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

{ #category : #'as yet unclassified' }
MLIPAnalysisInImage >> latexTestVsCode [
	^String streamContents:  [ :stream |
		self testVsCodeDistribution do: [ :values ||test testPercent notTest|
			test := values first.
			notTest:= values second.
			testPercent := (test / (test + notTest)) asFloat * 100.
			stream
				nextPutAll: (test asString) ;
				nextPutAll: ' & '.
			testPercent printOn: stream showingDecimalPlaces: 1.
			stream
				nextPutAll: ' & ' ;
				nextPutAll: (notTest asString) ;
				cr.
			].
		]
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

{ #category : #'as yet unclassified' }
MLIPAnalysisInImage >> testVsCodeDistribution [
	^self literalsTypes collect: [ :lType |
		self testVsCodeFor: lType
	]
]

{ #category : #'as yet unclassified' }
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
