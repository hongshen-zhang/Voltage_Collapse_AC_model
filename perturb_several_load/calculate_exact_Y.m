function [Y_exact] = calculate_exact_Y(mpc)
%Initialization
mpc.gen(:,6) = 1;
mpc.branch(:,5) = 0;
mpc.branch(:,9) = 0;

%gen_list
gen_list = [];
for loop = 1 : length(mpc.gen(:,1))
    gen_list(loop) = mpc.gen(loop,1);
end

Y_exact = 0;
for loop = 1 : length(mpc.bus(:,1))
    if mpc.bus(loop,2) == 1
        Y = Eq_resistence(gen_list,loop,mpc)
        Y_exact = Y_exact + Y; 
    end
end

end