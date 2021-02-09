Class {
	#name : #MLIPLiteralInLiteralArrayFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPLiteralInLiteralArrayFilter >> isNotMagicLiteral: literalNode [
	^ literalNode node parent isLiteralArray
]

{ #category : #testing }
MLIPLiteralInLiteralArrayFilter >> isTarget: literal [
	^true
]
