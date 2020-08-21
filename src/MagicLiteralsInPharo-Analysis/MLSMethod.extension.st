Extension { #name : #MLSMethod }

{ #category : #'*MagicLiteralsInPharo-Analysis' }
MLSMethod >> literalsOfType: lType [
	^self literalCandidates select: [ :lit | lType accept: lit ]
]
