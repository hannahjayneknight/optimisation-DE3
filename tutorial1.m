zhandle.LevelList = 1;
xlabel x1
ylabel x2
title(func2str(Z))
grid on
zhandle.YRange = [-2,2];
zhandle.XRange = [-2,2];
axis equal

Z = -Y - (2*X*Y) + X^2 + (Y^2) - (3*(X^2)*Y) - (2*(X^3)) + (2*(X^4));
zhandle = fcontour(Z)