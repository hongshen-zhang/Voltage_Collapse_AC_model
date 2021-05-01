function test_mpc(mpc,xlsx_name,xlsx_index)
format long
%First let all gen to be normalized as 1.
mpc.gen(:,6) = 1;
mpc.branch(:,9) = 0;

node_index = [];
exact_lambda = [];
predict_lambda = [];
error_ratio = [];


test_node = [];
num_test = 0;

num_bus = length(mpc.bus(:,1));
for loop = 1 : num_bus
    if mpc.bus(loop,2) == 1
        if (mpc.bus(loop,3)~=0) || (mpc.bus(loop,4)~=0)
            num_test = num_test + 1;
            test_node(num_test) = loop;
        end
    end
end

for loop = 1 : num_test
    node_index(loop) = loop;
    exact_lambda(loop) = Binary_exact_lambda(mpc,test_node(loop));
    predict_lambda(loop) = Binary_Predict_lambda(mpc,test_node(loop));
    error_ratio(loop) = abs(exact_lambda(loop) - predict_lambda(loop)) /...
        exact_lambda(loop);
end


varNames = {'node_index','exact_lambda','predict_lambda','error_ratio'};
T = table(node_index.',exact_lambda.',predict_lambda.',error_ratio.','VariableNames',varNames);
writetable(T,xlsx_name,'Sheet',xlsx_index)
end
