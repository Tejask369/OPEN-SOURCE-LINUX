# OPEN-SOURCE-LINUX
# OSS Audit — Linux Kernel
### Open Source Software Capstone Project

---

| Field | Details |
|---|---|
| **Student Name** | TEJAS KUMAR |
| **Roll Number** | 24BAS10025 |
| **Course** | Open Source Software (OSS NGMC) |
| **Chosen Software** | Linux Kernel |
| **License** | GPL v2 |
| **Repository** | `oss-audit-[rollnumber]` |

---

## About This Project

This repository is a complete OSS audit of the **Linux Kernel** — the open-source operating system kernel first released by Linus Torvalds in 1991. The project covers the kernel's origin story, GPL v2 license analysis, ethical reflections, Linux filesystem footprint, ecosystem mapping, and a comparison with proprietary alternatives.

The repository contains five shell scripts that demonstrate practical Linux skills and connect directly to the audit report's findings.

---

## Repository Structure

```
oss-audit-[rollnumber]/
│
├── README.md                        ← This file
├── script1_system_identity.sh       ← System Identity Report
├── script2_module_inspector.sh      ← FOSS Package & Module Inspector
├── script3_proc_auditor.sh          ← /proc Filesystem & Disk Auditor
├── script4_dmesg_analyzer.sh        ← Kernel dmesg Log Analyzer
└── script5_manifesto_gen.sh         ← Open Source Manifesto Generator
```

> **Note:** The project report PDF is submitted separately on the VITyarthi portal.

---

## Shell Scripts — Description & Usage

### Script 1: System Identity Report
**File:** `script1_system_identity.sh`

Displays a welcome screen with complete system information including Linux distribution, kernel version, current user, home directory, uptime, date/time, and a note about the GPL v2 license that covers the OS. Also shows the top 5 loaded kernel modules.

**Concepts used:** Variables, `echo`, command substitution `$()`, `/etc/os-release`, `uname`, `uptime`, `lsmod`, `awk`

**Run:**
```bash
chmod +x script1_system_identity.sh
./script1_system_identity.sh
```

---

### Script 2: FOSS Package & Kernel Module Inspector
**File:** `script2_module_inspector.sh`

Checks whether key OSS packages (bash, gcc, python3, git, curl) are installed on the system, displays their version and license, and uses a `case` statement to print a philosophy note for each. Also lists currently loaded kernel modules using `lsmod`.

**Concepts used:** `if-then-else`, `case` statement, `rpm -q` / `dpkg -l`, `lsmod`, `modinfo`, pipe with `grep`, functions

**Run:**
```bash
chmod +x script2_module_inspector.sh

# Inspect default package list:
./script2_module_inspector.sh

# Inspect a specific package:
./script2_module_inspector.sh git
```

---

### Script 3: /proc Filesystem & Disk Permission Auditor
**File:** `script3_proc_auditor.sh`

Loops through a list of important system directories and reports permissions, owner, and disk usage for each. Then reads live kernel data directly from `/proc` (cpuinfo, meminfo, uptime, loadavg, filesystems). Finally audits the kernel's own footprint — `/boot`, `/lib/modules`, `/proc/sys/kernel`.

**Concepts used:** `for` loop, arrays, `ls -ld`, `du -sh`, `awk`, `cut`, `/proc` virtual filesystem, `if-d` directory check

**Run:**
```bash
chmod +x script3_proc_auditor.sh
./script3_proc_auditor.sh
```

---

### Script 4: Kernel dmesg Log Analyzer
**File:** `script4_dmesg_analyzer.sh`

Reads the kernel ring buffer (`dmesg`) or a supplied log file line by line using a `while read` loop. Counts occurrences of a keyword (default: `error`) and also counts warnings, errors, and critical messages separately. Prints a summary and displays the last 10 matching lines. Includes a retry loop for empty files.

**Concepts used:** `while IFS= read -r` loop, `if-then`, counter variables, command-line arguments `$1` and `$2`, `dmesg`, `grep -i`, `tail`, `wc -l`, `mktemp`

**Run:**
```bash
chmod +x script4_dmesg_analyzer.sh

# Analyze live dmesg (default keyword: error):
./script4_dmesg_analyzer.sh

# Analyze a specific log file:
./script4_dmesg_analyzer.sh /var/log/syslog

# Analyze with a custom keyword:
./script4_dmesg_analyzer.sh /var/log/syslog warning
```

---

### Script 5: Open Source Manifesto Generator
**File:** `script5_manifesto_gen.sh`

Interactively asks the user five questions about open source, then composes a personalised philosophy statement using their answers and saves it to a `.txt` file named `manifesto_<username>.txt`. The manifesto paragraph adapts based on the user's answer about corporate profit from OSS.

**Concepts used:** `read` for interactive input, string concatenation, file writing with `>` and `>>`, `date` command, `if-then-elif-else`, `cat`, alias concept (demonstrated via comment)

**Run:**
```bash
chmod +x script5_manifesto_gen.sh
./script5_manifesto_gen.sh
```
Answer the five prompts. Your manifesto is saved to `manifesto_<yourusername>.txt` in the current directory.

---

## Dependencies

All scripts use standard Linux utilities available on any modern Linux distribution. No external packages need to be installed.

| Utility | Purpose | Available on |
|---|---|---|
| `bash` | Shell interpreter | All Linux distros |
| `uname` | Kernel version info | All Linux distros |
| `lsmod` | List loaded kernel modules | All Linux distros |
| `dmesg` | Kernel ring buffer | All Linux distros |
| `awk` | Text field extraction | All Linux distros |
| `grep` | Pattern matching | All Linux distros |
| `du`, `df` | Disk usage | All Linux distros |
| `rpm` | Package info (RPM-based) | Fedora, RHEL, CentOS |
| `dpkg` | Package info (DEB-based) | Ubuntu, Debian |

> Scripts 1–4 require no elevated privileges. Script 4 may need `sudo` to read full `dmesg` output on some systems: `sudo ./script4_dmesg_analyzer.sh`

---

## Running All Scripts at Once

```bash
# Make all scripts executable
chmod +x *.sh

# Run all five in sequence
./script1_system_identity.sh
./script2_module_inspector.sh
./script3_proc_auditor.sh
./script4_dmesg_analyzer.sh
./script5_manifesto_gen.sh
```

---

## Report Structure (Submitted Separately as PDF)

| Part | Section | Coverage |
|---|---|---|
| A1 | Origin Story | Linux Kernel 1991 history, Torvalds' motivation |
| A2 | License Analysis | GPL v2 — four freedoms, copyleft vs MIT |
| A3 | Ethical Reflection | Corporate profit on OSS, Red Hat paradox |
| B | Linux Footprint | `/proc`, `/boot`, `/lib/modules`, kernel install |
| C | FOSS Ecosystem | GCC, glibc, systemd, LAMP, kernel.org community |
| D | OSS vs Proprietary | Linux Kernel vs Windows Server |

---

## Academic Integrity Note

All shell scripts in this repository are original work. The scripts were written, tested, and documented by the student. All written sections in the report are in the student's own words. Use of AI tools was limited to concept clarification only — no AI-generated text appears in the report.

---

## License

This project submission is for academic purposes under VIT's OSS NGMC course. The Linux Kernel itself is licensed under [GPL v2](https://www.kernel.org/pub/linux/kernel/COPYING).

---

*Last updated: [Date of Submission]*
