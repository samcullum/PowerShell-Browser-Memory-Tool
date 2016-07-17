# PowerShell-Browser-Memory-Tool
Windows PowerShell Browser Memory Tool

## Description 
Browser Memory is a powerful yet easy-to-use diagnostic tool that allows users to record the memory being consumed by a browser. Built using the Windows PowerShell scripting language, this tool takes advantage of a fully featured scripting utility native to Microsoft Windows meaning no additional software needs to be installed. Browser Memory is available in both a command line version (via the PowerShell command line or PowerShell Integrated Scripted Environment (ISE)) and graphical version. 

Memory leaks caused by inefficient web applications can cause client browsers to become slow or unresponsive. Identifying the cause and pinpointing the duration taken to reach this point can be a non-trivial task. Designed to provide a simple way to monitor the memory usage of a browser, this tool can help identify issues that are candidates for further in depth investigation.

Requirements:
Windows 7, 8, 8.1 or 10 and .NET 4.* framework or Microsoft charting controls for .NET 3.5.


## Running Browser Memory

**Note: For both versions of this tool, the chosen browser needs to be opened before running the tool. Only one tab can be open in the browser.**

### Command Line Version
Before the tool can be used, it needs to be added to a Windows PowerShell profile. A profile is simply a text file containing all functions and commands that a user wishes to be automatically loaded each time PowerShell is opened.

* Open the PowerShell command prompt (from the Windows start menu, search “PowerShell” then click “Windows PowerShell”) and enter the following command.
```powershell
   Test-Path $profile
```
* Carry out this step if the output from the preceding command was “false”. Enter the following command to create a profile.
```powershell
   New-Item -ItemType file -Force $profile
```
* Enter the following command to open the profile in notepad.
```powershell
   notepad $profile
```
* Copy the contents of the BrowserMemory.ps1 file and paste it into the profile file (if data already exists in the profile simply append the BrowserMemory.ps1 contents to the end of the file). Save the profile and close notepad. Restart the PowerShell command prompt for the above changes to take effect.

* Having added the tool to the PowerShell profile, a new “Record-BrowserMemory” command will be recognised. The tool will record the memory (MB), runtime (HH:MM:SS) and is responding (True/False) values for a chosen browser at specified intervals. Data is saved in a specified location in a txt, csv and a graph format.

Command line help and examples can be viewed using the command
```powershell
   Get-Help Record-BrowserMemory -Full
```
A simple example to record the memory usage of Chrome at 3 seconds intervals and output result to C:\MyTestResults
```powershell
   Record-BrowserMemory -Browser chrome -Interval 3 -ResultsPath c:\MyTestResults
```
Recording is ended by closing the browser window.

*Results
Results are saved in txt, csv and png format and can be found in a “BrowserMemory” folder in the location specified when the command was run.

txt example:

<img width="300" alt="results1" src="https://cloud.githubusercontent.com/assets/5869552/16900527/e2c0bc48-4c1e-11e6-9c4e-3f50231b5a32.png">

CSV example:

<img width="300" alt="results2" src="https://cloud.githubusercontent.com/assets/5869552/16900537/2b519202-4c1f-11e6-9fcd-7d087bf819ed.png">

png example:

<img width="337" alt="results3" src="https://cloud.githubusercontent.com/assets/5869552/16900538/2b529404-4c1f-11e6-9603-3a061d8a6a00.png">

### GUI Version 
The GUI tool will record the same data and store results as per the command line version.
To run the tool right click on the BrowserMemoryGUI.ps1 file and select “Run with PowerShell”.

Depending on the configuration of the PowerShell execution policy, an trust prompt message may appear the first time the tool is run.
Enter “y” followed by the “Enter” key to confirm that you trust the BrowserMemoryGUI.ps1 file.

The GUI will then be displayed.

<img width="300" alt="gui" src="https://cloud.githubusercontent.com/assets/5869552/16900459/feb3e166-4c1c-11e6-94b7-71e7ba5a9dba.PNG">

**Browser Selection Box**: Specify which browser will be used for memory recording. Internet Explorer, Google Chrome, Mozilla Firefox and Microsoft Edge are supported. 

**Interval Box**: The interval in seconds that data is sampled and written to result files. Minimum value is 1, maximum value is 60.

**Results Location Box**: The location in which the result files will be saved.

Tool output and progress information is shown in the lower output box. Once all three input boxes are populated click the “Start Recording” button to initiate memory recording. Invalid input values will cause the relevant fields to be highlighted and prevent recording. 

<img width="300" alt="start" src="https://cloud.githubusercontent.com/assets/5869552/16900556/80ce3b86-4c1f-11e6-9357-f8b9209b9391.PNG">

Interaction can now be carried on the chosen browser. To stop recording click the “Stop Recording” button.

<img width="300" alt="stop" src="https://cloud.githubusercontent.com/assets/5869552/16900557/80d1546a-4c1f-11e6-9f7e-6ec47535e84b.PNG">

Result files can be found in the location specified or can be displayed directly from the tool using the three display results buttons. 


