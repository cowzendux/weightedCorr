# weightedCorr

SPSS Python Extension function that generates a correlation matrix that makes use of a regression weight

SPSS will not normally allow you to use a regression weight outside of a regression analysis. There is a command to weight your data, but it does this by artificially multiplying the number of cases that you have, which is not typically what you want.

This and other SPSS Python Extension functions can be found at http://www.stat-help.com/python.html

## Usage
**weightedCorr(weight, varlist1, varlist2)**
* "weight" is a string identifying the weight variable. This argument is required.
* "varlist1" and "varlist2" are lists of strings indicating the variables for the correlation matrix. varlist1 is required, but varlist2 is optional. If you only provide varlist1, then the function will calculate the intercorrelations among all of the variables in this list. If you provide both varlist1 and varlist2, the function will correlate the variables in  varlist1 with the variables in varlist2, but will not calculate the correlations within the two lists.

## Example 1
**weightedCorr(weight = "weightvar",    
varlist1 = ["age", "iq", "pretest"],    
varlist2 = ["posttest"])**
* This would provide the weighted correlations (where the weights are contained in the variable "weightvar") of age, iq, and the pretest score with the posttest score. 
* It would not provide the correlations among age, iq, and the pretest score. 
* Note that even though we only have one variable in varlist2, we still have to represent it as a list by including it in brackets.

## Example 2
**weightedCorr(weight = "weightvar",    
varlist1 = ["CO", "ES", "ES])**
* This would provide the weighted correlations (where the weights are contained in the variable "weightvar") among the three variables CO, ES, and IS.
