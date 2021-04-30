function [mpc_final] = finetune_mpc(change_mpc)
mpc_final = change_mpc;
mpc_final.branch(:,5) = 0;
%baseKV
%mpc_final.bus(:,10) = 0;
%Vmax
%mpc_final.bus(:,12) = 0;
%mpc_final.gen(:,2) = 0;
%mpc_final.gen(:,3) = 0;

%rateA,rateB,rateC
%mpc_final.branch(:,[6,7,8,9,10]) = 0;
end