Class {
	#name : #MLIPTargetToMessageLiteralFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#instVars : [
		'selector',
		'literalValidationBlock'
	],
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #'instance creation' }
MLIPTargetToMessageLiteralFilter class >> selector: aSymbol literalType: aClass [
	^ self new
		selector: aSymbol;
		literalType: aClass;
		yourself
]

{ #category : #'instance creation' }
MLIPTargetToMessageLiteralFilter class >> selector: aSymbol literalValue: anObject [
	^ self new
		selector: aSymbol;
		literalValue: anObject;
		yourself
]

{ #category : #testing }
MLIPTargetToMessageLiteralFilter >> isNotMagicLiteral: literalNode [
	| rbNode |
	rbNode := literalNode node.
	^ (self literalValidationBlock value: rbNode) and: [ 
		rbNode parent isMessage and: [ 
			rbNode parent receiver = rbNode and: [ 
				rbNode parent selector = self selector ] ] ]
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> literalType: aClass [
	self literalValidationBlock: [ :astNode | astNode value isKindOf: aClass ]
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> literalValidationBlock [
	^ literalValidationBlock
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> literalValidationBlock: anObject [
	literalValidationBlock := anObject
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> literalValue: anObject [
	self literalValidationBlock: [ :astNode | astNode value = anObject ]
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> selector [
	^ selector
]

{ #category : #accessing }
MLIPTargetToMessageLiteralFilter >> selector: anObject [
	selector := anObject
]
