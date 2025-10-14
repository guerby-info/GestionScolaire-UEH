import Foundation

// Modeles de Donnees
enum Sexe {
    case masculin
    case feminin
}

enum AnneeUniversitaire {
    case premiereAnnee
    case deuxiemeAnnee
    case troisiemeAnnee
    case quatriemeAnnee
    case cinquiemeAnnee
}

enum DomaineEtude {
    case sciencesInformatiques
    case genieCivil
    case genieElectrique
    case medecine
    case droit
    case economie
    case administration
    case psychologie
    case autres
}

enum TypeTransaction {
    case revenu
    case depense
}

enum CategorieTransaction {
    case fraisScolarite
    case fraisInscription
    case fraisAdministratifs
    case achatFournitures
    case equipement
}

class Matiere {
    let nom: String
    let coefficient: Double
    var note: Double
    
    init(nom: String, coefficient: Double, note: Double = 0.0) {
        self.nom = nom
        self.coefficient = coefficient
        self.note = note
    }
}

class GenerateurID {
    private static var compteurGeneral: Int = 0
    
    static func genererID(nom: String, prenom: String) -> String {
        let prefixe = String(prenom.prefix(4)).uppercased()
        compteurGeneral += 1
        return "\(prefixe)-\(String(format: "%03d", compteurGeneral))"
    }
}

class Etudiant {
    let id: String
    var nom: String
    var prenom: String
    var age: Int
    var sexe: Sexe
    var annee: AnneeUniversitaire
    var domaine: DomaineEtude
    var matieres: [Matiere]
    var dateInscription: Date
    
    init(nom: String, prenom: String, age: Int, sexe: Sexe, annee: AnneeUniversitaire, domaine: DomaineEtude) {
        self.id = GenerateurID.genererID(nom: nom, prenom: prenom)
        self.nom = nom
        self.prenom = prenom
        self.age = age
        self.sexe = sexe
        self.annee = annee
        self.domaine = domaine
        self.matieres = []
        self.dateInscription = Date()
    }
    
    func ajouterMatiere(_ matiere: Matiere) {
        if !matieres.contains(where: { $0.nom.lowercased() == matiere.nom.lowercased() }) {
            matieres.append(matiere)
        }
    }
    
    func ajouterNote(pour nomMatiere: String, note: Double) {
        if let index = matieres.firstIndex(where: { $0.nom.lowercased() == nomMatiere.lowercased() }) {
            matieres[index].note = note
        }
    }
    
    func calculerMoyenne() -> Double {
        guard !matieres.isEmpty else { return 0.0 }
        
        var totalNotesPonderees: Double = 0
        var totalCoefficients: Double = 0
        
        for matiere in matieres {
            totalNotesPonderees += matiere.note * matiere.coefficient
            totalCoefficients += matiere.coefficient
        }
        
        guard totalCoefficients > 0 else { return 0.0 }
        return totalNotesPonderees / totalCoefficients
    }
    
    func afficherBulletin() {
        print("\n" + String(repeating: "-", count: 75))
        let sexeSymbole = sexe == .masculin ? "H" : "F"
        let anneeString = obtenirStringAnnee(annee)
        let domaineString = obtenirStringDomaine(domaine)
        
        print("BULLETIN UNIVERSITAIRE - \(prenom) \(nom) (\(sexeSymbole))")
        print("ID: \(id) | \(anneeString) | \(domaineString)")
        print(String(repeating: "-", count: 75))
        
        if !matieres.isEmpty {
            print("Matieres : |Coef     |  Note  |")
            print(String(repeating: "-", count: 75))
            
            for (index, matiere) in matieres.enumerated() {
                let numero = "\(index + 1)-\(matiere.nom)"
                print(String(format: "%-15s |  %-8.1f|  %-6.0f|", 
                           numero, matiere.coefficient, matiere.note))
            }
            
            print(String(repeating: "-", count: 75))
            let moyenne = calculerMoyenne()
            print(String(format: "%-15s |  %-8s|  %-6.2f|", "Moyenne", "", moyenne))
            
            let appreciation: String
            switch moyenne {
            case 90...100: appreciation = "EXCELLENT"
            case 80..<90:  appreciation = "TRES BIEN"
            case 70..<80:  appreciation = "BIEN"
            case 60..<70:  appreciation = "PASSABLE"
            case 50..<60:  appreciation = "INSUFFISANT"
            default:       appreciation = "ECHEC"
            }
            print("APPRECIATION: \(appreciation)")
        } else {
            print("AUCUNE MATIERE ENREGISTREE")
        }
        print(String(repeating: "-", count: 75))
    }
    
    func obtenirStringAnnee(_ annee: AnneeUniversitaire) -> String {
        switch annee {
        case .premiereAnnee: return "1ere Annee"
        case .deuxiemeAnnee: return "2eme Annee"
        case .troisiemeAnnee: return "3eme Annee"
        case .quatriemeAnnee: return "4eme Annee"
        case .cinquiemeAnnee: return "5eme Annee"
        }
    }
    
    func obtenirStringDomaine(_ domaine: DomaineEtude) -> String {
        switch domaine {
        case .sciencesInformatiques: return "Sciences Informatiques"
        case .genieCivil: return "Genie Civil"
        case .genieElectrique: return "Genie Electrique"
        case .medecine: return "Medecine"
        case .droit: return "Droit"
        case .economie: return "Economie"
        case .administration: return "Administration"
        case .psychologie: return "Psychologie"
        case .autres: return "Autres"
        }
    }
}

class Transaction {
    let id: UUID
    let montant: Double
    let date: Date
    let type: TypeTransaction
    let categorie: CategorieTransaction
    let idEtudiant: String?
    let nomEtudiant: String
    let numeroReference: String
    
    init(montant: Double, type: TypeTransaction, categorie: CategorieTransaction, idEtudiant: String? = nil, nomEtudiant: String = "") {
        self.id = UUID()
        self.montant = montant
        self.date = Date()
        self.type = type
        self.categorie = categorie
        self.idEtudiant = idEtudiant
        self.nomEtudiant = nomEtudiant
        
        let formateur = DateFormatter()
        formateur.dateFormat = "yyyyMMddHHmmss"
        self.numeroReference = "REF-\(formateur.string(from: self.date))-\(Int.random(in: 1000...9999))"
    }
    
    func afficherInformations() {
        let typeString = type == .revenu ? "REVENU" : "DEPENSE"
        let formateurDate = DateFormatter()
        formateurDate.dateFormat = "dd/MM/yyyy HH:mm"
        formateurDate.locale = Locale(identifier: "fr_FR")
        
        let categorieString = obtenirStringCategorie(categorie)
        let etudiantInfo = idEtudiant != nil ? "Etudiant: \(nomEtudiant) (\(idEtudiant!))" : "General"
        
        print("""
        [\(typeString)] - \(categorieString)
        Montant: \(String(format: "%.2f", montant)) HTG
        \(etudiantInfo)
        Date: \(formateurDate.string(from: date))
        Reference: \(numeroReference)
        """)
    }
    
    private func obtenirStringCategorie(_ categorie: CategorieTransaction) -> String {
        switch categorie {
        case .fraisScolarite: return "Frais de scolarite"
        case .fraisInscription: return "Frais d'inscription"
        case .fraisAdministratifs: return "Frais administratifs"
        case .achatFournitures: return "Achat de fournitures"
        case .equipement: return "Equipement"
        }
    }
}

// Gestionnaires

class GestionEtudiants {
    private var etudiants: [Etudiant] = []
    
    func ajouterEtudiant(nom: String, prenom: String, age: Int, sexe: Sexe, annee: AnneeUniversitaire, domaine: DomaineEtude) -> Etudiant {
        let etudiant = Etudiant(nom: nom, prenom: prenom, age: age, sexe: sexe, annee: annee, domaine: domaine)
        etudiants.append(etudiant)
        return etudiant
    }
    
    func listerTousLesEtudiants() {
        if etudiants.isEmpty {
            print("\nAUCUN ETUDIANT ENREGISTRE")
            return
        }
        
        print("\n" + String(repeating: "=", count: 100))
        print("LISTE GENERALE DES ETUDIANTS - UNIVERSITE D'ETAT D'HAITI")
        print(String(repeating: "=", count: 100))
        
        print(String(format: "%-4s %-12s %-15s %-15s %-4s %-8s %-20s %-12s", 
                    "NO", "ID", "PRENOM", "NOM", "SEXE", "AGE", "DOMAINE", "MOYENNE"))
        print(String(repeating: "-", count: 100))
        
        for (index, etudiant) in etudiants.enumerated() {
            let sexeSymbole = etudiant.sexe == .masculin ? "H" : "F"
            let domaineString = etudiant.obtenirStringDomaine(etudiant.domaine)
            let moyenne = etudiant.calculerMoyenne()
            
            print(String(format: "%-4d %-12s %-15s %-15s %-4s %-8d %-20s %-12.2f",
                        index + 1,
                        etudiant.id,
                        etudiant.prenom,
                        etudiant.nom,
                        sexeSymbole,
                        etudiant.age,
                        domaineString,
                        moyenne))
        }
        
        print(String(repeating: "-", count: 100))
        
        let totalEtudiants = etudiants.count
        let hommes = etudiants.filter { $0.sexe == .masculin }.count
        let femmes = etudiants.filter { $0.sexe == .feminin }.count
        let moyenneGenerale = etudiants.map { $0.calculerMoyenne() }.reduce(0, +) / Double(totalEtudiants)
        
        print("STATISTIQUES:")
        print("Total etudiants: \(totalEtudiants) | Hommes: \(hommes) | Femmes: \(femmes)")
        print("Moyenne generale: \(String(format: "%.2f", moyenneGenerale))/100")
        print(String(repeating: "=", count: 100))
    }
    
    func trouverEtudiant(parNom nom: String, prenom: String) -> Etudiant? {
        return etudiants.first { 
            $0.nom.lowercased() == nom.lowercased() && 
            $0.prenom.lowercased() == prenom.lowercased() 
        }
    }
    
    func trouverEtudiant(parID id: String) -> Etudiant? {
        return etudiants.first { $0.id == id }
    }
    
    func etudiantExiste(nom: String, prenom: String) -> Bool {
        return trouverEtudiant(parNom: nom, prenom: prenom) != nil
    }
    
    func obtenirTousLesEtudiants() -> [Etudiant] {
        return etudiants
    }
    
    func obtenirEtudiantsParSexe(_ sexe: Sexe) -> [Etudiant] {
        return etudiants.filter { $0.sexe == sexe }
    }
    
    func obtenirEtudiantsParAnnee(_ annee: AnneeUniversitaire) -> [Etudiant] {
        return etudiants.filter { $0.annee == annee }
    }
    
    func obtenirEtudiantsParDomaine(_ domaine: DomaineEtude) -> [Etudiant] {
        return etudiants.filter { $0.domaine == domaine }
    }
    
    func ajouterMatiereAEtudiant(id: String, nomMatiere: String, coefficient: Double, note: Double) -> Bool {
        guard let indexEtudiant = etudiants.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        if etudiants[indexEtudiant].matieres.contains(where: { $0.nom.lowercased() == nomMatiere.lowercased() }) {
            return false
        }
        
        let matiere = Matiere(nom: nomMatiere, coefficient: coefficient, note: note)
        etudiants[indexEtudiant].ajouterMatiere(matiere)
        return true
    }
    
    func ajouterNoteAEtudiant(id: String, nomMatiere: String, note: Double) -> Bool {
        guard let indexEtudiant = etudiants.firstIndex(where: { $0.id == id }) else {
            return false
        }
        
        guard etudiants[indexEtudiant].matieres.contains(where: { $0.nom.lowercased() == nomMatiere.lowercased() }) else {
            return false
        }
        
        etudiants[indexEtudiant].ajouterNote(pour: nomMatiere, note: note)
        return true
    }
    
    func calculerMoyenneEtudiant(id: String) -> Double? {
        guard let etudiant = trouverEtudiant(parID: id) else {
            return nil
        }
        return etudiant.calculerMoyenne()
    }
    
    func obtenirMatieresEtudiant(id: String) -> [Matiere]? {
        guard let etudiant = trouverEtudiant(parID: id) else {
            return nil
        }
        return etudiant.matieres
    }
    
    func afficherBulletinEtudiant(id: String) -> Bool {
        guard let etudiant = trouverEtudiant(parID: id) else {
            return false
        }
        etudiant.afficherBulletin()
        return true
    }
    
    func obtenirEtudiantsSansMatieres() -> [Etudiant] {
        return etudiants.filter { $0.matieres.isEmpty }
    }
}

class GestionFinanciere {
    private var transactions: [Transaction] = []
    private let gestionEtudiants: GestionEtudiants
    
    init(gestionEtudiants: GestionEtudiants) {
        self.gestionEtudiants = gestionEtudiants
    }
    
    func enregistrerTransactionEtudiant(montant: Double, categorie: CategorieTransaction, idEtudiant: String) -> Bool {
        guard let etudiant = gestionEtudiants.trouverEtudiant(parID: idEtudiant) else {
            print("ERREUR: ETUDIANT NON TROUVE AVEC L'ID: \(idEtudiant)")
            return false
        }
        
        let transaction = Transaction(
            montant: montant,
            type: .revenu,
            categorie: categorie,
            idEtudiant: idEtudiant,
            nomEtudiant: "\(etudiant.prenom) \(etudiant.nom)"
        )
        transactions.append(transaction)
        print("SUCCES: TRANSACTION ENREGISTREE POUR L'ETUDIANT \(etudiant.prenom) \(etudiant.nom)")
        print("NUMERO DE REFERENCE: \(transaction.numeroReference)")
        return true
    }
    
    func listerToutesTransactions() {
        if transactions.isEmpty {
            print("\nAUCUNE TRANSACTION ENREGISTREE")
            return
        }
        
        print("\n" + String(repeating: "=", count: 60))
        print("JOURNAL DES TRANSACTIONS")
        print(String(repeating: "=", count: 60))
        
        for (index, transaction) in transactions.enumerated() {
            print("TRANSACTION \(index + 1):")
            transaction.afficherInformations()
            print(String(repeating: "-", count: 50))
        }
    }
    
    func calculerTotalRevenu() -> Double {
        return transactions
            .filter { $0.type == .revenu }
            .map { $0.montant }
            .reduce(0, +)
    }
    
    func calculerTotalDepenses() -> Double {
        return transactions
            .filter { $0.type == .depense }
            .map { $0.montant }
            .reduce(0, +)
    }
    
    func calculerSoldeActuel() -> Double {
        return calculerTotalRevenu() - calculerTotalDepenses()
    }
    
    func calculerMontantParEtudiant() -> [String: Double] {
        var totalParEtudiant: [String: Double] = [:]
        
        for transaction in transactions where transaction.type == .revenu && transaction.idEtudiant != nil {
            let idEtudiant = transaction.idEtudiant!
            totalParEtudiant[idEtudiant, default: 0] += transaction.montant
        }
        
        return totalParEtudiant
    }
    
    func afficherMontantParEtudiant() {
        let montants = calculerMontantParEtudiant()
        
        if montants.isEmpty {
            print("\nAUCUNE TRANSACTION ETUDIANT ENREGISTREE")
            return
        }
        
        print("\n" + String(repeating: "=", count: 60))
        print("MONTANT PAYE PAR CHAQUE ETUDIANT")
        print(String(repeating: "=", count: 60))
        
        for (idEtudiant, montant) in montants {
            if let etudiant = gestionEtudiants.trouverEtudiant(parID: idEtudiant) {
                let sexeSymbole = etudiant.sexe == .masculin ? "H" : "F"
                print("\(etudiant.prenom) \(etudiant.nom) (\(sexeSymbole)) - ID: \(idEtudiant)")
                print("  Total paye: \(String(format: "%.2f", montant)) HTG")
                print(String(repeating: "-", count: 30))
            }
        }
        
        let totalGeneral = montants.values.reduce(0, +)
        print("TOTAL GENERAL: \(String(format: "%.2f", totalGeneral)) HTG")
        print(String(repeating: "=", count: 60))
    }
    
    func afficherSolde() {
        let solde = calculerSoldeActuel()
        print("\n" + String(repeating: "=", count: 30))
        print("SOLDE ACTUEL")
        print(String(repeating: "=", count: 30))
        print("Solde: \(String(format: "%.2f", solde)) HTG")
        print(String(repeating: "=", count: 30))
    }
}

// Interface en Ligne de Commande
class InterfaceGestionScolaire {
    private let gestionEtudiants = GestionEtudiants()
    private let gestionFinanciere: GestionFinanciere
    
    init() {
        self.gestionFinanciere = GestionFinanciere(gestionEtudiants: gestionEtudiants)
    }
    
    // Methodes de Validation
    private func estNomValide(_ nom: String) -> Bool {
        let nomTrimme = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return !nomTrimme.isEmpty && nomTrimme.count >= 2
    }
    
    private func estAgeValide(_ chaineAge: String) -> (estValide: Bool, age: Int?) {
        guard let age = Int(chaineAge), age >= 15, age <= 70 else {
            return (false, nil)
        }
        return (true, age)
    }
    
    private func estCoefficientValide(_ chaineCoefficient: String) -> (estValide: Bool, coefficient: Double?) {
        guard let coefficient = Double(chaineCoefficient), coefficient > 0, coefficient <= 10 else {
            return (false, nil)
        }
        return (true, coefficient)
    }
    
    private func estNoteValide(_ chaineNote: String) -> (estValide: Bool, note: Double?) {
        guard let note = Double(chaineNote), note >= 0, note <= 100 else {
            return (false, nil)
        }
        return (true, note)
    }
    
    private func estMontantValide(_ chaineMontant: String) -> (estValide: Bool, montant: Double?) {
        guard let montant = Double(chaineMontant), montant > 0, montant <= 1_000_000 else {
            return (false, nil)
        }
        return (true, montant)
    }
    
    private func estNomMatiereValide(_ nom: String) -> Bool {
        let nomTrimme = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        return !nomTrimme.isEmpty && nomTrimme.count >= 2
    }
    
    // Methodes de Saisie
    private func demanderNom() -> String {
        while true {
            print("\nEntrez le nom de l'etudiant:")
            
            guard let entree = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("ERREUR DE SAISIE. VEUILLEZ REESSAYER.")
                continue
            }
            
            if !estNomValide(entree) {
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
            
            if !estNomValide(entree) {
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
            
            let validation = estAgeValide(entree)
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
            case 0:
                return .masculin
            case 1:
                return .masculin
            case 2:
                return .feminin
            default:
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR 1 OU 2.")
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
            case 0:
                return .premiereAnnee
            case 1: return .premiereAnnee
            case 2: return .deuxiemeAnnee
            case 3: return .troisiemeAnnee
            case 4: return .quatriemeAnnee
            case 5: return .cinquiemeAnnee
            default:
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 5.")
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
            case 0:
                return .sciencesInformatiques
            case 1: return .sciencesInformatiques
            case 2: return .genieCivil
            case 3: return .genieElectrique
            case 4: return .medecine
            case 5: return .droit
            case 6: return .economie
            case 7: return .administration
            case 8: return .psychologie
            case 9: return .autres
            default:
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 9.")
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
            
            if id == "0" {
                return nil
            }
            
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
            
            if entree == "0" {
                return nil
            }
            
            let validation = estMontantValide(entree)
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
            case 0:
                return nil
            case 1: return .fraisScolarite
            case 2: return .fraisInscription
            case 3: return .fraisAdministratifs
            case 4: return .achatFournitures
            case 5: return .equipement
            default:
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET 5.")
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
            
            if nombre == 0 {
                return nil
            }
            
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
            
            if entree == "0" {
                return nil
            }
            
            if !estNomMatiereValide(entree) {
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
            
            if entree == "0" {
                return nil
            }
            
            let validation = estCoefficientValide(entree)
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
            
            if entree == "0" {
                return nil
            }
            
            let validation = estNoteValide(entree)
            if !validation.estValide {
                print("NOTE INVALIDE. DOIT ETRE UN NOMBRE ENTRE 0 ET 100.")
                continue
            }
            
            return validation.note!
        }
    }
    
    // Methodes Principales
    
    func executer() {
        afficherMessageBienvenue()
        
        while true {
            afficherMenuPrincipal()
            let option = demanderOptionMenu(maxOption: 3)
            
            switch option {
            case 0:
                continue
            case 1:
                menuGestionEtudiants()
            case 2:
                menuGestionFinanciere()
            case 3:
                print("\nMERCI D'AVOIR UTILISE LE SYSTEME DE GESTION SCOLAIRE. AU REVOIR!")
                return
            default:
                break
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
            case 0:
                continue
            case 1:
                ajouterEtudiant()
            case 2:
                gestionEtudiants.listerTousLesEtudiants()
            case 3:
                ajouterMatieresEtudiant()
            case 4:
                modifierNoteEtudiant()
            case 5:
                afficherBulletinEtudiant()
            case 6:
                return
            default:
                break
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
            case 0:
                continue
            case 1:
                enregistrerTransactionEtudiant()
            case 2:
                gestionFinanciere.listerToutesTransactions()
            case 3:
                gestionFinanciere.afficherMontantParEtudiant()
            case 4:
                gestionFinanciere.afficherSolde()
            case 5:
                return
            default:
                break
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
        print("Nom: \(etudiant.nom)")
        print("Prenom: \(etudiant.prenom)")
        print("Age: \(etudiant.age)")
        print("Sexe: \(sexe == .masculin ? "Masculin" : "Feminin")")
        print("Annee: \(etudiant.obtenirStringAnnee(etudiant.annee))")
        print("Domaine: \(etudiant.obtenirStringDomaine(etudiant.domaine))")
    }
    
    private func ajouterMatieresEtudiant() {
        print("\n=== AJOUT DE MATIERES A UN ETUDIANT ===")
        
        guard let id = demanderIDEtudiant() else {
            return
        }
    
        guard let etudiant = gestionEtudiants.trouverEtudiant(parID: id) else {
            print("ERREUR: ETUDIANT NON TROUVE.")
            return
        }
        
        print("\nETUDIANT SELECTIONNE:")
        print("\(etudiant.prenom) \(etudiant.nom) (ID: \(etudiant.id))")
        
        guard let nombreMatieres = demanderNombreMatieres() else {
            return
        }
        
        var matieresAjoutees = 0
        
        for i in 1...nombreMatieres {
            print("\n--- Matiere \(i) sur \(nombreMatieres) ---")
            
            guard let nomMatiere = demanderNomMatiere() else {
                return
            }
            
            guard let coefficient = demanderCoefficient() else {
                return
            }
            
            guard let note = demanderNote() else {
                return
            }
            
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
        
        guard let id = demanderIDEtudiant() else {
            return
        }
        
        guard let etudiant = gestionEtudiants.trouverEtudiant(parID: id) else {
            print("ERREUR: ETUDIANT NON TROUVE.")
            return
        }
        
        print("\nETUDIANT SELECTIONNE:")
        print("\(etudiant.prenom) \(etudiant.nom) (ID: \(etudiant.id))")
        
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
            
            if choix == 0 {
                return
            }
            
            if choix < 1 || choix > matieres.count {
                print("CHOIX INVALIDE. VEUILLEZ CHOISIR ENTRE 1 ET \(matieres.count).")
                continue
            }
            
            let matiereSelectionnee = matieres[choix - 1]
            print("\nMATIERE SELECTIONNEE: \(matiereSelectionnee.nom)")
            print("Note actuelle: \(matiereSelectionnee.note)/100")
            
            guard let nouvelleNote = demanderNote() else {
                return
            }
            
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
        
        guard let id = demanderIDEtudiant() else {
            return
        }
        
        let succes = gestionEtudiants.afficherBulletinEtudiant(id: id)
        if !succes {
            print("ERREUR: IMPOSSIBLE D'AFFICHER LE BULLETIN.")
        }
    }
    
    private func enregistrerTransactionEtudiant() {
        print("\n=== ENREGISTREMENT D'UNE TRANSACTION ETUDIANT ===")
        
        guard let id = demanderIDEtudiant() else {
            return
        }
        
        guard let montant = demanderMontant() else {
            return
        }
        
        guard let categorie = demanderCategorieTransaction() else {
            return
        }
        
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

// Point d'entree principal
func main() {
    let interface = InterfaceGestionScolaire()
    interface.executer()
}

// Execution du programme
main()
