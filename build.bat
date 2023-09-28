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

@REM Create Versioned Folder + File Structure  
mkdir %PATH_VERSIONED_FOLDER%
mkdir %PATH_VERSIONED_FOLDER%\imgs

@REM Copy Images Into Dist
xcopy /s src\imgs\ %PATH_VERSIONED_FOLDER%\imgs\ /i /d /y /e 

@REM Minify Index And Bundle Dependencies 
@REM Then Into Dist Folder
CALL uglifyjs src\js\imports\* src\js\index.js -c -m -o %PATH_VERSIONED_FOLDER%\index.min.js

@REM Minify CSS Then Into Dist
CALL uglifycss src\css\style.css --output %PATH_VERSIONED_FOLDER%\style.min.css

@REM Copy Index HTML File Into Dist
copy src\index.html %PATH_VERSIONED_FOLDER%\index.html /y 

@REM Run Website
start brave file:///C:/Users/sinan/Documents/Projects/Programming/JavaScript/GameOfLive/%PATH_VERSIONED_FOLDER%/index.html
