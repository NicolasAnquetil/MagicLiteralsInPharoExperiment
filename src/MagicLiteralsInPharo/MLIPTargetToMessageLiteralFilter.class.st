Class {
	#name : #MLIPTargetToMessageLiteralFilter,
	#superclass : #MLIPAbstractMessageLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPTargetToMessageLiteralFilter >> isNotMagicLiteral: literal [
	| rbNode |
	(self isTarget: literal) ifFalse: [ ^false "i.e. might be magical" ].

	rbNode := literal node.
	^ (self literalValidationBlock value: rbNode) and: [ 
		rbNode parent isMessage and: [ 
			 
				rbNode parent selector = self selector ] ]
]

{ #category : #testing }
MLIPTargetToMessageLiteralFilter >> isTarget: literal [
	"literal is argument of a message send"
	^(super isTarget: literal)
		and: [ literal node parent receiver = literal node ]
]
