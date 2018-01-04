function expectedTimeWaited = fExpectedTimeWaitedDynamic( T, confirmationsRequired, rate, numIter )
    totalTimeWaited = 0;
    tMax = max(T);
    for i=1:numIter
        timeWaited = tMax;
        numArrivals = poissrnd(tMax*rate);
        arrivals = sort( tMax*rand(1,numArrivals) );
        
        
        for j=1:numArrivals
            relevantTimeIndex = find(arrivals(j) < T,1);
            if  j >= confirmationsRequired( relevantTimeIndex )
                timeWaited = min( timeWaited, arrivals(j) );
            end
        end
        
        totalTimeWaited = totalTimeWaited + timeWaited;
    end
    expectedTimeWaited = totalTimeWaited/numIter;
    
    if confirmationsRequired(1) == 0
        expectedTimeWaited = 0;
    end
end