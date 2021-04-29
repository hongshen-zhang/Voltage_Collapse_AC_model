function [result] = Binary_Predict_lambda(mpc,node)
%_________________________________________________________________________
%This part based on Binary search to search with expand lambda times of
%node demand.
%Use Binary_Predict_lambda(case9,5) to start
%_________________________________________________________________________
iter = 50;
upper = 1000; 
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
