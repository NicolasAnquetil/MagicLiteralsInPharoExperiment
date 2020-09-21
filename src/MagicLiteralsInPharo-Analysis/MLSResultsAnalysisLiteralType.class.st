Class {
	#name : #MLSResultsAnalysisLiteralType,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #accessing }
MLSResultsAnalysisLiteralType class >> literalsTypes [
	^ MLIPDescriptiveAnalysisLiteralTypes literalsTypes
]

{ #category : #statistics }
MLSResultsAnalysisLiteralType >> csv [
	| distribution |
	distribution := self distribution asDictionary.
	^String streamContents:  [ :stream |
		self csvHeader: stream.
			self class literalsTypes do: [ :litTyp |
				stream
					nextPutAll: litTyp name.
				self class allProjects do: [ :proj ||noTestAndTest|
					noTestAndTest := (distribution at: proj) at: litTyp name ifAbsent: [ #(0 0 ) ].
					stream
						nextPut: $; ;
						nextPutAll: noTestAndTest first asString ;
						nextPut: $; ;
						nextPutAll: noTestAndTest second asString
				].
				stream cr
			].
		stream
	]
]

{ #category : #statistics }
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
			nextPutAll: ';noTest;test'
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
	(self uniqLiterals: someLiterals)
		do: [ :lits || lit litType |
			lit := lits anyOne.
			litType := distrib
				at: (self detectLiteralKind: lit)
				ifAbsentPut: [ {0 . 0} ].
			lit method isTestMethod
				ifFalse: [ litType at: 1 put: (litType first + 1) ]
				ifTrue:  [ litType at: 2 put: (litType second + 1) ].
		].
	^distrib
	
]
