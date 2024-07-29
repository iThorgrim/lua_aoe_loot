# 🗡️ AOE Loot for Eluna
## Overview
This script implements the highly sought-after AOE Loot/Mass Loot feature from Mist of Pandaria, allowing players to loot multiple corpses in a single action instead of looting each one individually.<br>It is compatible with any emulator that uses Eluna, including TrinityCore (Eluna) and AzerothCore (mod-eluna).

## Preview
[https://streamable.com/pvqigh](https://streamable.com/pvqigh)

## Features
### Functional
- ✅ AOE Loot in Solo Play
- ✅ Duplication Protection

### Not Yet Functional
- ❌ Enable/Disable via Interface
- ❌ AOE Loot in Group Play

## 🚀 Installation
- Download the script in either .moon (MoonScript) or .lua (Lua) format.
- Place the script in your lua_scripts directory.
- Apply the provided .diff script to add a few methods to Eluna for full compatibility:
  - To apply the `.diff` script:
  - ```git apply --directory=modules/mod-eluna azerothcore_eluna.diff``` or ```git apply --directory=src/server/game/LuaEngine trinitycore_eluna.diff```
- No further action is required; the script is fully functional once in place.

## 🎮 Usage
Once installed, the AOE Loot feature will be automatically enabled for solo play. <br>
You can loot multiple corpses with a single action, improving your looting efficiency and game experience.

## 🔄 Compatibility
This script is compatible with any emulator using Eluna, with the provided .diff script to ensure full functionality.<br> No additional setup or configuration is required from the developers beyond applying the patch.

## 📚 References
[AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting) - Learn more about the AOE Loot feature introduced in Mist of Pandaria.

## 🛠️ Contribution
1. Fork, Clone, Create a branch, Commit, Push, Create a PR.
2. Report issues in the issue tracker.

## 📜 License
This project is licensed under the GNU GPL v3 License. See the LICENSE file for details.

## 📝 Credits
This README.md was generated with the help of ChatGPT.<br>
Contributors: [@iThorgrim](https://github.com/iThorgrim), YourNameHere ?
