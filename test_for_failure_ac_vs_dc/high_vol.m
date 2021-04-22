function [mpc_load] = high_vol(mpc)

mpc_load = mpc;

%part 1
num_for_load = length(mpc.bus(:,1));
for loop = 1 : num_for_load
    mpc_load.bus(loop,3) = 0;
end

%part 2
num_for_gen = length(mpc.gen(:,1));

for loop = 1 : num_for_gen
    mpc_load.gen(loop,2) = 0;
end

end