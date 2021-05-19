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

## Function 
- Use `calculate_exact_Y(mpc)` to test the exact sum of Y in mpc.
- Use `calculate_fast_Y(mpc)` to test the formula of sum of Y in mpc.
- Use `calculate_delta_Y(mpc,line_delete)` to test the delta of Y after line deletion.

----

## Simulation result

| Name | Exact | Formula | 
| :----: | :----: | :----: | 
| sum of Y | 27.489 - 95.439i | 27.488 - 95.381i | 
| sum of Y' | 20.487 - 80.954i | 20.484 - 80.925i | 
| delta between Y and Y' | 7.003 - 14.485i | 7.004 - 14.456i | 

### More detailed of formula can be viewed at `Formula.pdf`

