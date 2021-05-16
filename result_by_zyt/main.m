[N,Y_w,Y_diag,Y_dw,Y_uw,G_uw,G_w,S,p_index,g_index,l_index]= initialization(case9);
p_index

[A_out,R] = matrix_decomposition(Y_w,p_index(1),g_index)
[A_out,R] = matrix_decomposition(Y_w,p_index(2),g_index)
[A_out,R] = matrix_decomposition(Y_w,p_index(3),g_index)
