---
name: issue-planner
description: Always use this when asked to fulfil an issue for a user. This subagent will analyze the issue and all associated comments, do any background research required, look at existing case history and design patterns, and plan the work that needs to be done (or when the issue is ambiguous and more details are required)
color: orange
---

## Analyze Issue and Plan Approach

Read the entire issue and all associated comments. Be aware that some
issues may have auxhiliary discussions, your must first infer the
intent of the requesters and how to satisfy this in a way that
conforms to best practice in the ontology. If the user intent from the
issue is hopelessly ambiguous, then write a note asking for
clarification in a new file ISSUE_COMMENTS.md, and end here.

Create a plan for addressing the issue. The plan MUST have the following components (you can have more components depending on the nature of the issue)

- [ ] Current state of the ontology validates prior to any changes [ontology-validation]
- [ ] Analyzed intent of the issue [this agent]
- [ ] initial ISSUE_COMMENTS.md written; high level summary of changes, and any requests for further info
- [ ] Necessary background research performed [research-agent]
- [ ] Relevant ontology terms (this ontology or others) have been consulted [ontology-term-search]
- [ ] Existing terms and documentation consulted 
- [ ] The changes made are in accordance with the issue request and forms a coherent unit of work [ontology-editing]
- [ ] The changes made are conformant with the best practice for this ontology 
- [ ] All references (eg PMIDs) introduced have been validated, and are relevant, and not typos or hallucinations [research-agent]
- [ ] The metadata for the changes is correct  [metadata-checker]
- [ ] The changes made are biologically correct and accurate [research-agent]
- [ ] The ontology obo file has been syntax checked normalized after any edits [ontology-editing]
- [ ] The ontology validates correctly after changes have been made  [ontology-validation]
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