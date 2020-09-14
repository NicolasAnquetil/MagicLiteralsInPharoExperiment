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

{ #category : #statistics }
MLIPAnalysisASTNodes >> astNodeDistribution [
	| countByParentClass |
	countByParentClass := Dictionary new.
	MLIPAnalysisASTNodes parentNodeClasses
		do: [ :c || nb |
			nb := countByParentClass at: c ifAbsent: [ 0 ].
			methods do: [ :m |
				nb := nb +
					(m literalCandidates count: [ :lit | lit astTypeIs: c ])
				].
			countByParentClass at: c put: nb.
		].
	^countByParentClass 
]

{ #category : #outputting }
MLIPAnalysisASTNodes >> csv [
	^String streamContents:  [ :stream |
		| grandTotal distribution |
		grandTotal := 0.
		distribution := self astNodeDistribution.
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
