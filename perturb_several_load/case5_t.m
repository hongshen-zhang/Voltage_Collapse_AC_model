function mpc = case9_t
%CASE9    Power flow data for 9 bus, 3 generator case.
%   Please see CASEFORMAT for details on the case file format.
%
%   Based on data from p. 70 of:
%
%   Chow, J. H., editor. Time-Scale Modeling of Dynamic Networks with
%   Applications to Power Systems. Springer-Verlag, 1982.
%   Part of the Lecture Notes in Control and Information Sciences book
%   series (LNCIS, volume 46)
%
%   which in turn appears to come from:
%
%   R.P. Schulz, A.E. Turner and D.N. Ewart, "Long Term Power System
%   Dynamics," EPRI Report 90-7-0, Palo Alto, California, 1974.

%   MATPOWER

%% MATPOWER Case Format : Version 2
mpc.version = '2';

%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = 100;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	3	0	0	0	0	1	1	0	345	1	1.1	0.9;
	2	3	0	0	0	0	1	1	0	345	1	1.1	0.9;
	3	3	0	0	0	0	1	1	0	345	1	1.1	0.9;
	4	1	90	30	0	0	1	1	0	345	1	1.1	0.9;
	5	1	125	50	0	0	1	1	0	345	1	1.1	0.9;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	72.3	27.03	300	-300	1.04	100	1	250	10	0	0	0	0	0	0	0	0	0	0	0;
	2	163	6.54	300	-300	1.025	100	1	300	10	0	0	0	0	0	0	0	0	0	0	0;
	3	85	-10.95	300	-300	1.025	100	1	270	10	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	5	0	0.0576	0	250	250	250	0	0	1	-360	360;
	2	5	0.017	0.092	0	250	250	250	0	0	1	-360	360;
	3	5	0.039	0.17	0	150	150	150	0	0	1	-360	360;
    5	4	0.00001	0	0	0	0	0	0	0	1	-360	360;
%    9	4	0.01	0.085	0.176	250	250	250	0	0	1	-360	360;
 ];

%%-----  OPF Data  -----%%
%% generator cost data
%	1	startup	shutdown	n	x1	y1	...	xn	yn
%	2	startup	shutdown	n	c(n-1)	...	c0
mpc.gencost = [
	2	1500	0	3	0.11	5	150;
	2	2000	0	3	0.085	1.2	600;
	2	3000	0	3	0.1225	1	335;
];
