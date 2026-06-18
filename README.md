# Livre Gourmand 🍽️

Application web e-commerce de vente de livres de recettes en français.
Catalogue, panier, paiement, authentification et tableau de bord administrateur.

---

## 🛠️ Technologies

**Backend :** Node.js, Express.js, MySQL, JWT, bcrypt, Multer  
**Frontend :** React 18, React Router v6, React Bootstrap, Axios, Vite

---

## ✨ Fonctionnalités

- Catalogue avec recherche par titre, auteur ou ISBN
- Filtrage par catégorie
- Panier dynamique avec persistance
- Livraison gratuite à partir de 50$
- Formulaire de paiement avec validation
- Inscription et connexion sécurisée (JWT)
- Tableau de bord administrateur
- Gestion des recettes (ajout, modification, suppression)
- Gestion des commandes avec changement de statut
- Design responsive (mobile, tablette, desktop)

---

## ⚙️ Installation

### Prérequis
- Node.js v18+
- MySQL v8+

### Backend
```bash
cd backend
npm install
```

Créer le fichier `.env` dans `backend/` :
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=monlivres
PORT=3000
JWT_SECRET=monSecretJWT
```

```bash
node server.js
```
Serveur sur http://localhost:3000

### Frontend
```bash
cd livresgourmands-frontend
npm install
```

Créer le fichier `.env` dans `livresgourmands-frontend/` :
```
VITE_API_URL=http://localhost:3000/api
```

```bash
npm run dev
```
Application sur http://localhost:5173

---

## 🗄️ Base de données

```sql
CREATE DATABASE IF NOT EXISTS monlivres CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Importer dans l'ordre :
1. `backend/sql/schema.sql`
2. `backend/sql/seed_ouvrages.sql`

---

## 🔐 Comptes de test

| Email | Mot de passe | Rôle |
|-------|-------------|------|
| admin@recettes.com | password | Administrateur |
| julie@example.com | password | Client |

---

## 📍 Routes principales

| Route | Description |
|-------|-------------|
| / | Page d'accueil |
| /products | Catalogue |
| /cart | Panier |
| /checkout | Paiement |
| /login | Connexion |
| /admin | Tableau de bord |

---

## 👩🏾‍💻 Auteur

**Djenabou Diallo** — Développeuse Full Stack  
