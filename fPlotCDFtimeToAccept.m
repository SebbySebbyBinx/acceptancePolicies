function fPlotCDFtimeToAccept(  lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )
    %CDF of time to acceptance for a static and dynamic policy
    setupForCalcAndPlot

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [expProbDblSpendStatic, ~, ~ ] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, expProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );    
    
    arrCDFofConfirmStatic = fCDFtimeToAccept( lambda, alpha, staticPolicy, arrT );
    arrCDFofConfirmDynamic = fCDFtimeToAccept( lambda, alpha, dynamicPolicy, arrT );

    fig = figure('Name', ['CDFtimeToAccept']);
    hold all;

    plot( arrT, arrCDFofConfirmDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic Policy - {\it p}_{Double Spend} < ' num2str( 100 * probDblSpendMax, 4 ) '%'] );
    plot( arrT, arrCDFofConfirmStatic, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Static Policy - ' num2str(staticPolicyConf) ' confirmations'] );

    lgd = legend('show','Location','SouthEast');
    title(lgd,['Policies with E[{\it p}_{Double Spend}]  = ' , num2str(100*expProbDblSpendStatic,4) '%']);
    xlabel('time since transaction broadcast (minutes)');

    ylabel('CDF of time to acceptance');
    ylim([0 1])
    title({'CDF of Time To Transaction Acceptance For A Static and Dynamic Policy'; ['Assuming \alpha = ' num2str(alpha)]})
    fSetPlotSizeAndSave();
end