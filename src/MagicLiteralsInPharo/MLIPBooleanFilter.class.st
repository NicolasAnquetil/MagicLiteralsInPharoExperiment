Class {
	#name : #MLIPBooleanFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPBooleanFilter >> isNotMagicLiteral: literal [
	^(self isTarget: literal) and: [
		(literal value = true) or:
		[literal value = false]
	]
]

{ #category : #testing }
MLIPBooleanFilter >> isTarget: literal [
	^literal isBooleanLiteral
]
