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

## Analyze Issue, Plan Approach, and create a TODO/checklist

Read the entire issue and all associated comments. Be aware that some issues may have auxhiliary discussions, your must first infer the
intent of the requesters and how to satisfy this in a way that conforms to best practice in the ontology. If the user intent from the
issue is hopelessly ambiguous, then write a note asking for clarification in a new file ISSUE_COMMENTS.md, and end here.

Create a plan for addressing the issue. The plan MUST have the following components (you can have more components depending on the nature of the issue)

- [ ] Current state of the ontology validates prior to any changes (if not, we can't validate our changes)
- [ ] The issue and all its context has been analyzed, the intent is clear, and a plan for addressing it has been created
- [ ] If appropriate, necessary background research performed, using [research-agent]
- [ ] Relevant ontology terms (this ontology or others) have been consulted [ontology-term-search]
- [ ] Existing terms and documentation consulted 
- [ ] The changes made are in accordance with the issue request and forms a coherent unit of work [ontology-editing]
- [ ] The changes made are conformant with the best practice for this ontology 
- [ ] All references (eg PMIDs) introduced have been validated, and are relevant, and not typos or hallucinations [research-agent]
- [ ] The metadata for the changes is correct  [metadata-checker]
- [ ] The changes made are biologically correct and accurate [research-agent]
* [ ] edits were made using checkout/checkin commands
* [ ] new terms created in correct ID space
* [ ] complete validation was performed using the ontology-validation agent
- [ ] The ontology validates correctly using `make travis_test` after changes have been made
- [ ] ISSUE_COMMENTS.md written; high level summary of changes, and any requests for further info
- [ ] PR_COMMENTS.md written (if changes made); detailed description of changes made, and rationale. Include checklists. [this agent]

You MUST use the subagent defined in square brackets above for each of these.

## What to do if the ontology is invalid BEFORE you commence work.

if there is a minor fix, go ahead and make it. Otherwise you should
not make edits, and end after creating an ISSUE_COMMENTS.md file with
a detailed description of what is invalid, and a plan for how to fix things.

## Specific subagents for specific tasks

- For any request to obsolete a term, use the term-obsoletion agent
- For any request involving mappings or term xrefs, use the term-mapping agent
- For any task involving signifcant ontology content, use the design-patterns agent

## Performing background research [see also: research-agent]

You can do searches for literature using web search tools. For focused deep research, you can use `deep-research-client`.

Use PMIDs where possible, and ALWAYS check that these PMIDs are the correct ones, and not typos or hallucinated.

## Search and lookup of GO terms

The recommended way to find terms in `src/ontology/go-edit.obo` is using `obo-grep.pl`

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

Troubleshooting: if you can't find `go-edit.obo` it likely means you have changed folder, navigate back up to where the repo is checked out

## Searching terms in other ontologies

See [external-term-lookup] agent if you need to find non-GO terms.

## Making edits

The source file for this ontology is `src/ontology/go-edit.obo`. Generally editing should follow a "checkin" and "checkout" procedure (note: NOT the same as git checkin/out) to facilitate working with small term-specific files, rather than a megafile which is hard to fit into context.

The general procedure is:

* Find relevant terms with `obo-grep.pl`
* Checkout terms with `obo-checkout.pl`
* Make edits in terms/
* Checkin terms with `obo-checkin.pl`
* Perform ontology-wide validation

- IMPORTANT: Do not edit the edit file directly, it's large
- Add edits should be made in the `terms/` folder
- check out a term into `terms/`: `obo-checkout.pl src/ontology/go-edit.obo GO:1234567 [OTHER IDS]`
- This will create a single stanza obo files `terms/go_1234567.obo` which you can easily edit
     - (note the colon is replaced with an underscore)
- You can go ahead and edit the smallers files in the `terms/` folder
- After edits, check back in: `obo-checkin.pl src/ontology/go-edit.obo GO:1234567 [OTHER IDS]`
- if you like you can edit multiple terms in one batch, e.g. `terms/my_batch.obo`
     - `obo-checkout.pl src/ontology/go-edit.obo terms/my_batch.obo`
     - <make edits to terms/my_batch.obo>
     - `obo-checkin.pl src/ontology/go-edit.obo terms/my_batch.obo`
- checking in will update the edit file and remove the file from `terms/`
- Commits are then made on src/ontology/go-edit.obo as appropriate
- Note that `obo-checkout.pl` and `obo-checkin.pl` are in your PATH, no need to search for it    
- Always validate after checkin. See the [ontology-validation] agent

### Creation of new terms

Always follow this procedure:

* Work on new terms in a file in the top level `terms/` folder
* New terms start  GO:777xxxx
   - Do do `grep id: GO:777 src/ontology/go-edit.obo` to check for clashes (in ids and alt_ids)
   - Make a file `terms/GO_777xxxx.obo` with a fresh stanza
* Place this in the edit file with `obo-checkin.pl src/ontology/go-edit.obo terms/GO_777xxxx.obo`

Please do not try and place new terms in the edit file directly as they may end up in the wrong place.

### OBO Format Guidelines

- Term ID format: GO:NNNNNNN (7-digit number)
- Each term requires: id, name, namespace, definition with references
- Never guess GO IDs, use search tools above to determine actual term
- Never guess PMIDs for references, do a web search if needed
- Use standard relationship types: is_a, part_of, has_part, etc.
- Follow existing term patterns for consistency

Tip: It's always a good idea to look at the structure of existing similar terms, these can be found with `obo-grep.pl`

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

## ALWAYS perform validation

Ensure that full validation is performed, using `cd src/ontology && make travis_test`.

This ontology uses standard ODK/ROBOT tests plus custom tests to ensure the ontology is logically, syntactically, and stylistically valid.

After running, this agent should report a checklist:

* [ ] ontology is syntactically correct and has no reasoning issues
* [ ] `make travis_test` has been run and reports no errors

## Full Validation

The standard command to run to validate is:

```
cd src/ontology && make travis_test
```

Like all ODK tests, these are run in the same file as the ontology source. This wraps robot `reason` and other robot QC checks.

To debug syntax errors, try: `cd src/ontology && robot convert -vvv -i go-edit.obo -f obo -o go-edit.TMP.obo`
- The `-vvv` yields a full stack trace if there are errors.


## Logical Error Diagnosis

- Execute `cd src/ontology && robot explain --input go-edit.obo --output go-edit.entailed.obo` to find entailed axioms
- Use `cd src/ontology && robot explain --input go-edit.obo --reasoner ELK  -M unsatisfiability --unsatisfiable all explanations.md` to generate a report explaining unsat classes
- Analyze intersection_of axioms, is_a relationships, and logical definitions for conflicts
- Identify problematic axioms causing reasoning failures
- never use DL reasoners such as hermit for the full ontology, it is too large -- and unneccessary as we only have EL axioms, so ELK is sufficient (ELK is the default)

## Reference Validation

The standard validation pipeline does NOT cover reference validation. For this you must use your own judgment and use the research-agent.

## Reporting back information

If you are addressing a specific github issue, create fresh ISSUE_COMMENTS.md and PR_COMMENTS.md files.

If you are instructed to, then commit changes. These are generally to src/ontology/go-edit.obo. In some cases you may also need to change taxon constraint files.

If you did not modify a file yourself, don't commit it. There may be modifications in files like this CLAUDE.md, this is expected, don't commit them.
