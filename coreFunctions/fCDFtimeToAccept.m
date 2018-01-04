function arrCDFofConfirm = fCDFtimeToAccept( lambda, alpha, policy, arrT )
    fCheckArguments( policy, arrT );
    arrCDFofConfirm = zeros(1, length(arrT));
    initProbVectAtDepth = [1 0];
    
    arrConfirmRequired = sort(unique(policy(2,:)));
    if arrConfirmRequired(end) ~= Inf
        maxNonInfConfirmRequired =  arrConfirmRequired( end );
    else
        maxNonInfConfirmRequired =  arrConfirmRequired( end - 1 );
    end
    
    count = 1;
    for depth = 1:length( policy )-1
        % reshape the initProbVectAtDepth to account for the confirmations
        % required for this depth in the policy
        initProbVectAtDepth = fSetProbVectLength( initProbVectAtDepth, min( policy( 2, depth ), maxNonInfConfirmRequired + 1) );
        tStart = policy(1,depth);
        tEnd = policy(1,depth+1);
        if tEnd == max( arrT )
            tEnd = tEnd + 1;
        end
        
        t = arrT( (tStart <= arrT) & (arrT < tEnd) );
        if policy( 2, depth ) ~= Inf
            arrCDFofConfirm(count:(count+length(t)-1)) = fProbAcceptAtT( alpha, lambda, initProbVectAtDepth, t - tStart );
        else
            if count == 1
                arrCDFofConfirm(count:(count+length(t)-1)) = zeros(1,length(t)); 
            else
                arrCDFofConfirm(count:(count+length(t)-1)) = ones(1,length(t))*arrCDFofConfirm(count-1);
            end
        end
        count = count + length(t);
        
        % determine what initProbVectAtDepth is right before the policy
        % changes.
        initProbVectAtDepth = fProbVectAtT( alpha, lambda, initProbVectAtDepth, tEnd - tStart );      
    end
       
end


    function probVect = fSetProbVectLength( prevProbVect, numConfirmsRequired )
        probVect = zeros(1, numConfirmsRequired + 1);
        prevNumConfirmsRequired = length( prevProbVect ) - 1;

        for i=1:min( numConfirmsRequired, prevNumConfirmsRequired )
            probVect( i ) = prevProbVect( i );
        end
        
        probVect( end ) = 1 - sum( probVect(1:end-1) );
    end
    
    function probConfAtT = fProbAcceptAtT( alpha, lambda, initProbVect, arrT )
        probConfAtT = 0;
        lengthVect = length( initProbVect );     
        for i=1:lengthVect
            probConfAtT = probConfAtT + initProbVect(i)*(1 - poisscdf(lengthVect - i - 1, arrT*(1-alpha)*lambda));
        end
    end
    
    function probVectAtT = fProbVectAtT( alpha, lambda, initProbVect, t )
        probVectAtT = zeros(1, length(initProbVect));
        for i=1:(length(initProbVect)-1)
            tempVect = [zeros(1, i - 1)  poisspdf( (0:length(initProbVect) + -i + -1), t*(1-alpha)*lambda) 0];
            probVectAtT = probVectAtT + initProbVect(i)*tempVect;
        end     
        probVectAtT(end) = fProbAcceptAtT( alpha, lambda, initProbVect, t );
    end       

    function fCheckArguments( policy, arrT )
        if policy(1,end) < max(arrT)
            error( 'arrT in fCDFofConfirm extends beyond policy! i.e. the policy is not defined far out in time enough');
        end
    end