SUBSYSTEM_DEF(chemistry)
	name = "Chemistry"
	wait = 20
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_CHEMISTRY

	var/list/chemical_reactions = list()
	var/list/instant_reactions_by_reagent = list()
	var/list/distilled_reactions_by_reagent = list()
//	var/list/fusion_reactions_by_reagent = list() // TODO: Fusion reactions as chemical reactions
	var/list/chemical_reagents = list()

	//Simple list of all atmospheric gas IDs.
	var/list/atmo_gases = list()

/datum/controller/subsystem/chemistry/Recover()
	log_debug("[name] subsystem Recover().")
	chemical_reactions = SSchemistry.chemical_reactions
	chemical_reagents = SSchemistry.chemical_reagents

/datum/controller/subsystem/chemistry/Initialize()
	initialize_chemical_reagents()
	initialize_chemical_reactions()
	initialize_gas_data()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/chemistry/stat_entry(msg)
	msg = "C: [chemical_reagents.len] | R: [chemical_reactions.len]"
	return ..()

//Chemical Reactions - Initialises all /decl/chemical_reaction into a list
// It is filtered into multiple lists within a list.
// For example:
// chemical_reactions_by_reagent[REAGENT_ID_PHORON] is a list of all reactions relating to phoron
// Note that entries in the list are NOT duplicated. So if a reaction pertains to
// more than one chemical it will still only appear in only one of the sublists.
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reactions()
	var/list/paths = decls_repository.get_decls_of_subtype(/decl/chemical_reaction)

	for(var/path in paths)
		var/decl/chemical_reaction/D = paths[path]
		chemical_reactions += D
		if(D.required_reagents && D.required_reagents.len)
			var/reagent_id = D.required_reagents[1]

			var/list/add_to = instant_reactions_by_reagent // Default to instant reactions list, if something's gone wrong
//			if(istype(D, /decl/chemical_reaction/fusion)) // TODO: fusion reactions as chemical reactions
//				add_to = fusion_reactions_by_reagent
			if(istype(D, /decl/chemical_reaction/distilling))
				add_to = distilled_reactions_by_reagent

			LAZYINITLIST(add_to[reagent_id])
			add_to[reagent_id] += D

//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/datum/controller/subsystem/chemistry/proc/initialize_chemical_reagents()
	var/paths = subtypesof(/datum/reagent)
	chemical_reagents = list()
	for(var/path in paths)
		var/datum/reagent/D = new path()
		if(!D.name)
			continue
		chemical_reagents[D.id] = D

//Gas overlays
/atom/movable/gas_visuals
	icon = 'icons/effects/tile_effects.dmi'
	mouse_opacity = 0
	plane = ABOVE_MOB_PLANE

/atom/movable/gas_visuals/Initialize(mapload, ico)
	. = ..()
	icon_state = ico

//Chemical Gasses - Initialises all atmospheric gasses
/datum/controller/subsystem/chemistry/proc/initialize_gas_data()
	for(var/key in chemical_reagents)
		var/datum/reagent/gas = chemical_reagents[key]
		if(gas.id in atmo_gases)
			error("Duplicate gas id `[gas.id]`")
			continue
		if(gas.atmo_flags & IS_XGM_GAS)
			atmo_gases[gas.id] = gas
			gas.tile_overlay = new /atom/movable/gas_visuals(null, gas.id)

/datum/controller/subsystem/chemistry/proc/get_gas_name(var/id)
	if(!atmo_gases[id])
		return "?"
	var/datum/reagent/gas = atmo_gases[id]
	return gas.name

/datum/controller/subsystem/chemistry/proc/get_gas_flags(var/id)
	if(!atmo_gases[id])
		return 0
	var/datum/reagent/gas = atmo_gases[id]
	return gas.atmo_flags

/datum/controller/subsystem/chemistry/proc/get_gas_overlay_threshold(var/id)
	if(!atmo_gases[id])
		return INFINITY
	var/datum/reagent/gas = atmo_gases[id]
	return gas.overlay_limit

/datum/controller/subsystem/chemistry/proc/get_gas_overlay(var/id)
	if(!atmo_gases[id])
		return null
	var/datum/reagent/gas = atmo_gases[id]
	return gas.tile_overlay

/datum/controller/subsystem/chemistry/proc/get_gas_specific_heat(var/id)
	if(!atmo_gases[id])
		return 0
	var/datum/reagent/gas = atmo_gases[id]
	return gas.specific_heat

/datum/controller/subsystem/chemistry/proc/get_gas_molar_mass(var/id)
	if(!atmo_gases[id])
		return 0
	var/datum/reagent/gas = atmo_gases[id]
	return gas.molar_mass
