# TrayIP

This program shows the external IP address of the machine in the menu bar.

## Create a zip file of the app.

```
ditto -c -k --keepParent trayip.app trayip.zip
```

## Remove app from quarantine.

```
xattr -d com.apple.quarantine trayip.app
```
