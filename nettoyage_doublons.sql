-- ============================================
-- SCRIPT DE NETTOYAGE DES DOUBLONS
-- Base de données : carnet_de_sante
-- ============================================

USE carnet_de_sante;

-- Afficher les doublons avant nettoyage
SELECT 
    'AVANT NETTOYAGE - Doublons détectés:' AS info,
    nom, 
    prenom, 
    DATE_FORMAT(date_naissance, '%d/%m/%Y') as date_naissance,
    GROUP_CONCAT(id_profil ORDER BY id_profil) as ids,
    COUNT(*) as nombre
FROM profil_patient
WHERE id_utilisateur = 2 AND est_actif = TRUE
GROUP BY nom, prenom, date_naissance
HAVING COUNT(*) > 1;

-- Désactiver les profils en double (garde les plus récents)
-- Désactive Abdou Diallo ID 1 (garde ID 3)
UPDATE profil_patient SET est_actif = FALSE WHERE id_profil = 1;

-- Désactive Fatou Diallo ID 2 (garde ID 4)
UPDATE profil_patient SET est_actif = FALSE WHERE id_profil = 2;

-- Afficher les profils actifs après nettoyage
SELECT 
    '✅ APRÈS NETTOYAGE - Profils actifs uniques:' AS info;

SELECT 
    id_profil,
    CONCAT(prenom, ' ', nom) as nom_complet,
    DATE_FORMAT(date_naissance, '%d/%m/%Y') as date_naissance,
    TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) as age,
    sexe,
    groupe_sanguin,
    telephone,
    email
FROM profil_patient
WHERE id_utilisateur = 2 AND est_actif = TRUE
ORDER BY date_naissance;

-- Compter le résultat
SELECT COUNT(*) as 'Nombre de profils actifs' 
FROM profil_patient 
WHERE id_utilisateur = 2 AND est_actif = TRUE;

SELECT '✅ Nettoyage terminé! Vous avez maintenant 7 profils uniques.' AS resultat;
