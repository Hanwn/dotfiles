if [[ -d "$XDG_DATA_HOME/JetBrains/Toolbox/scripts" ]]; then
  path=("$XDG_DATA_HOME/JetBrains/Toolbox/scripts" $path)
fi

if [[ -d "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" ]]; then
  path=("$HOME/Library/Application Support/JetBrains/Toolbox/scripts" $path)
fi
