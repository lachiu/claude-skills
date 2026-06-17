#!/usr/bin/env bash

set -euo pipefail

GREEN=''
YELLOW=''
BLUE=''
RED=''
NC=''

if command -v tput >/dev/null && [[ -t 1 ]]; then
    GREEN=$(tput setaf 2)
    YELLOW=$(tput setaf 3)
    BLUE=$(tput setaf 4)
    RED=$(tput setaf 1)
    NC=$(tput sgr0)
fi

echo
echo
echo "${BLUE}🚀 Skill Scaffold Generator${NC}"
echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo

if [[ $# -ne 1 ]]; then
    echo "${RED}❌ Error: Missing skill name${NC}"
    echo "${YELLOW}💡 Usage: $0 <skill-name>${NC}"
    echo
    exit 1
fi

skill="$1"

if [[ ! "$skill" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "${RED}❌ Error: Invalid skill name${NC}"
    echo "${YELLOW}💡 Allowed characters: a-z A-Z 0-9 _ -${NC}"
    echo
    exit 1
fi

echo "${BLUE}📦 Creating skill:${NC} $skill"

mkdir -p "$skill"
echo "${GREEN}  📁 Created directory${NC}"

touch "$skill/SKILL.md"
echo "${GREEN}  📝 Created SKILL.md${NC}"

mkdir -p "$skill/references"
echo "${GREEN}  📚 Created references/${NC}"

echo
echo "${GREEN}✨ Done!${NC}"
echo
echo "${BLUE}🎯 Your skill scaffold is ready:${NC}"
echo "$skill/"
echo "├── 📝 SKILL.md"
echo "└── 📚 references/"