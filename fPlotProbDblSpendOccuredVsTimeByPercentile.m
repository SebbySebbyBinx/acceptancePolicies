function fPlotProbDblSpendOccuredVsTimeByPercentile( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, percentile, epsilonProbDblSpend, epsilonPolicyTime )
    % plot the probability a double spend has occured vs time since transaction
    % broadcast for an equivalent static and dynamic policy
    setupForCalcAndPlot;

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [~, ~, CDFprobDblSpendAtAcceptStatic ] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    percentileProbDblSpendStatic = fPercentileProbDblSpend( CDFprobDblSpendAtAcceptStatic, percentile );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenPercentile( lambda, alpha, arrInitAttLead, arrT, percentile, percentileProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );


    [ arrProbDblSpendOccuredStatic ] = fProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [ arrProbDblSpendOccuredDynamic ] = fProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );

    fig = figure('Name', 'probDblSpendOccuredVsTimeByPercentile');
    hold all;
    plot( arrT, arrProbDblSpendOccuredDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Dynamic Policy - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%' ]);
    plot( arrT, arrProbDblSpendOccuredStatic, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Static Policy - ' num2str(staticPolicyConf) ' confirmations']); 

    
    lgd = legend('show','Location','SouthEast');
    title(lgd,['Policies with ' num2str(percentile) 'th percentile {\it p}_{Double Spend} = ' , num2str(100*percentileProbDblSpendStatic,4) '%']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('probability a double spend has occured');
    title({['Probability a Double Spend Has Occured vs. Time Since Transaction Broadcast']; ['Assuming \alpha = ', num2str(alpha)]})
    fSetPlotSizeAndSave();
end


