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
	self subclassResponsibility
]

{ #category : #testing }
MLIPMagicLiteralFilter >> isTarget: literalNode [
	"Returns true if literal node is a possible target for this filter
	 It does not mean it is magic or not, only that it is the kind of nodes that the filter considers
	e.g. for a Boolean filter, a string is not a target"
	self subclassResponsibility
]
