#!/bin/bash
# validate-setup.sh - Verify research skill prerequisites

echo "=== Research Skill Setup Validation ==="
echo ""

# Check for mdb MCP server
echo "Checking MDB MCP server..."
if command -v claude &> /dev/null; then
    if claude mcp list 2>/dev/null | grep -q "mdb"; then
        echo "✓ mdb MCP server found"
    else
        echo "✗ mdb MCP server not found"
        echo "  Install mdb MCP server for vault integration"
        exit 1
    fi
else
    echo "? Claude CLI not available - cannot verify MCP servers"
fi

echo ""
echo "Checking vault access..."

# Try to find vault root
VAULT_PATHS=(
    "$HOME/vault"
    "$HOME/Obsidian"
    "$HOME/Documents/vault"
    "$HOME/Documents/Obsidian"
)

VAULT_FOUND=""
for path in "${VAULT_PATHS[@]}"; do
    if [ -d "$path" ]; then
        VAULT_FOUND="$path"
        break
    fi
done

if [ -n "$VAULT_FOUND" ]; then
    echo "✓ Vault found at: $VAULT_FOUND"
else
    echo "? No vault found at common paths"
    echo "  Vault access will be via mdb MCP server"
fi

echo ""
echo "Checking skill files..."

SKILL_DIR="$(dirname "$0")/.."
if [ -f "$SKILL_DIR/SKILL.md" ]; then
    echo "✓ SKILL.md found"
else
    echo "✗ SKILL.md not found"
    exit 1
fi

# Count reference files
MODE_COUNT=$(ls -1 "$SKILL_DIR/references/modes/"*.md 2>/dev/null | wc -l)
echo "  Mode references: $MODE_COUNT files"

TEMPLATE_COUNT=$(ls -1 "$SKILL_DIR/references/templates/"*.md 2>/dev/null | wc -l)
echo "  Templates: $TEMPLATE_COUNT files"

echo ""
echo "=== Validation Complete ==="
echo ""
echo "To use this skill:"
echo "  1. Ensure mdb MCP server is configured"
echo "  2. Install skill: claude skill install ./skill-research/"
echo "  3. Start researching!"
