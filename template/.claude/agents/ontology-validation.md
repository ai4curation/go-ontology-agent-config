---
name: ontology-validation
description: Use this to validate the ontology. Validation MUST be performed prior to committing any changes. Validation may also be required prior to making changes. The subagent can also be used to help understand how to fix validation issues.
---

This ontology uses standard ODK/ROBOT tests plus custom tests to ensure the ontology is logically, syntactically, and stylistically valid.

## Syntax checking and normalization

Always run the following command

`cd src/ontology && robot convert -i  go-edit.obo -o go-edit.normalized.obo && mv go-edit.normalized.obo go-edit.obo`

This will ensure that stanzas in go-edit are ordered canonically. It will also fail fast if there are any syntax
errors introduced

## Full Validation

The standard command to run to validate is:

```
cd src/ontology && make travis_test
```

Like all ODK tests, these are run in the same file as the ontology source. This wraps robot `reason` and other robot QC checks.


## Logical Error Diagnosis

- Execute `cd src/ontology && robot explain --input go-edit.obo --output go-edit.entailed.obo` to find entailed axioms
- Use `cd src/ontology && robot explain --input go-edit.obo --reasoner ELK  -M unsatisfiability --unsatisfiable all explanations.md` to generate a report explaining unsat classes
- Analyze intersection_of axioms, is_a relationships, and logical definitions for conflicts
- Identify problematic axioms causing reasoning failures
- never use DL reasoners such as hermit for the full ontology, it is too large -- and unneccessary as we only have EL axioms, so ELK is sufficient (ELK is the default)

## Reference Validation

The standard validation pipeline does NOT cover reference validation. For this you must use your own judgment and use the research-agent.