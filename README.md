# PowerShell-Browser-Memory-Tool
Windows PowerShell Browser Memory Tool

## Description 
Browser Memory is a powerful yet easy-to-use diagnostic tool that allows users to record the memory being consumed by a browser. Built using the Windows PowerShell scripting language, this tool takes advantage of a fully featured scripting utility native to Microsoft Windows meaning no additional software needs to be installed. Browser Memory is available in both a command line version (via the PowerShell command line or PowerShell Integrated Scripted Environment (ISE)) and graphical version. 

Memory leaks caused by inefficient web applications can cause client browsers to become slow or unresponsive. Identifying the cause and pinpointing the duration taken to reach this point can be a non-trivial task. Designed to provide a simple way to monitor the memory usage of a browser, this tool can help identify issues that are candidates for further in depth investigation.

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
A simple example to record the memory usage of Chrome at interval of 3 seconds and output result to c:\MyTestResults is


### GUI Version 
The GUI tool will record the same data and store results as per the command line version.
To run the tool right click on the BrowserMemoryGUI.ps1 file and select “Run with PowerShell”.

Depending on the configuration of the PowerShell execution policy, an trust prompt message may appear the first time the tool is run.
Enter “y” followed by the “Enter” key to confirm that you trust the BrowserMemoryGUI.ps1 file.

The GUI will then be displayed.
