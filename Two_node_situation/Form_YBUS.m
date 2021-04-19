function [YBUS] = Form_YBUS(mpc)
mpc = case2;

%Fit the data type of YBUS of the paper 
[YBUS, ~, ~] = makeYbus(mpc);
Y_num = length(mpc.bus(:,1));
for loop_i = 1 : Y_num
    for loop_j = 1 : Y_num
        if (loop_i ~= loop_j)
            YBUS(loop_i,loop_j) = - YBUS(loop_i,loop_j);
        end
    end
end

end