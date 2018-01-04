function fPlotPoliciesWithSameExpectedProbDblSpend( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime)
    % plots expected time to acceptance vs expected probability of double spend
    setupForCalcAndPlot

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [expProbDblSpendStatic, ~, ~ ] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, expProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );    
        
    
    confRequiredStatic = zeros(1,length(arrT));
    confRequiredDynamic = zeros(1,length(arrT));

    count = 1;
    for t = arrT
        confRequiredStatic( count ) = fConfRequired( staticPolicy, t );
        confRequiredDynamic( count ) = fConfRequired( dynamicPolicy, t );
        count = count + 1;
    end
    maxConf = max( [staticPolicy(2,:) dynamicPolicy(2,:)] );

    %%% Can also compare with policy that waits fixed time

    fig = figure('Name', ['policiesWithSameExpectedProbDblSpend']);
    hold all;
    plot( arrT, confRequiredDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic - {\it p}_{Double Spend} < ' num2str(100*probDblSpendMax,4) '%']);
    plot( arrT, confRequiredStatic, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Static - ' num2str(staticPolicyConf) ' confirmations']);

    lgd = legend('show','Location','NorthWest');
    title(lgd,['Policies with E[{\it p}_{Double Spend}] = ' , num2str(100*expProbDblSpendStatic,4) '%']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('confirmations required');
    ylim([0 maxConf + 1]);
    title({['Number of Confirmations Required Vs. Time Since Transaction Broadcast'];['For Policies With  E[{\it p}_{Double Spend}] = ', num2str(100*expProbDblSpendStatic,4), '% Assuming \alpha = '  num2str(alpha)]})
    fSetPlotSizeAndSave();
end
