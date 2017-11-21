### INFO
# Prints PDF files that are scanned to a watched directory using Sumatra (www.sumatrapdfreader.org/free-pdf-reader.html)

### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\Path\To\Watched\Folder\"
    $watcher.Filter = "*.pdf"
    $watcher.IncludeSubdirectories = $false
    $watcher.EnableRaisingEvents = $true  

### SETUP
$scandir = "C:\Path\To\Watched\Folder\"
$scanbackdir = "C:\Path\To\Backup\Folder\" 
$sumatra="C:\Program Files\SumatraPDF\SumatraPDF.exe"  # change this to wherever you have installed SumatraPDF
$pdftoprint=""
$printername= "YourPrinter'sName" # Check in the Sumatra GUI that it uses the same printer name as in the 'Select Printer' section 

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $changeType = $Event.SourceEventArgs.ChangeType
                $logline = "$(Get-Date), $changeType, $path"
                Add-content "C:\Path\To\Your\Log\log.txt" -value $logline
                Get-ChildItem -Path $scandir -filter "*.pdf"| % {
                    $curfile = $_ 
                    & $sumatra -silent -print-to $printername1 $scandir\$curfile
                    sleep 2 # Increase Sleep if slow to print otherwise PDF will be removed before it has time to print
                    # Move PDF - Will overwrite if same file name exists in the backup directory 
                    Move-Item -force $scandir\$curfile $scanbackdir
                }
              } 

### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
#    Register-ObjectEvent $watcher "Changed" -Action $action
#    Register-ObjectEvent $watcher "Deleted" -Action $action
#    Register-ObjectEvent $watcher "Renamed" -Action $action
    while ($true) {sleep 5}
