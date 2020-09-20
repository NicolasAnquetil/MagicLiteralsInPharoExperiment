Class {
	#name : #MLSResultsAnalysisDescriptiveStats,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #outputting }
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
		nextPutAll: '        ;classes;meths;literals;Tmeths;TLit' ;
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
	uniqLit := someLiterals groupedBy: [:lit | lit method -> lit node start].
	^{ classes size . 
		methods size . 
		uniqLit size . 
		(methods select: #isTestMethod) size .
		(uniqLit keys select: [ :lit | lit key isTestMethod ]) size}
		
]
