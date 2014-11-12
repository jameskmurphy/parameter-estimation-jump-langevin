Code for "Bayesian Parameter Estimation of Jump-Langevin Systems for Trend Following in Finance"
James Murphy (jm362@cam.ac.uk) and Simon Godsill
Department of Engineering, Cambridge University


Starting Points:  

1.  RunTest.m   - runs the reversible jump mcmc estimation process
           -- filesuffix   is a suffix to add to the saved file name (can be arbitrary)
           -- dataset      specfies the dataset on which to run the estimation process:  0 = synthetic data from model, 1 = s&p 500, (2,3 -- data not available)
           -- [other parameters, including # of samples, set within RunTest.m file]