function consider_all_mpc(mpc)
%--------------------------------------------------------------------------
% Author: Zhang HongShen
% Date : 20210512
% Plot the points figure for demand 
%--------------------------------------------------------------------------

warning('off')

%[num,lambda] = lambda_after_del(mpc,dis,del_branch_index,node_index)
%[num,lambda] = lambda_after_del(mpc,floyd_dis(mpc),1,3);

bus_num = length(mpc.bus(:,1));
branch_num = length(mpc.branch(:,1));

count = 0;
jump_result = [];
lambda_result = [];

for node = 1 : bus_num
    for branch = 1 : branch_num
        if (mpc.bus(node,3) ~= 0 && mpc.bus(node,4)~= 0)
            if (mpc.bus(node,2) == 1 && node ~= 10)
                [jump_temp,lambda_temp] = ...
                    lambda_after_del(mpc,floyd_dis(mpc),branch,node);
                if lambda_temp >= 0.1
                    count = count + 1;
                    jump_result(count) = jump_temp;
                    lambda_result(count) = lambda_temp;
                end
            end
        end
    end
end

plot_result_points(jump_result,lambda_result);
end