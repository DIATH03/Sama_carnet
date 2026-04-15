-- ============================================
-- SCRIPT DE CRÉATION DE LA BASE DE DONNÉES
-- Nom: carnet_de_sante
-- Application: Gestion de Santé Familiale
-- Date: 2026
-- ============================================

-- Suppression et création de la base de données
DROP DATABASE IF EXISTS carnet_de_sante;
CREATE DATABASE carnet_de_sante CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE carnet_de_sante;

-- ============================================
-- TABLE: utilisateur
-- Gestion des utilisateurs de l'application
-- ============================================
CREATE TABLE utilisateur (
    id_utilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    telephone VARCHAR(20),
    mot_de_passe VARCHAR(255) NOT NULL,
    role ENUM('admin', 'utilisateur', 'medecin') DEFAULT 'utilisateur',
    est_actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    derniere_connexion TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: profil_patient
-- Profils des membres de la famille
-- ============================================
CREATE TABLE profil_patient (
    id_profil INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    sexe ENUM('M', 'F', 'Autre') NOT NULL,
    groupe_sanguin VARCHAR(10),
    numero_securite_sociale VARCHAR(50),
    telephone VARCHAR(20),
    email VARCHAR(255),
    adresse TEXT,
    ville VARCHAR(100),
    code_postal VARCHAR(10),
    pays VARCHAR(100) DEFAULT 'Sénégal',
    medecin_traitant_id INT,
    photo_profil VARCHAR(255),
    notes_medicales TEXT,
    est_actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE,
    INDEX idx_utilisateur (id_utilisateur),
    INDEX idx_nom_prenom (nom, prenom),
    INDEX idx_date_naissance (date_naissance)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: medecin
-- Médecins et professionnels de santé
-- ============================================
CREATE TABLE medecin (
    id_medecin INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    specialite VARCHAR(100),
    numero_ordre VARCHAR(50),
    telephone VARCHAR(20),
    email VARCHAR(255),
    adresse_cabinet TEXT,
    ville VARCHAR(100),
    code_postal VARCHAR(10),
    horaires_consultation TEXT,
    accepte_carte_vitale BOOLEAN DEFAULT TRUE,
    notes TEXT,
    est_actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_specialite (specialite),
    INDEX idx_nom_prenom (nom, prenom)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: medicament
-- Gestion des médicaments
-- ============================================
CREATE TABLE medicament (
    id_medicament INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    nom_commercial VARCHAR(200) NOT NULL,
    denomination_commune_internationale VARCHAR(200),
    dosage VARCHAR(100),
    forme_pharmaceutique VARCHAR(100),
    numero_amm VARCHAR(50),
    posologie TEXT,
    dose_par_prise VARCHAR(100),
    nombre_prises_par_jour INT,
    heures_prise VARCHAR(255),
    moment_prise VARCHAR(255),
    duree_traitement INT,
    date_debut DATE,
    date_fin DATE,
    est_traitement_chronique BOOLEAN DEFAULT FALSE,
    quantite_totale INT,
    quantite_restante INT,
    seuil_alerte INT DEFAULT 5,
    instructions_particulieres TEXT,
    contre_indications TEXT,
    effets_secondaires TEXT,
    interactions_medicamenteuses TEXT,
    conditionnement VARCHAR(100),
    laboratoire VARCHAR(200),
    prix_unitaire DECIMAL(10,2),
    taux_remboursement DECIMAL(5,2),
    statut ENUM('actif', 'termine', 'suspendu', 'archive') DEFAULT 'actif',
    raison_arret TEXT,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_statut (statut),
    INDEX idx_date_debut (date_debut),
    INDEX idx_date_fin (date_fin),
    INDEX idx_nom_commercial (nom_commercial)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: prise_medicament
-- Historique des prises de médicaments
-- ============================================
CREATE TABLE prise_medicament (
    id_prise INT AUTO_INCREMENT PRIMARY KEY,
    id_medicament INT NOT NULL,
    date_heure_prevue DATETIME NOT NULL,
    date_heure_reelle DATETIME,
    statut ENUM('prevue', 'prise', 'oubliee', 'reportee') DEFAULT 'prevue',
    notes TEXT,
    rappel_envoye BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament) ON DELETE CASCADE,
    INDEX idx_medicament (id_medicament),
    INDEX idx_date_prevue (date_heure_prevue),
    INDEX idx_statut (statut)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: ordonnance
-- Ordonnances médicales
-- ============================================
CREATE TABLE ordonnance (
    id_ordonnance INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    id_medecin INT,
    numero_ordonnance VARCHAR(100) UNIQUE,
    date_prescription DATE NOT NULL,
    date_expiration DATE,
    diagnostic TEXT,
    instructions TEXT,
    duree_validite INT DEFAULT 365,
    statut ENUM('active', 'expiree', 'annulee') DEFAULT 'active',
    fichier_scan VARCHAR(255),
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES medecin(id_medecin) ON DELETE SET NULL,
    INDEX idx_profil (id_profil),
    INDEX idx_medecin (id_medecin),
    INDEX idx_date_prescription (date_prescription),
    INDEX idx_statut (statut)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: medicament_ordonnance
-- Liaison entre médicaments et ordonnances
-- ============================================
CREATE TABLE medicament_ordonnance (
    id_medicament_ordonnance INT AUTO_INCREMENT PRIMARY KEY,
    id_ordonnance INT NOT NULL,
    id_medicament INT NOT NULL,
    date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_ordonnance) REFERENCES ordonnance(id_ordonnance) ON DELETE CASCADE,
    FOREIGN KEY (id_medicament) REFERENCES medicament(id_medicament) ON DELETE CASCADE,
    UNIQUE KEY unique_medicament_ordonnance (id_ordonnance, id_medicament),
    INDEX idx_ordonnance (id_ordonnance),
    INDEX idx_medicament (id_medicament)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: rendez_vous
-- Gestion des rendez-vous médicaux
-- ============================================
CREATE TABLE rendez_vous (
    id_rendez_vous INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    id_medecin INT,
    date_rendez_vous DATE NOT NULL,
    heure_rendez_vous TIME NOT NULL,
    motif TEXT NOT NULL,
    type_consultation ENUM('premiere_consultation', 'suivi', 'urgence', 'bilan', 'autre') DEFAULT 'suivi',
    lieu_rendez_vous VARCHAR(255),
    statut ENUM('planifie', 'confirme', 'termine', 'annule', 'reporte') DEFAULT 'planifie',
    duree_estimee INT DEFAULT 30,
    notes_avant_rdv TEXT,
    diagnostic_pose TEXT,
    prescriptions TEXT,
    examens_demandes TEXT,
    notes_apres_rdv TEXT,
    date_prochain_rdv DATE,
    rappel_envoye BOOLEAN DEFAULT FALSE,
    date_rappel DATETIME,
    cout DECIMAL(10,2),
    est_rembourse BOOLEAN DEFAULT FALSE,
    fichiers_joints TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES medecin(id_medecin) ON DELETE SET NULL,
    INDEX idx_profil (id_profil),
    INDEX idx_medecin (id_medecin),
    INDEX idx_date (date_rendez_vous),
    INDEX idx_statut (statut)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: allergie
-- Allergies des patients
-- ============================================
CREATE TABLE allergie (
    id_allergie INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    type_allergie ENUM('medicamenteuse', 'alimentaire', 'environnementale', 'autre') NOT NULL,
    nom_allergie VARCHAR(200) NOT NULL,
    severite ENUM('legere', 'moderee', 'severe', 'critique') NOT NULL,
    symptomes TEXT,
    traitement_urgence TEXT,
    date_detection DATE,
    est_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_type (type_allergie),
    INDEX idx_severite (severite)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: antecedent_medical
-- Antécédents médicaux
-- ============================================
CREATE TABLE antecedent_medical (
    id_antecedent INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    type_antecedent ENUM('maladie', 'chirurgie', 'hospitalisation', 'familial', 'autre') NOT NULL,
    libelle VARCHAR(200) NOT NULL,
    description TEXT,
    date_diagnostic DATE,
    date_fin DATE,
    est_chronique BOOLEAN DEFAULT FALSE,
    traitement_actuel TEXT,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_type (type_antecedent)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: contact_urgence
-- Contacts en cas d'urgence
-- ============================================
CREATE TABLE contact_urgence (
    id_contact INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    lien_parente VARCHAR(100) NOT NULL,
    telephone_principal VARCHAR(20) NOT NULL,
    telephone_secondaire VARCHAR(20),
    email VARCHAR(255),
    adresse TEXT,
    ordre_priorite INT DEFAULT 1,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_priorite (ordre_priorite)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: journal_medical
-- Journal quotidien de santé
-- ============================================
CREATE TABLE journal_medical (
    id_journal INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    date_saisie DATE NOT NULL,
    heure_saisie TIME NOT NULL,
    etat_general ENUM('excellent', 'bon', 'moyen', 'faible', 'mauvais'),
    niveau_douleur INT CHECK (niveau_douleur BETWEEN 0 AND 10),
    symptomes TEXT,
    temperature DECIMAL(4,2),
    tension_arterielle_systolique INT,
    tension_arterielle_diastolique INT,
    frequence_cardiaque INT,
    poids DECIMAL(5,2),
    glycemie DECIMAL(5,2),
    humeur VARCHAR(100),
    qualite_sommeil ENUM('excellente', 'bonne', 'moyenne', 'mauvaise'),
    heures_sommeil DECIMAL(4,2),
    activite_physique TEXT,
    alimentation TEXT,
    hydratation_litres DECIMAL(4,2),
    medicaments_pris TEXT,
    observations_libres TEXT,
    fichiers_joints TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_date (date_saisie)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: symptome
-- Suivi des symptômes
-- ============================================
CREATE TABLE symptome (
    id_symptome INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    date_saisie DATE NOT NULL,
    heure_saisie TIME NOT NULL,
    type_symptome VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    intensite INT CHECK (intensite BETWEEN 1 AND 10),
    localisation VARCHAR(200),
    frequence VARCHAR(100),
    facteurs_declenchants TEXT,
    mesures_prises TEXT,
    a_consulte BOOLEAN DEFAULT FALSE,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_date (date_saisie),
    INDEX idx_type (type_symptome)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: examen_medical
-- Examens et analyses médicales
-- ============================================
CREATE TABLE examen_medical (
    id_examen INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    id_medecin INT,
    type_examen VARCHAR(200) NOT NULL,
    date_examen DATE NOT NULL,
    laboratoire VARCHAR(200),
    resultats TEXT,
    valeurs_normales TEXT,
    interpretation TEXT,
    fichier_resultats VARCHAR(255),
    statut ENUM('planifie', 'effectue', 'resultats_recus', 'annule') DEFAULT 'planifie',
    cout DECIMAL(10,2),
    est_rembourse BOOLEAN DEFAULT FALSE,
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES medecin(id_medecin) ON DELETE SET NULL,
    INDEX idx_profil (id_profil),
    INDEX idx_date (date_examen),
    INDEX idx_type (type_examen)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: vaccination
-- Carnet de vaccination
-- ============================================
CREATE TABLE vaccination (
    id_vaccination INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    id_medecin INT,
    nom_vaccin VARCHAR(200) NOT NULL,
    maladie_ciblee VARCHAR(200),
    date_vaccination DATE NOT NULL,
    numero_lot VARCHAR(100),
    date_rappel DATE,
    lieu_vaccination VARCHAR(200),
    professionnel_sante VARCHAR(200),
    effets_secondaires TEXT,
    certificat_vaccination VARCHAR(255),
    statut ENUM('effectue', 'planifie', 'rappel_necessaire') DEFAULT 'effectue',
    notes TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    FOREIGN KEY (id_medecin) REFERENCES medecin(id_medecin) ON DELETE SET NULL,
    INDEX idx_profil (id_profil),
    INDEX idx_date (date_vaccination),
    INDEX idx_vaccin (nom_vaccin)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: notification
-- Système de notifications
-- ============================================
CREATE TABLE notification (
    id_notification INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT NOT NULL,
    id_profil INT,
    type_notification ENUM('medicament', 'rendez_vous', 'stock', 'rappel_vaccination', 'autre') NOT NULL,
    titre VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    date_notification DATETIME NOT NULL,
    est_lue BOOLEAN DEFAULT FALSE,
    date_lecture DATETIME,
    priorite ENUM('basse', 'normale', 'haute', 'urgente') DEFAULT 'normale',
    action_url VARCHAR(255),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_utilisateur (id_utilisateur),
    INDEX idx_profil (id_profil),
    INDEX idx_date (date_notification),
    INDEX idx_lue (est_lue)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: document_medical
-- Documents médicaux (scans, PDF, etc.)
-- ============================================
CREATE TABLE document_medical (
    id_document INT AUTO_INCREMENT PRIMARY KEY,
    id_profil INT NOT NULL,
    type_document ENUM('ordonnance', 'resultat_examen', 'radiographie', 'certificat', 'autre') NOT NULL,
    titre VARCHAR(200) NOT NULL,
    description TEXT,
    chemin_fichier VARCHAR(255) NOT NULL,
    taille_fichier BIGINT,
    type_mime VARCHAR(100),
    date_document DATE,
    mots_cles TEXT,
    est_confidentiel BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_profil) REFERENCES profil_patient(id_profil) ON DELETE CASCADE,
    INDEX idx_profil (id_profil),
    INDEX idx_type (type_document),
    INDEX idx_date (date_document)
) ENGINE=InnoDB;

-- ============================================
-- TABLE: parametre_application
-- Paramètres et configuration de l'application
-- ============================================
CREATE TABLE parametre_application (
    id_parametre INT AUTO_INCREMENT PRIMARY KEY,
    id_utilisateur INT,
    cle_parametre VARCHAR(100) NOT NULL,
    valeur_parametre TEXT,
    type_valeur ENUM('string', 'number', 'boolean', 'json') DEFAULT 'string',
    description TEXT,
    est_global BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE,
    UNIQUE KEY unique_cle_utilisateur (cle_parametre, id_utilisateur),
    INDEX idx_cle (cle_parametre)
) ENGINE=InnoDB;

-- ============================================
-- INSERTION DE DONNÉES DE TEST
-- ============================================

-- Utilisateur de test
INSERT INTO utilisateur (nom, prenom, email, telephone, mot_de_passe, role) VALUES
('Admin', 'Test', 'admin@test.com', '+221 77 000 00 01', 'admin123', 'admin'),
('Diallo', 'Mamadou', 'mamadou@test.com', '+221 77 111 11 11', 'user123', 'utilisateur'),
('Ndiaye', 'Fatou', 'medecin@gmail.com', '+221 77 123 45 67', 'medecin123', 'medecin');

-- Profils patients de test
INSERT INTO profil_patient (id_utilisateur, nom, prenom, date_naissance, sexe, groupe_sanguin) VALUES
(2, 'Diallo', 'Abdou', '2016-01-15', 'M', 'O+'),
(2, 'Diallo', 'Fatou', '2018-05-20', 'F', 'A+');

-- Médecins de test
INSERT INTO medecin (nom, prenom, specialite, telephone, email) VALUES
('Ndiaye', 'Cheikh', 'Pédiatrie', '338001122', 'cndiaye@hopital.sn'),
('Sall', 'Aïssatou', 'Médecine Générale', '338223344', 'asall@clinique.sn');

-- Médicaments de test
INSERT INTO medicament (id_profil, nom_commercial, dosage, forme_pharmaceutique, posologie, 
                       dose_par_prise, nombre_prises_par_jour, heures_prise, moment_prise,
                       date_debut, quantite_totale, quantite_restante, statut) VALUES
(1, 'Doliprane', '500mg', 'Comprimé', '1 comprimé matin et soir', '1 comprimé', 2, 
 '08:00, 20:00', 'après repas', CURDATE(), 30, 20, 'actif');

-- Rendez-vous de test
INSERT INTO rendez_vous (id_profil, id_medecin, date_rendez_vous, heure_rendez_vous, 
                        motif, type_consultation, statut) VALUES
(1, 1, DATE_ADD(CURDATE(), INTERVAL 7 DAY), '09:30:00', 
 'Consultation de suivi', 'suivi', 'planifie');

-- Symptômes de test
INSERT INTO symptome (id_profil, date_saisie, heure_saisie, type_symptome, 
                     description, intensite) VALUES
(1, CURDATE(), CURTIME(), 'Fièvre', 'Température élevée depuis ce matin', 6);

-- ============================================
-- VUES UTILES
-- ============================================

-- Vue: Médicaments actifs avec alertes de stock
CREATE VIEW v_medicaments_alertes AS
SELECT 
    m.id_medicament,
    p.nom AS patient_nom,
    p.prenom AS patient_prenom,
    m.nom_commercial,
    m.quantite_restante,
    m.seuil_alerte,
    m.date_debut,
    DATEDIFF(m.date_fin, CURDATE()) AS jours_restants
FROM medicament m
JOIN profil_patient p ON m.id_profil = p.id_profil
WHERE m.statut = 'actif'
AND (m.quantite_restante <= m.seuil_alerte OR m.date_fin < DATE_ADD(CURDATE(), INTERVAL 7 DAY));

-- Vue: Prochains rendez-vous
CREATE VIEW v_prochains_rendez_vous AS
SELECT 
    r.id_rendez_vous,
    p.nom AS patient_nom,
    p.prenom AS patient_prenom,
    r.date_rendez_vous,
    r.heure_rendez_vous,
    r.motif,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    m.specialite,
    r.statut,
    DATEDIFF(r.date_rendez_vous, CURDATE()) AS jours_restants
FROM rendez_vous r
JOIN profil_patient p ON r.id_profil = p.id_profil
LEFT JOIN medecin m ON r.id_medecin = m.id_medecin
WHERE r.date_rendez_vous >= CURDATE()
AND r.statut IN ('planifie', 'confirme')
ORDER BY r.date_rendez_vous, r.heure_rendez_vous;

-- Vue: Symptômes récents (7 derniers jours)
CREATE VIEW v_symptomes_recents AS
SELECT 
    s.id_symptome,
    p.nom AS patient_nom,
    p.prenom AS patient_prenom,
    s.date_saisie,
    s.heure_saisie,
    s.type_symptome,
    s.description,
    s.intensite,
    DATEDIFF(CURDATE(), s.date_saisie) AS jours_depuis
FROM symptome s
JOIN profil_patient p ON s.id_profil = p.id_profil
WHERE s.date_saisie >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
ORDER BY s.date_saisie DESC, s.heure_saisie DESC;

-- ============================================
-- PROCÉDURES STOCKÉES
-- ============================================

-- Procédure: Décrémenter le stock d'un médicament
DELIMITER //
CREATE PROCEDURE sp_decrementer_stock(
    IN p_id_medicament INT,
    IN p_quantite INT
)
BEGIN
    UPDATE medicament 
    SET quantite_restante = quantite_restante - p_quantite
    WHERE id_medicament = p_id_medicament;
    
    -- Vérifier si le seuil d'alerte est atteint
    SELECT 
        CASE 
            WHEN quantite_restante <= seuil_alerte 
            THEN CONCAT('ALERTE: Stock faible pour ', nom_commercial)
            ELSE 'Stock OK'
        END AS message
    FROM medicament
    WHERE id_medicament = p_id_medicament;
END //
DELIMITER ;

-- Procédure: Créer une notification de rappel
DELIMITER //
CREATE PROCEDURE sp_creer_notification_rappel(
    IN p_id_utilisateur INT,
    IN p_id_profil INT,
    IN p_type VARCHAR(50),
    IN p_titre VARCHAR(200),
    IN p_message TEXT,
    IN p_date_notification DATETIME
)
BEGIN
    INSERT INTO notification (
        id_utilisateur, 
        id_profil, 
        type_notification, 
        titre, 
        message, 
        date_notification
    ) VALUES (
        p_id_utilisateur, 
        p_id_profil, 
        p_type, 
        p_titre, 
        p_message, 
        p_date_notification
    );
END //
DELIMITER ;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger: Créer une notification lors d'une alerte de stock
DELIMITER //
CREATE TRIGGER trg_alerte_stock_medicament
AFTER UPDATE ON medicament
FOR EACH ROW
BEGIN
    IF NEW.quantite_restante <= NEW.seuil_alerte AND OLD.quantite_restante > OLD.seuil_alerte THEN
        INSERT INTO notification (
            id_utilisateur,
            id_profil,
            type_notification,
            titre,
            message,
            date_notification,
            priorite
        )
        SELECT 
            p.id_utilisateur,
            NEW.id_profil,
            'stock',
            'Alerte de stock',
            CONCAT('Le médicament ', NEW.nom_commercial, ' a un stock faible (', NEW.quantite_restante, ' restant)'),
            NOW(),
            'haute'
        FROM profil_patient p
        WHERE p.id_profil = NEW.id_profil;
    END IF;
END //
DELIMITER ;

-- Trigger: Créer une notification pour un rendez-vous
DELIMITER //
CREATE TRIGGER trg_notification_rendez_vous
AFTER INSERT ON rendez_vous
FOR EACH ROW
BEGIN
    INSERT INTO notification (
        id_utilisateur,
        id_profil,
        type_notification,
        titre,
        message,
        date_notification,
        priorite
    )
    SELECT 
        p.id_utilisateur,
        NEW.id_profil,
        'rendez_vous',
        'Nouveau rendez-vous',
        CONCAT('Rendez-vous programmé le ', DATE_FORMAT(NEW.date_rendez_vous, '%d/%m/%Y'), 
               ' à ', TIME_FORMAT(NEW.heure_rendez_vous, '%H:%i'), ' - ', NEW.motif),
        NOW(),
        'normale'
    FROM profil_patient p
    WHERE p.id_profil = NEW.id_profil;
END //
DELIMITER ;

-- ============================================
-- INDEX COMPLÉMENTAIRES POUR PERFORMANCE
-- ============================================

-- Index composites pour les requêtes fréquentes
CREATE INDEX idx_medicament_profil_statut ON medicament(id_profil, statut);
CREATE INDEX idx_rendez_vous_profil_date ON rendez_vous(id_profil, date_rendez_vous);
CREATE INDEX idx_symptome_profil_date ON symptome(id_profil, date_saisie);
CREATE INDEX idx_notification_utilisateur_lue ON notification(id_utilisateur, est_lue);

-- ============================================
-- COMMENTAIRES SUR LES TABLES
-- ============================================

ALTER TABLE utilisateur COMMENT = 'Table des utilisateurs de l\'application';
ALTER TABLE profil_patient COMMENT = 'Profils des membres de la famille';
ALTER TABLE medicament COMMENT = 'Gestion des médicaments et traitements';
ALTER TABLE rendez_vous COMMENT = 'Gestion des rendez-vous médicaux';
ALTER TABLE symptome COMMENT = 'Suivi quotidien des symptômes';
ALTER TABLE notification COMMENT = 'Système de notifications et rappels';

-- ============================================
-- FIN DU SCRIPT
-- ============================================

-- Afficher un récapitulatif
SELECT 'Base de données carnet_de_sante créée avec succès!' AS status;
SELECT COUNT(*) AS nombre_tables FROM information_schema.tables 
WHERE table_schema = 'carnet_de_sante' AND table_type = 'BASE TABLE';
