function [dynamicPolicy, probDblSpendMax]= fFindDynamicPolicyGivenExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, expectedProbDblSpendTarget, epsilonProbDblSpend, epsilonPolicyTime )
    % this function returns a dynamic policy that has the same expected
    % probability of double spend compared to a static policy.

    
    % via binary search, determine the appropriate maximum double spend for
    % the dynamic policy
    fprintf('Finding dynamic policy with the expected double spend probability %f \n', expectedProbDblSpendTarget);
    fprintf('Stopping when expected double spend probability is within %f of target \n',  epsilonProbDblSpend);
    fprintf('Difference in double spend probability and target: ');
    probDblSpendMaxLow = 0; probDblSpendMaxHigh = 1;
    expectedProbDblSpendDynamic = Inf;
    while  ( abs(expectedProbDblSpendDynamic - expectedProbDblSpendTarget) > epsilonProbDblSpend) 
        probDblSpendMaxMid = (probDblSpendMaxLow + probDblSpendMaxHigh)/2;
        dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMaxMid, epsilonPolicyTime );
        
        [expectedProbDblSpendDynamic, ~]= fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );
        
        if expectedProbDblSpendDynamic < expectedProbDblSpendTarget
            probDblSpendMaxLow = probDblSpendMaxMid;
        else 
            probDblSpendMaxHigh = probDblSpendMaxMid;
        end
        fprintf('%f ', expectedProbDblSpendDynamic - expectedProbDblSpendTarget );
        if (probDblSpendMaxHigh - probDblSpendMaxLow) < 4*eps(probDblSpendMaxMid)
            error('Did not find an equivalent policy'); 
        end
    end
    probDblSpendMax = probDblSpendMaxMid;
    fprintf('\n');
    
end