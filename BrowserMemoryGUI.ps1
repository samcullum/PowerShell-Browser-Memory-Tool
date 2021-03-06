#title           :BrowserMemoryGUI.ps1
#description     :Record browser memory usage.
#author		     :Sam Cullum
#date            :17/07/2016
#version         :1.0   
#==============================================================================

# Store XAML for form.
$inputXML = @"
<Window x:Name="MainWindow" x:Class="WpfApplication.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Height="498.693" Width="480.119" ResizeMode="NoResize">
    <Grid Background="LightGray" Margin="0,0,-5.667,0.333">
        <Label x:Name="LabelTitle" Content="Browser Memory Tool" HorizontalAlignment="Left" Margin="169,10,0,0" VerticalAlignment="Top"
         Width="159" FontWeight="Bold" FontSize="16.2" FontFamily="Calibri">
        <Label.Effect> <DropShadowEffect Opacity="0.2"/> </Label.Effect> </Label>
        <ComboBox x:Name="ComboBrowser" HorizontalAlignment="Left" Margin="10,63,0,0" VerticalAlignment="Top" Width="443" IsEditable="True" 
         ToolTip="Select browser to use when recording memory." Text="Select browser from dropdown..." Height="25" FontFamily="Calibri"
         HorizontalContentAlignment="Center" FontSize="11.9">
            <ComboBox.Background>
                <LinearGradientBrush EndPoint="0,1" StartPoint="0,0">
                    <GradientStop Color="#FFF0F0F0" Offset="0"/>
                    <GradientStop Color="#FFE7E4E4" Offset="1"/>
                </LinearGradientBrush>
            </ComboBox.Background>
            <ComboBoxItem Content="Internet Explorer"/>
            <ComboBoxItem Content="Google Chrome"/>
            <ComboBoxItem Content="Mozilla Firefox"/>
            <ComboBoxItem Content="Microsoft Edge"/>
        </ComboBox>
        <TextBox x:Name="TbOutput" HorizontalAlignment="Left" Height="139" Margin="10,322,0,0" TextWrapping="Wrap" VerticalAlignment="Top" 
         Width="452" IsReadOnly="True" FontSize="11.9" Background="#FFE8E8E8" VerticalScrollBarVisibility="Visible"
         ScrollViewer.CanContentScroll="True" FontFamily="Calibri"/>
        <Label x:Name="LabelInterval" Content="Sample Interval (Seconds) : " HorizontalAlignment="Left" Margin="10,109,0,0"
         VerticalAlignment="Top" RenderTransformOrigin="0.143,0.008" 
         ToolTip="Enter interval (seconds) between 1-60 for memory to be sampled or leave as default."
         Height="30" FontSize="11.9" FontFamily="Calibri"/>
        <TextBox x:Name="TbInterval" HorizontalAlignment="Left" Height="26" Margin="146,109,0,0" TextWrapping="Wrap" VerticalAlignment="Top" 
         Width="307" RenderTransformOrigin="0.498,0.727" Text="3" 
         ToolTip="Enter interval (seconds) between 1-60 for data to be sampled or leave as default." 
         Background="#FFFFFCFC" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" FontSize="11.9" FontFamily="Calibri"/>
        <Label x:Name="LabelFilePath" Content="Results Location :" HorizontalAlignment="Left" Margin="10,148,0,0" VerticalAlignment="Top" 
         RenderTransformOrigin="0.143,0.008" ToolTip="Enter the location (file path) to save results or leave default." Height="30" 
         FontSize="11.9" FontFamily="Calibri"/>
        <TextBox x:Name="TbFilePath" HorizontalAlignment="Left" Height="26" Margin="102,148,0,0" TextWrapping="Wrap" VerticalAlignment="Top" 
         Width="351" RenderTransformOrigin="0.498,0.727" Text="C:\" ToolTip="Enter the location (file path) to save results or leave default.."
         Background="#FFFFFCFC" HorizontalContentAlignment="Center" VerticalContentAlignment="Center" FontSize="11.9" FontFamily="Calibri"/>
        <Button x:Name="ButtonRecord" Content="Start Recording" HorizontalAlignment="Left" Margin="102,194,0,0" VerticalAlignment="Top"
         Width="122" Height="34" Background="#FF8FE29A" ToolTip="Start recording browser memory usage. Results will be saved the specified location." 
         FontSize="11.9" FontFamily="Calibri" >
        <Button.Effect> <DropShadowEffect Opacity="0.7"/> </Button.Effect> </Button>
        <Button x:Name="ButtonStop" Content="Stop Recording" HorizontalAlignment="Left" Margin="246,194,0,0" VerticalAlignment="Top" 
         Width="120" Height="34" Background="#FFF38282" ToolTip="End browser memory recording." IsEnabled="False" FontSize="11.9" FontFamily="Calibri" >
        <Button.Effect> <DropShadowEffect Opacity="0.7"/> </Button.Effect> </Button>
        <Button x:Name="ButtonShowCSV" Content="CSV" HorizontalAlignment="Left" Margin="291,288,0,0" VerticalAlignment="Top" 
         Width="75" Background="#FF8FE29A" ToolTip="Display results (.csv format)" FontSize="11.9" IsEnabled="False" FontFamily="Calibri">
        <Button.Effect> <DropShadowEffect Opacity="0.7"/> </Button.Effect> </Button>
        <Button x:Name="ButtonShowGraph" Content="Graph" HorizontalAlignment="Left" Margin="102,288,0,0" VerticalAlignment="Top" 
         Width="75" Background="#FF8FE29A" ToolTip="Display results (graph format)" FontSize="11.9" IsEnabled="False" FontFamily="Calibri">
        <Button.Effect> <DropShadowEffect Opacity="0.7"/> </Button.Effect> </Button>
        <Button x:Name="ButtonShowTxt" Content="Text" HorizontalAlignment="Left" Margin="198,288,0,0" VerticalAlignment="Top"
         Width="75" Background="#FF8FE29A" ToolTip="Display results (.txt format)" FontSize="11.9" IsEnabled="False" FontFamily="Calibri">
        <Button.Effect> <DropShadowEffect Opacity="0.7"/> </Button.Effect> </Button>
        <Label x:Name="LabelResults" Content="Display Results" HorizontalAlignment="Left" Margin="198,260,0,0" VerticalAlignment="Top" 
         FontSize="12.5" Width="100" FontFamily="Calibri"/>
        <TextBox x:Name="TbSetbrowser" HorizontalAlignment="Left" Height="23" Margin="413,201,0,0" TextWrapping="Wrap" VerticalAlignment="Top"
         Width="40" IsEnabled="False" IsReadOnly="True" Visibility="Hidden"/>
        <TextBox x:Name="TbSetInterval" HorizontalAlignment="Left" Height="23" Margin="413,229,0,0" TextWrapping="Wrap" VerticalAlignment="Top"
         Width="40" IsEnabled="False" IsReadOnly="True" Visibility="Hidden"/>
        <TextBox x:Name="TbSetFilepath" HorizontalAlignment="Left" Height="23" Margin="413,257,0,0" TextWrapping="Wrap" VerticalAlignment="Top" 
         Width="40" IsEnabled="False" IsReadOnly="True" Visibility="Hidden"/>
    </Grid>
</Window>
"@       
 
# Replace text in XAML to use in powershell (remove properties from window declaration and remove 'x:' before control names).
$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N'  -replace '^<Win.*', '<Window'
 
# Load windows assembly. 
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')

# Cast above form code as XAML.
[xml]$XAML = $inputXML

# Create new Xml reader and load xml into powershell.
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 

try
{
   $Form=[Windows.Markup.XamlReader]::Load($reader)
}
catch
{
   Write-Host "Unable to load Xaml Reader. Check syntax and ensure .net is installed then run the script again."
}
 
# Load XAML Objects in PowerShell and prefix nmes with 'WPF'.
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}

# Bool used in input validation checks.
$Proceed = $true

# prompt if Microsoft Chart Controls are not present. System.Windows.Forms.DataVisualization cannot be loaded...
# without Chart Controls library (part of .NET 4.0 and can be added to .NET 3.5)
try
{
   # Load windows forms assembly (needed to configure line graph) 
   
   [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization") 
   $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Windows Forms assembly added.")
         
   # Set up chart frame.
   $BrowserMemoryChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
   $BrowserMemoryChart.Width = 1000
   $BrowserMemoryChart.Height = 700
   $BrowserMemoryChart.BackColor = [System.Drawing.Color]::White
 
   # Set up chart header and font details.
   $BrowserMemoryChart.Titles.Add("Browser Memory Usage") | Out-Null
   $BrowserMemoryChart.Titles[0].Font = "segoeuilight,18pt"
   $BrowserMemoryChart.Titles[0].Alignment = "TopCenter"

   # Set up a chart area and add to the frame created above.
   $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
   $ChartArea.Name = "ChartArea"
   $ChartArea.AxisY.Title = "Memory(MB)"
   $ChartArea.AxisX.Title = "Browser RunTime (HH:MM:SS)"
   $ChartArea.AxisX.MajorGrid.Enabled = $false
   $ChartArea.AxisY.MajorGrid.Enabled = $false
   $BrowserMemoryChart.ChartAreas.Add($ChartArea)

   #Set up legend to graph.
   $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
   $legend.name = "Legend"
   $BrowserMemoryChart.Legends.Add($legend)

   # Set up memory series & legend and add to chart.
   $BrowserMemoryChart.Series.Add("Memory") | Out-Null 
   $BrowserMemoryChart.Series["Memory"].BorderWidth = 3
   $BrowserMemoryChart.Series["Memory"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
   $BrowserMemoryChart.Series["Memory"].Color = "#0099FF"
   $BrowserMemoryChart.Series["Memory"].Legend = "Legend"

   # Set up known browser crash point series & legend and add to chart.
   $BrowserMemoryChart.Series.Add("Crash Point") | Out-Null 
   $BrowserMemoryChart.Series["Crash Point"].BorderWidth = 3
   $BrowserMemoryChart.Series["Crash Point"].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
   $BrowserMemoryChart.Series["Crash Point"].Color = "#FF3300"
   $BrowserMemoryChart.Series["Crash Point"].Legend = "Legend"

   $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Results form configured successfully.")
   $WPFTbOutput.ScrollToEnd()
}
catch
{
   $WPFTbOutput.AppendText("`n$(Get-Date)-ERROR:Microsoft charting controls not be found.
                Chart Controls library is part of .NET 4.0 and can be also installed for .NET 3.5.
                Ensure Chart Controls are present then try again")
   $WPFTbOutput.ScrollToEnd()
   $Proceed = $false
}

# Store timestamp and directory name for results.
$Timestamp = (Get-Date -Format s).ToString().Replace(":","-")  
$Directory = "BrowserMemory"
$TestDirectory = "DoNotDelete"
 
# Create control events to drive wpf application.
$WPFButtonRecord.Add_Click({  
   # Input validations 
   # Only run if stop button is disabled (if all input is valid, additional clicks will execute no code).
   if(!$WPFButtonStop.IsEnabled)
   {
      $WPFTbOutput.Clear()
      # Store true process name.
      if ($WPFComboBrowser.Text -eq "Internet Explorer")
        { $Browser = "iexplore" }
      if ($WPFComboBrowser.Text -eq "Google Chrome")
        { $Browser = "chrome" }
      if ($WPFComboBrowser.Text -eq "Mozilla Firefox")
        { $Browser = "firefox" }
      if ($WPFComboBrowser.Text -eq "Microsoft Edge")
        { $Browser = "MicrosoftEdgeCP" }

      if ($WPFComboBrowser.Text -eq "Internet Explorer" -or $WPFComboBrowser.Text -eq "Google Chrome" -or 
        $WPFComboBrowser.Text -eq "Mozilla Firefox" -or $WPFComboBrowser.Text -eq "Microsoft Edge" -and
        (Get-Process $Browser -ErrorAction SilentlyContinue))
      {
         $WPFComboBrowser.Foreground = "#FF000000"
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Using $($WPFComboBrowser.Text) browser.")
         $WPFTbSetbrowser.Text = $WPFComboBrowser.Text
         # Auto scoll to latest text box entry.
         $WPFTbOutput.ScrollToEnd()
      }
      else
      {
         # If not valid highlight red and display messgae.
         $WPFComboBrowser.Foreground = "#FFEB0000"
         $WPFComboBrowser.Text = "BROWSER NOT SET"           
         $WPFTbOutput.AppendText("`n$(Get-Date)-ERROR:Browser not set or is not running.")
         $WPFTbOutput.ScrollToEnd()
         $Proceed = $false
      }

      if($WPFTbInterval.Text -in 1..60)
      {
          # If not valid highlight label, textbox content and border then display messgae.
          $WPFTbInterval.BorderBrush = "#FF000000"; $WPFLabelInterval.Foreground = "#FF000000"; $WPFTbInterval.Foreground = "#FF000000"
          $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Using Interval of $($WPFTbInterval.Text) seconds.")
          $WPFTbSetInterval.Text = $WPFTbInterval.Text
          $WPFTbOutput.ScrollToEnd()
      }
      else
      {
         $WPFTbInterval.BorderBrush = "#FFEB0000"; $WPFLabelInterval.Foreground = "#FFEB0000"; $WPFTbInterval.Foreground = "#FFEB0000"
         $WPFTbOutput.AppendText("`n$(Get-Date)-ERROR:Interval must be a number between 1-60.")
         $WPFTbOutput.ScrollToEnd()
         $Proceed = $false
      }

      if ($WPFTbFilePath.Text -ne "" -and (Test-Path $WPFTbFilePath.Text))
      {
         $WPFTbFilePath.BorderBrush = "#FF000000"; $WPFLabelFilePath.Foreground = "#FF000000"; $WPFTbFilePath.Foreground = "#FF000000"
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Saving data in $($WPFTbFilePath.Text).")
         $WPFTbSetFilepath.Text = $WPFTbFilePath.Text
         $WPFTbOutput.ScrollToEnd()
      }
      else
      {
         $WPFTbFilePath.BorderBrush = "#FFEB0000"; $WPFLabelFilePath.Foreground = "#FFEB0000"; $WPFTbFilePath.Foreground = "#FFEB0000"
         $WPFTbOutput.AppendText("`n$(Get-Date)-ERROR:Results path $($WPFTbFilePath.Text) not reachable or does not exist.")
         $WPFTbOutput.ScrollToEnd()
         $Proceed = $false
      }

      # Browser memory recording code starts here
      # Only executed if all input validations have passed (if proceed variable is true).
      if ($Proceed -ne $false)
      {
         # retrieve wpf control text and store true process name.
         if ($WPFTbSetbrowser.Text -eq "Internet Explorer")
          { $Browser = "iexplore" }
         if ($WPFTbSetbrowser.Text -eq "Google Chrome")
          { $Browser = "chrome" }
         if ($WPFTbSetbrowser.Text -eq "Mozilla Firefox")
          { $Browser = "firefox" }
         if ($WPFTbSetbrowser.Text -eq "Microsoft Edge")
          { $Browser = "MicrosoftEdgeCP" }

         $Interval = $WPFTbSetInterval.Text
         $ResultsPath = $WPFTbSetFilepath.Text

         # Create results directory       
         If(-not(Test-Path -path "$ResultsPath\$Directory"))
         {
            New-Item "$ResultsPath\$Directory" -type directory | Out-Null
            New-Item "$ResultsPath\$Directory\$TestDirectory" -type directory | Out-Null
            $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Results directory created.")
            $WPFTbOutput.ScrollToEnd()
         }
         else
         {
            New-Item "$ResultsPath\$Directory\$TestDirectory" -type directory | Out-Null
         }

         # Store result file names
         $FilePathTxt = "$ResultsPath\$Directory\$($WPFTbSetbrowser.Text)-BrowserMemory-$Timestamp.txt"
         $FilePathCSV = "$ResultsPath\$Directory\$($WPFTbSetbrowser.Text)-BrowserMemory-$Timestamp.csv"  
         $TestPath = "$ResultsPath\$Directory\$TestDirectory"    
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:File names stored.")
         $WPFTbOutput.ScrollToEnd()

         # Output to wpf textbox.
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:RECORDING STARTED")
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:To stop recording press 'Stop Recording'.")
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Do not view results before recording has ended.")
         $WPFTbOutput.ScrollToEnd()

         # Output title & date header to results txt file        
         write-Output "--------##############- $Browser Memory Monitor -#############--------" | Out-File $FilePathTxt
         Get-Date | Out-File $FilePathTxt -Append
         $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Header written to results text file")
         $WPFTbOutput.ScrollToEnd()

         # Loop as background job so wpf GUI is not blocked or frozen (run in different thread).
         Start-Job  -Name RecordMemory -ScriptBlock{
            $Processes = @()
            # Append hash table values (memory, runtime and responding) to result files..
            # at the specified interval while the 'DoNotDelete' directory (deleted when stop recording button is pressed) exists.
            while ((Test-Path -path "$($args[4])") -and (Get-Process $args[0] -ErrorAction SilentlyContinue)){
               # Sort specified process and select top object to ensure the active child browser process is used.
               Get-Process -Name $args[0] -ErrorAction SilentlyContinue | Sort-Object PM -Descending | 
                  Select-Object ProcessName,@{Label="Run Time (HH:MM:SS)"; Expression={(get-date) - $_.StartTime}}, 
                  @{label="Browser Memory (MB)"; Expression={[int]($_.PrivateMemorySize/1mb)}}, 
                  @{Label="Is Responding (True/False)"; Expression={$_.Responding}} | select -First 1 | Out-File $args[1] -Append -Width 100
               Get-Process -Name $args[0] -ErrorAction SilentlyContinue | Sort-Object PM -Descending | 
                  Select-Object ProcessName,@{Label="Run Time (HH:MM:SS)"; Expression={(get-date) - $_.StartTime}},
                  @{label="Browser Memory (MB)"; Expression={[int]($_.PrivateMemorySize/1mb)}}, 
                  @{Label="Is Responding (True/False)"; Expression={$_.Responding}} | select -First 1 | Export-Csv -Path $args[2] -Append -NoTypeInformation 
               # On each iteration, add process object to the processes array (graph series data) selecting PM, RunTime and crash point attributes.
               $Process = Get-Process -Name $args[0] | Sort-Object PM -Descending | select -First 1 |
                  Select-Object PM,@{Label="Run Time (HH:MM:SS)"; Expression={(get-date) - $_.StartTime}},@{Label="Max Memory"; Expression={1200}}
               $Processes += $Process
               Start-Sleep -Seconds $args[3]
            }
            # Return processes array data when job completes.
            return $Processes
         # Pass variables from main script so they can be used in the job thread.
         } -ArgumentList $Browser, $FilePathTxt, $FilePathCSV, $Interval, $TestPath

         # Enable wpf stop button once recording has started.
         $WPFButtonStop.IsEnabled = "true"                                        
      }
   } 
})

$WPFButtonStop.Add_Click({ 
   # Only execute code on first button click.
   if (!$WPFButtonShowGraph.IsEnabled)
   {
      # Store result file name wpf control text.
      $ResultsPath = $WPFTbSetFilepath.Text
      $Browser = $WPFTbSetbrowser.Text
      $FilePathGraph = "$ResultsPath\$Directory\$Browser-BrowserMemory-$Timestamp"
      
      # Delete 'DoNotDelete' directory (causes 'RecordMemory' backgroud job to complete).
      Remove-Item "$ResultsPath\$Directory\$TestDirectory" | Out-Null

      $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:RECORDING STOPPPED")
      $WPFTbOutput.ScrollToEnd()

      # Ensure background job has finished.
      Wait-Job -Name RecordMemory

      # Receive processes array data from background job and clean up open job.
      $GraphData = Get-Job -Name RecordMemory | Receive-Job
      Remove-Job -Name RecordMemory

      # Loop through each process object  
      # Add runtime and memory attributes from each to first graph series. Add crash point indicator to second graph series.    
      $GraphData | ForEach-Object{
      $BrowserMemoryChart.Series["Memory"].Points.addxy($_.'Run Time (HH:MM:SS)'.ToString(), $_.PM/1mb)
      $BrowserMemoryChart.Series["Crash Point"].Points.AddXY($_.'Run Time (HH:MM:SS)'.ToString(), $_.'Max Memory')
      } | Out-Null
      $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Series data added to results graph.")
      $WPFTbOutput.ScrollToEnd()

      # Save graph to the specified location.
      $BrowserMemoryChart.SaveImage($FilePathGraph + ".png", "PNG")
      $WPFTbOutput.AppendText("`n$(Get-Date)-INFO:Graph results saved.")

      $WPFTbOutput.AppendText("`n`nTo make another recording...reopen this tool.")
      $WPFTbOutput.ScrollToEnd()

      # Enable show results buttons.
      $WPFButtonShowGraph.IsEnabled = "True"
      $WPFButtonShowCSV.IsEnabled = "True"
      $WPFButtonShowTxt.IsEnabled = "True"
   }
})

# Open result files on button click.
$WPFButtonShowGraph.Add_Click({ 
   $ResultsPath = $WPFTbSetFilepath.Text
   $Browser = $WPFTbSetbrowser.Text
   $FilePathGraph = "$ResultsPath\$Directory\$Browser-BrowserMemory-$Timestamp.png"
   Invoke-Item $FilePathGraph
})

$WPFButtonShowCSV.Add_Click({ 
   $ResultsPath = $WPFTbSetFilepath.Text  
   $Browser = $WPFTbSetbrowser.Text
   $FilePathCSV = "$ResultsPath\$Directory\$Browser-BrowserMemory-$Timestamp.csv"
   Invoke-Item $FilePathCSV
})

$WPFButtonShowTxt.Add_Click({ 
   $ResultsPath = $WPFTbSetFilepath.Text 
   $Browser = $WPFTbSetbrowser.Text
   $FilePathTxt = "$ResultsPath\$Directory\$Browser-BrowserMemory-$Timestamp.txt"
   Invoke-Item  $FilePathTxt
})
	
# Display form
$Form.ShowDialog() | Out-Null