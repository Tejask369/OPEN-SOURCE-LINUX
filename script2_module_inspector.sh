#!/bin/bash
# =============================================================================
# Script 2: FOSS Package & Kernel Module Inspector
# Author: [Your Name] | Roll No: [Your Roll Number]
# Course: Open Source Software | OSS Audit Capstone Project
# Chosen Software: Linux Kernel
# Description: Checks if key Linux kernel-related packages are installed,
#              displays their version and license info, and uses a case
#              statement to print a philosophy note for each package.
# Usage: ./script2_module_inspector.sh [package-name]
#        If no argument is given, a default list is inspected.
# =============================================================================

# --- Function to detect the package manager ---
# Different Linux distros use different package managers (apt, rpm, pacman)
detect_pkg_manager() {
    if command -v rpm &>/dev/null; then
        echo "rpm"
    elif command -v dpkg &>/dev/null; then
        echo "dpkg"
    elif command -v pacman &>/dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# --- Function to check if a package is installed ---
# Takes package name as argument, returns 0 (found) or 1 (not found)
check_package() {
    local PKG=$1
    local MGR=$(detect_pkg_manager)

    # Use the appropriate package manager command
    case $MGR in
        rpm)
            rpm -q "$PKG" &>/dev/null
            ;;
        dpkg)
            dpkg -l "$PKG" 2>/dev/null | grep -q "^ii"
            ;;
        pacman)
            pacman -Q "$PKG" &>/dev/null
            ;;
        *)
            # If no package manager found, return not found
            return 1
            ;;
    esac
}

# --- Function to get package version ---
get_version() {
    local PKG=$1
    local MGR=$(detect_pkg_manager)

    case $MGR in
        rpm)
            rpm -q --queryformat '%{VERSION}' "$PKG" 2>/dev/null
            ;;
        dpkg)
            dpkg -l "$PKG" 2>/dev/null | grep "^ii" | awk '{print $3}'
            ;;
        pacman)
            pacman -Q "$PKG" 2>/dev/null | awk '{print $2}'
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# --- Philosophy note function using case statement ---
# For each well-known OSS package, print a philosophy reflection
print_philosophy() {
    local PKG=$1
    echo ""
    echo "  [PHILOSOPHY NOTE]"

    # case statement matches the package name to a philosophy note
    case $PKG in
        linux-kernel | kernel | linux)
            echo "  Linux Kernel: Born from a student's frustration in 1991, the kernel"
            echo "  proved that a global community of strangers can build something more"
            echo "  reliable than any single company. It powers 97% of the world's servers."
            ;;
        gcc | gcc-*)
            echo "  GCC: The GNU Compiler Collection is the backbone that compiles the"
            echo "  Linux kernel itself. Without GPL-licensed GCC, the free software"
            echo "  ecosystem would not exist as we know it today."
            ;;
        bash)
            echo "  Bash: The GNU Bourne Again Shell. Every time you type a command,"
            echo "  you interact with free software. Bash embodies the Unix philosophy:"
            echo "  small tools that do one thing well, combined to do anything."
            ;;
        python3 | python)
            echo "  Python: Shaped entirely by its community through PEPs (Python"
            echo "  Enhancement Proposals). It shows that open governance can produce"
            echo "  software used by millions without a single corporate owner."
            ;;
        git)
            echo "  Git: Linus Torvalds built Git in 2005 after BitKeeper revoked its"
            echo "  free license. The irony is that a proprietary tool's removal led to"
            echo "  the creation of the most widely used version control system ever."
            ;;
        httpd | apache2)
            echo "  Apache HTTP Server: Powers ~30% of all websites. A foundation-governed"
            echo "  project that showed corporations could collaborate on shared"
            echo "  infrastructure without giving one company a monopoly."
            ;;
        mysql | mysql-server)
            echo "  MySQL: A dual-license story — GPL for the community, commercial for"
            echo "  enterprises. Now owned by Oracle, it sparked MariaDB as a community"
            echo "  fork to keep the spirit of open development alive."
            ;;
        vim | neovim)
            echo "  Vim: A text editor that has lasted 30+ years because its source is"
            echo "  open, its users are contributors, and no company can kill it."
            ;;
        curl | wget)
            echo "  curl/wget: Tiny tools that silently power billions of API calls daily."
            echo "  A reminder that the most impactful OSS is often invisible infrastructure."
            ;;
        *)
            # Default case for unrecognised packages
            echo "  $PKG: Every open-source tool, however small, represents someone's"
            echo "  decision to give rather than sell. That choice, multiplied by millions,"
            echo "  built the internet."
            ;;
    esac
    echo ""
}

# --- Main inspection logic ---
echo "========================================================"
echo "     FOSS PACKAGE & KERNEL MODULE INSPECTOR             "
echo "========================================================"
echo ""

# List of packages to inspect (can also pass one as argument: $1)
# If an argument is provided, inspect only that package
if [ -n "$1" ]; then
    PACKAGES=("$1")
else
    # Default list of key OSS packages related to the Linux ecosystem
    PACKAGES=("bash" "gcc" "python3" "git" "curl")
fi

# --- Loop through each package and inspect it ---
for PACKAGE in "${PACKAGES[@]}"; do
    echo "--------------------------------------------------------"
    echo "  Inspecting: $PACKAGE"
    echo "--------------------------------------------------------"

    # if-then-else: check whether the package is installed
    if check_package "$PACKAGE"; then
        echo "  Status  : INSTALLED"
        VERSION=$(get_version "$PACKAGE")
        echo "  Version : $VERSION"

        # Show extra info if rpm is available
        if command -v rpm &>/dev/null; then
            LICENSE=$(rpm -q --queryformat '%{LICENSE}' "$PACKAGE" 2>/dev/null)
            SUMMARY=$(rpm -q --queryformat '%{SUMMARY}' "$PACKAGE" 2>/dev/null)
            echo "  License : $LICENSE"
            echo "  Summary : $SUMMARY"
        fi
    else
        echo "  Status  : NOT INSTALLED"
        echo "  Tip     : Install with your distro's package manager."
    fi

    # Print philosophy note for this package
    print_philosophy "$PACKAGE"
done

# --- Also show currently loaded kernel modules ---
echo "========================================================"
echo "  CURRENTLY LOADED KERNEL MODULES (lsmod sample)"
echo "========================================================"
echo ""

# lsmod lists all currently loaded kernel modules
# awk skips the header line (NR>1) and prints only module name and size
lsmod | awk 'NR>1 {printf "  %-30s Size: %s KB\n", $1, int($2/1024)}' | head -10

echo ""
echo "  Use 'modinfo <module_name>' to inspect any module above."
echo "========================================================"
