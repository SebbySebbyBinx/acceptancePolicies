function fPlotProbDblSpendVsConfForFixedTimePolicy( lambda, alpha, arrInitAttLead, acceptAfterT, arrConf)
    % Shows the probability of Double Spend Vs. Number of Confimations Assuming A Fixed Amount of Time Waited For Transaction Verification
    setupForCalcAndPlot

    arrProbDblSpend = zeros(1,length(arrConf));
    count = 1;
    for conf=arrConf
        arrProbDblSpend( count ) = fProbDblSpend( lambda, alpha, arrInitAttLead, acceptAfterT, conf );
        count = count + 1;
    end

    fig = figure('Name', 'probDblSpendVsConfForFixedTimePolicy');
    hold all;
    plot( arrConf, arrProbDblSpend, '*', 'lineWidth', 1, 'color', fixedTimePolicyLineColor, 'DisplayName', ['Wait for ' num2str(acceptAfterT) ' minutes to accept']);
    lgd = legend('show','Location','NorthEast');
    title(lgd,['Policies']);
    xlabel('number of confirmations at transaction acceptance');
    ylabel('{\it p}_{Double Spend}')
    title({'Double Spend Probability Vs. Confimations At Transaction Acceptance';['Assuming Acceptance After Exactly ' num2str(acceptAfterT) ' Minutes And \alpha = ' num2str(alpha )]})
    fSetPlotSizeAndSave();
end