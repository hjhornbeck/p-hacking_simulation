# load the table
TABLE=csvread("rpp_data.condensed.csv");
TABLE(1,:) = []; # clip the header

ROUNDS=10000;
PVALUE=0.05;

ARGS = argv();
for ARGIND = 1:nargin
PHACKED = str2num( ARGS{ARGIND} );
for NULLRATE = 0.05 : 0.02 : 0.95
for DATASET = [1,3]      # 1 = original scores, 3 = replications

RESULTPV=[0 0; 0 0]; # row = actual, col = result, 0 = false
RESULTPH=[0 0; 0 0];

# handle the nulls first
for i = 1:roundb(ROUNDS*NULLRATE)
  COUNT=TABLE(roundb( (unifrnd( 1,size(TABLE,1) )) ), DATASET);

  SAMPLE=normrnd(0,1,COUNT/2,2);
  [PVAL, F, DF_B, DF_W] = anova(SAMPLE);

#  SAMPLE=normrnd(0,1,COUNT/2,1);
#  [PVAL, T, DF] = t_test(SAMPLE, 0);

  if PVAL <= PVALUE
    RESULTPV(1,2)++;
  else
    RESULTPV(1,1)++;
  endif
  if PVAL <= PHACKED
    RESULTPH(1,2)++;
  else
    RESULTPH(1,1)++;
  endif
endfor

# now for the non-nulls
for i = roundb(ROUNDS*NULLRATE):ROUNDS
  COUNT=TABLE(roundb( (unifrnd( 1,size(TABLE,1) )) ), DATASET);
  CORR=TABLE(roundb( (unifrnd( 1,size(TABLE,1) )) ), DATASET+1);

  COHENS = 2*CORR / sqrt(1 - CORR*CORR);  

  SAMPLE=[ normrnd(0,1,COUNT/2,1), normrnd(COHENS,1,COUNT/2,1) ];
  [PVAL, F, DF_B, DF_W] = anova(SAMPLE);

#  SAMPLE=normrnd(COHENS,1,COUNT/2,1);
#  [PVAL, T, DF] = t_test(SAMPLE, 0);

  if PVAL <= PVALUE
    RESULTPV(2,2)++;
  else
    RESULTPV(2,1)++;
  endif
  if PVAL <= PHACKED
    RESULTPH(2,2)++;
  else
    RESULTPH(2,1)++;
  endif
endfor

# and the big reveal!
if DATASET == 1
  printf("%f\t%f", NULLRATE, PHACKED );
endif

printf("\t%f\t%f\t%f\t%f", RESULTPV(1,2), RESULTPV(2,2), RESULTPH(1,2), RESULTPH(2,2) );

if DATASET == 3
  printf("\n")
endif

 endfor
 endfor
 endfor
