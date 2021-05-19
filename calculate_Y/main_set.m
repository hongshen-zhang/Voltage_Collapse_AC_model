%--------------------------------------------------------------------------
% Main for test 
%--------------------------------------------------------------------------
clear all
clear 
warning('off')

%case information
mpc = case14;
%index of deleted line
line_delete = [11,12];

Simulation1 = 'Simulation for part 2 \sum_i Y_i'
Y_exact = calculate_exact_Y(mpc)
sum_Y = calculate_fast_Y(mpc)


Simulation2 = 'Simulation for part 2 \sum_i Y_i'''
mpc.branch([11,12],:) = [];
Y_exact_del = calculate_exact_Y(mpc)
sum_Y_del = calculate_fast_Y(mpc)


mpc = case14;
warning('off')
Simulation3 = 'Simulation for part 3 \sum_i (Y_i - Y_i'')'
delta_exact = Y_exact - Y_exact_del
Y_del_cal = calculate_delta_Y(mpc,[11,12]) 