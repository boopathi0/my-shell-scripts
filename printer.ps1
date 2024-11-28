# CheckPrintSpooler.ps1

# Define the service name
$serviceName = "Spooler"

# Get the service object
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

# Check if the service was found
if ($service -eq $null) {
    Write-Output "Service $serviceName not found."
} elseif ($service.Status -ne 'Running') {
    # Start the service if it is not running
    Start-Service -Name $serviceName
    Write-Output "Service $serviceName was not running and has now been started."
} else {
    Write-Output "Service $serviceName is already running."
}
