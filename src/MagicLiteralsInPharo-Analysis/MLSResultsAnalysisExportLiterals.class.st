Class {
	#name : #MLSResultsAnalysisExportLiterals,
	#superclass : #MLSResultsAnalysis,
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #API }
MLSResultsAnalysisExportLiterals >> csv [
	^String streamContents:  [ :stream |
		self exportToCsvStream: stream ]
]

{ #category : #API }
MLSResultsAnalysisExportLiterals >> exportToCsvFile: aFilename [
	 self exportToCsvFile: aFilename withFilter: [ :lit | true ]
]

{ #category : #exporting }
MLSResultsAnalysisExportLiterals >> exportToCsvFile: aFilename withFilter: aBlock [
	aFilename asFileReference writeStreamDo: [ :st |
		self exportToCsvStream: st withFilter: aBlock
	]
]

{ #category : #API }
MLSResultsAnalysisExportLiterals >> exportToCsvStream: stream [
	self exportToCsvStream: stream withFilter: [ :lit | true ]
	
]

{ #category : #exporting }
MLSResultsAnalysisExportLiterals >> exportToCsvStream: stream withFilter: filterBlock [
	| csvWriter exportedFields |
	csvWriter := (NeoCSVWriter on: stream)
		fieldWriter: #quoted ;
		yourself.
	exportedFields := self exportedFields.
	csvWriter writeHeader: (exportedFields collect: #key).
	exportedFields do: [ :fieldToExport | csvWriter addField: fieldToExport value ].
	(literals select: filterBlock)
		do: [ :lit | csvWriter nextPut: lit ]
		displayingProgress: 'CSV export'
	
]
