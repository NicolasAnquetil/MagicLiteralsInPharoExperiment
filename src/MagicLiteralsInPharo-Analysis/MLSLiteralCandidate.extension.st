Extension { #name : #MLSLiteralCandidate }

{ #category : #'*MagicLiteralsInPharo-Analysis' }
MLSLiteralCandidate >> astTypeIs: astType [
	| parentNode |
	parentNode := self astNode parent.
	(parentNode class = astType) ifTrue: [ ^true ].
	(parentNode class = RBMessageNode) ifFalse: [ ^ false].
	"Fine decomposition of all RBMessageNode"
	((astType = #receiver) and: "receiver of binary message -> operand"
		[ parentNode receiver = self astNode and:
		[ parentNode isBinary not]])
		ifTrue: [ ^true ].
	((astType = #binaryArg) and:
		[ parentNode receiver = self astNode and:
		[ parentNode isBinary]])
		ifTrue: [ ^true ].
	((astType = #binaryArg) and:
		[ parentNode receiver ~= self astNode and:
		[ parentNode isBinary]])
		ifTrue: [ ^true ].
	((astType = #keywordArg) and:
		[ parentNode receiver ~= self astNode and: 
		[ parentNode isKeyword]])
		ifTrue: [ ^true ].
	^false
]
