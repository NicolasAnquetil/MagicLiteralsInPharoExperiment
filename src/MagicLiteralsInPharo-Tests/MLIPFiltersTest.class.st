Class {
	#name : #MLIPFiltersTest,
	#superclass : #TestCase,
	#instVars : [
		'filter'
	],
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPFiltersTest >> filterNode: aRBNode [
	^filter isNotMagicLiteral: (self literalWith: aRBNode)
]

{ #category : #running }
MLIPFiltersTest >> literalWith: aRBNode [
	^MLSAnalysisLiteral new
		node: aRBNode ;
		yourself
]
