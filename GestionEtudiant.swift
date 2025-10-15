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

