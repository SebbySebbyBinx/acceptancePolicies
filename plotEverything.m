lambda = .1;
alpha = .2;
arrInitAttLead = 1;
arrT = 0:.1:500;
staticPolicyConf = 6;
probDblSpendMax = .01337;
epsilonProbDblSpend = .000001;
epsilonPolicyTime = .001;

%function fPlotSingleDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, pDoubleSpendMax, epsilonPolicyTime )
fPlotSingleDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime );

%function fPlotProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime );
fPlotProbDblSpendOccuredVsTime( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime );
%function fPlotProbDblSpendOccuredVsTimeByPercentile( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, percentile, epsilonProbDblSpend, epsilonPolicyTime )
percentile = 99;
fPlotProbDblSpendOccuredVsTimeByPercentile( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, percentile, epsilonProbDblSpend, epsilonPolicyTime )

%function fPlotCDFprobDblSpendAtAccept( lambda, alpha, arrInitAttLead, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )
fPlotCDFprobDblSpendAtAccept( lambda, alpha, arrInitAttLead, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )

%function fPlotCDFtimeToAccept(  lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )
fPlotCDFtimeToAccept(  lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime )

%function fPlotDynamicPoliciesDifferentAlphas(  lambda, arrAlpha, arrInitAttLead, arrT, pDoubleSpendMax, epsilonPolicyTime )
arrAlpha = [.2 .05 .01];
fPlotDynamicPoliciesDifferentAlphas(  lambda, arrAlpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime )

%function fPlotPoliciesWithSameExpectedProbDblSpend( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime)
fPlotPoliciesWithSameExpectedProbDblSpend( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf, epsilonProbDblSpend, epsilonPolicyTime)

%function fPlotDynamicPoliciesDifferentThresholds( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, epsilonPolicyTime)
arrProbDblSpendMax = [.001, .01, .1 1];    
fPlotDynamicPoliciesDifferentThresholds( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, epsilonPolicyTime)

%function fPlotDynamicPolicyLongTime( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime )
arrLongT = [0:1:100000];
fPlotDynamicPolicyLongTime( lambda, alpha, arrInitAttLead, arrLongT, probDblSpendMax, epsilonPolicyTime )

%function fPlotExpTimeToAcceptVsExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf,  epsilonPolicyTime)
arrProbDblSpendMax = [.001:.001:.009,.01:.003:.25];
arrStaticPolicyConf = 1:11;
fPlotExpTimeToAcceptVsExpProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf,  epsilonPolicyTime)

%function fPlotExpTimeToAcceptVsPercentileProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf, percentile, epsilonPolicyTime)
arrStaticPolicyConf = 1:18;
percentile = 99;
fPlotExpTimeToAcceptVsPercentileProbDblSpend( lambda, alpha, arrInitAttLead, arrT, arrProbDblSpendMax, arrStaticPolicyConf, percentile, epsilonPolicyTime)

%function fPlotExpTimeToAcceptVsLambda(  arrLambda, alpha, arrInitAttLead, probDblSpendMax, epsilonPolicyTime)
arrLambda = [.01:.005:.3 .4:.1:4];
fPlotExpTimeToAcceptVsLambda(  arrLambda, alpha, arrInitAttLead, probDblSpendMax, epsilonPolicyTime)

%function fPlotProbDblSpendVsConfForFixedTimePolicy( lambda, alpha, arrInitAttLead, acceptAfterT, arrConf)
arrConf = 1:11;
acceptAfterT = 50;
fPlotProbDblSpendVsConfForFixedTimePolicy( lambda, alpha, arrInitAttLead, acceptAfterT, arrConf)

%function fPlotProbDblSpendVsTimeForDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime)
fPlotProbDblSpendVsTimeForDynamicPolicy( lambda, alpha, arrInitAttLead, arrT, probDblSpendMax, epsilonPolicyTime)

%function fPlotProbDblSpendVsTimeForStaticPolicy( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf)
fPlotProbDblSpendVsTimeForStaticPolicy( lambda, alpha, arrInitAttLead, arrT, staticPolicyConf)

%function fPlotPercentileProbDblSpendVsAlpha( lambda, arrAlpha, arrInitAttLead, arrT, staticPolicyConf, percentile,  epsilonPolicyTime, epsilonProbDblSpend)
arrAlpha = 0:.01:.35;
percentile = 99;
fPlotPercentileProbDblSpendVsAlpha( lambda, alpha, arrAlpha, arrInitAttLead, arrT, staticPolicyConf, percentile,  epsilonPolicyTime, epsilonProbDblSpend)

%function matProbDblSpend = fVsRosen()
matProbDblSpendVsRosen = fVsRosen();
round( matProbDblSpendVsRosen*100, 3)

