#!/usr/bin/env nu

use language.nu
use desktopEntry.nu

let dataDirs = ((if ($env.XDG_DATA_HOME != "") { $env.XDG_DATA_HOME + ":" }) + $env.XDG_DATA_DIRS) | split row ":"

let desktopFiles = $dataDirs | each { |it| glob $"($it)/applications/**/*.desktop" } | where { |it| $it != [ ] } | flatten

$desktopFiles | each { |it| { value: (open $it | desktopEntry parse), id: (desktopEntry getId $it) } } | uniq-by id
