-- ============================================
-- REQUÊTES SQL UTILES
-- Application Gestion de Santé Familiale
-- ============================================

-- ============================================
-- 1. STATISTIQUES GÉNÉRALES
-- ============================================

-- Nombre total de profils actifs
SELECT COUNT(*) AS nombre_profils 
FROM profil_patient 
WHERE est_actif = TRUE;

-- Nombre de médicaments actifs par profil
SELECT 
    p.nom,
    p.prenom,
    COUNT(m.id_medicament) AS nombre_medicaments
FROM profil_patient p
LEFT JOIN medicament m ON p.id_profil = m.id_profil AND m.statut = 'actif'
WHERE p.est_actif = TRUE
GROUP BY p.id_profil, p.nom, p.prenom
ORDER BY nombre_medicaments DESC;

-- Nombre de rendez-vous à venir
SELECT COUNT(*) AS rendez_vous_a_venir
FROM rendez_vous
WHERE date_rendez_vous >= CURDATE()
AND statut IN ('planifie', 'confirme');

-- ============================================
-- 2. MÉDICAMENTS
-- ============================================

-- Médicaments à prendre aujourd'hui pour un profil
SELECT 
    nom_commercial,
    dose_par_prise,
    nombre_prises_par_jour,
    heures_prise,
    moment_prise,
    instructions_particulieres
FROM medicament
WHERE id_profil = 1 -- Remplacer par l'ID du profil
AND statut = 'actif'
AND (date_fin IS NULL OR date_fin >= CURDATE())
ORDER BY nom_commercial;

-- Médicaments en rupture de stock
SELECT 
    p.nom,
    p.prenom,
    m.nom_commercial,
    m.quantite_restante,
    m.seuil_alerte,
    (m.seuil_alerte - m.quantite_restante) AS deficit
FROM medicament m
JOIN profil_patient p ON m.id_profil = p.id_profil
WHERE m.statut = 'actif'
AND m.quantite_restante <= m.seuil_alerte
ORDER BY m.quantite_restante;

-- Traitements chroniques
SELECT 
    p.nom,
    p.prenom,
    m.nom_commercial,
    m.posologie,
    m.date_debut
FROM medicament m
JOIN profil_patient p ON m.id_profil = p.id_profil
WHERE m.est_traitement_chronique = TRUE
AND m.statut = 'actif'
ORDER BY p.nom, m.nom_commercial;

-- Historique des prises d'un médicament
SELECT 
    DATE(pm.date_heure_prevue) AS date,
    TIME(pm.date_heure_prevue) AS heure_prevue,
    TIME(pm.date_heure_reelle) AS heure_reelle,
    pm.statut,
    TIMESTAMPDIFF(MINUTE, pm.date_heure_prevue, pm.date_heure_reelle) AS retard_minutes
FROM prise_medicament pm
WHERE pm.id_medicament = 1 -- Remplacer par l'ID du médicament
ORDER BY pm.date_heure_prevue DESC
LIMIT 30;

-- Taux d'observance (respect du traitement)
SELECT 
    m.nom_commercial,
    COUNT(*) AS total_prises,
    SUM(CASE WHEN pm.statut = 'prise' THEN 1 ELSE 0 END) AS prises_effectuees,
    SUM(CASE WHEN pm.statut = 'oubliee' THEN 1 ELSE 0 END) AS prises_oubliees,
    ROUND(
        SUM(CASE WHEN pm.statut = 'prise' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS taux_observance
FROM prise_medicament pm
JOIN medicament m ON pm.id_medicament = m.id_medicament
WHERE m.id_profil = 1 -- Remplacer par l'ID du profil
AND pm.date_heure_prevue >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY m.id_medicament, m.nom_commercial;

-- ============================================
-- 3. RENDEZ-VOUS
-- ============================================

-- Prochains rendez-vous (tous profils)
SELECT 
    p.nom AS patient_nom,
    p.prenom AS patient_prenom,
    r.date_rendez_vous,
    r.heure_rendez_vous,
    r.motif,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    m.specialite,
    r.lieu_rendez_vous,
    DATEDIFF(r.date_rendez_vous, CURDATE()) AS jours_restants
FROM rendez_vous r
JOIN profil_patient p ON r.id_profil = p.id_profil
JOIN medecin m ON r.id_medecin = m.id_medecin
WHERE r.date_rendez_vous >= CURDATE()
AND r.statut IN ('planifie', 'confirme')
ORDER BY r.date_rendez_vous, r.heure_rendez_vous;

-- Rendez-vous du jour
SELECT 
    p.nom,
    p.prenom,
    r.heure_rendez_vous,
    r.motif,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    r.lieu_rendez_vous,
    r.notes_avant_rdv
FROM rendez_vous r
JOIN profil_patient p ON r.id_profil = p.id_profil
JOIN medecin m ON r.id_medecin = m.id_medecin
WHERE r.date_rendez_vous = CURDATE()
AND r.statut IN ('planifie', 'confirme')
ORDER BY r.heure_rendez_vous;

-- Historique des consultations
SELECT 
    r.date_rendez_vous,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    m.specialite,
    r.motif,
    r.diagnostic_pose,
    r.notes_apres_rdv
FROM rendez_vous r
JOIN medecin m ON r.id_medecin = m.id_medecin
WHERE r.id_profil = 1 -- Remplacer par l'ID du profil
AND r.statut = 'termine'
ORDER BY r.date_rendez_vous DESC
LIMIT 20;

-- ============================================
-- 4. ORDONNANCES
-- ============================================

-- Ordonnances actives
SELECT 
    o.numero_ordonnance,
    o.date_prescription,
    o.date_expiration,
    DATEDIFF(o.date_expiration, CURDATE()) AS jours_avant_expiration,
    o.diagnostic,
    CONCAT(m.nom, ' ', m.prenom) AS medecin,
    COUNT(mo.id_medicament) AS nombre_medicaments
FROM ordonnance o
JOIN medecin m ON o.id_medecin = m.id_medecin
LEFT JOIN medicament_ordonnance mo ON o.id_ordonnance = mo.id_ordonnance
WHERE o.id_profil = 1 -- Remplacer par l'ID du profil
AND o.statut = 'active'
AND o.date_expiration >= CURDATE()
GROUP BY o.id_ordonnance
ORDER BY o.date_expiration;

-- Ordonnances qui expirent bientôt (dans les 30 jours)
SELECT 
    p.nom,
    p.prenom,
    o.numero_ordonnance,
    o.date_expiration,
    DATEDIFF(o.date_expiration, CURDATE()) AS jours_restants,
    o.diagnostic
FROM ordonnance o
JOIN profil_patient p ON o.id_profil = p.id_profil
WHERE o.statut = 'active'
AND o.date_expiration BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY o.date_expiration;

-- Médicaments d'une ordonnance
SELECT 
    m.nom_commercial,
    m.dosage,
    m.forme_pharmaceutique,
    m.posologie,
    m.dose_par_prise,
    m.nombre_prises_par_jour,
    m.instructions_particulieres
FROM medicament m
JOIN medicament_ordonnance mo ON m.id_medicament = mo.id_medicament
WHERE mo.id_ordonnance = 1 -- Remplacer par l'ID de l'ordonnance
ORDER BY m.nom_commercial;

-- ============================================
-- 5. PROFILS PATIENTS
-- ============================================

-- Vue complète d'un profil patient
SELECT 
    p.*,
    CONCAT(m.nom, ' ', m.prenom) AS medecin_traitant
FROM profil_patient p
LEFT JOIN medecin m ON p.medecin_traitant_id = m.id_medecin
WHERE p.id_profil = 1; -- Remplacer par l'ID du profil

-- Allergies d'un patient
SELECT 
    type_allergie,
    nom_allergie,
    severite,
    symptomes,
    DATE_FORMAT(date_detection, '%d/%m/%Y') AS date_detection
FROM allergie
WHERE id_profil = 1 -- Remplacer par l'ID du profil
AND est_active = TRUE
ORDER BY 
    FIELD(severite, 'critique', 'severe', 'moderee', 'legere');

-- Antécédents médicaux
SELECT 
    type_antecedent,
    libelle,
    description,
    DATE_FORMAT(date_diagnostic, '%d/%m/%Y') AS date_diagnostic,
    est_chronique,
    traitement_actuel
FROM antecedent_medical
WHERE id_profil = 1 -- Remplacer par l'ID du profil
ORDER BY date_diagnostic DESC;

-- Contacts d'urgence
SELECT 
    CONCAT(nom, ' ', prenom) AS nom_complet,
    lien_parente,
    telephone_principal,
    telephone_secondaire,
    email,
    ordre_priorite
FROM contact_urgence
WHERE id_profil = 1 -- Remplacer par l'ID du profil
ORDER BY ordre_priorite;

-- ============================================
-- 6. JOURNAL MÉDICAL
-- ============================================

-- Entrées récentes du journal
SELECT 
    date_saisie,
    etat_general,
    niveau_douleur,
    symptomes,
    temperature,
    CONCAT(tension_arterielle_systolique, '/', tension_arterielle_diastolique) AS tension,
    frequence_cardiaque,
    humeur,
    qualite_sommeil,
    observations_libres
FROM journal_medical
WHERE id_profil = 1 -- Remplacer par l'ID du profil
ORDER BY date_saisie DESC, heure_saisie DESC
LIMIT 30;

-- Évolution de la température
SELECT 
    date_saisie,
    temperature,
    etat_general
FROM journal_medical
WHERE id_profil = 1
AND temperature IS NOT NULL
ORDER BY date_saisie DESC
LIMIT 14;

-- ============================================
-- 7. RAPPORTS ET ANALYSES
-- ============================================

-- Résumé médical complet pour un patient
SELECT 
    'Profil' AS categorie,
    CONCAT(p.nom, ' ', p.prenom) AS description,
    NULL AS date
FROM profil_patient p
WHERE p.id_profil = 1

UNION ALL

SELECT 
    'Médicament actif' AS categorie,
    m.nom_commercial AS description,
    m.date_debut AS date
FROM medicament m
WHERE m.id_profil = 1 AND m.statut = 'actif'

UNION ALL

SELECT 
    'Prochain RDV' AS categorie,
    r.motif AS description,
    r.date_rendez_vous AS date
FROM rendez_vous r
WHERE r.id_profil = 1 
AND r.date_rendez_vous >= CURDATE()
AND r.statut IN ('planifie', 'confirme')

ORDER BY date DESC NULLS FIRST;

-- Suivi des médicaments par mois
SELECT 
    YEAR(pm.date_heure_prevue) AS annee,
    MONTH(pm.date_heure_prevue) AS mois,
    COUNT(*) AS total_prises,
    SUM(CASE WHEN pm.statut = 'prise' THEN 1 ELSE 0 END) AS effectuees,
    SUM(CASE WHEN pm.statut = 'oubliee' THEN 1 ELSE 0 END) AS oubliees
FROM prise_medicament pm
JOIN medicament m ON pm.id_medicament = m.id_medicament
WHERE m.id_profil = 1
GROUP BY annee, mois
ORDER BY annee DESC, mois DESC;

-- ============================================
-- 8. MAINTENANCE
-- ============================================

-- Nettoyer les anciennes notifications lues
DELETE FROM notification
WHERE est_lue = TRUE
AND date_lecture < DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Marquer les ordonnances expirées
UPDATE ordonnance
SET statut = 'expiree'
WHERE date_expiration < CURDATE()
AND statut = 'active';

-- Marquer les médicaments terminés
UPDATE medicament
SET statut = 'termine'
WHERE date_fin < CURDATE()
AND statut = 'actif';

-- ============================================
-- FIN DES REQUÊTES
-- ============================================
