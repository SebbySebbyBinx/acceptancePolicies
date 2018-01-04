function fPlotDynamicPolicyLongTime( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime )
    % Display a single dynamic policy 
    setupForCalcAndPlot

    arrConfRequired = zeros( 1, length(arrT));
    timeBetweenPolicyChange = zeros( 1, length(arrT));
    dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead,  max(arrT), probDblSpendMax, epsilonPolicyTime ); 
    count = 1;
    for t = arrT
        confRequired = fConfRequired( dynamicPolicy, t );
        arrConfRequired( count ) = confRequired;

        firstRelevantPolicyIndex = find( dynamicPolicy(2,:) == confRequired, 1, 'first' );
        secondRelevantPolicyIndex = find( dynamicPolicy(2,:) == confRequired, 1, 'last' ) + 1;
        if (firstRelevantPolicyIndex == 1) || (secondRelevantPolicyIndex == (size(dynamicPolicy,2)+1)) %ignore policy at boundary
            timeBetweenPolicyChange( count ) = NaN;
        else
            timeBetweenPolicyChange( count ) = dynamicPolicy(1,secondRelevantPolicyIndex ) - dynamicPolicy(1,firstRelevantPolicyIndex);
        end
        count = count + 1;
    end
    maxConf = max(confRequired);

    fig = figure('Name', ['dynamicPolicyLongTime']);
    plot( arrT, arrConfRequired, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%']);
    lgd = legend('show', 'location', 'southeast');
    title(lgd,['Policies']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('confirmations required');
    ylim([0 maxConf + 1]);
    title({['Number of Confirmations Required Vs. Time Since Transaction Broadcast'];['To Guarantee {\it p}_{Double Spend} < ', num2str(100*probDblSpendMax,4), '% Assuming \alpha = '  num2str(alpha)]})
    fSetPlotSizeAndSave();

    fig = figure('Name', ['dynamicPolicyLongTimePolicyChange']);
    plot( arrT, timeBetweenPolicyChange, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%']);
    lgd = legend('show', 'location', 'southeast');
    title(lgd,['Policies']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('time between policy changes');
    title({['Time Between Dynamic Policy Changes Vs. Time Since Transaction Broadcast'];['Assuming {\it p}_{Double Spend} < ', num2str(100*probDblSpendMax,4), '% and \alpha = '  num2str(alpha)]})
    fSetPlotSizeAndSave();
end


