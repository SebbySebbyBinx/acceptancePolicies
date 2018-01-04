function fPlotExpTimeToAcceptVsLambda(  arrLambda, alpha, arrInitAttLead, probDblSpendMax, epsilonPolicyTime)
    %Expected Time To Confirmation vs. lambda
    setupForCalcAndPlot

    arrExpectedTimeToAcceptDynamic = zeros(1, length(arrLambda) );

    count = 1;
    fprintf('lambda: ');
    for lambda = arrLambda

        arrT = 0:1/(10*lambda):(30*6/lambda);

        fprintf(' %f ', lambda);

        dynamicPolicy = fFindDynamicPolicyGivenProbDblSpendMax( lambda, alpha, arrInitAttLead, max(arrT), probDblSpendMax, epsilonPolicyTime ); 
        [~, expectedTimeToAcceptDynamic, ~] = fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );

        arrExpectedTimeToAcceptDynamic(count) = expectedTimeToAcceptDynamic;
        count = count + 1;
    end
    fprintf('\n');

    figure('Name', 'expectedTimeToAcceptVsLambda');
    plot( arrLambda, arrExpectedTimeToAcceptDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', ['\alpha = ', num2str(alpha)])

    lgd = legend('show','Location','NorthEast');
    title(lgd,'Network Parameters');

    xlabel('block arrival rate - \lambda (minutes^{-1})');
    ylabel('E[time to transaction tcceptance]');
    title({['Expected Time To Transaction Acceptance vs. \lambda'],['Assuming A Dynamic Policy Where {\it p}_{Double Spend} <  ', num2str(100 * probDblSpendMax, 4), '%']})
    fSetPlotSizeAndSave();
end