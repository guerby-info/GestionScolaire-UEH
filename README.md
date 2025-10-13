# 🎓 Système de Gestion Scolaire - UEH

**Université d'État d'Haïti**  
*Campus Henry Christophe de Limonade*  
*Faculté des Sciences et de Génie (FSG)*

---

## 📋 Table des Matières
- [Description](#-description)
- [Équipe](#-équipe)
- [Structure du Projet](#-structure-du-projet)
- [Fonctionnalités](#-fonctionnalités)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Contribution](#-contribution)
- [License](#-license)

---

##  Description

Système complet de gestion d'établissement scolaire développé en Swift dans le cadre du projet de programmation à la Faculté des Sciences et de Génie. Cette application permet la gestion intégrée des étudiants, des notes, et des aspects financiers d'un établissement universitaire.

##  Équipe de Développement

###  Superviseur Académique
| Role | Nom | Contact |
|------|-----|---------|
|  Professeur Superviseur | Tchyalapi | [GitHub](https://github.com/tchyalapi) |

### 💻 Développeurs
| # | Nom & Prénom | Rôle | Module | Branche Git |
|---|--------------|------|---------|-------------|
| 1 | Guerby RENE| Développeur Principal | Interface Utilisateur | `main` |
| 2 | Woodkely Fritz JOSEPH | Développeur | Gestion des Étudiants | `feature/gestion-etudiant` |
| 3 | Jean Edmonson ALCINDOR | Développeur | Gestion Financière | `feature/gestion-fianciere` |


## 🏗️ Structure du Projet
GestionScolaire-UEH/
├── 📁 Sources/
│ ├── 🎓 GestionEtudiants.swift # Module gestion étudiants
│ ├── 💰 GestionFinanciere.swift # Module gestion financière
│ ├── 🖥️ InterfaceUtilisateur.swift # Module interface (COMPLÉTÉ)
│ └── 🚀 main.swift # Point d'entrée principal
├── 📁 Documentation/
│ └── 📄 manuel-utilisation.md # Documentation utilisateur
├── 🔧 .gitignore
├── 📄 LICENSE
└── 📄 README.md


## ✨ Fonctionnalités

### 🎓 Module Gestion des Étudiants
- ✅ Inscription des étudiants
- ✅ Gestion des matières et coefficients
- ✅ Saisie et modification des notes
- ✅ Calcul automatique des moyennes
- ✅ Génération de bulletins
- ✅ Recherche et filtrage des étudiants

### 💰 Module Gestion Financière
- ✅ Enregistrement des transactions
- ✅ Suivi des paiements par étudiant
- ✅ Génération de références uniques
- ✅ Calcul des soldes et statistiques
- ✅ Rapports financiers détaillés

### 🖥️ Module Interface Utilisateur
- ✅ Menus interactifs et intuitifs
- ✅ Validation robuste des entrées
- ✅ Gestion des erreurs utilisateur
- ✅ Affichage formaté professionnel
- ✅ Navigation fluide entre modules

## 🚀 Installation

### Prérequis
- Swift 5.0+ (macOS/Linux) ou environnement Swift compatible
- Git pour la gestion de version

### Clonage du Repository
```bash
git clone https://github.com/guerby-info/GestionScolaire-UEH.git
cd GestionScolaire-UEH
