#!/usr/bin/env -S nu

let dataDirs = $env.XDG_DATA_DIRS | split row : | prepend $env.XDG_DATA_HOME;

let desktopFiles = $dataDirs | each { |dir| glob $"($dir)/applications/*.desktop" } | flatten | uniq

let fileContents = $desktopFiles | par-each {
	|file|
	let content = open $file;
	let lines = $content | split row "\n";

	$lines | skip until { |line| $line == "[Desktop Entry]" } | where { |line| $line != "" } | each { |line| $line }
}

mut desktopFiles = [];

for file in $fileContents {
	let mainContents = $file | skip 1 | take until { |line| ($line | str starts-with "[") and ($line | str ends-with "]") } | each { |line| $line | parse --regex '(?P<Key>[A-Za-z]+)(?:\[(?P<Language>\w+)\])?=(?P<Value>\S+)' } | where { |line| $line != [] } | flatten;

	let actionsKeys = $mainContents | where { |line| $line.Key == "Action" }
	mut actions = [];
	if ($actionsKeys | length) > 1 {
		continue;
	} else if ($actionsKeys | length) == 1 {
		$actions = ($actionsKeys.0.Value | split row ";" | where { |action| $action != "" })
	}
	let actions = $actions

	mut actionsContents = { 'Desktop Entry': $mainContents }
	for action in $actions {
		let actionContents = $file | skip until { |line| $line == $"[Deskto Action ($action)]" } | skip 1 | take until { |line| ($line | str starts-with "[") and ($line | str ends-with "]") } | each { |line| $line | parse --regex '(?P<Key>[A-Za-z]+)(?:\[(?P<Language>\w+)\])?=(?P<Value>\S+)' } | where { |line| $line != [] } | flatten;
		
		$actionsContents | append { $action: [ ($actionContents | flatten) ] }
	}

	$desktopFiles = if $desktopFiles == [] {
		[ ($actionsContents | flatten) ]
	} else {
		$desktopFiles | append [ ($actionsContents | flatten) ]
	}
}

$desktopFiles | flatten