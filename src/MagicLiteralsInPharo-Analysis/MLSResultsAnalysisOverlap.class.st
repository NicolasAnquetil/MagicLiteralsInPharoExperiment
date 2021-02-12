"
Analysis of literals that were evaluated by more than 1 participant
"
Class {
	#name : #MLSResultsAnalysisOverlap,
	#superclass : #MLSResultsAnalysis,
	#instVars : [
		'fieldAccess',
		'one',
		'more'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #collecting }
MLSResultsAnalysisOverlap >> collectLiteralDescription [
	^literals collect: [ :lit ||desc|
		desc := Dictionary new: fieldAccess size.
		fieldAccess keysAndValuesDo: [ :fld :fldBlock |
			desc
				at: fld
				put: (fldBlock value: lit)
			].
		desc
	]

]

{ #category : #collecting }
MLSResultsAnalysisOverlap >> collectOverlaps [
	^(literals groupedBy: [ :l | self literalIdentifier: l])
		reject: [ :assoc | assoc value size = 1 ]
]

{ #category : #API }
MLSResultsAnalysisOverlap >> conflictingOverlaps [
	| over |
	over := self collectOverlaps.
	^over
		select: [ :litOvr |
			(litOvr value anySatisfy: [ :desc | (desc at: #status) isMagic ])
			and: [ litOvr value anySatisfy: [ :desc | (desc at: #status) isNotMagic ] ] ]

]

{ #category : #API }
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

{ #category : #initialization }
MLSResultsAnalysisOverlap >> initialize [
	super initialize.
	fieldAccess := self exportedFields asDictionary
]

{ #category : #private }
MLSResultsAnalysisOverlap >> literalIdentifier: aLiteral [
	^aLiteral method name , '/' , (aLiteral idInMethod asString)
]

{ #category : #collecting }
MLSResultsAnalysisOverlap >> minExpertiseBetween: literal1 and: literal2 [
	| expertiseBlock expertiseOrder expertise1 expertise2 |
	expertiseOrder := #(low medium high).
	expertiseBlock := fieldAccess at: #expertise.

	expertise1 := expertiseOrder indexOf: (expertiseBlock value: literal1).
	expertise2 := expertiseOrder indexOf: (expertiseBlock value: literal2).
	
	^(expertise1 < expertise2)
		ifTrue: [ literal1 ]
		ifFalse: [ literal2 ]
]

{ #category : #API }
MLSResultsAnalysisOverlap >> resolveConflictsInFavorOfNewbie [
	| literalDict |
	literalDict := Dictionary new.
	one := OrderedCollection new.
	more := OrderedCollection new.

	literals do: [:lit || litID |
		litID := self literalIdentifier: lit.
		literalDict
			at: litID
			ifPresent: [ :otherLit |
				more add: lit.
				literalDict at: litID put: (self resolveInFavorOfNewbie: lit and: otherLit) ]
			ifAbsent: [
				one add: lit.
				literalDict at: litID put: lit ]
		
	].
	^literalDict values
]

{ #category : #collecting }
MLSResultsAnalysisOverlap >> resolveInFavorOfNewbie: literal1 and: literal2 [
	literal1 isUnknown ifTrue: [ ^literal2 ].
	literal2 isUnknown ifTrue: [ ^literal1 ].

	^self minExpertiseBetween: literal1 and: literal2

]

{ #category : #API }
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
