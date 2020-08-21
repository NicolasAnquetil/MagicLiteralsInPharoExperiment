"
Similar to MLIPAnalysisDB but using in image objects instead of a DB with the literals
"
Class {
	#name : #MLIPAnalysisInImage,
	#superclass : #Object,
	#instVars : [
		'methods',
		'methodFilters'
	],
	#category : #'MagicLiteralsInPharo-Analysis'
}

{ #category : #accessing }
MLIPAnalysisInImage >> allLiterals [
	^methods flatCollect: #literalCandidates
]

{ #category : #outputting }
MLIPAnalysisInImage >> csvTestVsCode [
	^String streamContents:  [ :stream |
		self printTestVsCodeOn: stream separatedBy: ';'
	].
]

{ #category : #running }
MLIPAnalysisInImage >> filterSample: methodsSample [
	^methodsSample select: [ :meth |
		methodFilters allSatisfy: [ :filter | filter accept: meth ]
	]
]

{ #category : #initialization }
MLIPAnalysisInImage >> initialize [ 
	super initialize .

	methodFilters := {
		MLSExperimentFilterWithLiteral new . 
	}

]

{ #category : #outputting }
MLIPAnalysisInImage >> latexTestVsCode [
	^String streamContents:  [ :stream |
		self printTestVsCodeOn: stream separatedBy: ' & '
	].
]

{ #category : #accessing }
MLIPAnalysisInImage >> literalsTypes [
	^{
	MLIPLiteralTypes forClass: Integer .
	MLIPLiteralTypes forClass: String .
	MLIPLiteralTypes forClass: Symbol .
	MLIPLiteralTypes forClass: Boolean .
	MLIPLiteralTypes forClass: Array .
	MLIPLiteralTypes class: UndefinedObject testSelector: #isNilLiteral .
	MLIPLiteralTypes forClass: Character .
	MLIPLiteralTypes forClass: Float
	}
]

{ #category : #accessing }
MLIPAnalysisInImage >> methodFilters [
	^ methodFilters
]

{ #category : #accessing }
MLIPAnalysisInImage >> methodFilters: anObject [
	methodFilters := anObject
]

{ #category : #statistics }
MLIPAnalysisInImage >> numberOfLiterals [
	^self allLiterals size
]

{ #category : #running }
MLIPAnalysisInImage >> onSample: aCollectionOfMethods [
	methods := self filterSample: aCollectionOfMethods 
]

{ #category : #outputting }
MLIPAnalysisInImage >> printTestVsCodeOn: stream separatedBy: stringSeparator [
	| grandTotal |
	grandTotal := 0.
	self testVsCodeDistribution do: [ :values |
		grandTotal := grandTotal + (values at: #totalType).
		stream
			nextPutAll: ((values at: #totalType) asString) ;
			nextPutAll: stringSeparator.
			(values at: #percentType) printOn: stream showingDecimalPlaces: 1.
			stream
				nextPutAll: stringSeparator ;
				nextPutAll: ((values at: #nbTest) asString) ;
				nextPutAll: stringSeparator.
			(values at: #percentTest) printOn: stream showingDecimalPlaces: 1.
			stream
				nextPutAll: stringSeparator ;
				nextPutAll: ((values at: #nbNotTest) asString) ;
				cr.
			].
		stream
			nextPutAll: (grandTotal asString) ;
			nextPutAll: stringSeparator ;
			nextPutAll: stringSeparator ;
			nextPutAll: stringSeparator ;
			nextPutAll: stringSeparator ;
			cr

]

{ #category : #statistics }
MLIPAnalysisInImage >> testVsCodeDistribution [
	| allResults grandTotal |
	grandTotal := 0.
	allResults := self literalsTypes collect: [ :lType || result |
		result := self testVsCodeFor: lType.
		grandTotal := grandTotal + result sum.
		result
	].
	^allResults collect: [:res ||return|
		return := SmallDictionary new: 5.
		return at: #totalType put: res sum.
		return at: #nbTest put: res first .
		return at: #nbNotTest put: res second.
		return at: #percentType put: ((return at: #totalType) / grandTotal) asFloat * 100 .
		return at: #percentTest put: (res first / (return at: #totalType)) asFloat * 100 .
		return
	]
]

{ #category : #statistics }
MLIPAnalysisInImage >> testVsCodeFor: aLiteralType [
	| test notTest |
	test := 0.
	notTest := 0.
	methods do: [ :meth |
		meth isTestMethod
			ifTrue: [ test := test + (meth literalsOfType: aLiteralType) size ]
			ifFalse: [ notTest := notTest + (meth literalsOfType: aLiteralType) size ]
	].
	^{test . notTest}
]
