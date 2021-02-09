"
A MLIPSymbolFilterTest is a test class for testing the behavior of MLIPSymbolFilter
"
Class {
	#name : #MLIPSymbolFilterTest,
	#superclass : #MLIPFiltersTest,
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPSymbolFilterTest >> setUp [
	super setUp.
	filter := MLIPSymbolFilter new
]

{ #category : #test }
MLIPSymbolFilterTest >> testIsNotMagicLiteral [
	self assert: (self filterNode: (RBLiteralValueNode value: #anySymbol)).
	self assert: (self filterNode: (RBLiteralValueNode value: #anySymbol:)).
	
	self deny: (self filterNode: (RBLiteralValueNode value: 42)).
]
