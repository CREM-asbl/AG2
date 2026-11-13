# Suivi d'optimisation AG2

## Phase A - Mesures runtime de base

### Protocole de profiling

Scénarios (exécuter en build Debug) :
1. Ouverture fichier .fag moyen (tsf2.fag) et gros (fichier > 500 formes si disponible).
2. Déplacement d'une figure (drag continu 5 s).
3. Undo/Redo x10 sur opération de modification.
4. Intersection (recalcul) sur figure à nombreux points.

Points de mesure :
- Temps total par scénario (ms) via ticks/microseconds.
- Nombre d'appels et temps cumulé par hotspot (Figure.subfigupdate, Point.UpdateShape, ObjectsList.GetShape) via logs DebugBuild.
- Mémoire (working set) avant/après.

Instrumentation (DebugBuild uniquement, sans changement de comportement) :
- Figure.subfigupdate : compteur + temps cumulé (Microseconds), log System.DebugLog.
- Point.UpdateShape : compteur + temps cumulé, log.
- ObjectsList.GetShape : compteur + temps cumulé, log.
- Shape.ApplyTransformation : non présent dans le code actuel.

### Mesures Phase A

| Scénario | Temps total (ms) | subfigupdate appels | subfigupdate temps (us) | Point.UpdateShape appels | Point.UpdateShape temps (us) | GetShape appels | GetShape temps (us) | Mémoire (Mo) |
|---|---|---|---|---|---|---|---|---|
| Ouverture .fag moyen |  |  |  |  |  |  |  |  |
| Ouverture .fag gros |  |  |  |  |  |  |  |  |
| Déplacement figure |  |  |  |  |  |  |  |  |
| Undo/Redo x10 |  |  |  |  |  |  |  |  |
| Intersection |  |  |  |  |  |  |  |  |

Notes : remplir après exécution manuelle en build Debug. Logs disponibles via System.DebugLog.
