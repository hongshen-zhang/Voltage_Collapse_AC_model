function [success] = Predict_for_node(mpc,node)
%This part could only is solved for several generators
%It returns 0 for failure and 1 for success
%Use the formula(49) in gao_si to check
%Based on Eq_resistence
Y_eq = [];
del = [];
sum_x = 0;
sum_y = 0;
for loop = 1 : length(mpc.bus(:,1))
    if mpc.bus(loop,2) == 1
        sum_x = sum_x + mpc.bus(loop,3);
        sum_y = sum_y + mpc.bus(loop,4);
    end
end
sum_x = sum_x - mpc.bus(node,3);
sum_y = sum_y - mpc.bus(node,4);

sum_x = 0;
sum_y = 0;

%Consider the impact of total line charging susceptance
sum_sus = sum(mpc.branch(:,5)) / 2;

del_num = 0;
num_gen = length(mpc.gen(:,1));
num_branch = length(mpc.branch(:,1));
num_bus = length(mpc.bus(:,1));
gen_list = mpc.gen(:,1);
for loop = 1 : num_gen
    new_gen = setdiff(gen_list,gen_list(loop));
    change_mpc = mpc;
    %make_new_mpc
    %Let all gen in new_gen to be disconnect
    %It is equal to that all branch with new_gen to be 
    for loop_branch = 1 : num_branch
        node_1 = change_mpc.branch(loop_branch,1);
        node_2 = change_mpc.branch(loop_branch,2);
        [tf_1,~] = ismember(node_1,new_gen);
        [tf_2,~] = ismember(node_2,new_gen);
        if (tf_1 == 1 || tf_2 == 1) 
            %change_mpc.branch(loop_branch,3) = 99999999;
            %change_mpc.branch(loop_branch,[4,5]) = 0;   
            del_num = del_num + 1;
            del(del_num) = loop_branch;
        end
    end 
    change_mpc.branch(del,:) = [];
    %delete other generator
    del = [];
    del_num = 0;
    for loop_gen = 1 : num_gen
        node_ind = mpc.gen(loop_gen,1);
        [tf,~] = ismember(node_ind,new_gen);
        if (tf == 1)
            del_num = del_num + 1;
            del(del_num) = loop_gen;
            %change_mpc.gen(loop_gen,2) 
        end
    end
    change_mpc.gen(del,:) = [];
    %delete other bus
    del = [];
    del_num = 0;
    for loop_bus = 1 : num_bus
        node_ind = mpc.bus(loop_bus,1);
        [tf,~] = ismember(node_ind,new_gen);
        if (tf == 1)
            del_num = del_num + 1;
            del(del_num) = loop_bus;
        end
    end
    change_mpc.bus(del,:) = [];    
    del = [];
    del_num = 0;    
    %change_mpc.branch
    %node
    %gen_list(loop)
    new_index = [];
    new_num = length(change_mpc.bus(:,1));
    for loop_ind = 1 : new_num
        index = change_mpc.bus(loop_ind,1);
        new_index(index) = loop_ind;
        change_mpc.bus(loop_ind,1) = loop_ind;
    end
    new_num_gen = length(change_mpc.gen(:,1));
    for loop_ind = 1 : new_num_gen
        index = change_mpc.gen(loop_ind,1);
        change_mpc.gen(loop_ind,1) = new_index(index);
    end
    new_num_branch = length(change_mpc.branch(:,1));
    for loop_ind = 1 : new_num_branch
        ind_1 = change_mpc.branch(loop_ind,1);
        ind_2 = change_mpc.branch(loop_ind,2);
        change_mpc.branch(loop_ind,1) = new_index(ind_1);
        change_mpc.branch(loop_ind,2) = new_index(ind_2);
    end
    mpc_final = finetune_mpc(change_mpc);
    Y_eq(loop) = Eq_resistence(new_index(node),new_index(gen_list(loop)),mpc_final);
end

Y_ii = sum(Y_eq) + sum_sus * j;
Y_ij = sum(Y_eq);
S_load = (-(mpc.bus(node,3) + sum_x) - (mpc.bus(node,4) + sum_y) * j) ...
    / mpc.baseMVA;
%S_load
Pro_1 = sqrt(abs(Y_ii^2) ...
    / (abs(S_load) * abs(Y_ii) ...
    - real(S_load * Y_ii)));
Pro_2 = abs(Y_ij * 1 ...
    / Y_ii);
if Pro_1 * Pro_2 > sqrt(2)
    success = 1;
else
    success = 0;
end

end
