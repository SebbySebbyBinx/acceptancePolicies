function [expectedProbDblSpend, expectedTimeToAccept, CDFprobDblSpendAtAccept, percentileProbDblSpend] = fPolicyProperties( lambda, alpha, arrInitAttLead, policy, arrT )

    % non-linearities occur at times when the policy changes (e.g. the
    % probability of double spend jump downwards). The following statements
    % augment the arrT time vector with additional time samples at the
    % times when policy changes, allowing for more accurate calculations
    arrTPolicyChanges = zeros(1, 3*length(policy(1,:)));
    cnt = 1;
    for cnt=1:length(policy(1,:))
        arrTPolicyChanges(cnt) = max( policy(1,cnt) - 40*eps(policy(1,cnt)) , 0);
        arrTPolicyChanges(cnt+1) = max( policy(1,cnt) - 20*eps(policy(1,cnt)) , 0);
        arrTPolicyChanges(cnt+2) = min( policy(1,cnt) + 20*eps(policy(1,cnt)) , max(arrT));
        cnt = cnt + 3;
    end
    arrT = sort( [arrT, arrTPolicyChanges] );
    
    CDFtimeToAccept = fCDFtimeToAccept( lambda, alpha, policy, arrT );
    expectedTimeToAccept = fExpectedValue( CDFtimeToAccept, arrT ); 
  
    arrProbDoubleSpend = zeros(1, length(arrT));
    cnt = 1;
    for T=arrT
        arrProbDoubleSpend(cnt) = fProbDblSpend( lambda, alpha, arrInitAttLead, T, fConfRequired( policy, T ) );
  
        cnt = cnt + 1;
    end
    expectedProbDblSpend = fExpectedValue( CDFtimeToAccept, arrProbDoubleSpend );

    PDFtimeToAccept = diff([0 CDFtimeToAccept]);
    temp = [arrProbDoubleSpend; PDFtimeToAccept];
    temp = sortrows(temp')';
    temp(2,:) = cumsum( temp(2,:) );
    CDFprobDblSpendAtAccept = [ [0 temp(1,1); 0 0] temp [1;1]];
   
end
