function [Ybus_all,B_LL,B_LG,V_load_star,Q_cirt,Q_load] = makeNeeds(mpc)

[YBUS, ~, ~] = makeYbus(mpc);
[x,y,value] = find(YBUS);

bus = mpc.bus;
gen = mpc.gen;
baseMVA = mpc.baseMVA;

Q_load = [];
Load_index = [];
Generator_index = [];
V_load_star = [];
I_shunt = [];
count_load_index = 0;
count_generator_index = 0;

for loop = 1 : length(bus(:,1))
    %if load bus
    %Load_index,Q_load,I_shunt(for B_s)
    if bus(loop,2) == 1
        count_load_index = count_load_index + 1;
        Load_index(count_load_index) = loop;
        %bus(:,4) is Q_d(reactive part for demand)
        Q_load(count_load_index) = bus(loop,4) / baseMVA;
        %bus(:,6) is B_s(reactive part for I_shunt)
        %I_shunt(count_load_index) = bus(loop,6) / baseMVA;
        I_shunt(count_load_index) = 0;
        %V_load_star(count_load_index) = bus(loop,8);
    end
    %if generator bus
    %further in gen part
    if (bus(loop,2) == 2) || (bus(loop,2) == 3)
        count_generator_index = count_generator_index + 1;
        Generator_index(count_generator_index) = loop;
    end
end 

B_LL = zeros(count_load_index,count_load_index);
B_LG = zeros(count_load_index,count_generator_index);

for loop = 1 : length(x)
    %li_load is 0(no) or 1(yes),loc_load is the index
    [li_load_1,loc_load_1] = ismember(x(loop),Load_index);
    [li_load_2,loc_load_2] = ismember(y(loop),Load_index);
    [li_gen_2,loc_gen_2] = ismember(y(loop),Generator_index);
    if (li_load_1 == 1) && (li_load_2 == 1) 
        B_LL(loc_load_1,loc_load_2) = imag(value(loop));
    end
    if (li_load_1 == 1) && (li_gen_2 == 1)
        B_LG(loc_load_1,loc_gen_2) = imag(value(loop));
    end
end


V_G = zeros(count_generator_index,1);
for i = 1 : length(gen(:,1))
    [li_gen,loc_gen] = ismember(gen(i,1),Generator_index);
    if li_gen == 1 
        V_G(loc_gen) = gen(i,6);
    end
end

V_load_star =  -inv(B_LL) * (B_LG * V_G + I_shunt.');
%V_load_star =  -inv(B_LL) * (B_LG * V_G);

%another pattern get V_load_star

Q_cirt = (diag(V_load_star) * B_LL * diag(V_load_star)) /4;
Ybus_all = imag(full(YBUS));

end