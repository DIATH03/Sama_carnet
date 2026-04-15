-- ============================================
-- SCRIPT D'INSERTION DE PROFILS DE TEST
-- À exécuter après la création de la base
-- ============================================

USE carnet_de_sante;

-- Vérifier si des profils existent déjà
SELECT COUNT(*) as nb_profils FROM profil_patient;

-- Supprimer les profils de test existants (optionnel)
-- DELETE FROM profil_patient WHERE id_utilisateur = 2;

-- Insertion de 7 profils patients pour la famille Diallo
INSERT INTO profil_patient (id_utilisateur, nom, prenom, date_naissance, sexe, groupe_sanguin, telephone, email, notes_medicales) VALUES
(2, 'Diallo', 'Abdou', '2016-01-15', 'M', 'O+', '338001122', 'abdou.diallo@email.sn', 'Enfant en bonne santé, vaccination à jour'),
(2, 'Diallo', 'Fatou', '2018-05-20', 'F', 'A+', '338001133', 'fatou.diallo@email.sn', 'Allergie aux arachides'),
(2, 'Diallo', 'Mamadou', '1985-03-10', 'M', 'B+', '776543210', 'mamadou.diallo@email.sn', 'Père de famille, bon état général'),
(2, 'Diallo', 'Aïssatou', '1988-07-25', 'F', 'O+', '776543211', 'aissatou.diallo@email.sn', 'Mère de famille, suivi gynécologique régulier'),
(2, 'Diallo', 'Ibrahima', '2020-11-08', 'M', 'A+', '338001144', 'ibrahima.diallo@email.sn', 'Bébé, vaccination en cours'),
(2, 'Diallo', 'Marième', '2014-09-12', 'F', 'B+', '338001155', 'marieme.diallo@email.sn', 'Scolarisée, bon développement'),
(2, 'Diallo', 'Cheikh', '1960-02-18', 'M', 'O+', '776543212', 'cheikh.diallo@email.sn', 'Grand-père, diabète type 2 contrôlé, hypertension');

-- Vérification de l'insertion
SELECT 
    id_profil,
    CONCAT(prenom, ' ', nom) as nom_complet,
    DATE_FORMAT(date_naissance, '%d/%m/%Y') as date_naissance,
    TIMESTAMPDIFF(YEAR, date_naissance, CURDATE()) as age,
    sexe,
    groupe_sanguin
FROM profil_patient
WHERE id_utilisateur = 2
ORDER BY date_naissance;

-- Insertion de quelques médicaments pour certains profils
INSERT INTO medicament (id_profil, nom_commercial, dosage, forme_pharmaceutique, posologie, 
                       dose_par_prise, nombre_prises_par_jour, heures_prise, moment_prise,
                       date_debut, quantite_totale, quantite_restante, statut) VALUES
-- Pour Abdou (enfant)
((SELECT id_profil FROM profil_patient WHERE prenom='Abdou' AND nom='Diallo' LIMIT 1), 
 'Doliprane Enfant', '250mg', 'Suspension', '1 cuillère à café matin et soir', 
 '5ml', 2, '08:00,20:00', 'après repas', CURDATE(), 30, 25, 'actif'),

-- Pour Cheikh (grand-père diabétique)
((SELECT id_profil FROM profil_patient WHERE prenom='Cheikh' AND nom='Diallo' LIMIT 1), 
 'Metformine', '850mg', 'Comprimé', '1 comprimé matin et soir', 
 '1 cp', 2, '08:00,20:00', 'pendant repas', DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 60, 15, 'actif'),
 
((SELECT id_profil FROM profil_patient WHERE prenom='Cheikh' AND nom='Diallo' LIMIT 1), 
 'Amlodipine', '5mg', 'Comprimé', '1 comprimé le matin', 
 '1 cp', 1, '08:00', 'le matin', DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 30, 8, 'actif');

-- Insertion de quelques rendez-vous
INSERT INTO rendez_vous (id_profil, id_medecin, date_rendez_vous, heure_rendez_vous, 
                        motif, type_consultation, lieu_rendez_vous, statut) VALUES
-- Pour Fatou
((SELECT id_profil FROM profil_patient WHERE prenom='Fatou' AND nom='Diallo' LIMIT 1),
 1, DATE_ADD(CURDATE(), INTERVAL 5 DAY), '10:00:00', 
 'Consultation pédiatrique de routine', 'suivi', 'Cabinet Dr. Ndiaye', 'planifie'),

-- Pour Cheikh
((SELECT id_profil FROM profil_patient WHERE prenom='Cheikh' AND nom='Diallo' LIMIT 1),
 2, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '14:30:00', 
 'Contrôle diabète et tension', 'suivi', 'Clinique Sall', 'confirme'),

-- Pour Aïssatou
((SELECT id_profil FROM profil_patient WHERE prenom='Aïssatou' AND nom='Diallo' LIMIT 1),
 2, DATE_ADD(CURDATE(), INTERVAL 10 DAY), '09:00:00', 
 'Bilan de santé annuel', 'bilan', 'Clinique Sall', 'planifie');

-- Insertion de quelques symptômes
INSERT INTO symptome (id_profil, date_saisie, heure_saisie, type_symptome, 
                     description, intensite, localisation) VALUES
-- Pour Abdou
((SELECT id_profil FROM profil_patient WHERE prenom='Abdou' AND nom='Diallo' LIMIT 1),
 DATE_SUB(CURDATE(), INTERVAL 2 DAY), '14:30:00', 'Fièvre', 
 'Température élevée après l\'école', 6, 'Corps entier'),

-- Pour Cheikh
((SELECT id_profil FROM profil_patient WHERE prenom='Cheikh' AND nom='Diallo' LIMIT 1),
 DATE_SUB(CURDATE(), INTERVAL 1 DAY), '18:00:00', 'Fatigue', 
 'Sensation de fatigue inhabituelle', 5, 'Générale'),
 
((SELECT id_profil FROM profil_patient WHERE prenom='Cheikh' AND nom='Diallo' LIMIT 1),
 CURDATE(), '09:00:00', 'Maux de tête', 
 'Léger mal de tête au réveil', 3, 'Tête');

-- Afficher un résumé
SELECT 
    CONCAT(p.prenom, ' ', p.nom) as patient,
    (SELECT COUNT(*) FROM medicament m WHERE m.id_profil = p.id_profil AND m.statut = 'actif') as medicaments,
    (SELECT COUNT(*) FROM rendez_vous r WHERE r.id_profil = p.id_profil AND r.date_rendez_vous >= CURDATE()) as rdv_futurs,
    (SELECT COUNT(*) FROM symptome s WHERE s.id_profil = p.id_profil AND s.date_saisie >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)) as symptomes_7j
FROM profil_patient p
WHERE p.id_utilisateur = 2
ORDER BY p.date_naissance;

SELECT '✅ Données de test insérées avec succès!' as status;
