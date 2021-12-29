@echo off

flutter.bat pub get
where flutter.bat > temp
set /p flutter_dir= < temp
set /p flutter_dir="%flutter_dir%"

echo "done"
echo.
pause