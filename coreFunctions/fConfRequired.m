function confRequired = fConfRequired( matPolicy, T )
    % matPolicy contains information of how many confirmations are required
    % at a certain time after transaction broadcast
    % first row of matPolicy contains times
    % second row of matPolicy contains confirmation required
    
    relevantIndex = find( matPolicy(1,:) <= T, 1, 'last' );
    %relevantIndex holds the row number of matPolicy to be read from
    %relevantIndex is the number of the last column that is less than T
    
    confRequired = matPolicy(2,relevantIndex);
end