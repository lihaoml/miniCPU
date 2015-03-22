function res = europeanBinomialPricer( d, u, p, T, N, rf, spot, payoff )
	# Auxiliary variables
	ratioUd = u / d;
	ratioProb = p / ( 1.0 - p );
	
	# initialize loop variables
	price = spot * d ^ N; # Price corresponding to state i=0
	prob = ( 1 - p ) ^ N; # Probability of a path that reach state i=0
	binom = 1.0; 
	expectation = prob * payoff( price );
	
	# loop over states in period N - 1 and compute the expectation 
	for i = 1:N  # loop start from one, as we already added the case i=0
		price = price  * ratioUd;           # Price corresponding to state i
		prob = prob * ratioProb;            # Probability of a path that reach state i
		binom = binom * ( N - i + 1 ) / i;  # Number of paths which reach state i
		expectation = expectation + binom * prob * payoff( price );
	endfor
	
	res = exp( -rf * T ) * expectation;
endfunction

