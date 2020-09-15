Class {
	#name : #MLIPDescriptiveAnalysisASTAndLiteralType,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis-DescriptiveStats'
}

{ #category : #accessing }
MLIPDescriptiveAnalysisASTAndLiteralType class >> astNodeClasses [
	^ MLIPDescriptiveAnalysisASTNodes astNodeClasses first: 2
]

{ #category : #accessing }
MLIPDescriptiveAnalysisASTAndLiteralType class >> astNodeNames [
	^ MLIPDescriptiveAnalysisASTNodes astNodeNames first: 2
]

{ #category : #accessing }
MLIPDescriptiveAnalysisASTAndLiteralType class >> literalsTypes [
	^ MLIPDescriptiveAnalysisLiteralTypes literalsTypes first: 3
]

{ #category : #outputting }
MLIPDescriptiveAnalysisASTAndLiteralType >> csv [
	^String streamContents:  [ :stream |
		| distribution |
		distribution := self distribution.

		stream nextPutAll: '                '.
		self class literalsTypes do: [ :litTyp |
			stream
				nextPut: $; ;
				nextPutAll: litTyp literalClass name
		].
		stream cr.

		self class astNodeClasses
			with: self class astNodeNames
			do: [ :astClass : name || classDistrib |
				classDistrib := distribution at: astClass.
				stream nextPutAll: name.
				self class literalsTypes do: [ :litTyp |
					stream
						nextPut: $; ;
						nextPutAll: ((classDistrib at: litTyp literalClass ifAbsent: [0]) asString)
				].
				stream cr
		]
	]
]

{ #category : #outputting }
MLIPDescriptiveAnalysisASTAndLiteralType >> distribution [
	| distrib |
	distrib := Dictionary new: 2.
	self class astNodeClasses
		do: [ :astClass || nb |
			self class literalsTypes  do: [ :litTyp || classDistrib |
				classDistrib  := distrib at: astClass ifAbsentPut: [ Dictionary new: 3].
				nb := classDistrib at: litTyp literalClass ifAbsent: [ 0 ].
				methods do: [ :m |
					nb := nb +
						(m literalCandidates count: [ :lit |
							(lit astTypeIs: astClass) and:
							[ litTyp accept: lit] ])
				].
				classDistrib at: litTyp literalClass put: nb.
			].
		].
	^distrib 
]
