## Version 2.7.2 (2026-10-30)

- fix: guard fusionsubfigs/Phase0/AddToFigure against OOB/nil (#61)
- Ajout des fichiers supplémentaires pour le packaging multiplateforme
- Fix standard arc copy deformation (paste vs duplicate)
- fix: bound pInShape bp loops by UBound to prevent OutOfBounds
- Fix #39: nested nil guards in Figure.restructurer (Xojo or has no short-circuit)
- Fix NilObjectException in Figure.restructurer on Delete
- fix(montrer-cacher): nil guards Swap + Repere hidden persistence
- fix(#51): guard nil SelectForm/tsfi in UndoOperation head
- fix(#51): guard nil tsf and shape in UndoOperation
- fix(#50): review follow-ups - nil BiB, r1 typo, n=-1 guards
- fix(#50): guard side-index -1 and nil sides in PutOn chain
- fix(#49): guard OOB in validerpoint chain
- fix: centre icones polygone SetIco (issue #42)
- fix: guard EL2 nil in PushButton1_MouseEnter (issue #52)
- chore: nettoie dossier python_oracle racine (deplace dans Tests/)
- chore(test): supprime IntersectionSolverTests.xojo_code inutilise
- chore(test): deplace les tests oracle Python dans Tests/
- fix(intersec): ajoute next manquant pour boucle arc filter
- fix(intersec): tangency line/circle single point + arc inside filter loop
- chore(geometry): note TODO IntersectionSolver futur dans Intersec
- fix(geometry): stabilise les branches d'intersection dans Intersec
- test(geometry): oracle de memoire de branche stable (TDD)
- refactor(geometry): supprime les controles Arc morts dans IntersectionSolver
- fix(geometry): corrige appels API BiBPoint et syntaxe nil dans IntersectionSolver
- refactor: split IntersectionSolution into its own file
- fix: remove duplicate Equals(IntersectionSolution) from IntersectionSolver class
- fix: add IntersectionSolution class reference to project file
- fix: add Equals(IntersectionSolution) method to IntersectionSolution class
- fix: move Equals(IntersectionSolver) to IntersectionSolver class
- fix: Add Equals overload for IntersectionSolver to resolve type reference

# AG2 - Changelog

## Version 2.7.1 (depuis v2.7.0)

### Améliorations majeures

**Refactorisation de l'architecture interne :**
- Ajout d'un système de filtrage pour les formes (interface IShapeFilter) pour améliorer la modularité
- Implémentation d'un cache pour les formes et leurs dépendances dans ObjectsList
- Centralisation des méthodes utilitaires dans le module OperationHelpers
- Harmonisation et amélioration de la méthode GetShape dans plusieurs classes

**Robustesse et gestion des erreurs :**
- Renforcement des vérifications de sécurité dans les opérations critiques (Modifier, Flecher, Pointer, Tracer)
- Amélioration de la validation des paramètres dans FigsList
- Meilleure gestion des exceptions et codes d'erreur
- Corrections du système de gestion des intersections et des points

**Optimisations de performance :**
- Réduction de la duplication de code
- Optimisation des redimensionnements de tableaux (classe BiBPoint)
- Amélioration de la gestion des propriétés 'createTrace' et 'tracept'
- Meilleure lisibilité et maintenabilité globale

### Corrections de bugs

- Correction de computeintercercles : vérification des bornes avant assignation
- Correction de GetRealId : gestion de l'ID manquant
- Harmonisation de Prolonger : corrections de logique et renommages
- Amélioration du test de prolongation pour les Lacet
- Corrections du système de traçage des points
- Optimisations du chargement des formes
- Corrections d'affichage et d'intersection

### Nouvelles méthodes

- UpdatePointSurPosition dans la classe Point pour gérer la mise à jour des points selon leur position
- FilterVisibleByChoixValide dans OperationHelpers pour centraliser la validation des choix

### Compatibilité

- Correction de compatibilité Linux avec lisoup3
- Optimisation et nettoyage du code pour meilleure compatibilité multiplateforme


