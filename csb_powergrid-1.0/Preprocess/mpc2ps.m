function [ps, busdata] = mpc2ps( mpc, busdata )
%mpc2ps Converts from MatPower's mpc format to our PowerSystem format.
% This is version 2, modified for structure preserving model.
% Additional busdata will be relabeled along the conversion from external
% to internal indexing.

% ps is a format similar to mpc, but the following processing takes place:
% - bus admittance matrix is used instead of branch data.
% - "internal indexing" of Matpower is created on buses, meaning sequential 
%   indices from 1 to length(). 
% - offline generators are removed
% - generators without dynamical data will have estimated dynamical parameters
% - bus types (PV, PQ, REF) are retained (pflow only)

%% find a powerflow solution
mopt = mpoption( ...
    'OUT_ALL', 0, ...
    'VERBOSE', 0, ...
    'PF_DC', 0, ...
    'OUT_SYS_SUM', 0, ...
    'OUT_BUS', 0, 'OUT_BRANCH', 0);

mopt.pf.enforce_q_lims = 1;

bustypes = mpc.bus(:,2); %record the original bus types (may change because q limit forcing)

mpc = runpf(mpc, mopt);
if ~mpc.success
    error('Powerflow failed on initial network\n');    
end

mpc.bus(:,2) = bustypes; % restore bus types! keep it consistent with the original.

%% make sure we have mpc_dyn and bus_dyn. If not, fill in with defaults
mpc = ensure_mpc_dyn(mpc);

%% convert to internal indexing
mpc = ext2int(mpc);
mpc = e2i_field(mpc, 'gen_dyn', 'gen');
mpc = e2i_field(mpc, 'bus_dyn', 'bus');

if isfield(mpc, 'busExtra')
    mpc = e2i_field(mpc, {'busExtra', 'Latitude'}, 'bus');
    mpc = e2i_field(mpc, {'busExtra', 'Longitude'}, 'bus');
end

if (nargin > 1)
    busdata = e2i_data(mpc, busdata, 'bus');
end

%% remove offline generators
on = mpc.gen(:,8) == 1;
mpc.gen = mpc.gen(on,:);
mpc.gen_dyn = mpc.gen_dyn(on,:);

%% build ps.gen and ps.dyn: keep original machine data!
ps.gen = mpc.gen;
ps.gen_dyn = mpc.gen_dyn;
%ps.bus_dyn = mpc.bus_dyn;

%% merge multiple generators on the same bus
genbus = unique(ps.gen(:,1));

for i = 1 : length(genbus)
    bus = genbus(i);
    gens = ps.gen(:,1) == bus;  %generators on this given bus
    if sum(gens) > 1

        %find row indices of the generators
        nz = find(gens);
        nz1 = nz(1);        
        
        %new dynamical parameters
        Xd = imag(1 / sum(1 / (1j * ps.gen_dyn(gens, 1)))); %parallel connection
        H = sum(ps.gen_dyn(gens, 2));
        D = sum(ps.gen_dyn(gens, 3));
        newdyn = [Xd H D];
        
        %new generator parameters
        Pg = sum(ps.gen(gens, 2));
        Qg = sum(ps.gen(gens, 3));
        newgen = [ bus, Pg, Qg, sum(ps.gen(gens, 4)), sum(ps.gen(gens, 5)), ps.gen(nz1,6), ...
            100, 1, sum(ps.gen(gens, 9)), sum(ps.gen(gens, 10)), zeros(1, size(ps.gen, 2)-10)];        

        %override the first one with the merged one
        ps.gen_dyn(nz1,:) = newdyn;
        ps.gen(nz1,:) = newgen;
        
        %remove others
        gens(nz1) = false; %mark first one to keep
        keep = ~gens;
        ps.gen_dyn = ps.gen_dyn(keep,:);
        ps.gen = ps.gen(keep,:);
    end
end

%% compose the rest of ps data
ps.bus = mpc.bus;
ps.baseMVA = mpc.baseMVA;
ps.Y = makeYbus(mpc);

% given or default reference frequency
if isfield(mpc, 'ref_freq')
    ps.ref_freq = mpc.ref_freq;
else
    ps.ref_freq = 60;
end

% for US datasets: write better area number from extra bus data
if isfield(mpc, 'busExtra')
    areas = unique(mpc.busExtra.AreaNum);
    for i=1:length(areas)
        areaSelect = mpc.busExtra.AreaNum == areas(i);
        ps.bus(areaSelect, 7) = i;
    end
end

% final check: ps powerflow must work too
[~,success] = runpf_ps(ps);
if ~success
    error('Powerflow failed on final network\n');
end

end

