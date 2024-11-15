# 🗡️ AOE Loot Script for Eluna

## It's now archived see this -> https://github.com/iThorgrim/lua_aoe_loot/issues/10


## Overview
Implement the AOE Loot/Mass Loot feature from Mist of Pandaria, allowing players to loot multiple corpses in a single action. Compatible with any emulator using Eluna, including TrinityCore and AzerothCore.

## Features

### Functionnal
- ✅ AOE Loot in Solo Play
- ✅ AOE Loot in Group Play
- ✅ Duplication Protection
- ✅ Enable/Disable via Interface (CSMH and AIO support)
- ✅ ["Skinning"](https://wowpedia.fandom.com/wiki/Skinning) and ["Mob Engineering"](https://wowwiki-archive.fandom.com/wiki/Mob_engineering) support
- ✅ Autoloot support (you can activate or disable it the AOELoot works !)

### Not Yet Functionnal
- ❌ The futur

## 🚀 Installation

1. Download the script in `.moon` or `.lua` format.
2. Place it in your `lua_scripts` directory.
3. Download the .diff script for your Emulator (TrinityCore, AzerothCore)
4. Apply the provided `.diff` script to add necessary methods to Eluna:
```sh
git apply --directory=modules/mod-eluna azerothcore_eluna.diff
git apply --directory=src/server/game/LuaEngine trinitycore_eluna.diff
```
5. The script is fully functional once in place.

## 🎮 Usage

Automatically enabled for solo play, allowing looting of multiple corpses with one action.

## 🔄 Compatibility

Works with any emulator using Eluna, with the provided `.diff` script ensuring full functionality.

## 📚 References

- [AOE Looting in Mist of Pandaria](https://wowwiki-archive.fandom.com/wiki/Area_of_Effect_looting)

## 🛠️ Contribution

1. **Fork**, **Clone**, **Create a branch**, **Commit**, **Push**, **Create a PR**.
2. Report issues in the issue tracker.
3. You can [sponsor](https://github.com/sponsors/ithorgrim) my work!

## 📜 License

Licensed under GNU GPL v3. See the LICENSE file.

## 📝 Credits

Readme generated with the help of ChatGPT.  
Contributors: [@iThorgrim](https://github.com/iThorgrim), [@Niam5](https://github.com/Niam5), [@Intemporel](https://github.com/Intemporel)
