"
A class to load ston files resulting from experiments and export them in CSV for analysis in R

MLSResultsAnalysis importDirectory: '/path/to/directory'
"
Class {
	#name : #MLSResultsAnalysis,
	#superclass : #Object,
	#instVars : [
		'literals',
		'experiments'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #accessing }
MLSResultsAnalysis class >> allProjects [
	^#( 'morphic' 'parser' 'Pharo' 'PolyMath' 'Roassal' 'Seaside' 'VMMaker' )
]

{ #category : #'instance creation' }
MLSResultsAnalysis class >> fromOtherAnalysis: analysis [
	^self new
		getFromOtherAnalysis: analysis ;
		yourself
]

{ #category : #'instance creation' }
MLSResultsAnalysis class >> importDirectory: aName [
	MLSClassExternal resetInstances .
	MLSMethodExternal resetInstances .
	^self new importFromDirectory: aName
]

{ #category : #'instance creation' }
MLSResultsAnalysis class >> importExpertsBase: aName [
	^self new importExpertsFromFile: aName
]

{ #category : #accessing }
MLSResultsAnalysis >> detectASTNode: aLiteral [
	MLIPDescriptiveAnalysisASTNodes astNodeClasses
			with: MLIPDescriptiveAnalysisASTNodes astNodeNames
			do: [ :class : name |
				(aLiteral astTypeIs: class)
				ifTrue: [  ^ name ]
			].
	^'unknownASTNode'

]

{ #category : #accessing }
MLSResultsAnalysis >> detectLiteralKind: aLiteral [ 
	^(MLIPDescriptiveAnalysisLiteralTypes literalsTypes detect: [ :typ | typ accept: aLiteral ]) name
]

{ #category : #enumerating }
MLSResultsAnalysis >> do: aBlock [
	"iterates on all literals"
	literals do: aBlock
]

{ #category : #accessing }
MLSResultsAnalysis >> experimentForProject: project id: id [
	^experiments
		detect: [ :exp | exp project =project and: [ exp experiment = id ] ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MLSResultsAnalysis >> experiments [
	^experiments
]

{ #category : #accessing }
MLSResultsAnalysis >> expertForProject: project experiment: experimentId [
	^(self experimentForProject: project id: experimentId) expert
]

{ #category : #accessing }
MLSResultsAnalysis >> expertiseForProject: project experiment: experimentId [
	^(self experimentForProject: project id: experimentId) expertise
]

{ #category : #importing }
MLSResultsAnalysis >> getFromOtherAnalysis: analysis [
	experiments := analysis experiments.
	literals := analysis literals
]

{ #category : #importing }
MLSResultsAnalysis >> importExpertExperiment: record [
	(record third) ifNotNil: [ |tokens|
		tokens := record first findBetweenSubstrings: '-'.
		experiments add:
			(MLSAnalysisExperiment
				project: (tokens first)
				experiment: (tokens second asInteger)
				expert: (record second)
				expertise: (record third) )
	]
]

{ #category : #importing }
MLSResultsAnalysis >> importExpertsFromFile: aFilename [
	aFilename asFileReference readStreamDo: [ :st | self importExpertsFromStream: st ]
]

{ #category : #importing }
MLSResultsAnalysis >> importExpertsFromStream: aStream [
	| csv |
	csv := NeoCSVReader on: aStream contents readStream.
	3 timesRepeat: [ csv skipHeader ].
	csv do: [ :record |
		1 to: record size by: 3 do: [ :i |
			self importExpertExperiment: (record copyFrom: i to: i+2)
		]
	]
]

{ #category : #importing }
MLSResultsAnalysis >> importFromDirectory: aName [
	| directory |
	directory := aName asFileReference.
	directory exists ifFalse: [ ^ nil ].
	directory isDirectory  ifFalse: [ ^ nil ].
	directory entries
		do: [ :e | 
			(e basename endsWith: '.ston')
			ifTrue: [ self importLiteralsFromFile: e ]
			ifFalse: [
				(e basename endsWith: '.csv')
				ifTrue: [ self importExpertsFromFile: e ] ] ]
		displayingProgress: [ :e | e basename ]
]

{ #category : #importing }
MLSResultsAnalysis >> importLiterals: project xp: id fromStream: aStream [
	(MLSReader on: aStream) next
		methods do: [ :serializedMeth |
			serializedMeth literalCandidates do: [ :lit |
				literals
					add:
						((MLSAnalysisLiteral fromSerialized: lit inMethod: serializedMeth)
							project: project ;
							experimentId: id ;
							yourself)
			]
		]
]

{ #category : #importing }
MLSResultsAnalysis >> importLiteralsFromFile: aFileRef [
	| tokens xpId projectName |
	tokens := aFileRef basename findBetweenSubstrings: '-.'.
	projectName := tokens second.
	xpId := tokens third asInteger.
	aFileRef readStreamDo: [ :s |
		self importLiterals: projectName xp: xpId fromStream: s
	]
]

{ #category : #initialization }
MLSResultsAnalysis >> initialize [
	literals := OrderedCollection new.
	experiments := OrderedCollection new
]

{ #category : #private }
MLSResultsAnalysis >> isConstantMethod: aRBNode [
	^(aRBNode parent class = RBReturnNode) and:
	[ (aRBNode parent parent class = RBSequenceNode) and:
	[ (aRBNode parent parent statements size = 1) and:
	[ aRBNode parent parent parent class = RBMethodNode ] ] ]
]

{ #category : #accessing }
MLSResultsAnalysis >> literals [
	^literals
]

{ #category : #private }
MLSResultsAnalysis >> nodeLocation: aRBNode [
	^MLSNodeLocationVisitor on: aRBNode
]

{ #category : #importing }
MLSResultsAnalysis >> stonToSerializedSample: aStream [
	^(STON reader
		acceptUnknownClasses: true ;
		on: aStream)
		next
			fixStonErrors ;
			yourself
]

{ #category : #private }
MLSResultsAnalysis >> uniqLiterals: someLiterals [
	^ someLiterals groupedBy: [:lit | lit method -> lit node start]
]
