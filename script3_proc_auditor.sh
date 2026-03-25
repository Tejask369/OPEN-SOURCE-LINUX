#!/bin/bash
# =============================================================================
# Script 3: /proc Filesystem & Disk Permission Auditor
# Author: [Your Name] | Roll No: [Your Roll Number]
# Course: Open Source Software | OSS Audit Capstone Project
# Chosen Software: Linux Kernel
# Description: Loops through key system directories and /proc virtual files
#              to report disk usage, permissions, and live kernel data.
#              The /proc filesystem is unique to Linux — it exposes the kernel's
#              internal state as readable files. There is nothing like it in
#              proprietary operating systems.
# =============================================================================

# --- Separator function for cleaner output ---
sep() {
    echo "--------------------------------------------------------"
}

echo "========================================================"
echo "     /proc FILESYSTEM & DISK PERMISSION AUDITOR         "
echo "========================================================"
echo ""

# =============================================================================
# PART 1: Standard directory audit using a for loop
# Loops over important system directories, reports permissions and disk usage
# =============================================================================
echo "  PART 1: KEY SYSTEM DIRECTORY AUDIT"
sep

# Array of directories to audit — these are standard Linux filesystem locations
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/boot" "/lib/modules")

# for loop: iterate over each directory in the array
for DIR in "${DIRS[@]}"; do

    # if-then-else: check the directory exists before trying to read it
    if [ -d "$DIR" ]; then
        # ls -ld: list directory itself (not contents), long format
        # awk: extract permissions (field 1), owner (field 3), group (field 4)
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3":"$4}')

        # du -sh: disk usage, human-readable (-h), summary (-s)
        # 2>/dev/null suppresses permission errors
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        printf "  %-20s Perms: %-12s Owner: %-15s Size: %s\n" \
               "$DIR" "$PERMS" "$OWNER" "$SIZE"
    else
        # Directory does not exist on this system
        printf "  %-20s [does not exist on this system]\n" "$DIR"
    fi
done

echo ""

# =============================================================================
# PART 2: Live kernel data from /proc — unique to Linux
# /proc is a virtual filesystem created by the kernel at boot.
# Every file here is generated on-demand by the kernel — no disk storage used.
# This is what makes Linux so transparent compared to proprietary OS.
# =============================================================================
echo "  PART 2: LIVE KERNEL DATA FROM /proc FILESYSTEM"
sep
echo "  Note: /proc files are virtual — they have no real size on disk."
echo "        The kernel generates their contents dynamically on each read."
echo ""

# --- /proc/version: kernel build information ---
if [ -f /proc/version ]; then
    echo "  /proc/version (kernel build info):"
    echo "  $(cat /proc/version | cut -c1-80)..."
    echo ""
fi

# --- /proc/cpuinfo: CPU details ---
if [ -f /proc/cpuinfo ]; then
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
    CPU_CORES=$(grep -c "processor" /proc/cpuinfo)
    echo "  /proc/cpuinfo:"
    echo "    CPU Model : $CPU_MODEL"
    echo "    CPU Cores : $CPU_CORES"
    echo ""
fi

# --- /proc/meminfo: memory statistics ---
if [ -f /proc/meminfo ]; then
    MEM_TOTAL=$(grep "MemTotal" /proc/meminfo | awk '{printf "%.1f GB", $2/1024/1024}')
    MEM_FREE=$(grep "MemAvailable" /proc/meminfo | awk '{printf "%.1f GB", $2/1024/1024}')
    echo "  /proc/meminfo:"
    echo "    Total RAM  : $MEM_TOTAL"
    echo "    Available  : $MEM_FREE"
    echo ""
fi

# --- /proc/uptime: system uptime in seconds ---
if [ -f /proc/uptime ]; then
    UPTIME_SECS=$(cat /proc/uptime | awk '{print int($1)}')
    UPTIME_DAYS=$((UPTIME_SECS / 86400))
    UPTIME_HRS=$(( (UPTIME_SECS % 86400) / 3600 ))
    UPTIME_MINS=$(( (UPTIME_SECS % 3600) / 60 ))
    echo "  /proc/uptime:"
    echo "    System has been running for: ${UPTIME_DAYS}d ${UPTIME_HRS}h ${UPTIME_MINS}m"
    echo ""
fi

# --- /proc/loadavg: CPU load averages ---
if [ -f /proc/loadavg ]; then
    LOAD=$(cat /proc/loadavg)
    echo "  /proc/loadavg (1min / 5min / 15min CPU load):"
    echo "    $LOAD"
    echo ""
fi

# --- /proc/filesystems: filesystems the kernel supports ---
if [ -f /proc/filesystems ]; then
    echo "  /proc/filesystems (kernel-supported filesystems, sample):"
    grep -v "nodev" /proc/filesystems | awk '{print "    " $1}' | head -8
    echo ""
fi

# =============================================================================
# PART 3: Check Linux Kernel's own config directory and boot files
# This links back to Part B of the report — where the kernel lives on disk
# =============================================================================
echo "  PART 3: LINUX KERNEL FOOTPRINT ON THIS SYSTEM"
sep

# Kernel config directories and files to check
KERNEL_PATHS=("/boot" "/lib/modules/$(uname -r)" "/proc/sys/kernel" "/etc/sysctl.conf")

for KPATH in "${KERNEL_PATHS[@]}"; do
    if [ -e "$KPATH" ]; then
        PERMS=$(ls -ld "$KPATH" 2>/dev/null | awk '{print $1, $3, $4}')
        echo "  FOUND: $KPATH"
        echo "         Permissions: $PERMS"
    else
        echo "  NOT FOUND: $KPATH"
    fi
done

echo ""

# Show kernel version files in /boot
echo "  Kernel files in /boot:"
ls /boot/vmlinuz* /boot/initrd* /boot/System.map* 2>/dev/null | \
    while read f; do
        SIZE=$(du -sh "$f" 2>/dev/null | cut -f1)
        echo "    $f  ($SIZE)"
    done

echo ""
echo "========================================================"
echo "  Audit complete. The /proc filesystem is your window"
echo "  into the Linux kernel's live state — no proprietary"
echo "  OS exposes this level of transparency to its users."
echo "========================================================"
