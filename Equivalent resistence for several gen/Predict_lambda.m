function [Up] = Predict_lambda(mpc,node)
%This part could only solve with one generator
%Waiting for further upgrade

iter = 1000;
upper = 100;
index_gen = 1;
Up = 0;
for loop = 1 : iter
    lambda = loop / iter * upper;
    mpc_mul = Multi_mpc(mpc,node,lambda);
    Y_ii = Equivalent(index_gen,node,mpc_mul);
    S_load = (-mpc_mul.bus(node,3) - mpc_mul.bus(node,4) * j) ...
        / mpc_mul.baseMVA;
    %This equation is for load bus
    Pro_1 = sqrt(abs(Y_ii^2) ...
        / (abs(S_load) * abs(Y_ii) ...
        - real(S_load * Y_ii)));
    Pro_2 = abs(Y_ii * mpc.gen(index_gen,6) ...
        / Y_ii);
    if Pro_1 * Pro_2 > sqrt(2)
        Up = lambda;
    end
end
end