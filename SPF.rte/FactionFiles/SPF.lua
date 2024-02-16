-- Space Pirates http://forums.datarealms.com/viewtopic.php?f=61&t=45173 by Major, revamped by pawnis
-- Faction file by weegee, redone by pawnis
-- 
-- Unique Faction ID
local factionid = "Space Pirates";
print ("Loading "..factionid)

CF_Factions[#CF_Factions + 1] = factionid

CF_FactionNames[factionid] = "Space Pirates";
CF_FactionDescriptions[factionid] = "Arr! The Space Pirate Federation is here to lay claim to yer booty!";
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
CF_ActDescriptions[factionid][i] = "Average chump fuelled by hopes, dreams, loot, and booty - not necessarily in that order."
CF_ActUnlockData[factionid][i] = 0
CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
CF_ActPowers[factionid][i] = 3

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Armoured Federal Privateer"
CF_ActPresets[factionid][i] = "Armoured Federal Privateer"
CF_ActModules[factionid][i] = "SPF.rte"
CF_ActPrices[factionid][i] = 120
CF_ActDescriptions[factionid][i] = "Federal privateer in crude metal armor."
CF_ActUnlockData[factionid][i] = 1200
CF_ActTypes[factionid][i] = CF_ActorTypes.HEAVY;
CF_ActPowers[factionid][i] = 6

i = #CF_ActNames[factionid] + 1
CF_ActNames[factionid][i] = "Ohklar"
CF_ActPresets[factionid][i] = "Ohklar"
CF_ActModules[factionid][i] = "SPF.rte"
CF_ActPrices[factionid][i] = 250
CF_ActDescriptions[factionid][i] = "It might look funny, but this blue alien frog is probably tougher than you."
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

-- Base actors and items (automatic stuff, no need to change these unless you want to)

local baseActors = {};
baseActors[#baseActors + 1] = {presetName = "Medic Drone", class = "ACrab", unlockData = 1000, actorPowers = 0};

local baseItems = {};
baseItems[#baseItems + 1] = {presetName = "Remote Explosive", class = "TDExplosive", unlockData = 500, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Anti Personnel Mine", class = "TDExplosive", unlockData = 900, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Light Digger", class = "HDFirearm", unlockData = 0, itemPowers = 1, weaponType = CF_WeaponTypes.DIGGER};
baseItems[#baseItems + 1] = {presetName = "Medium Digger", class = "HDFirearm", unlockData = 600, itemPowers = 3, weaponType = CF_WeaponTypes.DIGGER};
baseItems[#baseItems + 1] = {presetName = "Heavy Digger", class = "HDFirearm", unlockData = 1200, itemPowers = 5, weaponType = CF_WeaponTypes.DIGGER};
baseItems[#baseItems + 1] = {presetName = "Detonator", class = "HDFirearm", unlockData = 500, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Grapple Gun", class = "HDFirearm", unlockData = 1100, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Medikit", class = "HDFirearm", unlockData = 700, itemPowers = 3};
baseItems[#baseItems + 1] = {presetName = "Disarmer", class = "HDFirearm", unlockData = 900, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Constructor", class = "HDFirearm", unlockData = 1000, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Scanner", class = "HDFirearm", unlockData = 600, itemPowers = 0};
baseItems[#baseItems + 1] = {presetName = "Riot Shield", class = "HeldDevice", unlockData = 500, itemPowers = 1};
-- Add said actors and items
for j = 1, #baseActors do
	local actor;
	i = #CF_ActNames[factionid] + 1
	if baseActors[j].class == "ACrab" then
		actor = CreateACrab(baseActors[j].presetName, "Base.rte");
		CF_ActTypes[factionid][i] = CF_ActorTypes.ARMOR;
		CF_ActOffsets[factionid][i] = Vector(0, 12);
	elseif baseActors[j].class == "AHuman" then
		actor = CreateAHuman(baseActors[j].presetName, "Base.rte");
		CF_ActTypes[factionid][i] = CF_ActorTypes.LIGHT;
	end
	if actor then
		CF_ActNames[factionid][i] = actor.PresetName
		CF_ActPresets[factionid][i] = actor.PresetName
		CF_ActModules[factionid][i] = "Base.rte"
		CF_ActPrices[factionid][i] = actor:GetGoldValue(0, 1, 1)
		CF_ActDescriptions[factionid][i] = actor.Description
		
		CF_ActUnlockData[factionid][i] = baseActors[j].unlockData
		CF_ActPowers[factionid][i] = baseActors[j].actorPowers
		CF_ActClasses[factionid][i] = actor.ClassName;
		DeleteEntity(actor)
	end
end
for j = 1, #baseItems do
	local item;
	i = #CF_ItmNames[factionid] + 1
	if baseItems[j].class == "TDExplosive" then
		item = CreateTDExplosive(baseItems[j].presetName, "Base.rte");
		CF_ItmTypes[factionid][i] = baseItems[j].weaponType and baseItems[j].weaponType or CF_WeaponTypes.GRENADE
	elseif baseItems[j].class == "HDFirearm" then
		item = CreateHDFirearm(baseItems[j].presetName, "Base.rte");
		CF_ItmTypes[factionid][i] = baseItems[j].weaponType and baseItems[j].weaponType or CF_WeaponTypes.TOOL
	elseif baseItems[j].class == "HeldDevice" then
		item = CreateHeldDevice(baseItems[j].presetName, "Base.rte");
		CF_ItmTypes[factionid][i] = baseItems[j].weaponType and baseItems[j].weaponType or CF_WeaponTypes.SHIELD
	end
	if item then
		CF_ItmNames[factionid][i] = item.PresetName
		CF_ItmPresets[factionid][i] = item.PresetName
		CF_ItmModules[factionid][i] = "Base.rte"
		CF_ItmPrices[factionid][i] = item:GetGoldValue(0, 1, 1)
		CF_ItmDescriptions[factionid][i] = item.Description
		CF_ItmClasses[factionid][i] = item.ClassName;
		
		CF_ItmUnlockData[factionid][i] = baseItems[j].unlockData
		CF_ItmPowers[factionid][i] = baseItems[j].itemPowers
		DeleteEntity(item)
	end
end

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "DP-T Plasma Cutter"
CF_ItmPresets[factionid][i] = "DP-T Plasma Cutter"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Cheaply modified plasma cutter. Particularly good at cutting anything that isn't metal."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.DIGGER;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "DP 9 Blast Shield"
CF_ItmPresets[factionid][i] = "DP 9 Blast Shield"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Repurposed mining blastshield - understandably extra-resilient against explosions."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHIELD;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Rum"
CF_ItmPresets[factionid][i] = "Rum"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Rum!"
CF_ItmUnlockData[factionid][i] = 100
CF_ItmClasses[factionid][i] = "HeldDevice"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.TOOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Cutlass"
CF_ItmPresets[factionid][i] = "Cutlass"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 15
CF_ItmDescriptions[factionid][i] = "They used these for a reason, but now guns are used instead for a reason too."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "QzBf G-9"
CF_ItmPresets[factionid][i] = "QzBf G-9"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Tiny pistol. For when you have little else."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Harrier PPt"
CF_ItmPresets[factionid][i] = "Harrier PPt"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 20
CF_ItmDescriptions[factionid][i] = "Solid, punchy handgun."
CF_ItmUnlockData[factionid][i] = 150
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "S&W 400 M"
CF_ItmPresets[factionid][i] = "S&W 400 M"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Old-fashioned revolving-cylinder hand cannon."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "T9 Frag"
CF_ItmPresets[factionid][i] = "T9 Frag"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 5
CF_ItmDescriptions[factionid][i] = "Frag grenade- V to cook."
CF_ItmUnlockData[factionid][i] = 200
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 2

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "INCIN-2 Popcorn"
CF_ItmPresets[factionid][i] = "INCIN-2 Popcorn"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 10
CF_ItmDescriptions[factionid][i] = "Incendiary grenade - V to cook."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmClasses[factionid][i] = "TDExplosive"
CF_ItmTypes[factionid][i] = CF_WeaponTypes.GRENADE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "BnM-4"
CF_ItmPresets[factionid][i] = "BnM-4"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Wood-furniture bolt-action. We'd call it antique if it wasn't still being made."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AXt-C48"
CF_ItmPresets[factionid][i] = "AXt-C48"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "A rather large bolt-action sniper that comes with a scope."
CF_ItmUnlockData[factionid][i] = 450
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SNIPER;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "StG 66-F"
CF_ItmPresets[factionid][i] = "StG 66-F"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A semi-auto carbine, cobbled together out of other designs. Decent."
CF_ItmUnlockData[factionid][i] = 0
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MPt-8 Duster"
CF_ItmPresets[factionid][i] = "MPt-8 Duster"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Cheap and effective open-bolt SMG - dirt cheap to manufacture."
CF_ItmUnlockData[factionid][i] = 350
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 3

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "TMP"
CF_ItmPresets[factionid][i] = "TMP"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "High-quality, compact SMG."
CF_ItmUnlockData[factionid][i] = 800
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AGK35"
CF_ItmPresets[factionid][i] = "AGK35"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 40
CF_ItmDescriptions[factionid][i] = "A powerful, but inaccurate assault rifle. A reliable addition to any arsenal."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 4

--i = #CF_ItmNames[factionid] + 1
-- CF_ItmNames[factionid][i] = "AGK37 Mod 4"
-- CF_ItmPresets[factionid][i] = "AGK37 Mod 4"
-- CF_ItmModules[factionid][i] = "SPF.rte"
-- CF_ItmPrices[factionid][i] = 80
-- CF_ItmDescriptions[factionid][i] = "A powerful, but inaccurate assault rifle. A staple gun in the Federation's varied arsenal."
-- CF_ItmUnlockData[factionid][i] = 1200
-- CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
-- CF_ItmPowers[factionid][i] = 4

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AN-Mag"
CF_ItmPresets[factionid][i] = "AN-Mag"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 50
CF_ItmDescriptions[factionid][i] = "The more plastic an assault rifle has, the better it is, right? This is a testament to that notion."
CF_ItmUnlockData[factionid][i] = 1400
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 5

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MD M27A2"
CF_ItmPresets[factionid][i] = "MD M27A2"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "45 watt plasma burst rifle featuring high accuracy and damage output."
CF_ItmUnlockData[factionid][i] = 2000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.RIFLE;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "AutoMag D-9"
CF_ItmPresets[factionid][i] = "AutoMag D-9"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 80
CF_ItmDescriptions[factionid][i] = "The resourceful man's intermediate-cartridge LMG."
CF_ItmUnlockData[factionid][i] = 1750
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 7

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "B-3"
CF_ItmPresets[factionid][i] = "B-3"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 150
CF_ItmDescriptions[factionid][i] = "A super-heavy machinegun. Just lugging this thing around is tough, let alone firing it!"
CF_ItmUnlockData[factionid][i] = 2500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 9

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "ARk Riot"
CF_ItmPresets[factionid][i] = "ARk Riot"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 60
CF_ItmDescriptions[factionid][i] = "Reliable and powerful riot shotgun. Can be braced against a shield."
CF_ItmUnlockData[factionid][i] = 600
CF_ItmTypes[factionid][i] = CF_WeaponTypes.SHOTGUN;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "StPl 251"
CF_ItmPresets[factionid][i] = "StPl 251"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 90
CF_ItmDescriptions[factionid][i] = "A very basic grenade launcher."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 6

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "MKII Harksburg Flarepistol"
CF_ItmPresets[factionid][i] = "MKII Harksburg Flarepistol"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 30
CF_ItmDescriptions[factionid][i] = "Robust 35mm flaregun for signaling purposes. Not useful against metallic enemies."
CF_ItmUnlockData[factionid][i] = 500
CF_ItmTypes[factionid][i] = CF_WeaponTypes.PISTOL;
CF_ItmPowers[factionid][i] = 0

i = #CF_ItmNames[factionid] + 1
CF_ItmNames[factionid][i] = "Flammenwerfer K-12 P"
CF_ItmPresets[factionid][i] = "Flammenwerfer K-12 P"
CF_ItmModules[factionid][i] = "SPF.rte"
CF_ItmPrices[factionid][i] = 100
CF_ItmDescriptions[factionid][i] = "Flamethrower with a jury-rigged detachable canister. Doesn't burn hot enough for metallic enemies."
CF_ItmUnlockData[factionid][i] = 1000
CF_ItmTypes[factionid][i] = CF_WeaponTypes.HEAVY;
CF_ItmPowers[factionid][i] = 0
