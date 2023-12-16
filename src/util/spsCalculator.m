function sps_score = spsCalculator(ep, np, ef, nf, sps_metric)
% spsCalculator function returns the suspiciousness score based on ep, np, ef, nf and sps_metric.
%
% Inputs:
%   ep: passed and topk         as: successed and activated
%   np: passed and not topk     ns: successed and unactivated
%   ef: failed and topk         af: failed and activated
%   nf: failed and not topk     nf: failed and unactivated
%   sps_metric: suspiciousness metrics, including alpha version and minus
%   (alpha-beta) version
% Outputs:
%   sps_score: suspiciousness score

if strcmp(sps_metric, 'alphaTarantula')
    sps_score = (ef/(ef+nf))/((ef/(ef+nf))+(ep/(ep+np)));
elseif strcmp(sps_metric, 'alphaOchiai')
    sps_score = ef/sqrt((ef+nf)*(ef+ep));
elseif strcmp(sps_metric, 'alphaDstar')
    % here, we set the value of * as 3
    sps_score = (ef^3)/(ep+nf);
elseif strcmp(sps_metric, 'alphaJaccard')
    sps_score = ef/(ef+nf+ep);
elseif strcmp(sps_metric, 'alphaKulczynski1')
    sps_score = ef/(nf+ep);
elseif strcmp(sps_metric, 'alphaKulczynski2')
    sps_score = 0.5 * (ef/(ef+nf) + ef/(ef+ep));
elseif strcmp(sps_metric, 'alphaOp')
    sps_score = ef-(ep/(ep+np+1));
elseif strcmp(sps_metric, 'betaTarantula')
    sps_score = (nf/(nf+ef))/((nf/(nf+ef))+(np/(np+ep)));
elseif strcmp(sps_metric, 'betaOchiai')
    sps_score = nf/sqrt((nf+ef)*(nf+np));
elseif strcmp(sps_metric, 'betaDstar')
    sps_score = (nf^3)/(np+ef);
elseif strcmp(sps_metric, 'betaJaccard')
    sps_score = nf/(nf+ef+np);
elseif strcmp(sps_metric, 'betaKulczynski1')
    sps_score = nf/(ef+np);
elseif strcmp(sps_metric, 'betaKulczynski2')
    sps_score = 0.5 * (nf/(nf+ef) + nf/(nf+np));
elseif strcmp(sps_metric, 'betaOp')
    sps_score = nf-(np/(np+ep+1));
elseif strcmp(sps_metric, 'minusTarantula')
    sps_score = (ef/(ef+nf))/((ef/(ef+nf))+(ep/(ep+np))) - (nf/(nf+ef))/((nf/(nf+ef))+(np/(np+ep)));
elseif strcmp(sps_metric, 'minusOchiai')
    sps_score = ef/sqrt((ef+nf)*(ef+ep)) - nf/sqrt((nf+ef)*(nf+np));
elseif strcmp(sps_metric, 'minusDstar')
    sps_score = (ef^3)/(ep+nf) - (nf^3)/(np+ef);
elseif strcmp(sps_metric, 'minusJaccard')
    sps_score = ef/(ef+nf+ep) - nf/(nf+ef+np);
elseif strcmp(sps_metric, 'minusKulczynski1')
    sps_score = ef/(nf+ep) - nf/(ef+np);
elseif strcmp(sps_metric, 'minusKulczynski2')
    sps_score = 0.5 * (ef/(ef+nf) + ef/(ef+ep)) - 0.5 * (nf/(nf+ef) + nf/(nf+np));
elseif strcmp(sps_metric, 'minusOp')
    sps_score = ef-(ep/(ep+np+1)) - (nf-(np/(np+ep+1)));
else
    error('Check your suspiciousness metrics!');
end
end