function [result] = Binary_Predict_lambda(mpc,node)
%This part could only solve with one generator
iter = 50;
upper = 1000;
lower = 0;
for loop = 1 : iter
    test = (upper + lower) / 2;
    mpc_mul = Multi_mpc(mpc,node,test);
    results = Predict_for_node(mpc_mul,node);
    if results == 1
        lower = test;
    else 
        upper = test;
    end
end
result = (upper + lower) / 2;
end
