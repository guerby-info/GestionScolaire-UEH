import Foundation

class Validators {
    static func estNomValide(_ nom: String) -> Bool {
        let nomTrimme = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return !nomTrimme.isEmpty && nomTrimme.count >= 2
    }
    
    static func estAgeValide(_ chaineAge: String) -> (estValide: Bool, age: Int?) {
        guard let age = Int(chaineAge), age >= 15, age <= 70 else {
            return (false, nil)
        }
        return (true, age)
    }
    
    static func estCoefficientValide(_ chaineCoefficient: String) -> (estValide: Bool, coefficient: Double?) {
        guard let coefficient = Double(chaineCoefficient), coefficient > 0, coefficient <= 10 else {
            return (false, nil)
        }
        return (true, coefficient)
    }
    
    static func estNoteValide(_ chaineNote: String) -> (estValide: Bool, note: Double?) {
        guard let note = Double(chaineNote), note >= 0, note <= 100 else {
            return (false, nil)
        }
        return (true, note)
    }
    
    static func estMontantValide(_ chaineMontant: String) -> (estValide: Bool, montant: Double?) {
        guard let montant = Double(chaineMontant), montant > 0, montant <= 1_000_000 else {
            return (false, nil)
        }
        return (true, montant)
    }
    
    static func estNomMatiereValide(_ nom: String) -> Bool {
        let nomTrimme = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return !nomTrimme.isEmpty && nomTrimme.count >= 2
    }
}

class InterfaceUtilisateur {
    private let gestionEtudiants = GestionEtudiants()
    private let gestionFinanciere: GestionFinanciere
    
    init() {
        self.gestionFinanciere = GestionFinanciere(gestionEtudiants: gestionEtudiants)
    }
    
    // Méthodes de saisie
    private func demanderNom() -> String {
        while true {
            print("\nEntrez le nom de l'etudiant:")
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            if !Validators.estNomValide(entree) {
                print("LE NOM DOIT CONTENIR AU MOINS 2 CARACTERES.")
                continue
            }
            return entree
        }
    }
    
    private func demanderPrenom() -> String {
        while true {
            print("\nEntrez le prenom de l'etudiant:")
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            if !Validators.estNomValide(entree) {
                print("LE PRENOM DOIT CONTENIR AU MOINS 2 CARACTERES.")
                continue
            }
            return entree
        }
    }
    
    private func demanderAge() -> Int {
        while true {
            print("\nEntrez l'age de l'etudiant:")
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            let validation = Validators.estAgeValide(entree)
            if !validation.estValide {
                print("AGE INVALIDE. L'AGE DOIT ETRE UN NOMBRE ENTRE 15 ET 70 ANS.")
                continue
            }
            return validation.age!
        }
    }
    
    private func demanderSexe() -> Sexe {
        while true {
            print("\nChoisissez le sexe de l'etudiant:")
            print("1. Masculin")
            print("2. Feminin")
            print("0. Retour")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let choix = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE VALIDE.")
                continue
            }
            
            switch choix {
            case 0: return .masculin
            case 1: return .masculin
            case 2: return .feminin
            default: print("CHOIX INVALIDE. VEUILLEZ CHOISIR 1 OU 2.")
            }
        }
    }
    
    private func demanderAnnee() -> AnneeUniversitaire {
        while true {
            print("\nChoisissez l'annee de l'etudiant:")
            print("1. 1ere Annee")
            print("2. 2eme Annee")
            print("3. 3eme Annee")
            print("4. 4eme Annee")
            print("5. 5eme Annee")
            print("0. Retour")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let choix = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE ENTRE 1 ET 5.")
                continue
            }
            
            switch choix {
            case 0: return .premiereAnnee
            case 1: return .premiereAnnee
            case 2: return .deuxiemeAnnee
            case 3: return .troisiemeAnnee
            case 4: return .quatriemeAnnee
            case 5: return .cinquiemeAnnee
            default: print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 5.")
            }
        }
    }
    
    private func demanderDomaine() -> DomaineEtude {
        while true {
            print("\nChoisissez le domaine d'etude:")
            print("1. Sciences Informatiques")
            print("2. Genie Civil")
            print("3. Genie Electrique")
            print("4. Medecine")
            print("5. Droit")
            print("6. Economie")
            print("7. Administration")
            print("8. Psychologie")
            print("9. Autres")
            print("0. Retour")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let choix = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE ENTRE 1 ET 9.")
                continue
            }
            
            switch choix {
            case 0: return .sciencesInformatiques
            case 1: return .sciencesInformatiques
            case 2: return .genieCivil
            case 3: return .genieElectrique
            case 4: return .medecine
            case 5: return .droit
            case 6: return .economie
            case 7: return .administration
            case 8: return .psychologie
            case 9: return .autres
            default: print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 9.")
            }
        }
    }
    
    private func demanderIDEtudiant() -> String? {
        while true {
            print("\nEntrez l'ID de l'etudiant (ex: GUER-001):")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let id = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if id == "0" { return nil }
            if id.isEmpty {
                print("L'ID NE PEUT PAS ETRE VIDE.")
                continue
            }
            if gestionEtudiants.trouverEtudiant(parID: id) == nil {
                print("AUCUN ETUDIANT TROUVE AVEC CET ID: \(id)")
                continue
            }
            return id
        }
    }
    
    private func demanderMontant() -> Double? {
        while true {
            print("\nEntrez le montant (HTG):")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if entree == "0" { return nil }
            let validation = Validators.estMontantValide(entree)
            if !validation.estValide {
                print("MONTANT INVALIDE. DOIT ETRE UN NOMBRE POSITIF (MAX 1,000,000 HTG).")
                continue
            }
            return validation.montant!
        }
    }
    
    private func demanderCategorieTransaction() -> CategorieTransaction? {
        while true {
            print("\nChoisissez la categorie de transaction:")
            print("1. Frais de scolarite")
            print("2. Frais d'inscription")
            print("3. Frais administratifs")
            print("4. Achat de fournitures")
            print("5. Equipement")
            print("0. Retour")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let choix = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE ENTRE 1 ET 5.")
                continue
            }
            
            switch choix {
            case 0: return nil
            case 1: return .fraisScolarite
            case 2: return .fraisInscription
            case 3: return .fraisAdministratifs
            case 4: return .achatFournitures
            case 5: return .equipement
            default: print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 5.")
            }
        }
    }
    
    private func demanderOptionMenu(maxOption: Int) -> Int {
        while true {
            print("\nChoisissez une option (0-\(maxOption)):")
            print("0. Retour")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), 
                  let option = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE VALIDE.")
                continue
            }
            
            if option < 0 || option > maxOption {
                print("OPTION INVALIDE. VEUILLEZ CHOISIR ENTRE 0 ET \(maxOption).")
                continue
            }
            return option
        }
    }
    
    private func demanderNombreMatieres() -> Int? {
        while true {
            print("\nCombien de matieres voulez-vous ajouter?")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let nombre = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE VALIDE.")
                continue
            }
            
            if nombre == 0 { return nil }
            if nombre < 1 || nombre > 20 {
                print("LE NOMBRE DE MATIERES DOIT ETRE ENTRE 1 ET 20.")
                continue
            }
            return nombre
        }
    }
    
    private func demanderNomMatiere() -> String? {
        while true {
            print("\nEntrez le nom de la matiere:")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if entree == "0" { return nil }
            if !Validators.estNomMatiereValide(entree) {
                print("LE NOM DE LA MATIERE DOIT CONTENIR AU MOINS 2 CARACTERES.")
                continue
            }
            return entree
        }
    }
    
    private func demanderCoefficient() -> Double? {
        while true {
            print("\nEntrez le coefficient de la matiere:")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if entree == "0" { return nil }
            let validation = Validators.estCoefficientValide(entree)
            if !validation.estValide {
                print("COEFFICIENT INVALIDE. DOIT ETRE UN NOMBRE ENTRE 0.1 ET 10.")
                continue
            }
            return validation.coefficient!
        }
    }
    
    private func demanderNote() -> Double? {
        while true {
            print("\nEntrez la note (sur 100):")
            print("Ou entrez '0' pour retourner au menu precedent")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if entree == "0" { return nil }
            let validation = Validators.estNoteValide(entree)
            if !validation.estValide {
                print("NOTE INVALIDE. DOIT ETRE UN NOMBRE ENTRE 0 ET 100.")
                continue
            }
            return validation.note!
        }
    }
    
    // Méthodes principales d'interface
    func executer() {
        afficherMessageBienvenue()
        
        while true {
            afficherMenuPrincipal()
            let option = demanderOptionMenu(maxOption: 3)
            
            switch option {
            case 1: menuGestionEtudiants()
            case 2: menuGestionFinanciere()
            case 3:
                print("\nMERCI D'AVOIR UTILISE LE SYSTEME DE GESTION SCOLAIRE. AU REVOIR!")
                return
            default: continue
            }
        }
    }
    
    private func afficherMessageBienvenue() {
        print("""
        ====================================
        GESTION COMPLETE D'ETABLISSEMENT SCOLAIRE
        Universite d'Etat d'Haiti
        Campus Henry Christophe de Limonade
        Faculte des Sciences et de Genie (FSG)
        ====================================
        """)
    }
    
    private func afficherMenuPrincipal() {
        print("""
        \n=== MENU PRINCIPAL ===
        1. Gestion des Etudiants
        2. Gestion de l'Economat
        3. Quitter
        """)
    }
    
    private func menuGestionEtudiants() {
        while true {
            print("""
            \n=== GESTION DES ETUDIANTS ===
            1. Ajouter un etudiant
            2. Lister tous les etudiants
            3. Ajouter des matieres avec notes a un etudiant
            4. Modifier une note d'un etudiant
            5. Afficher le bulletin d'un etudiant
            6. Retour au menu principal
            """)
            
            let option = demanderOptionMenu(maxOption: 6)
            
            switch option {
            case 1: ajouterEtudiant()
            case 2: gestionEtudiants.listerTousLesEtudiants()
            case 3: ajouterMatieresEtudiant()
            case 4: modifierNoteEtudiant()
            case 5: afficherBulletinEtudiant()
            case 6: return
            default: continue
            }
        }
    }
    
    private func menuGestionFinanciere() {
        while true {
            print("""
            \n=== GESTION DE L'ECONOMAT ===
            1. Enregistrer une transaction etudiant
            2. Lister toutes les transactions
            3. Afficher le montant paye par chaque etudiant
            4. Afficher le solde actuel
            5. Retour au menu principal
            """)
            
            let option = demanderOptionMenu(maxOption: 5)
            
            switch option {
            case 1: enregistrerTransactionEtudiant()
            case 2: gestionFinanciere.listerToutesTransactions()
            case 3: gestionFinanciere.afficherMontantParEtudiant()
            case 4: gestionFinanciere.afficherSolde()
            case 5: return
            default: continue
            }
        }
    }
    
    private func ajouterEtudiant() {
        print("\n=== AJOUT D'UN NOUVEL ETUDIANT ===")
        
        let nom = demanderNom()
        let prenom = demanderPrenom()
        
        if gestionEtudiants.etudiantExiste(nom: nom, prenom: prenom) {
            print("\nERREUR: UN ETUDIANT AVEC LE MEME NOM ET PRENOM EXISTE DEJA.")
            return
        }
        
        let age = demanderAge()
        let sexe = demanderSexe()
        let annee = demanderAnnee()
        let domaine = demanderDomaine()
        
        let etudiant = gestionEtudiants.ajouterEtudiant(
            nom: nom,
            prenom: prenom,
            age: age,
            sexe: sexe,
            annee: annee,
            domaine: domaine
        )
        
        print("\nSUCCES: ETUDIANT AJOUTE AVEC SUCCES!")
        print("ID ATTRIBUE: \(etudiant.id)")
    }
    
    private func ajouterMatieresEtudiant() {
        print("\n=== AJOUT DE MATIERES A UN ETUDIANT ===")
        
        guard let id = demanderIDEtudiant() else { return }
        guard let etudiant = gestionEtudiants.trouverEtudiant(parID: id) else {
            print("ERREUR: ETUDIANT NON TROUVE.")
            return
        }
        
        print("\nETUDIANT SELECTIONNE: \(etudiant.prenom) \(etudiant.nom) (ID: \(etudiant.id))")
        
        guard let nombreMatieres = demanderNombreMatieres() else { return }
        var matieresAjoutees = 0
        
        for i in 1...nombreMatieres {
            print("\n--- Matiere \(i) sur \(nombreMatieres) ---")
            
            guard let nomMatiere = demanderNomMatiere() else { return }
            guard let coefficient = demanderCoefficient() else { return }
            guard let note = demanderNote() else { return }
            
            let succes = gestionEtudiants.ajouterMatiereAEtudiant(
                id: id,
                nomMatiere: nomMatiere,
                coefficient: coefficient,
                note: note
            )
            
            if succes {
                print("SUCCES: Matiere '\(nomMatiere)' ajoutee avec note \(note)/100")
                matieresAjoutees += 1
            } else {
                print("ERREUR: Impossible d'ajouter la matiere '\(nomMatiere)'")
            }
        }
        
        print("\nOPERATION TERMINEE: \(matieresAjoutees) matiere(s) ajoutee(s) sur \(nombreMatieres) prevue(s)")
    }
    
    private func modifierNoteEtudiant() {
        print("\n=== MODIFICATION DE NOTE ===")
        
        guard let id = demanderIDEtudiant() else { return }
        guard let etudiant = gestionEtudiants.trouverEtudiant(parID: id) else {
            print("ERREUR: ETUDIANT NON TROUVE.")
            return
        }
        
        print("\nETUDIANT SELECTIONNE: \(etudiant.prenom) \(etudiant.nom) (ID: \(etudiant.id))")
        
        guard let matieres = gestionEtudiants.obtenirMatieresEtudiant(id: id) else {
            print("ERREUR: IMPOSSIBLE D'OBTENIR LES MATIERES DE L'ETUDIANT.")
            return
        }
        
        if matieres.isEmpty {
            print("CET ETUDIANT N'A AUCUNE MATIERE ENREGISTREE.")
            return
        }
        
        print("\nMATIERES DE L'ETUDIANT:")
        for (index, matiere) in matieres.enumerated() {
            print("\(index + 1). \(matiere.nom) - Note actuelle: \(matiere.note)/100")
        }
        
        while true {
            print("\nEntrez le numero de la matiere a modifier:")
            print("Ou entrez '0' pour retourner")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let choix = Int(entree) else {
                print("VEUILLEZ ENTRER UN NOMBRE VALIDE.")
                continue
            }
            
            if choix == 0 { return }
            if choix < 1 || choix > matieres.count {
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET \(matieres.count).")
                continue
            }
            
            let matiereSelectionnee = matieres[choix - 1]
            print("\nMATIERE SELECTIONNEE: \(matiereSelectionnee.nom)")
            print("Note actuelle: \(matiereSelectionnee.note)/100")
            
            guard let nouvelleNote = demanderNote() else { return }
            
            let succes = gestionEtudiants.ajouterNoteAEtudiant(
                id: id,
                nomMatiere: matiereSelectionnee.nom,
                note: nouvelleNote
            )
            
            if succes {
                print("SUCCES: Note modifiee de \(matiereSelectionnee.note) a \(nouvelleNote)/100")
            } else {
                print("ERREUR: Impossible de modifier la note.")
            }
            break
        }
    }
    
    private func afficherBulletinEtudiant() {
        print("\n=== AFFICHAGE DU BULLETIN ===")
        guard let id = demanderIDEtudiant() else { return }
        
        let succes = gestionEtudiants.afficherBulletinEtudiant(id: id)
        if !succes {
            print("ERREUR: IMPOSSIBLE D'AFFICHER LE BULLETIN.")
        }
    }
    
    private func enregistrerTransactionEtudiant() {
        print("\n=== ENREGISTREMENT D'UNE TRANSACTION ETUDIANT ===")
        
        guard let id = demanderIDEtudiant() else { return }
        guard let montant = demanderMontant() else { return }
        guard let categorie = demanderCategorieTransaction() else { return }
        
        let succes = gestionFinanciere.enregistrerTransactionEtudiant(
            montant: montant,
            categorie: categorie,
            idEtudiant: id
        )
        
        if !succes {
            print("ERREUR: IMPOSSIBLE D'ENREGISTRER LA TRANSACTION.")
        }
    }
}