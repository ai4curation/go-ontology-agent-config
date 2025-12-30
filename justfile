AGENT_FILES := "CLAUDE.md AGENTS.md .goosehints .github/copilot-instructions.md .claude .codex"

# Remove agent instructions from the target directory
[no-cd]
pre_clean target-directory=".":
    cd {{target-directory}} && rm -rf {{AGENT_FILES}}

[no-cd]
install-tools:
    uv tool install --force oaklib
    uv tool install --force linkml-reference-validator --with linkml
    uv tool install --force deep-research-client
    git clone https://github.com/cmungall/obo-scripts.git && mv obo-scripts/obo-grep.pl obo-scripts/obo-checkin.pl  obo-scripts/obo-checkout.pl /usr/local/bin

# Install the template into the target (current directory by default) directory
[no-cd]
install target-directory=".": (pre_clean target-directory) (install-tools)
    copier copy -f {{ justfile_directory() }}/template {{ target-directory }}
