/datum/unit_test/communicator_smoke_test
	name = "SMOKE: communicator test"

/datum/unit_test/communicator_smoke_test/start_test()
	var/number_of_issues = 0
	var/test_index = 1

	var/obj/container = new()

	// Make communicator
	new /obj/item/communicator(container)
	if(check_valid(test_index,"MAKE"))
		number_of_issues++

	// Del communicator
	clear_inv(container)
	if(check_valid(test_index,"STANDARD QDEL"))
		number_of_issues++
	clear_inv(container)

	// Del communicator
	new /obj/item/communicator(container)
	clear_inv(container)
	if(check_valid(test_index,"DEL BEFORE"))
		number_of_issues++

	// deleted as soon as created
	qdel(new /obj/item/communicator(container))
	if(check_valid(test_index,"QDEL ON CREATE"))
		number_of_issues++
	clear_inv(container)

	// Check subtypes
	for(var/type in subtypesof(/obj/item/communicator))
		new type(container)
		if(check_valid(test_index,"BAD PATH [type]"))
			number_of_issues++
		clear_inv(container)

	// nullspace spawn
	new /obj/item/communicator(null)
	if(check_valid(test_index,"NULLSPACED"))
		number_of_issues++

	// sleepy del
	var/ref = new /obj/item/communicator(container)
	qdel(ref)
	sleep(1)
	if(check_valid(test_index,"SLEEPY ON CREATE"))
		number_of_issues++
	clear_inv(container)

	// spawn magic
	var/ref = new /obj/item/communicator(container)
	qdel(ref)
	spawn(1)
		if(check_valid(test_index,"SPAWN ON CREATE"))
			number_of_issues++
		clear_inv(container)

	// sleepy del
	var/ref = new /obj/item/communicator(container)
	sleep(1)
	qdel(ref)
	if(check_valid(test_index,"SLEEPY DEL"))
		number_of_issues++

	// spawn magic
	var/ref = new /obj/item/communicator(container)
	spawn(1)
		qdel(ref)
	if(check_valid(test_index,"SPAWN DEL"))
		number_of_issues++

	// prewipe
	clear_inv(container)

	// big one
	for(var/i = 1 to 1000)
		new /obj/item/communicator(container)
	if(check_valid(test_index,"CRASH STACK"))
		number_of_issues++
	clear_inv(container)

	if(number_of_issues)
		fail("[number_of_issues] smokes failed.")
	else
		pass("no smoke leaks.")

	return 1

/datum/unit_test/communicator_smoke_test/proc/check_valid(var/test_index, var/test_name)
	if(all_communicators == null)
		log_unit_test("[test_index]: Smoke - [test_name] LEAK LEAK LEAK.")
		return TRUE

/datum/unit_test/communicator_smoke_test/proc/clear_inv(var/obj/O)
	for(var/obj/I in O.contents)
		qdel(I)
