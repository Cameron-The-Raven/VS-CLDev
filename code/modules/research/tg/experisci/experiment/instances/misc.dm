/datum/experiment/scanning/random/janitor_trash
	name = "Station Hygiene Inspection"
	description = "To learn how to clean, we must first learn what it is to have filth. We need you to scan some filth around the station."
	possible_types = list(/obj/effect/decal/cleanable/blood)
	total_requirement = 3

/datum/experiment/scanning/random/janitor_trash/serialize_progress_stage(atom/target, list/seen_instances)
	var/scanned_total = seen_instances.len
	return EXPERIMENT_PROG_INT("Scan samples of blood or oil", scanned_total, required_atoms[target])
