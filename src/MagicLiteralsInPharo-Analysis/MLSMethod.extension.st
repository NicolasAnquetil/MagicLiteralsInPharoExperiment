Extension { #name : #MLSMethod }

{ #category : #'*MagicLiteralsInPharo-Analysis' }
MLSMethod >> literalsOfType: lType [
	^self literalCandidates count: [ :lit | lType accept: lit ]
]
