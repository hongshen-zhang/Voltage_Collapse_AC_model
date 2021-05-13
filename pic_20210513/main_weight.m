warning('off')

mpc = case30;

bus_num = length(mpc.bus(:,1));
branch_num = length(mpc.branch(:,1));

dis = floyd_dis_weight(mpc);
result = zeros(branch_num,bus_num);

for node = 1 : bus_num
    for branch = 1 : branch_num
        result(branch,node) = weight_dis(mpc,dis,branch,node);
    end
end

result