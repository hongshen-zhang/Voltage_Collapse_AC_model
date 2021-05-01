%given casename
%casename = case5;
%casename = case9;
%casename = case14;
%casename = case30;
%casename = case57;
%casename = case118;

format long
for loop = 3 : 3
    if loop == 1
        mpc = case5;
    end
    if loop == 2
        mpc = case9;
    end
    if loop == 3
        mpc = case14;
    end
    if loop == 4
        mpc = case30;
    end
    if loop == 5
        mpc = case57;
    end
    if loop == 6
        mpc = case118;
    end
    test_mpc(mpc,'all_result.xls',loop);
end