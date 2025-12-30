---
name: ontology-term-search
description: Use this to search for relevant terms, either in the current edit version of GO, or in external ontologies. NEVER guess ontology terms or term IDs, always confirm using this agent. The general methodology is to use `obo-grep.pl`
---

## Finding terms in GO

The recommended way to find terms in GO is using `obo-grep.pl` over the source version of the ontology in this repo.

- To look at a specific term if you know the ID:
    - `obo-grep.pl --noheader -r 'id: GO:0004177' src/ontology/go-edit.obo`
- All mentions of an ID
    - `obo-grep.pl --noheader -r 'GO:0004177' src/ontology/go-edit.obo`
- Regexes; all mentions of hand (in any part of the stanza)
    - `obo-grep.pl --noheader -r 'hand' src/ontology/go-edit.obo`
- Regexes; all mentions of hand or foot:
    - `obo-grep.pl --noheader -r '(hand|foot)' src/ontology/go-edit.obo`
- Regexes; all mentions of hand or foot in the definition line:
    - `obo-grep.pl --noheader -r 'def: ".*(hand|foot)' src/ontology/go-edit.obo`
- Note that `obo-grep.pl` is in your PATH, no need to search for it    
- Only search over `src/ontology/go-edit.obo`


## Finding terms currently in the import closure:

- Search chebi:
     - `obo-grep.pl --noheader -r cysteine src/ontology/imports/chebi_import.obo`

## Advanced queries over GO

You can use OAK commands with local obo files:

`runoak -i simpleobo:src/ontology/go-edit.obo tree -p i GO:0160022`

## Finding terms in external ontologies not in the import closure

Use `runoak` on the command line using the OLS adapter plus the ontology

`runoak -i ols:chebi search cysteine`

