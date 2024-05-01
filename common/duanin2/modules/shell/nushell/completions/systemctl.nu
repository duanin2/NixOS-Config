def systemd-units [ context: string ] {
	if ($context | str contains "--user") {
		systemctl list-unit-files -al --user | lines | skip 1 | drop 2 | parse --regex '^(?P<Unit>\S+\.(?:(?:auto)?mount|path|scope|service|slice|socket|swap|target|timer))\s+(?P<Status>(?:(?:enabled|disabled|masked|linked|alias|generated|transient|static)(?:-runtime)?))\s+(?P<Preset>(?:enabled|disabled|failed|-))$' | get Unit
	} else {
		systemctl list-unit-files -al --system | lines | skip 1 | drop 2 | parse --regex '^(?P<Unit>\S+\.(?:(?:auto)?mount|path|scope|service|slice|socket|swap|target|timer))\s+(?P<Status>(?:(?:enabled|disabled|masked|linked|alias|generated|transient|static)(?:-runtime)?))\s+(?P<Preset>(?:enabled|disabled|failed|-))$' | get Unit
	}
}

export extern "systemctl status" [
	--help(-h)											# Show help
	--version												# Show package version
	--system												# Connect to system manager
	--user													# Connect to user service manager
	--host(-H): string							# Operate on remote host
	--machine(-M): string						# Operate on a local container
	--type(-t): string							# List units of a particular type
	--state: string									# List units of a particular LOAD or SUB or ACTIVE state
	--failed												# Shortcut for `--state=failed`
	--property(-p): string					# Show only properties by this name
	-P: string											# Equivalent to `--value --property=NAME`
	--all(-a)												# Show all properties/units currently in memory, including dead/empty ones. To list all units installed on the system, use 'list-unit-files' instead.
	--full(-l)											# Don't ellipsize unit names on output
	--recursive(-r)									# Show unit list of host and local containers
	--reverse												# Show reverse dependencies with 'list-dependencies'
	--with-dependencies							# Show unit dependencies with 'status', 'cat', 'list-units', and 'list-unit-files'.
	--job-mode: string							# Specify how to deal with already queued jobs, when queueing a new job
	--show-transaction(-T)					# When enqueuing a unit job, show full transaction
	--show-types										# When showing sockets, explicitly show their type
	--value													# When showing properties, only print the value
	--check-inhibitors: string			# Whether to check inhibitors before shutting down, sleeping, or hibernating
	-i															# Shortcut for --check-inhibitors=no
	--kill-whom: string							# Whom to send signal to
	--kill-value: string						# Signal value to enqueue
	--signal(-s): string						# Which signal to send
	--what: string									# Which types of resources to remove
	--now														# Start or stop unit after enabling or disabling it
	--dry-run												# Only print what would be done. Currently supported by verbs: halt, poweroff, reboot, kexec, soft-reboot, suspend, hibernate, suspend-then-hibernate, hybrid-sleep, default, rescue, emergency, and exit.
	--quiet(-q)											# Suppress output
	--no-warn												# Suppress several warnings shown by default
	--wait													# For (re)start, wait until service stopped again. For is-system-running, wait until startup is completed.
	--no-block											# Do not wait until operation finished
	--no-wall												# Don't send wall message before halt/power-off/reboot
	--no-reload											# Don't reload daemon after en-/dis-abling unit files
	--legend: string								# Enable/disable the legend (column headers and hints)
	--no-pager											# Do not pipe output into a pager
	--no-ask-password								# Do not ask for system passwords
	--global												# Edit/enable/disable/mask default user unit files globally
	--runtime												# Edit/enable/disable/mask unit files temporarily until next reboot
	--force(-f)											# When enabling unit files, override existing symlinks. When shutting down, execute action immediately.
	--preset-mode: string						# Apply only enable, only disable, or all presets
	--root: string									# Edit/enable/disable/mask unit files in the specified root directory
	--image: string									# Edit/enable/disable/mask unit files in the specified disk image
	--image-policy: string					# Specify disk image dissection policy
	--lines(-n): int								# Number of journal entries to show
	--output(-o): string						# Change journal output mode (short, short-precise, short-iso, short-iso-precise, short-full, short-monotonic, short-unix, short-delta, verbose, export, json, json-pretty, json-sse, cat)
	--firmware-setup								# Tell the firmware to show the setup menu on next boot
	--boot-loader-menu: string			# Boot into boot loader menu on next boot
	--boot-loader-entry: string			# Boot into a specific boot loader entry on next boot
	--plain													# Print unit dependencies as a list instead of a tree
	--timestamp: string							# Change format of printed timestamps (pretty, unix, us, utc, us+utc)
	--read-only											# Create read-only bind mount
	--mkdir													# Create directory before mounting, if missing
	--marked												# Restart/reload previously marked units
	--drop-in: string								# Edit unit files using the specified drop-in file name
	--when: string									# Schedule halt/power-off/reboot/kexec action after a certain timestamp
	...units: string@systemd-units	# Show runtime status of one or more units
]