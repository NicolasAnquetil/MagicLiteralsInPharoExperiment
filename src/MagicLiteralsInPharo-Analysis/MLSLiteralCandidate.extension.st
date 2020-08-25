Extension { #name : #MLSLiteralCandidate }

{ #category : #'*MagicLiteralsInPharo-Analysis' }
MLSLiteralCandidate >> astTypeIs: astType [
	(self astNode parent class = astType) ifTrue: [ ^true ].
	(self astNode parent class = RBMessageNode)
	ifTrue: [
		((astType = #receiver) and: [ self astNode parent receiver = self astNode])
			ifTrue: [ ^true ].
		((astType = #keywordArg) and:
			[ self astNode parent receiver ~= self astNode and: 
			[self astNode parent isKeyword]])
			ifTrue: [ ^true ].
		((astType = #binaryArg) and:
			[ self astNode parent receiver ~= self astNode and:
			[self astNode parent isBinary]])
			ifTrue: [ ^true ].
	].
	^false
]
