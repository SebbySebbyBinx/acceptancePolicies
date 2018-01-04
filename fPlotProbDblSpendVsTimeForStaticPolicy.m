function fPlotProbDblSpendVsTimeForStaticPolicy( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf)
    setupForCalcAndPlot

    N = 5;

    arrProbDblSpend = zeros(1,length(arrT));
    count = 1;
    for T=arrT
        arrProbDblSpend(count) = fProbDblSpend( lambda, alpha, arrInitAttLead, T, staticPolicyConf );
        count = count + 1;
    end

    fig = figure('Name', 'probDblSpendVsTimeForStaticPolicy');
    hold all;
    plot( arrT, arrProbDblSpend, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth', 3, 'DisplayName', ['Static - ' num2str(staticPolicyConf) ' confirmations']);
    lgd = legend('show','Location','southeast');
    title(lgd,['Policy']);
    title({['Double Spend Probability Vs. Time To Transaction Acceptance'];['Assuming Five Confirmations Waited and Attacker Has 20% of Network Hashrate']})
    xlabel( 'time from transaction broadcast to acceptance (minutes)' );
    ylabel( '{ \it p}_{Double Spend}' );
    ylim([0 1]);
    fSetPlotSizeAndSave();
end