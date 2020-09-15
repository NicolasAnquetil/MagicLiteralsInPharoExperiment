"
Analysis focusing AST Node types
"
Class {
	#name : #MLIPDescriptiveAnalysisASTNodes,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis-DescriptiveStats'
}

{ #category : #accessing }
MLIPDescriptiveAnalysisASTNodes class >> astNodeClasses [
	^ { #binaryArg . #keywordArg . #receiver . RBAssignmentNode. RBReturnNode. RBSequenceNode. RBPragmaNode. RBArrayNode }
]

{ #category : #accessing }
MLIPDescriptiveAnalysisASTNodes class >> astNodeNames [
	| manual |
	manual := #('Operand' 'Arg.' 'Receiver').
	^(manual ,
		((self astNodeClasses allButFirst: manual size)
			collect: [ :c | (c name allButFirst: 'RB' size) allButLast: 'Node' size ]))
		replaceAll: 'Assignment' with: 'Assign.'
]

{ #category : #outputting }
MLIPDescriptiveAnalysisASTNodes >> csv [
	^String streamContents:  [ :stream |
		| grandTotal distribution |
		grandTotal := 0.
		distribution := self distribution.
		distribution do: [ :assoc | grandTotal := grandTotal + assoc value ].

		self class astNodeClasses
			with: self class astNodeNames
			do: [ :class : name |
				stream
					nextPutAll: name ;
					nextPut: $; ;
					nextPutAll: ((distribution at: class) asString) ;
					cr
			].
		stream
			nextPutAll: 'total' ;
			nextPut: $; ;
			nextPutAll: (grandTotal asString) ;
			cr
	].
]

{ #category : #statistics }
MLIPDescriptiveAnalysisASTNodes >> distribution [
	| distrib |
	distrib := Dictionary new.
	self class astNodeClasses
		do: [ :c || nb |
			nb := distrib at: c ifAbsent: [ 0 ].
			methods do: [ :m |
				nb := nb +
					(m literalCandidates count: [ :lit | lit astTypeIs: c ])
				].
			distrib at: c put: nb.
		].
	^distrib 
]
