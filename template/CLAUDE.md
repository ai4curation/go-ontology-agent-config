# GO Ontology Project Guide

This includes instructions for editing the go ontology. 

## Project Layout

- follows standard ODK layout
- Main development file is `src/ontology/go-edit.obo` with `Makefile` in same directory
- individual terms checked out in `terms`

These instructions are optimized for claude code. Subagents are used, and defined
in .claude/agents/

## Create a plan for any changes to be made [see also: issue-planner agent]

ALWAYS use the issue-planner agent when you are resolving github issues. When resolving issues directly from the user,
you should still consult the issue planner agent.

ALWAYS create a checklist for yourself, and ALWAYS report that checklist in PR_COMMENTS.md

## Performing background research [see also: research-agent]

You can do searches for literature using web search tools. For focused deep research, you can use `deep-research-client`.

Use PMIDs where possible, and ALWAYS check that these PMIDs are the correct ones, and not typos or hallucinated.

## Querying ontology [see also: ontology-term-search agent]

You can search over `src/ontology/go-edit.obo` using `obo-grep.pl` (in your path)

- To look at a specific term if you know the ID:
    - `obo-grep.pl --noheader -r 'id: GO:0004177' src/ontology/go-edit.obo`
- All mentions of an ID
    - `obo-grep.pl --noheader -r 'GO:0004177' src/ontology/go-edit.obo`
- Regexes; all mentions of hand or foot:
    - `obo-grep.pl --noheader -r '(hand|foot)' src/ontology/go-edit.obo`

## Making edits [see also: ontology-editing agent]

Use `obo-checkout.pl` and `obo-checkin.pl` to create tractable editable modules in the `terms` folder.

It's always a good idea to look at the structure of existing similar terms, these can be found with `obo-grep.pl`

## Design patterns

Always make sure that design patterns are conformed to, especially for compositional terms. Use the [design-pattern] agent to check for conformance of name, def and logical def.

But also use prior art: look for similar terms with `obo-grep.pl`

## Special cases

- term obsoletions, invoke the [term-obsoletion] agent
    - ensure no references (in ontology or annotations) to obsolete terms
    - follow metadata conventions
- anything involving CHEBI/chemical entities, invoke the [chemical-entity-agent]
    - use ph7.3 forms
- mappings, invoke the [mapping-agent] agent
    - for always provide the skos predicate on a mapping when you can

## Validation [ontology-validation agent]

Ensure 

## Reporting back information

If you are addressing a specific github issue, create fresh ISSUE_COMMENTS.md and PR_COMMENTS.md files.

If you are instructed to, then commit changes. These are generally to src/ontology/go-edit.obo. In some cases you may also need to change taxon constraint files.

## Syntax Checking

- To validate syntax: `robot convert --catalog src/ontology/catalog-v001.xml -i go-edit.obo -f obo -o go-edit.TMP.obo`
- Use `-vvv` for a full stack trace if there are errors.

## Gene Ontology Guidelines

## `namespace` tags

Unlike other obo ontologies, there is always a `namespace:` tag in GO.

## Obsoleting terms

obsolete terms should have no logical axioms (is_a, relationship,
intersection_of) on them. Obsolete terms may be replaced by a single
term (so-called obsoletion with exact replacement), or by zero to many `consider` tags.

Synonyms and xrefs can be migrated judiciously,

We never do complete merges now, so there should be no `alt_ids` or
disappearing stanzas. If a user asks for a merge, they usually mean
obsoletion with direct replacement, as here:

```
[Term]
id: GO:0000170
name: obsolete sphingosine hydroxylase activity
namespace: molecular_function
def: "OBSOLETE. Catalysis of the hydroxylation of sphingolipid long chain bases." [PMID:9556590]
comment: The reason for obsoletion is that this term is equivalent to sphingolipid C4-monooxygenase activity.
property_value: term_tracker_item "https://github.com/geneontology/go-ontology/issues/29717" xsd:anyURI
is_obsolete: true
replaced_by: GO:0102772
```

Note the pattern for names and definitions.

No relationship should point to an obsolete term - when you obsolete a term, you may need to also rewire
terms to "skip" the obsoleted term.

## Other metadata

- Link back to the issue you are dealing with using the `term_tracker_item`
- All terms should have definitions, with at least one definition xref, ideally a PMID
- You can sign terms as `created_by: dragon-ai-agent`

## Relationships

All terms should have at least one `is_a` (this can be implicit by a logical definition, see below).
It's common for BP and CC terms to have a `part_of` relationship.

## Taxon Constraints

These live in `src/taxon_constraints`

- `never_in_taxon.tsv`
- `only_in_taxon.tsv`

When obsoleting a term, you may need to remove the taxon constraint, as these should never point to obsoletes

## Logical definitions

These should follow genus-differentia form, and the text definition should mirror the logical definition. Example:

```
[Term]
id: GO:0001649
name: osteoblast differentiation
namespace: biological_process
def: "The process whereby a relatively unspecialized cell acquires the specialized features of an osteoblast, a mesodermal or neural crest cell that gives rise to bone." [CL:0000062]
synonym: "osteoblast cell differentiation" EXACT []
intersection_of: GO:0030154 ! cell differentiation
intersection_of: results_in_acquisition_of_features_of CL:0000062 ! osteoblast
relationship: part_of GO:0001503 ! ossification
```

Here the genus is `cell differentiation` and the differentia points to a CL term. Never guess these IDs, use tools to find them.
Never guess the pattern or relationships. Consult the design pattern docs or look for similar terms (e.g. other differentiation terms).

The reasoner can find the most specific `is_a`, so it's OK to leave this off.

## Reaction Terms

Reaction terms may have mappings that are qualified using skos (using `source` qualifiers), as in the following:

```
[Term]
id: GO:0000140
name: acylglycerone-phosphate reductase (NADP+) activity
namespace: molecular_function
def: "Catalysis of the reaction: 1-hexadecanoyl-sn-glycero-3-phosphate + NADP+ = 1-hexadecanoylglycerone 3-phosphate + H+ + NADPH." [RHEA:17341]
synonym: "1-acyldihydroxyacetone-phosphate reductase activity" EXACT []
synonym: "1-palmitoylglycerol-3-phosphate:NADP+ oxidoreductase activity" RELATED [EC:1.1.1.101]
synonym: "acyldihydroxyacetone phosphate reductase activity" RELATED [EC:1.1.1.101]
synonym: "palmitoyl dihydroxyacetone phosphate reductase activity" RELATED [EC:1.1.1.101]
synonym: "palmitoyl-dihydroxyacetone-phosphate reductase activity" RELATED [EC:1.1.1.101]
synonym: "palmitoyldihydroxyacetone-phosphate reductase activity" RELATED [EC:1.1.1.101]
xref: EC:1.1.1.101 {source="skos:exactMatch"}
xref: MetaCyc:ACYLGLYCERONE-PHOSPHATE-REDUCTASE-RXN {source="skos:exactMatch"}
xref: MetaCyc:RXN-15046 {source="skos:narrowMatch"}
xref: RHEA:17341 {source="skos:exactMatch"}
xref: RHEA:36175 {source="skos:narrowMatch"}
is_a: GO:0016616 ! oxidoreductase activity, acting on the CH-OH group of donors, NAD or NADP as acceptor
property_value: term_tracker_item "https://github.com/geneontology/go-ontology/issues/28070" xsd:anyURI
property_value: term_tracker_item "https://github.com/geneontology/go-ontology/issues/28526" xsd:anyURI
```

Ideally there is a single source of truth for a reaction terms, which should be specified in the def xref


