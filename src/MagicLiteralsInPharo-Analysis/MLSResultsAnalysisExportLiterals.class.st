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

{ #category : #exporting }
MLSResultsAnalysisExportLiterals >> exportedFields [
	^{
		(#literal -> [ :lit | lit value asString]) .
		(#kind -> [ :lit | self detectLiteralKind: lit ]) .
		(#astNode -> [ :lit | self detectASTNode: lit ]) .
		(#status -> [ :lit | lit status ]) .
		(#idInMethod -> [ :lit | lit idInMethod]) .
		"(#location -> [ :lit | self nodeLocation: lit node]) ."
		(#isConstantMethod -> [ :lit | self isConstantMethod: lit node]) .
		(#method -> [ :lit | lit method name]) .
		(#isTestMethod -> [ :lit | lit method isTestMethod]) .
		(#commentLength -> [:lit | lit commentLength]) .
		(#nbLiteralsInMethod -> [:lit | lit numberLiteralsInMethod]) .
		(#project -> [ :lit | lit project ]) .
		(#expId -> [ :lit | lit experimentId ]) .
		(#expert -> [ :lit | self expertForProject: lit project experiment: lit experimentId ]) .
		(#expertise -> [ :lit | self expertiseForProject: lit project experiment: lit experimentId ])
	}
]