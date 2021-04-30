%Here is the main part for several bus condition
%Note that we should first noramlize 
%
%Assumption 1: the voltage of all generator to be 1
%mpc.gen(:,6) = 1 

mpc = case9;
mpc.gen(:,6) = 1;
%mpc.branch(:,5) = 0;
%mpc.gen(:,[4,5,9,10]) = 0;

format long
Binary_exact_lambda(mpc,5)
Binary_Predict_lambda(mpc,5)

Binary_exact_lambda(mpc,7)
Binary_Predict_lambda(mpc,7)

Binary_exact_lambda(mpc,9)
Binary_Predict_lambda(mpc,9)
