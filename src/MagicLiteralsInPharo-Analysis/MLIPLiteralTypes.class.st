Class {
	#name : #MLIPLiteralTypes,
	#superclass : #Object,
	#instVars : [
		'literalClass',
		'testSelector'
	],
	#category : #'MagicLiteralsInPharo-Analysis-DescriptiveStats'
}

{ #category : #'as yet unclassified' }
MLIPLiteralTypes class >> class: aClass testSelector: aSymbol [ 
	^self new
		literalClass: aClass ;
		testSelector: aSymbol ;
		yourself
]

{ #category : #'as yet unclassified' }
MLIPLiteralTypes class >> forClass: aClass [
	^self class: aClass testSelector: ('is' , aClass name , 'Literal') asSymbol
]

{ #category : #visiting }
MLIPLiteralTypes >> accept: aLiteralCandidate [
	^testSelector value: aLiteralCandidate 
]

{ #category : #accessing }
MLIPLiteralTypes >> literalClass [
	^ literalClass
]

{ #category : #accessing }
MLIPLiteralTypes >> literalClass: anObject [
	literalClass := anObject
]

{ #category : #accessing }
MLIPLiteralTypes >> name [ 
	^self literalClass name
]

{ #category : #accessing }
MLIPLiteralTypes >> testSelector [
	^ testSelector
]

{ #category : #accessing }
MLIPLiteralTypes >> testSelector: anObject [
	testSelector := anObject
]
