Function Record-BrowserMemory
{
<#
.SYNOPSIS
Records Browser Memory usage.
.DESCRIPTION
!!Ensure only one tab is open on the browser being used!!.
Memory (MB), runtime (HH:MM:SS) and is responding (True/False) values are gathered from a browser process (iexplore or chrome) at specified intervals.
Data is saved to both a txt and csv file in the specified location. A graph (png) is also generated and saved in the specified location. 
Use the Verbose switch to see additional output.
.PARAMETER Browser
Specifies which browser will be used for memory recording (mandatory).
Internet Explorer (iexplore), Google Chrome (chrome), Mozilla Firefox (firefox) and Microsoft Edge (edge) are supported. 
.PARAMETER Interval
The interval in seconds that data is sampled and written to result files (not mandatory). Min = 1, Max = 60. Default: 5.
.PARAMETER ResultsPath
The location in which the result text and csv files will be stored (mandatory).
.EXAMPLE
Record-Browser -Browser iexplore -Interval 3 -ResultsPath c:\TestFolder 
.EXAMPLE
Record-Browser -Browser chrome -Interval 3 -ResultsPath c:\TestFolder -Verbose
.EXAMPLE
Record-Browser -Browser iexplore -ResultsPath c:\TestFolder 
#>

# cmdletbinding attribute added to enable verbose messaging and additional parameter checking.
[cmdletbinding()]

# Declare parameters and add validation decorators.
param (
   [ValidateSet("iexplore","chrome","firefox","edge")]
   [ValidateScript({
      # Custom error if input does not match a value in the parameter set
      if ($_ -eq "iexplore" -or $_ -eq "chrome" -or $_ -eq "firefox" -or $_ -eq "edge"){
         $True
      }
      else{
         Throw "$_ is not a supported browser. Please try the command again using 'iexplore', 'chrome', 'firefox' or 'edge'."
      }
   })]
   # prompt user for value if not provided
   [string[]]$Browser = $(throw "The Browser parameter is required ('iexplore', 'chrome', 'firefox or 'edge'). Please try the command again"), 
  
   [ValidateRange(1,60)]
   [int]$Interval = 5,

   [parameter(Mandatory = $true)]
   [ValidateNotNullOrEmpty()]
   [ValidateScript({
      # Custom error message if file path cannot be reached
      if (Test-Path $_){
         $True
      }
      else{
         Throw "The file path $_ is not reachable or does not exist. Please check the file path and then try the command again." 
      }
    })]
    [string]$ResultsPath 
)

# Stop script if error occurs
$ErrorActionPreference = "Stop" 

# Modify browser name to true process name if edge is chosen by user
$BrowserProc = $Browser
if ($BrowserProc -eq "edge") 
{
   $BrowserProc = "MicrosoftEdgeCP"
}

# Check the specified bowser is running, if not then display message and do not continue script.
$BrowserCheck = Get-Process $BrowserProc -ErrorAction SilentlyContinue
if ($BrowserCheck -eq $null) 
{
   Throw "The $Browser browser is not running. Ensure the chosen browser is running then try the command again."
}

Write-Verbose "Using browser: $Browser"
Write-Verbose "Using interval: $Interval (seconds)"
Write-Verbose "Results location: $ResultsPath"

# Output to console
Write-Host "######---->Browser Memory Monitor<----######" -ForegroundColor Green 

# Create results directory
Write-Verbose "Creating results directory"
If(-not(Test-Path -path "$ResultsPath\BrowserMemory"))
{
   New-Item "$ResultsPath\BrowserMemory" -type directory | Out-Null
}
else
{
   Write-Verbose "'BrowserMemory' directory already exists in the specified location, using existing directory for results."
}

$ResultsPath = "$ResultsPath\BrowserMemory"

# Store result file names and declare array for process graph data.
Write-Verbose "Storing results file names"
$Timestamp = (Get-Date -Format s).ToString().Replace(":","-")  
$ResultFile1="\$Browser-BrowserMemory-$Timestamp.txt" 
$ResultFile2="\$Browser-BrowserMemory-$Timestamp.csv"
$ResultFile3="\$Browser-BrowserMemory-$Timestamp.png"
$Processes = @()
Write-Verbose "File names stored"

# Create custom hash tables (process memory converted to MB, process runtime and process responding boolean) for result output.
Write-Verbose "Creating hash table values"
$MemoryMB=@{label="Browser Memory (MB)"; Expression={[int]($_.PrivateMemorySize/1mb)}} 
# Subtract process start time from current date to get uptime. 
$RunTime=@{Label="Run Time (HH:MM:SS)"; Expression={(get-date) - $_.StartTime}} 
$Responding=@{Label="Is Responding (True/False)"; Expression={$_.Responding}}
# Set up value for known crash point indicator. 
$MaxMemory = @{Label="Max Memory"; Expression={1200}}
Write-Verbose "Hash table values created and stored"

# Exit script if Microsoft Chart Controls are not present. 
# System.Windows.Forms.DataVisualization cannot be loaded without Chart Controls library 
#(part of .NET 4.0 and can be added to .NET 3.5)
try
{
   # Load windows forms assembly (needed to configure line graph) 
   write-Verbose "Adding Windows Forms assembly"
   [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization") 
}
catch 
{
   Write-Host "Microsoft charting controls could not be found.`nThe Chart Controls library is part of .NET 4.0, but it can be also installed for .NET 3.5.`nEnsure Chart Controls are present then try the command again"
}

Write-Verbose "Windows Forms assembly added"


Write-Verbose "Configuring results graph"
# Set up chart frame.
$BrowserMemoryChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
$BrowserMemoryChart.Width = 1000
$BrowserMemoryChart.Height = 700
$BrowserMemoryChart.BackColor = [System.Drawing.Color]::White
 
# Set up chart header and font details.
$BrowserMemoryChart.Titles.Add("$Browser Memory Usage") | Out-Null
$BrowserMemoryChart.Titles[0].Font = "segoeuilight,18pt"
$BrowserMemoryChart.Titles[0].Alignment = "TopCenter"

# Set up a chart area and add to the frame created above.
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$ChartArea.Name = "ChartArea"
$ChartArea.AxisY.Title = "Memory(MB)"
$ChartArea.AxisX.Title = "$Browser RunTime (HH:MM:SS)"
$ChartArea.AxisX.MajorGrid.Enabled = $false
$ChartArea.AxisY.MajorGrid.Enabled = $false
$BrowserMemoryChart.ChartAreas.Add($ChartArea)

#Set up legend to graph.
$legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
$legend.name = "Legend"
$BrowserMemoryChart.Legends.Add($legend)

# Set up memory series & legend and add to chart.
$BrowserMemoryChart.Series.Add("$Browser Memory") | Out-Null 
$BrowserMemoryChart.Series["$Browser Memory"].BorderWidth = 3
$BrowserMemoryChart.Series["$Browser Memory"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$BrowserMemoryChart.Series["$Browser Memory"].Color = "#0099FF"
$BrowserMemoryChart.Series["$Browser Memory"].Legend = "Legend"

# Set up known browser crash point series & legend and add to chart.
$BrowserMemoryChart.Series.Add("Crash Point") | Out-Null 
$BrowserMemoryChart.Series["Crash Point"].BorderWidth = 3
$BrowserMemoryChart.Series["Crash Point"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$BrowserMemoryChart.Series["Crash Point"].Color = "#FF3300"
$BrowserMemoryChart.Series["Crash Point"].Legend = "Legend"

Write-Verbose "Graph configured successfully"

# Output to console.
Write-Host "`nRECORDING STARTED...results will be saved to the specified location.`nTo stop recording close the $Browser window.`nDo not view results before recording has ended." -ForegroundColor Green

# Output title & date header to results txt file
Write-Verbose "Writing header to results text file"
write-Output "--------##############- $Browser Memory Monitor -#############--------" | Out-File $ResultsPath$ResultFile1
Get-Date | Out-File $ResultsPath$ResultFile1 -Append

# Append hash table values (memory, runtime and responding) to text and csv files at the specified interval while the browser process is running.
while (Get-Process $BrowserProc -ErrorAction SilentlyContinue){
   Write-Verbose "Writing $Browser data to txt & csv result files"
   # Sort specified process and select top object to ensure the active child browser process is used.
   Get-Process -Name $BrowserProc -ErrorAction SilentlyContinue | Sort-Object PM -Descending | 
      Select-Object ProcessName,$RunTime,$MemoryMB,$Responding | select -First 1 | 
	  Out-File $ResultsPath$ResultFile1 -Append -Width 100
   Get-Process -Name $BrowserProc -ErrorAction SilentlyContinue | Sort-Object PM -Descending | 
      Select-Object ProcessName,$RunTime,$MemoryMB,$Responding | select -First 1 | 
	  Export-Csv -Path $ResultsPath$ResultFile2 -Append -NoTypeInformation 
   # On each iteration, add process object to the processes array (graph series data). 
   # Selecting the PM and $RunTime and crash point indicator attributes.
   $Process = Get-Process -Name $BrowserProc | Sort-Object PM -Descending | select -First 1 | Select-Object PM,$RunTime,$MaxMemory
   $Processes += $Process
   Start-Sleep -Seconds $Interval 
} 

Write-Verbose "Txt & csv result files complete"

# Loop through each process object 
# Add runtime and memory attributes from each to first graph series.
# Add crash point indicator to second graph series.
Write-Verbose "Adding graph series data"
$Processes | ForEach-Object {
   $BrowserMemoryChart.Series["$Browser Memory"].Points.addxy($_.'Run Time (HH:MM:SS)'.ToString(), $_.PM/1mb)
   $BrowserMemoryChart.Series["Crash Point"].Points.AddXY($_.'Run Time (HH:MM:SS)'.ToString(), $_.'Max Memory')
} | Out-Null

# Save graph to the specified location.
Write-Verbose "Saving graph png results"
$BrowserMemoryChart.SaveImage("$ResultsPath$ResultFile3", "PNG")
Write-Verbose "Results graph saved"

Write-Host "`nRecording Complete" -ForegroundColor Green

}
