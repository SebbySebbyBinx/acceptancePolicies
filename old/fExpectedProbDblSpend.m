function expectedProbDblSpend = fExpectedProbDblSpend( lambda, alpha, arrDistOfInitAttLead, policy, arrT )
 
    arrCDFofConfirm = fCDFtimeToAccept( lambda, alpha, policy, arrT );
    
    count = 1;
    for T=arrT
        arrProbDoubleSpend(count) = fProbDoubleSpend( lambda, alpha, arrDistOfInitAttLead, T, fConfRequired( policy, T ) );
        count = count + 1;
    end
    
    expectedProbDblSpend = 0;
    count = 1;
    probCount = 0;
    for T = arrT(1:end)
        expectedProbDblSpend = expectedProbDblSpend + (arrCDFofConfirm(count) - probCount)*arrProbDoubleSpend(count);
        probCount = arrCDFofConfirm(count);
        count = count + 1;
    end

end
