clear all;
hold all;
legend('-DynamicLegend');
figure('Position', [100, 100, 900, 500]);

arrDistOfInitAttLead = [0 1];
lambda = .1

arrTime = 5000;
pDoubleSpendMax = .01;
  

expectedTimeWaitedDynamic = [];
expectPDoubleSpendDynamic = [];

arrAlpha = 0.1:.1:.4;
for alpha = arrAlpha
    alpha
    
    matPolicy = fFindPolicy( lambda, alpha, arrDistOfInitAttLead, max(arrTime), pDoubleSpendMax, .01 ); 
    [expectPDoubleSpend, expectTimeWaited] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, 5000 );
    
    expectedTimeWaitedDynamic(end+1) = 60*expectTimeWaited;
    expectPDoubleSpendDynamic(end+1) = expectPDoubleSpend;
end
    
hold all
plot( arrAlpha, expectedTimeWaitedDynamic, 'lineWidth',3 )
legend('-DynamicLegend');


xlabel('\alpha');
ylabel('E[Time Waited]');
%ylim([0 pDoubleSpendMax*1.1])
title({['Expected Time Waited vs. \alpha'],['Assuming A Dymamic Policy Where P_{Double Spend} <  ', num2str(pDoubleSpendMax)]})
%legend(strcat('\alpha = ', num2str(alpha)))
set(findall(gcf,'type','text'),'fontSize',16,'fontname', 'Times New Roman');
set(gca,'FontSize',16,'fontname', 'Times New Roman');
set(gcf,'color','w'); %set background white   