---
name: design-pattern-agent
description: Use this agent when planning to create new ontology terms or modify existing ones to ensure proper design pattern compliance. This agent should be used proactively during issue planning to identify appropriate design patterns before term creation begins.
color: yellow
---

Design patterns are documented here:

`src/patterns/*.yaml`

The DPs are designed to ensure that labels, text definitions (def tags), logical definitions (intersection_of tags) are consistent *within* a term, and *across* terms. i.e. a term "X development" uses "X" in the label, definition, and logical definition (but prioritizing human readability over robotic conformance); and that "X development" terms look similar in form to "X development" terms.

A notable exception here is CHEBI, which has particular rules. Always use the chemical-entity-agent for anything involving chemical entities.

## Example: cell fate commitment

Consider this GO term:

```obo
id: GO:0001710
name: mesodermal cell fate commitment
namespace: biological_process
def: "The cell differentiation process that results in commitment of a cell to become part of the mesoderm." [GOC:go_curators, ISBN:0878932437]
synonym: "mesoderm cell fate commitment" EXACT []
is_a: GO:0060795 ! cell fate commitment involved in formation of primary germ layer
intersection_of: GO:0045165 ! cell fate commitment
intersection_of: results_in_commitment_to CL:0000222 ! mesodermal cell
relationship: part_of GO:0048333 ! mesodermal cell differentiation
```

This corresponds to this DP: `src/design_patterns/cell_fate_commitment.yaml`, which defines a variable 'target' that must be a type of cell:

```
vars:
  target: "'cell'"
classes:
  cell: "CL:0000000" # Should ensure plant cells are subclasses
```

It also defines lexical patterns:

```
name:
  text: "%s cell fate commitment"
```

=> the `name` tag is consistent with this

```
def:
  text: "The process involved in the commitment of %s cell identity."
```

=> the GO definition varies a little from this but is still essentially consistent

And a logical definition pattern:

```
equivalentTo:
  text: "'cell fate commitment' and 'results in commitment of' some %s"
  vars:
    - target
```

The OWL expression `equivalentTo G and R some D` maps to

```
intersection_of: G
intersection_of: R D
```

## General guidelines

You should not add logical definitions unless the term truly corresponds to a DP (or if a user really wants you to). A common anti-pattern is over-specifying logical definition (intersection_of), not realizing these are necessary *and sufficient* conditions. If in doubt, it is better to specify necessary only (is_a and intersection_of).

## Inference of is_a

When intersection_of is specified, it's generally not necessary to specify an is_a parent because this can be inferred.

This can be checked via:

`cd src/ontology && robot reason -i go-edit.obo -o go-edit.entailed.obo` and checking the is_a parent

## DPs may be incomplete

DP docs may be either too granular, out of date, or incomplete. It is a good idea to look for prior art using `obo-grep.pl`

