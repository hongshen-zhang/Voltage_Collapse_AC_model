function [Y_ij] = Eq_resistence_set(start,ter,mpc)
%start is the node_index of generator bus(may contain several buses)
%ter is the node_index of load bus(may contain several buses)

[YBUS, ~, ~] = makeYbus(mpc);
Y = full(YBUS);
n = length(mpc.bus(:,1));
m = length(start);

Y(:,start) = [];
combine = Y(start,:);
Y(start,:) = [];
Y(n - m + 1 , :) =  sum(combine,1);
Y(: , n - m + 1) = [sum(combine,1) , -sum(sum(combine))];

n_new = n - m + 1;
m_new = length(ter);

new_ter = [];
for loop_load = 1 : length(ter)
    new = 0;
    for loop = 1 : ter(loop_load)
        %if mpc.bus(loop,2) ~= 1
        if mpc.bus(loop,2) == 1
            new = new + 1;
        end
        new_ter(loop_load) = new;
    end
end

Y(:,new_ter) = [];
comb = Y(new_ter,:);
Y(new_ter,:) = [];
Y(n_new - m_new + 1, :) = sum(comb,1);
Y(: , n_new - m_new + 1) = [(sum(comb,1)), -sum(sum(comb))];
Y(: , n_new - m_new) = [];

I_n = zeros(n_new - m_new + 1 ,1);
I_n(n_new - m_new + 1) = 1;
%I_n(ter) = 1;



I_n(n_new - m_new) = -1;

choose = 1;

Y(choose,:) = [];
I_n(choose) = [];



%if choose < ter
%if choose < new
%    new = new - 1;
%end

U = inv(Y) * I_n;

Y_ij =  1 / U(n_new - m_new);

end