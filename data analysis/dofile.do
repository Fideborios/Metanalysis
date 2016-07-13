cd "C:\Users\niki\Desktop\data analysis" 
import excel "C:\Users\niki\Desktop\data analysis\data1.xlsx", firstrow clear
des
label var GrpAN "Number of patients in group A"
label var GrpAFrem " Number of patients in full remision in group A"

*drop TnoFrem CnoFrem
gen TnoFrem= GrpAN- GrpAFrem
gen CnoFrem= GrpBN - GrpBFrem

*fixed effect model*
metan TnoFrem GrpAFrem CnoFrem GrpBFrem, or chi2 nograph

*Random effect model*
metan TnoFrem GrpAFrem CnoFrem GrpBFrem, or random

*epeidh einai 0 prepei na tou prosthesoume 0.5*
replace TnoFrem=TnoFrem+0.5 if StudyID==2
replace CnoFrem=CnoFrem+0.5 if StudyID==2

replace TnoFrem=TnoFrem+0.5 if StudyID==4
replace CnoFrem=CnoFrem+0.5 if StudyID==4

replace GrpAN=GrpAN+1 if StudyID==2
replace GrpBN=GrpBN+1 if StudyID==2

replace GrpAN=GrpAN+1 if StudyID==4
replace GrpBN=GrpBN+1 if StudyID==4

replace GrpAFrem=GrpAN-TnoFrem
replace GrpBFrem=GrpBN-CnoFrem


* gen gia logor kai selogor*
gen logor=log((TnoFrem/GrpAFrem)/(CnoFrem/GrpBFrem))

gen selogor=sqrt((1/TnoFrem)+(1/GrpAFrem)+(1/CnoFrem)+(1/GrpBFrem))


*metan fixed effect model*
metan logor selogor, eform

*metan random effect model*
metan logor selogor, eform random


*metan Empirical Bayes*
metan logor selogor, eform ebayes print


*inverse variable*
metan TnoFrem GrpAFrem CnoFrem GrpBFrem, or fixedi

*meleti me magaluterh epidrash fixed effect model*
metaninf logor selogor, eform print

*random effect model (metainf)
metaninf logor selogor, eform print random

*metabias*
metabias logor selogor, egger graph




