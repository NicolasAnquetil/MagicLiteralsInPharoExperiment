"
Computes efficiency of heuristics to detect non-matgic literals
"
Class {
	#name : #MLSResultsAnalysisAutomaticHeuristic,
	#superclass : #MLSResultsAnalysis,
	#instVars : [
		'filter'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #API }
MLSResultsAnalysisAutomaticHeuristic >> csv [
	| magic undecided notMagic |
	magic := self statsForKind: #isMagic.
	undecided := self statsForKind: #isUnknown.
	notMagic := self statsForKind: #isNotMagic.
	^String streamContents: [ :stream |
		stream
			<< '                   ;isMagic;undecided;notMagic' ;
			cr.
		self
			csvRow: 'total' 
			data: { magic x . undecided x . notMagic x } 
			onStream: stream.
		self 
			csvRow: 'notMagic(heuristic)' 
			data: { magic y . undecided y . notMagic y } 
			onStream: stream			
	]
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> csvRow: aString data: data onStream: aStream [
	aStream
		<< aString ;
		<< $; ;
		<< data first asString ;
		<< $; ;
		<< data second asString ;
		<< $; ;
		<< data third asString ;
		cr

]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> filter [
	^ filter
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> filter: anObject [
	filter := anObject
]

{ #category : #initialization }
MLSResultsAnalysisAutomaticHeuristic >> initialize [ 
	super initialize.
	filter := MLIPCompositeMagicLiteralFilter withDefaultFilters
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> statsForKind: aSelector [
	^(self literals count: [ :l | l perform: aSelector ]) @
	(self literals count: [ :l | (l perform: aSelector)  and: [ filter isNotMagicLiteral: l ] ])
]
