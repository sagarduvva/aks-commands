# ============================================
# Azure CLI PowerShell Script
# Delete All Resource Groups Sequentially
# With Logging
# ============================================

# Login to Azure (if not already logged in)
az login

# Optional: Set subscription (uncomment and modify if needed)
# az account set --subscription "YOUR_SUBSCRIPTION_ID"

# Create log file with timestamp
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "Azure_RG_Delete_Log_$timestamp.txt"

Write-Host "Log file: $logFile" -ForegroundColor Cyan
Add-Content -Path $logFile -Value "========== Deletion Started: $(Get-Date) =========="

Write-Host "Fetching all Resource Groups..." -ForegroundColor Cyan

# Get all resource group names
$resourceGroups = az group list --query "[].name" -o tsv

# ============================================
# OPTIONAL EXCLUSION BLOCK
# --------------------------------------------
# To exclude specific Resource Groups from deletion:
# 1. Uncomment the $excludeRGs array
# 2. Add the Resource Group names you want to protect
# ============================================

# $excludeRGs = @(
#     "Production-RG",
#     "Shared-Services-RG",
#     "DoNotDelete-RG"
# )

# If exclusion list is enabled, filter out excluded RGs
# if ($excludeRGs) {
#     $resourceGroups = $resourceGroups | Where-Object { $_ -notin $excludeRGs }
# }

Write-Host "Starting deletion process..." -ForegroundColor Yellow
Add-Content -Path $logFile -Value "Starting deletion process..."

foreach ($rg in $resourceGroups) {

    $startTime = Get-Date
    Write-Host "Deleting Resource Group: $rg" -ForegroundColor Red
    Add-Content -Path $logFile -Value "[$startTime] Deleting: $rg"

    try {
        az group delete `
            --name $rg `
            --yes `
            --no-wait false

        $successTime = Get-Date
        Write-Host "Deleted: $rg" -ForegroundColor Green
        Add-Content -Path $logFile -Value "[$successTime] SUCCESS: $rg deleted"
    }
    catch {
        $errorTime = Get-Date
        Write-Host "Failed to delete: $rg" -ForegroundColor Yellow
        Add-Content -Path $logFile -Value "[$errorTime] ERROR: Failed to delete $rg"
        Add-Content -Path $logFile -Value $_
    }
}

Add-Content -Path $logFile -Value "========== Deletion Completed: $(Get-Date) =========="
Write-Host "All Resource Groups processed." -ForegroundColor Cyan
Write-Host "Log saved to: $logFile" -ForegroundColor Cyan