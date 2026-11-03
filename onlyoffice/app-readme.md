# OnlyOffice Document Server

Éditeur de documents collaboratif, consommé par Odoo via son connecteur
OnlyOffice.

## Points à connaître avant d'installer

- **Le Service s'appelle `documentserver`** (`fullnameOverride`). C'est le nom
  que le connecteur d'Odoo appelle : le changer casse l'édition des documents.
- **La clé JWT est partagée avec Odoo.** Par défaut le chart réutilise le Secret
  existant `onlyoffice-jwt` (clé `JWT_SECRET`) et ne le régénère pas. Une
  installation neuve peut en générer un : il faut alors reporter la même valeur
  dans Odoo.
- **Non exposé par défaut.** Le Document Server reste en `ClusterIP` ; activer
  l'option d'exposition crée l'`IngressRoute` Traefik et le `Certificate`
  cert-manager.
- **Un seul replica.** La stratégie est `Recreate` : pas de deux writers sur le
  cache de documents.
