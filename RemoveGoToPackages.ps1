#lists running processes beginning with g, stops known GoToMeeting processes

# Get all processes starting with "g"
$GProcesses = Get-Process -Name "g*"

# Check if any processes are found
if ($GProcesses) {
    # Output the running processes starting with "g"
    Write-Host "These are the running processes starting with 'g':"
    $GProcesses | Format-Table -AutoSize Name, Id

    # Stop specific processes if they are running
    $ProcessesToStop = @("g2mcomm", "g2mlauncher", "g2mstart")
    foreach ($processName in $ProcessesToStop) {
        $ProcessToStop = $GProcesses | Where-Object { $_.Name -eq $processName }
        if ($ProcessToStop) {
            Stop-Process -Name $processName -ErrorAction SilentlyContinue
            Write-Host "Stopped process: $processName"
        } else {
            Write-Host "Process '$processName' is not running."
        }
    }
} else {
    # No processes starting with "g" are found
    Write-Host "There are no processes starting with 'g'."
}


# Check if any processes are returned
if ($GProcesses) {
    # Processes found, do something with them
    foreach ($process in $processes) {
        Write-Host "Process ID: $($process.ProcessId)"
        Write-Host "Process Name: $($process.Name)"
    }
} else {
    # No processes found
    Write-Host "There are no processes found."
}

# Get a list of installed programs
$installedPrograms = Get-WmiObject -Class Win32_Product | Select-Object -Property Name

# Get GoTo Opener package
$gotoopenerPackage = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "GoTo Opener" }

# Get GoToMeeting package
$gotomeetingPackage = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -Like "GoToMeeting*" }

# Create a variable to store existing programs
$ExistingPrograms = @()

# Check if GoTo packages are found
if ($gotoopenerPackage -or $gotomeetingPackage) {
    # Output list of installed programs
    Write-Host "List of installed programs:"
    $installedPrograms

    # Output list of GoTo packages
    Write-Host "List of GoTo packages:"
    if ($gotomeetingPackage) { $ExistingPrograms += $gotomeetingPackage.Name }
    if ($gotoopenerPackage) { $ExistingPrograms += $gotoopenerPackage.Name }

    # Uninstall GoTo programs if found
    if ($gotomeetingPackage) { $gotomeetingPackage.Uninstall() }
    if ($gotoopenerPackage) { $gotoopenerPackage.Uninstall() }

    # Check programs again for anything beginning with GoTo
    $existingGoToPackages = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "GoTo*" }

    # Output existing GoTo packages or success result
    if ($existingGoToPackages) {
        Write-Host "Existing GoTo packages still installed:"
        $existingGoToPackages | Select-Object -ExpandProperty Name
    } else {
        Write-Host "All GoTo packages successfully uninstalled."
    }
} else {
    # No GoTo packages found
    Write-Host "There are no GoTo packages installed."
}
