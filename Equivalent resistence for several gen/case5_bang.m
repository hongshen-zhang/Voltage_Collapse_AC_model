function mpc = case3_z
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
mpc.baseMVA = 1;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	1	3	0	0	0	0	1	1	0	345	1	1.5	0.5;
    2	1	0.01	0	0	0	1	1	0	345	1	1.5	0.5;   
	3	1	0.01	0	0	0	1	1	0	345	1	1.5	0.5;
    4	1	0.01	0	0	0	1	1	0	345	1	1.5	0.5;
    5	1	0.01	0	0	0	1	1	0	345	1	1.5	0.5;
];

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = [
	1	0	0	300	-300	1	1	1	250	0	0	0	0	0	0	0	0	0	0	0	0;
];

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = [
	1	2	0.05	0.05	0	0	0	0	0	0	1	-360	360;
    2	3	0.05	0.05	0	0	0	0	0	0	1	-360	360;
    3	4	0.05	0.05	0	0	0	0	0	0	1	-360	360; 
    4	5	0.05	0.05	0	0	0	0	0	0	1	-360	360; 
];

