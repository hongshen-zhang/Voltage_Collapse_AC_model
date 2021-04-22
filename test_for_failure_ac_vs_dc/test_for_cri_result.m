clear all
clear
casename = case9;
%casename = case14;
%casename = case24_ieee_rts;
%casename = case30;
%casename = case39;
%casename = case57;
%casename = case118;
%casename = case300;


exact_0 = [];
predict_0 = [];
exact_1 = [];
predict_1 = [];
load_num = 9;

for loop = 1 : load_num
    if casename.bus(loop,2) == 1
        [a_0,b_0] = test_for_cri_both(casename,loop,0);
        [a_1,b_1] = test_for_cri_both(casename,loop,1);
        exact_0(loop) = a_0;
        predict_0(loop) = b_0;
        exact_1(loop) = a_1;
        predict_1(loop) = b_1;
    else
        exact_0(loop) = 0;
        predict_0(loop) = 0;
        exact_1(loop) = 0;
        predict_1(loop) = 0;
    end
        
end


figure(1)
s1 = scatter([1:load_num],exact_0,300,'.');
hold on
s2 = scatter([1:load_num],predict_0,300,'.');
legend('exact','predict');
ylim([0.05,50]);

figure(11)
scatter([1:load_num],abs(predict_0-exact_0)./ exact_0,300,'.');
legend('delta');
ylim([0.05,50]);


figure(2)
s1 = scatter([1:load_num],exact_1,300,'.');
hold on
s2 = scatter([1:load_num],predict_1,300,'.');
legend('exact','predict');
ylim([0.05,50]);

figure(22)
scatter([1:load_num],abs(predict_1-exact_1) ./ exact_1,300,'.');
legend('delta');
ylim([0.05,50]);

exact_0
predict_0

exact_1
predict_1
