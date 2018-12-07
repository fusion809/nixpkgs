#!/bin/sh
cd "@out@/lib/openra-d2"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=d2 Engine.LaunchPath="@out@/bin/openra-d2" Engine.ModSearchPaths="@out@/lib/openra-d2/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
	error_message="OpenRA Dune II has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
	  zenity --no-wrap --error --title "OpenRA Dune II" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
