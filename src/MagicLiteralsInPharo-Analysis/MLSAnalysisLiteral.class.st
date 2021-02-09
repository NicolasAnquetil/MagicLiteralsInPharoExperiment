"
A literal analysed in one experiment contains the literal, its owning method, its status (magic or not), the project and experimentId where it was analysed
"
Class {
	#name : #MLSAnalysisLiteral,
	#superclass : #Object,
	#instVars : [
		'status',
		'mid',
		'method',
		'project',
		'experimentId',
		'methodLiterals',
		'node'
	],
	#category : #'MagicLiteralsInPharo-Analysis-ExperimentResult'
}

{ #category : #'instance creation' }
MLSAnalysisLiteral class >> fromSerialized: serializedLiteral inMethod: serializedMethod [
	^self new
		fromSerialized: serializedLiteral inMethod: serializedMethod
		yourself
]

{ #category : #testing }
MLSAnalysisLiteral >> astTypeIs: astType [
	| parentNode |
	parentNode := self node parent.
	(parentNode class = astType) ifTrue: [ ^true ].
	(parentNode class = RBMessageNode) ifFalse: [ ^ false].
	"Fine decomposition of all RBMessageNode"
	((astType = #receiver) and: "receiver of binary message -> operand"
		[ parentNode receiver = self node and:
		[ parentNode isBinary not]])
		ifTrue: [ ^true ].
	((astType = #binaryArg) and:
		[ parentNode receiver = self node and:
		[ parentNode isBinary]])
		ifTrue: [ ^true ].
	((astType = #binaryArg) and:
		[ parentNode receiver ~= self node and:
		[ parentNode isBinary]])
		ifTrue: [ ^true ].
	((astType = #keywordArg) and:
		[ parentNode receiver ~= self node and: 
		[ parentNode isKeyword]])
		ifTrue: [ ^true ].
	^false
]

{ #category : #accessing }
MLSAnalysisLiteral >> commentLength [
	| length |
	length := 0.
	RBCommentNodeVisitor
		visit: method parseTree
		do: [ :comment | length := length + comment size].
	^length
]

{ #category : #accessing }
MLSAnalysisLiteral >> experimentId [
	^ experimentId
]

{ #category : #accessing }
MLSAnalysisLiteral >> experimentId: anObject [
	experimentId := anObject
]

{ #category : #private }
MLSAnalysisLiteral >> findSerialized: serialized inNodes: literalNodes [
	| index |
	index := 0.
	literalNodes
		detect: [ :node |
			index := index + 1.
			(serialized startPosition = node start) and: [
			(serialized endPosition = node stop) ]
		]
		ifOne: [ :node | ^ node -> index ]
		ifNone: [ AssertionFailure signal: 'Literal not found in compiled method' ]

]

{ #category : #initialisation }
MLSAnalysisLiteral >> fromSerialized: serializedLiteral inMethod: serializedMethod [
	"value := serializedMethod sourceCode
		copyFrom: serializedLiteral startPosition to: serializedLiteral endPosition."
	status := serializedLiteral status.
	serializedMethod
		compiledMethodIfFound: [ :compiled || allLiterals nodeAndId |
			method := compiled.
			allLiterals := MLSFindLiteralsNodeVisitor visit: (compiled parseTree).
			nodeAndId := self
				findSerialized: serializedLiteral
				inNodes: allLiterals.
			methodLiterals := allLiterals size.
			node := nodeAndId key.
			mid := nodeAndId value
		]
		ifAbsent: [ NotFound signal: serializedMethod name]
]

{ #category : #accessing }
MLSAnalysisLiteral >> idInMethod [
	"Id of the literal in the method"
	^mid
]

{ #category : #testing }
MLSAnalysisLiteral >> isArrayLiteral [
	^(self value isArray) or: [ self value class == ByteArray ]
]

{ #category : #testing }
MLSAnalysisLiteral >> isBooleanLiteral [
	^(self value = true) or: [ self value = false ]

]

{ #category : #testing }
MLSAnalysisLiteral >> isCharacterLiteral [
	^self value isCharacter
]

{ #category : #testing }
MLSAnalysisLiteral >> isFloatLiteral [
	^(self value isFloat ) or: [ self value class = ScaledDecimal ]
]

{ #category : #testing }
MLSAnalysisLiteral >> isIntegerLiteral [
	^self value isInteger 
]

{ #category : #testing }
MLSAnalysisLiteral >> isMagic [
	^ self status isMagic
]

{ #category : #testing }
MLSAnalysisLiteral >> isNilLiteral [
	^self value isNil
]

{ #category : #testing }
MLSAnalysisLiteral >> isNotMagic [
	^ self status isNotMagic
]

{ #category : #testing }
MLSAnalysisLiteral >> isStringLiteral [
	^(self value isString) and: [ self value isSymbol not ]
]

{ #category : #testing }
MLSAnalysisLiteral >> isSymbolLiteral [
	^self value isSymbol
]

{ #category : #testing }
MLSAnalysisLiteral >> isUnknown [
	^ self status isUnknown
]

{ #category : #accessing }
MLSAnalysisLiteral >> method [
	^ method
]

{ #category : #accessing }
MLSAnalysisLiteral >> node [
	^node
]

{ #category : #accessing }
MLSAnalysisLiteral >> node: aRBNode [
	node := aRBNode
]

{ #category : #accessing }
MLSAnalysisLiteral >> numberLiteralsInMethod [
	^methodLiterals
]

{ #category : #printing }
MLSAnalysisLiteral >> printOn: aStream [
		aStream << method name << ' ' << self value asString
]

{ #category : #accessing }
MLSAnalysisLiteral >> project [
	^ project
]

{ #category : #accessing }
MLSAnalysisLiteral >> project: anObject [
	project := anObject
]

{ #category : #accessing }
MLSAnalysisLiteral >> status [
	^ status
]

{ #category : #accessing }
MLSAnalysisLiteral >> value [
	^ node value
]
