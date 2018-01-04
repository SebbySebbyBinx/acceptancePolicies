function fPlotProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )
    % plot the probability a double spend has occured vs time since transaction
    % broadcast for an equivalent static and dynamic policy
    setupForCalcAndPlot;

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [expectedProbDblSpendStatic, ~, ~ ] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, expectedProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );


    [ arrProbDblSpendOccuredStatic ] = fProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [ arrProbDblSpendOccuredDynamic ] = fProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );

    fig = figure('Name', 'probDblSpendOccuredVsTime');
    hold all;
    plot( arrT, arrProbDblSpendOccuredDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Dynamic Policy - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%' ]);
    plot( arrT, arrProbDblSpendOccuredStatic, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Static Policy - ' num2str(staticPolicyConf) ' confirmations']); 

    
    lgd = legend('show','Location','SouthEast');
    title(lgd,['Policies with E[{\it p}_{Double Spend}] = ' , num2str(100*expectedProbDblSpendStatic,4) '%']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('probability a double spend has occured');
    title({['Probability a Double Spend Has Occured vs. Time Since Transaction Broadcast']; ['Assuming \alpha = ', num2str(alpha)]})
    fSetPlotSizeAndSave();
end


