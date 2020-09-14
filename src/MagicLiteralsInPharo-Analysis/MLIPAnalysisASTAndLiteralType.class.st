Class {
	#name : #MLIPAnalysisASTAndLiteralType,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis'
}

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> literalsTypes [
	^ MLIPAnalysisLiteralTypes literalsTypes first: 3
]

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> parentNodeClasses [
	^ MLIPAnalysisASTNodes parentNodeClasses first: 2
]

{ #category : #accessing }
MLIPAnalysisASTAndLiteralType class >> parentNodeNames [
	^ MLIPAnalysisASTNodes parentNodeNames first: 2
]

{ #category : #outputting }
MLIPAnalysisASTAndLiteralType >> csv [
	^String streamContents:  [ :stream |
		| distribution |
		distribution := self astNodeDistribution.
		self class parentNodeClasses
			with: self class parentNodeNames
			do: [ :class : name |
				stream
					nextPutAll: name ;
					nextPut: $; ;
					nextPutAll: ((distribution at: class) asString) ;
					cr.
			]
	]
]
