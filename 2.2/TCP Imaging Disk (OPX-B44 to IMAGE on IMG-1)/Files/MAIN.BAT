@echo off
cls
echo ==============================================================================
echo LIFESAVER 2.00 - TCP/IP IMAGING DISK (OPX-B44 to IMAGE ON IMG-1) 
echo ==============================================================================
echo.
echo Please hit a key to select one of the following options:
echo.
echo N = NORMAL (Recommended)
echo     Only disk sectors containing data are placed in image file meaning faster
echo     imaging/restore operations and smaller image files. 
echo.
echo S = SECTOR-BY-SECTOR
echo     All sectors are placed in the image file meaning slower imaging/restore
echo     operations and very large image files. Use this if NORMAL mode fails
echo.
echo X = QUIT
echo.
echo ==============================================================================
echo Copyright (c) RVJ Callanan & Associates 2007
echo ==============================================================================
choice /c:nsx /n
cls
if errorlevel 3 Goto Quit
if errorlevel 2 Goto Sect
if errorlevel 1 Goto Norm

:Norm
set GHOSTMODE=NORM
goto Start

:Sect
set GHOSTMODE=SECT
goto Start

:Quit
echo ******************************************************************************
echo OPERATION CANCELLED BY USER!
echo ******************************************************************************
Goto Done

:Start
echo ==============================================================================
echo Copying Ghost files ...
if not exist n:\opx\ghost.exe goto nogf
if not exist n:\opx\ghost.env goto nogf
copy n:\opx\ghost.exe r:\ /y
copy n:\opx\ghost.env r:\ /y
goto gfok
:nogf
echo ******************************************************************************
echo GHOST FILE(S) MISSING IN IMAGE DIRECTORY!
echo ******************************************************************************
goto done
:gfok

:imgchk
echo ============================================================
echo Checking for existing image files ...
echo.
echo.
if not exist n:\opx\*.gho goto imfok
echo ************************************************************
echo IMAGE FILE ALREADY EXISTS!
echo ************************************************************
goto done
:imfok
echo The command completed successfully
echo.
echo.

:image
echo ============================================================
echo Imaging disk to network ...
if %GHOSTMODE%==SECT goto sectghost

:normghost
Ghost -clone,mode=dump,src=1,dst=n:\opx\d1000000.gho -batch -fni -fdsp -ial -ib -z -split=638 -autoname
if not errorlevel 1 goto imgok
goto imgfail

:sectghost
Ghost -clone,mode=dump,src=1,dst=n:\opx\d1000000.gho -batch -fni -fdsp -ia -ib -z -split=638 -autoname
if not errorlevel 1 goto imgok
goto imgfail

:imgfail
echo ************************************************************
echo IMAGING PROCESS FAILED!
echo ************************************************************
goto done

:imgok
echo The command completed successfully

:verimg
echo ============================================================
echo Verifying image file ...
Ghost -chkimg,n:\opx\d1000000.gho -autoname -batch
echo.
echo.
if not errorlevel 1 goto verok
echo ************************************************************
echo IMAGE VERIFIFICATION FAILED!
echo ************************************************************
goto done
:verok
echo The command completed successfully

:success
cls
echo ************************************************************
echo This computer has been imaged successfully!
echo ************************************************************
goto done

:Done
echo.
echo.                                                      
echo Please remove all disks and switch off or restart computer!
exit