function [Mag_pre] = Predict_Three_Node_1
%This part calculate the exact magnitude for two node situation
%Here the node 1 is the generator bus
%Here the node 2 is the load bus
%Suppose the power of load bus is S_load = mag + mag * j
%Note that here S_i indicate the output power
%Thus the load bus are negetive and generator bus are positive
index_gen = 1;
index_load = 3;

iter = 1000;
mag_bound = 0;
mpc = case3;
Y = Form_YBUS(mpc);
Y(index_load,index_gen) = 1;
Y(index_gen,index_load) = 1;
Y(index_load,index_load) = 1;
Y(index_gen,index_gen) = 1;

for loop = 1 : iter
    mag = loop / iter;
    S_load = - mag - mag * j;
    %This equation is for load bus
    Pro_1 = sqrt(abs(Y(index_load,index_load).^2) ...
        / (abs(S_load) * abs(Y(index_load,index_load)) ...
        - real(S_load * Y(index_load,index_load))));
    Pro_2 = abs(Y(index_load,index_gen) * mpc.gen(1,6) ...
        / Y(index_load,index_load));
    if Pro_1 * Pro_2 > sqrt(2)
        mag_bound = mag;
    end
end
Mag_pre = mag_bound;
end