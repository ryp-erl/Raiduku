<img src="https://github.com/ryp-erl/assets/blob/main/Raiduku/rdk_logo.jpg?raw=true" width=50 align="right" />

![version](https://img.shields.io/github/v/release/ryp-erl/Raiduku)
[![wiki](https://img.shields.io/badge/read-wiki-green)](https://github.com/ryp-erl/Raiduku/wiki)
[![issues](https://img.shields.io/badge/report-issues-blueviolet)](https://github.com/ryp-erl/Raiduku/issues)
[![curseforge](https://img.shields.io/badge/visit%20on-curseforge-orange)](https://www.curseforge.com/wow/addons/raiduku/)

# Raiduku

Minimalist World of Warcraft addon to help raid leaders managing loots in Wrath of Lich King Classic.

## Why this addon?

- Not every raider needs to install it. Only the one managing loots.
- Not intrusive. You can still attribute loot manually.
- Supports +1 system, automatically order and designate the winner.
- Supports [thatsmybis.com](https://thatsmybis.com) (TMB) allowing you to import prios and export loot history (even if manually attributed).
- Supports [softres.it](https://softres.it) (SR).

## What's new?

With the version 2.0.0:

- **New UI** using [ScrollingTable](https://www.curseforge.com/wow/addons/lib-st) : automatic sorting works the same (+1 / +2, prios and softres) and the first row is automatically selected to attribute to the winner. But in some cases, people are passing or you need to balance loot and the first might not be the one awarded. So now you can select any row and click attribute loot.
- **New info** : you can now see how many loots for they main spec players have already looted which greatly helps in quick decision making.
- **New info and action** : you can now see when an item is BoE without having to check the tooltip. When you click on "Recycle loot" it will send it to the ML instead of the recycler.
- **Fixes** : players should now be properly removed from the imported softres or prios when awarded loots.

![rdk_new_ui](https://github.com/ryp-erl/assets/blob/main/Raiduku/raiduku-2.0.png?raw=true)

## Documentation

Checkout the [Wiki](https://github.com/En-Roue-Libre/Raiduku/wiki) for more information on how to use this addon.

## Other addons:

- [AutoLoggerWotlk](https://www.curseforge.com/wow/addons/autologgerwotlk): Automatically start combat logging when entering a Wotlk raid.

## License

[GNU GPLv3](LICENSE)