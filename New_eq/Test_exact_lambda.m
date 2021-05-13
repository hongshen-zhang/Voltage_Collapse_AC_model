function [Up] = Test_exact_lambda(mpc,node)
iter = 10000;
upper = 100;
mpopt = mpoption;
mpopt = mpoption(mpopt,'PF_DC',0,'OUT_ALL',0,'VERBOSE',0);

for loop = 1 : iter
    lambda = loop / iter * upper;
    mpc_mul = Multi_mpc(mpc,node,lambda);
    results = runpf(mpc_mul,mpopt);
    if results.success == 1
        Up = lambda;
    end
end
end