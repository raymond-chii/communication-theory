clc
clear
close all
%%%% Lei(Raymond) Chi comm ps2


[desicion_map, desicion_ml, Pe_map, Pe_ml] = process(1,9,1,9)
[map_errors1, ml_errors1] = simulation (1,9,1,9, desicion_map, desicion_ml)

[desicion_map_2, desicion_ml_2, Pe_map_2, Pe_ml_2] = process(4,6,1,9)
[map_errors2, ml_errors2] = simulation (4,6,1,9, desicion_map_2, desicion_ml_2)

[desicion_map_3, desicion_ml_3, Pe_map_3, Pe_ml_3] = process(1,9,4,6)
[map_errors3, ml_errors3] = simulation (1,9,4,6, desicion_map_3, desicion_ml_3)


% after comparing the difference between simulations and the theorical
% values. I found out that for the most parts it is accurately aligns with
% each other. However, the difference in case 3 for probability between
% simulation error of ml and theorical error of ml is noticed, but i dont
% know whether there is an error in the code(because all the other ones aligns 
% with each other) or is it just that MAP as a decision theory is just more
% accurate, which i believe the first case more. 



function [erroraverage_map, erroraverage_ml] = simulation (b1, r1, b2, r2, desicion_map, desicion_ml)
    N = 10^5;
    map_errors = 0;
    ml_errors = 0; 
    urn_1 = 0; 
    urn_2 = 0; 
    chose_urn_1 = 0;
    chose_urn_2 = 0; 
    for i = 1:N
        urn_1 = [ones(1, b1), 2 * ones(1, r1)]; 
        chose_urn_1 = urn_1(randi(length(urn_1)));
        urn_2 = [ones(1, b2 + (chose_urn_1 == 1)), 2 * ones(1, r2 + (chose_urn_1 == 2))];
        chose_urn_2 = urn_2(randi(length(urn_2)));
    if chose_urn_2 == 1
        
        if desicion_map(1) ~= chose_urn_1
            map_errors = map_errors + 1;

        end
        if desicion_ml(1) ~= chose_urn_1
            ml_errors = ml_errors + 1;
        end
    end
    if chose_urn_2 == 2
       
        if desicion_map(2) ~= chose_urn_1
            map_errors = map_errors + 1;
        end
         if desicion_ml(2) ~= chose_urn_1
            ml_errors = ml_errors + 1;
        end
    end
    end
    erroraverage_map = map_errors/N;
    erroraverage_ml = ml_errors/N;

end

function [desicion_map, desicion_ml, Pe_map, Pe_ml] = process(b1, r1, b2, r2)

prior_r1 = r1 / (r1 + b1);
prior_b1 = b1 / (r1 + b1);


likelihood_R2_g_R1 = (r2 + 1) / (r2 + 1 + b2); 
likelihood_B2_g_R1 = b2 / (b2 + r2 + 1);
likelihood_R2_g_B1 = r2 / (r2 + b2 + 1);
likelihood_B2_g_B1 = (b2 + 1) / (b2 + 1 + r2); 


posterior_R1_g_R2 = (likelihood_R2_g_R1 * prior_r1)/(likelihood_R2_g_R1 * prior_r1 + likelihood_R2_g_B1 * prior_b1);
posterior_R1_g_B2 = (likelihood_B2_g_R1 * prior_r1)/(likelihood_B2_g_R1 * prior_r1 + likelihood_B2_g_B1 * prior_b1);
posterior_B1_g_R2 = (likelihood_R2_g_B1 * prior_b1)/(likelihood_R2_g_R1 * prior_r1 + likelihood_R2_g_B1 * prior_b1); 
posterior_B1_g_B2 = (likelihood_B2_g_B1 * prior_b1)/(likelihood_B2_g_R1 * prior_r1 + likelihood_B2_g_B1 * prior_b1);

desicion_map = [0,0];
desicion_ml = [0,0];


if posterior_R1_g_B2 > posterior_B1_g_B2
    desicion_map(1) = 2; 
else 
    desicion_map(1) = 1;
end


if posterior_B1_g_R2 > posterior_R1_g_R2
    desicion_map(2) = 1;
else 
    desicion_map(2) = 2;
end


if likelihood_R2_g_B1 > likelihood_B2_g_B1
    desicion_ml(1) = 1;
else
    desicion_ml(1) = 2;
end


if likelihood_B2_g_R1 > likelihood_R2_g_R1
    desicion_ml(2) = 1;
else 
    desicion_ml(2) = 2;
end

if desicion_map(1) == 1
    P_e1 = 1-likelihood_B2_g_B1;
else
    P_e1 = 1-likelihood_R2_g_B1; 
end

if desicion_map(2) == 1
    P_e2 = 1-likelihood_B2_g_R1;
else
    P_e2 = 1-likelihood_R2_g_R1; 
end
Pe_map = P_e1*prior_b1+P_e2*prior_r1;

if desicion_ml(1) == 1
    P_e1 = 1-likelihood_B2_g_B1;
else
    P_e1 = 1-likelihood_R2_g_B1; 
end

if desicion_ml(2) == 1
    P_e2 = 1-likelihood_B2_g_R1;
else
    P_e2 = 1-likelihood_R2_g_R1; 
end
Pe_ml = P_e1*prior_b1+P_e2*prior_r1;

%P_e = P_e1*prior_b1 + P_e2*prior_r1
%P_etest = prior_r1 * likelihood_B2_g_R1 + prior_b1 * likelihood_R2_g_B1
end

% No, ml decisions are NOT based on distribution of balls in Urn I, since
% the decision is comparing the likelihood of drawing either a red or 
% a blue ball based on given that Urn I drew red or blue, where the ball
% drew from Urn I is already given. It is a pre-assumption of happening already
% Maybe, there will be a problem when there is zero balls in Urn I for
% eiter color. Furthermore, let's take a look at the equation for
% likelihood: likelihood_R2_g_R1 = (r2 + 1) / (r2 + 1 + b2);, r1 or b1 is
% not even involed in this equation. 


%% PART F

% Yes, for map decisions, it is based on the distribution of balls in Urn
% I, because the given value is event R2 or B2. It is pre-assumpped that
% event R2 or B2 and finding the probability of Urn I for either color.
% Lets look at the posterior equation: posterior_R1_g_R2 = (likelihood_
% R2_g_R1 * prior_r1)/(likelihood_R2_g_R1 * prior_r1 + likelihood_R2_g_B1 * prior_b1);
% prior of r1 or b1 is heavily involved in this equation, therefore, the
% change in the distrubtion would change the decision that is made in MAP. 

