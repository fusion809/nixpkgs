#!/bin/sh
cd "@out@/lib/openra-rv"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=rv Engine.LaunchPath="@out@/bin/openra-rv" Engine.ModSearchPaths="@out@/lib/openra-rv/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
	error_message="OpenRA Romanov's Vengeance has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
	  zenity --no-wrap --error --title "OpenRA Romanov's Vengeance" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
