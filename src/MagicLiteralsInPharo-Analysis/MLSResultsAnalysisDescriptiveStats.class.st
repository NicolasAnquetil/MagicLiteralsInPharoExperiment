"
Descriptive Statistics analysis

API:
- #csv -- output result of analysis in csv format
"
Class {
	#name : #MLSResultsAnalysisDescriptiveStats,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #API }
MLSResultsAnalysisDescriptiveStats >> csv [
	| distribution |
	distribution := (self distribution) asDictionary.
	^String streamContents:  [ :stream |
		self csvHeader: stream.
			self class allProjects do: [ :proj ||distrib |
				distrib := distribution at: proj.
				stream
					nextPutAll: proj.
				distrib do: [ :val |
					stream
						nextPut: $; ;
						nextPutAll: val asString
				].
				stream cr
			].
		stream
	]
]

{ #category : #outputting }
MLSResultsAnalysisDescriptiveStats >> csvHeader: stream [
	stream
		nextPutAll: '        ;classes;meths;literals;uniqLit;Tmeths;TLit;TUniqLit' ;
		cr.

]

{ #category : #statistics }
MLSResultsAnalysisDescriptiveStats >> distribution [
	^self class allProjects collect: [ :proj |
		proj -> (self distributionForProject: proj) ]

]

{ #category : #statistics }
MLSResultsAnalysisDescriptiveStats >> distributionForProject: aProjectName [
	^self distributionOnLiterals: (self literals select: [ :lit | lit project = aProjectName ])
		
]

{ #category : #statistics }
MLSResultsAnalysisDescriptiveStats >> distributionOnLiterals: someLiterals [
	| methods classes uniqLit|
	methods := (someLiterals groupedBy: #method) keys.
	classes := methods groupedBy: [ :m | m methodClass name ].
	uniqLit := self uniqLiterals: someLiterals.
	^{ classes size . 
		methods size . 
		someLiterals size .
		uniqLit size . 
		(methods select: #isTestMethod) size .
		(someLiterals select: [ :lit | lit method isTestMethod ]) size .
		(uniqLit keys select: [ :lit | lit key isTestMethod ]) size
	}
		
]
