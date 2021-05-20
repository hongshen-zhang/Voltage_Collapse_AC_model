%[N,Y_w,Y_diag,Y_dw,Y_uw,G_uw,G_w,S,p_index,g_index,l_index]= initialization(case9);
[N,Y_w,Y_diag,Y_dw,Y_uw,G_uw,G_w,S,p_index,g_index,l_index]= initialization(case30);
G = graph(Y_uw);
h1=plot(G,'layout','force','linewidth',2,'edgecolor',[152 152 152]/256);
highlight(h1,find(mpc.bus(:,2)~=1),'NodeColor','r')

%p_index
%[A_out,R] = matrix_decomposition(Y_w,p_index(1),g_index)
%[A_out,R] = matrix_decomposition(Y_w,p_index(2),g_index)
%[A_out,R] = matrix_decomposition(Y_w,p_index(3),g_index)
