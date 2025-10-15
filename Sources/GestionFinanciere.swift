import Foundation

// Énumérations pour la partie financière
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
    
    private func calculerMontantParEtudiant() -> [String: Double] {
        var totalParEtudiant: [String: Double] = [:]
        
        for transaction in transactions where transaction.type == .revenu && transaction.idEtudiant != nil {
            let idEtudiant = transaction.idEtudiant!
            totalParEtudiant[idEtudiant, default: 0] += transaction.montant
        }
        
        return totalParEtudiant
    }
}
