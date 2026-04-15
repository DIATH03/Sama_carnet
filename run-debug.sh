#!/bin/bash

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================"
echo "  Application Santé Familiale - v2.0"
echo "========================================"
echo ""

# Fonction pour afficher les erreurs
error_exit() {
    echo -e "${RED}[ERREUR]${NC} $1"
    exit 1
}

# Fonction pour afficher les succès
success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

# Fonction pour afficher les avertissements
warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

# 1. Vérifier Java
echo "1. Vérification de Java..."
if ! command -v java &> /dev/null; then
    error_exit "Java n'est pas installé. Installez Java JDK 11 ou supérieur."
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
if [ "$JAVA_VERSION" -lt 11 ]; then
    error_exit "Java 11 ou supérieur est requis. Version actuelle: $JAVA_VERSION"
fi
success "Java $(java -version 2>&1 | head -n 1)"

# 2. Vérifier Maven
echo "2. Vérification de Maven..."
if ! command -v mvn &> /dev/null; then
    error_exit "Maven n'est pas installé. Installez Apache Maven."
fi
success "Maven $(mvn -version | head -n 1 | cut -d' ' -f3)"

# 3. Vérifier MySQL
echo "3. Vérification de MySQL..."
if ! command -v mysql &> /dev/null; then
    warning "MySQL CLI n'est pas trouvé. Assurez-vous que MySQL est installé et démarré."
else
    success "MySQL trouvé"
fi

# 4. Vérifier la base de données
echo "4. Vérification de la base de données..."
if command -v mysql &> /dev/null; then
    echo "   Voulez-vous vérifier si la base 'carnet_de_sante' existe? (y/n)"
    read -r check_db
    if [ "$check_db" = "y" ]; then
        echo "   Entrez le mot de passe root MySQL:"
        mysql -u root -p -e "USE carnet_de_sante; SELECT 'Base de données OK' AS status;" 2>/dev/null
        if [ $? -eq 0 ]; then
            success "Base de données 'carnet_de_sante' trouvée"
        else
            warning "Base de données non trouvée ou erreur de connexion"
            echo "   Créer la base maintenant? (y/n)"
            read -r create_db
            if [ "$create_db" = "y" ]; then
                if [ -f "carnet_de_sante.sql" ]; then
                    echo "   Entrez le mot de passe root MySQL:"
                    mysql -u root -p < carnet_de_sante.sql
                    if [ $? -eq 0 ]; then
                        success "Base de données créée avec succès"
                    else
                        error_exit "Erreur lors de la création de la base"
                    fi
                else
                    error_exit "Fichier carnet_de_sante.sql non trouvé"
                fi
            fi
        fi
    fi
fi

# 5. Nettoyer et compiler
echo ""
echo "5. Compilation de l'application..."
echo "   Cela peut prendre quelques minutes lors de la première exécution..."
mvn clean compile

if [ $? -ne 0 ]; then
    error_exit "Erreur lors de la compilation. Consultez les messages ci-dessus."
fi
success "Compilation réussie"

# 6. Lancer l'application
echo ""
echo "6. Lancement de l'application..."
echo "========================================"
echo ""

mvn javafx:run

EXIT_CODE=$?

echo ""
echo "========================================"
if [ $EXIT_CODE -eq 0 ]; then
    success "Application terminée normalement"
else
    error_exit "L'application s'est terminée avec une erreur (code: $EXIT_CODE)"
fi
