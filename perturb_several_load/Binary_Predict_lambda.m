function [result] = Binary_Predict_lambda(mpc,node)
%_________________________________________________________________________
%This part based on Binary search to search with expand lambda times of
%node demand.
%Use Binary_Predict_lambda(case9,5) to start
%_________________________________________________________________________
iter = 50;
upper = 1000; 
lower = 0;
for loop = 1 : iter
    test = (upper + lower) / 2;
    mpc_mul = Multi_mpc(mpc,node,test);
    %mpc_mul indicates the mpc after multiplication
    results = Predict(mpc_mul,node);
    if results == 1
        lower = test;
    else 
        upper = test;
    end
end
result = (upper + lower) / 2;
end
