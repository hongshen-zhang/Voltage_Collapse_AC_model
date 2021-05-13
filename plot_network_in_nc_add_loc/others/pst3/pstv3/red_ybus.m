function [Y11,Y12,Y21,Y22,rec_V1,rec_V2,bus_order] =...
                          red_ybus(bus_sol,line)
% Syntax:  [red_Y,rec_V] = red_ybus(bus_sol,line)                                     
%          [Y11,Y12,Y21,Y22,rec_V1,rec_V2,bus_order] =...
%                          red_ybus(bus_sol,line)
% 10:22 am January 29, 1999
% Purpose: form the reduced admittance matrix
%
% Input:    bus_sol   - bus solution (generated by loadflow)
%           line      - line data
%
% Output:   red_Y     - reduced admittance matrix
%           rec_V     - voltage reconstruction matrix
%           Y11,Y12,Y21,Y22 - reduced admittance matrix for
%                         systems with non-conforming loads
%           rec_V1, rec_V2 - voltage reconstruction bus
%           bus_order - vector of bus number for recovering
%                       bus voltages
% See also: pst_var, loadflow, ybus
%
% Calls: ysparse
%
% Called By: s_simu, svm_mgen 

% (c) Copyright 1991-1996 Joe H. Chow - All Rights Reserved
%
% History (in reverse chronological order)
% correction to dc
% Version:      2.3
% Modification: Add induction generators
% Date:         August 1997

% Author:       Graham Rogers
% Version:      2.2
% Modification: add dc model
% Date:         March 1997
% Author:       Graham Rogers

% Version:      2.1
% Modification: add capability to have more than one generator or 
%               induction motor on a single bus
%               modification of non conforming load section to
%               allow call with single driver
% Date:         November 1996
% Author:       Graham Rogers       
% Version       2.0
% Modification: remove loops
%               add induction motors
% Author:       Graham Rogers
% Date:         July 1995
% Version:   1.0
% Author:    Kwok W. Cheung, Joe H. Chow
% Date:      March 1991
% 
% ***********************************************************

global basmva bus_int mac_int ind_int igen_int

global mac_con ind_con ind_pot load_con igen_con igen_pot 

global  dcc_pot n_conv n_dcl ldc_idx ac_bus r_idx i_idx


jay = sqrt(-1);
swing_bus = 1;
gen_bus = 2;
load_bus = 3;

nline = length(line(:,1));     % number of lines
nbus = length(bus_sol(:,1));     % number of buses
[n,dummy] = size(mac_con);    % number of generators
[nmot,dummy]=size(ind_con);	% number of induction motors
[nig,dummy] = size(igen_con); % number of induction generators
n_tot=n+nmot+nig;			% total number of machines
ngm = n + nmot; % number of generators + induction motors
xd=zeros(n,1);
% build sparse admittance matrix Y
Y_d = y_sparse(bus_sol,line); % bus admittance matrix construction
V = bus_sol(:,2);      % magnitude of terminal voltage
% Compute constant impedance component of non-conforming loads
if nargout > 2 %checking number of output arguments
% non-conforming load ajustments
% subtract non-conforming loads from bus P and Q loads
  [nload dum] = size(load_con);
  if nload~=0
    j = bus_int(load_con(:,1));
    bus_sol(j,6) = (ones(nload,1)-load_con(:,2)-load_con(:,4)) ...
                   .*bus_sol(j,6);
    bus_sol(j,7) = (ones(nload,1)-load_con(:,3)-load_con(:,5))...
                   .*bus_sol(j,7);
    if n_conv ~=0
      % remove dc loads from LT bus
      bus_sol(ac_bus,6) = zeros(n_conv,1);
      bus_sol(ac_bus,7) = zeros(n_conv,1);
    end
  end
end

%  Add load components to Y matrix
Pl = bus_sol(:,6);     % real power of loads
Ql = bus_sol(:,7);     % reactive power of loads

%  Modify load component to take into account generation

%  buses with no generator data
gen_exist = zeros(max(bus_sol(:,1)),1);
gen_exist(round(mac_con(1:n,2))) = 1:n;
netgen= find(gen_exist(round(bus_sol(:,1))) < 1);% index of buses with no dynamic gen data
Pl(netgen) = Pl(netgen) - bus_sol(netgen,4);  % convert generation 
Ql(netgen) = Ql(netgen) - bus_sol(netgen,5);  %   to negative load

% form constant impedance load admittance for all buses
yl = (Pl - jay*Ql)./V.^2;
ii = [1:1:nbus]';
y1 = sparse(ii,ii,yl,nbus,nbus);
Y_d = Y_d + y1; %add to system y matrix

%initialize matrix for machine internal admittances
iin = [1:1:n_tot]';
Y_b = sparse(1,1,0,n_tot,nbus); 

% extract appropriate xdprime and xdpprime from machine
%   data
ra=mac_con(:,5)*basmva./mac_con(:,3);
testxpp= mac_con(:,8) ~= zeros(n,1);
testxp = ~testxpp;  
txpp=find(testxpp);
txp=find(testxp);
if ~isempty(txpp)
   xd(txpp,1) = mac_con(txpp,8)*basmva./mac_con(txpp,3); %xppd 
end
if ~isempty(txp)
   xd(txp,1) = mac_con(txp,7)*basmva./mac_con(txp,3); %xpd
end 
y(1:n,1) = ones(n,1)./(ra+jay*xd); 
   
jg = bus_int(round(mac_con(:,2)));  % buses connected to
                                      % generator

% check for multiple generators at a bus
perm = eye(n);
for k = 1:n
  mg_idx = find(jg  == jg(k));
  lmg = length(mg_idx);
  if lmg>1
    %set 2nd or higher occurences to zero
    jg(mg_idx(2:lmg)) = zeros(lmg-1,1);
    perm(k,mg_idx) = ones(1,lmg);
  end
end

% remove zero elements from jg
jgz_idx = find(jg==0);
jg(jgz_idx) = [];

% remove zero rows from permutaion matrix
perm(jgz_idx,:) = [];

Ymod = (diag(y))*perm';
Y_b(1:n,jg) = - Ymod ;
Y_d = full(Y_d);
Y_d(jg,jg) = Y_d(jg,jg) + perm*Ymod;
Y_d = sparse(Y_d);

% extract appropriate xsp from induction motor 
%   data
motmax=0;
if length(ind_con)~=0
      xsp = ind_pot(:,5).*ind_pot(:,1);
      rs=ind_con(:,4).*ind_pot(:,1);
      y(n+1:ngm,1) = ones(nmot,1)./(rs+jay*xsp);     
      jm = bus_int(round(ind_con(:,2)));  % bus connected to induction motor
        % check for multiple induction motors at a bus
       perm = eye(nmot);
       for k = 1:nmot
         mm_idx = find(jm  == jm(k));
         lmm = length(mm_idx);
         if lmm>1
         %set 2nd or higher occurences to zero
           jm(mm_idx(2:lmm)) = zeros(lmm-1,1);
           perm(k,mm_idx) = ones(1,lmm);
         end
       end
       % remove zero elements from jm
       jmz_idx = find(jm==0);
       jm(jmz_idx) = [];
       % remove zero rows from permutaion matrix
       perm(jmz_idx,:) = [];
       Ymmod = diag(y(n+1:ngm,1))*perm';
       Y_b(n+1:ngm,jm) = -Ymmod;
       Y_d(jm,jm) = Y_d(jm,jm) + perm*Ymmod;
       motmax= max(ind_con(:,1));
end

% extract appropriate xsp from induction generator 
% data
igmax=0;
if nig~=0
      xsp = igen_pot(:,5).*igen_pot(:,1);
      rs=igen_con(:,4).*igen_pot(:,1);
      y(ngm+1:n_tot,1) = ones(nig,1)./(rs+jay*xsp);     
      jm = bus_int(round(igen_con(:,2)));  % bus connected to induction generator
        % check for multiple induction generators at a bus
       perm = eye(nig);
       for k = 1:nig
         mm_idx = find(jm  == jm(k));
         lmm = length(mm_idx);
         if lmm>1
         %set 2nd or higher occurences to zero
           jm(mm_idx(2:lmm)) = zeros(lmm-1,1);
           perm(k,mm_idx) = ones(1,lmm);
         end
       end
       % remove zero elements from jm
       jmz_idx = find(jm==0);
       jm(jmz_idx) = [];
       % remove zero rows from permutaion matrix
       perm(jmz_idx,:) = [];
       Ymmod = diag(y(ngm+1:n_tot,1))*perm';
       Y_b(ngm+1:n_tot,jm) = -Ymmod;
       Y_d(jm,jm) = Y_d(jm,jm) + perm*Ymmod;
       igmax= max(igen_con(:,1));
end

Y_a = sparse(iin,iin,y,n_tot,n_tot);
Y_c = Y_b.'; % .' is ordinary transpose
% form the reduced admittance matrix
if nargout <= 2
    Y12 = -Y_d\Y_c;
    Y11 = full(Y_a + Y_b*Y12);
    Y12 = full(Y12); %rec_V
  else 
    if nload~=0
    % non-conforming load Y matrix reduction
    % make vector with non-conforming load buses first
    % Note dc buses must be the last entries in load_con
      bus_order = zeros(nbus,1);
      bus_conf = zeros(nbus,1);
      bus_order(1:nload) = bus_int(load_con(:,1));
      bus_conf(bus_order(1:nload))=ones(nload,1); % constant impedance bus
                                                % indicator                                                                                    
      bus_order(nload+1:nbus)=find(~bus_conf);
      % make permutation matrix
      P = sparse(1,1,0,nbus,nbus);
      P(1:nbus,bus_order)=eye(nbus);

      % apply permutation matrix to Y matrix
      % this puts the nonconforming buses in the first
      % nload by nload block of Y
      Y_b = Y_b*P'; Y_c = P*Y_c; Y_d = P*Y_d*P';  
      % Im = Y_a E_m + Y_b Vb
      % 0  = Y_c E_m + Y_d Vb
      % partition Y matrices
      Y_b1 = Y_b(:,1:nload); Y_b2 = Y_b(:,nload+1:nbus);
      Y_c1 = Y_c(1:nload,:); Y_c2 = Y_c(nload+1:nbus,:);
      Y_d1 = Y_d(1:nload,:); Y_d2 = Y_d(nload+1:nbus,:);
      Y_d11 = Y_d1(:,1:nload); Y_d12 = Y_d1(:,nload+1:nbus);
      Y_d21 = Y_d2(:,1:nload); Y_d22 = Y_d2(:,nload+1:nbus);
      %
      %yinv = inv(Y_d22);
      %rec_V1 = -yinv*Y_c2; rec_V2 = -yinv*Y_d21;
      rec_V2 = -Y_d22\[Y_c2 Y_d21];
      rec_V1 = rec_V2(:,1:n_tot); rec_V2 = rec_V2(:,n_tot+1:n_tot+nload);
      Y11 = full(Y_a + Y_b2*rec_V1); 
      Y12 = full(Y_b1 + Y_b2*rec_V2);
      Y21 = full(Y_c1 + Y_d12*rec_V1);
      Y22 = full(Y_d11 + Y_d12*rec_V2);
      if n_conv~=0
         % modify so that the HV dc voltage replaces the LT dc voltage
         x_dc(r_idx) = dcc_pot(:,2); x_dc(i_idx) = dcc_pot(:,4);
         % note that the dc lt buses are  after the non-conforming load buses
         n_start = nload-n_conv+1;
         if n_start>1
           n_fin = n_start -1;%end of non-dc non-conforming loads
           y33 = Y22(n_start:nload,n_start:nload);
           y31 = Y21(n_start:nload,:);
           y32 = Y22(n_start:nload,1:n_fin);
           y21 = Y21(1:n_fin,:);
           y22 = Y22(1:n_fin,1:n_fin);
           y23 = Y22(1:n_fin,n_start:nload);
           y11 = Y11;
           y12 = Y12(:,1:n_fin);
           y13 = Y12(:,n_start:nload);
           vr1 = rec_V1;
           vr2 = rec_V2(:,1:n_fin);
           vr3 = rec_V2(:,n_start:nload);
           
           % make modifications
           kdc = eye(n_conv) - jay*y33*diag(x_dc);
           kdc = inv(kdc);
           y31 = kdc*y31;
           y32 = kdc*y32;
           y33 = kdc*y33;
           
           y11 = y11 + jay*y13*diag(x_dc)*y31;
           y12 = y12 + jay*y13*diag(x_dc)*y32;
           y13 = y13 + jay*y13*diag(x_dc)*y33;
           y21 = y21 + jay*y23*diag(x_dc)*y31;
           y22 = y22 + jay*y23*diag(x_dc)*y32;
           y23 = y23 + jay*y23*diag(x_dc)*y33;
           vr1 = vr1 + jay*vr3*diag(x_dc)*y31;
           vr2 = vr2 + jay*vr3*diag(x_dc)*y32;
           vr3 = vr3 + jay*vr3*diag(x_dc)*y33;
           
           Y11 = y11;
           Y12(:,1:n_fin) = y12;
           Y12(:,n_start:nload) = y13;
           Y21(1:n_fin,:) = y21;
           Y22(1:n_fin,1:n_fin) = y22;
           Y22(1:n_fin,n_start:nload)= y23;
           Y21(n_start:nload,:) = y31;
           Y22(n_start:nload,1:n_fin) = y32;
           Y22(n_start:nload,n_start:nload) = y33;
           rec_V1 = vr1;
           rec_V2(:, 1:n_fin) = vr2;
           rec_V2(:,n_start:nload) = vr3;
         else
           % dc buses only
           y22 = Y22;
           y12 = Y12;
           y11 = Y11;
           y21 = Y21;
           vr1 = rec_V1;
           vr2 = rec_V2;
           kdc = eye(n_conv) - jay*y22*diag(x_dc);
           kdc = inv(kdc);
           y21 = kdc*y21;
           y22 = kdc*y22;
           y11 = y11 + jay*y12*diag(x_dc)*y21;
           y12 = y12 + jay*y12*diag(x_dc)*y22;
           vr1 = vr1 + jay*vr2*diag(x_dc)*y21;
           vr2 = vr2 + jay*vr2*diag(x_dc)*y22;
           Y11 = y11;
           Y12 = y12;
           Y21 = y21;
           Y22 = y22;
           rec_V1 = vr1;
           rec_V2 = vr2; 
         end
      end
    else
      Y12 = -Y_d\Y_c;
      Y11 = full(Y_a + Y_b*Y12);
      Y12 = full(Y12); %rec_V
      rec_V1 = Y12;
      Y12 = [];
      Y21 = [];
      Y22 = [];
      rec_V2 = [];
      bus_order = bus_int(bus_sol(:,1));
    end
end

return