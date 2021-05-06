%Here is the main part for several bus condition
%Note that we should first noramlize 
%
%Assumption 1: 
%the voltage of all generator(include PV bus and V\theta bus) to be 1
%code : mpc.gen(:,6) = 1 

warning('off');
format long
mpc = case3_zhs;
mpc.gen(:,6) = 1;

%Assumption 2: 
%The real power of the generator bus(PV bus) is fitted
%Here is one example that illustrate the importance of Assumption 2
node_resis = [100,50,10,5,1,0.5,0.1];
for loop = 1 : length(node_resis)
    node_resis(loop)
end

mpc.branch(2,3) = 100;
mpc.branch(2,4) = 100;
exact_100 = Binary_exact_lambda(mpc,3)
predict_100 = Binary_Predict_lambda(mpc,3)
delta_100 = abs(exact_1 - predict_1) / exact_1

mpc.branch(2,3) = 50;
mpc.branch(2,4) = 50;
exact_50 = Binary_exact_lambda(mpc,3)
predict_50 = Binary_Predict_lambda(mpc,3)
delta_50 = abs(exact_50 - predict_50) / exact_1

mpc.branch(2,3) = 10;
mpc.branch(2,4) = 10;
exact_10 = Binary_exact_lambda(mpc,3)
predict_10 = Binary_Predict_lambda(mpc,3)
delta_10 = abs(exact_1 - predict_1) / exact_1

mpc.branch(2,3) = 2;
mpc.branch(2,4) = 2;
exact_1 = Binary_exact_lambda(mpc,3)
predict_1 = Binary_Predict_lambda(mpc,3)
delta_1 = abs(exact_1 - predict_1) / exact_1


