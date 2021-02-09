Class {
	#name : #MLIPBooleanFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPBooleanFilter >> isNotMagicLiteral: literalNode [
	^(literalNode value = true) or: [literalNode value = false]
]
