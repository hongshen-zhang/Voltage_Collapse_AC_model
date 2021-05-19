function formal_test(mpc,node_set)
r2 = Binary_Predict_several_lambda(mpc,node_set)
r3 = Binary_exact_several_lambda(mpc,node_set)
error_1 = abs(r2 - r3) / r3
end