#!/usr/bin/env -S nu

let desktopFileRegex = { |line| $line | parse --regex '(?P<Key>[A-Za-z]+)(?:\[(?P<Language>\w+)\])?=(?P<Value>\S+)' }

def getContentsRange [
	input: list
	includeOnly?: any
	from?: any
	startSkip?: int
	to?: any
	endSkip?: int
] {
	mut value = $input

	if ($includeOnly != null) {
		$value = ($value | filter $includeOnly)

		if ($from != null) {
			$value = ($value | skip until $from)

			if ($startSkip != null and $startSkip >= 1) {
				$value = ($value | skip $startSkip)

				if ($to != null) {
					$value = ($value | take until $to)

					if ($endSkip != null and $endSkip >= 1) {
						$value = ($value | drop $endSkip)
					}
				}
			}
		}
	}

	debug info

	$value
}

let dataDirs = $env.XDG_DATA_DIRS | split row : | prepend $env.XDG_DATA_HOME;

let desktopFiles = $dataDirs | each { |dir| glob $"($dir)/applications/*.desktop" } | flatten | uniq

let fileContents = $desktopFiles | par-each {
	|file|
	let file = $file;
	mut content = "";
	try {
		$content = (open $file);
	} catch {}
	let content = $content;
	let lines = $content | split row "\n";

	$lines
}

mut desktopFiles = [];

for file in $fileContents {
	let mainContents = (getContentsRange $file { |line| $line != "" } { |line| $line == "[Desktop Entry]" } 1 { |line| ($line | str starts-with "[") and ($line | str ends-with "]") }) | each $desktopFileRegex | flatten;

	mut actionsContents = { 'Desktop Entry': $mainContents }

	let actionsKeys = $mainContents | where { |line| $line.Key == "Actions" }
	mut actions = [];
	if ($actionsKeys | length) == 1 {
		$actions = (($actionsKeys | flatten).Value | split row ";" | where { |action| $action != "" })
	}
	let actions = $actions

	for action in $actions {
		let actionContents = (getContentsRange $file { |line| $line != "" } { |line| $line == $"[Desktop Action ($action)]" } 1 { |line| ($line | str starts-with "[") and ($line | str ends-with "]") }) | each $desktopFileRegex | flatten;
		
		$actionsContents = { ...$actionsContents, $action: $actionContents }
	}

	$desktopFiles = if $desktopFiles == [] {
		[ $actionsContents ]
	} else {
		$desktopFiles | append [ $actionsContents ]
	}
}

$desktopFiles | to json