function [result] = Binary_exact_lambda(mpc,node)
%__________________________________________________________________________
%This part test the exact lambda for casename = mpc and node_index = node
%Use Binary_exact_lambda(case9,5) to start
%__________________________________________________________________________

iter = 20;
upper = 1000;
lower = 0;
mpopt = mpoption;
mpopt = mpoption(mpopt,'PF_DC',0,'OUT_ALL',0,'VERBOSE',0);

for loop = 1 : iter
    test = (upper + lower) / 2;
    mpc_mul = Multi_mpc(mpc,node,test);
    
    results = runpf(mpc_mul,mpopt);
    if results.success == 1
        lower = test;
    else 
        upper = test;
    end
end
result = (upper + lower) / 2;
end