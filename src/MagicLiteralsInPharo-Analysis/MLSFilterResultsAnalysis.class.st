Class {
	#name : #MLSFilterResultsAnalysis,
	#superclass : #Object,
	#instVars : [
		'title',
		'stream'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #constants }
MLSFilterResultsAnalysis class >> magicKey [
	^#magic
]

{ #category : #constants }
MLSFilterResultsAnalysis class >> notMagicKey [
	^#notMagic
]

{ #category : #constants }
MLSFilterResultsAnalysis class >> undecidedKey [
	^#undecided
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> allMagic: values [
	^(values at: self class magicKey)
		first
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> allNotMagic: values [
	^(values at: self class notMagicKey)
		first
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> allUndecided: values [
	^(values at: self class undecidedKey)
		first
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> filteredMagic: values [
	^(values at: self class magicKey)
		second
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> filteredNotMagic: values [
	^(values at: self class notMagicKey)
		second
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> filteredUndecided: values [
	^(values at: self class undecidedKey)
		second
]

{ #category : #initialization }
MLSFilterResultsAnalysis >> initialize [ 
	super initialize .
	String streamContents: [ :st |
		stream := st
	]
]

{ #category : #output }
MLSFilterResultsAnalysis >> outputResult: values [
	self subclassResponsibility 

]

{ #category : #accessing }
MLSFilterResultsAnalysis >> title [
	^ title
]

{ #category : #accessing }
MLSFilterResultsAnalysis >> title: anObject [
	title := anObject
]
