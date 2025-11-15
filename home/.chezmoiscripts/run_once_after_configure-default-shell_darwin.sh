#!/usr/bin/env bash
{{ if eq .chezmoi.os "darwin" -}}

# check if fish is default shell (macos specific check here)
# if yes, exit
if [[ "$(dscl . -read ~/ UserShell)" == "UserShell: $(which fish)" ]]; then
    echo "Fish is already the default shell"
    exit 0
fi

# check if fish is in the shells list
# if not - add it to the list
if ! grep -Fxq "$(which fish)" /etc/shells; then
    echo "Adding $(which fish) to list of shells..."
    which fish | sudo tee -a /etc/shells
else
    echo "$(which fish) is already in /etc/shells"
fi
# do a check if adding it to the list succeeded
if ! grep -Fxq "$(which fish)" /etc/shells; then
    echo "There was no error but still $(which fish) is not in /etc/shells. Add manually and rerun install script."
    exit 1
fi

echo "Setting Fish as the default shell for the user..."
chsh -s "$(which fish)"
{{ end -}}
