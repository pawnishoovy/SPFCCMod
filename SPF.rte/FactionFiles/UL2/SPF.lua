-- Space Pirates http://forums.datarealms.com/viewtopic.php?f=61&t=45173 by Major
-- Faction file by weegee
-- 
-- Unique Faction ID
local factionid = "Space Pirates";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "Space Pirates";
CF_FactionDescriptions[factionid] = "Aarr! The Space Pirate Federation is here to lay claim to yer booty!";
CF_FactionPlayable[factionid] = true;

CF_RequiredModules[factionid] = {"SPF.rte"}
-- Available values ORGANIC, SYNTHETIC
CF_FactionNatures[factionid] = CF_FactionTypes.ORGANIC;

-- Define faction bonuses, in percents
-- Scan price reduction
CF_ScanBonuses[factionid] = 75
-- Relation points increase
CF_RelationsBonuses[factionid] = 200
-- New HQ build price reduction
CF_ExpansionBonuses[factionid] = 0

-- Gold per turn increase
CF_MineBonuses[factionid] = 0
-- Science per turn increase
CF_LabBonuses[factionid] = 0
-- Delivery time reduction
CF_AirfieldBonuses[factionid] = 0
-- Superweapon targeting reduction
CF_SuperWeaponBonuses[factionid] = 0
-- Unit price reduction
CF_FactoryBonuses[factionid] = 0
-- Body price reduction
CF_CloneBonuses[factionid] = 0
-- HP regeneration increase
CF_HospitalBonuses[factionid] = 0

-- Define brain unit
CF_Brains[factionid] = "Salvaged UA-056 Minuteman Brainbot";
CF_BrainModules[factionid] = "SPF.rte";
CF_BrainClasses[factionid] = "AHuman";
CF_BrainPrices[factionid] = 600;

-- Define dropship
CF_Crafts[factionid] = "CarryCorps He-88 Taurus LCC";
CF_CraftModules[factionid] = "SPF.rte";
CF_CraftClasses[factionid] = "ACDropShip";
CF_CraftPrices[factionid] = 380;

-- Define superweapon script
CF_SuperWeaponScripts[factionid] = "UnmappedLands2.rte/SuperWeapons/DummyParticle.lua"

-- Define buyable actors available for purchase or unlocks
CF_ActNames[factionid] = {}
CF_ActPresets[factionid] = {}
CF_ActModules[factionid] = {}
CF_ActPrices[factionid] = {}
CF_ActDescriptions[factionid] = {}
CF_ActUnlockData[factionid] = {}
CF_ActClasses[factionid] = {}
CF_ActTypes[factionid] = {}
CF_ActPowers[factionid] = {}
CF_ActOffsets[factionid] = {}

local i = 0
i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Federal Privateer"
CF_ActPresets[factionid][i] = "Federal Privateer"
CF_ActModules[factionid][i] = "SPF.rte"
CF_ActPrices[factionid][i] = 90
CF_ActDescriptions[factionid][i] = "A generic scumbag who decided to stop wasting his life away in some dingy cantina and joined up on a Federation Privateer Vessel on a quest for loot and booty."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Armoured Federal Privateer"
CF_ActPresets[factionid][i] = "Armoured Federal Privateer"
CF_ActModules[factionid][i] = "SPF.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "Federal Privateers that have kitted themselves out in crude plate armour. They cost more but it's worth it."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Ohklar"
CF_ActPresets[factionid][i] = "Ohklar"
CF_ActModules[factionid][i] = "SPF.rte"
CF_ActPrices[factionid][i] = 250
CF_ActDescriptions[factionid][i] = "Ohklar are large brutish creatures evolved from type of alien frog with stony rough skin. They are exceptionally strong and tough to kill, you'd better hope it's on your side."
CF_ActUnlockData[factionid][i] = 2500
CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
CF_ActPowers[factionid][i] = 8

-- Define buyable items available for purchase or unlocks
CF_ItmNames[factionid] = {}
CF_ItmPresets[factionid] = {}
CF_ItmModules[factionid] = {}
CF_ItmPrices[factionid] = {}
CF_ItmDescriptions[factionid] = {}
CF_ItmUnlockData[factionid] = {}
CF_ItmClasses[factionid] = {}
CF_ItmTypes[factionid] = {}
CF_ItmPowers[factionid] = {} -- AI will select weapons based on this value 1 - weakest, 10 toughest, 0 never use

-- Available weapon types
-- PISTOL, RIFLE, SHOTGUN, SNIPER, HEAVY, SHIELD, DIGGER, GRENADE

local i = 0
i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "DP-T Plasma Cutter"
CF_ItmPresets[factionid][i] = "DP-T Plasma Cutter"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A knockoff plasma cutter with its safety field removed, cuts throuck rock and earth but the less concentrated plasma has a hard time going through reinforced steel."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "DP 9 Blast Shield"
CF_ItmPresets[factionid][i] = "DP 9 Blast Shield"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "A repurposed mining blastshield fitted with carrying handles for heavy assaults. Can take one Helluva beating but is seriously heavy."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Light Scanner"
CF_ItmPresets[factionid][i] = "Light Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Lightest in the scanner family. Cheapest of them all and can only scan a small area."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Medium Scanner"
CF_ItmPresets[factionid][i] = "Medium Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "Medium scanner. This scanner is stronger and can reveal a larger area."
CF_ItmUnlockData[factionid][i] = 250
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Heavy Scanner"
CF_ItmPresets[factionid][i] = "Heavy Scanner"
CF_ItmModules[factionid][i] = "Base.rte"
CF_ItmPrices[factionid][i] = 70
CF_ItmDescriptions[factionid][i] = "Strongest scanner out of the three. Can reveal a large area."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "QzBf G-9"
CF_ItmPresets[factionid][i] = "QzBf G-9"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "A cheap blackmarket pistol, usually the first thing an enterprising Federal Privateer buys."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Harrier PPt"
CF_ItmPresets[factionid][i] = "Harrier PPt"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "A solid handgun that packs a punch, it's also a bit of a status symbol among the Privateers, each usually having hand tooled custom furniture and fittings."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "S&W 400 M"
CF_ItmPresets[factionid][i] = "S&W 400 M"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A powerful old revolver of higher quality than most weapons found in Privateer possession."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "T9 Frag"
CF_ItmPresets[factionid][i] = "T9 Frag"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "The most basic grenade, 3 second fuse."
CF_ItmUnlockData[factionid][i] = 200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "INCIN-2 Popcorn"
CF_ItmPresets[factionid][i] = "INCIN-2 Popcorn"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "The Popcorn grenade releases a blast of incendiary powder that burns at extremely high temperatures, guaranteed to crisp biologicals to a cinder."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "BnM-4"
CF_ItmPresets[factionid][i] = "BnM-4"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A basic rifle easily manufacured on backwoods planets due to the simple design."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "BnM-4 JSu 3x"
CF_ItmPresets[factionid][i] = "BnM-4 JSu 3x"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "A BnM-4 rifle with a JSu 3x optical zoom scope. The scopes are usually scavenged from low tech planets, making them expensive."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "StG 66-F"
CF_ItmPresets[factionid][i] = "StG 66-F"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A semi-auto carbine seemingly cobbled together out of other designs. Fairly accurate and with decent stopping power."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MPt-8 Duster"
CF_ItmPresets[factionid][i] = "MPt-8 Duster"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A cheap but effective close quarters SMG. Larger corporations are constantly trying to halt production of these cheap undercutting guns but new gunsmithies keep popping up, churning out hundreds of MPt-8s."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TMP"
CF_ItmPresets[factionid][i] = "TMP"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A high quality SMG that is smaller and more compact than the MPt-8."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AGK35"
CF_ItmPresets[factionid][i] = "AGK35"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A powerful but inaccurate assault rifle. A staple gun in the Federation's varied arsenal."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AGK37 Mod 4"
CF_ItmPresets[factionid][i] = "AGK37 Mod 4"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "A powerful but inaccurate assault rifle. A staple gun in the Federation's varied arsenal."
CF_ItmUnlockData[factionid][i] = 1200
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AN-Mag"
CF_ItmPresets[factionid][i] = "AN-Mag"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "One of the best assault rifles a Federal Privateer has acces to, accurate and powerfull, but it comes at a price."
CF_ItmUnlockData[factionid][i] = 1400
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AN-Mag AG5"
CF_ItmPresets[factionid][i] = "AN-Mag AG5"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "This modification of the AN-Mag comes with an underslung AG5 grenade launcher."
CF_ItmUnlockData[factionid][i] = 1600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MD M27A2"
CF_ItmPresets[factionid][i] = "MD M27A2"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "A 45 watt plasma burst rifle featuring high acuraccy and high damage output. These weapons are manufactured in an autofactory discovered by a Privateer captain under the ruins of a desolated world."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AutoMag D-9"
CF_ItmPresets[factionid][i] = "AutoMag D-9"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "The most common LMG found on Federation vessels. The D-9 is a gas-operated machinegun with a 50 round 5.5x45mm drum magazine firing at 900 RPM. An effective support weapon but lacking in long range accuracy."
CF_ItmUnlockData[factionid][i] = 1750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "B-3"
CF_ItmPresets[factionid][i] = "B-3"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "A massive heavy machine gun that should be mounted on a tank or something, why are you carrying this? It weighs more than I do!"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ARk Riot"
CF_ItmPresets[factionid][i] = "ARk Riot"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Reliable and powerful riot shotgun, ideal for close quarters fights. Works well with a DP 9 Blast-Shield."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "StPl 251"
CF_ItmPresets[factionid][i] = "StPl 251"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "A very basic grenade launcher that is light and simple to use. Can fire either frag or incendiary grenades."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MKII Harksburg Flarepistol"
CF_ItmPresets[factionid][i] = "MKII Harksburg Flarepistol"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "A robust 35mm flaregun for signaling purposes, as a distress beacon, etc. Will burn flesh easily but is practically useless against metal. Some privateers have learned to fire shattered flares out of the gun to produce an incendiary shotgun effect."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Flammenwerfer K-12 P"
CF_ItmPresets[factionid][i] = "Flammenwerfer K-12 P"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "A flamethrower that has a small drum of fuel attatched to the fore grip, for those not suicidal enough to walk around with a backpack full of fuel. Extremely good against flesh, but absolutely terrible against steel."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0
