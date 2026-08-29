# Productive Animal Backyards

**2× faster vanilla animal backyard production for Manor Lords 0.8.104.**

Productive Animal Backyards reduces the vanilla production cycle of **Chicken Coops, Goat Pens, and Pig Pens** while preserving the game's original output quantities and production logic.

## What it changes

| Production | Vanilla | Modded |
|---|---:|---:|
| Eggs | 30 days | **15 days** |
| Chicken | ~120 days | **~60 days** |
| Milk | 49 days | **~25 days** |
| Chevon + Hides | 147 days | **~75 days** |
| Pig base cycle | 73 days | **36.5 days** |

Vanilla quantities remain unchanged. Pannage, perks, affinities, yield modifiers, storage, inventory, Production Tracker and byproduct progression remain vanilla.

Apiaries are intentionally not modified.

## Requirements

- Manor Lords **0.8.104**
- Windows
- UE4SS is **not required**

## Automatic installation

1. Download the latest **Automatic Installer** from the GitHub Releases page.
2. Extract it into `ManorLords\Binaries\Win64\`.
3. Double-click `Install_ProductiveAnimalBackyards.bat`.
4. Launch Manor Lords normally.

The installer verifies the exact supported executable and creates a **version-specific vanilla backup** before patching.

## Uninstall

Double-click `Uninstall_ProductiveAnimalBackyards.bat`.

The current 0.8.104 backup is stored as:

`ManorLords-Win64-Shipping.exe.ProductiveAnimalBackyards.0.8.104.bak`

Older backups are left untouched.

## Security and transparency

The complete installer source code is available in this repository.

The installer:
- does **not** include or redistribute the Manor Lords executable
- does **not** download anything
- does **not** access the network
- does **not** disable antivirus
- does **not** request administrator privileges
- verifies the exact supported executable before patching
- creates and verifies a vanilla backup
- writes only the three verified 4-byte patch locations
- verifies the final patched executable

Because it modifies the user's local game executable, some antivirus products may still report a heuristic warning.

**Do not disable your antivirus if you are uncomfortable running it.** Use the script-free BPS version from Nexus Mods instead.

## Supported executable

Manor Lords 0.8.104 vanilla:

`813c4909dbe8bef3481469137c66f35cc23dec11c145b6963c4739b41539e621`

Patched:

`e1321b736be4bf4f9d3f4dbfbee9968dffb09c157be1a0d14c316683d6d77513`

## Game updates

This release supports **Manor Lords 0.8.104 only**.

Do not force it onto a newer build and never restore an old game-version backup over a newer executable.

## Disclaimer

Unofficial fan-made modification. Not affiliated with or endorsed by the developers or publisher of Manor Lords.
