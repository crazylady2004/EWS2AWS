# EWS2AWS
Projet de TPI blanc sur AWS

## Contexte
L’EPFL gère de manière centralisée plus de 850 sites WordPress, tous hébergés sur un cluster Kubernetes (OpenShift). En cas de problème majeur sur l’infrastructure Openshift les sites web seraient inaccessibles.

## Objectifs
Le but de ce TPI est de mettre en place un POC qui permet de dupliquer des sites sur une autre infrastructure de type AWS de manière scriptée sans intervention manuelle pour la configuration.

Dans les grandes lignes, les opérations attendues sont les suivantes :
- Exporter deux sites existants, par exemple https://www.epfl.ch/ et https://www.epfl.ch/campus/
- Déployer automatiquement une infrastructure sur AWS
- Importer les sites exportés précédemment dans la nouvelle infrastructure sur AWS
- Appliquer automatiquement toutes les adaptations nécessaires afin que les sites
fonctionnent correctement
