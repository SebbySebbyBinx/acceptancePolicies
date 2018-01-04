function expectedValue = fExpectedValue( arrCDF, arrValues )
    % this function takes in a *sampled* CDF and a corresponding array of
    % values
    % returns an estimate for the expected value

    % find the PDF from the CDF
    arrPDF = diff( [0 arrCDF] );
    
    % arrCDF is a *sampled* CDF, and so we need to account for the sampling
    % error. If sampling is frequent enough, arrValues can be approximated 
    % as changing linearly within a sampling interval.
    % So an estimate for average value in that interval is just the
    % average of the current value and the previous value (except for the
    % first value which stays the same).
    arrModValues = (arrValues + [arrValues(1) arrValues(1:end-1)])/2;
    
    % expected value is the weighted average of the values and their
    % corresponding probabilities
    expectedValue = dot(arrPDF, arrModValues);
end