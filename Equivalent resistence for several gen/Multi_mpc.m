function [mpc_mul] = Multi_mpc(mpc,node,lambda)
%Multi_mpc is multiply mpc the demand of node by lambda
%lambda = 1 is meaningless

mpc_mul = mpc;
mpc_mul.gen(:,6) = 1;
mpc_mul.bus(node,3) = mpc.bus(node,3) * lambda;
mpc_mul.bus(node,4) = mpc.bus(node,4) * lambda;

end