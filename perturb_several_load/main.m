%--------------------------------------------------------------------------
% Main for test 
%--------------------------------------------------------------------------
mpc = case9;

%Initialize with the same voltage
mpc.gen(:,6) = 1;

%Eq_resistence([1,2,3],5,finetune_mpc(mpc))

Binary_exact_several_lambda(mpc,[5,7])
Binary_exact_several_lambda(mpc,[5,9])
Binary_exact_several_lambda(mpc,[7,9])
Binary_exact_several_lambda(mpc,[5,7,9])



Binary_Predict_lambda(mpc,5)

Eq_resistence([1,2,3],7,finetune_mpc(mpc))
Binary_exact_lambda(mpc,7)
Binary_Predict_lambda(mpc,7)

Eq_resistence([1,2,3],9,finetune_mpc(mpc))
Binary_exact_lambda(mpc,9)
Binary_Predict_lambda(mpc,9)