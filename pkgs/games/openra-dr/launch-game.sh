#!/bin/sh
cd "@out@/lib/openra-dr"

# Run the game
mono --debug OpenRA.Game.exe Game.Mod=dr Engine.LaunchPath="@out@/bin/openra-dr" Engine.ModSearchPaths="@out@/lib/openra-dr/mods" "$@"

# Show a crash dialog if something went wrong
if [ $? != 0 ] && [ $? != 1 ]; then
	error_message="OpenRA Dark Reign has encountered a fatal error.\nPlease refer to the crash logs for more information.\n\nLog files are located in ~/.openra/Logs\n"
  if command -v zenity > /dev/null; then
	  zenity --no-wrap --error --title "OpenRA Dark Reign" --text "$error_message" 2>/dev/null
  else
    printf "${error_message}\n" >&2
  fi
  exit 1
fi
