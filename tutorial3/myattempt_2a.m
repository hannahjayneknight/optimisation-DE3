clear all; clc;

A = [   5, 3, 0, 2, 0, 3, 4, 6;
        2, 0, 4, 3, 7, 0, 1, 0;
        2, 4, 3, 0, 0, 0, 0, 0;
        7, 3, 6, 0, 0, 0, 0, 0;
        5, 0, 3, 0, 0, 0, 0, 0;
        0, 0, 0, 3, 1, 2, 0, 0;
        0, 0, 0, 2, 4, 3, 0, 0;
        0, 0, 0, 0, 0, 0, 8, 5;
        0, 0, 0, 0, 0, 0, 7, 9;
        0, 0, 0, 0, 0, 0, 6, 4;
        -1, 0, 0, 0, 0, 0, 0, 0;
        0, -1, 0, 0, 0, 0, 0, 0;
        0, 0, -1, 0, 0, 0, 0, 0;
        0, 0, 0, -1, 0, 0, 0, 0;
        0, 0, 0, 0, -1, 0, 0, 0;
        0, 0, 0, 0, 0, -1, 0, 0;
        0, 0, 0, 0, 0, 0, -1, 0;
        0, 0, 0, 0, 0, 0, 0, -1;
    ];

b = [ 30, 20, 10, 15, 12, 7, 9, 25, 30, 20, 0, 0, 0, 0, 0, 0, 0, 0];

f = [-8 -5 -6 -9 -7 -9 -6 -5];

[sol,fval,exitflag,output] = linprog(f,A,b);