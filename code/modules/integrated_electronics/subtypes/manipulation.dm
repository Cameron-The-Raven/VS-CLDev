/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in most ranged weapons, ballistic and energy.  \
	The first and second inputs need to be numbers.  They are coordinates for the gun to fire at, relative to the machine itself.  \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible.  Note that the \
	normal limitations to firearms, such as ammunition requirements and firing delays, still hold true if fired by the mechanism."
	complexity = 20
	w_class = ITEMSIZE_NORMAL
	size = 3
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	var/obj/item/gun/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	power_draw_per_use = 50 // The targeting mechanism uses this.  The actual gun uses its own cell for firing if it's an energy weapon.

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	installed_gun = null // It will be qdel'd by ..() if still in our contents
	return ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/gun))
		var/obj/item/gun/gun = O
		if(installed_gun)
			to_chat(user, span_warning("There's already a weapon installed."))
			return
		user.drop_from_inventory(gun)
		installed_gun = gun
		size += gun.w_class
		gun.forceMove(src)
		to_chat(user, span_notice("You slide \the [gun] into the firing mechanism."))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(src))
		to_chat(user, span_notice("You slide \the [installed_gun] out of the firing mechanism."))
		size = initial(size)
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
	else
		to_chat(user, span_notice("There's no weapon to remove from the mechanism."))

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work()
	if(!installed_gun)
		return

	var/datum/integrated_io/target_x = inputs[1]
	var/datum/integrated_io/target_y = inputs[2]

	if(src.assembly)
		if(isnum(target_x.data))
			target_x.data = round(target_x.data)
		if(isnum(target_y.data))
			target_y.data = round(target_y.data)

		var/turf/T = get_turf(src.assembly)

		if(target_x.data == 0 && target_y.data == 0) // Don't shoot ourselves.
			return

		// We need to do this in order to enable relative coordinates, as locate() only works for absolute coordinates.
		var/i
		if(target_x.data > 0)
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, EAST)
				i--
		else
			i = abs(target_x.data)
			while(i > 0)
				T = get_step(T, WEST)
				i--

		i = 0
		if(target_y.data > 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, NORTH)
				i--
		else if(target_y.data < 0)
			i = abs(target_y.data)
			while(i > 0)
				T = get_step(T, SOUTH)
				i--

		if(!T)
			return
		installed_gun.Fire_userless(T)

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move a meter in that direction, assuming it is not \
	being held, or anchored in some way.  It should be noted that the ability to move is dependent on the type of assembly that this circuit inhabits."
	w_class = ITEMSIZE_NORMAL
	complexity = 20
//	size = 5
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list()
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(src)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return
		if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum(wanted_dir.data))
				step(assembly, wanted_dir.data)


/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades at prime them at will."
	extended_desc = "Time between priming and detonation is limited to between 1 to 12 seconds but is optional. \
					If unset, not a number, or a number less than 1 then the grenade's built-in timing will be used. \
					Beware: Once primed there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	size = 2
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 4)
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type

/obj/item/integrated_circuit/manipulation/grenade/Initialize(mapload)
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.dropInto(loc)
	detach_grenade()
	. =..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, span_warning("There is already a grenade attached!"))
		else if(user.unEquip(G, force=1))
			user.visible_message(span_warning("\The [user] attaches \a [G] to \the [src]!"), span_notice("You attach \the [G] to \the [src]."))
			attach_grenade(G)
			G.forceMove(src)
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message(span_warning("\The [user] removes \an [attached_grenade] from \the [src]!"), span_notice("You remove \the [attached_grenade] from \the [src]."))
		user.put_in_any_hand_if_possible(attached_grenade) || attached_grenade.dropInto(loc)
		detach_grenade()
	else
		..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			attached_grenade.det_time = between(1, detonation_time.data, 12) SECONDS
		attached_grenade.activate()
		var/atom/holder = loc
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.forensic_data?.get_lastprint()] Circuit: [forensic_data?.get_lastprint()] Grenade: [attached_grenade.forensic_data?.get_lastprint()]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/grenade/G)
	attached_grenade = G
	RegisterSignal(attached_grenade, COMSIG_OBSERVER_DESTROYED, /obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade)
	size += G.w_class
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	SIGNAL_HANDLER
	if(!attached_grenade)
		return
	UnregisterSignal(attached_grenade, COMSIG_OBSERVER_DESTROYED)
	attached_grenade = null
	size = initial(size)
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/grenade/frag
	pre_attached_grenade_type = /obj/item/grenade/explosive
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_COMBAT = 10)
	spawn_flags = null			// Used for world initializing, see the #defines above.
