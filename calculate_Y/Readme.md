# Formula of delta Y and its simulation 

 ![language](https://img.shields.io/badge/language-Matlab-darkgreen.svg)
 ![Usage1](https://img.shields.io/badge/Usage-Matpower-green.svg)

----
This example choose `IEEEcase14` and delete the branch with index `[11,12]`. Change the `main.m` to choose other case and line.

```
mpc = case14;
line_delete = [11,12];
```

----

Function 
- Use `calculate_exact_Y(mpc)` to test the exact sum of Y in mpc.
- Use `calculate_fast_Y(mpc)` to test the formula of sum of Y in mpc.
- Use `calculate_delta_Y(mpc,line_delete)` to test the delta of Y after line deletion.

----

Simulation 1

```

The raw_code folder transfer the data in OATS style of GB network into MATPOWER style. 

----
See more details in [A reduced representative GB network](https://oats.readthedocs.io/en/latest/networkdata.html#a-reduced-representative-gb-network).

It contains vivid picture with buses, branches and generators.

>Cite information [1] : Bukhsh, Waqquas, Calum Edmunds, and Keith Bell. "OATS: Optimisation and Analysis Toolbox for Power Systems." IEEE Transactions on Power Systems 35.5 (2020): 3552-3561.
>
>Cite information [2] : Bell, K. R. W. "Test system requirements for modelling future power systems." IEEE PES General Meeting. IEEE, 2010.

