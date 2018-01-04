function [expectPDoubleSpend, expectTimeWaited] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, numIter )
    if matPolicy(:,1) == [0;0]
        expectPDoubleSpend = fProbDoubleSpend( lambda, alpha, arrDistOfInitAttLead, 0, 0 );
        expectTimeWaited = 0;
    else
        cummPDoubleSpend = 0; cummTimeWaited = 0; count = 0;
        tMax = matPolicy(2,end);
        for i = 1:numIter
            t=0; arrivals = 0;
            while t < tMax
                t = t + exprnd(1/(lambda*(1-alpha)));
                arrivals = arrivals + 1;
                if arrivals >= matPolicy( 1, find( matPolicy(2,:) > t, 1)-1)
                    cummPDoubleSpend = cummPDoubleSpend + fProbDoubleSpend( lambda, alpha, arrDistOfInitAttLead, t, arrivals );
                    cummTimeWaited = cummTimeWaited + t;
                    count = count + 1;
                    break;
                end  
            end
        end
        expectPDoubleSpend = cummPDoubleSpend/count; expectTimeWaited = cummTimeWaited/count;
    end

end