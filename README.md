# CaliburDiscord
![](images/preview.webp)

CaliburDiscord is a Lua-based plugin that adds Discord Rich Presence integration into SOULCALIBUR VI, allowing your current in-game activity to be displayed directly on your Discord profile.

## Features

- Displays current battle mode (Training, Local Versus, Story, Libra, etc.)
- Shows Character and Stage information dynamically based on the chosen side.
- Supports the detection of Local Versus, CPU Battles, Replays and even Mock Battles
- Support VodkaVerse characters (Natsu, Viola, Leixia, Kestrel, etc.)

## Requirements

- UE4SS (Universal Unreal Engine 4 Script System)

You must download the latest experimental-latest build [here](https://github.com/UE4SS-RE/RE-UE4SS/tree/experimental-latest).

## Installation
If you're installing CaliburDiscord directly from the releases section, it comes pre-packaged with UE4SS.
- Download the latest release and drop it into: `SoulcaliburVI\Binaries\Win64\`

If you have a pre-existing install of UE4SS
- Take only the CaliburDiscord folder, located `ue4ss\Mods`
- Place it in your pre-existing UE4SS Mods folder.

Launch the game, the Discord Game SDK should initialise, and you should now see SOULCALIBUR VI activity on your Discord profile!

## Notes

- This plugin is purely cosmetic and does not modify gameplay.
- Requires Discord to be running in the background for presence updates to work.
- Compatible with most versions of SOULCALIBUR VI on PC.

If you’d like to extend or debug this plugin:
Check the Lua scripts inside Mods/CaliburDiscord/Scripts/.
The core logic resides in `main.lua` and supporting modules like `calibur.lua`

## Additional Credits
- [UE4SS Team](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest): For providing Lua scripting functionality for their application.
- [GhostyPool](https://github.com/GhostyPool/DiscordRPC-Lua): For allowing an easy library for Integrated Discord Rich Presence via Lua.

## License

- This project is licensed under the MIT License.
- SOULCALIBUR VI and all related assets are the property of Bandai Namco Entertainment.
- This project is an independent, non-commercial fan-made integration.
