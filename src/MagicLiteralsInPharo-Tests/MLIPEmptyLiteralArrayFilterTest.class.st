"
A MLIPEmptyLiteralArrayFilterTest is a test class for testing the behavior of MLIPEmptyLiteralArrayFilter
"
Class {
	#name : #MLIPEmptyLiteralArrayFilterTest,
	#superclass : #MLIPFiltersTest,
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPEmptyLiteralArrayFilterTest >> setUp [
	super setUp.
	filter := MLIPEmptyLiteralArrayFilter new
]

{ #category : #test }
MLIPEmptyLiteralArrayFilterTest >> testIsNotMagicLiteral [
	self assert: (self filterNode: (RBLiteralArrayNode value: #())).
	
	self deny: (self filterNode: (RBLiteralArrayNode value: #(1 2 3))).
	
	self deny: (self filterNode: (RBLiteralValueNode value: 42))
]
