function [ percentileProbDblSpend ] = fPercentileProbDblSpend( CDFprobDblSpendAtAccept, percentile )
    percentileProbDblSpend = CDFprobDblSpendAtAccept(1, find(CDFprobDblSpendAtAccept(2,:) > percentile/100, 1, 'first') );
end

