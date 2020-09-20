Class {
	#name : #MLSResultsAnalysisLiteralType,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #'as yet unclassified' }
MLSResultsAnalysisLiteralType class >> allProjects [
	^#( 'morphic' 'parser' 'Pharo' 'PolyMath' 'Roassal' 'Seaside' 'VMMaker' )
]

{ #category : #statistics }
MLSResultsAnalysisLiteralType >> csv [
	| distribution |
	distribution := self distribution.
	^String streamContents:  [ :stream |
		stream
			nextPutAll: '         '.
		distribution values first keysDo: [ :proj |
			stream
				nextPut: $; ;
				nextPutAll: proj ;
				nextPut: $;
		].
		stream cr.
		distribution
			keysAndValuesDo: [ :litTyp :distrib |
				stream
					nextPutAll: litTyp.
				distrib valuesDo: [ :noTestAndTest |
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
