Extension { #name : #MLSLiteralCandidate }

{ #category : #'*MagicLiteralsInPharo-Analysis' }
MLSLiteralCandidate >> astTypeIs: astType [
	(self astNode parent class = astType) ifTrue: [ ^true ].
	(self astNode parent class = RBMessageNode)
	ifTrue: [
		((astType = #receiver) and: [ self astNode parent = self ])
			ifTrue: [ ^true ].
		((astType = #arg) and: [ self astNode parent  ~= self ])
			ifTrue: [ ^true ].
	].
	^false
]
