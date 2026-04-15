# 🏥 Application Santé Familiale - VERSION COMPLÈTE

## ✅ PRÊT À L'EMPLOI - Aucune modification nécessaire !

Cette archive contient une application **100% fonctionnelle** avec TOUS les formulaires déjà intégrés.

---

## 🚀 INSTALLATION EN 3 ÉTAPES

### Étape 1 : Extraire
```bash
unzip APPLICATION-SANTE-FAMILIALE-COMPLETE.zip
cd health-app
```

### Étape 2 : Base de données
```bash
mysql -u root -p < carnet_de_sante.sql
mysql -u root -p < insertion_profils_test.sql
mysql -u root -p < nettoyage_doublons.sql
```

### Étape 3 : Lancer
```bash
mvn clean compile javafx:run
```

---

## ✨ FONCTIONNALITÉS

✅ **Dashboard** - 4 cartes interactives  
✅ **Médicaments** - Ajout/Modification/Arrêt  
✅ **Rendez-vous** - Planification/Modification/Annulation  
✅ **Profils** - Création/Modification/Suppression  
✅ **Symptômes** - Suivi quotidien  

---

## 🎯 DONNÉES DE TEST

- **7 profils patients** (famille Diallo)
- **3 médicaments** en cours
- **3 rendez-vous** programmés
- **3 symptômes** récents

---

## 🔧 Configuration (optionnel)

Si mot de passe MySQL non vide :
```java
// src/main/java/sn/healthcare/app/utils/DatabaseConnection.java
// Ligne 21
private static final String PASSWORD = "votre_mot_de_passe";
```

---

**Version** : 1.0 Complète  
**Status** : ✅ PRODUCTION READY
