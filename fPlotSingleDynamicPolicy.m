function fPlotSingleDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime )
    % plot a single dynamic policy 
    setupForCalcAndPlot;

    
    dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMax, epsilonPolicyTime ); 

    
    arrConfRequired = zeros(1,length(arrT));    
    count = 1;
    for T = arrT
        arrConfRequired( count ) = fConfRequired( dynamicPolicy, T );
        count = count + 1;
    end 
    maxConf = max(arrConfRequired);
    
    
    fig = figure('Name', ['singleDynamicPolicy']);
    plot( arrT, arrConfRequired, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%']);
    

    lgd = legend('show', 'location', 'southeast');
    title(lgd,['Policy']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('confirmations required');
    ylim([0 maxConf + 1]);
    title({['Number of Confirmations Required Vs. Time Since Transaction Broadcast'];['To Guarantee {\it p}_{Double Spend} < ', num2str(100*probDblSpendMax,4), '% Assuming \alpha = '  num2str(alpha)]})
    fSetPlotSizeAndSave();
end





