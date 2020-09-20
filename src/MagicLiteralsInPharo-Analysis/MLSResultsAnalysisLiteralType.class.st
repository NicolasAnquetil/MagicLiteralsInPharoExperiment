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
	distribution := self distribution.
	^String streamContents:  [ :stream |
		self csvHeader: stream.
			self class literalsTypes do: [ :litTyp ||distrib |
				distrib := distribution at: litTyp name.
				stream
					nextPutAll: litTyp name.
				self class allProjects do: [ :proj ||noTestAndTest|
					noTestAndTest := distrib at: proj ifAbsent: [ #(0 0 ) ].
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
	| distrib|
	distrib := Dictionary new: MLIPDescriptiveAnalysisLiteralTypes literalsTypes size.
	literals do: [ :lit || litType project |
		litType := distrib
			at: (self detectLiteralKind: lit)
			ifAbsentPut: (Dictionary new: self class allProjects size).
		project := litType
			at: (lit project)
			ifAbsent: [ {0 . 0} ].
		lit method isTestMethod
			ifTrue: [ project at: 2 put: (project second + 1) ]
			ifFalse:  [ project at: 1 put: (project first + 1) ].
		litType
			at: (lit project)
			put: project.
	].
	^distrib
	
]
