* Calculate a weighted corrlation matrix
* By Jamie DeCoster

* This program allows users to calculate a correlation matrix
* that makes use of a regression weight. 

**** Usage: weightedCorr(weight, varlist1, varlist2)
**** "weight" is a string identifying the weight variable. This
* argument is required.
**** "varlist1" and "varlist2" are lists of strings indicating the variables 
* for the correlation matrix. varlist1 is required, but varlist2 is optional. 
* If you only provide varlist1, then the function will calculate the 
* intercorrelations among all of the variables in this list. If you provide 
* both varlist1 and varlist2, the function will correlate the variables in 
* varlist1 with the variables in varlist2, but will not calculate the correlations 
* within the two lists.

* Example 1: 
**** weightedCorr("weightvar", ["age", "iq", "pretest"], ["posttest"])
* This would provide the weighted correlations (where the weights are 
* contained in the variable "weightvar") of age, iq, and the pretest score 
* with the posttest score. It would not provide the correlations among age, iq,
* and the pretest score. Note that even though we only have one variable
* in varlist2, we still have to represent it as a list by including it in brackets.

* Example 2
**** weightedCorr("weightvar", ["CO", "ES", "ES])
* This would provide the weighted correlations (where the weights are 
* contained in the variable "weightvar") among the three variables CO, ES, 
* and IS.

************
* Version History
************
* 2013-10-15 Created

set printback = off.
BEGIN PROGRAM PYTHON3.
import spss, spssaux
from spss import CellText

def weightedCorr(weight, varlist1, varlist2 = None):
    if (varlist2 == None):
        varlist2 = varlist1

# Using the regression procedure to get the individual correlations
# Storing the results in lists

    rList = []
    nList = []
    pList = []
    for var1 in varlist1:
        for var2 in varlist2:
            cmd = """REGRESSION
  /MISSING LISTWISE
  /REGWGT=%s
  /STATISTICS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT %s
  /METHOD=ENTER %s.""" %(weight, var1, var2)
            handle,failcode=spssaux.CreateXMLOutput(
		cmd,
		omsid="Regression",
		visible=False)
            modelsummary=spssaux.GetValuesFromXMLWorkspace(
		handle,
		tableSubtype="Model Summary",
		cellAttrib="text")
            anovatable=spssaux.GetValuesFromXMLWorkspace(
		handle,
		tableSubtype="ANOVA",
		cellAttrib="text")
            if (len(modelsummary) > 0):
                r = float(modelsummary[0])
                p = float(anovatable[4])
                n = float(anovatable[6])
            else:
                r = None
                p = None
                n = None
            rList.append(r)
            pList.append(p)
            nList.append(n)

# Put results into a pivot table
    spss.StartProcedure("Weighted Correlations")
    table = spss.BasePivotTable("Correlations weighted by " + weight,
"OMS table subtype")
    coldim=table.Append(spss.Dimension.Place.column,"variable2")
    rowdim1=table.Append(spss.Dimension.Place.row,"variable1")
    rowdim2=table.Append(spss.Dimension.Place.row,"statistic")

    rowvarCatlist = []
    for var in varlist1:
        t = CellText.String(var)
        rowvarCatlist.append(t)
    colvarCatlist = []
    for var in varlist2:
        t = CellText.String(var)
        colvarCatlist.append(t)
    statCatlist = [CellText.String("r"), CellText.String("p"), CellText.String("n")]
    table.SetCategories(rowdim1, rowvarCatlist) 
    table.SetCategories(rowdim2, statCatlist)
    table.SetCategories(coldim, colvarCatlist)

    count = 0
    for var1 in varlist1:
        for var2 in varlist2:
            if (rList[count] != None):
                table[(CellText.String(var2), 
CellText.String(var1), CellText.String("r"))] = CellText.Number(rList[count], 
spss.FormatSpec.Correlation)
                table[(CellText.String(var2), 
CellText.String(var1), CellText.String("p"))] = CellText.Number(pList[count],
spss.FormatSpec.Significance)
                table[(CellText.String(var2), 
CellText.String(var1), CellText.String("n"))] = CellText.Number(nList[count], 
spss.FormatSpec.Count)
            count += 1
    spss.EndProcedure()

end program python.
set printback = on.

