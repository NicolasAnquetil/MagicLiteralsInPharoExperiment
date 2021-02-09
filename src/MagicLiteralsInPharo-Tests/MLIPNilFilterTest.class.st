"
A MLIPNilFilterTest is a test class for testing the behavior of MLIPNilFilter
"
Class {
	#name : #MLIPNilFilterTest,
	#superclass : #MLIPFiltersTest,
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPNilFilterTest >> setUp [
	super setUp.
	filter := MLIPNilFilter new
]

{ #category : #test }
MLIPNilFilterTest >> testIsNotMagicLiteral [
	self assert: (self filterNode: (RBLiteralValueNode value: nil)).
	
	self deny: (self filterNode: (RBLiteralValueNode value: 42)).
	
	self deny: (self filterNode: (RBLiteralValueNode value: true)).
]
