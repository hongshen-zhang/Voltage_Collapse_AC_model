function [cri_succ,cri_delta] = test_for_cri_both(casename,node_index,type)
%casename = case9;
%casename = case14;
%casename = case24_ieee_rts;
%casename = case30;
%casename = case39;
%casename = case57;
%casename = case118;
%casename = case300;

mpc = ext2int(casename);

%for case39, index \in 1 to 29 are load bus
if type == 0
    mpc_high = mpc;
end
if type == 1
    mpc_high = high_vol(mpc);
end

multi_lam = 0:0.1:50;
mpopt = mpoption;
mpopt = mpoption(mpopt,'PF_DC',0,'OUT_ALL',0,'VERBOSE',0);


cri_succ = 0;
cri_delta = 0;
delta = [];
succ = [];
for loop = 2 : length(multi_lam)
    lambda = multi_lam(loop);
    mpc_mul = multi_one_node(mpc_high,node_index,lambda);
    [Ybus,B_LL,B_LG,V_load_star,Q_cirt,Q_load] = makeNeeds(mpc_mul);
    Delta = max(abs(inv(Q_cirt) * (Q_load.')));
    results = runpf(mpc_mul,mpopt);
    succ(loop) = results.success;
    delta(loop) = Delta;
    if (succ(loop - 1) == 1) && (succ(loop) == 0)
        cri_succ = loop * 0.1;
    end
    
    if (delta(loop - 1) < 1) && (delta(loop) >= 1)
        cri_delta = loop * 0.1;
    end
end

%figure(1)
%plot([1:201]*0.1,delta,[1:201]*0.1,succ);

end

