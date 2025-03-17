/obj/machinery/power/am_engine
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/am_engine.dmi'
	icon_state = "core_off"
	density = TRUE
	anchored = TRUE
	flags = ON_BORDER

/proc/convert2energy(mass)
	return mass * (SPEED_OF_LIGHT ** 2)

/obj/machinery/power/am_engine/proc/check_components()
	return

//engine
/obj/machinery/power/am_engine/engine
	name = "Antimatter Engine"
	icon_state = "core_off"
	var/engine_id = 0
	var/H_fuel = 0
	var/antiH_fuel = 0
	var/datum/weakref/connected = null

/obj/machinery/power/am_engine/engine/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/am_engine/engine/LateInitialize()
	check_components()

/obj/machinery/power/am_engine/engine/check_components()
	if(connected?.resolve())
		return
	var/obj/machinery/power/am_engine/injector/I = locate() in get_area(src)
	connected = WEAKREF(I)

/obj/machinery/power/am_engine/engine/Destroy()
	if(datum_flags & DF_ISPROCESSING)
		STOP_MACHINE_PROCESSING(src)
	. = ..()

/obj/machinery/power/am_engine/engine/proc/engine_go()
	if(datum_flags & DF_ISPROCESSING)
		return
	check_components()
	if((!connected?.resolve()) || (stat & BROKEN))
		return
	if(!antiH_fuel || !H_fuel)
		return

	var/energy = 0
	if(antiH_fuel == H_fuel)
		var/mass = antiH_fuel + H_fuel
		energy = convert2energy(mass)
		H_fuel = 0
		antiH_fuel = 0
	else
		var/residual_matter = abs(H_fuel - antiH_fuel)
		var/mass = antiH_fuel + H_fuel - residual_matter
		energy = convert2energy(mass)
		if( H_fuel > antiH_fuel )
			H_fuel = residual_matter
			antiH_fuel = 0
		else
			H_fuel = 0
			antiH_fuel = residual_matter
	visible_message(span_red("\The [src] fires!"),span_red("You hear a loud bang!"), runemessage = "bang")
	energy = energy*0.75 //Q = k x (delta T)

	START_MACHINE_PROCESSING(src)
	var/obj/machinery/power/am_engine/injector/I = connected?.resolve()
	I.update_icon()
	update_icon()

/obj/machinery/power/am_engine/engine/proc/engine_shutdown()
	if(!(datum_flags & DF_ISPROCESSING))
		return
	visible_message(span_red("\The [src] whirrs down!"),span_red("You hear a low whirring!"), runemessage = "whirr...")
	STOP_MACHINE_PROCESSING(src)

/obj/machinery/power/am_engine/engine/process()
	var/obj/machinery/power/am_engine/injector/I = connected?.resolve()
	if(!I || (stat & BROKEN) )
		STOP_MACHINE_PROCESSING(src)
		update_icon()
		return
	if(!antiH_fuel || !H_fuel)
		STOP_MACHINE_PROCESSING(src)
		update_icon()
		return

	var/mass				//total mass
	var/energy				//energy from the reaction
	var/remaining_H	= 0		//residual matter if H
	var/remaining_antiH = 0	//residual matter if antiH
	if(antiH_fuel == H_fuel)
		//if they're equal then convert the whole mass to energy
		mass = antiH_fuel + H_fuel
		energy = convert2energy(mass)
	else
		//else if they're not equal determine which isn't equal
		//and set it equal to either H or antiH so we don't lose anything
		var/residual_matter = abs(H_fuel - antiH_fuel)
		mass = antiH_fuel + H_fuel - residual_matter
		energy = convert2energy(mass)
		if( H_fuel > antiH_fuel )
			remaining_H = residual_matter
		else
			remaining_antiH = residual_matter

	if(energy > convert2energy(8e-12))
		//TOO MUCH ENERGY
		visible_message(span_red("\The [src] whirrs loudly!"),span_red("You hear a loud whirring!"), runemessage = "whirr")
		addtimer(src,CALLBACK(src,PROC_REF(attempt_singularity_cascade),energy,H,antiH,mass),20,TIMER_DELETE_ME)
	else
		//this amount of energy is okay so it does the proper output thing
		//E = Pt
		//Lets say its 86% efficient
		var/output = 0.86*energy/20
		add_avail(output)

	//yeah the machine realises that something isn't right and accounts for it if H or antiH
	H_fuel -= remaining_H
	antiH_fuel -= remaining_antiH
	antiH_fuel = antiH_fuel/4

	H_fuel = H_fuel/4
	H_fuel += remaining_H
	antiH_fuel += remaining_antiH

	if(H_fuel <= 0)
		H_fuel = 0
		I.mat_tank = FALSE
	if(antiH_fuel <= 0)
		antiH_fuel = 0
		I.anti_tank = FALSE

	I.update_icon()

/obj/machinery/power/am_engine/engine/proc/attempt_singularity_cascade(var/energy,var/H,var/antiH,var/mass)
	//Q = k x (delta T)
	//Too much energy so machine panics and dissapates half of it as heat
	//The rest of the energetic photons then form into H and anti H particles again!
	H_fuel -= H
	antiH_fuel -= antiH
	antiH_fuel = antiH_fuel/2
	H_fuel = H_fuel/2

	energy = convert2energy(H_fuel + antiH_fuel)
	H_fuel += H
	antiH_fuel += antiH

	//FAR TOO MUCH ENERGY STILL
	if(energy > convert2energy(8e-12))
		STOP_MACHINE_PROCESSING(src) // we're BYOND saving!
		var/turf/ground_zero = get_turf(src)
		if(!ground_zero)
			return
		var/ground_zero_range = round(energy / 387)
		log_and_message_admins("[src] entered an explosive gravity cascade! [ground_zero.x].[ground_zero.y].[ground_zero.z]")
		visible_message(span_huge(span_bolddanger("BANG")),span_huge(span_bolddanger("BANG")), runemessage = "bang")
		qdel(src)
		SSradiation.radiate(ground_zero, energy)
		new /obj/effect/bhole(ground_zero)
		explosion(ground_zero, ground_zero_range, ground_zero_range*2, ground_zero_range*3, ground_zero_range*4)

/obj/machinery/power/am_engine/engine/update_icon()
	if(datum_flags & DF_ISPROCESSING)
		icon_state = "core_on"
		set_light(3, 2, "#66FFFF")
	else
		icon_state = "core_off"
		set_light(0)
