"
A MLIPArgumentOfMessageLiteralFilterTest is a test class for testing the behavior of MLIPArgumentOfMessageLiteralFilter
"
Class {
	#name : #MLIPArgumentOfMessageLiteralFilterTest,
	#superclass : #MLIPFiltersTest,
	#instVars : [
		'literalNode1',
		'literalNode2'
	],
	#category : #'MagicLiteralsInPharo-Tests-Filters'
}

{ #category : #running }
MLIPArgumentOfMessageLiteralFilterTest >> setUp [
	| messageNode |
	literalNode1 := RBLiteralValueNode value: nil.
	literalNode2 :=  RBLiteralValueNode value: nil.
	messageNode := RBMessageNode receiver: (RBVariableNode named: 'foo') selector: #copyFrom:to: arguments: {literalNode1.literalNode2}.
	literalNode1 parent: messageNode.
	literalNode2 parent: messageNode.

]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral [
	literalNode1 value: 1 start: 0 stop: -1.
	literalNode2 value: 'str' start: 0 stop: -1.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #copyFrom:to: literalType: Integer.

	self assert: (self filterNode: literalNode1).
	self deny: (self filterNode: literalNode2).
]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral2 [
	literalNode1 value: 1 start: 0 stop: -1.
	literalNode2 value: 'str' start: 0 stop: -1.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #copyFrom:to: literalValue: 1.

	self assert: (self filterNode: literalNode1).
	self deny: (self filterNode: literalNode2).
]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral3 [
	literalNode1 value: 1 start: 0 stop: -1.
	literalNode2 value: 42 start: 0 stop: -1.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #copyFrom:to: literalType: Integer index: 2.

	self deny: (self filterNode: literalNode1).
	self assert: (self filterNode: literalNode2).
]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral4 [
	literalNode1 value: 1 start: 0 stop: -1.
	literalNode2 value: 42 start: 0 stop: -1.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #copyFrom:to: literalValue: 42 index: 2.

	self deny: (self filterNode: literalNode1).
	self assert: (self filterNode: literalNode2).
]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral5 [
	literalNode1 value: 1 start: 0 stop: -1.
	literalNode2 value: 41 start: 0 stop: -1.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #copyFrom:to: literalValue: 42 index: 2.

	self deny: (self filterNode: literalNode1).
	self deny: (self filterNode: literalNode2).
]

{ #category : #test }
MLIPArgumentOfMessageLiteralFilterTest >> testIsNotMagicLiteral6 [
	| messageNode |
	literalNode1 value: 1 start: 0 stop: -1.
	messageNode := literalNode1 parent.
	messageNode
		selector: #+ ;
		arguments: {literalNode1}.

	filter := MLIPArgumentOfMessageLiteralFilter selector: #+ literalValue: 1 index: 1.

	self assert: (self filterNode: literalNode1).
]
