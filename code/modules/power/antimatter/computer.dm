//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:05
#define STATE_DEFAULT 1
#define STATE_INJECTOR  2
#define STATE_ENGINE 3


/obj/machinery/computer/am_engine
	name = "Antimatter Engine Console"
	icon_screen = "turbinecomp"
	icon_keyboard = "id_key"
	req_access = list(access_engine)
	var/engine_id = 0
	var/authenticated = 0
	var/datum/weakref/connected_E
	var/datum/weakref/connected_I
	var/state = STATE_DEFAULT

/obj/machinery/computer/am_engine/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/am_engine/LateInitialize()
	check_components()

/obj/machinery/computer/am_engine/proc/check_components()
	if(!connected_E?.resolve())
		for(var/obj/machinery/power/am_engine/engine/E in get_area(src))
			if(E.engine_id == engine_id)
				connected_E = WEAKREF(E)
	if(!connected_I?.resolve())
		for(var/obj/machinery/power/am_engine/injector/I in get_area(src))
			if(I.engine_id == engine_id)
				connected_I = WEAKREF(I)

/obj/machinery/computer/am_engine/Topic(href, href_list)
	if(..())
		return
	usr.machine = src

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("activate")
			check_components()
			var/obj/machinery/power/am_engine/engine/engine = connected_E?.resolve()
			engine?.engine_go()
		if("engine")
			state = STATE_ENGINE
		if("injector")
			state = STATE_INJECTOR
		if("main")
			state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if (I && istype(I))
				if(check_access(I))
					authenticated = 1
		if("deactivate")
			check_components()
			var/obj/machinery/power/am_engine/engine/engine = connected_E?.resolve()
			engine?.engine_shutdown()
		if("logout")
			authenticated = 0

	updateUsrDialog(usr)

/obj/machinery/computer/am_engine/attack_ai(var/mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/am_engine/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "<head><title>Engine Computer</title></head><body>"
	switch(state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=logout'>Log Out</A> \]<br>"
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=engine'>Engine Menu</A> \]"
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=injector'>Injector Menu</A> \]"
			else
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=login'>Log In</A> \]"
		if(STATE_INJECTOR)
			check_components()
			var/obj/machinery/power/am_engine/injector/inject = connected_I?.resolve()
			if(isnull(inject))
				dat += "<BR>\[ DISCONNECTED \]<br>"
			else if(inject.injecting)
				dat += "<BR>\[ Injection in progress\]<br>"
			else
				dat += "<BR>\[ Not injecting \]<br>"
		if(STATE_ENGINE)
			check_components()
			var/obj/machinery/power/am_engine/engine/engine = connected_E?.resolve()
			if(!engine)
				dat += "<BR>\[ DISCONNECTED \]"
			else if(engine.datum_flags & DF_ISPROCESSING)
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=deactivate'>Emergency Stop</A> \]"
			else
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=activate'>Activate Engine</A> \]"
			dat += "<BR>Contents:<br>[engine.H_fuel]kg of Hydrogen<br>[engine.antiH_fuel]kg of Anti-Hydrogen<br>"

	dat += "<BR>\[ [(state != STATE_DEFAULT) ? "<A href='byond://?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A href='byond://?src=\ref[user];mach_close=communications'>Close</A> \]"
	user << browse("<html>[dat]</html>", "window=communications;size=400x500")
	onclose(user, "communications")

#undef STATE_DEFAULT
#undef STATE_INJECTOR
#undef STATE_ENGINE
