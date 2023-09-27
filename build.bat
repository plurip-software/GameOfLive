@REM A Build Script For Preparing A Release Distribution

@REM Clear The Screen
cls

@REM Get Name Of Project Folder
FOR /F %%i IN ('cd') DO set NAME_FOLDER=%%~nxi

@REM Load Current Version Number From package.json
findstr /c:"version" package.json > tmpFile 
set /p VERS_KEY_VAL= < tmpFile 
del tmpFile
SET VERSION=%VERS_KEY_VAL:~14,5%

@REM Compose Versioned Folder Name  
SET VERSIONED_FOLDER=%NAME_FOLDER%-%VERSION%

@REM Create Dist Folder And The Inner Folder Struture
mkdir dist

@REM Set Variable To Path Of Versioned Folder
SET PATH_VERSIONED_FOLDER=dist\%VERSIONED_FOLDER%

@REM Create Versioned Folder + File Structure  
mkdir %PATH_VERSIONED_FOLDER%
mkdir %PATH_VERSIONED_FOLDER%\js
mkdir %PATH_VERSIONED_FOLDER%\css
mkdir %PATH_VERSIONED_FOLDER%\imgs

@REM Minify JS And Save Subsequently in Dist
CALL uglifyjs src\js\index.js --compress --mangle --output %PATH_VERSIONED_FOLDER%\js\index.min.js

@REM Minify CSS And Save Subsequently in Dist
CALL uglifycss src\css\style.css --output %PATH_VERSIONED_FOLDER%\css\style.min.css

@REM Copy Images Into Dist
xcopy /s src\imgs\ %PATH_VERSIONED_FOLDER%\imgs\ /i /d /y /e 

@REM Copy Minified JS Files Into Dist
xcopy /s src\js\ %PATH_VERSIONED_FOLDER%\js\ /i /d /y /e 

@REM Copy Minified CSS Files Into Dist
xcopy /s src\css\ %PATH_VERSIONED_FOLDER%\css\ /i /d /y /e 

@REM Copy Index File Into Dist
copy src\index.html %PATH_VERSIONED_FOLDER%\index.html /y 

@REM Delete The Source Files
del %PATH_VERSIONED_FOLDER%\css\style.css %PATH_VERSIONED_FOLDER%\js\index.js 

@REM Run Website
start brave file:///C:/Users/sinan/Documents/Projects/Programming/JavaScript/GameOfLive/index.html