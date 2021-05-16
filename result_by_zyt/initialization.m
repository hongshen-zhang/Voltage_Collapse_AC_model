function [N,Y_w,Y_diag,Y_dw,Y_uw,G_uw,G_w,S,p_index,g_index,l_index]= initialization(mpc)
% output: p_index, g_index, l_index both are column vectors

mpc=ext2int(mpc);
N=size(mpc.bus,1);
[Y,~,~]=makeYbus(mpc);
Y_w=full(Y); %D-A (Dij~=sum(Aij), in some conditions)
Y_diag=diag(Y_w); 
Y_w(eye(size(Y_w,1))~=0)=0;Y_w=-Y_w;
Y_dw=Y_w./Y_diag; 
Y_uw=Y_w; Y_uw(Y_uw~=0)=1;
G_uw=digraph(Y_uw);
G_w=digraph(abs(Y_w));
result=runpf(mpc);
result=ext2int(result);
S=zeros(N,1);
S(result.gen(:,1))=complex(result.gen(:,2),result.gen(:,3));
S=( S-complex(result.bus(:,3),result.bus(:,4)) )/100;
p_index=intersect( find(mpc.bus(:,2)==1), find(mpc.bus(:,3)>0));
p_index=intersect( p_index , find(mpc.bus(:,4)>0));

g_index=find(mpc.bus(:,2)~=1);
l_index=setdiff((1:N)',g_index);



