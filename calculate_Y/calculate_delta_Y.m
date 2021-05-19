function [delta] = calculate_delta_Y(mpc,line_set)
%Initialization
mpc.gen(:,6) = 1;
mpc.branch(:,5) = 0;
mpc.branch(:,9) = 0;
n = length(mpc.bus(:,1));
m = length(mpc.gen(:,1));

Y1 = get_Y(mpc);
mpc.branch(line_set,:) = [];
Y2 = get_Y(mpc);

I_n = zeros(n - m + 1,n - m);
I_n(n - m + 1 , : ) = -1;
for loop = 1 : n - m
    I_n(loop,loop) = 1;
end

R_result =  pinv(Y1) * (Y1 - Y2) * pinv(Y2) * I_n;

left = inv(diag(diag(pinv(Y2) * I_n)));

right = inv(diag(diag(pinv(Y1) * I_n)));

delta = sum(diag(left * R_result * right));

end