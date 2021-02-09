Class {
	#name : #MLSFilterResultsAnalysisRecPrec,
	#superclass : #MLSFilterResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #output }
MLSFilterResultsAnalysisRecPrec >> outputResult: values [
	| truePositives falsePositives rec prec f |
	truePositives := (self allNotMagic: values) intersection: (self filteredNotMagic: values).
	falsePositives := (self filteredMagic: values) , (self filteredUndecided: values).

	rec := (truePositives size / (self allNotMagic: values) size) asFloat
		* 100.
	prec := truePositives size / (truePositives size + falsePositives size) asFloat
		* 100.
	f := 2 * rec * prec / (rec+prec).
	stream
		<< title ;
		<< ' rec=' ;
		<< (rec truncateTo: 0.1) asString ;
		<< '% prec=' ;
		<< (prec truncateTo: 0.1) asString ;
		<< '% F=' ;
		<< (f truncateTo: 0.1) asString ;
		<< '%' ;
		cr.
	^stream contents

]
