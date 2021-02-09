"
Filter to decide if a literal is magic

call #isNotMagicLiteral: on the literal to test

see subclasses, particularly MLIPCompositeMagicLiteralFilter
"
Class {
	#name : #MLIPMagicLiteralFilter,
	#superclass : #Object,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPMagicLiteralFilter >> isNotMagicLiteral: literalNode [
	"Returns true if literal node is not a magic literal."
	^ self subclassResponsibility
]
