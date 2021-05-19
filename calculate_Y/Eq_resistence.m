function [Y_ij] = Eq_resistence(start,ter,mpc)
%ter is the node_index of load bus 
%start is the node_index of generator bus(may contain several buses)

[YBUS, ~, ~] = makeYbus(mpc);
Y = full(YBUS);
n = length(mpc.bus(:,1));
m = length(mpc.gen(:,1));

Y(:,start) = [];
combine = Y(start,:);
Y(start,:) = [];
Y(n - m + 1 , :) =  sum(combine);
%Y(: , n - m + 1) = [sum(combine) , -sum(sum(combine))];

new = 0;

I_n = zeros(n - m + 1,1);
I_n(n - m + 1) = -1;
%I_n(ter) = 1;

for loop = 1 : ter
    if mpc.bus(loop,2) == 1
        new = new + 1;
    end
end
I_n(new) = 1;

choose = 0;
for loop = 1 : n - m 
    if loop ~= new
        choose = loop;
    end
end

Y(choose,:) = [];
I_n(choose) = [];



%if choose < ter
%if choose < new
%    new = new - 1;
%end

U = inv(Y) * I_n;
Y_ij =  1 / U(new);

end