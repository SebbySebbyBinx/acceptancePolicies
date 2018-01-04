alpha = 0.2;
lambda = .1;
arrDistOfInitAttLead = [1];
N = 3;

tMax = N*10*30 + 1000;
arrT = 0:.1:tMax;

matPolicyStatic = [0,tMax;N,N];  
[expectProbDoubleSpendStatic, expectTimeWaitedStatic, sampleProbDoubleSpend] = fEvalPolicy( matPolicyStatic, lambda, alpha, arrDistOfInitAttLead, 10000 ); 
hold all;
[f,xi] = ksdensity(sampleProbDoubleSpend,'support',[0,1],'function','cdf'); plot(xi,f)

epsilon = .0001;
pDoubleSpendMaxLow = 0; pDoubleSpendMaxHigh = 1;
while pDoubleSpendMaxHigh - pDoubleSpendMaxLow > epsilon
    pDoubleSpendMaxHigh - pDoubleSpendMaxLow
    matPolicyDynamic = fFindPolicy( lambda, alpha, arrDistOfInitAttLead, tMax, (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2, .001 ); 
    [expectPDoubleSpendDynamic, expectTimeWaitedDynamic, sampleProbDoubleSpend] = fEvalPolicy( matPolicyDynamic, lambda, alpha, arrDistOfInitAttLead, 1000 );
    
    if expectPDoubleSpendDynamic < expectProbDoubleSpendStatic
        pDoubleSpendMaxLow = (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2;
    else
        pDoubleSpendMaxHigh = (pDoubleSpendMaxLow + pDoubleSpendMaxHigh)/2;
    end   
end
[expectPDoubleSpendDynamic, expectTimeWaitedDynamic, sampleProbDoubleSpend] = fEvalPolicy( matPolicyDynamic, lambda, alpha, arrDistOfInitAttLead, 10000 );


figure('Position', [100, 100, 900, 500]);
[f,xi] = ksdensity(sampleProbDoubleSpend,'support',[0,pDoubleSpendMaxHigh],'function','cdf'); plot(xi,f)

%figure
%hold all;
%[ distMainChainLead ] = fPDFTimeToDoubleSpend( matPolicyStatic, lambda, alpha, arrDistOfInitAttLead, 300000 );
%hold all;
%[ distMainChainLead ] = fPDFTimeToDoubleSpend( matPolicyDynamic, lambda, alpha, arrDistOfInitAttLead, 300000 );


xlabel('time (minutes)');
ylabel('P_{Double Spend}');
title({['CDF of Double Spend of Probabilities At Time of Transaction Acceptance When \alpha = ', num2str(alpha)]})
legend('Fixed Confirmations Policy', 'Bounded Probability of Double Spend Policy')
set(findall(gcf,'type','text'),'fontSize',16,'fontname', 'Times New Roman');
set(gca,'FontSize',16,'fontname', 'Times New Roman');
set(gcf,'color','w'); %set background white   