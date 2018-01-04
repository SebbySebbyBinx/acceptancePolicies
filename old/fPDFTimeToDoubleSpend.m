function [ distMainChainLead ] = fPDFTimeToDoubleSpend( matPolicy, lambda, alpha, arrDistOfInitAttLead, numIter )

    iter = 0;
    nMax = matPolicy(1,end);
    tMaxPolicy = matPolicy(2,end);
    sampleMainChainLead = zeros(1,numIter);
    sampleMainChainTime = zeros(1,numIter);
    for i = 1:numIter
        t = 0; mainChainArrivals = 0; attackerChainArrivals = 0; policyIndex = 1;
        
        randomVal = rand(); count = 1;
        while randomVal > sum( arrDistOfInitAttLead(1:count) )
            attackerChainArrivals = attackerChainArrivals + 1;
            count = count + 1;
        end

        while t < tMaxPolicy

            policyIndex = 1;
            while matPolicy(2, policyIndex + 1 ) < t
                policyIndex = policyIndex + 1;
            end
            mainChainArrivalsReqd = matPolicy(1,policyIndex);
            
            if mainChainArrivals >= mainChainArrivalsReqd
                iter = iter + 1;
                sampleMainChainLead(iter) = mainChainArrivals - attackerChainArrivals;
                sampleMainChainTime(iter) = t;
                break;
            end

            timeToNextMainChainBlock = exprnd(1/(lambda*(1-alpha)));
            
            t = t + timeToNextMainChainBlock;
            mainChainArrivals = mainChainArrivals + 1;
            attackerChainArrivals = attackerChainArrivals + poissrnd( timeToNextMainChainBlock * (lambda*alpha) );
            
            if t > tMaxPolicy            
               't > tMaxPolicy - Policy not defined for long enough time - results will be INCORRECT' 
               break;
            end
        end

    end
    
    
    sampleMainChainLead = sampleMainChainLead(1:iter);
    sampleMainChainTime = sampleMainChainTime(1:iter);
    
    
    distMainChainLead = zeros(1, max(sampleMainChainLead) + 2);
    for i=1:length(sampleMainChainLead)
        if sampleMainChainLead(i) < 0
            distMainChainLead(1) = distMainChainLead(1) + 1;
        else
            distMainChainLead( sampleMainChainLead(i) + 2 ) = distMainChainLead( sampleMainChainLead(i) + 2 ) + 1;     
        end
    end
    distMainChainLead = distMainChainLead / sum( distMainChainLead );
       

 
    
    numStates = 100;
    if numStates < length(distMainChainLead)
        'numStates < length(distMainChainLead)'
    end
    Q = zeros( numStates, numStates );
    
    for i=1:numStates
        if i ~= 1
            Q(i, i-1) = lambda*alpha;
            Q(i, i) = -lambda;
            Q(i, i+1) = lambda*(1-alpha);
        end
    end
    Q = Q(:,1:numStates);
    arrT = 0:1:500;    
    arrProbDblAtT = zeros(1,length(arrT));
    count = 1;
    Qresults = zeros( length(distMainChainLead), length(arrT));
    count = 1;
    for t = arrT
        expQ = expm( Q*t );
        firstColumnOfExpQ = expQ(:,1);
        Qresults(:,count) = firstColumnOfExpQ( 1:length(distMainChainLead) );
        count = count + 1;
    end
    
    count = 1;
    for t = arrT
        t
        for i=1:length(distMainChainLead)
            if i==1
                indices = find( sampleMainChainLead < 0 );
            else
                indices = find( sampleMainChainLead == i-1 );
            end
            
            results = 0;
            for j=1:length(indices)
                if t - sampleMainChainTime(indices(j)) > 0
                    results = results + Qresults(i, fTimeToIndex(t - sampleMainChainTime( indices(j)), arrT ));
                end
            end
            if length(indices) > 0
                results = results / length(indices);
            end
            
            arrProbDblAtT(count) = arrProbDblAtT(count) + distMainChainLead(i)*results;
        end          
        
        %distMainChainLead = [distMainChainLead, zeros(1,numStates - length(distMainChainLead))];
        count = count + 1;
    end
    

    plot(arrT, arrProbDblAtT, 'lineWidth', 3 )
    
    [expectPDoubleSpend, expectTimeWaited, sampleProbDoubleSpend] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, numIter );
    expectPDoubleSpend
    expectTimeWaited
    mean(sampleMainChainTime)
    
end


function index = fTimeToIndex( t, arrT )
    index = find( t <= arrT, 1, 'first' );
end