function [ arrProbDblSpendOccured ] = fProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, policy, arrT )
    % function returns arrProbDblSpendOccured - the probability a
    % double spend has occured vs time

    % arrCDFtimeToAccept is the CDF of the time to transaction acceptance
    arrCDFtimeToAccept = fCDFtimeToAccept( lambda, alpha, policy, arrT );
    % arrPDFtimeToAccept is the PDF of the time to transaction acceptance
    arrPDFtimeToAccept = [0 diff(arrCDFtimeToAccept)];
    % the probability a double spend has occured vs time (arrT)
    arrProbDblSpendOccured = zeros(1, length(arrT) );
    
    % We assume that the attacker cannot get more than a certain number of
    % blocks behind, represented by the variable maxBlocksAttBehind
    % We have to make this assumption because we cannot simulate a infinite
    % birth-death chain
    maxBlocksAttBehind = 50;
    
    % arrProbAttBirthDeathChain represents a probability vector on a birth
    % death chain
    % The first element is the probability that a double spend has occured
    % and is an absorbing state
    % The second element is the probability the attacker is zero blocks behind
    % The third element is the probability the attacker is one block
    % behind, etc.
    arrProbAttBirthDeathChain = zeros(1, maxBlocksAttBehind);

    % Q represents the generator matrix for the birth-death chain
    Q = zeros( maxBlocksAttBehind, maxBlocksAttBehind );
    for i=2:maxBlocksAttBehind
        if i==maxBlocksAttBehind
            Q(i, i-1) = lambda*alpha;
            Q(i, i) = -lambda*alpha;
        else
            Q(i, i-1) = lambda*alpha;
            Q(i, i) = -lambda;
            Q(i, i+1) = lambda*(1-alpha);
        end
    end
    
    count = 1;
    arrDeltaT = diff([0 arrT]);
    for T = arrT      
        % find the amount of time elapsed since the previous loop
        deltaT = arrDeltaT(count);
        
        % Account for the fact we are discretizing a continuous processes
        T = T - deltaT/2;

        % find the number of confirmation required at time T
        confRequired = fConfRequired( policy, T );        
        
        % probAcceptAtT is the probability a transaction is accepted in
        % time interval [T-deltaT, T]
        probAcceptAtT = arrPDFtimeToAccept(count);        
    
        % add probAcceptAtT into arrProbAttBirthDeathChain
        % if the attacker has found more blocks than the confirmations
        % required at the time of acceptance, a double spend has occured 
        arrProbAttBirthDeathChain(1) = arrProbAttBirthDeathChain(1) + probAcceptAtT*(1 - poisscdf(confRequired, lambda*alpha*T));
        % attBlockDist is the distribution blocks the attacker has found
        % from 0 to confRequired
        attBlockDist = fliplr( poisspdf( 0:confRequired, lambda*alpha*T) );
        arrProbAttBirthDeathChain(2:2+confRequired) = arrProbAttBirthDeathChain(2:2+confRequired) + probAcceptAtT * attBlockDist;
            
        % update arrProbAttBirthDeathChain by how it changed over deltaT
        % time
        % use results from continuous time Markov chains. Transient involve
        % *matrix exponentials* (different from regular exponentials
        arrProbAttBirthDeathChain = arrProbAttBirthDeathChain*expm( Q*deltaT );
        
        % arrProbDblSpendOccured(count) represents the probability a double 
        % has occured by timeT. This is simply the first element in arrProbAttBirthDeathChain
        arrProbDblSpendOccured(count) = arrProbAttBirthDeathChain(1);
        
        count = count + 1;
    end
        
end

