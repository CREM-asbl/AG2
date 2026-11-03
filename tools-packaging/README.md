# AG2 — Packaging

Chaîne packaging locale (Xojo 2023r2 IDE manuel, PowerShell Windows).

## Prérequis

- Xojo 2023r2, Inno Setup 6 (`ISCC.exe`), WSL2 (smoke Linux)
- `VERSION` racine = source vérité (ex `2.7.2`)

## Usage

```powershell
# 1. Builder via IDE (auto: snapshot → poll → package)
.\tools-packaging\build.ps1

# 2. Ou packaging direct depuis builds IDE existants
.\tools-packaging\package-all.ps1
.\tools-packaging\package-all.ps1 -Only windows,linux
.\tools-packaging\package-all.ps1 -Skip macos -WinArch both

# 3. Watch auto (FileSystemWatcher, debounce 15s)
.\tools-packaging\watch-builds.ps1

# 4. Verifier
.\tools-packaging\test-packages.ps1   # 9 checks
.\tools-packaging\test-linux-smoke.ps1  # WSL2

# 5. Publier
.\tools-packaging\update-version-xml.ps1        # DryRun
.\tools-packaging\update-version-xml.ps1 -Publish
.\tools-packaging\publish-release.ps1          # DryRun
.\tools-packaging\publish-release.ps1 -Publish
```

## Scripts

| Script | Rôle |
|---|---|
| `sync-version.ps1` | Aligne AG.xojo_project sur VERSION |
| `update-changelog.ps1` | Prépend section depuis git log |
| `package-windows.ps1 -Arch x64\|x86` | ISCC exe + zip portable |
| `package-linux.ps1` | tgz Linux x64 |
| `package-macos.ps1` | tgz macOS universal (DMG abandonné) |
| `make-manifest.ps1` | dist/manifest.json (sha256) |
| `test-packages.ps1` | 9 checks porte verte |
| `package-all.ps1 -Only/-Skip` | Chaîne complète + tableau SizeMB/Sec |
| `build.ps1` | Snapshot → poll IDE → package-all |
| `watch-builds.ps1` | Watcher auto → package-all -Only cible |
| `update-version-xml.ps1` | Sync https://api.crem.be/AG/version.xml (DryRun défaut) |
| `test-linux-smoke.ps1 [-Tgz] [-TimeoutSec]` | Smoke WSL2 (extract TEMP, ldd + --help, PASS/FAIL/SKIP) |

## Linux headless (issue #71)

Silent exit 0 before any window = startup quit before CreateWindow.
Causes fixed/guarded: `SpecialFolder.Documents` nil (no xdg-user-dirs),
`DocFolder` nil in `Configuration`/`Dictionnaire`, `--help` running full
GUI path. `App.Opening` now short-circuits `--help`/`--version` before
`initWindow.ShowModal`, `InitFolders` falls back to
`ApplicationData` then app dir, and the smoke test fails on empty
`--help` output (`SMOKE-KO-silent`) instead of PASS.

Prereqs on minimal systems: install `xdg-user-dirs`, run
`xdg-user-dirs-update`, launch under `DISPLAY`/Xvfb or WSLg.
| `test-macos-smoke.sh [tgz] [timeout]` | Smoke macOS CI (otool, plutil, --help, PASS/FAIL/SKIP) |
| `publish-release.ps1` | gh release (DryRun défaut) |

## Conventions

- `Builds - AG/` ignoré git (builds IDE locaux)
- `Select-Object -First` partout, jamais `head`
- Client MAJ : `Connexion/CheckUpdate.xojo_code` lit `url + version.xml`
- Assoc `.fag`/`.hag` via ISS (HKLM/HKCU + SHChangeNotify)
