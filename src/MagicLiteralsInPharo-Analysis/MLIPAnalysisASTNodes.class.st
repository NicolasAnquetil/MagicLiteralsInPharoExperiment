"
Analysis focusing AST Node types
"
Class {
	#name : #MLIPAnalysisASTNodes,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis'
}

{ #category : #accessing }
MLIPAnalysisASTNodes class >> parentNodeClasses [
	^ { #binaryArg . #keywordArg . #receiver . RBAssignmentNode. RBReturnNode. RBSequenceNode. RBPragmaNode. RBArrayNode }
]

{ #category : #accessing }
MLIPAnalysisASTNodes class >> parentNodeNames [
	| manual |
	manual := #('Operand' 'Arg.' 'Receiver').
	^(manual ,
		((self parentNodeClasses allButFirst: manual size)
			collect: [ :c | (c name allButFirst: 'RB' size) allButLast: 'Node' size ]))
		replaceAll: 'Assignment' with: 'Assign.'
]

{ #category : #outputting }
MLIPAnalysisASTNodes >> csv [
	^String streamContents:  [ :stream |
		| grandTotal distribution |
		grandTotal := 0.
		distribution := self distribution.
		distribution do: [ :assoc | grandTotal := grandTotal + assoc value ].

		self class parentNodeClasses
			with: self class parentNodeNames
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
MLIPAnalysisASTNodes >> distribution [
	| distrib |
	distrib := Dictionary new.
	self class parentNodeClasses
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
