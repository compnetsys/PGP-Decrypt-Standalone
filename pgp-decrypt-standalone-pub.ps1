#PGP DISK DECRYPTION - POWERSHELL
# MELVIN - COMPNETSYS
# LOGGING CURRENLTY TURNED OFF


$PASSLIST=() # LIST OF PASSWORDS GO HERE E.G ('PASSW0RD1','PASSWORD2')
$GETPASS={$PASSLIST}.Invoke()


$logname = $env:COMPUTERNAME
$logname = $logname+"_Decrypt.txt"
$logdir = $env:TMP
$logdir = $logdir
$logfile = $logdir+"\"+$logname
if(Test-Path -Path $logfile){Remove-Item -Path $logfile}
$pass = " "


$pgpwde = "C:\Program Files (x86)\PGP Corporation\PGP Desktop\pgpwde.exe"
set-alias pgpwde "$pgpwde"

clear
Write-Host "`tPLEASE WAIT .. ATTEMPTING TO START WHOLE DISK DE-CRYPTION ON..........=> $env:COMPUTERNAME `r`r`r`n"

$pcount =0 

foreach($pass in $GETPASS)
{

$pcount++
Write-Host "`tTRYING WITH PASSWORD #:$PCOUNT"
start-sleep 2

          $dodecryp = (pgpwde --decrypt --passphrase $pass --disk 0 --all-partitions) | Out-String
          $dodecrypS = (pgpwde --status) | Out-String

          #CHECK IF DISK IS ENCRYPTED OR NOT
          $CHECKSTATUSS = ($dodecryp | Select-String "not instrumented" -SimpleMatch  ) 
          if($CHECKSTATUSS)
          {
                 $DSTATUS = "`tTHIS DISK IS NOT ENCRYPTED`r`r`n"
                 
                 Write-Host "$DSTATUS" -ForegroundColor "GREEN" 
                 Start-Sleep 5
                 $pass = "YES"
                 Break
                 
                 }
          
          #CHECK IF PASSWORDS FAILED
          $CHECKSTATUSF = ($dodecryp | Select-String "bad" -SimpleMatch  ) 
          if($CHECKSTATUSF)
          {
                 $DSTATUS = "`tDISK COULD NOT BE DE-CRYPTED WITH THIS PASSWORD"
                 
                 Write-Host "$DSTATUS" -ForegroundColor "RED" 
                 }

        #CHECK IF ENCRYPTION HAS STARTED.
        $CHECKSTATUSP = ($dodecryp | Select-String "ba4d" -SimpleMatch  ) 
          if($CHECKSTATUSP)
          {
                 $DSTATUS = "`tDISK DE-CRYPTION STARTED WITH THIS PASSWORD"
                 
                 Write-Host "$DSTATUS`r`r`n" -ForegroundColor "GREEN" 
                 Start-Sleep 5
                 $pass = "YES"
                 pgpwde --status
                 break

                 }      
          
 
    }
    if(!($pass -eq "YES"))
    {
     WRITE-HOST "`r`r`n`tNONE OF THE PASSWORDS WORKED TO DECRYPT THIS DISK`r`n`tPLEASE NOTE THIS COMPUTER NAME: $env:COMPUTERNAME AND SCHEDULE TO GET IT RE-IMAGED" -ForegroundColor Red
     }
