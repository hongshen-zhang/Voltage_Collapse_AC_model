M = [-1 1 0 0;
    1 -2 1 0;
    0 1 -2 1;
    0 0 1 -1];

n = 4;
gen = 4;

M([1,gen],:) = M([gen,1],:);
M(:,[gen,1]) = M(:,[1,gen]);

load = 2;

M([n,load],:) = M([load,n],:);
M(:,[load,n]) = M(:,[n,load]);

M

I = [1 0 0 -1];
choose_row = [1];
choose_col = [1,2];
M(:,choose_col) = [];
M(choose_row,:) = [];

M
I(choose_row) = [];

pinv(M) * I.'