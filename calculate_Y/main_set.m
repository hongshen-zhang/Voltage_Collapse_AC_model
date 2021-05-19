%--------------------------------------------------------------------------
% Main for test 
%--------------------------------------------------------------------------
clear all
clear 
mpc = case14;
warning('off')

Y_exact = calculate_exact_Y(mpc)
sum_Y = calculate_fast_Y(mpc)

mpc.branch([11,12],:) = [];

Y_exact_del = calculate_exact_Y(mpc)
sum_Y_del = calculate_fast_Y(mpc)


mpc = case14;
warning('off')



delta_exact = Y_exact - Y_exact_del
delta_pre = sum_Y - sum_Y_del
Y_del_cal = calculate_delta_Y(mpc,[11,12]) 