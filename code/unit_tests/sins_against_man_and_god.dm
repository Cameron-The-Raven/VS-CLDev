// File for unit tests of things NEVER TO DO, and should NEVER happen,
// either major codetraps or that things that cause years of problems if done.

/datum/unit_test/all_procs_must_have_argument_sanity
	name = "CODE STYLE: All procs must maintain argument sanity"

/datum/unit_test/all_procs_must_have_argument_sanity/start_test()
	var/failed = FALSE

	// This is the most cursed code I have ever written, you are welcome - Willbird
	for(var/S in typesof(/obj/effect/effect))
		var/path = "[S]/proc"
		log_unit_test(path)
		var/list/atoms_list = typesof(path)
		log_unit_test(atoms_list.len)
		for(var/P in atoms_list)
			log_unit_test("[P]: Code style.")

		if(failed)
			fail("One or more procs have invalid states.")
		else
			pass("All procs are sane.")
		return TRUE
