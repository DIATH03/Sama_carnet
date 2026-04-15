# Changelog

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/fr/1.0.0/),
et ce projet adhère au [Semantic Versioning](https://semver.org/lang/fr/).

## [1.0.0] - 2026-01-28

### ✨ Ajouté

#### Architecture
- Architecture MVC complète et professionnelle
- Pattern DAO pour l'accès aux données
- Connexion singleton à la base de données MySQL
- Système de logging avec SLF4J

#### Modèles de Données
- Classe `Utilisateur` pour les comptes principaux
- Classe `ProfilPatient` pour les membres de la famille
- Classe `Medicament` pour les traitements médicamenteux
- Classe `Ordonnance` pour les prescriptions
- Classe `RendezVous` pour les consultations
- Classe `Medecin` pour les praticiens
- Calcul automatique de l'IMC pour les patients
- Gestion des groupes sanguins et rhésus

#### Accès aux Données (DAO)
- `ProfilPatientDAO` : CRUD complet sur les profils
- `MedicamentDAO` : Gestion des médicaments et alertes de stock
- `RendezVousDAO` : Gestion des rendez-vous médicaux
- Requêtes optimisées avec index
- Support des transactions

#### Interface Utilisateur
- Dashboard principal avec vue d'ensemble
- Sélection de profil patient
- Affichage des médicaments du jour en tableau
- Liste des prochains rendez-vous
- Cartes statistiques (nombre de médicaments, prochain RDV, alertes)
- Zone d'alertes dynamique
- Navigation latérale moderne
- Design responsive et professionnel
- Fichier CSS personnalisé

#### Services Métier
- `RappelService` : Système de rappels automatiques
  - Vérification périodique (toutes les 5 minutes)
  - Notifications JavaFX natives
  - Multithreading avec Timer Java
  - Rappels personnalisables par médicament
  
- `PDFExportService` : Export de documents PDF
  - Carnet de santé complet
  - Liste des médicaments
  - Historique des rendez-vous
  - Mise en page professionnelle avec iText
  - En-têtes et pieds de page personnalisés

#### Base de Données
- Script SQL complet avec 14 tables
- Données de test intégrées
- Triggers pour calculs automatiques (IMC, numéro ordonnance)
- Vues SQL pour requêtes fréquentes
- Procédures stockées pour opérations complexes
- Index pour optimisation des performances

#### Documentation
- README.md complet avec instructions
- GUIDE_INSTALLATION.md détaillé
- PRESENTATION_PROJET.md avec contexte et architecture
- REQUETES_UTILES.sql avec exemples de requêtes
- Commentaires JavaDoc dans le code

#### Scripts d'Exécution
- `run.bat` pour Windows
- `run.sh` pour Linux/macOS
- Configuration Maven complète
- Support JavaFX intégré

#### Outils de Développement
- Configuration Maven avec toutes les dépendances
- .gitignore pour ignorer les fichiers générés
- Structure de projet standardisée
- Support VS Code, IntelliJ IDEA, Eclipse

### 🎨 Design
- Palette de couleurs moderne et cohérente
- Interface épurée et professionnelle
- Icônes Unicode pour simplicité
- Cartes de statistiques colorées
- Tableaux avec alternance de lignes
- Boutons de navigation stylisés
- Effets hover et transitions

### 🔧 Technique
- Java 11+ compatible
- JavaFX 17.0.2
- MySQL 8.0+ support
- Maven build automation
- iText 5.5.13.3 pour PDF
- Gestion des exceptions complète
- Logging structuré

### 🔒 Sécurité
- Prepared Statements pour prévenir les injections SQL
- Validation des données utilisateur
- Gestion sécurisée des connexions BD
- Isolation des données par famille

### 📦 Dépendances
- org.openjfx:javafx-controls:17.0.2
- org.openjfx:javafx-fxml:17.0.2
- mysql:mysql-connector-java:8.0.33
- com.itextpdf:itextpdf:5.5.13.3
- org.apache.commons:commons-lang3:3.12.0
- org.slf4j:slf4j-api:2.0.7
- org.slf4j:slf4j-simple:2.0.7

## [Prochaines versions]

### 🔮 Prévu pour v1.1.0
- Interface de gestion des profils
- Interface de gestion des médicaments
- Interface de gestion des rendez-vous
- Journal médical quotidien
- Graphiques de suivi
- Export Excel

### 🌟 Prévu pour v1.2.0
- Authentification par mot de passe
- Gestion des utilisateurs multiples
- Permissions et rôles
- Backup automatique de la base
- Import/Export de données

### 🚀 Prévu pour v2.0.0
- Version mobile (Android/iOS)
- Synchronisation cloud
- API REST
- Notifications push
- Mode hors ligne

### 💡 Idées Futures
- Intelligence artificielle pour détection d'interactions
- OCR pour ordonnances
- Intégration pharmacies
- Télémédecine
- Wearables integration

---

## Légende

- ✨ Ajouté : Nouvelles fonctionnalités
- 🔧 Modifié : Changements dans des fonctionnalités existantes
- 🐛 Corrigé : Corrections de bugs
- 🔒 Sécurité : Correctifs de sécurité
- ⚡ Performance : Améliorations de performance
- 📚 Documentation : Modifications de documentation
- 🎨 Style : Changements n'affectant pas la logique
- ♻️ Refactoring : Restructuration du code
- 🗑️ Supprimé : Fonctionnalités retirées
