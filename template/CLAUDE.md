# GO Ontology Project Guide

This includes instructions for editing the go ontology and related files in response to GitHub issues.

## Project Layout

The project follows standard ODK layout:

 * src
    * ontology/
       * go-edit.obo
       * Makefile
       * ...
    * taxon_constraints/
       * only_in_taxon.tsv
       * never_in_taxon.tsv
 * terms/   ## checked out copies, for editing
    * GO_NNNNNNN.obo # checked out local copy
 * .claude/
    * agents/   ## specific agent instructions    

 For make targets, a standard pattern is `cd src/ontology && make <TARGET>`. Beware of accidentally changing to the `src/ontology`
 dir and forgetting where you are. It is best to run things from the top level

These instructions are optimized for claude code. Subagents are used, and defined
in `.claude/agents/`

## ALWAYS create a plan for any changes to be made [see also: issue-planner agent]

ALWAYS use the issue-planner agent when you are resolving github issues. When resolving issues directly from the user,
you should still consult the issue planner agent.

ALWAYS create a checklist for yourself, and ALWAYS report that checklist in PR_COMMENTS.md

The checklist should include both the core minimal checklist AND the checklists from any agents that were run

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

Always invoke the ontology-editing agent to make edits

Use `obo-checkout.pl` and `obo-checkin.pl` to create tractable editable modules in the `terms` folder.

It's always a good idea to look at the structure of existing similar terms, these can be found with `obo-grep.pl`

## Ensure correct metadata [see also: metadata-checker] agent

- ALWAYS include created_by and creation_date for terms YOU CREATE
- NEVER add or modify these properties if you are simply editing an existing term
- Unlike other obo ontologies, there is always a `namespace:` tag in GO (including on obsolete terms)
- Link back to the issue you are dealing with using the `term_tracker_item`
- All terms should have definitions, with at least one definition xref, ideally a PMID

## Relationships, Logical Definitions, and Design patterns

Always make sure that design patterns are conformed to, especially for compositional terms. Use the [design-pattern] agent to check for conformance of name, def and logical def.

But also use prior art: look for similar terms with `obo-grep.pl`

All terms should have at least one `is_a` (this can be implicit by a logical definition, see below).
It's common for BP and CC terms to have a `part_of` relationship.

Logical definitions should follow genus-differentia form, and the text definition should mirror the logical definition. Example:

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

## Special cases

- term obsoletions, invoke the [term-obsoletion] agent
    - ensure no references (in ontology or annotations) to obsolete terms; rewire if necessary
    - ensure migration of axioms
    - ensure minimal axioms remain in obsolete term
    - follow metadata conventions
- anything involving CHEBI/chemical entities, invoke the [chemical-entity-agent]
    - use ph7.3 forms
- mappings, invoke the [mapping-agent] agent
    - always provide the skos predicate on a mapping when you can
    - always check the mapped term to see if a mapping makes sense
    - look at mappings holistically
- for anything involving reactions/catalytic activities/RHEA/EC, invoke the [reaction-agent]
- for taxon constraints, see the [taxon-constraint-agent]
    - these are in `src/taxon_constraints` (not the main obo file)
        - `never_in_taxon.tsv`
        - `only_in_taxon.tsv`

## ALWAYS perform validation [ontology-validation agent]

Ensure that full validation is performed, using `cd src/ontology && make travis_test`. see ontology-validation agent for details.

## Reporting back information

If you are addressing a specific github issue, create fresh ISSUE_COMMENTS.md and PR_COMMENTS.md files.

If you are instructed to, then commit changes. These are generally to src/ontology/go-edit.obo. In some cases you may also need to change taxon constraint files.

If you did not modify a file yourself, don't commit it. There may be modifications in files like this CLAUDE.md, this is expected, don't commit them.


