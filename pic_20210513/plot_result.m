function plot_result_point(mpc,index,jump,lambda)
baseline = Binary_exact_lambda(mpc);
base = [];
%jump_min = min(jump);
jump_max = max(jump);
mean_count = zeros(1,jump_max);
mean_sum = zeros(1,jump_max);

for loop = 1 : length(jump)
    base(loop) = baseline;
    mean_count(jump(loop)) = mean_count(jump(loop)) + 1;
    mean_sum(jump(loop)) = mean_sum(jump(loop)) + lambda(loop);
end

mean_num = [];
mean = [];
for loop = 1 : jump_max
    if mean_count(loop) == 0
        mean_num = loop;
        mean = mean_sum(loop) / mean_count(loop);
    end
end


scatter(jump,lambda);
hold on 
plot(mean_num,mean);
hold on 

end