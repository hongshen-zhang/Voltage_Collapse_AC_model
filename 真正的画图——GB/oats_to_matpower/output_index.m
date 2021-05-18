load case_GB_reduced.mat
varNames = {'node_index','genorload'};
xlsx_name = 'GB.csv';
mpc = case_GB_reduced;
T = table(mpc.bus(:,1),mpc.bus(:,2),'VariableNames',varNames);
writetable(T,xlsx_name)

xlsx_name = 'GB_adjancency.csv'
varNames = {'start','end'};
T = table(mpc.branch(:,1),mpc.branch(:,2),'VariableNames',varNames);
writetable(T,xlsx_name)