@echo off

:netini
echo ==============================================================================
echo Initialising Network Adapter ...
net initialize
if not errorlevel 1 goto netpro
echo ******************************************************************************
echo FAILED TO INITIALISE ADAPTER!           
echo ******************************************************************************
goto done

:netpro
echo.
echo.
echo ==============================================================================
echo Establishing Network Protocol ...
device dis_pkt.dos
netbind.com
do aipa
umb
tcptsr
tinyrfc
nmtsr
emsbfr
if not errorlevel 1 goto netsta
:tcperr
echo ******************************************************************************
echo COULD NOT ESTABLISH NETWORK PROTOCOL!   
echo ******************************************************************************
goto done

:netsta
echo.
echo.
echo ==============================================================================
echo Starting Network ...
net start
goto netlog
if not errorlevel 1 goto netlog
echo ******************************************************************************
echo COULD NOT START NETWORK! 
echo ******************************************************************************
goto done

:netlog
echo.
echo.
echo ==============================================================================
echo Logging on to Network ...
net logon imager imagerpw /savepw:no
if not errorlevel 1 goto netcon
echo ******************************************************************************
echo COULD NOT LOGON TO NETWORK!
echo ******************************************************************************
goto done

:netcon
echo.
echo.
echo ==============================================================================
echo Connecting to Network Image Share ...
net use n: \\image\images /savepw:no
if not errorlevel 1 goto main
echo ******************************************************************************
echo COULD NOT CONNECT TO NETWORK IMAGE SHARE!
echo ******************************************************************************
goto done

:main
main.bat

:done