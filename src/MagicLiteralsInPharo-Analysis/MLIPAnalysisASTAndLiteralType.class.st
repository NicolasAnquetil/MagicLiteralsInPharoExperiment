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
		self class parentNodeClasses
			with: self class parentNodeNames
			do: [ :class : name |
				stream
					nextPutAll: name ;
					nextPut: $; ;
					nextPutAll: ((distribution at: class) asString) ;
					cr.
			]
	]
]

{ #category : #outputting }
MLIPAnalysisASTAndLiteralType >> distribution [
	| distrib |
	distrib := Dictionary new.
	self class parentNodeClasses
		do: [ :astClass || nb |
			self class literalsTypes do: [ :litTyp |
				nb := distrib at: (astClass -> litTyp) ifAbsent: [ 0 ].
				methods do: [ :m |
					nb := nb +
						(m literalCandidates count: [ :lit |
							(lit astTypeIs: astClass) and:
							[ litTyp accept: lit] ])
				].
				distrib at: (astClass -> litTyp) put: nb.
			].
		].
	^distrib 
]
