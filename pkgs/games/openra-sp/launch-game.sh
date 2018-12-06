#!/bin/sh
cd "@out@/lib/openra-sp"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=sp Engine.LaunchPath="@out@/bin/openra-sp" Engine.ModSearchPaths="@out@/lib/openra-sp/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
	error_message="OpenRA Shattered Paradise has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
	  zenity --no-wrap --error --title "OpenRA Shattered Paradise" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
