Class {
	#name : #MLIPEmptyLiteralArrayFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPEmptyLiteralArrayFilter >> isNotMagicLiteral: literal [
	^ (self isTarget: literal) and: [ literal node contents isEmpty ]
]

{ #category : #testing }
MLIPEmptyLiteralArrayFilter >> isTarget: literal [
	^literal node isLiteralArray
]
