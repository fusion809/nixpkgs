#!/bin/sh
cd "@out@/lib/openra-ca"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=ca Engine.LaunchPath="@out@/bin/openra-ca" Engine.ModSearchPaths="@out@/lib/openra-ca/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
	error_message="OpenRA Combined Arms has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
	  zenity --no-wrap --error --title "OpenRA Combined Arms" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
