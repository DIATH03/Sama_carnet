#!/bin/bash

echo "========================================"
echo "  Application Gestion Santé Familiale"
echo "========================================"
echo ""

# Vérifier Java
echo "Vérification de Java..."
if ! command -v java &> /dev/null; then
    echo "ERREUR: Java n'est pas installé ou pas dans le PATH"
    echo "Veuillez installer Java JDK 11 ou supérieur"
    exit 1
fi
echo "[OK] Java détecté: $(java -version 2>&1 | head -n 1)"

# Vérifier Maven
echo "Vérification de Maven..."
if ! command -v mvn &> /dev/null; then
    echo "ERREUR: Maven n'est pas installé ou pas dans le PATH"
    echo "Veuillez installer Apache Maven"
    exit 1
fi
echo "[OK] Maven détecté: $(mvn -version | head -n 1)"

echo ""
echo "Lancement de l'application..."
echo ""

# Lancer l'application avec Maven
mvn javafx:run

echo ""
echo "Application terminée."
