import Foundation

// Énumérations pour votre partie
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
