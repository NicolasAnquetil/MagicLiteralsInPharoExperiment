Class {
	#name : #MLSResultsAnalysisLiteralType,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #accessing }
MLSResultsAnalysisLiteralType class >> allProjects [
	^super allProjects reject: [:proj | proj = 'parser']
]

{ #category : #accessing }
MLSResultsAnalysisLiteralType class >> literalsTypes [
	^ MLIPDescriptiveAnalysisLiteralTypes literalsTypes
]

{ #category : #API }
MLSResultsAnalysisLiteralType >> csv [
	| distribution |
	distribution := self distribution asDictionary.
	^String streamContents:  [ :stream |
		self csvHeader: stream.
			self class literalsTypes do: [ :litTyp |
				stream
					nextPutAll: litTyp name.
				self class allProjects do: [ :proj || magicOrNot |
					magicOrNot := (distribution at: proj) at: litTyp name ifAbsent: [ #(0 0 ) ].
					stream
						nextPut: $; ;
						nextPutAll: magicOrNot first asString ;
						nextPut: $; ;
						nextPutAll: magicOrNot second asString
				].
				stream cr
			].
		stream
	]
]

{ #category : #outputting }
MLSResultsAnalysisLiteralType >> csvHeader: stream [
	stream
		nextPutAll: '         '.
	self class allProjects do: [ :proj |
		stream
			nextPut: $; ;
			nextPutAll: proj ;
			nextPut: $;
	].
	stream cr.
	stream
		nextPutAll: '         '.
	self class allProjects do: [ :proj |
		stream
			nextPutAll: ';ok;magic'
	].
	stream cr.

]

{ #category : #statistics }
MLSResultsAnalysisLiteralType >> distribution [
	^self class allProjects collect: [ :proj |
		proj -> (self distributionForProject: proj) ]

]

{ #category : #statistics }
MLSResultsAnalysisLiteralType >> distributionForProject: aProjectName [
	^self distributionOnLiterals: (self literals select: [ :lit | lit project = aProjectName ])
]

{ #category : #statistics }
MLSResultsAnalysisLiteralType >> distributionOnLiterals: someLiterals [
	| distrib|
	distrib := Dictionary new: MLIPDescriptiveAnalysisLiteralTypes literalsTypes size.
	someLiterals
		do: [ :lit || litType |
			litType := distrib
				at: (self detectLiteralKind: lit)
				ifAbsentPut: [ {0 . 0} ].
			lit isMagic
				ifFalse: [ litType at: 1 put: (litType first + 1) ]
				ifTrue:  [ litType at: 2 put: (litType second + 1) ].
		].
	^distrib
	
]
