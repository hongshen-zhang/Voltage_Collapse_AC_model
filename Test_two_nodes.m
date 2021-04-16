%Test for 2  nodes
runpf('case2')

mag = 0.544;
deg = 22.375;
rad = deg * pi / 180;
V_G = 1;

%V_G is the voltage of node 1(generator bus);
%V_L is the voltage of node 2(load bus);
V_L = mag * cos(rad) + mag * sin(rad) * j;
P = (V_L - V_G) * conj(V_L)
