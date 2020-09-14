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

{ #category : #accessing }
MLIPAnalysisInImage >> methods [ 
	^methods
]

{ #category : #statistics }
MLIPAnalysisInImage >> numberOfLiterals [
	^self allLiterals size
]

{ #category : #running }
MLIPAnalysisInImage >> onSample: aCollectionOfMethods [
	methods := self filterSample: aCollectionOfMethods 
]
