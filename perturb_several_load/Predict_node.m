function [success] = Predict_node(mpc,node)
%This part could only is solved for several generators
%It returns 0 for failure and 1 for success
%Use the formula(49) in gao_si to check
%Based on Eq_resistence
Y_eq = [];
%del = [];
%sum_x = 0;
%sum_y = 0;
%for loop = 1 : length(mpc.bus(:,1))
%    if mpc.bus(loop,2) == 1
%        sum_x = sum_x + mpc.bus(loop,3);
%        sum_y = sum_y + mpc.bus(loop,4);
%    end
%end
%sum_x = sum_x - mpc.bus(node,3);
%sum_y = sum_y - mpc.bus(node,4);

sum_x = 0;
sum_y = 0;

%Consider the impact of total line charging susceptance
%sum_sus = sum(mpc.branch(:,5)) / 2;
sum_sus = 0;

num_gen = length(mpc.gen(:,1));
gen_list = mpc.gen(:,1);
for loop = 1 : num_gen
    mpc_final = finetune_mpc(mpc);
    Y_eq(loop) = Eq_resistence(node,gen_list(loop),mpc_final);
end

Y_ii = sum(Y_eq) + sum_sus * j;

Y_ij = sum(Y_eq);
S_load = (-(mpc.bus(node,3) + sum_x) - (mpc.bus(node,4) + sum_y) * j) ...
    / mpc.baseMVA;
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
