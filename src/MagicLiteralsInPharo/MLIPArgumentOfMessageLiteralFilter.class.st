Class {
	#name : #MLIPArgumentOfMessageLiteralFilter,
	#superclass : #MLIPTargetToMessageLiteralFilter,
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
MLIPArgumentOfMessageLiteralFilter >> isNotMagicLiteral: literalNode [
	| indexOfArgument rbNode |
	rbNode := literalNode node.
	indexOfArgument := rbNode parent isMessage
								ifTrue: [ rbNode parent arguments indexOf: rbNode ]
								ifFalse: [ -1 "Same value as if #indexOf: found nothing." ].
	^ (self literalValidationBlock value: rbNode) and: [ 
		(self expectedIndex isNil or: [ self expectedIndex = indexOfArgument ]) and: [
			rbNode parent isMessage and: [ 
				rbNode parent receiver ~= rbNode and: [ 
					rbNode parent selector = self selector ] ] ] ]
]
