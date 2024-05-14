.-
help for ^relogitq^
.-

Calculates quantities of interest after a corrected logit regression
--------------------------------------------------------------------

   ^relogitq^ [^, pr^ ^bayes^ ^mle^ ^unbi^ased ^listx^ 
               ^fd(pr)^ ^changex(^var1 val1 val2 [^&^ var2 val1 val2]^)^
               ^rr(^var1 val1 val2 [^&^ var2 val1 val2]^) sims(^#^) l^evel^(^#^)^]


Description
-----------

This procedure implements the suggestions of King and Zeng (1999a,b)
for improved methods of computing quantities of interest -- absolute
risks (probabilities), relative risks, and attributable risks (first
differences) -- from a logistic regression that is corrected for small
samples and rare events, as well as selection on the dependent
variable as in case-control designs.  First run a corrected logit (see
help @relogit@) and set values for the explanatory variables (see help
@setx@).  Then use ^relogitq^ to calculate the desired quantities of
interest.

Note: The ^relogitq^ procedure is memory-intensive.  If you receive an error
message such as "no room to add more variables," you may need to allocate
more memory to Stata by typing "clear" and then "set memory #m".  See
[R] memory in the reference manual for more details about memory allocation.


Options That Affect Which Quantities are Calculated
---------------------------------------------------

^pr^ reports Pr(depvar==1|x), the probability (absolute risk) that the
   dependent variable takes on a value of 1 when the explanatory
   variables (x) are set at values that were chosen at the @setx@
   stage.  If no other options are specified, this is the default
   output.

^fd(pr)^ is a "wrapper" that makes it easy to simulate first differences
   (also called attributable risks).  Simply wrap the fd() wrapper around
   the ^pr^ option to estimate the change in Pr(Y=1) given some change in x,
   holding other variables at the values that were set at the @setx@
   stage.  The ^fd()^ wrapper must be used in conjunction with the
   ^changex()^ option.

^changex(^var1 val1 val2^)^ specifies how the explanatory variables
   (x) should change when evaluating a first difference (attributable
   risk). ^changex()^ uses the same basic syntax as @setx@, except
   that each explanatory variable has two values: a starting value and
   an ending value.  For instance, ^fd(pr)^ ^changex(x1 .2 .8)^
   calculates the change in Pr(Y=1) caused by increasing x1 from its
   starting value, 0.2, to its ending value, 0.8.  You can specify
   multiple changex scenarios by separating each scenario with an
   ampersand.  See the examples, below.

^rr(^var1 val1 val2^)^ specifies how the explanatory variables (x)
   should change when calculating the relative risk,
   Pr(Y=1|xend)/Pr(Y=1|xstart), where xstart represents the vector of
   starting values for x and xend represents the vector of ending
   values for x.  ^rr()^ uses the same basic syntax as ^changex^.  For
   instance, ^rr(x1 mean p75)^ instructs ^relogitq^ to calculate the
   relative risk of Pr(Y=1) caused by increasing x1 from its mean to
   its 75th percentile, holding other variables at the levels chosen
   at the @setx@ stage.  In this example, x1 is set to its mean in
   xstart and set to its 75th percentile in xend.  If you are
   interested in the percentage change in relative risk, compute
   100*[rr - 1], where rr is the output from this command.  You can
   specify multiple rr() scenarios by separating each scenario with an
   ampersand.

^listx^ causes ^relogitq^ to list all x-values that were chosen at the @setx@
   stage and provide a basis for predicted probabilities, first differences
   and relative risks.

^l^evel^(^#^)^ specifies the confidence level, in percent, for confidence     
   intervals around quantities of interest.  The default is ^level(95)^ or
   the value set by ^set l^evel.  For more information on ^set l^evel, see
   the on-line help for @level@.

   
Options that Affect How the Quantities are Calculated
-----------------------------------------------------

By default, ^relogitq^ uses stochastic simulation to compute all
quantities of interest and the uncertainty surrounding those
quantities.  The program reports the median of the simulated posterior
density, as well as confidence intervals around the median.
^relogitq^ also supports analytical methods for obtaining point
estimates of quantities of interest, but continues to use simulation
to measure the uncertainty.  The following three analytical methods
are available:

^mle^ instructs ^relogitq^ to calculate point estimates for quantities of
   interest based only on the the maximum likelihood estimates (the
   coefficients generated by @relogit@), without accounting for their
   uncertainty.  For instance, mle option computes the probability
   Pr(Y=1|x,b) using the formula 1/(1+exp(-x*b)), where x is the
   vector of x's that was chosen at the @setx@ stage and b represents
   the vector of logit (or relogit) coefficients.  This approach is
   consistent but has higher mean square error and so is not generally
   recommended.

^unbi^ased instructs ^relogitq^ to calculate approximately unbiased estimates
   of all quantities of interest.  This option has a higher mean squared error
   than the Bayesian alternative, which is superior in most cases.

^bayes^ uses the entire probability distribution of b to approximate the
   expected value of Pr(Y=1|x), without conditioning on the point
   estimate b.  This approach has the lowest mean squared error and is
   recommended for users who prefer the analytical approach.

The program also contains an option to control the simulation process, which
produces all measures of uncertainty.

^sims(^m^)^ specifies the number of simulations, m, which must be a positive
   integer.  The default is 1000 simulations.  Increase the number of
   simulations to obtain more precise approximations to quantities of
   interest; reduce the number of simulations for greater
   computational speed.  You can determine whether you have enough
   precision by repeating a relogitq command with the same number of
   simulations and seeing whether you have sufficient digits of
   precision.  If you choose a large number of simulations, you
   may need to allocate more memory to Stata.  See [R] memory in the
   reference manual for more details about memory allocation.


Examples
--------

To display Pr(Y=1|x), where x represents the values that were chosen
at the @setx@ stage, type

   . ^relogitq^

To obtain the same quantity of interest via analytical Bayesian
methods and list all x-values chosen at the @setx@ stage, type type

   . ^relogitq, bayes listx^

Use the ^fd()^ and ^changex()^ options to calculate the effects of
changes in probabilties caused by movements in x.  For instance, the
following command will calculate the change in Pr(Y=1) caused by
increasing the explanatory variable x1 from its 20th to its 80th
percentile.

   . ^relogitq, fd(pr) changex(x1 p20 p80)^


You specify many changex() scenarios by separating each scenario with
an ampersand.  The following expression will calculate two first
differences (attributable risks): the change in Pr(Y=1) caused by
increasing x1 from its mean to its maximum level, and the change in
Pr(Y=1) caused by simultaneously incrasing x1 from 3 to the square
root of 15 and increasing x2 from its median to its 90th percentile.

   . ^relogitq, fd(pr) changex(x1 mean max & x1 3 sqrt(15) x2 median p90)^


A similar syntax applies to relative risks.  Thus, the next command
gives the percentage change in relative risk of Pr(Y=1) caused by
raising x1 from 10 to 15.

   . ^relogitq, rr(x1 10 15)^



Saved Results
-------------

^relogitq^ saves the following scalars:

  r(Pr)     = Point estimate for Pr(Y=1|x), where x was set with @setx@
  r{PrL)    = Lower bound of confidence interval for Pr(Y=1|x)
  r(PrU)    = Upper bound of confidence interval for Pr(Y=1|x)
  r(dPr_#)  = Point estimate of change in Pr(Y=1) for 1st difference scenario #
  r(dPrL_#) = Lower bound of confidence interval for first difference #
  r(dPrU_#) = Upper bound of confidence interval for first difference #
  r(rr_#)   = Point estimate of % change in Pr(Y=1) for relative risk scenario #
  r(rrL_#)  = Lower bound of confidence interval for relative risk #
  r(rrU_#)  = Upper bound of confidence interval for relative risk #


Distribution
------------

    ^relogitq^ is (C) Copyright, 1999, Michael Tomz, Gary King and Langche
    Zeng, All Rights Reserved.  You may copy and distribute this program
    provided no charge is made and the copy is identical to the original.
    To request an exception, please contact:

    Michael Tomz <tomz@@fas.harvard.edu>
    Department of Government, Harvard University
    Littauer Center North Yard
    Cambridge, MA 02138

    Please distribute the current version of this program, which is
    available from http://GKing.Harvard.Edu.


References
----------

    Gary King and Langche Zeng. 1999a. "Logistic Regression in Rare
    Events Data," Department of Government, Harvard University,
    available from http://GKing.Harvard.Edu.

    Gary King and Langche Zeng. 1999b. "Estimating Absolute, Relative,
    and Attributable Risks in Case-Control Studies," Department of
    Government, Harvard University, available from
    http://GKing.Harvard.Edu.


