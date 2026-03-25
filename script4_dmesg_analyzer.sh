#!/bin/bash
# =============================================================================
# Script 4: Kernel dmesg Log Analyzer
# Author: [Your Name] | Roll No: [Your Roll Number]
# Course: Open Source Software | OSS Audit Capstone Project
# Chosen Software: Linux Kernel
# Description: Reads the kernel ring buffer (dmesg) or a log file line by line,
#              counts occurrences of keywords (error, warning, etc.), and prints
#              a summary with matching lines. Demonstrates while-read loop,
#              if-then logic, counters, and command-line arguments.
# Usage: ./script4_dmesg_analyzer.sh [logfile] [keyword]
#        Examples:
#          ./script4_dmesg_analyzer.sh                    # uses dmesg directly
#          ./script4_dmesg_analyzer.sh /var/log/syslog    # uses a log file
#          ./script4_dmesg_analyzer.sh /var/log/syslog error
# =============================================================================

# --- Command-line arguments ---
# $1 = optional log file path; if not provided, we use dmesg output
# $2 = optional keyword; defaults to "error"
LOGFILE=$1
KEYWORD=${2:-"error"}       # Default keyword is 'error' if not specified

# --- Counter variables ---
TOTAL_LINES=0
MATCH_COUNT=0
WARN_COUNT=0
ERR_COUNT=0
CRIT_COUNT=0

# --- Temporary file to store matching lines ---
TMPFILE=$(mktemp /tmp/dmesg_matches_XXXXXX)

echo "========================================================"
echo "     KERNEL DMESG LOG ANALYZER                          "
echo "========================================================"
echo ""

# =============================================================================
# Determine the input source: file or live dmesg
# =============================================================================
if [ -n "$LOGFILE" ]; then
    # A log file was provided as argument — verify it exists and is not empty
    if [ ! -f "$LOGFILE" ]; then
        echo "  ERROR: File '$LOGFILE' not found."
        echo "  Usage: $0 [logfile] [keyword]"
        exit 1
    fi

    # Check if the file is empty — do-while style retry loop
    RETRY=0
    while [ ! -s "$LOGFILE" ]; do
        RETRY=$((RETRY + 1))
        echo "  WARNING: '$LOGFILE' appears to be empty. Retry $RETRY of 3..."
        sleep 1
        # After 3 retries, give up
        if [ $RETRY -ge 3 ]; then
            echo "  File is still empty after $RETRY retries. Exiting."
            exit 1
        fi
    done

    echo "  Source  : File — $LOGFILE"
    INPUT_CMD="cat \"$LOGFILE\""
else
    # No file provided — use live dmesg (kernel ring buffer)
    # dmesg reads messages from the kernel's internal message buffer
    echo "  Source  : Live kernel ring buffer (dmesg)"
    INPUT_CMD="dmesg"
fi

echo "  Keyword : '$KEYWORD'"
echo ""
echo "  Scanning..."
echo ""

# =============================================================================
# WHILE-READ LOOP: read the log/dmesg line by line
# This is the core of the script — processes one line at a time
# =============================================================================
eval "$INPUT_CMD" | while IFS= read -r LINE; do
    # Increment total line counter
    TOTAL_LINES=$((TOTAL_LINES + 1))

    # if-then: check if the line contains our target keyword (case-insensitive)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        MATCH_COUNT=$((MATCH_COUNT + 1))
        # Save the matching line to temp file for later display
        echo "$LINE" >> "$TMPFILE"
    fi

    # Count specific severity levels regardless of the main keyword
    if echo "$LINE" | grep -iq "warning\|warn"; then
        WARN_COUNT=$((WARN_COUNT + 1))
    fi

    if echo "$LINE" | grep -iq "error\|err"; then
        ERR_COUNT=$((ERR_COUNT + 1))
    fi

    if echo "$LINE" | grep -iq "critical\|crit\|panic\|oops"; then
        CRIT_COUNT=$((CRIT_COUNT + 1))
    fi

done

# --- Count total lines separately (subshell can't export counters) ---
if [ -n "$LOGFILE" ]; then
    TOTAL_LINES=$(wc -l < "$LOGFILE")
else
    TOTAL_LINES=$(dmesg | wc -l)
fi
MATCH_COUNT=$(wc -l < "$TMPFILE" 2>/dev/null || echo 0)

# Re-count severity levels from the source
if [ -n "$LOGFILE" ]; then
    WARN_COUNT=$(grep -ic "warning\|warn" "$LOGFILE" 2>/dev/null || echo 0)
    ERR_COUNT=$(grep -ic "error\|err" "$LOGFILE" 2>/dev/null || echo 0)
    CRIT_COUNT=$(grep -ic "critical\|crit\|panic\|oops" "$LOGFILE" 2>/dev/null || echo 0)
else
    WARN_COUNT=$(dmesg | grep -ic "warning\|warn" 2>/dev/null || echo 0)
    ERR_COUNT=$(dmesg | grep -ic "error\|err" 2>/dev/null || echo 0)
    CRIT_COUNT=$(dmesg | grep -ic "critical\|crit\|panic\|oops" 2>/dev/null || echo 0)
fi

# =============================================================================
# Summary output
# =============================================================================
echo "========================================================"
echo "  ANALYSIS SUMMARY"
echo "========================================================"
echo "  Total lines scanned : $TOTAL_LINES"
echo "  Matches for '$KEYWORD' : $MATCH_COUNT"
echo ""
echo "  Severity breakdown (all keywords):"
echo "    Warnings  (warn/warning)         : $WARN_COUNT"
echo "    Errors    (error/err)             : $ERR_COUNT"
echo "    Critical  (critical/panic/oops)   : $CRIT_COUNT"
echo ""

# =============================================================================
# Show the last 10 matching lines (tail + grep approach)
# =============================================================================
echo "========================================================"
echo "  LAST 10 LINES MATCHING '$KEYWORD'"
echo "========================================================"
echo ""

if [ -s "$TMPFILE" ]; then
    # tail: show the last 10 lines of the match file
    tail -10 "$TMPFILE" | while IFS= read -r MATCH_LINE; do
        # Trim very long lines to 100 chars for readable output
        echo "  >> ${MATCH_LINE:0:100}"
    done
else
    echo "  No lines found matching '$KEYWORD'."
    echo "  The kernel appears to be running cleanly — no $KEYWORD messages."
fi

echo ""

# =============================================================================
# Show kernel boot messages summary (first 5 lines of dmesg)
# This is always useful to include in the Part B report
# =============================================================================
echo "========================================================"
echo "  KERNEL BOOT MESSAGES (first 5 lines of dmesg)"
echo "========================================================"
dmesg | head -5 | while IFS= read -r LINE; do
    echo "  $LINE"
done

echo ""
echo "========================================================"
echo "  The kernel ring buffer is a circular log maintained"
echo "  entirely in memory. Unlike proprietary OS logs, every"
echo "  kernel message is readable without special tools —"
echo "  just 'dmesg'. This transparency is a GPL freedom."
echo "========================================================"

# --- Clean up temporary file ---
rm -f "$TMPFILE"
