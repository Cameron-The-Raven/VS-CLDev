/datum/component/towing_link
	VAR_PRIVATE/atom/movable/owner_atom
	VAR_PRIVATE/train_length = 0
	VAR_PRIVATE/datum/component/towing_link/lead
	VAR_PRIVATE/datum/component/towing_link/tow

/datum/component/towing_link/Initialize()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	owner_atom = parent
	RegisterSignal(owner_atom, COMSIG_TOWING_CONNECT, PROC_REF(handle_hitch_to_next))
	RegisterSignal(owner_atom, COMSIG_TOWING_DISCONNECT, PROC_REF(handle_disconnect))
	RegisterSignal(owner_atom, COMSIG_TOWING_REBUILD, PROC_REF(handle_rebuild))
	RegisterSignal(owner_atom, COMSIG_QDELETING, PROC_REF(handle_rebuild))

/datum/component/towing_link/Destroy()
	UnregisterSignal(owner_atom, COMSIG_TOWING_CONNECT)
	UnregisterSignal(owner_atom, COMSIG_TOWING_DISCONNECT)
	UnregisterSignal(owner_atom, COMSIG_TOWING_REBUILD)
	UnregisterSignal(owner_atom, COMSIG_QDELETING)
	owner_atom = null
	. = ..()

/////////////////////////////////////////////////////////////////////////
// Signal handlers
/////////////////////////////////////////////////////////////////////////
/datum/component/towing_link/proc/handle_hitch_to_next(atom/movable/C, mob/user)
	SIGNAL_HANDLER

	// Check if we are still valid when rebuilding
	if(QDELETED(owner_atom))
		return
	// Check if towing target is valid
	if(QDELETED(C))
		return
	var/datum/component/towing_link/tow_target = C?.GetComponent(/datum/component/towing_link)
	if(!tow_target)
		return
	// Check for automatic hitching with no user
	if(!user)
		attach_to(tow_target, null)
		return TRUE

	// User hitching action
	if(get_dist(owner_atom, C) > 1)
		to_chat(user, span_warning("[owner_atom] is too far away from [C] to hitch them together."))
		return FALSE
	if(tow_target.lead)
		to_chat(user, span_warning("[owner_atom] is already hitched to something."))
		return
	if(tow_target.tow)
		to_chat(user, span_warning("[C] is already towing something."))
		return

	//check for endless loops
	var/obj/vehicle/train/next_car = C
	while(next_car)
		if(next_car == owner_atom)
			to_chat(user, span_danger("That seems very silly."))
			return
		var/datum/component/towing_link/next_tow = next_car?.GetComponent(/datum/component/towing_link)
		next_car = next_tow?.lead?.owner_atom

	// Actually hitch
	attach_to(tow_target, user)

/datum/component/towing_link/proc/handle_disconnect(list/affected_atoms, mob/user)
	SIGNAL_HANDLER

	// Check if we should bother
	if(!lead)
		if(user)
			to_chat(user, span_warning("[owner_atom] is not hitched to anything."))
		return

	// Report who is affected
	if(islist(affected_atoms))
		affected_atoms |= owner_atom
		affected_atoms |= lead.owner_atom

	// Disconnect us
	if(user)
		to_chat(user, span_notice("You unhitch [owner_atom] from [lead.owner_atom]."))
	lead.tow = null
	lead = null

/// Informs the entire train of towing objects to reconnect their chain.
/datum/component/towing_link/proc/handle_rebuild()
	SIGNAL_HANDLER

	// Get all ahead of us
	var/list/all_components_in_train = list()
	var/obj/vehicle/train/next_car = src
	while(next_car)
		next_car = next_car.lead
		if(next_car)
			all_components_in_train += next_car
	// Now behind..
	next_car = src
	while(next_car)
		next_car = next_car.tow
		if(next_car)
			all_components_in_train += next_car
	// Finally us!
	all_components_in_train += src

	// Disconnect and reconnect them all!
	for(var/datum/component/towing_link/link in all_components_in_train)
		var/old_lead_atom = link?.lead?.owner_atom
		if(old_lead_atom)
			link.handle_disconnect(null, null)
			link.handle_hitch_to_next(old_lead_atom, null)

/////////////////////////////////////////////////////////////////////////
// Latching/unlatching procs
/////////////////////////////////////////////////////////////////////////
/datum/component/towing_link/proc/attach_to(datum/component/towing_link/target_lead, mob/user)
	lead = target_lead
	lead.tow = src
	set_dir(get_dir(get_turf(owner_atom),get_turf(lead.owner_atom)))
	if(user)
		to_chat(user, span_notice("You hitch [owner_atom] to [lead.owner_atom]."))

/datum/component/towing_link/proc/is_leader()
	if(lead)
		return FALSE
	return TRUE

/datum/component/towing_link/proc/is_tail()
	if(tow)
		return FALSE
	return TRUE

/////////////////////////////////////////////////////////////////////////
// Latching/unlatching helper procs
/////////////////////////////////////////////////////////////////////////

/// Disconnect from the towing atom we are following, verb checks for if user can do so.
/atom/movable/proc/unlatch_verb()
	RETURN_TYPE(/list) // Returns list of affected cars
	set name = "Unlatch"
	set desc = "Unhitches this train from the one in front of it."
	set category = "Vehicle"
	set src in view(1)

	if(!ishuman(usr))
		return list()
	if(!canmove || stat || restrained() || !Adjacent(usr))
		return list()
	return unlatch_towing(usr)

/// Directly disconnect from the towing atom we are following, and returns list of atoms affected by the disconnection.
/atom/movable/proc/unlatch_towing(mob/user)
	RETURN_TYPE(/list)
	var/list/disconnected_cars = list()
	SEND_SIGNAL(src, COMSIG_TOWING_DISCONNECT, disconnected_cars, user)
	return disconnected_cars
