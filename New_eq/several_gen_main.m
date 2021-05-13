%Here is the main part for several bus condition
%Note that we should first noramlize 
%
%Assumption 1: the voltage of all generator to be 1
%mpc.gen(:,6) = 1 
warning('off');
mpc = case3_zhs;
mpc.gen(:,6) = 1;
%mpc.branch(:,5) = 0;
%mpc.gen(:,[4,5,9,10]) = 0;

format long
exact_1 = Binary_exact_lambda(mpc,3)
predict_1 = Binary_Predict_lambda(mpc,3)
delta_1 = abs(exact_1 - predict_1) / exact_1 

%exact_2 = Binary_exact_lambda(mpc,7)
%predict_2 = Binary_Predict_lambda(mpc,7)
%delta_2 = abs(exact_2 - predict_2) / exact_2

%exact_3 = Binary_exact_lambda(mpc,9)
%predict_3 = Binary_Predict_lambda(mpc,9)
%delta_3 = abs(exact_3 - predict_3) / exact_3

