@echo off
setlocal enabledelayedexpansion

rem Save current state of the command prompt.
set "OLDPATH=%PATH%"
set "OLDCD=%CD%"

if EXIST config.cmd (
    call config.cmd
    set "PATH=!PATHRESOURCEHACKER!;!PATHLOVE!;!PATH7ZIP!;%PATH%"

    where /Q ResourceHacker.exe
    if ERRORLEVEL 1 (
        echo Failed to find ResourceHacker.exe in PATH. Please check your config.cmd
        goto EXIT
    )

    where /Q love.exe
    if ERRORLEVEL 1 (
        echo Failed to find love.exe in PATH. Please check your config.cmd
        goto EXIT
    )

    where /Q 7z.exe
    if ERRORLEVEL 1 (
        echo Failed to find 7z.exe in PATH. Please check your config.cmd
        goto EXIT
    )
) else (
    echo Failed to find config.cmd.
    goto EXIT
)

echo Cleaning up folders...
if exist "build/intermediate" ( rmdir /S /Q "build/intermediate"  )
if exist "build/" ( rmdir /S /Q "build/" )

mkdir build
mkdir build\intermediate

copy /V /Y "%PATHLOVE%\love.exe" /B "build\intermediate\"
copy /V /Y "%PATHLOVE%\love.dll" /B "build\intermediate\"
copy /V /Y "%PATHLOVE%\lua51.dll" /B "build\intermediate\"   
copy /V /Y "%PATHLOVE%\OpenAL32.dll" /B "build\intermediate\"   
copy /V /Y "%PATHLOVE%\SDL2.dll" /B "build\intermediate\"  
copy /V /Y "%PATHLOVE%\msvcr120.dll" /B "build\intermediate\"  
copy /V /Y "%PATHLOVE%\msvcp120.dll" /B "build\intermediate\"  
copy /V /Y "%PATHLOVE%\mpg123.dll" /B "build\intermediate\"  

copy /V /Y "add_icon.txt" /B "build\intermediate\"  
copy /V /Y "src\icon.ico" /B "build\intermediate\"  
copy /V /Y "add_versioninfo.txt" /B "build\intermediate\"  
copy /V /Y "manifest.xml" /B "build\intermediate\"  
copy /V /Y "add_manifest.txt" /B "build\intermediate\"  

call generate_versioninfo.bat

cd src
7z.exe a ..\build\intermediate\build.zip *

cd ..
cd build
cd intermediate
move build.zip build.love
echo Copy
copy /b love.exe + build.love cs2_sound_converter.exe

ResourceHacker.exe -script add_icon.txt
del cs2_sound_converter.exe
move cs2_sound_converter_icon.exe cs2_sound_converter.exe

7z.exe a "cs2_sound_converter.7z" cs2_sound_converter.exe love.dll lua51.dll OpenAL32.dll SDL2.dll msvcr120.dll msvcp120.dll mpg123.dll

copy /V /Y "%PATH7ZIP%\7zS2.sfx" /B 7zS2.sfx
copy /V /Y "..\..\config.txt" /V config.txt

copy /b 7zS2.sfx + config.txt + cs2_sound_converter.7z "cs2_sound_converter.exe"

ResourceHacker.exe -open VersionInfo1.rc -save VersionInfo1.res -action compile -log CONSOLE
ResourceHacker.exe -script add_versioninfo.txt

del cs2_sound_converter.exe
move cs2_sound_converter_version.exe cs2_sound_converter.exe
ResourceHacker.exe -script add_icon.txt

del cs2_sound_converter.exe
move cs2_sound_converter_icon.exe cs2_sound_converter.exe
ResourceHacker.exe -script add_manifest.txt

move cs2_sound_converter_manifest.exe "..\cs2_sound_converter.exe"

:EXIT
rem Load old state of the command prompt.
set "PATH=%OLDPATH%"
cd %OLDCD%

exit /B