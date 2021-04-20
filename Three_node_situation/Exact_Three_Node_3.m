function [Mag_exact] = Exact_Three_Node_3
%This part calculate the exact magnitude for two node situation
%Here the node 1 is the generator bus
%Here the node 2 is the load bus
%Here the node 3 is the load bus
%Suppose the power of load bus is S_load = mag + mag * j


index_load = 2;
iter = 1000;
mag_bound = 0;
mpopt = mpoption;
mpopt = mpoption(mpopt,'PF_DC',0,'OUT_ALL',0,'VERBOSE',0);

for loop = 1 : iter
    mag = loop / iter;
    mpc = case2;
    mpc.bus(index_load , 3) = mag;
    mpc.bus(index_load , 4) = mag;
    results = runpf(mpc,mpopt);
    if results.success == 1
        mag_bound = mag;
    end
end

Mag_exact = mag_bound;
end