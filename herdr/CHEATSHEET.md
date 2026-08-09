# Herdr Spickzettel

Herdr ist auf `Ctrl-a` als Prefix ausgelegt. Erst `Ctrl-a`, dann der eigentliche
Befehl. Die Maus ist dabei ganz normal nutzbar.

## Die ersten 5 Befehle

| Aktion | Tastenkürzel |
| --- | --- |
| Hilfe mit allen aktiven Bindings | `prefix+?` |
| Neuer Tab | `prefix+c` |
| Split rechts / unten | `prefix+v` / `prefix+-` |
| Zwischen Panes springen | `prefix+h/j/k/l` |
| Detach ohne etwas zu beenden | `prefix+q` |

## Panes

| Aktion | Tastenkürzel |
| --- | --- |
| Pane maximieren / Zoom | `prefix+z` |
| Aktuelles Pane schliessen | `prefix+x` |
| Pane mit `h/j/k/l` verschieben | `prefix+shift+h/j/k/l` |
| Resize-Modus | `prefix+r` |
| Copy-Modus | `prefix+[` |

## Tabs

| Aktion | Tastenkürzel |
| --- | --- |
| Naechster / vorheriger Tab | `prefix+n` / `prefix+p` |
| Direkt zu Tab 1 bis 9 | `prefix+1..9` |
| Tab umbenennen | `prefix+shift+t` |
| Tab schliessen | `prefix+shift+x` |

## Workspaces und Session

| Aktion | Tastenkürzel |
| --- | --- |
| Neuer Workspace | `prefix+shift+n` |
| Workspace umbenennen | `prefix+shift+w` |
| Workspace schliessen | `prefix+shift+d` |
| Goto-Picker | `prefix+g` |
| Sidebar ein- / ausblenden | `prefix+b` |

## Nützliche Befehle

```sh
herdr --default-config
herdr server stop
```

Wenn du nur eine Sache merken willst: `Ctrl-a q` zum Detach, `Ctrl-a ?` fuer die
komplette Uebersicht.
