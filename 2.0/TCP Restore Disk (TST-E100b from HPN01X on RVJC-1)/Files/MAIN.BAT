@echo off
cls
echo ==============================================================================
echo LIFESAVER 2.00 - TCP/IP RESTORE DISK (TST-E100B from HPN01X ON RVJC-1) 
echo ==============================================================================
echo.
echo Please hit a key to select one of the following options:
echo.
echo S = SAFE RESTORE (Recommended)
echo     Verifies image before restoring computer. If any part of
echo     image is corrupt, the restore operation will NOT proceed.
echo.
echo F = FAST RESTORE (Not Recommended)
echo     Restores computer without first verifying image. A bad
echo     image will leave your computer in an unusable state.
echo.
echo V = VERIFY ONLY (Check new image)
echo     Verifies image without restoring computer. This will
echo     NOT affect your computer in any way.
echo.
echo X = QUIT
echo.
echo ==============================================================================
echo Copyright (c) RVJ Callanan & Associates 2007
echo ==============================================================================
choice /c:sfvx /n
cls
if errorlevel 4 Goto Quit
if errorlevel 3 Goto Verify
if errorlevel 2 Goto Fast
if errorlevel 1 Goto Safe

:Safe
echo About to start a SAFE RESTORE operation.
echo.
echo Warning! This will overwrite hard drive contents.
echo If a corrupt image is detected, the restore operation
echo will NOT proceed and your hard drive contents will
echo NOT be affected in any way.
echo.
echo Please ensure network image is available!
echo Press C to continue (or X to abort)
choice /c:cx /n
cls
if errorlevel 2 Goto Quit
echo ==============================================================================
echo Copying Ghost files ...
if not exist n:\tst\ghost.exe goto snogf
if not exist n:\tst\ghost.env goto snogf
copy n:\tst\ghost.exe r:\ /y
copy n:\tst\ghost.env r:\ /y
goto sgfok
:snogf
echo ******************************************************************************
echo GHOST FILE(S) MISSING IN IMAGE DIRECTORY!
echo ******************************************************************************
goto done
:sgfok
echo ==============================================================================
echo Searching for first image file ...
echo.
echo.
if exist n:\tst\d1000000.gho goto simfok
echo ******************************************************************************
echo COULD NOT FIND IMAGE FILE!
echo ******************************************************************************
goto Done
:simfok
echo The command completed successfully
echo.
echo.
echo ==============================================================================
echo Checking image file(s) ...
ghost -chkimg,n:\tst\d1000000.gho -autoname -batch
echo.
echo.
if not errorlevel 1 goto schkok
echo ******************************************************************************
echo RESTORE CHECK FAILED - IMAGE MAY BE DAMAGED!
echo ******************************************************************************
goto Done
:schkok
echo The command completed successfully
echo.
echo.
echo ==============================================================================
cls
echo Your CD(s) verified okay, about to start restore proper.
echo.
echo Please ensure network image is available!
echo Press C to continue (or X to abort)
choice /c:cx /n
cls
if errorlevel 2 Goto Quit
echo ==============================================================================
echo Restoring Computer ...
ghost -clone,mode=load,src=n:\tst\d1000000.gho,dst=1,szeE -autoname -batch -ial -ib -nolilo
echo.
echo.
if not errorlevel 1 goto srstok
echo ******************************************************************************
echo RESTORE FAILED!
echo ******************************************************************************
goto Done
:srstok
echo The command completed successfully
echo.
echo ==============================================================================
echo YOUR COMPUTER WAS RESTORED SUCCESSFULLY!  
echo ==============================================================================
goto Done


:Fast
echo About to start a FAST RESTORE operation.
echo.
echo Warning! This will overwrite hard drive contents.
echo A corrupt image will probably leave your computer in an
echo unusable state. If you are unsure about the state of
echo your image, choose the SAFE RESTORE option!
echo.
echo Please ensure network image is available!
echo Press C to continue (or X to abort)
choice /c:cx /n
cls
if errorlevel 2 Goto Quit
echo ==============================================================================
echo Copying Ghost files ...
if not exist n:\tst\ghost.exe goto fnogf
if not exist n:\tst\ghost.env goto fnogf
copy n:\tst\ghost.exe r:\ /y
copy n:\tst\ghost.env r:\ /y
goto fgfok
:fnogf
echo ******************************************************************************
echo GHOST FILE(S) MISSING IN IMAGE DIRECTORY!
echo ******************************************************************************
goto done
:fgfok
echo ==============================================================================
echo Searching for first image file ...
echo.
echo.
if exist n:\tst\d1000000.gho goto fimfok
echo ******************************************************************************
echo COULD NOT FIND IMAGE FILE!
echo ******************************************************************************
goto Done
:fimfok
echo The command completed successfully
echo.
echo.
echo ==============================================================================
echo Restoring Computer ...
Ghost -clone,mode=load,src=n:\tst\d1000000.gho,dst=1,szeE -autoname -batch -ial -ib -nolilo
echo.
echo.
if not errorlevel 1 goto frstok
echo ******************************************************************************
echo RESTORE FAILED!
echo ******************************************************************************
goto Done
:frstok
echo The command completed successfully
echo.
echo ==============================================================================
echo YOUR COMPUTER WAS RESTORED SUCCESSFULLY!  
echo ==============================================================================
goto Done


:Verify
echo About to start a VERIFY ONLY operation.
echo.
echo This test ensures that your network image is valid.
echo It will NOT affect your hard drive contents in any way.
echo.
echo Please ensure network image is available!
echo Press C to continue (or X to abort)
choice /c:cx /n
cls
if errorlevel 2 Goto Quit
echo ==============================================================================
echo Copying Ghost files ...
if not exist n:\tst\ghost.exe goto vnogf
if not exist n:\tst\ghost.env goto vnogf
copy n:\tst\ghost.exe r:\ /y
copy n:\tst\ghost.env r:\ /y
goto vgfok
:vnogf
echo ******************************************************************************
echo GHOST FILE(S) MISSING IN IMAGE DIRECTORY!
echo ******************************************************************************
goto done
:vgfok
echo ==============================================================================
echo Searching for first image file ...
echo.
echo.
if exist n:\tst\d1000000.gho goto vimfok
echo ******************************************************************************
echo COULD NOT FIND IMAGE FILE!
echo ******************************************************************************
goto Done
:vimfok
echo The command completed successfully
echo.
echo.
echo ==============================================================================
echo Checking image file(s) ...
Ghost -chkimg,n:\tst\d1000000.gho -autoname -batch
echo.
echo.
if not errorlevel 1 goto vchkok
echo ******************************************************************************
echo RESTORE CHECK FAILED - IMAGE MAY BE DAMAGED!
echo ******************************************************************************
goto Done
:vchkok
echo The command completed successfully
echo.
echo ==============================================================================
echo YOUR NETWORK IMAGE CHECKED OUT OKAY!  
echo ==============================================================================
goto Done

:Quit
echo ******************************************************************************
echo OPERATION CANCELLED BY USER!
echo ******************************************************************************
Goto Done

:Done
echo.
echo.                                                      
echo Please remove all disks and switch off or restart computer!
exit