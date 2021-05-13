function [num,lambda] = lambda_after_del(mpc,dis,del_branch_index,node_index)
%return num indicates the 'ÌøÊý'
%return lambda indicates the resilience after delete the branch_index
node_1 = mpc.branch(del_branch_index,1);
node_2 = mpc.branch(del_branch_index,2);
num = min(dis(node_index,node_1),dis(node_index,node_2)) + 1;

mpc.branch(del_branch_index,:) = [];
lambda = Binary_exact_lambda(mpc,node_index);

end