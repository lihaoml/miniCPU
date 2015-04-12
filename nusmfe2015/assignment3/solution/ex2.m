function ex2(K)
  spot=100; 
  T=2; 
  rf=0.04;
  sigma = 0.2;

  function res=call(spot,strike)
    res=max(spot-strike,0);
  end 
  payoff=@(x)call(x,K);

  # analytic price for reference
  F = spot * exp(rf*T);
  d1 = (log (F/K) + 0.5 * sigma * sigma * T) / sigma / sqrt(T);
  d2 = (log (F/K) - 0.5 * sigma * sigma * T) / sigma / sqrt(T); 
  bs = exp(-rf*T) * (F * normcdf(d1) - K*normcdf(d2))

  p1=zeros(1,length(10:200));
  p2=zeros(1,length(10:200));
  p3=zeros(1,length(10:200));
  for i=10:200
    p1(i-9)=europeanBinomialPricerD(spot, sigma, rf, T, i, payoff, [], []);
    p2(i-9)=europeanTrinomialPricerCRR(spot, sigma, rf, T, i, payoff);
    p3(i-9)=europeanTrinomialPricerB(spot, sigma, rf, T, i, payoff);
  end 

  plot([10:200],p1,'g;EuroBinomialCRR;',
       [10:200],p2,'b;EuroTrinomialCRR;',
       [10:200],p3,'m;EuroTrinomialB;',
       [10:200],repmat(bs, 1, length(p2)),'r;BS Analytic;');
  xlabel('Number of time steps');
  ylabel('Price');
endfunction