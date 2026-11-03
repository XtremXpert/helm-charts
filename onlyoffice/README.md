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
helm push dist/onlyoffice-1.1.0.tgz oci://ghcr.io/xtremxpert/charts
```

Puis, dans Rancher : Apps → Repositories → Create → **OCI Repository**,
`oci://ghcr.io/xtremxpert/charts`, authentification BasicAuth.

## Fleet

```yaml
defaultNamespace: onlyoffice
helm:
  chart: oci://ghcr.io/xtremxpert/charts/onlyoffice
  version: 1.1.0
  releaseName: onlyoffice
  takeOwnership: true   # adoption des objets créés à la main
```

## Écarts corrigés depuis la 1.0.0

- image épinglée (`9.4.0.1` au lieu de `latest`) ;
- ressources et sondes alignées sur ce qui tourne réellement ;
- `Service` en un seul port 80 (le conteneur n'écoute pas en 443) ;
- secret JWT existant réutilisé au lieu d'en créer un second ;
- middleware `replacePathRegex` (qui ne pouvait jamais s'appliquer à un chemin)
  remplacé par un `redirectScheme` ;
- exposition rendue optionnelle.
