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

{ #category : #statistics }
MLIPAnalysisInImage >> astNodeDistribution [
	| countByParentClass |
	countByParentClass := Dictionary new.
	self parentNodeClasses do: [ :c || nb |
		nb := countByParentClass at: c ifAbsent: [ 0 ].
		methods do: [ :m |
			nb := nb +
				(m literalCandidates count: [ :lit | lit astTypeIs: c ])
			].
		countByParentClass at: c put: nb.
	].
	^countByParentClass 
]

{ #category : #outputting }
MLIPAnalysisInImage >> csvASTNodes [
	^String streamContents:  [ :stream |
		| grandTotal distribution |
		grandTotal := 0.
		distribution := self astNodeDistribution.
		distribution do: [ :assoc | grandTotal := grandTotal + assoc value ].
		self parentNodeClasses with: self parentNodeNames do: [ :class : name |
			stream
				nextPutAll: name ; nextPut: $; ;
				nextPutAll: ((distribution at: class) asString) ; nextPut: $; .
				((distribution at: class) / grandTotal * 100) printOn: stream showingDecimalPlaces: 1.
				stream cr.
		].
		stream
			nextPutAll: 'total' ;
			nextPut: $; ;
			nextPutAll: (grandTotal asString) ;
			nextPut: $; ;
			cr
	].
]

{ #category : #outputting }
MLIPAnalysisInImage >> csvTestVsCode [
	^String streamContents:  [ :stream |
	| grandTotal |
	grandTotal := 0.
	self testVsCodeDistribution do: [ :values |
		grandTotal := grandTotal + (values at: #totalType).
		stream
			nextPutAll: ((values at: #totalType) asString) ;
			nextPut: $; .
			(values at: #percentType) printOn: stream showingDecimalPlaces: 1.
			stream
				nextPut: $; ;
				nextPutAll: ((values at: #nbTest) asString) ;
				nextPut: $; .
			(values at: #percentTest) printOn: stream showingDecimalPlaces: 1.
			stream
				nextPut: $; ;
				nextPutAll: ((values at: #nbNotTest) asString) ;
				cr.
			].
		stream
			nextPutAll: (grandTotal asString) ;
			nextPut: $; ;
			nextPut: $; ;
			nextPut: $; ;
			nextPut: $; ;
			cr
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

{ #category : #accessing }
MLIPAnalysisInImage >> literalsTypes [
	^{
	MLIPLiteralTypes forClass: Integer .
	MLIPLiteralTypes forClass: String .
	MLIPLiteralTypes forClass: Symbol .
	MLIPLiteralTypes forClass: Boolean .
	MLIPLiteralTypes forClass: Array .
	MLIPLiteralTypes class: UndefinedObject testSelector: #isNilLiteral .
	MLIPLiteralTypes forClass: Float .
	MLIPLiteralTypes forClass: Character
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

{ #category : #accessing }
MLIPAnalysisInImage >> parentNodeClasses [
	^ { #receiver . #arg . RBAssignmentNode. RBReturnNode. RBSequenceNode. RBPragmaNode. RBArrayNode }
]

{ #category : #accessing }
MLIPAnalysisInImage >> parentNodeNames [
	^(#('Receiver' 'Arg.') ,
		((self parentNodeClasses allButFirst: 2)
			collect: [ :c | (c name allButFirst: 'RB' size) allButLast: 'Node' size ]))
		replaceAll: 'Assignment' with: 'Assign.'
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
		return at: #percentTest put: 
			((return at: #totalType) > 0
			ifTrue: [ (res first / (return at: #totalType)) asFloat * 100 ]
			ifFalse: [ -100 ] ).
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
			ifTrue: [ test := test + (meth literalsOfType: aLiteralType) ]
			ifFalse: [ notTest := notTest + (meth literalsOfType: aLiteralType) ]
	].
	^{test . notTest}
]
