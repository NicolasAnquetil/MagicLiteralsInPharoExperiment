Class {
	#name : #MLSFilterResultsAnalysisCSV,
	#superclass : #MLSFilterResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #output }
MLSFilterResultsAnalysisCSV >> outputResult: values [
	stream
		<< title ;
		<< ';isMagic;undecided;notMagic' ;
		cr.
	self
		row: 'total' 
		data: {
			(self allMagic: values) size .
			(self allUndecided: values) size .
			(self allNotMagic: values) size }.
	self 
		row: 'notMagic(heuristic)' 
		data: {
			(self filteredMagic: values) size .
			(self filteredUndecided: values) size .
			(self filteredNotMagic: values) size }.
	^stream contents
]

{ #category : #private }
MLSFilterResultsAnalysisCSV >> row: aString data: data [
	stream
		<< aString ;
		<< $; ;
		<< data first asString ;
		<< $; ;
		<< data second asString ;
		<< $; ;
		<< data third asString ;
		cr

]
