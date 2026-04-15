# 📘 Guide d'Installation Complet

Guide détaillé pour installer et exécuter l'Application de Gestion de Santé Familiale.

## 📋 Table des Matières

1. [Prérequis Système](#prérequis-système)
2. [Installation de Java](#installation-de-java)
3. [Installation de Maven](#installation-de-maven)
4. [Installation de MySQL](#installation-de-mysql)
5. [Configuration de la Base de Données](#configuration-de-la-base-de-données)
6. [Installation du Projet](#installation-du-projet)
7. [Exécution de l'Application](#exécution-de-lapplication)
8. [Résolution des Problèmes](#résolution-des-problèmes)

---

## 🖥️ Prérequis Système

### Configuration Minimale
- **OS** : Windows 10/11, macOS 10.14+, Linux (Ubuntu 20.04+)
- **RAM** : 4 GB minimum, 8 GB recommandé
- **Espace disque** : 500 MB pour l'application + 2 GB pour les outils
- **Résolution** : 1280x720 minimum

### Logiciels Requis
- Java JDK 11 ou supérieur
- Maven 3.6+
- MySQL 8.0+ ou XAMPP
- IDE (VS Code recommandé)

---

## ☕ Installation de Java

### Windows

1. **Télécharger Java JDK**
   - Aller sur https://www.oracle.com/java/technologies/downloads/
   - Télécharger JDK 11 ou plus récent (recommandé: JDK 17)
   - Choisir la version Windows x64 Installer

2. **Installer Java**
   - Exécuter le fichier téléchargé
   - Suivre l'assistant d'installation
   - Noter le chemin d'installation (ex: `C:\Program Files\Java\jdk-17`)

3. **Configurer les Variables d'Environnement**
   ```
   # Ouvrir les Paramètres Système Avancés
   # Variables d'environnement > Variables système
   
   Nouvelle variable:
   Nom: JAVA_HOME
   Valeur: C:\Program Files\Java\jdk-17
   
   Modifier la variable PATH:
   Ajouter: %JAVA_HOME%\bin
   ```

4. **Vérifier l'installation**
   ```bash
   java -version
   javac -version
   ```

### macOS

```bash
# Installer avec Homebrew
brew install openjdk@17

# Configurer JAVA_HOME
echo 'export JAVA_HOME=$(/usr/libexec/java_home)' >> ~/.zshrc
source ~/.zshrc

# Vérifier
java -version
```

### Linux (Ubuntu/Debian)

```bash
# Installer OpenJDK
sudo apt update
sudo apt install openjdk-17-jdk

# Configurer JAVA_HOME
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
source ~/.bashrc

# Vérifier
java -version
```

---

## 🔨 Installation de Maven

### Windows

1. **Télécharger Maven**
   - Aller sur https://maven.apache.org/download.cgi
   - Télécharger `apache-maven-3.9.x-bin.zip`

2. **Installer Maven**
   - Extraire dans `C:\Program Files\Apache\maven`

3. **Configurer les Variables d'Environnement**
   ```
   Nouvelle variable:
   Nom: MAVEN_HOME
   Valeur: C:\Program Files\Apache\maven
   
   Modifier PATH:
   Ajouter: %MAVEN_HOME%\bin
   ```

4. **Vérifier**
   ```bash
   mvn -version
   ```

### macOS

```bash
# Installer avec Homebrew
brew install maven

# Vérifier
mvn -version
```

### Linux

```bash
# Installer Maven
sudo apt install maven

# Vérifier
mvn -version
```

---

## 🗄️ Installation de MySQL

### Option 1: XAMPP (Recommandé pour débutants)

1. **Télécharger XAMPP**
   - Aller sur https://www.apachefriends.org/
   - Télécharger la version pour votre OS

2. **Installer XAMPP**
   - Exécuter l'installateur
   - Sélectionner au minimum: MySQL, phpMyAdmin

3. **Démarrer MySQL**
   - Ouvrir XAMPP Control Panel
   - Cliquer sur "Start" pour MySQL
   - Vérifier que le port 3306 est libre

4. **Accéder à phpMyAdmin**
   - Ouvrir http://localhost/phpmyadmin
   - User: `root`
   - Password: (vide)

### Option 2: MySQL Standalone

#### Windows
```bash
# Télécharger depuis https://dev.mysql.com/downloads/installer/
# Exécuter MySQL Installer
# Choisir "Developer Default"
# Configurer root password
```

#### macOS
```bash
brew install mysql
brew services start mysql
mysql_secure_installation
```

#### Linux
```bash
sudo apt install mysql-server
sudo systemctl start mysql
sudo mysql_secure_installation
```

---

## 🔧 Configuration de la Base de Données

### 1. Créer la Base de Données

**Avec phpMyAdmin:**
1. Ouvrir http://localhost/phpmyadmin
2. Cliquer sur "Nouvelle base de données"
3. Nom: `gestion_sante`
4. Interclassement: `utf8mb4_unicode_ci`
5. Cliquer sur "Créer"

**Avec ligne de commande:**
```bash
mysql -u root -p

CREATE DATABASE gestion_sante CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestion_sante;
```

### 2. Importer le Script SQL

**Avec phpMyAdmin:**
1. Sélectionner la base `gestion_sante`
2. Onglet "Importer"
3. Choisir le fichier `BASE_DE_DONNÉES_COMPLÈTE.sql`
4. Cliquer sur "Exécuter"

**Avec ligne de commande:**
```bash
mysql -u root -p gestion_sante < BASE_DE_DONNÉES_COMPLÈTE.sql
```

### 3. Vérifier les Tables

```sql
USE gestion_sante;
SHOW TABLES;

-- Vous devriez voir:
-- utilisateur, famille, profil_patient, medicament, 
-- ordonnance, rendez_vous, medecin, etc.
```

### 4. Vérifier les Données de Test

```sql
SELECT * FROM utilisateur;
SELECT * FROM profil_patient;
SELECT * FROM medicament;
```

---

## 📦 Installation du Projet

### 1. Obtenir le Code Source

```bash
# Si vous avez le ZIP
unzip health-app.zip
cd health-app

# Ou cloner depuis Git (si disponible)
git clone [URL_DU_REPO]
cd health-app
```

### 2. Vérifier la Structure

```bash
health-app/
├── pom.xml
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
└── README.md
```

### 3. Configurer la Connexion BD

Ouvrir `src/main/java/sn/healthcare/app/utils/DatabaseConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/gestion_sante";
private static final String USER = "root";
private static final String PASSWORD = ""; // Votre mot de passe MySQL
```

### 4. Télécharger les Dépendances

```bash
mvn clean install
```

Cette commande va :
- Télécharger toutes les dépendances (JavaFX, MySQL Connector, iText, etc.)
- Compiler le projet
- Créer le JAR exécutable

---

## 🚀 Exécution de l'Application

### Méthode 1: Avec Maven

```bash
cd health-app
mvn javafx:run
```

### Méthode 2: Avec JAR

```bash
# Compiler
mvn clean package

# Exécuter
java -jar target/health-management-app-1.0.0.jar
```

### Méthode 3: Dans VS Code

1. Ouvrir le projet dans VS Code
2. Installer les extensions:
   - Extension Pack for Java
   - JavaFX Support
3. Appuyer sur F5 ou cliquer sur "Run"

---

## 🔍 Résolution des Problèmes

### Erreur: "Cannot connect to database"

**Solution:**
1. Vérifier que MySQL est démarré
   ```bash
   # XAMPP: Vérifier dans Control Panel
   # Standalone: 
   sudo systemctl status mysql  # Linux
   brew services list          # macOS
   ```

2. Vérifier les credentials dans `DatabaseConnection.java`
3. Tester la connexion manuellement:
   ```bash
   mysql -u root -p gestion_sante
   ```

### Erreur: "JavaFX runtime components are missing"

**Solution:**
1. Vérifier que JavaFX est dans les dépendances Maven
2. Exécuter avec les bons arguments VM:
   ```bash
   java --module-path /path/to/javafx-sdk/lib \
        --add-modules javafx.controls,javafx.fxml \
        -jar app.jar
   ```

### Erreur: "Class not found: com.mysql.cj.jdbc.Driver"

**Solution:**
```bash
# Nettoyer et recompiler
mvn clean install -U
```

### L'application se lance mais est vide

**Solution:**
1. Vérifier que Dashboard.fxml existe dans `src/main/resources/view/`
2. Vérifier les logs dans la console
3. Tester la connexion BD

### Problème de performance

**Solution:**
1. Augmenter la mémoire JVM:
   ```bash
   export MAVEN_OPTS="-Xmx1024m"
   mvn javafx:run
   ```

2. Vérifier les index de la base de données:
   ```sql
   SHOW INDEX FROM medicament;
   ```

---

## 📊 Test de l'Installation

### 1. Test de Connexion BD

```bash
# Créer un fichier TestConnection.java
javac TestConnection.java
java TestConnection
```

### 2. Test de l'Interface

1. Lancer l'application
2. Vérifier que le Dashboard s'affiche
3. Sélectionner un profil dans la liste
4. Vérifier l'affichage des médicaments et rendez-vous

### 3. Test des Fonctionnalités

- [ ] Sélection de profil fonctionne
- [ ] Médicaments s'affichent
- [ ] Rendez-vous s'affichent
- [ ] Alertes de stock apparaissent
- [ ] Navigation fonctionne

---

## 📞 Support

En cas de problème persistant:
1. Vérifier les logs dans `logs/app.log`
2. Consulter la documentation MySQL
3. Vérifier la version de Java: `java -version`
4. Vérifier Maven: `mvn -version`

---

## ✅ Checklist d'Installation

- [ ] Java JDK 11+ installé
- [ ] JAVA_HOME configuré
- [ ] Maven installé
- [ ] MySQL/XAMPP installé et démarré
- [ ] Base de données `gestion_sante` créée
- [ ] Script SQL importé
- [ ] Projet téléchargé
- [ ] Dépendances Maven téléchargées
- [ ] Application lancée avec succès

---

**Bon développement ! 🚀**
