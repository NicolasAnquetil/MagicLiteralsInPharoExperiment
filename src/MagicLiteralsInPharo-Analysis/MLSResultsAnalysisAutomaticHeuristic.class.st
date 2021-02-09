"
Computes efficiency of heuristics to detect non-matgic literals
"
Class {
	#name : #MLSResultsAnalysisAutomaticHeuristic,
	#superclass : #MLSResultsAnalysis,
	#instVars : [
		'filter',
		'output'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> csvOutput [
	output := MLSFilterResultsAnalysisCSV new

]

{ #category : #initialization }
MLSResultsAnalysisAutomaticHeuristic >> initialize [ 
	super initialize .
	self csvOutput
]

{ #category : #accessing }
MLSResultsAnalysisAutomaticHeuristic >> recprecOutput [
	output := MLSFilterResultsAnalysisRecPrec new
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> resultForType: aTypeSelector filter: aFilter [
	| rawValues |
	filter := aFilter.
	rawValues := Dictionary new.
	rawValues
		at: MLSFilterResultsAnalysis magicKey
		put: (self statsForLiterals: [ :lit | (aTypeSelector value: lit) and: [lit isMagic]]).
	rawValues
		at: MLSFilterResultsAnalysis undecidedKey
		put: (self statsForLiterals: [ :lit | (aTypeSelector value: lit) and: [lit isUnknown]]).
	rawValues
		at: MLSFilterResultsAnalysis notMagicKey
		put: (self statsForLiterals: [ :lit | (aTypeSelector value: lit) and: [lit isNotMagic]]).
	^rawValues 
]

{ #category : #API }
MLSResultsAnalysisAutomaticHeuristic >> statsAll [
	"results for all types of literals and all filters"
	^output
		title: 'ALL' ;
		outputResult: (self
			resultForType: [:e|true]
			filter: (MLIPCompositeMagicLiteralFilter withDefaultFilters))
 
]

{ #category : #private }
MLSResultsAnalysisAutomaticHeuristic >> statsForLiterals: aSelectionBlock [
	^{
		(self literals select: [ :lit | aSelectionBlock value: lit]) .
		(self literals select: [ :lit | (aSelectionBlock value: lit)  and: [ filter isNotMagicLiteral: lit ] ])
	}
]

{ #category : #API }
MLSResultsAnalysisAutomaticHeuristic >> statsString [
	^output
		title: 'STRING' ;
		outputResult: (self
			resultForType: #isStringLiteral
			filter: (MLIPStringFilter new))

]
