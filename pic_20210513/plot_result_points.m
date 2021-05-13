function plot_result_points(jump,lambda)


%jump_min = min(jump);
jump_max = max(jump);
mean_count = zeros(1,jump_max);
mean_sum = zeros(1,jump_max);

for loop = 1 : length(jump)
    mean_count(jump(loop)) = mean_count(jump(loop)) + 1;
    mean_sum(jump(loop)) = mean_sum(jump(loop)) + lambda(loop);
end
count_mean = 0;
mean_num = [];
mean = [];


for loop = 1 : jump_max
    if mean_count(loop) ~= 0
        count_mean = count_mean + 1;
        mean_num(count_mean) = loop;
        mean(count_mean) = mean_sum(loop) / mean_count(loop);
    end
end


figure(999)
scatter(jump,lambda,'k.');
hold on 
plot(mean_num,mean,'bp','MarkerSize',15);
hold on 
end