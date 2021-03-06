# BO2-Origins-Patches

## Installation

I recommend using Redacted BO2 for these mods: https://redacted.se/

This is a good tutorial for installing Redacted: https://www.youtube.com/watch?v=clJOLuIpxR0

OriginsPatch goes in the data/scripts folder of your Redacted

zm_tomb, zm_tomb_dig, and zm_tomb_classic go in the data/maps/mp folder of your Redacted (don't rename)

\_zm_powerups goes in the data/maps/mp/zombies folder of your Redacted (don't rename)

Textures go in the data/images folder of your Redacted if you want them (don't rename)

## Details

These patches manipulate RNG for the solo easter egg speedrun. The speedrun strategy changes often, so the patches may not always be optimized for the current route. Heres a list of what each file does:

### OriginsPatch
* Zombie counter
* FOV
* Full backwards movement speed and strafe speed
* Wunderfizz location
* Wunderfizz perk order
* Box location
* Box weapons
* Weather rounds
* Optimal ice parts (works in combination with zm_tomb_dig)

### zm_tomb
* Robot cycles and feet
* Templar rounds and generators
* Optimal dials for step 3 of each staff upgrade

### zm_tomb_dig
* Dig spot spawn locations
* Zombie blood from first dig every round
* Optimal ice parts (works in combination with OriginsPatch)

### zm_tomb_classic
* Every part spawn location

### \_zm_powerups
* Drop cycles
* 4 drops at the start of every round

## FAQ 

Q - Where is the data/maps/mp folder?  
A - You will have to play at least one game of zombies on Redacted for that folder to be created. It will be located in the same directory you launch the game from.

Q - Where is the data/maps/mp/zombies folder?  
A - It doesn't get created, you will have to make the zombies folder.

Q - Do the patches work on multiplayer?  
A - Probably not, they were made to be used in solo speedruns.

Q - How to start an Origins game without the cutscene?  
A - Paste this code into the Redacted console (courtesy of Yoma's Twitch command):  
g_gametype zclassic;ui_zm_gamemodegroup zclassic;ui_zm_mapstartlocation tomb;map zm_tomb

Q - HUD isn't working and it says TranZit on the scoreboard?  
A - Use the code from the previous question right after launching Redacted, don't even press the Online button.

Q - Game crashes after a fast_restart?  
A - On Redacted, you should be using map_restart.

If you have any other questions, message me on Discord: Dank Slushie#9682
