Class {
	#name : #MLIPNilFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPNilFilter >> isNotMagicLiteral: literal [
	^self isTarget: literal
]

{ #category : #testing }
MLIPNilFilter >> isTarget: literal [
	^  literal value isNil
]
