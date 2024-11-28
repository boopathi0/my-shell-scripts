# Variables
$tenableURL = "https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/24578/download?i_agree_to_tenable_license_agreement=true"
$tempFilePath = "C:\Temp\TenableAgent.msi"
$serviceName = "Tenable Nessus Agent"

# Ensure Temp Directory Exists
if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}

# Check if Tenable Nessus Agent is installed
$serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($null -eq $serviceStatus) {
    Write-Host "Tenable Nessus Agent not found. Downloading and installing..."

    # Download Tenable Agent Installer
    Write-Host "Downloading Tenable Agent from $tenableURL..."
    Invoke-WebRequest -Uri $tenableURL -OutFile $tempFilePath -UseBasicParsing
	    # Install the Tenable Agent
    Write-Host "Installing Tenable Agent..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $tempFilePath /qn" -Wait

    # Start the service after installation
    Start-Service -Name $serviceName

    # Verify installation
    $serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($null -ne $serviceStatus -and $serviceStatus.Status -eq "Running") {
        Write-Host "Tenable Nessus Agent installed and running successfully."
    } else {
        Write-Host "Installation failed or service is not running."
    }
} else {
    Write-Host "Tenable Nessus Agent is already installed and the service is $($serviceStatus.Status)."
}

# Clean up the installer file
if (Test-Path $tempFilePath) {
    Remove-Item $tempFilePath -Force
    Write-Host "Cleaned up installer file."
	cd 'C:\Program Files\Tenable\Nessus Agent\'
	# Add or update the registry key
	$regPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Tenable"
	$regValueName = "TAG"
	$regValueData = ""

# Command to force overwrite
	Start-Process -FilePath "REG" -ArgumentList "ADD `"$regPath`" /t REG_SZ /v $regValueName /d `"$regValueData`" /f" -NoNewWindow -Wait

	Write-Host "Registry key added or updated successfully."
	./nessuscli.exe agent link --cloud --groups=Fujitsu --key=33e71c4052f8e3fd9b0007a47c2507941eabd7e085ac4f1d0a47c4ffaa6fc859 --proxy-host=185.46.212.88 --proxy-port=80
	./nessuscli.exe agent status
	}