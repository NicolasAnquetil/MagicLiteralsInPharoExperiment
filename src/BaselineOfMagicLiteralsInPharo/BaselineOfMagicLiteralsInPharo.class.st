Class {
	#name : #BaselineOfMagicLiteralsInPharo,
	#superclass : #BaselineOf,
	#category : #BaselineOfMagicLiteralsInPharo
}

{ #category : #baselines }
BaselineOfMagicLiteralsInPharo >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			"Dependencies"
			spec
				baseline: 'TreeQuery'
				with: [ spec repository: 'github://JulienDelplanque/TreeQuery:v1.0.0/src'].
			spec
				baseline: 'MatplotLibBridge'
				with: [ spec repository: 'github://JulienDelplanque/MatplotLibBridge:v1.3.0/src'].
			spec baseline: 'ContainersTrie' 
				with: [ spec repository: 'github://Ducasse/Containers-Trie/src' ].
			spec baseline: 'SQLite3' 
				with: [ spec repository: 'github://JulienDelplanque/SQLite3:v2.1.0/src' ].
			"Packages"
			spec
				package: 'MagicLiteralsInPharo' with: [ spec requires: #('TreeQuery' 'ContainersTrie' 'SQLite3') ];
				package: 'MagicLiteralsInPharo-Tests' with: [ spec requires: #('MagicLiteralsInPharo') ] ]
]
