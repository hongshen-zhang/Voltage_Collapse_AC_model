[bus,line,mac_con] = data48em;
mpc = pst2matpower(bus,line,mac_con);
data48_matpower = case4gs;
data48_matpower.bus = mpc.bus;
data48_matpower.gen = mpc.gen;
data48_matpower.branch = mpc.branch;

