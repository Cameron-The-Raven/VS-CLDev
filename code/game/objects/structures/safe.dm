/*
CONTAINS:
SAFES
FLOOR SAFES
*/

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of metal with a dial embedded in it. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\""
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position- from 0 to 72
	var/tumbler_1_open	//the tumbler position to open at- 0 to 72
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the maximum combined w_class of stuff in the safe


/obj/structure/safe/Initialize(mapload)
	. = ..()
	tumbler_1_pos = rand(0, 72)
	tumbler_1_open = rand(0, 72)

	tumbler_2_pos = rand(0, 72)
	tumbler_2_open = rand(0, 72)

	if(. != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD

/obj/structure/safe/LateInitialize()
	for(var/obj/item/I in loc)
		if(space >= maxspace)
			return
		if(I.w_class + space <= maxspace)
			space += I.w_class
			I.forceMove(src)

/obj/structure/safe/proc/check_unlocked(mob/user, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, span_notice("You hear a [pick("tonk", "krunk", "plunk")] from \the [src]."))
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, span_notice("You hear a [pick("tink", "krink", "plink")] from \the [src]."))
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user) visible_message(span_infoplain(span_bold("[pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")]!")))
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 71
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 71)
		num = 0
	return num


/obj/structure/safe/update_icon()
	if(open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)


/obj/structure/safe/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "<center>"
	dat += "<a href='byond://?src=\ref[src];open=1'>[open ? "Close" : "Open"] [src]</a> | <a href='byond://?src=\ref[src];decrement=1'>-</a> [dial * 5] <a href='byond://?src=\ref[src];increment=1'>+</a>"
	if(open)
		dat += "<table>"
		for(var/i = contents.len, i>=1, i--)
			var/obj/item/P = contents[i]
			dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
		dat += "</table></center>"
	user << browse("<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=safe;size=350x300")


/obj/structure/safe/Topic(href, href_list)
	if(!ishuman(usr))	return
	var/mob/living/carbon/human/user = usr

	var/canhear = 0
	if(user.get_type_in_hands(/obj/item/clothing/accessory/stethoscope))
		canhear = 1

	if(href_list["open"])
		if(check_unlocked())
			to_chat(user, span_notice("You [open ? "close" : "open"] [src]."))
			open = !open
			update_icon()
			updateUsrDialog(usr)
			return
		else
			to_chat(user, span_notice("You can't [open ? "close" : "open"] [src], the lock is engaged!"))
			return

	if(href_list["decrement"])
		dial = decrement(dial)
		if(dial == tumbler_1_pos + 1 || dial == tumbler_1_pos - 71)
			tumbler_1_pos = decrement(tumbler_1_pos)
			if(canhear)
				to_chat(user, span_notice("You hear a [pick("clack", "scrape", "clank")] from \the [src]."))
			if(tumbler_1_pos == tumbler_2_pos + 37 || tumbler_1_pos == tumbler_2_pos - 35)
				tumbler_2_pos = decrement(tumbler_2_pos)
				if(canhear)
					to_chat(user, span_notice("You hear a [pick("click", "chink", "clink")] from \the [src]."))
					playsound(src, 'sound/machines/click.ogg', 20, 1)
			check_unlocked(user, canhear)

		updateUsrDialog(usr)
		return

	if(href_list["increment"])
		dial = increment(dial)
		if(dial == tumbler_1_pos - 1 || dial == tumbler_1_pos + 71)
			tumbler_1_pos = increment(tumbler_1_pos)
			if(canhear)
				to_chat(user, span_notice("You hear a [pick("clack", "scrape", "clank")] from \the [src]."))
			if(tumbler_1_pos == tumbler_2_pos - 37 || tumbler_1_pos == tumbler_2_pos + 35)
				tumbler_2_pos = increment(tumbler_2_pos)
				if(canhear)
					to_chat(user, span_notice("You hear a [pick("click", "chink", "clink")] from \the [src]."))
					playsound(src, 'sound/machines/click.ogg', 20, 1)
			check_unlocked(user, canhear)
		updateUsrDialog(usr)
		return

	if(href_list["retrieve"])
		user << browse(null, "window=safe") // Close the menu

		var/obj/item/P = locate(href_list["retrieve"]) in src
		if(open)
			if(P && in_range(src, user))
				user.put_in_hands(P)
				updateUsrDialog(usr)


/obj/structure/safe/attackby(obj/item/I, mob/user)
	if(open)
		if(I.w_class + space <= maxspace)
			space += I.w_class
			user.drop_item()
			I.loc = src
			to_chat(user, span_notice("You put [I] in \the [src]."))
			updateUsrDialog(user)
			return
		else
			to_chat(user, span_notice("[I] won't fit in \the [src]."))
			return
	else
		if(istype(I, /obj/item/clothing/accessory/stethoscope))
			to_chat(user, "Hold [I] in one of your hands while you manipulate the dial.")
			return


/obj/structure/safe/ex_act(severity)
	return

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = FALSE
	level = 1	//underfloor
	plane = PLATING_PLANE
	layer = ABOVE_UTILITY

/obj/structure/safe/floor/Initialize(mapload)
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(var/intact)
	invisibility = intact ? INVISIBILITY_ABSTRACT : INVISIBILITY_NONE

/obj/structure/safe/floor/hides_under_flooring()
	return 1
