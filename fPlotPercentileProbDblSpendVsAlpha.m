function fPlotPercentileProbDblSpendVsAlpha( lambda, alphaAnchor, arrAlpha, arrInitAttLead, arrT, staticPolicyConf, percentile,  epsilonPolicyTime, epsilonProbDblSpend)
    % plots expected time to acceptance vs expected probability of double spend
    setupForCalcAndPlot

    staticPolicy = [0, max(arrT); staticPolicyConf, staticPolicyConf];  
    [expProbDblSpendStatic, ~, ~ ] = fPolicyProperties( lambda, alphaAnchor, arrInitAttLead, staticPolicy, arrT );
    %percentileProbDblSpendStatic = fPercentileProbDblSpend( CDFprobDblSpendAtAcceptStatic, percentile );
    %[dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenPercentile( lambda, alphaAnchor, arrInitAttLead, arrT, percentile, percentileProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );
    [dynamicPolicy, probDblSpendMax] = fFindDynamicPolicyGivenExpProbDblSpend( lambda, alphaAnchor, arrInitAttLead, arrT, expProbDblSpendStatic, epsilonProbDblSpend, epsilonPolicyTime );

    
    arrPercentileProbDblSpendStatic = zeros(1,length(arrAlpha));
    arrPercentileProbDblSpendDynamic = zeros(1,length(arrAlpha));
    count = 1;
    for alpha = arrAlpha
        alpha
       [~, ~, CDFprobDblSpendAtAcceptStatic] = fPolicyProperties( lambda, alpha, arrInitAttLead, staticPolicy, arrT );
       percentileProbDblSpendStatic = CDFprobDblSpendAtAcceptStatic(1, find(CDFprobDblSpendAtAcceptStatic(2,:) > percentile/100, 1, 'first') );     
       
       [~, ~, CDFprobDblSpendAtAcceptDynamic] = fPolicyProperties( lambda, alpha, arrInitAttLead, dynamicPolicy, arrT );
       percentileProbDblSpendDynamic = CDFprobDblSpendAtAcceptDynamic(1, find(CDFprobDblSpendAtAcceptDynamic(2,:) > percentile/100, 1, 'first') );     
          
       arrPercentileProbDblSpendStatic(count) = percentileProbDblSpendStatic;
       arrPercentileProbDblSpendDynamic(count) = percentileProbDblSpendDynamic;
       count = count + 1; 
    end
    
    fig = figure('Name', ['percentileProbDblSpendVsAlpha']);
    hold all;
    plot( arrAlpha, arrPercentileProbDblSpendDynamic, dynamicPolicyLineType, 'color', dynamicPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Dynamic - {\it p}_{Double Spend} < ' num2str(100*probDblSpendMax,4) '%'])
    plot( arrAlpha, arrPercentileProbDblSpendStatic, staticPolicyLineType, 'color', staticPolicyLineColor, 'lineWidth',3, 'DisplayName', ['Static - ' num2str(staticPolicyConf) ' confirmations'])

  
    lgd = legend('show','Location','NorthWest');
    title(lgd,['Policies with E[{\it p}_{Double Spend}] = ' , num2str(100*expProbDblSpendStatic,4) '%']);
    
    lgd = legend('show','Location','NorthWest');
    xlabel('\alpha');
    ylabel([num2str(percentile) '^{th} percentile of {\it p}_{Double Spend}']);
    %title({[num2str(percentile) '^{th} percentile of {\it p}_{Double Spend} vs. \alpha'] ['Comparing Policies With Same E[{\it p}_{Double Spend}] When \alpha = '  num2str(alphaAnchor)]})
    title({[num2str(percentile) '^{th} percentile of {\it p}_{Double Spend} vs. \alpha']})
    fSetPlotSizeAndSave();
end

