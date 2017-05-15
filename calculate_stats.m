# load the table
TABLE=csvread("rpp_data.condensed.csv");
TABLE(1,:) = []; # clip the header

ROUNDS=10000;
NULLRATE=0.7;
PVALUE=0.05;
PHACKED=0.08;
for DATASET = [1,3]      # 1 = original scores, 3 = replications

RESULTPV=[0 0; 0 0]; # row = actual, col = result, 0 = false
RESULTPH=[0 0; 0 0];

# handle the nulls first
for i = 1:roundb(ROUNDS*NULLRATE)
  COUNT=TABLE(roundb( (unifrnd( 1,size(TABLE,1) )) ), DATASET);

#  SAMPLE=normrnd(0,1,COUNT/2,2);
#  [PVAL, F, DF_B, DF_W] = anova(SAMPLE);

  SAMPLE=normrnd(0,1,COUNT/2,1);
  [PVAL, T, DF] = t_test(SAMPLE, 0);
  
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

#  SAMPLE=[ normrnd(0,1,COUNT/2,1), normrnd(COHENS,1,COUNT/2,1) ];
#  [PVAL, F, DF_B, DF_W] = anova(SAMPLE);
  
  SAMPLE=normrnd(COHENS,1,COUNT/2,1);
  [PVAL, T, DF] = t_test(SAMPLE, 0);
  
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
  display("(Template: OSC 2015 originals)");
elseif DATASET == 3
  display("(Template: OSC 2015 replications)");
endif

printf("With a %.2f%% success rate and a straight p <= %.6f,\
 the false positive rate is %.4f%% (%d f.p, %d t.p)\n", ...
 (1-NULLRATE)*100.0, PVALUE, RESULTPV(1,2)/sum(RESULTPV(:,2))*100.0, ...
 RESULTPV(1,2), RESULTPV(2,2) );
printf("Whereas if p-hacking lets slip p <= %.6f,\
 the false positive rate is %.4f%% (%d f.p, %d t.p)\n\n\n", ...
 PHACKED, RESULTPH(1,2)/sum(RESULTPH(:,2))*100.0, ...
 RESULTPH(1,2), RESULTPH(2,2) );

 endfor
