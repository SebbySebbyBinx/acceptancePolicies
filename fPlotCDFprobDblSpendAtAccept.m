function fPlotCDFprobDblSpendAtAccept( lambda, alpha, arrInitAttLead, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )
    %plot the CDF of p_{Double Spend} at transaction acceptance
    setupForCalcAndPlot;

    tMax = staticPolicyConf/lambda*20;
    arrT = 0:.05:tMax;

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [expProbDblSpendStatic, ~, ~ ] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, expProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );    
    
    [~, ~, CDFprobDblSpendAtAcceptStatic] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [~, ~, CDFprobDblSpendAtAcceptDynamic] = fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );


    fig = figure('Name', ['CDFprobDblSpendAtAccept']);
    hold all;
    plot( CDFprobDblSpendAtAcceptDynamic(1,:), CDFprobDblSpendAtAcceptDynamic(2,:), dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Dynamic Policy - {\it p}_{DoubleSpend} < ' num2str(100*probDblSpendMax,4) '%' ]);
    plot( CDFprobDblSpendAtAcceptStatic(1,:), CDFprobDblSpendAtAcceptStatic(2,:), staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Static Policy - ' num2str(staticPolicyConf) ' confirmations']);

    lgd = legend('show','Location','SouthEast');
    title(lgd,['Policies with E[{\it p}_{Double Spend}] = ' , num2str(100*expProbDblSpendStatic,4) '%']);
    xlabel('{\it p}_{Double Spend} at transaction acceptance');
    xlim([0,min(1,5*expProbDblSpendStatic)]);
    ylabel('CDF of {\it p}_{Double Spend} at acceptance');
    ylim([0,1]);
    title({['CDF of {\it p}_{Double Spend} At Transaction Acceptance']})
    fSetPlotSizeAndSave();
end