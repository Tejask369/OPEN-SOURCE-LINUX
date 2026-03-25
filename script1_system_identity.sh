#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Author: [Your Name] | Roll No: [Your Roll Number]
# Course: Open Source Software | OSS Audit Capstone Project
# Chosen Software: Linux Kernel
# Description: Displays a welcome screen with key system information including
#              kernel version, distro, user info, uptime, and license details.
# =============================================================================

# --- Variables ---
STUDENT_NAME="[Your Name]"          # Replace with your name
ROLL_NO="[Your Roll Number]"        # Replace with your roll number
SOFTWARE_CHOICE="Linux Kernel"      # Chosen OSS project

# --- Gather system information using command substitution ---
KERNEL=$(uname -r)                          # Full kernel release string
KERNEL_ARCH=$(uname -m)                     # CPU architecture (x86_64, etc.)
KERNEL_OS=$(uname -o)                       # OS name (GNU/Linux)
USER_NAME=$(whoami)                         # Currently logged-in user
HOME_DIR=$HOME                              # User's home directory
UPTIME=$(uptime -p)                         # Human-readable uptime
CURRENT_DATE=$(date '+%A, %d %B %Y')        # Formatted date
CURRENT_TIME=$(date '+%H:%M:%S %Z')         # Formatted time with timezone
HOSTNAME=$(hostname)                        # System hostname

# --- Read distro name from /etc/os-release (standard across distros) ---
# /etc/os-release is a freedesktop.org standard file present on all modern Linux distros
if [ -f /etc/os-release ]; then
    DISTRO=$(grep -w "PRETTY_NAME" /etc/os-release | cut -d'=' -f2 | tr -d '"')
else
    # Fallback if /etc/os-release is not found
    DISTRO="Unknown Linux Distribution"
fi

# --- Read kernel GPL license info from /proc/version ---
# /proc/version is a virtual file exposed by the kernel itself
if [ -f /proc/version ]; then
    KERNEL_BUILD=$(cat /proc/version | cut -d'(' -f1)
else
    KERNEL_BUILD="Kernel version info unavailable"
fi

# --- Display the identity report ---
echo "========================================================"
echo "        OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT      "
echo "========================================================"
echo ""
echo "  Student  : $STUDENT_NAME ($ROLL_NO)"
echo "  Software : $SOFTWARE_CHOICE"
echo "  Course   : Open Source Software"
echo ""
echo "--------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "--------------------------------------------------------"
echo "  Hostname       : $HOSTNAME"
echo "  Distribution   : $DISTRO"
echo "  Kernel Version : $KERNEL"
echo "  Architecture   : $KERNEL_ARCH"
echo "  OS Type        : $KERNEL_OS"
echo ""
echo "--------------------------------------------------------"
echo "  USER INFORMATION"
echo "--------------------------------------------------------"
echo "  Logged-in User : $USER_NAME"
echo "  Home Directory : $HOME_DIR"
echo ""
echo "--------------------------------------------------------"
echo "  TIME & UPTIME"
echo "--------------------------------------------------------"
echo "  Current Date   : $CURRENT_DATE"
echo "  Current Time   : $CURRENT_TIME"
echo "  System Uptime  : $UPTIME"
echo ""
echo "--------------------------------------------------------"
echo "  LICENSE INFORMATION"
echo "--------------------------------------------------------"
echo "  The Linux Kernel is licensed under the GNU General"
echo "  Public License version 2 (GPL v2)."
echo ""
echo "  This means:"
echo "    - You have the freedom to run the kernel for any purpose."
echo "    - You can study and modify the source code."
echo "    - You can redistribute copies freely."
echo "    - Any modified version you distribute must also be GPL v2."
echo ""
echo "  'Free as in freedom, not free as in free beer.' — RMS"
echo "========================================================"
echo ""

# --- Extra: Show top 5 loaded kernel modules ---
# Kernel modules are components of the kernel loaded at runtime
echo "  TOP 5 LOADED KERNEL MODULES (via lsmod):"
echo "--------------------------------------------------------"
lsmod | awk 'NR>1 {print "  " $1}' | head -5
echo "========================================================"
