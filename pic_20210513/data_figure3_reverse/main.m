load jump.mat
load lambda.mat
load mean_num.mat
load mean.mat
figure(1)
scatter(jump,lambda,'k.');
hold on 
plot(mean_num,mean,'bp','MarkerSize',15);
hold on 