function [success] = Predict_set(mpc,node_set)
%This part could only is solved for several generators
%It returns 0 for failure and 1 for success
%Use the formula(49) in gao_si to check
%Based on Eq_resistence
gen_list = mpc.gen(:,1);
mpc_final = finetune_mpc(mpc);
Y_eq = Eq_resistence_set(gen_list,node_set,mpc_final);
Y_ii = Y_eq;
Y_ij = Y_ii;
S_load = 0;
for loop = 1 : length(node_set)
    S_load = S_load + ...
        ((-(mpc.bus(node_set(loop),3)) - (mpc.bus(node_set(loop),4)) * j))...
        / mpc.baseMVA;
end


%S_load
Pro_1 = sqrt(abs(Y_ii^2) ...
    / (abs(S_load) * abs(Y_ii) ...
    - real(S_load * Y_ii)));
Pro_2 = abs(Y_ij * 1 ...
    / Y_ii);
if Pro_1 * Pro_2 > sqrt(2)
    success = 1;
else
    success = 0;
end

end
