% plotting the objective function and constraints

x=linspace(-3,3);
y=linspace(-3,3);
[X Y]=meshgrid(x,y); % creating input values

C1=Y.^2-2*X;
C2=(Y-1).^2+5*X-15; % constraints

F=X.^2+(Y-3).^2; % obj function

figure
axis([-3,3,-3,3])
xlabel('X(1)')
ylabel('X(2)')
contour(X,Y,C1,10)
hold on
plot(0.5*x.^2,x,'k','linewidth',2)
hold on
axis([-3,3,-3,3])
contour(X,Y,C2,10)
hold on
plot(-0.2*(x-1).^2+3,x,'k','linewidth',2)
hold on
axis([-3,3,-3,3])
contour(X,Y,F,10)
hold on
plot(1.0602,1.4562,'*r')