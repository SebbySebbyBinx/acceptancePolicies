function fPlotDynamicPoliciesDifferentAlphas(  lambda, arrAlpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime )
    % Display dynamic policy for varying values of alpha
    setupForCalcAndPlot

    fig = figure('Name', 'dynamicPoliciesDifferentAlphas');
    hold all; 
    
    confRequired = length(arrT);
    maxConf = 0;
    count = 1;
    for alpha = arrAlpha
        policy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMax, epsilonPolicyTime ); 
        j=1;
        for t = arrT
            confRequired( j ) = fConfRequired( policy, t );
            j = j+1;
        end
        plot( arrT, confRequired, dynamicPolicyLineType, 'color', (1 - 1*(count-1)/length(arrAlpha))*dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', [' Assuming \alpha = ' num2str(alpha)]);
        maxConf = max( maxConf, max(confRequired));
        count = count + 1;
    end
    
    lgd = legend('show', 'location', 'northwest');
    title(lgd,['Dynamic Policies']);
    xlabel('time since transaction broadcast (minutes)');
    ylabel('confirmations required');
    ylim([0 maxConf + 1]);
    title({'Number of Confirmations Required Vs. Time Since Transaction Broadcast';['To Guarantee {\it p}_{Double Spend} < ', num2str(100*probDblSpendMax,4), '%']})
    fSetPlotSizeAndSave();
end




