"
Computes efficiency of heuristics to detect non-magic literals

```
( MLSResultsAnalysis importDirectory: '/path/to/directory')
	csvOutput ;
	filter: [ :e|true ] ;
	heuristic: (MLIPCompositeMagicLiteralFilter withDefaultFilters) ;
	title: 'All literals/All heuristics' ;
	results.
```

Instance variables:
- output -- strategy to output the result, available through #csvOutput and #recprecOutput
- filter -- what kind of literals to experiment on (eg `#filter: #isStringLiteral`)
- heuristic -- heuristic to test (eg: `#heuristic: MLIPStringFilter new`)
- title -- a string to identify the result
"
Class {
	#name : #MLSResultsAnalysisAutomaticHeuristic,
	#superclass : #MLSResultsAnalysis,
	#instVars : [
		'output',
		'heuristic',
		'filter',
		'title'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> allHeuristics [
	self heuristic: MLIPCompositeMagicLiteralFilter withDefaultFilters
]

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> csvOutput [
	output := MLSFilterResultsAnalysisCSV new

]

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> defaultHeuristicFilter [
	"use the #isTarget: method of the heuristic as a literal filter"
	self filter: [ :e | self heuristic isTarget: e ]
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> filter [
	^ filter
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> filter: anObject [
	filter := anObject
]

{ #category : #API }
MLSResultsAnalysisAutomaticHeuristic >> forAll [
	^self
		title: 'ALL' ;
		noLiteralFilter ;
		allHeuristics ;
		results.

]

{ #category : #API }
MLSResultsAnalysisAutomaticHeuristic >> forString [
	^self
		title: 'STRING' ;
		filter: #isStringLiteral ;
		heuristic: (MLIPStringFilter new) ;
		results.

]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> heuristic [
	^ heuristic
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> heuristic: anObject [
	heuristic := anObject
]

{ #category : #initialization }
MLSResultsAnalysisAutomaticHeuristic >> initialize [ 
	super initialize .
	self csvOutput.
	self noLiteralFilter.
	self allHeuristics.
	self title: 'All literals/All heuristics'
]

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> irOutput [
	"Information Retrieval metrics ouput"
	output := MLSFilterResultsAnalysisIR new
]

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> noLiteralFilter [
	self filter: [ :e | true ]
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> output [
	^ output
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> output: anObject [
	output := anObject
]

{ #category : #configuration }
MLSResultsAnalysisAutomaticHeuristic >> recprecOutput [
	output := MLSFilterResultsAnalysisIR new
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> results [
	| rawValues |
	rawValues := Dictionary new.
	rawValues
		at: MLSFilterResultsAnalysis magicKey
		put: (self statsForLiterals: [ :lit | (self filter value: lit) and: [lit isMagic]]).
	rawValues
		at: MLSFilterResultsAnalysis undecidedKey
		put: (self statsForLiterals: [ :lit | (self filter value: lit) and: [lit isUnknown]]).
	rawValues
		at: MLSFilterResultsAnalysis notMagicKey
		put: (self statsForLiterals: [ :lit | (self filter value: lit) and: [lit isNotMagic]]).
	^output
		title: self title ;
		outputResult: rawValues
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> statsForLiterals: aSelectionBlock [
	^{
		(self literals select: [ :lit | aSelectionBlock value: lit]) .
		(self literals select: [ :lit | (aSelectionBlock value: lit)  and: [ self heuristic isNotMagicLiteral: lit ] ])
	}
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> title [
	^ title
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> title: anObject [
	title := anObject
]
