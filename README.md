# P-hacking Simulation
# http://freethoughtblogs.com/reprobate/2017/05/15/p-hacking-is-no-big-deal/

The scripts should be fairly intuitive to understand. They come in three variants:

* calculate_stats.m: For the given hard-wired parameters, print out a text summary.
* calculate_stats.fixed.m: For the parameters given on the command line, output the
   simulation p-values to the console.
* calculate_stats.varying.m: For the given effective p-value, output a spreadsheet of
   results to the console.

The t-test code is present but commented out.
