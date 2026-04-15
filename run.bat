@echo off
echo ========================================
echo   Application Gestion Sante Familiale
echo ========================================
echo.

REM Vérifier Java
echo Verification de Java...
java -version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Java n'est pas installe ou pas dans le PATH
    echo Veuillez installer Java JDK 11 ou superieur
    pause
    exit /b 1
)
echo [OK] Java detecte

REM Vérifier Maven
echo Verification de Maven...
mvn -version >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Maven n'est pas installe ou pas dans le PATH
    echo Veuillez installer Apache Maven
    pause
    exit /b 1
)
echo [OK] Maven detecte

echo.
echo Lancement de l'application...
echo.

REM Lancer l'application avec Maven
mvn javafx:run

echo.
echo Application terminee.
pause
