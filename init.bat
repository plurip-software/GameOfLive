@REM Clear The Screen
cls

@REM Get Name Of Project Folder
FOR /F %%i IN ('cd') DO set NAME_FOLDER=%%~nxi

@REM Create Src Filestructure
mkdir src 
mkdir src\js 
mkdir src\css 
mkdir src\imgs 

@REM Create Default "index.html" Code
echo "<!DOCTYPE html><html lang='en'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'<title>Document</title></head><body></body></html>" > index.html