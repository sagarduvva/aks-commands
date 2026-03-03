# ============================================
# Azure CLI PowerShell Script
# Delete All Resource Groups Sequentially
# ============================================

# Login to Azure (if not already logged in)
# az login

# Optional: Set subscription (uncomment and modify if needed)
# az account set --subscription "YOUR_SUBSCRIPTION_ID"

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

foreach ($rg in $resourceGroups) {

    Write-Host "Deleting Resource Group: $rg" -ForegroundColor Red

    # Delete resource group and wait until completion
    az group delete `
        --name $rg `
        --yes `
        --no-wait false

    Write-Host "Deleted: $rg" -ForegroundColor Green
}

Write-Host "All Resource Groups processed." -ForegroundColor Cyan