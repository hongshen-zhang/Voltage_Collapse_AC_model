%--------------------------------------------------------------------------
% Main for test 
%--------------------------------------------------------------------------
mpc = case14_t;

%Initialize with the same voltage
mpc.gen(:,6) = 1;


r1 = Binary_exact_several_lambda(mpc,[5,9,10,11])
r2 = Binary_Predict_several_lambda(mpc,[5,9,10,11])
r3 = abs(r1 - r2)*100/r1 



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