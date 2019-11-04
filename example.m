positions = {[2 0] [1 1] [0 2] [0 0]};
values = [1 2 1 1];
x0 = [1; 1];

p1 = MultiPolynomial(positions, values, x0);
disp(p1);
%<< 1 + (x2 - 1)^2 + 2(x1 - 1)(x2 - 1) + (x1 - 1)^2

keys = {[1 0], [0 0]};
keys = conv2str(keys);
keys
%<< {'1  0'}    {'0  0'}
values = [1 1];
map = containers.Map(keys, values);
x0 = [1; 1];
p2 = MultiPolynomial(map, 2, x0);
disp(p2);
%<< 1 + (x1 - 1)

disp(p1*5);
%<< 5 + 5(x2 - 1)^2 + 10(x1 - 1)(x2 - 1) + 5(x1 - 1)^2

disp(p1+p2);
%<< 2 + (x2 - 1)^2 + (x1 - 1) + 2(x1 - 1)(x2 - 1) + (x1 - 1)^2

disp(p1-p2);
%<< (x2 - 1)^2 + -1(x1 - 1) + 2(x1 - 1)(x2 - 1) + (x1 - 1)^2

disp(p1*p2);
%<< 1 + (x2 - 1)^2 + (x1 - 1) + 2(x1 - 1)(x2 - 1) + (x1 - 1)(x2 - 1)^2 + (x1 - 1)^2 + 2(x1 - 1)^2(x2 - 1) + (x1 - 1)^3

disp(p1.diff(1));
%<< 2(x2 - 1) + 2(x1 - 1)

disp(p1.integrate(2));
%<< (x2 - 1) + 0.33333(x2 - 1)^3 + (x1 - 1)(x2 - 1)^2 + (x1 - 1)^2(x2 - 1)


