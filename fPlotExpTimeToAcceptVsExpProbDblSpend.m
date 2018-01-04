function fPlotExpTimeToAcceptVsExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf,  epsilonPolicyTime)
    % plots expected time to acceptance vs expected probability of double spend
    setupForCalcAndPlot

    expTimeToAcceptDynamic = zeros(1,length(arrProbDblSpendMax));
    expProbDblSpendDynamic = zeros(1,length(arrProbDblSpendMax));
    count = 1;
    for pDoubleSpendMax = arrProbDblSpendMax
        fprintf('pDoubleSpendMax = %f\n',pDoubleSpendMax)
        dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), pDoubleSpendMax, epsilonPolicyTime ); 
        [expProbDblSpendDynamic(count), expTimeToAcceptDynamic(count), ~]= fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );
        count = count + 1;
    end

    expTimeToAcceptStatic = zeros(1,length(arrStaticPolicyConf));
    expProbDblSpendStatic = zeros(1,length(arrStaticPolicyConf));
    count = 1;
    for staticPolicyConf = arrStaticPolicyConf
        fprintf('Static policy that wait for  %i confirmations \n', staticPolicyConf)
        staticPolicy = [0 max(arrT); staticPolicyConf staticPolicyConf]; 
        [expProbDblSpendStatic(count), expTimeToAcceptStatic(count), ~]= fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
        count = count + 1;    
    end
    

    fig = figure('Name', ['expectedTimeToAcceptVsExpectedProbDblSpend']);
    hold all;
    plot( expProbDblSpendDynamic, expTimeToAcceptDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', 'Dynamic')
    stairs( fliplr(expProbDblSpendStatic), fliplr(expTimeToAcceptStatic), [staticPolicyLineType 'o'], 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', 'Static')

    lgd = legend('show','Location','NorthEast');
    title(lgd,'Policy Type');
    xlabel('E[{\it p}_{Double Spend}]');
    ylabel('E[time to transaction acceptance]');
    xlim([0 .1])
    title({['E[Time To Transaction Acceptance] vs. E[{\it p}_{Double Spend}]'] ['Assuming \alpha = ', num2str(alpha)]})
    fSetPlotSizeAndSave();
end

