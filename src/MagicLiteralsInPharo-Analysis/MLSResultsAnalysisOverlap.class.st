Class {
	#name : #MLSResultsAnalysisOverlap,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #collecting }
MLSResultsAnalysisOverlap >> collectLiteralDescription [
	^self collectLiteralDescription: self exportedFields withFilter: [ :lit | true ]
]

{ #category : #collecting }
MLSResultsAnalysisOverlap >> collectLiteralDescription: fieldList withFilter: filterBlock [
	^(literals select: filterBlock)
		collect: [ :lit ||desc|
			desc := Dictionary new: fieldList size.
			fieldList do: [ :fld || fldBlock |
				fldBlock := fld value.
				desc
					at: fld key
					put: (fldBlock value: lit)
			].
			desc
		]

]

{ #category : #run }
MLSResultsAnalysisOverlap >> collectOverlaps [
	^(self collectLiteralDescription
		groupedBy: [ :d | (d at: #method) -> (d at: #idInMethod)])
		reject: [ :assoc | assoc value size = 1 ]
	
]

{ #category : #run }
MLSResultsAnalysisOverlap >> conflictingOverlaps [
	| over |
	over := self collectOverlaps.
	^over
		select: [ :litOvr |
			(litOvr value anySatisfy: [ :desc | (desc at: #status) isMagic ])
			and: [ litOvr value anySatisfy: [ :desc | (desc at: #status) isNotMagic ] ] ]

]

{ #category : #run }
MLSResultsAnalysisOverlap >> conflictingOverlapsExpertise [
	| over |
	over := self collectOverlaps.
	^over
		select: [ :litOvr |
			(litOvr value anySatisfy: [ :desc | (desc at: #status) isMagic ])
			and: [ litOvr value anySatisfy: [ :desc | (desc at: #status) isNotMagic ] ] ]
		thenCollect: [ :litOvr |
			litOvr collect: [ :desc | (desc at: #expertise) -> ((desc at: #status) asString) ]
		]
]

{ #category : #run }
MLSResultsAnalysisOverlap >> statsOverlaps [
	| over |
	over := self collectOverlaps
		collect: [ :assoc | assoc value size ].
	^{
	#number -> over size .
	#sum -> over sum.
	#avg -> over average asFloat .
	#median -> over median .
	#min -> over min .
	#max -> over max
	}
	
]
