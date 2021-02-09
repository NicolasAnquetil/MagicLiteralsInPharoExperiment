"
A MLIPBooleanFilterTest is a test class for testing the behavior of MLIPBooleanFilter
"
Class {
	#name : #MLIPBooleanFilterTest,
	#superclass : #MLIPFiltersTest,
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPBooleanFilterTest >> setUp [
	super setUp.
	filter := MLIPBooleanFilter new
]

{ #category : #test }
MLIPBooleanFilterTest >> testIsNotMagicLiteral [
	self assert: (self filterNode: (RBLiteralValueNode value: true)).
	self assert: (self filterNode: (RBLiteralValueNode value: false)).
	
	self deny: (self filterNode: (RBLiteralValueNode value: 42)).
]
