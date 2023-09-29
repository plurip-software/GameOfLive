@REM A Build Script For Preparing A Release Distribution

@REM Clear The Screen
cls

@REM Extract Project Name And Version From 'package.json' 
for /f "tokens=2 delims=:, " %%a in ('findstr /C:"name" "package.json"') do set "NAME=%%~a"
for /f "tokens=2 delims=:, " %%a in ('findstr /C:"version" "package.json"') do set "VERSION=%%~a"

@REM Compose Versioned Folder Name  
SET VERSIONED_FOLDER=%NAME%-%VERSION%

@REM Create Dist Folder And The Inner Folder Struture
mkdir dist

@REM Set Variable To Path Of Versioned Folder
SET PATH_VERSIONED_FOLDER=dist\%VERSIONED_FOLDER%

cd %PATH_VERSIONED_FOLDER%

@REM Create Versioned Folder + File Structure  
mkdir imgs

@REM Copy Images Into Dist
xcopy /s ..\src\imgs\ imgs\ /i /d /y /e 

@REM Minify Index And Bundle Dependencies 
@REM Then Into Dist Folder
CALL uglifyjs ..\src\js\imports\* ..\src\js\index.js -c -m -o index.min.js

@REM Minify CSS Then Into Dist
CALL uglifycss ..\src\css\style.css --output style.min.css

@REM Copy Index HTML File Into Dist
copy ..\..\index.html index.html /y 

@REM Run Website
start brave index.html
