Class {
	#name : #MLIPDirectlyAssignedFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #testing }
MLIPDirectlyAssignedFilter >> isNotMagicLiteral: literalNode [
	|parents assignmentIndex|
	parents := literalNode node parents.
	assignmentIndex := parents detectIndex: #isAssignment ifNone: [ ^ false ].
	^ (parents copyFrom: assignmentIndex + 1 to: parents size - 1)
		allSatisfy: [ :node | node isLiteralArray ]
]
