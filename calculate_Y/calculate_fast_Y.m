function [sum_Y] = calculate_fast_Y(mpc)
%Initialization
mpc.gen(:,6) = 1;
mpc.branch(:,5) = 0;
mpc.branch(:,9) = 0;
start = mpc.gen(:,1);

%make equivalence
[YBUS, ~, ~] = makeYbus(mpc);
Y = full(YBUS);
n = length(mpc.bus(:,1));
m = length(mpc.gen(:,1));

Y(:,start) = [];
combine = Y(start,:);
Y(start,:) = [];
Y(n - m + 1 , :) =  sum(combine);
%Y(: , n - m + 1) = [sum(combine) , -sum(sum(combine))];

I_n = zeros(n - m + 1,n - m);
I_n(n - m + 1 , : ) = -1;
for loop = 1 : n - m
    I_n(loop,loop) = 1;
end

R_result = diag(diag(pinv(Y) * I_n));

sum_Y = sum(sum(inv((R_result))));

end