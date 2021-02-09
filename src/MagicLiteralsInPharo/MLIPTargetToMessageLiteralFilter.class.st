Class {
	#name : #MLIPTargetToMessageLiteralFilter,
	#superclass : #MLIPAbstractMessageLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPTargetToMessageLiteralFilter >> isNotMagicLiteral: literalNode [
	| rbNode |
	rbNode := literalNode node.
	^ (self literalValidationBlock value: rbNode) and: [ 
		rbNode parent isMessage and: [ 
			rbNode parent receiver = rbNode and: [ 
				rbNode parent selector = self selector ] ] ]
]
