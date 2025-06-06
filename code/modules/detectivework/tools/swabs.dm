/obj/item/forensics/swab
	name = "swab kit"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon_state = "swab"
	var/gsr = 0
	var/list/dna
	var/used
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/forensics/swab/proc/is_used()
	return used

/obj/item/forensics/swab/attack(var/mob/living/M, var/mob/user)

	if(!ishuman(M))
		return ..()

	if(is_used())
		return

	var/mob/living/carbon/human/H = M
	var/sample_type

	if(H.wear_mask)
		to_chat(user, span_warning("\The [H] is wearing a mask."))
		return

	if(!H.dna || !H.dna.unique_enzymes)
		to_chat(user, span_warning("They don't seem to have DNA!"))
		return

	if(user != H && H.a_intent != I_HELP && !H.lying)
		user.visible_message(span_danger("\The [user] tries to take a swab sample from \the [H], but they move away."))
		return

	if(user.zone_sel.selecting == O_MOUTH)
		if(!H.organs_by_name[BP_HEAD])
			to_chat(user, span_warning("They don't have a head."))
			return
		if(!H.check_has_mouth())
			to_chat(user, span_warning("They don't have a mouth."))
			return
		user.visible_message("[user] swabs \the [H]'s mouth for a saliva sample.")
		dna = list(H.dna.unique_enzymes)
		sample_type = "DNA"

	else if(user.zone_sel.selecting == BP_R_HAND || user.zone_sel.selecting == BP_L_HAND)
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name[BP_R_HAND]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name[BP_L_HAND]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			to_chat(user, span_warning("They don't have any hands."))
			return
		user.visible_message("[user] swabs [H]'s palm for a sample.")
		sample_type = "GSR"
		gsr = H.forensic_data?.get_gunshotresidue()
	else
		return

	if(sample_type)
		set_used(sample_type, H)
		return
	return 1

/obj/item/forensics/swab/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity || istype(A, /obj/machinery/dnaforensics))
		return

	if(is_used())
		to_chat(user, span_warning("This swab has already been used."))
		return

	add_fingerprint(user)

	var/list/choices = list()
	if(A.forensic_data?.has_blooddna())
		choices |= "Blood"
	if(istype(A, /obj/item/clothing))
		choices |= "Gunshot Residue"

	var/choice
	if(!choices.len)
		to_chat(user, span_warning("There is no evidence on \the [A]."))
		return
	else if(choices.len == 1)
		choice = choices[1]
	else
		choice = tgui_input_list(user, "What kind of evidence are you looking for?","Evidence Collection", choices)

	if(!choice)
		return

	var/sample_type
	if(choice == "Blood")
		if(!A.forensic_data?.has_blooddna()) return
		dna = A.forensic_data?.get_blooddna().Copy()
		sample_type = "blood"

	else if(choice == "Gunshot Residue")
		var/obj/item/clothing/B = A
		if(!istype(B) || !B.forensic_data?.get_gunshotresidue())
			to_chat(user, span_warning("There is no residue on \the [A]."))
			return
		gsr = B.forensic_data?.get_gunshotresidue()
		sample_type = "residue"

	if(sample_type)
		user.visible_message("\The [user] swabs \the [A] for a sample.", "You swab \the [A] for a sample.")
		set_used(sample_type, A)

/obj/item/forensics/swab/proc/set_used(var/sample_str, var/atom/source)
	name = "[initial(name)] ([sample_str] - [source])"
	desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_str] from [source].'."
	icon_state = "swab_used"
	used = 1
