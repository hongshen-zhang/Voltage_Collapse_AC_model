%main for case2

mpc = case2;
mpc.gen(:,6) = 1;
%mpc.branch(:,5) = 0;
%mpc.gen(:,[4,5,9,10]) = 0;

format long
exact_1 = Binary_exact_lambda(mpc,2)
predict_1 = Binary_Predict_lambda(mpc,2)
delta_1 = abs(exact_1 - predict_1) / exact_1 
