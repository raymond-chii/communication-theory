clc
clear
close all
%%%% Lei(Raymond) Chi comm ps3 

% question 4e

Pe = linspace(0, 1, 101)
cap = Pe .* log2(Pe) + (1 - Pe) .* log2(1 - Pe) + 1;

figure;
plot(Pe, cap);
xlabel('Pe');
ylabel('channel capacity (bits)');
title('channel capacity vs. pE');
grid on;

% problem 5

% lambda 1 = 0.4 amd lambda 2 = 1
test = linspace(0.4, 1, 4);
linspace(0.4, 1, 4)
variances = [4, 3, 0.8, 0.1];

%these two are the tight bounds 
lambda_tight1 = 0.56;
lambda_tight2 = 0.561;
[d1, r1] = water_filling(variances, lambda_tight1)
[d2, r2] = water_filling(variances, lambda_tight2)


d2 = zeros(size(test));
r2 = zeros(size(test));

for i = 1:length(test)
    [dtest(i), rtest(i)] = water_filling(variances, test(i));
end

% lambda_values = linspace(0, 5, 100);
D_values = zeros(size(test));
R_values = zeros(size(test));

for i = 1:length(test)
    [D_values(i), R_values(i)] = water_filling(variances, test(i));
end


figure;
plot(D_values,R_values, '-o');
xlabel('Distortion (D)');
ylabel('Rate (R)');
title('Rate-Distortion Curve');
grid on;


% increasing lambda will cause D to increase and will decrease R


lambda_parte = 0.56
[D, R, Di,Ri] =parte(variances, lambda_parte)
% R3 = 0 , is not encoded at all 

function [D, R, Di,Ri] =parte(variance, lambda)

D = 0; 
R = 0;
Di = [0,0,0,0];
Ri = [0,0,0,0];
for i = 1:length(variance)
    if variance(i) >= lambda
        Di(i) = lambda;

    else 
        Di(i) = variance(i);
    end 
    
    D = sum(Di);
    Ri(i) = 1/2*log(variance(i)/Di(i));
    R = sum(Ri);

end 
end 


function [D, R] =water_filling(variance, lambda)

D = 0; 
R = 0;
Di = [0,0,0,0];
Ri = [0,0,0,0];
for i = 1:length(variance)
    if variance(i) >= lambda
        Di(i) = lambda;

    else 
        Di(i) = variance(i);
    end 
    
    D = sum(Di);
    Ri(i) = 1/2*log(variance(i)/Di(i));
    R = sum(Ri);

end 
end 
