function sps_score = spsCalculator(as, ns, af, nf, sps_metric)
% spsCalculator function returns the suspiciousness score based on as, ns, af, nf and sps_metric.
%
% Insuts:
%   as: successed and activated    
%   ns: successed and unactivated  
%   af: failed and activated   
%   nf: failed and unactivated 
%   sps_metric: suspiciousness metrics, including alpha version and minus
%   (alpha-beta) version
% Outputs:
%   sps_score: suspiciousness score

if strcmp(sps_metric, 'alphaTarantula')
    sps_score = (af/(af+nf))/((af/(af+nf))+(as/(as+ns)));
elseif strcmp(sps_metric, 'alphaOchiai')
    sps_score = af/sqrt((af+nf)*(af+as));
elseif strcmp(sps_metric, 'alphaDstar')
    % here, we set the value of * as 3
    sps_score = (af^3)/(as+nf);
elseif strcmp(sps_metric, 'alphaJaccard')
    sps_score = af/(af+nf+as);
elseif strcmp(sps_metric, 'alphaKulczynski1')
    sps_score = af/(nf+as);
elseif strcmp(sps_metric, 'alphaKulczynski2')
    sps_score = 0.5 * (af/(af+nf) + af/(af+as));
elseif strcmp(sps_metric, 'alphaOp')
    sps_score = af-(as/(as+ns+1));
elseif strcmp(sps_metric, 'betaTarantula')
    sps_score = (nf/(nf+af))/((nf/(nf+af))+(ns/(ns+as)));
elseif strcmp(sps_metric, 'betaOchiai')
    sps_score = nf/sqrt((nf+af)*(nf+ns));
elseif strcmp(sps_metric, 'betaDstar')
    sps_score = (nf^3)/(ns+af);
elseif strcmp(sps_metric, 'betaJaccard')
    sps_score = nf/(nf+af+ns);
elseif strcmp(sps_metric, 'betaKulczynski1')
    sps_score = nf/(af+ns);
elseif strcmp(sps_metric, 'betaKulczynski2')
    sps_score = 0.5 * (nf/(nf+af) + nf/(nf+ns));
elseif strcmp(sps_metric, 'betaOp')
    sps_score = nf-(ns/(ns+as+1));
elseif strcmp(sps_metric, 'minusTarantula')
    sps_score = (af/(af+nf))/((af/(af+nf))+(as/(as+ns))) - (nf/(nf+af))/((nf/(nf+af))+(ns/(ns+as)));
elseif strcmp(sps_metric, 'minusOchiai')
    sps_score = af/sqrt((af+nf)*(af+as)) - nf/sqrt((nf+af)*(nf+ns));
elseif strcmp(sps_metric, 'minusDstar')
    sps_score = (af^3)/(as+nf) - (nf^3)/(ns+af);
elseif strcmp(sps_metric, 'minusJaccard')
    sps_score = af/(af+nf+as) - nf/(nf+af+ns);
elseif strcmp(sps_metric, 'minusKulczynski1')
    sps_score = af/(nf+as) - nf/(af+ns);
elseif strcmp(sps_metric, 'minusKulczynski2')
    sps_score = 0.5 * (af/(af+nf) + af/(af+as)) - 0.5 * (nf/(nf+af) + nf/(nf+ns));
elseif strcmp(sps_metric, 'minusOp')
    sps_score = af-(as/(as+ns+1)) - (nf-(ns/(ns+as+1)));
else
    error('Check your suspiciousness metrics!');
end
end