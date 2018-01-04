function fPlotProbDblSpendVsTimeForDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime)
    %Probability of Double Spend vs. Total Time For Transaction Acceptance for
    %a dynamic policy
    setupForCalcAndPlot

    dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMax, epsilonPolicyTime ); 

    arrProbDblSpend = zeros(1,length(arrT));
    count = 1;
    for T=arrT
        arrProbDblSpend(count) = fProbDblSpend( lambda, alpha, arrInitAttLead, T, fConfRequired( dynamicPolicy, T ) );
        count = count + 1;
    end

    fig = figure('Name', ['probDblSpendVsTimeForDynamicPolicy']);
    hold all;
    plot( arrT, arrProbDblSpend, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Dynamic - {\it p}_{Double Spend} < ', num2str(100*probDblSpendMax,4) '%'])
    lgd = legend('show','Location','southeast');
    title(lgd,['Policies']);
    title({['Double Spend Probability vs. Time From Broadcast To Transaction Acceptance'],['Assuming A Dymamic Policy Where {\it p}_{Double Spend} <  ', num2str(100*probDblSpendMax,4) '% and \alpha = ', num2str(alpha)],[]})
    xlabel('time from transaction broadcast to acceptance (minutes)');
    ylabel('{\it p}_{Double Spend}');
    ylim([0 probDblSpendMax*1.1])
    fSetPlotSizeAndSave()
end