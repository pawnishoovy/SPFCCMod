To enable preset actors in the buy menu, remove the double forward
slash ("//") from the last line of the .ini file "Index" in the folder
"Actors".

ie:

IncludeFile = SPF.rte/Actors/Droids/Droids Effects.ini
IncludeFile = SPF.rte/Actors/Droids/Droids.ini
IncludeFile = SPF.rte/Actors/Infantry/Infantry Effects.ini
IncludeFile = SPF.rte/Actors/Infantry/Infantry.ini
IncludeFile = SPF.rte/Actors/Ohklar/Ohklar Effects.ini
IncludeFile = SPF.rte/Actors/Ohklar/Ohklar.ini
//IncludeFile = SPF.rte/Actors/Infantry Variants.ini

Will change to:

IncludeFile = SPF.rte/Actors/Droids/Droids Effects.ini
IncludeFile = SPF.rte/Actors/Droids/Droids.ini
IncludeFile = SPF.rte/Actors/Infantry/Infantry Effects.ini
IncludeFile = SPF.rte/Actors/Infantry/Infantry.ini
IncludeFile = SPF.rte/Actors/Ohklar/Ohklar Effects.ini
IncludeFile = SPF.rte/Actors/Ohklar/Ohklar.ini
IncludeFile = SPF.rte/Actors/Infantry Variants.ini


Note:

Preset actors may cause slight problems in scenario activites where
the game loads a preset actor and gives them a double complement of
guns, bombs and tools. This would lead to the actor being unable to
fly due to being weighted down excessively.