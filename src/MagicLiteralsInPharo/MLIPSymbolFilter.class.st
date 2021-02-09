Class {
	#name : #MLIPSymbolFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPSymbolFilter >> isNotMagicLiteral: literalNode [
	^ literalNode value isSymbol
]
