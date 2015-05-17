spot=100; K=85; T=2; N=200; rf=0.04;sigma = 0.2;
div_ts = [0.5, 1.0, 1.5];div_rs = [0.05, 0.05, 0.05];

function res=call(S,K)
  res=max(S-K,0);
end 
function res=put(S,K)
  res=max(K-S,0.0);
end 
function res=straddle(S,K)
  res=max(S-K,K-S);
end 

payoff=@(x)call(x,K);
euroP=zeros(1,length(10:200));
amerP=zeros(1,length(10:200));
length(euroP)
for i=10:200
   euroP(i-9)=europeanBinomialPricerD(spot, sigma, rf, T, i, payoff, div_ts, div_rs);
   amerP(i-9)=americanBinomialPricerD(spot, sigma, rf, T, i, payoff, div_ts, div_rs);
end 

# analytic price for reference
# dividend adjustment
spotadj = spot;
for k = 1 : length(div_rs)
  spotadj *= 1-div_rs(k);
endfor
F = spotadj * exp(rf*T);
d1 = (log (F/K) + 0.5 * sigma * sigma * T) / sigma / sqrt(T);
d2 = (log (F/K) - 0.5 * sigma * sigma * T) / sigma / sqrt(T); 
bs = exp(-rf*T) * (F * normcdf(d1) - K*normcdf(d2))

plot([10:200],euroP,'g;EuroBinomialCRR;',
     [10:200],amerP,'b;AmerBinomialCRR;',
     [10:200],repmat(bs, 1, length(euroP)),'r;BS Analytic;');
xlabel('Number of time steps');
ylabel('Price');

f=@(x)call(x,85);
europeanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)
americanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)
f=@(x)put(x,85);
europeanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)
americanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)
f=@(x)straddle(x,85);
europeanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)
americanBinomialPricerD(spot, sigma, rf, T, 100, f, div_ts, div_rs)

