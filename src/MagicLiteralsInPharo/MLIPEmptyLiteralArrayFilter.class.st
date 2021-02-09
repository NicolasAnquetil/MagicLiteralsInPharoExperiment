Class {
	#name : #MLIPEmptyLiteralArrayFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPEmptyLiteralArrayFilter >> isNotMagicLiteral: literalNode [
	^ literalNode node isLiteralArray and: [ literalNode node contents isEmpty ]
]
