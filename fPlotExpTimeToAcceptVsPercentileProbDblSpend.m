function fPlotExpTimeToAcceptVsPercentileProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf, percentile, epsilonPolicyTime)
    % plots expected time to acceptance vs expected probability of double spend
    setupForCalcAndPlot

    expTimeToAcceptDynamic = zeros(1,length(arrProbDblSpendMax));
    percentileProbDblSpendDynamic = zeros(1,length(arrProbDblSpendMax));
    count = 1;
    for pDoubleSpendMax = arrProbDblSpendMax
        fprintf('pDoubleSpendMax = %f\n',pDoubleSpendMax)
        dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), pDoubleSpendMax, epsilonPolicyTime ); 
        [~, expTimeToAcceptDynamic(count), CDFprobDblSpendAtAcceptDynamic]= fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );
        percentileProbDblSpendDynamic(count) = fPercentileProbDblSpend( CDFprobDblSpendAtAcceptDynamic, percentile );
        count = count + 1;
    end

    expTimeToAcceptStatic = zeros(1,length(arrStaticPolicyConf));
    percentileProbDblSpendStatic = zeros(1,length(arrStaticPolicyConf));
    count = 1;
    for staticPolicyConf = arrStaticPolicyConf
        fprintf('Static policy that wait for  %i confirmations \n', staticPolicyConf)
        staticPolicy = [0 max(arrT); staticPolicyConf staticPolicyConf]; 
        [~, expTimeToAcceptStatic(count), CDFprobDblSpendAtAcceptStatic]= fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
        percentileProbDblSpendStatic(count) = fPercentileProbDblSpend( CDFprobDblSpendAtAcceptStatic, percentile );    
        count = count + 1;    
    end

    fig = figure('Name', ['expectedTimeToAcceptVsPercentileProbDblSpend']);
    hold all;
    plot( percentileProbDblSpendDynamic, expTimeToAcceptDynamic, [dynamicPolicyLineType], 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', 'Dynamic')
    stairs( fliplr(percentileProbDblSpendStatic), fliplr(expTimeToAcceptStatic), [staticPolicyLineType 'o'], 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', 'Static')

    lgd = legend('show','Location','NorthEast');
    title(lgd,'Policy Type');
    xlabel([num2str(percentile) '^{th} percentile of {\it p}_{Double Spend}']);
    ylabel('E[time to transaction acceptance]');
    xlim([0 .1])
    title({['E[Time To Transaction Acceptance] vs. ' num2str(percentile) '^{th} percentile of {\it p}_{Double Spend}'] ['Assuming \alpha = ', num2str(alpha)]})
    ylim_curr = get(gca,'ylim');
    set(gca, 'ylim', [0 ylim_curr(2)]);
    fSetPlotSizeAndSave();
end

