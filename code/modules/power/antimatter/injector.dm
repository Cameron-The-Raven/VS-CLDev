/obj/machinery/power/am_engine/injector
	name = "Injector"
	icon_state = "injector"
	var/engine_id = 0
	var/injecting = 0
	var/fuel = 0
	var/datum/weakref/connected = null
	var/mat_tank = FALSE
	var/anti_tank = FALSE

/obj/machinery/power/am_engine/injector/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/am_engine/injector/LateInitialize()
	check_components()

/obj/machinery/power/am_engine/injector/check_components()
	if(connected?.resolve())
		return
	var/obj/machinery/power/am_engine/engine/E = locate() in get_area(src)
	connected = WEAKREF(E)

/obj/machinery/power/am_engine/injector/attackby(obj/item/fuel/F, mob/user)
	check_components()
	var/obj/machinery/power/am_engine/engine/E = connected?.resolve()
	if((stat & BROKEN) || !E)
		return
	if(!istype(F, /obj/item/fuel))
		return

	if(injecting)
		to_chat(user, "There's already a fuel rod in the injector!")
		return

	if(!F.fuel)
		to_chat(user, "There's nothing in \the [F]!")
		return

	injecting = TRUE
	if(do_after(user,5 SECONDS))
		to_chat(user, "You insert \the [F] into the injector")
		var/fuel = F.fuel
		if(!F.is_antimatter)
			E.H_fuel += fuel
			mat_tank = TRUE
		else
			E.antiH_fuel += fuel
			anti_tank = TRUE
		update_icon()
		injecting = FALSE
		qdel(F)
	else
		injecting = FALSE

/obj/machinery/power/am_engine/injector/update_icon()
	// TODO - change to overlays already present in dmi
	if(mat_tank && anti_tank)
		icon_state = "injector_matter_antimatter"
		return
	if(mat_tank)
		icon_state = "injector_matter"
		return
	if(anti_tank)
		icon_state = "injector_antimatter"
		return
