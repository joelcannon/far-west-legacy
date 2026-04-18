# FWL Deployment (macOS)

Two modes:

## Stable install (launchd)

Runs as a user-level launchd service. Starts at login, restarts on crash, survives SSH disconnect.

    ./deploy/install_mac.sh

- Service label: `com.farwestlegacy.app`
- Plist: `~/Library/LaunchAgents/com.farwestlegacy.app.plist`
- Logs: `~/Library/Logs/far-west-legacy/flask.{log,err}`
- Port: 8081 (set via plist `EnvironmentVariables`)

### Manage service

Status:

    launchctl print gui/$(id -u)/com.farwestlegacy.app

Stop:

    launchctl bootout gui/$(id -u)/com.farwestlegacy.app

Start:

    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.farwestlegacy.app.plist

Uninstall:

    ./deploy/uninstall_mac.sh

### Tail logs

    tail -f ~/Library/Logs/far-west-legacy/flask.log
    tail -f ~/Library/Logs/far-west-legacy/flask.err

## Dev mode (foreground)

For debugging, UI tweaks, or anything where you want debug=True output in your terminal. Automatically stops the launchd service on start and restarts it on exit.

    ./start_mac.sh

Press Ctrl+C to stop dev mode. The launchd service resumes automatically.

## Clipboard helper

    ./copy_sample_mac.sh            # list available samples
    ./copy_sample_mac.sh veteran    # copy to clipboard via pbcopy
