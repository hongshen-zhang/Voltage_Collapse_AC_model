%-----------------------------------------------------------------
%Author: zhanghongshen
%Data: 20210507
%Main of oats to matpower
%The code here is used for transfer the oats data to matpower data
%Here is especially for the GB_ReducedNetwork 
%-----------------------------------------------------------------
clear all
clear
filename = 'GB_ReducedNetwork.xlsx';

%-----------------------------------------------------------------
%bus part start
[oats_bus,~,~] = xlsread(filename,1);
%name,baseKV,type,zone,VM,VA,VNLB,VNUB,VELB,VEUB
bus_search = [1,3,4,5,6,7,8,9,10,11];
bus_num = length(oats_bus(:,bus_search(1)));
bus_index = 1:1:bus_num;
get_index = [];
for loop = 1 : bus_num
    get_index(oats_bus(loop,bus_search(1))) = loop;
end

baseKV = oats_bus(:,bus_search(2));
type = oats_bus(:,bus_search(3));
zone = oats_bus(:,bus_search(4));
Vm = oats_bus(:,bus_search(5));
Va = oats_bus(:,bus_search(6));
Vmin = oats_bus(:,bus_search(9));
Vmax = oats_bus(:,bus_search(10));
%bus part end
%-----------------------------------------------------------------

%-----------------------------------------------------------------
%demand part start
[oats_demand,~,~] = xlsread(filename,2);
%busname,real,reactive
demand_search = [1,2,3];
Pd = zeros(bus_num,1);
Qd = zeros(bus_num,1);
demand_num = length(oats_demand(:,demand_search(1)));
for loop = 1 : demand_num
    node_index = get_index(oats_demand(loop,demand_search(1)));
    %Here choose the first demand as the demand of the index
    if (Pd(node_index) + Qd(node_index) == 0)
        Pd(node_index) = oats_demand(loop,demand_search(2));
        Qd(node_index) = oats_demand(loop,demand_search(3));
    end
end
%demand part end
%-----------------------------------------------------------------

%-----------------------------------------------------------------
% branch part start
[oats_branch,~,~] = xlsread(filename,3);
% from_node,to_node,r,x,b,rateC,rateAB,angLB,angUB
branch_search = [1,2,4,5,6,7,8,9,10];
% Here useful = 33 indicates that satisfy the problem
% Take useful = 9999 indicates all branch are useful
useful = 9999;
branch_num = length(oats_branch(:,branch_search(1)));
count_branch = 0;
fbus = [];
tbus = [];
r = [];
x = [];
b = [];
rateA = [];
rateB = [];
rateC = [];
ratio = [];
angle = [];
status = [];
angmin = [];
angmax = [];

for loop = 1 : branch_num
    count_branch = count_branch + 1;
    node_1 = get_index(oats_branch(loop,branch_search(1)));
    node_2 = get_index(oats_branch(loop,branch_search(2)));
    fbus(count_branch) = node_1;
    tbus(count_branch) = node_2;
    r(count_branch) = oats_branch(loop,branch_search(3));
    x(count_branch) = oats_branch(loop,branch_search(4));
    b(count_branch) = oats_branch(loop,branch_search(5));
    rateA(count_branch) = oats_branch(loop,branch_search(7));
    rateB(count_branch) = oats_branch(loop,branch_search(7));
    rateC(count_branch) = oats_branch(loop,branch_search(6));
    ratio(count_branch) = 0;
    angle(count_branch) = 0;
    if loop <= useful
        status(count_branch) = 1;
    else
        status(count_branch) = 0;
    end
    angmin(count_branch) = oats_branch(loop,branch_search(8));
    angmax(count_branch) = oats_branch(loop,branch_search(9));
end
% branch part end
%-----------------------------------------------------------------

%-----------------------------------------------------------------
% transformer part start
[oats_transformer,~,~] = xlsread(filename,4);
% from_node,to_node,stat,r,x,b,rateC,rateAB,angmin,angmax,ratio
transformer_search = [1,2,4,5,6,7,8,9,10,11,13];
transformer_num = length(oats_transformer(:,transformer_search(1)));
for loop = 1 : transformer_num
    count_branch = count_branch + 1;
    node_1 = get_index(oats_transformer(loop,transformer_search(1)));
    node_2 = get_index(oats_transformer(loop,transformer_search(2)));
    fbus(count_branch) = node_1;
    tbus(count_branch) = node_2;
    status(count_branch) = oats_transformer(loop,transformer_search(3));
    r(count_branch) = oats_transformer(loop,transformer_search(4));
    x(count_branch) = oats_transformer(loop,transformer_search(5));
    b(count_branch) = oats_transformer(loop,transformer_search(6));
    rateA(count_branch) = oats_transformer(loop,transformer_search(8));
    rateB(count_branch) = oats_transformer(loop,transformer_search(8));
    rateC(count_branch) = oats_transformer(loop,transformer_search(7));
    angle(count_branch) = 0;
    angmin(count_branch) = oats_transformer(loop,transformer_search(9));
    angmax(count_branch) = oats_transformer(loop,transformer_search(10));
    ratio(count_branch) = oats_transformer(loop,transformer_search(11));;
end
% transformer part end
%-----------------------------------------------------------------

%-----------------------------------------------------------------
% shunt part start
[oats_shunt,~,~] = xlsread(filename,6);
%node_index,Gs,Bs,stat
shunt_search = [1,3,4,5];
Gs = zeros(bus_num,1);
Bs = zeros(bus_num,1);
shunt_num = length(oats_shunt(:,shunt_search(1)));
for loop = 1 : shunt_num
    node_index = get_index(oats_shunt(loop,shunt_search(1)));
    %Here choose the first demand as the demand of the index
    if (oats_shunt(loop,shunt_search(4)) == 1)
        if Gs(node_index) <= oats_shunt(loop,shunt_search(2))
            Gs(node_index) = oats_shunt(loop,shunt_search(2));
        end
        if Bs(node_index) <= oats_shunt(loop,shunt_search(3))
            Bs(node_index) = oats_shunt(loop,shunt_search(3));
        end
    end
end
% shunt part end
%-----------------------------------------------------------------


%-----------------------------------------------------------------
% baseMVA part start
[oats_baseMVA,~,~] = xlsread(filename,9);
baseMVA = oats_baseMVA(1,1);
% baseMVA part end
%-----------------------------------------------------------------


%-----------------------------------------------------------------
% generator part start
[oats_generator,~,~] = xlsread(filename,8);
%node_index,status,Pg,Qg,Pmin,Pmax,Qmin,Qmax,Vg
generator_search = [1,4,6,7,8,9,10,11,12];
count_generator = 0;
generator_num = length(oats_generator(:,generator_search(1)));
gen_bus = [];
gen_pg = [];
gen_qg = [];
gen_qmax = [];
gen_qmin = [];
gen_vg = [];
gen_mbase = [];
gen_status = [];
gen_pmax = [];
gen_pmin = [];
gen_pc1 = [];
gen_pc2 = [];
gen_qc1min = [];
gen_qc1max = [];
gen_qc2min = [];
gen_qc2max = [];
gen_ramp_agc = [];
gen_ramp_10 = [];
gen_ramp_30 = [];
gen_ramp_q = [];
gen_apf = [];
for loop = 1 : generator_num
    count_generator = count_generator + 1;
    node_index = get_index(oats_generator(loop,generator_search(1)));
    gen_bus(count_generator) = node_index;
    gen_pg(count_generator) = oats_generator(loop,generator_search(3));
    gen_qg(count_generator) = oats_generator(loop,generator_search(4));
    gen_qmax(count_generator) = oats_generator(loop,generator_search(8));
    gen_qmin(count_generator) = oats_generator(loop,generator_search(7));
    gen_vg(count_generator) = oats_generator(loop,generator_search(9));
    gen_mbase(count_generator) = baseMVA;
    gen_status(count_generator) = oats_generator(loop,generator_search(2));
    gen_pmax(count_generator) = oats_generator(loop,generator_search(6));
    gen_pmin(count_generator) = oats_generator(loop,generator_search(5));
    gen_pc1(count_generator) = 0;
    gen_pc2(count_generator) = 0;
    gen_qc1min(count_generator) = 0;
    gen_qc1max(count_generator) = 0;
    gen_qc2min(count_generator) = 0;
    gen_qc2max(count_generator) = 0;
    gen_ramp_agc(count_generator) = 0;
    gen_ramp_10(count_generator) = 0;
    gen_ramp_30(count_generator) = 0;
    gen_ramp_q(count_generator) = 0;
    gen_apf(count_generator) = 0;
end
% generator part end
%-----------------------------------------------------------------


%-----------------------------------------------------------------
% finishing results into mpc
mpc = case4gs;
mpc.baseMVA = baseMVA;
mpc.bus = [bus_index.',type,Pd,Qd,Gs,Bs,zone,Vm,Va,baseKV,zone,Vmax,Vmin];
mpc.gen = [gen_bus.',gen_pg.',gen_qg.',gen_qmax.',gen_qmin.',gen_vg.',...
    gen_mbase.',gen_status.',gen_pmax.',gen_pmin.',gen_pc1.',gen_pc2.',...
    gen_qc1min.',gen_qc1max.',gen_qc2min.',gen_qc2max.',gen_ramp_agc.',...
    gen_ramp_10.',gen_ramp_30.',gen_ramp_q.',gen_apf.'];
mpc.branch = [fbus.',tbus.',r.',x.',b.',rateA.',rateB.',rateC.',ratio.',...
    angle.',status.',angmin.',angmax.'];

runpf(mpc)

save('case_GB_reduced','mpc');