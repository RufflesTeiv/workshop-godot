extends Node

func call_delayed(callable: Callable, delay: float, process_always := true, process_in_physics := false, ignore_time_scale := false, flags := 0):
	get_tree().create_timer(delay, process_always, process_in_physics, ignore_time_scale).timeout.connect(callable, flags)
