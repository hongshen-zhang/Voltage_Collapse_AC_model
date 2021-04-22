function [mpc_mul] = multi_one_node(mpc,node_index,lambda)
mpc_mul = mpc;
mpc_mul.bus(node_index,3) = abs(mpc_mul.bus(node_index,3) * lambda);
mpc_mul.bus(node_index,4) = abs(mpc_mul.bus(node_index,4) * lambda);
end