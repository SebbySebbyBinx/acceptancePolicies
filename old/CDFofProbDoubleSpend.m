%plot the CDF of P_{Double Spend}
clear all;
hold all;
figure('Position', [100, 100, 900, 500]);

alpha = 0.2;
lambda = .1;
arrDistOfInitAttLead = [1];
N = 6;

tMax = N*10*30 + 1000;
% increment = .3;
% T = [0:increment:tMax];
% probDoubleSpend = [];
% for time=T
%     probDoubleSpend(end+1) = fProbDoubleSpend( lambda, alpha, arrDistOfInitAttLead, time, N );
% end
% erlangNdist = makedist('Gamma',N,1/(lambda*(1-alpha)));
% expectedProbDoubleSpendStatic = sum( increment * probDoubleSpend .* pdf( erlangNdist, T ) )
% plot( probDoubleSpend, pdf( erlangNdist, T ))


matPolicy = [0,tMax; N,N];  
[expectProbDoubleSpendStatic, expectTimeWaitedStatic, sampleProbDoubleSpend] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, 10000 ); 
hold all;
[f,xi] = ksdensity(sampleProbDoubleSpend,'support',[0,1],'function','cdf'); 
plot(xi,f, ':', 'lineWidth',3, 'DisplayName', 'Static Policy')
legend('-DynamicLegend');

epsilon = .0001;
pDoubleSpendMaxLow = 0; pDoubleSpendMaxHigh = 1;
while pDoubleSpendMaxHigh - pDoubleSpendMaxLow > epsilon
    pDoubleSpendMaxHigh - pDoubleSpendMaxLow
    matPolicy = fFindPolicy( lambda, alpha, arrDistOfInitAttLead, tMax, (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2, .001 ); 
    [expectPDoubleSpendDynamic, expectTimeWaitedDynamic, sampleProbDoubleSpend] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, 10000 );
    
    if expectPDoubleSpendDynamic < expectProbDoubleSpendStatic
        pDoubleSpendMaxLow = (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2;
    else
        pDoubleSpendMaxHigh = (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2;
    end   
end
[expectPDoubleSpendDynamic, expectTimeWaitedDynamic, sampleProbDoubleSpend] = fEvalPolicy( matPolicy, lambda, alpha, arrDistOfInitAttLead, 10000 );
hold all;
[f,xi] = ksdensity(sampleProbDoubleSpend,'support',[0,pDoubleSpendMaxHigh],'function','cdf'); 
plot(xi,f,'lineWidth',3, 'DisplayName', 'Dynamic Policy')
legend('-DynamicLegend');


xlabel('P_{Double Spend}');
%ylabel('E[time waited]');
title({['CDF of P_{Double Spend} Assuming E[P(Double Spend)] = ', num2str(expectProbDoubleSpendStatic)]})
set(findall(gcf,'type','text'),'fontSize',16,'fontname', 'Times New Roman');
set(gca,'FontSize',16,'fontname', 'Times New Roman');
set(gcf,'color','w'); %set background white   