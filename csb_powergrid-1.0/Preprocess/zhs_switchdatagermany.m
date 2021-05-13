load germany8
load ENTSO_E_2009_WINTER
mpc_ger = case4gs;
mpc_ger.bus = ps2.bus;
mpc_ger.gen = ps2.gen;
%mpc_ger.branch = mpc.branch(:,1:13);

branch_num = length(mpc.branch(:,1));
remain = [];
remain_index = 0;
for loop = 1 : branch_num
    inside = 0;
    if mpc.branch(loop,1) >= 768
        inside = inside + 1;
    end
    if mpc.branch(loop,2) >= 768
        inside = inside + 1;
    end
    if mpc.branch(loop,1) <= 995
        inside = inside + 1;
    end
    if mpc.branch(loop,2) <= 995
        inside = inside + 1;
    end
    %[li,~] = ismember(loop,mpc.removed_buses);
    if (inside == 4)
        remain_index = remain_index + 1;
        remain(remain_index) = loop;
    end
end

mpc_ger.branch = mpc.branch(remain,1:13);
mpc_ger.branch(:,1) = mpc_ger.branch(:,1) - 767;
mpc_ger.branch(:,2) = mpc_ger.branch(:,2) - 767;
mpc_ger.branch(:,3) = 0;
mpc_ger.gen(:,2) = abs(mpc_ger.gen(:,2));

