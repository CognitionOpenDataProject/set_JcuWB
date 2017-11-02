* Encoding: UTF-8.
* syntax to replicate analysis published in Cognition.

*select data from study 1.
USE ALL.
COMPUTE filter_$=(study = 1).
VARIABLE LABELS filter_$ 'study = 1 (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

*run ANCOVA and display EM Means.
GLM child_change experimenter_change BY gender prime_type WITH Zage
  /WSFACTOR=toy_owner 2 Polynomial 
  /METHOD=SSTYPE(3)
  /EMMEANS=TABLES(toy_owner) WITH(Zage=MEAN)
  /EMMEANS=TABLES(prime_type) WITH(Zage=MEAN)
  /EMMEANS=TABLES(prime_type*toy_owner) WITH(Zage=MEAN)
  /PRINT=ETASQ 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=toy_owner 
  /DESIGN=Zage gender prime_type gender*prime_type.


*run t-tests to break down toy owner by prime interaction.
SORT CASES  BY prime_type.
SPLIT FILE LAYERED BY prime_type.

T-TEST PAIRS=child_change WITH experimenter_change (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.


*generate means and confidence intervals for the interaction.
SPLIT FILE OFF.
EXAMINE VARIABLES=child_change experimenter_change BY prime_type
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.


*generate means and CIs for main effect of picture type.
COMPUTE object_ch=MEAN(child_change,experimenter_change).
EXECUTE.

EXAMINE VARIABLES=object_ch BY prime_type
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

*generate means and CIs for main effect of toy owner.
EXAMINE VARIABLES=child_change experimenter_change
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.
