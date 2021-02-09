"
A MLIPStringFilterTest is a test class for testing the behavior of MLIPStringFilter
"
Class {
	#name : #MLIPStringFilterTest,
	#superclass : #MLIPFiltersTest,
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPStringFilterTest >> setUp [
	super setUp.
	filter := MLIPStringFilter new
]

{ #category : #test }
MLIPStringFilterTest >> testIsNotMagicLiteral [
	self assert: (self filterNode: (RBLiteralNode value: 'Hello you')).
	
	self assert: (self filterNode: (RBLiteralNode value: 'Hello?!')).
	
	self deny: (self filterNode: (RBLiteralNode value: 'deqdqdqw')).
	
	self deny: (self filterNode: (RBLiteralNode value: 'Hello  dqdww wwdwee'))
]
