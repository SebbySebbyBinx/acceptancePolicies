function [expectPDoubleSpend, expectTimeWaited, sampleProbDoubleSpend] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, numIter )

    cummPDoubleSpend = 0; cummTimeWaited = 0; count = 0;
    nMax = matPolicy(2,end);
    tMax = matPolicy(1,end);
    sampleProbDoubleSpend = zeros(1,numIter);
    for i = 1:numIter
        t = 0; arrivals = 0; policyIndex = 1;
        while t < tMax

            policyIndex = 1;
            while matPolicy(1, policyIndex + 1 ) < t
                policyIndex = policyIndex + 1;
            end
            arrivalsReqd = matPolicy(2,policyIndex);
            
            if arrivals >= arrivalsReqd
                probDoubleSpend = fProbDoubleSpend( lambda, alpha, arrDistOfInitAttLead, t, arrivals );
                cummPDoubleSpend = cummPDoubleSpend + probDoubleSpend;
                cummTimeWaited = cummTimeWaited + t;
                count = count + 1;
                sampleProbDoubleSpend(count) = probDoubleSpend;
                break;
            end

            t = t + exprnd(1/(lambda*(1-alpha)));
            arrivals = arrivals + 1;

            if t > tMax            
               't > tMax' 
               break;
            end
        end

    end
    sampleProbDoubleSpend = sampleProbDoubleSpend(1:count);
    expectPDoubleSpend = cummPDoubleSpend/count; expectTimeWaited = cummTimeWaited/count;
end