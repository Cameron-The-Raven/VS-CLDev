GLOBAL_LIST_EMPTY(archive_diseases)

/// Add a disease to the archive using it's symptoms as a key. Sets the name of the input disease to the archived one if it finds a match. Returns the archived datum.
/proc/handle_archived_disease(var/datum/disease/advance/D)
	RETURN_TYPE(/datum/disease/advance)
	var/the_id = D.GetDiseaseID()
	// Return the archived datum, update passed disease's name with archived name.
	if(D.update_from_archived_name(the_id))
		return GLOB.archive_diseases[the_id]
	// Make a copy, return the archived entry
	var/datum/disease/advance/C = D.copy_disease()
	GLOB.archive_diseases[the_id] = C
	return C

GLOBAL_LIST_INIT(advance_cures, list(
	REAGENT_ID_SPACEACILLIN,
	REAGENT_ID_ORANGEJUICE,
	REAGENT_ID_ETHANOL,
	REAGENT_ID_GLUCOSE,
	REAGENT_ID_COPPER,
	REAGENT_ID_LEAD,
	REAGENT_ID_LITHIUM,
	REAGENT_ID_RADIUM,
	REAGENT_ID_MERCURY,
	REAGENT_ID_BLISS,
	REAGENT_ID_MUTAGEN,
	REAGENT_ID_PHORON,
	REAGENT_ID_SACID
))

/datum/disease/advance
	name = "Unknown"
	desc = "An engineered disease which can contain a multitude of symptoms."
	form = "Advance Disease"
	agent = "advance microbes"
	max_stages = 5
	disease_flags = CURABLE|CAN_CARRY|CAN_RESIST|CAN_NOT_POPULATE
	spread_text = "Unknown"
	viable_mobtypes = list(/mob/living/carbon/human)

	var/last_modified_by = "no CKEY"
	var/resistance
	var/stealth
	var/stage_rate
	var/transmission
	var/severity
	var/speed
	var/list/symptoms = list()

	var/s_processing = FALSE
	var/id = ""

/datum/disease/advance/New()
	refresh()

/datum/disease/advance/Destroy()
	if(s_processing)
		for(var/datum/symptom/S in symptoms)
			S.End(src)
	return ..()

/datum/disease/advance/stage_act()
	if(!..())
		return FALSE
	if(symptoms && length(symptoms))

		if(!s_processing)
			s_processing = TRUE
			for(var/datum/symptom/S in symptoms)
				S.Start(src)

		for(var/datum/symptom/S in symptoms)
			S.Activate(src)
	else
		CRASH("We do not have any symptoms during stage_act()!")
	return TRUE

/datum/disease/advance/IsSame(datum/disease/advance/D)
	if(!istype(D, /datum/disease/advance))
		return FALSE

	if(GetDiseaseID() != D.GetDiseaseID())
		return FALSE
	return TRUE

/datum/disease/advance/cure(resistance = TRUE)
	if(affected_mob)
		var/id = "[GetDiseaseID()]"
		if(resistance && !(id in affected_mob.GetResistances()))
			affected_mob.GetResistances()[id] = id
		remove_virus()
	qdel(src)

/datum/disease/advance/copy_disease()
	var/datum/disease/advance/A = ..()
	QDEL_LIST(A.symptoms)
	for(var/datum/symptom/S as anything in symptoms)
		A.symptoms += S.CopySymptom()
	A.disease_flags = disease_flags
	A.resistance = resistance
	A.stealth = stealth
	A.stage_rate = stage_rate
	A.transmission = transmission
	A.severity = severity
	A.speed = speed
	A.id = id
	return A

/datum/disease/advance/proc/Mix(datum/disease/advance/D)
	if(!(IsSame(D)))
		var/list/possible_symptoms = shuffle(D.symptoms)
		for(var/datum/symptom/S in possible_symptoms)
			add_symptom(S.CopySymptom())

/datum/disease/advance/proc/HasSymptom(datum/symptom/S)
	for(var/datum/symptom/symp in symptoms)
		if(symp.id == S.id)
			return TRUE
	return FALSE

/datum/disease/advance/proc/generate_symptoms_by_severity(sev_min, sev_max, amount = 1)

	var/list/generated = list()

	var/list/possible_symptoms = list()
	for(var/symp in GLOB.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.severity >= sev_min && S.severity <= sev_max)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!length(possible_symptoms))
		return generated

	for(var/i = 1 to amount)
		generated += pick_n_take(possible_symptoms)

	return generated

/datum/disease/advance/proc/generate_symptoms(level_min, level_max, amount_get = 0)

	var/list/generated = list()

	// Generate symptoms. By default, we only choose non-deadly symptoms.
	var/list/possible_symptoms = list()
	for(var/symp in GLOB.list_symptoms)
		var/datum/symptom/S = new symp
		if(S.level >= level_min && S.level <= level_max)
			if(!HasSymptom(S))
				possible_symptoms += S

	if(!length(possible_symptoms))
		return generated

	// Random chance to get more than one symptom
	var/number_of = amount_get
	if(!amount_get)
		number_of = 1
		while(prob(20))
			number_of += 1

	for(var/i = 1; number_of >= i && length(possible_symptoms); i++)
		generated += pick_n_take(possible_symptoms)

	return generated

/datum/disease/advance/proc/refresh(new_name = FALSE)
	generate_properties()
	assign_properties()
	id = null
	if(new_name)
		assign_name()
	else
		handle_archived_disease(src)

/datum/disease/advance/proc/generate_properties()
	resistance = 0
	stealth = 0
	stage_rate = 0
	transmission = 0
	severity = 0

	var/c1sev
	var/c2sev
	var/c3sev

	for(var/datum/symptom/S as anything in symptoms)
		resistance += S.resistance
		stealth += S.stealth
		stage_rate += S.stage_speed
		transmission += S.transmission
	for(var/datum/symptom/S as anything in symptoms)
		S.severityset(src)
		switch(S.severity)
			if(-INFINITY to 0)
				c1sev += S.severity
			if(1 to 2)
				c2sev = max(c2sev, min(3, (S.severity + c2sev)))
			if(3 to 4)
				c2sev = max(c2sev, min(4, (S.severity + c2sev)))
			if(5 to INFINITY)
				if(c3sev >= 5)
					c3sev += (S.severity -3)
				else
					c3sev += S.severity

	severity += (max(c2sev, c3sev) + c1sev)

/datum/disease/advance/proc/assign_properties()

	if(stealth >= 2)
		visibility_flags |= HIDDEN_SCANNER
	else
		visibility_flags &= ~HIDDEN_SCANNER

	set_spread()
	permeability_mod = max(CEILING(0.4 * transmission, 1), 1)
	cure_chance = 15 - clamp(resistance, -5, 5) // can be between 10 and 20
	stage_prob = max(stage_rate, 2)
	set_severity(severity)
	generate_cure()

/datum/disease/advance/proc/set_spread()
	switch(transmission)
		if(-INFINITY to 5)
			spread_flags = DISEASE_SPREAD_BLOOD
			spread_text = "Blood"
		if(6 to 10)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_FLUIDS
			spread_text = "Fluids"
		if(11 to INFINITY)
			spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_FLUIDS | DISEASE_SPREAD_CONTACT
			spread_text = "On Contact"

/datum/disease/advance/proc/set_severity(level_sev)

	switch(level_sev)

		if(-INFINITY to -2)
			severity = DISEASE_BENEFICIAL
		if(-1)
			severity = DISEASE_POSITIVE
		if(0)
			severity = DISEASE_NONTHREAT
		if(1)
			severity = DISEASE_MINOR
		if(2)
			severity = DISEASE_MEDIUM
		if(3)
			severity = DISEASE_HARMFUL
		if(4)
			severity = DISEASE_DANGEROUS
		if(5 to INFINITY)
			severity = DISEASE_BIOHAZARD
		else
			severity = "Unknown"

/datum/disease/advance/proc/generate_cure()
	var/res = clamp(resistance - (length(symptoms) / 2), 1, length(GLOB.advance_cures))
	cures = list(GLOB.advance_cures[res])
	cure_text = cures[1]
	return

/// Randomly generate a symptom, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/evolve(min_level, max_level)
	var/s = safepick(generate_symptoms(min_level, max_level, 1))
	if(s)
		add_symptom(s)
		refresh(TRUE)
	return

/// Randomly generates a symptom from a given list, has a chance to lose or gain a symptom.
/datum/disease/advance/proc/picky_evolve(var/list/datum/symptom/D)
	var/s = safepick(D)
	if(s)
		add_symptom(new s)
		refresh(TRUE)
	return

/// Randomly remove a symptom.
/datum/disease/advance/proc/devolve()
	if(length(symptoms) > 1)
		var/s = safepick(symptoms)
		if(s)
			remove_symptom(s)
			refresh(TRUE)
	return

/// Randomly neuter a symptom.
/datum/disease/advance/proc/neuter_symptom()
	if(symptoms.len)
		var/s = safepick(symptoms)
		if(s)
			neuter_symptom(s)
			refresh(TRUE)

/// Name the disease. Updates the archived disease datum's name. Then assigns all active datums of the disease with the new name.
/datum/disease/advance/proc/assign_name(new_name = "Unknown")
	var/datum/disease/advance/A = handle_archived_disease(src)
	A.name = new_name // update's the ARCHIVED datum's name!
	for(var/datum/disease/advance/AD in GLOB.active_diseases)
		AD.update_from_archived_name(AD.GetDiseaseID())

/// Find the archived virus. If the virus has been archived before, use its name. Returns true if the disease was archived and not unknown, false otherwise.
/datum/disease/advance/proc/update_from_archived_name(var/the_id)
	var/datum/disease/advance/A = GLOB.archive_diseases[the_id]
	if(!A || A.name == "Unknown")
		return FALSE
	name = A.name
	return TRUE

/// Return a unique ID of the disease.
/datum/disease/advance/GetDiseaseID()
	if(!id)
		var/list/L = list()
		for(var/datum/symptom/S in symptoms)
			if(S.neutered)
				L += "[S.id]N"
			else
				L += S.id
		L = sortList(L) // Sort the list so it doesn't matter which order the symptoms are in.
		var/result = jointext(L, ":")
		id = result
	return id

/datum/disease/advance/proc/finalize()
	for(var/datum/symptom/S in symptoms)
		S.OnAdd(src)

/// Add a symptom, if it is over the limit (with a small chance to be able to go over). We take a random symptom away and add the new one.
/datum/disease/advance/proc/add_symptom(datum/symptom/S)

	if(HasSymptom(S))
		return

	if(length(symptoms) < (VIRUS_SYMPTOM_LIMIT - 1) + rand(-1, 1))
		symptoms += S
	else
		remove_symptom(pick(symptoms))
		symptoms += S
	S.OnAdd(src)
	refresh()

/// Simply removes the symptom.
/datum/disease/advance/proc/remove_symptom(datum/symptom/S)
	symptoms -= S
	return

/// Neuters a symptom, allowing it only for stats.
/datum/disease/advance/neuter_symptom(datum/symptom/S)
	if(!S.neutered)
		S.neutered = TRUE
		S.name += " (neutered)"
		S.OnRemove(src)

/// Mix a list of advance diseases and return the mixed result.
/proc/Advance_Mix(list/D_list)

	var/list/diseases = list()

	for(var/datum/disease/advance/A in D_list)
		diseases += A.copy_disease()

	if(!length(diseases))
		return null
	if(length(diseases) <= 1)
		return pick(diseases) // Just return the only entry.

	var/i = 0
	// Mix our diseases until we are left with only one result.
	while(i < 20 && length(diseases) > 1)

		i++

		var/datum/disease/advance/D1 = pick(diseases)
		diseases -= D1

		var/datum/disease/advance/D2 = pick(diseases)
		D2.Mix(D1)

	// Should be only 1 entry left, but if not let's only return a single entry
	var/datum/disease/advance/to_return = pick(diseases)
	to_return.refresh(new_name = TRUE)
	return to_return

/proc/SetViruses(datum/reagent/R, list/data)
	if(data)
		var/list/preserve = list()
		if(istype(data) && data["viruses"])
			for(var/datum/disease/A in data["viruses"])
				preserve += A.copy_disease()
			R.data = data.Copy()
		if(length(preserve))
			R.data["viruses"] = preserve

/client/proc/AdminCreateVirus()
	set category = "Fun.Event Kit"
	set name = "Create Advanced Virus"
	set desc = "Create an advanced virus and release it."

	if(!is_admin(usr))
		return FALSE

	var/i = VIRUS_SYMPTOM_LIMIT
	var/mob/living/carbon/human/H = null

	var/datum/disease/advance/D = new(0, null)
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += GLOB.list_symptoms.Copy()
	do
		if(src)
			var/symptom = tgui_input_list(src, "Choose a symptom to add ([i] remaining)", "Choose a Symptom", symptoms)
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/symptom/S = new symptom
				if(!D.HasSymptom(S))
					D.symptoms += S
					i -= 1
	while(i > 0)

	if(length(D.symptoms) > 0)

		var/new_name = tgui_input_text(src, "Name your new disease.", "New Name")
		if(!new_name)
			return FALSE
		D.refresh(new_name)
		D.finalize()

		for(var/datum/disease/advance/AD in GLOB.active_diseases)
			AD.refresh()

		H = tgui_input_list(src, "Choose infectee", "Infectees", human_mob_list)

		if(isnull(H))
			return FALSE

		if(!H.HasDisease(D))
			H.force_contract_disease(D)

		var/list/name_symptoms = list()
		for(var/datum/symptom/S in D.symptoms)
			name_symptoms += S.name
		message_admins("[key_name_admin(src)] has triggered a custom virus outbreak of [D.name]! It has these symptoms: [english_list(name_symptoms)]")
		log_admin("[key_name_admin(src)] infected [key_name_admin(H)] with [D.name]. It has these symptoms: [english_list(name_symptoms)]")

		return TRUE
