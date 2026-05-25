# for linux
if [ -d "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" ]; then
  export PATH="$XDG_DATA_HOME/JetBrains/Toolbox/scripts:$PATH"
fi

# for mac
if [ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]; then
  export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
fi