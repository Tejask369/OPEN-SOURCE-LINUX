#!/bin/bash
# =============================================================================
# Script 5: Open Source Manifesto Generator
# Author: [Your Name] | Roll No: [Your Roll Number]
# Course: Open Source Software | OSS Audit Capstone Project
# Chosen Software: Linux Kernel
# Description: Interactively asks the user three questions about open source,
#              then composes a personalised philosophy statement and saves it
#              to a .txt file. Demonstrates read, string concatenation, file
#              writing with >, date command, and the alias concept.
# =============================================================================

# --- Alias demonstration (concept shown via comment as required) ---
# In a live shell session you could run:
#   alias today='date "+%d %B %Y"'
# and then use: today
# Here we use the date command directly since aliases don't persist in scripts.

# --- Welcome banner ---
echo "========================================================"
echo "      OPEN SOURCE MANIFESTO GENERATOR                   "
echo "========================================================"
echo ""
echo "  This tool generates a personalised open source"
echo "  philosophy statement based on your answers."
echo ""
echo "  Answer honestly — this will be YOUR manifesto."
echo ""
echo "========================================================"
echo ""

# =============================================================================
# Interactive input using 'read' — collects user answers into variables
# =============================================================================

# Question 1: A Linux/open-source tool the student uses daily
read -p "  Q1. Name one Linux or open-source tool you use every day: " TOOL
echo ""

# Question 2: One word describing what 'freedom' means in software
read -p "  Q2. In one word, what does software 'freedom' mean to you? " FREEDOM
echo ""

# Question 3: Something the student would build and share freely
read -p "  Q3. Name one thing you would build and share freely: " BUILD
echo ""

# Question 4 (bonus): How they feel about companies profiting from OSS
read -p "  Q4. Should companies profit from free software? (yes/no/mixed): " PROFIT_VIEW
echo ""

# Question 5: Their software choice for this project
read -p "  Q5. In one word, what makes the Linux Kernel important? " KERNEL_WORD
echo ""

# --- Date and output filename ---
# date command with format string to get readable date
DATE=$(date '+%d %B %Y')
TIME=$(date '+%H:%M')

# String concatenation: build the output filename from username
OUTPUT="manifesto_$(whoami).txt"

# =============================================================================
# Compose the manifesto paragraph using string concatenation
# Echo statements are appended to the file using >> (append redirect)
# The file is created fresh with > on the first write
# =============================================================================

# Create/overwrite the file with the header (> creates or truncates)
echo "========================================================" > "$OUTPUT"
echo "  OPEN SOURCE MANIFESTO" >> "$OUTPUT"
echo "  Generated: $DATE at $TIME" >> "$OUTPUT"
echo "  Author: $(whoami) on $(hostname)" >> "$OUTPUT"
echo "========================================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# --- Main manifesto paragraph (string concatenation across multiple echos) ---
echo "  Every day, I rely on $TOOL — a piece of software that" >> "$OUTPUT"
echo "  someone built and chose to share with the world at no cost." >> "$OUTPUT"
echo "  To me, software freedom means $FREEDOM. Not just the absence" >> "$OUTPUT"
echo "  of a price tag, but the right to see, modify, and redistribute" >> "$OUTPUT"
echo "  the tools that shape how I think and work." >> "$OUTPUT"
echo "" >> "$OUTPUT"

echo "  The Linux Kernel, at the heart of this project, is $KERNEL_WORD." >> "$OUTPUT"
echo "  It was not built by a corporation chasing profit — it was built" >> "$OUTPUT"
echo "  by Linus Torvalds in 1991, a student who needed a free Unix system," >> "$OUTPUT"
echo "  and by thousands of contributors who believed the same thing:" >> "$OUTPUT"
echo "  that foundational software should belong to everyone." >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Conditional paragraph based on their answer about company profits
# if-then-elif-else: branch based on the PROFIT_VIEW variable
if [ "$PROFIT_VIEW" = "yes" ]; then
    echo "  I believe companies can and should profit from open source —" >> "$OUTPUT"
    echo "  not by locking it down, but by adding value on top of it." >> "$OUTPUT"
    echo "  Red Hat built a billion-dollar business on Linux while giving" >> "$OUTPUT"
    echo "  every change back. That is the GPL working as designed." >> "$OUTPUT"
elif [ "$PROFIT_VIEW" = "no" ]; then
    echo "  Software built by a community's unpaid labor should not be" >> "$OUTPUT"
    echo "  the foundation of private profit without contribution back." >> "$OUTPUT"
    echo "  The GPL v2 that covers the Linux Kernel was written precisely" >> "$OUTPUT"
    echo "  to prevent this — any derivative work must remain free." >> "$OUTPUT"
else
    echo "  The relationship between open source and commercial profit is" >> "$OUTPUT"
    echo "  complex. Companies like Red Hat and Canonical have sustained" >> "$OUTPUT"
    echo "  the ecosystem. Others have extracted without contributing." >> "$OUTPUT"
    echo "  The GPL v2 draws a legal line: take freely, but share back." >> "$OUTPUT"
fi

echo "" >> "$OUTPUT"

echo "  One day, I want to build $BUILD and release it freely — because" >> "$OUTPUT"
echo "  the tools I will use to build it were given to me freely." >> "$OUTPUT"
echo "  Standing on the shoulders of giants means acknowledging the debt," >> "$OUTPUT"
echo "  and the best way to repay it is to lift the next person up." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "  This is my open source manifesto." >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "========================================================" >> "$OUTPUT"
echo "  Signed: $(whoami) | $(date)" >> "$OUTPUT"
echo "========================================================" >> "$OUTPUT"

# =============================================================================
# Display the result
# =============================================================================
echo ""
echo "========================================================"
echo "  Your manifesto has been saved to: $OUTPUT"
echo "========================================================"
echo ""

# cat: display the contents of the file we just wrote
cat "$OUTPUT"

echo ""
echo "========================================================"
echo "  'The Linux kernel is a perfect example of what can"
echo "   happen when the right people are allowed to be free."
echo "   Free to work on what they care about, free to share"
echo "   their work.' — Linus Torvalds"
echo "========================================================"
