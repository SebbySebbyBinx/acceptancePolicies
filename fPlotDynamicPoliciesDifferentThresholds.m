function fPlotDynamicPoliciesDifferentThresholds( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, epsilonPolicyTime)
    %dynamic policy for different double spend threshholds
    setupForCalcAndPlot

    fig = figure('Name', ['dynamicPoliciesDifferentThresholds']);
    hold all;

    confRequired = length(arrT);
    maxConf = 0;
    count = 1;
    for pDoubleSpendMax = arrProbDblSpendMax
        matPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), pDoubleSpendMax, epsilonPolicyTime ); 
        j=1;
        for t = arrT
            confRequired( j ) = fConfRequired( matPolicy, t );
            j = j+1;
        end    
        plot( arrT, confRequired, dynamicPolicyLineType, 'color', (1 - 1*(count-1)/length(arrProbDblSpendMax))*dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', [' p_{Double Spend} < ' num2str(100*pDoubleSpendMax,4) '%']);
        maxConf = max( maxConf, max(confRequired));
        count = count + 1;
    end

    lgd = legend('show','Location','NorthWest');
    title(lgd,'Dynamic Policies');
    xlabel('time since transaction broadcast (minutes)');
    ylabel('confirmations required');
    ylim([0 maxConf + 1])
    title({'Number of Confirmations Required Vs. Time Since Transaction Broadcast';['To Guarantee {\it p}_{Double Spend} Below A Threshhold Assuming \alpha = ', num2str(alpha)]})
    fSetPlotSizeAndSave();
end