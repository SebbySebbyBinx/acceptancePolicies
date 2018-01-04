function [ probDoubleSpend ] = fProbDblSpend( lambda, alpha, arrInitAttLead, T, N )
    %this function finds the probability of double spend assuming the main
    %chain grows at rate lambda during normal operation when the attacker
    %is honest.
    
    %Assume:
    %the attacker has alpha fraction of the hashpower
    %transaction acceptance took T minutes and had N confirmations
    %arrInitAttLead - attackers initial distribution over starting states. e.g. [1]
    %means the attacker starts mining when transaction is broadcast, and [0
    %1] means the attacker starts one block ahead

    %ensure the attacker distribution is a distribution (i.e. sums up to
    %one)
    if sum( arrInitAttLead ) ~= 1
        error('Initial attacker lead probabilities must sum to 1')
    end
    %Ensure T is non-negative
    if T < 0
        error('T must be non-negative')
    end
    %Ensure N is non-negative
    if N < 0
        error('N must be non-negative')
    end    
    
    if N == Inf
        probDoubleSpend = 0;
        return;
    end  
    
    if isequal( arrInitAttLead, 1 )
        %special case when attacker has no head start simplifies
        %calculation
        arrAttLeadAfterAcceptance = poisspdf( 0:N, lambda*alpha*T);   
        
    else
        probNumMainChainArrivals = poisspdf( 0:N, lambda*alpha*T); 
        arrAttLeadAfterAcceptance = conv(probNumMainChainArrivals, arrInitAttLead);
        
        %we do not have to record the probablities for the number of blocks 
        %the attacker is ahead, since the double spend is guaranteed at that point
        arrAttLeadAfterAcceptance = arrAttLeadAfterAcceptance(1:N+1);
    end
        
    % arrAttLeadAfterAcceptance is p^* in the paper
    % first element of arrAttLeadAfterAcceptance corresponds to p^*_{-N}
    i=-N:1:0;
    alphaCoeffs = (alpha/(1-alpha)).^(-i+1) - 1;
    %double spend probability can be expressed as a single sum
    probDoubleSpend = 1 + dot( arrAttLeadAfterAcceptance, alphaCoeffs );
end
