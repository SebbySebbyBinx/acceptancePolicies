function [dynamicPolicy, probDblSpendMax]= fFindDynamicPolicyGivenPercentile( lambda, alpha, arrInitAttLead, arrT, percentile, percentileProbDblSpendTarget, epsilonProbDblSpend, epsilonPolicyTime )
    % this function returns a dynamic policy that has the same expected
    % probability of double spend compared to a static policy.

    
    % via binary search, determine the appropriate maximum double spend for
    % the dynamic policy
    fprintf('Finding dynamic policy with the %ith percentile of double spend probability equal to %f \n', percentile, percentileProbDblSpendTarget);
    fprintf('Stopping when expected double spend probability is within %f of target \n',  epsilonProbDblSpend);
    fprintf('Difference in double spend probability and target: ');
    probDblSpendMaxLow = 0; probDblSpendMaxHigh = 1;
    percentileProbDblSpendDynamic = Inf;
    while  ( abs(percentileProbDblSpendDynamic - percentileProbDblSpendTarget) > epsilonProbDblSpend) 
        probDblSpendMaxMid = (probDblSpendMaxLow + probDblSpendMaxHigh)/2;
        dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMaxMid, epsilonPolicyTime );
        
        [~, ~, CDFprobDblSpendAtAcceptDynamic] = fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );
        percentileProbDblSpendDynamic = fPercentileProbDblSpend( CDFprobDblSpendAtAcceptDynamic, percentile );
        
        if percentileProbDblSpendDynamic < percentileProbDblSpendTarget
            probDblSpendMaxLow = probDblSpendMaxMid;
        else 
            probDblSpendMaxHigh = probDblSpendMaxMid;
        end
        fprintf('%f ', percentileProbDblSpendDynamic - percentileProbDblSpendTarget );
        if (probDblSpendMaxHigh - probDblSpendMaxLow) < 4*eps(probDblSpendMaxMid)
            error('Did not find an equivalent policy'); 
        end
    end
    probDblSpendMax = probDblSpendMaxMid;
    fprintf('\n');
    
end