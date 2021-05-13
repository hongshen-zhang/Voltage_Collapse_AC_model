function [result_dis] = weight_dis(mpc,dis,branch_index,node_index)
%return result_dis indicates the 'º”»®æ‡¿Î'
node_1 = mpc.branch(branch_index,1);
node_2 = mpc.branch(branch_index,2);

resistence = (mpc.branch(branch_index,3).^2 + mpc.branch(branch_index,4).^2)^(0.5);


result = min(dis(node_index,node_1),dis(node_index,node_2)) + resistence;

result_dis = 1 / result;

end