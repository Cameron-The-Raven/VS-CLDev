SUBSYSTEM_DEF(transfer_controller)
	name = "Transfer"
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	init_order = INIT_ORDER_AUTOTRANSFER
	wait = 10 SECONDS
	var/static/list/occupations //List of all jobs
	var/static/list/unassigned //Players who need jobs
	var/static/list/job_icons //Cache of icons for job info window
	var/timerbuffer = 0 //buffer for time check
	var/shift_hard_end = 0
	var/shift_last_vote = 0

/datum/controller/subsystem/transfer_controller/Initialize()
	timerbuffer = CONFIG_GET(number/vote_autotransfer_initial)
	shift_hard_end = CONFIG_GET(number/vote_autotransfer_initial) + (CONFIG_GET(number/vote_autotransfer_interval) * 0) //Change this "1" to how many extend votes you want there to be.
	shift_last_vote = shift_hard_end - CONFIG_GET(number/vote_autotransfer_interval)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/transfer_controller/stat_entry(msg)
	msg = "T: [get_time(round_duration_in_ds)] | F:[get_time(shift_last_vote)] | E:[get_time(shift_hard_end)]"
	return ..()

/datum/controller/subsystem/transfer_controller/proc/get_time(var/ds)
	var/mins = round((ds % (1 HOUR)) / (1 MINUTE))
	var/hours = round(ds / (1 HOUR))
	return "[hours < 10 ? add_zero(hours, 1) : hours]:[mins < 10 ? add_zero(mins, 1) : mins]"

/datum/controller/subsystem/transfer_controller/fire(resumed = 0)
	if(!resumed)
		if (round_duration_in_ds >= shift_last_vote - 2 MINUTES)
			shift_last_vote = 99999999 //Setting to a stupidly high number since it'll be not used again.
			var/hours = CONFIG_GET(number/vote_autotransfer_interval) / (1 HOUR) // calculate hours
			to_world(span_world(span_notice("This upcoming round-extend vote will be your ONLY extend vote. Wrap up your scenes in the next [hours] [hours > 1 ? "hours" : "hour"] if the round is extended."))) //CHOMPStation Edit
		if (round_duration_in_ds >= shift_hard_end - 1 MINUTE)
			init_shift_change(null, 1)
			shift_hard_end = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval) //If shuttle somehow gets recalled, let's force it to call again next time a vote would occur.
			timerbuffer = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval) //Just to make sure a vote doesn't occur immediately afterwords.
		else if (round_duration_in_ds >= timerbuffer - 1 MINUTE)
			SSvote.start_vote(new /datum/vote/crew_transfer)
			timerbuffer = timerbuffer + CONFIG_GET(number/vote_autotransfer_interval)
