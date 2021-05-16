function [A_out,R]= matrix_decomposition(A_in,p_index,g_index)
% g_index: column vector

A=A_in;N=size(A,1);
temp=setdiff(1:N,[p_index;g_index])'; % column vector
node_rank=[g_index;p_index;temp];
A=A(node_rank,:);A=A(:,node_rank);
temp=sum(A(length(g_index)+1:end,1:length(g_index)),2);
%temp=sum(A(length(g_index)+1:N,:),1);temp=temp(length(g_index)+1:end);
A=A(length(g_index)+1:N,length(g_index)+1:N);
A=[[0,temp.'];[temp,A]]; A=-A+diag(sum(A,2)); 
N1=2;N=size(A,1);
A11=A(1:N1,1:N1);A12=A(1:N1,N1+1:N); A21=A(N1+1:N,1:N1);A22=A(N1+1:N,N1+1:N);
A_out=A11-A12*(A22^-1)*A21;
R=-sum(A_out(end,1:end-1));



