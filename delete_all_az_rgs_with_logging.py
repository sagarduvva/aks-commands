import subprocess
import datetime
import sys

# ============================================
# Azure Resource Group Deletion Script
# Sequential deletion with logging
# ============================================

# Create timestamped log file
timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
log_file = f"Azure_RG_Delete_Log_{timestamp}.txt"

def log(message):
    time_now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{time_now}] {message}"
    print(line)
    with open(log_file, "a") as f:
        f.write(line + "\n")

log("========== Deletion Started ==========")

# Optional: Login (uncomment if needed)
# subprocess.run(["az", "login"], check=True)

# Optional: Set subscription (uncomment and modify if needed)
# subprocess.run(["az", "account", "set", "--subscription", "YOUR_SUBSCRIPTION_ID"], check=True)

try:
    log("Fetching all Resource Groups...")

    result = subprocess.run(
        ["az", "group", "list", "--query", "[].name", "-o", "tsv"],
        capture_output=True,
        text=True,
        check=True
    )

    resource_groups = result.stdout.strip().split("\n")

except subprocess.CalledProcessError as e:
    log(f"ERROR fetching resource groups: {e.stderr}")
    sys.exit(1)

# ============================================
# OPTIONAL EXCLUSION BLOCK
# --------------------------------------------
# To exclude specific Resource Groups from deletion:
# 1. Uncomment the exclude_rgs list
# 2. Add the Resource Group names to protect
# ============================================

# exclude_rgs = [
#     "Production-RG",
#     "Shared-Services-RG",
#     "DoNotDelete-RG"
# ]

# if 'exclude_rgs' in locals():
#     resource_groups = [rg for rg in resource_groups if rg not in exclude_rgs]

log("Starting deletion process...")

for rg in resource_groups:
    if not rg.strip():
        continue

    log(f"Deleting Resource Group: {rg}")

    try:
        subprocess.run(
            ["az", "group", "delete", "--name", rg, "--yes", "--no-wait", "false"],
            check=True
        )
        log(f"SUCCESS: {rg} deleted")

    except subprocess.CalledProcessError as e:
        log(f"ERROR: Failed to delete {rg}")
        log(e.stderr)

log("========== Deletion Completed ==========")
print(f"\nLog saved to: {log_file}")