
# RPR Unfit System

Ein fortschrittliches FiveM Kampfunfähigkeitssystem, das dafür sorgt, dass Spieler nach einer Bewusstlosigkeit nicht sofort wieder in Aktionen eingreifen können. Das Script wurde umfassend verbessert und bietet nun Unterstützung für mehrere Frameworks, Datenbankintegration und viele weitere Funktionen.

## Features

- **Multi-Framework-Unterstützung**: Kompatibel mit ESX und QBCore
- **Persistente Speicherung**: Kampfunfähigkeitsstatus bleibt nach Serverneustarts erhalten (optional)
- **Anpassbares HUD**: Moderne oder klassische HUD-Anzeige mit voller Anpassbarkeit
- **Administrationswerkzeuge**: Admin-Befehle zum Verwalten des Kampfunfähigkeitsstatus
- **Sanitäter-Integration**: Spezielle Funktionen für Sanitäter
- **Fahrzeugkontrollen**: Verhindert das Aussteigen aus Fahrzeugen und Fahrzeugsteuerung während der Kampfunfähigkeit
- **Mehrsprachige Unterstützung**: Voll anpassbare Spracheinstellungen
- **Modulare Struktur**: Saubere Code-Organisation für einfachere Wartung und Integration

## Dependencies

- ESX Legacy oder QBCore (Framework kann in der Konfiguration ausgewählt werden)
- Ein Ambulance mit Revive-Trigger (z.B. esx_ambulancejob, qb-ambulancejob oder ak47_ambulancejob)
- OxMySQL (optional, für Datenbank-Persistenz)

## Installation

1. Lade das Repository herunter
2. Kopiere den Ordner `rpr_unfit` in deinen `resources`-Ordner
3. Füge `ensure rpr_unfit` zu deiner `server.cfg` hinzu
4. Passe die Einstellungen in `config.lua` an dein Setup an

## Konfiguration

Die Datei `config.lua` bietet umfangreiche Anpassungsmöglichkeiten:

- Framework-Auswahl (ESX oder QBCore)
- Zeiteinstellungen für Kampfunfähigkeit
- HUD-Anpassungen (Position, Farbe, Stil)
- Berechtigungsgruppen
- Benachrichtigungen
- Sprache und Text
- Integration mit anderen Skripts

## Befehle

- `/unfitadmin [spieler-id]` - Admin-Befehl zum Zurücksetzen des Kampfunfähigkeitsstatus eines Spielers
- `/unfithud` - Blendet die Unfit-HUD-Anzeige ein/aus
- `/unfitstatus [spieler-id]` - Zeigt den aktuellen Kampfunfähigkeitsstatus eines Spielers an
- `/unfitforce [spieler-id]` - Erzwingt den Kampfunfähigkeitsstatus für einen Spieler
- `/unfitrevive [spieler-id]` - Erlaubt Sanitätern, einen kampfunfähigen Spieler zu behandeln

## Ordnerstruktur

```
rpr_unfit/
├── client/
│   ├── main.lua     - Hauptclientcode und Initialisierung
│   ├── events.lua   - Clientseitige Event-Handler
│   └── ui.lua       - UI-Rendering und HUD-Funktionen
├── server/
│   ├── main.lua     - Hauptservercode und Initialisierung
│   ├── database.lua - Datenbankfunktionen
│   ├── events.lua   - Serverseitige Event-Handler
│   └── utils.lua    - Framework-spezifische Hilfsfunktionen
├── config.lua       - Hauptkonfigurationsdatei
├── fxmanifest.lua   - Resource-Manifest
├── LICENSE.md       - Lizenzinformationen
└── README.md        - Dokumentation
```

## Integration in andere Skripte

Das Script bietet verschiedene Events, die von anderen Skripten genutzt werden können:

- `rpr_unfit:setUnfit` - Setzt einen Spieler in den Kampfunfähigkeitsstatus
- `rpr_unfit:removeUnfit` - Entfernt den Kampfunfähigkeitsstatus eines Spielers
- `rpr_unfit:getUnfitStatus` - Ruft den Kampfunfähigkeitsstatus eines Spielers ab
- `rpr_unfit:extendUnfitTime` - Verlängert die Kampfunfähigkeitszeit eines Spielers

## Lizenz

Dieses Script steht unter einer benutzerdefinierten Lizenz. Siehe [LICENSE](LICENSE.md) für Details.

© 141Reaper
