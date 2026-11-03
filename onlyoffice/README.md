# onlyoffice

Chart Helm du OnlyOffice Document Server (édition communautaire), écrit pour le
cluster de Bemade, publié comme *Rancher chart*.

## Rancher chart

Le chart porte les trois marqueurs de la vitrine Rancher :

| Élément | Rôle |
|---|---|
| `annotations.catalog.cattle.io/*` | nom affiché, namespace et release figés, réservation CPU/mémoire |
| `questions.yaml` | formulaire d'installation dans Apps → Charts |
| `app-readme.md` | texte affiché en tête de la fiche |

`catalog.cattle.io/namespace` et `catalog.cattle.io/release-name` sont aussi un
garde-fou : une installation depuis la vitrine vise le même objet qu'une release
Fleet, donc elle entre en collision visiblement au lieu de créer un second
propriétaire silencieux.

## Installation

```sh
helm install onlyoffice . -n onlyoffice --create-namespace
```

## Vitrine (OCI)

```sh
helm package . --destination dist
```

Puis, dans Rancher : Apps → Repositories → Create → **HTTP**,
`https://raw.githubusercontent.com/XtremXpert/helm-charts/main`.

## Déploiement

L'installation passe par un `HelmOp` (Continuous Delivery → App Bundles → Helm Op),
pas par un `fleet.yaml` :

```yaml
apiVersion: fleet.cattle.io/v1alpha1
kind: HelmOp
metadata: {name: onlyoffice, namespace: fleet-local}
spec:
  namespace: onlyoffice
  defaultNamespace: onlyoffice
  targets: [{clusterName: local}]
  helm:
    releaseName: onlyoffice
    repo: https://raw.githubusercontent.com/XtremXpert/helm-charts/main
    chart: onlyoffice
    version: 1.2.0
    takeOwnership: true   # adoption des objets créés à la main
    values:
      jwt: {existingSecret: onlyoffice-jwt}
      ingress: {enabled: false}
```

## Versions

| Chart | Image | Note |
|---|---|---|
| 1.2.0 | 10.0.0.1 | saut majeur 9.4 → 10.0 ; JWT activé par défaut côté image |
| 1.1.0 | 9.4.0.1 | premier chart aligné sur le workload réel |
| 1.0.0 | `latest` | retiré : ne décrivait pas ce qui tournait |

Le saut 9.4 → 10.0 n'est pas un correctif. À vérifier avant de déployer :

- le connecteur OnlyOffice d'Odoo doit supporter la 10.0 (édition des documents) ;
- l'image 10.0 active JWT par défaut — c'est déjà notre cas, la clé partagée ne change pas ;
- 10.0 introduit un filtre d'IP WOPI optionnel (`wopi.requireIpFilterRule`), sans effet
  sur l'intégration Odoo qui passe par l'API Docs et non par WOPI.


## Écarts corrigés depuis la 1.0.0

- image épinglée (`9.4.0.1` au lieu de `latest`) ;
- ressources et sondes alignées sur ce qui tourne réellement ;
- `Service` en un seul port 80 (le conteneur n'écoute pas en 443) ;
- secret JWT existant réutilisé au lieu d'en créer un second ;
- middleware `replacePathRegex` (qui ne pouvait jamais s'appliquer à un chemin)
  remplacé par un `redirectScheme` ;
- exposition rendue optionnelle.
