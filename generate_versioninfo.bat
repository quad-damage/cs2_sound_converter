@echo off

set "PRODUCT_MAJOR_VERSION=1"
set "PRODUCT_MINOR_VERSION=0"

echo: > "build\intermediate\VersionInfo1.rc"
echo 1 VERSIONINFO >> "build\intermediate\VersionInfo1.rc"
echo FILEVERSION %PRODUCT_MAJOR_VERSION%,%PRODUCT_MINOR_VERSION%,0,0 >> "build\intermediate\VersionInfo1.rc"
echo PRODUCTVERSION %PRODUCT_MAJOR_VERSION%,%PRODUCT_MINOR_VERSION%,0,0 >> "build\intermediate\VersionInfo1.rc"
echo FILEOS 0x40004 >> "build\intermediate\VersionInfo1.rc"
echo FILETYPE 0x1 >> "build\intermediate\VersionInfo1.rc"
echo { >> "build\intermediate\VersionInfo1.rc"
echo BLOCK "StringFileInfo"  >> "build\intermediate\VersionInfo1.rc"
echo {  >> "build\intermediate\VersionInfo1.rc"
echo 	BLOCK "040904b0"  >> "build\intermediate\VersionInfo1.rc"
echo 	{  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "FileDescription", "Sound converter utility for Counter-Strike 2."  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "FileVersion", "%PRODUCT_MAJOR_VERSION%.%PRODUCT_MINOR_VERSION%"  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "InternalName", "cs2_sound_converter.exe"  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "LegalCopyright", "Quadruple Damage : Public domain"  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "OriginalFilename", "cs2_sound_converter.exe"  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "ProductName", "Counter-Strike 2 Sound Converter"  >> "build\intermediate\VersionInfo1.rc"
echo 		VALUE "ProductVersion", "%PRODUCT_MAJOR_VERSION%.%PRODUCT_MINOR_VERSION%"  >> "build\intermediate\VersionInfo1.rc"
echo 	}  >> "build\intermediate\VersionInfo1.rc"
echo }  >> "build\intermediate\VersionInfo1.rc"
echo:  >> "build\intermediate\VersionInfo1.rc"
echo BLOCK "VarFileInfo"  >> "build\intermediate\VersionInfo1.rc"
echo {  >> "build\intermediate\VersionInfo1.rc"
echo 	VALUE "Translation", 0x0409 0x04B0    >> "build\intermediate\VersionInfo1.rc"
echo }  >> "build\intermediate\VersionInfo1.rc"
echo }  >> "build\intermediate\VersionInfo1.rc"
echo:  >> "build\intermediate\VersionInfo1.rc"
echo:  >> "build\intermediate\VersionInfo1.rc"