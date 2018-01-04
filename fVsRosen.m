function matProbDblSpend = fVsRosen()
    % This function compares the results from Rosenfelds paper: https://arxiv.org/pdf/1402.2009.pdf
    % to the results obtained by using the formulas for double spending I
    % created. Note that Rosenfeld calculated the probability of double spend
    % as a function of the number of confirmations, not time. 

    lambda = .1;

    % From Rosenfeld:
    %Once n blocks are found by the honest network, in a period of time during which m + 1
    %blocks are found by the attacker (we assume one block was pre-mined by the attacker before
    %commencing the attack)
    arrInitAttLead = [0 1];

    arrN = 1:10;
    arrAlpha = .02:.02:.5;
    matProbDblSpend = zeros( length(arrAlpha), length(arrN) );

    increment = .01;
    % enumerate over different policies from waiting for 1 to 10 blocks
    for N = arrN
       tMax = N*10*30 + 1000; %we assume all transactions are confirmed and the double spend has occured within this many minutes of broadcast
       arrT = [0:increment:tMax];
       policy = [0 tMax; N N]; %construct the policy. Wait N confirmations regardless of time, until tMax


       count = 1;       
       for alpha = arrAlpha    %alpha represents the amount of hashrate the attacker has
            [expectedProbDblSpend, ~, ~]= fPolicyProperties( lambda, alpha, arrInitAttLead, policy, arrT );
            %the above function calculates expected probability of double spend
            %for the policy and attack parameters

            matProbDblSpend(count,N) = expectedProbDblSpend;
            disp(matProbDblSpend);
            count = count + 1;
        end
    end
end

