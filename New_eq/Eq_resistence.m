function [Y_ij] = Eq_resistence(start,ter,mpc)
%start is the node_index of load bus 
%ter is the node_index of generator or slack bus
[YBUS, ~, ~] = makeYbus(mpc);
Y = full(YBUS);
%Y
n = length(mpc.bus(:,1));

choose = 0;
for loop = 1 : n
    %if (loop ~= start) && (loop~= ter)
    if (loop ~= ter)
        choose = loop;
    end
end

Y(:,start) = [];

I_n = zeros(n,1);
I_n(start) = -1;
I_n(ter) = 1;
Y(choose,:) = [];
I_n(choose) = [];

%if choose < ter
if choose < ter
    ter = ter - 1;
end


U = inv(Y) * I_n;

Y_ij =  1 / U(ter);

end