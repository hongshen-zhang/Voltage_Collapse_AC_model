function [Y] = get_Y(mpc)
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
end