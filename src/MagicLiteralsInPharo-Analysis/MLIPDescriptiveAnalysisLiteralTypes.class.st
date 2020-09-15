"
Analysis focusing literal types and whether they are in test methods or not
"
Class {
	#name : #MLIPDescriptiveAnalysisLiteralTypes,
	#superclass : #MLIPAnalysisInImage,
	#category : #'MagicLiteralsInPharo-Analysis-DescriptiveStats'
}

{ #category : #accessing }
MLIPDescriptiveAnalysisLiteralTypes class >> literalsTypes [
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

{ #category : #outputting }
MLIPDescriptiveAnalysisLiteralTypes >> csv [
	^String streamContents:  [ :stream || grandTotal |
		grandTotal := 0.
		self class literalsTypes
			with: self distribution
			do: [ :typ :values |
				grandTotal := grandTotal + (values at: #totalType).
				stream
					nextPutAll: typ name ; 					nextPut: $; ;
					nextPutAll: ((values at: #totalType) asString) ;	nextPut: $; ;
					nextPutAll: ((values at: #nbTest) asString) ; 		nextPut: $; ;
					nextPutAll: ((values at: #nbNotTest) asString) ;	cr.
			].
		stream
			nextPut: $; ;
			nextPutAll: (grandTotal asString) ;
			nextPut: $; ;
			nextPut: $; ;
			cr
	].
]

{ #category : #statistics }
MLIPDescriptiveAnalysisLiteralTypes >> distribution [
	| allResults grandTotal |
	grandTotal := 0.
	allResults := self class literalsTypes collect: [ :lType || result |
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
MLIPDescriptiveAnalysisLiteralTypes >> testVsCodeFor: aLiteralType [
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
