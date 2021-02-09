Class {
	#name : #MLIPArgumentOfMessageLiteralFilter,
	#superclass : #MLIPAbstractMessageLiteralFilter,
	#instVars : [
		'expectedIndex'
	],
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #'instance creation' }
MLIPArgumentOfMessageLiteralFilter class >> selector: aSymbol literalType: aClass index: anInteger [
	^ (self selector: aSymbol literalType: aClass)
		expectedIndex: anInteger;
		yourself
]

{ #category : #'instance creation' }
MLIPArgumentOfMessageLiteralFilter class >> selector: aSymbol literalValue: anObject index: anInteger [
	^ (self selector: aSymbol literalValue: anObject)
		expectedIndex: anInteger;
		yourself
]

{ #category : #accessing }
MLIPArgumentOfMessageLiteralFilter >> expectedIndex [
	^ expectedIndex
]

{ #category : #accessing }
MLIPArgumentOfMessageLiteralFilter >> expectedIndex: anObject [
	expectedIndex := anObject
]

{ #category : #testing }
MLIPArgumentOfMessageLiteralFilter >> isNotMagicLiteral: literal [
	| rbNode |
	(self isTarget: literal) ifFalse: [ ^false "i.e. might be magical" ].

	rbNode := literal node.	
	(self literalValidationBlock value: rbNode)
		ifFalse: [^false].
	(self expectedIndex isNil or: [ self expectedIndex = (rbNode parent arguments indexOf: rbNode) ])
		 ifFalse: [^false].
	^rbNode parent selector = self selector

]

{ #category : #testing }
MLIPArgumentOfMessageLiteralFilter >> isTarget: literal [
	"literal is argument of a message send"
	^(super isTarget: literal)
		and: [ literal node parent arguments includes: literal node ]
]
