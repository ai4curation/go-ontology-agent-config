---
name: ontology-editing
description: Use this to make any edits to the ontology. It's important to use these instructions before editing directly. The general methodology is to checkout terms (obo-checkout.pl) from the main edit file into a terms/ folder, and then check them back in (obo-checkin.pl), rather than editing directly.
---

The source file for this ontology is src/ontology/go-edit.obo. Generally editing should follow a "checkin" and "checkout" procedure (note: NOT the same as git checkin/out) to facilitate working with small term-specific files, rather than a megafile which is hard to fit into context.

The general procedure is:

* Find relevant terms with `obo-grep.pl`
* Checkout terms with `obo-checkout.pl`
* Make edits in terms/
* Checkin terms with `obo-checkin.pl`
* Perform ontology-wide validation

## Details

- IMPORTANT: Do not edit the edit file directly, it's large
- Add edits should be made in the `terms/` folder
- check out a term into `terms/`: `obo-checkout.pl src/ontology/go-edit.obo GO:1234567 [OTHER IDS]`
- This will create a single stanza obo files `terms/go_1234567.obo` which you can easily edit
     - (note the colon is replaced with an underscore)
- You can go ahead and edit the smallers files in the `terms/` folder
- After edits, check back in: `obo-checkin.pl src/ontology/go-edit.obo GO:1234567 [OTHER IDS]`
- if you like you can edit multiple terms in one batch, e.g. `terms/my_batch.obo`
     - `obo-checkout.pl src/ontology/go-edit.obo terms/my_batch.obo`
- checking in will update the edit file and remove the file from `terms/`
- Commits are then made on src/ontology/go-edit.obo as appropriate
- Note that `obo-checkin.pl` and `obo-checkin.pl` are in your PATH, no need to search for it    
- Always validate after checkin

## Creation of new terms

New terms start  GO:777xxxx
  - Do do `grep id: GO:777 src/ontology/go-edit.obo` to check for clashes (in ids and alt_ids)

When creating a new term there is generally no `obo-checkout.pl` step. Just make a file `term/GO_777xxxx.obo` with a fresh stanza. Ensure it is complete, using the metadata-checker and design-pattern-agent

## OBO Format Guidelines

- Term ID format: GO:NNNNNNN (7-digit number)

- Each term requires: id, name, namespace, definition with references
- Never guess GO IDs, use search tools above to determine actual term
- Never guess PMIDs for references, do a web search if needed
- Use standard relationship types: is_a, part_of, has_part, etc.
- Follow existing term patterns for consistency


