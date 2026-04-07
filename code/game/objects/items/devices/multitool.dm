/**
 * Multitool -- A multitool is used for hacking electronic devices.
 * TO-DO -- Using it as a power measurement tool for cables etc. Nannek.
 *
 */

/obj/item/multitool
	name = "multitool"
	desc = "Used for pulsing wires to test which to cut. Not recommended by doctors."
	description_info = "You can use this on airlocks or APCs to try to hack them without cutting wires."
	icon = 'icons/obj/device.dmi'
	icon_state = "multitool"
	force = 5.0
	w_class = ITEMSIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3
	drop_sound = 'sound/items/drop/multitool.ogg'
	pickup_sound = 'sound/items/pickup/multitool.ogg'

	matter = list(MAT_STEEL = 50,MAT_GLASS = 20)

	var/mode_index = 1
	var/toolmode = MULTITOOL_MODE_STANDARD
	var/list/modes = list(MULTITOOL_MODE_STANDARD, MULTITOOL_MODE_INTCIRCUITS)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	toolspeed = 1
	tool_qualities = list(TOOL_MULTITOOL)

	VAR_PRIVATE/datum/weakref/buffer // simple machine buffer for device linkage
	var/weakref_wiring //Used to store weak references for integrated circuitry. This is now the Omnitool.

	var/uplink = FALSE

/// Stores a buffered link to a datum or atom to be linked to another object
/obj/item/multitool/proc/set_buffered_link(mob/user, datum/thing)
	if(thing == null)
		buffer = null
		if(user)
			to_chat(user, span_notice("You clear \the [src]'s buffer!"))
		update_icon()
		return
	buffer = WEAKREF(thing)
	if(user)
		to_chat(user, span_notice("You copied \the [thing] into \the [src]'s buffer!"))
	update_icon()

/// Gets the datum or atom currently stored in the multitool's buffer
/obj/item/multitool/proc/get_buffered_link()
	RETURN_TYPE(/atom)
	var/atom/atom_buff = buffer?.resolve()
	if(QDELETED(atom_buff))
		return null
	return atom_buff

/// Returns true if the buffer currently holds a datum of the type type/subtype provided
/obj/item/multitool/proc/filter_buffer(mob/user, expected_typepath)
	var/atom/atom_buff = buffer?.resolve()
	if(!istype(atom_buff, expected_typepath))
		if(user)
			var/atom/as_atom = expected_typepath // MUST BE ATOMS, DO NOT USE THIS TO FILTER FOR DATUMS LIKE TECHWEB LINKS
			to_chat(user, span_warning("Error: Buffer is either empty, or object in buffer is invalid. Requires \a [initial(as_atom.name)]"))
		return FALSE
	return TRUE

/obj/item/multitool/proc/state_buffer(mob/user)
	var/atom/atom_buff = get_buffered_link()
	to_chat(user, span_notice("The buffer is [atom_buff ? atom_buff : "empty"]"))

/obj/item/multitool/Destroy()
	. = ..()
	buffer = null

/obj/item/multitool/attack_self(mob/living/user)
	. = ..(user)
	if(.)
		return TRUE
	if(uplink)
		return

	if(selected_io)
		selected_io = null
		to_chat(user, span_notice("You clear the wired connection from the multitool."))
		update_icon()
		return

	update_icon()
	state_buffer(user)
	var/choice = tgui_alert(user, "What do you want to do with \the [src]?", "Multitool Menu", list("Switch Mode", "Clear Buffers", "Cancel"))
	switch(choice)
		if("Clear Buffers")
			set_buffered_link(user, null)
			weakref_wiring = null
			accepting_refs = 0
			if(toolmode == MULTITOOL_MODE_INTCIRCUITS)
				accepting_refs = 1
		if("Switch Mode")
			mode_switch(user)
		else
			to_chat(user,span_notice("You lower \the [src]."))
			return

	update_icon()

/obj/item/multitool/proc/mode_switch(mob/living/user)
	if(mode_index + 1 > modes.len) mode_index = 1

	else
		mode_index += 1

	toolmode = modes[mode_index]
	to_chat(user,span_notice("\The [src] is now set to [toolmode]."))

	accepting_refs = (toolmode == MULTITOOL_MODE_INTCIRCUITS)

	return

/datum/category_item/catalogue/anomalous/precursor_a/alien_multitool
	name = "Precursor Alpha Object - Pulse Tool"
	desc = "This ancient object appears to be an electrical tool. \
	It has a simple mechanism at the handle, which will cause a pulse of \
	energy to be emitted from the head of the tool. This can be used on a \
	conductive object such as a wire, in order to send a pulse signal through it.\
	<br><br>\
	These qualities make this object somewhat similar in purpose to the common \
	multitool, and can probably be used for tasks such as direct interfacing with \
	an airlock, if one knows how."
	value = CATALOGUER_REWARD_EASY

/obj/item/multitool/alien
	name = "alien multitool"
	desc = "An omni-technological interface."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_multitool)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "multitool"
	toolspeed = 0.1
	origin_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 5)

// Alien multitool only has those icon states
/obj/item/multitool/alien/update_icon()
	if(accepting_refs)
		icon_state = "multitool_ref_scan"
		return
	icon_state = "multitool"
