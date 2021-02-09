"
A MLIPTargetToMessageLiteralFilterTest is a test class for testing the behavior of MLIPTargetToMessageLiteralFilter
"
Class {
	#name : #MLIPTargetToMessageLiteralFilterTest,
	#superclass : #MLIPFiltersTest,
	#instVars : [
		'filter2',
		'literalNode'
	],
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPTargetToMessageLiteralFilterTest >> setUp [
	| argNode messageNode |

	super setUp.
	filter := MLIPTargetToMessageLiteralFilter selector: #timesRepeat: literalType: Integer.
	filter2 := MLIPTargetToMessageLiteralFilter selector: #timesRepeat: literalValue: 1.

	literalNode := RBLiteralValueNode new.
	argNode := RBBlockNode new.
	messageNode := RBMessageNode receiver: literalNode selector: #foo: arguments: {argNode}.
	literalNode parent: messageNode.
	argNode parent: messageNode.
]

{ #category : #test }
MLIPTargetToMessageLiteralFilterTest >> testIsNotMagicLiteral [
	literalNode value: 42 start: 0 stop: -1.
	literalNode parent selector: #timesRepeat: .
	
	self assert: (self filterNode: literalNode).	
	self deny: (filter2 isNotMagicLiteral: (self literalWith: literalNode))
]

{ #category : #test }
MLIPTargetToMessageLiteralFilterTest >> testIsNotMagicLiteral2 [
	literalNode value: 1 start: 0 stop: -1.
	literalNode parent selector: #timesRepeat: .

	self assert: (self filterNode: literalNode).
	self assert: (filter2 isNotMagicLiteral: (self literalWith: literalNode)).
]

{ #category : #test }
MLIPTargetToMessageLiteralFilterTest >> testIsNotMagicLiteral3 [
	literalNode value: 'str' start: 0 stop: -1.
	
	self deny: (self filterNode: literalNode).
	self deny: (filter2 isNotMagicLiteral: (self literalWith: literalNode)).
]

{ #category : #test }
MLIPTargetToMessageLiteralFilterTest >> testIsNotMagicLiteral4 [
	literalNode value: 1 start: 0 stop: -1.

	self deny: (self filterNode: literalNode).
	self deny: (filter2 isNotMagicLiteral: (self literalWith: literalNode)).
]
