#!/bin/bash

set -e

# "Use cases tree" section in 'use_cases.md' will be converted from tree to plain text
# Input and output format are Markdown
# Output file is 'plain_text_use_cases_tree.md'
# Nodes starting with '*' will not be displayed
# Nodes starting with '-' will be displayed

USE_CASES_DOC=use_cases.md
USE_CASES_TREE_TITLE="## Use cases tree"
USE_CASES_TREE=use_cases_tree.txt
PLAIN_TEXT_USE_CASES_TREE=plain_text_use_cases_tree.md

USE_CASES_TREE_TITLE_LINE_NO=$(grep -n "${USE_CASES_TREE_TITLE}" ${USE_CASES_DOC} | cut -d ':' -f 1)
USE_CASES_TREE_BEGIN_LINE_NO=$((USE_CASES_TREE_TITLE_LINE_NO + 1))

tail ${USE_CASES_DOC} -n +${USE_CASES_TREE_BEGIN_LINE_NO} > ${USE_CASES_TREE}

./use_cases_tree_to_plain_text.js > ${PLAIN_TEXT_USE_CASES_TREE}

echo "Output is '${PLAIN_TEXT_USE_CASES_TREE}'"
