Class {
	#name : #MLIPAnalysisASTAndLiteralType,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis'
}

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> literalsTypes [
	^ MLIPAnalysisLiteralTypes literalsTypes first: 3
]

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> parentNodeClasses [
	^ MLIPAnalysisASTNodes parentNodeClasses first: 2
]

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> parentNodeNames [
	^ MLIPAnalysisASTNodes parentNodeNames first: 2
]

{ #category : #outputting }
MLIPAnalysisASTAndLiteralType >> csv [
	^String streamContents:  [ :stream |
		| distribution |
		distribution := self distribution.

		stream nextPutAll: '        '.
		self class literalsTypes do: [ :litTyp |
			stream
				nextPut: $; ;
				nextPutAll: litTyp literalClass name
		].
		stream cr.

		self class parentNodeClasses
			with: self class parentNodeNames
			do: [ :astClass : name || classDistrib |
				classDistrib := distribution at: astClass.
				stream nextPutAll: name.
				self class literalsTypes do: [ :litTyp |
					stream
						nextPut: $; ;
						nextPutAll: ((classDistrib at: litTyp ifAbsent: [0]) asString)
				].
				stream cr
		]
	]
]

{ #category : #outputting }
MLIPAnalysisASTAndLiteralType >> distribution [
	| distrib |
	distrib := Dictionary new: 2.
	self class parentNodeClasses
		do: [ :astClass || nb |
			self class literalsTypes do: [ :litTyp || classDistrib |
				classDistrib  := distrib at: astClass ifAbsentPut: [ Dictionary new: 3].
				nb := classDistrib at: litTyp ifAbsent: [ 0 ].
				methods do: [ :m |
					nb := nb +
						(m literalCandidates count: [ :lit |
							(lit astTypeIs: astClass) and:
							[ litTyp accept: lit] ])
				].
				classDistrib at: litTyp put: nb.
			].
		].
	^distrib 
]
