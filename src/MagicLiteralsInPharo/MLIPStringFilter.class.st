Class {
	#name : #MLIPStringFilter,
	#superclass : #MLIPMagicLiteralFilter,
	#instVars : [
		'knownWordsRatioThreshold'
	],
	#classInstVars : [
		'trie'
	],
	#category : #'MagicLiteralsInPharo-Filters'
}

{ #category : #accessing }
MLIPStringFilter class >> defaultKnownWordsRatioThreshold [
	^ 0.5
]

{ #category : #accessing }
MLIPStringFilter class >> resetTrie [
	<script>
	trie := nil
]

{ #category : #accessing }
MLIPStringFilter class >> trie [
	^ trie ifNil: [ |memoryFile|
		memoryFile := FileSystem memory / 'words.txt'.
		memoryFile writeStreamDo: [ :s |
			s nextPutAll: (ZnEasy get: 'https://github.com/dwyl/english-words/blob/master/words.txt?raw=true') contents ].
		trie := CTTrie readFromFile: memoryFile withLineTransformer: #asLowercase.
		memoryFile ensureDelete.
		trie ]
]

{ #category : #accessing }
MLIPStringFilter >> defaultKnownWordsRatioThreshold [
	^ self class defaultKnownWordsRatioThreshold
]

{ #category : #testing }
MLIPStringFilter >> isNotMagicLiteral: literal [
	^ (self isTarget: literal) and:
		[ literal value isEmpty or:
			[ literal value size > 3 and:
				[ (literal value mlipKnownWordsRatioWith: self trie) > self knownWordsRatioThreshold ] ] ]
]

{ #category : #testing }
MLIPStringFilter >> isTarget: literal [
	^(literal node class = RBLiteralValueNode) and: 
		[literal value isString and:
		[literal value isSymbol not] ]
]

{ #category : #testing }
MLIPStringFilter >> knownWordsRatioThreshold [
	^ knownWordsRatioThreshold ifNil: [ knownWordsRatioThreshold := self defaultKnownWordsRatioThreshold ]
]

{ #category : #accessing }
MLIPStringFilter >> knownWordsRatioThreshold: anObject [
	knownWordsRatioThreshold := anObject
]

{ #category : #accessing }
MLIPStringFilter >> trie [
	^ self class trie
]
