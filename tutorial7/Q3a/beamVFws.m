function [f] = beamVFws(xF,w)
% Define 3 elements of x vector as individual variables length, width, height
L = xF(1); W = xF(2); H = xF(3); F = xF(4);
% Define volume
V = L*W*H;
f = w(1)*V - w(2)*F;