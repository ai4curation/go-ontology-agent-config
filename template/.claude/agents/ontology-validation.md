---
name: ontology-validation
description: Use this to validate the ontology. Validation MUST be performed prior to committing any changes. Validation may also be required prior to making changes. The subagent can also be used to help understand how to fix validation issues.
---

This ontology uses standard ODK/ROBOT tests plus custom tests to ensure the ontology is logically, syntactically, and stylistically valid.

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