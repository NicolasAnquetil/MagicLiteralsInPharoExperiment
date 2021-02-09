Class {
	#name : #MLIPPragmaArgumentFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPPragmaArgumentFilter >> isNotMagicLiteral: literalNode [
	^ literalNode node parent isPragma
]
