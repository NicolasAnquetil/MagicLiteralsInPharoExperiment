Class {
	#name : #MLIPAbstractMessageLiteralFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#instVars : [
		'selector',
		'literalValidationBlock'
	],
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #'instance creation' }
MLIPAbstractMessageLiteralFilter class >> selector: aSymbol literalType: aClass [
	^ self new
		selector: aSymbol;
		literalType: aClass;
		yourself
]

{ #category : #'instance creation' }
MLIPAbstractMessageLiteralFilter class >> selector: aSymbol literalValue: anObject [
	^ self new
		selector: aSymbol;
		literalValue: anObject;
		yourself
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> literalType: aClass [
	self literalValidationBlock: [ :astNode | astNode value isKindOf: aClass ]
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> literalValidationBlock [
	^ literalValidationBlock
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> literalValidationBlock: anObject [
	literalValidationBlock := anObject
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> literalValue: anObject [
	self literalValidationBlock: [ :astNode | astNode value = anObject ]
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> selector [
	^ selector
]

{ #category : #accessing }
MLIPAbstractMessageLiteralFilter >> selector: anObject [
	selector := anObject
]
