function [dis] = floyd_dis(mpc)
%Initialize
bus_num = length(mpc.bus(:,1));
dis = zeros(bus_num);
dis = dis + 9999;
for loop = 1 : bus_num
    dis(loop,loop) = 0;
end

%Initialize the distance with length 1
branch_num = length(mpc.branch(:,1));
for loop = 1 : branch_num
    index_1 = mpc.branch(loop,1);
    index_2 = mpc.branch(loop,2);
    dis(index_1,index_2) = 1;
    dis(index_2,index_1) = 1;
end

%Floyd
for loop_i = 1 : bus_num
    for loop_j = 1 : bus_num
        for loop_k = 1 : bus_num
            if dis(loop_i,loop_j) + dis(loop_j,loop_k) < dis(loop_i,loop_k)
                dis(loop_i,loop_k) = dis(loop_i,loop_j) + dis(loop_j,loop_k);
            end
        end
    end
end

end