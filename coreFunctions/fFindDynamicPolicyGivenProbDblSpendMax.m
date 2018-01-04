function dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, tMax, pDoubleSpendMax, epsilonPolicyTime )

    minConfirms = 0;
    while pDoubleSpendMax < fProbDblSpend( lambda, alpha, arrInitAttLead, 0, minConfirms )
        minConfirms = minConfirms + 1;
    end

    maxConfirms = 0;
    while pDoubleSpendMax < fProbDblSpend( lambda, alpha, arrInitAttLead, tMax, maxConfirms )
        maxConfirms = maxConfirms + 1;
    end
    
    dynamicPolicy(2,:) = minConfirms:maxConfirms;
    dynamicPolicy(1,1) = 0;
    
    lower = 0; 
    count = 2;
    for confirmRqd = (minConfirms+1):maxConfirms
        %find the first time for which the number of confirmation required
        %is confirmRqd
        upper = tMax;
        while abs( upper - lower ) > epsilonPolicyTime
            if pDoubleSpendMax < fProbDblSpend( lambda, alpha, arrInitAttLead, (upper+lower)/2, confirmRqd - 1 )
                upper = (upper+lower)/2;
            else
                lower = (upper+lower)/2;
            end            
        end
        dynamicPolicy(1,count) = (upper+lower)/2;
        lower = (upper+lower)/2;
        count = count + 1;
    end
    
    dynamicPolicy(:,end + 1) = [tMax; maxConfirms];

end