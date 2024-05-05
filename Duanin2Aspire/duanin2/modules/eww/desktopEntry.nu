#!/usr/bin/env nu

use language.nu

# Gets the ID of a desktop entry file
export def getId [
  path: string         # Full path to the desktop file
] {
  $path | path split | skip until { |name| $name == "applications" } | skip 1 | path join | str replace "/" "-"
}

# Converts from a desktop entry array string to a nu array
export def "type array read" [
  value: string        # The desktop entry value
]: nothing -> list<string> {
  let res = $value | split row ";"
  if (($res | last 1) == [ "" ]) {
    let res = $res | drop 1
  }
  $res
}
# Converts from a nu array string to a desktop entry array
export def "type array write" [
  value: list<string>  # The array
]: nothing -> string {
  $value | str join ";"
}

# Converts from a desktop entry string to a nu string
export def "type string read" [
  value: string        # The string
]: nothing -> string {
  $value
}
# Converts from a nu string to a desktop entry string
export def "type string write" [
  value: string        # The string
]: nothing -> string {
  $value
}

# Converts from a desktop entry localestring to a nu string
export def "type localestring read" [
  value: string        # The localestring
]: nothing -> string {
  $value
}
# Converts from a nu string to a desktop entry localestring
export def "type localestring write" [
  value: string        # The string
]: nothing -> string {
  $value
}

# Converts from a desktop entry iconstring to a nu string
export def "type iconstring read" [
  value: string        # The iconstring
]: nothing -> string {
  $value
}
# Converts from a nu string to a desktop entry iconstring
export def "type iconstring write" [
  value: string        # The string
]: nothing -> string {
  $value
}

# Converts from a desktop entry boolean to a nu bool
export def "type boolean read" [
  value: string        # The boolean
]: nothing -> bool {
  $value | into bool
}
# Converts from a nu bool to a desktop entry boolean
export def "type boolean write" [
  value: bool          # The bool
]: nothing -> string {
  $value | into string
}

# Converts from a desktop entry numeric to a nu float
export def "type numeric read" [
  value: string        # The numeric
]: nothing -> float {
  $value | into float
}
# Converts from a nu float to a desktop entry numeric
export def "type numeric write" [
  value: float         # The float
]: nothing -> string {
  $value | into string
}

# Returns a type based on a key
export def "type getForKey" [
  key: string          # The desktop entry key
]: nothing -> record {
  match $key {
    "Type" => { type: "string" },
    "Version" => { type: "string" },
    "Name" => { type: "localestring" },
    "GenericName" => { type: "localestring" },
    "NoDisplay" => { type: "boolean" },
    "Comment" => { type: "localestring" },
    "Icon" => { type: "iconstring" },
    "Hidden" => { type: "boolean" },
    "OnlyShowIn" => { type: "array", contains: "string" },
    "NotShowIn" => { type: "array", contains: "string" },
    "DBusActivatable" => { type: "boolean" },
    "TryExec" => { type: "string" },
    "Exec" => { type: "string" },
    "Path" => { type: "string" },
    "Terminal" => { type: "string" },
    "Actions" => { type: "array", contains: "string" },
    "MimeType" => { type: "array", contains: "string" },
    "Categories" => { type: "array", contains: "string" },
    "Implements" => { type: string, contains: "string" },
    "Keywords" => { type: "array", contains: "localestring" },
    "StartupNotify" => { type: "boolean" },
    "StartupWMClass" => { type: "string" },
    "URL" => { type: "string" },
    "PrefersNonDefaultGPU" => { type: "boolean" },
    "SingleMainWindow" => { type: "boolean" }
  }
}

# Converts a desktotp entry type to a nushell type
export def "type read" [
  type: record         # The desktop entry type to convert from
  value: string        # The desktop entry value
]: [nothing -> string, nothing -> bool, nothing -> float, nothing -> list<string>, nothing -> list<bool>, nothing -> list<float>] {
  match $type.type {
    "string" => (type string read $value),
    "localestring" => (type localestring read $value),
    "iconstring" => (type iconstring read $value),
    "boolean" => (type boolean read $value),
    "numeric" => (type numeric read $value),
    "array" => {
      let array = type array read $value

      match $type.contains {
        "string" => ($array | each { |it| type string read $it }),
    	"localestring" => ($array | each { |it| type localestring read $it }),
    	"iconstring" => ($array | each { |it| type iconstring read $it }),
    	"boolean" => ($array | each { |it| type boolean read $it }),
    	"numeric" => ($array | each { |it| type numeric read $it })
      }
    }
  }
}
export def "type write" [
  type: record         # The desktop entry type to convert to
  value: any           # The nu value
]: nothing -> string {
  match $type.type {
    "string" => (type string write $value),
    "localestring" => (type localestring write $value),
    "iconstring" => (type iconstring write $value),
    "boolean" => (type boolean write $value),
    "numeric" => (type numeric write $value),
    "array" => {
      let array = match $type.contains {
        "string" => ($value | each { |it| type string write $it }),
    	"localestring" => ($value | each { |it| type localestring write $it }),
    	"iconstring" => ($value | each { |it| type iconstring write $it }),
    	"boolean" => ($value | each { |it| type boolean write $it }),
    	"numeric" => ($value | each { |it| type numeric write $it })
      }

      type array write $array
    }
  }
}

# Parses a desktop entry file from stdin
export def parse []: string -> any {
  from ini | transpose key value | par-each {
    |it|
    {
      key: (if ($it.key | str contains "Desktop Action ") { $it.key | str replace "Desktop Action " "" } else { $it.key })
      value: ($it.value | transpose key value | par-each {
        |it|
        let langStart = $it.key | str index-of "["
        let langEnd = $it.key | str index-of "]"
        let hasLang = ($langStart != -1 and $langEnd != -1)

        let key = if (not $hasLang) { $it.key } else { $it.key | str substring 0..($langStart - 1) }
        let type = type getForKey $key
      
        let language = language parse (if (not $hasLang) { "" } else { $it.key | str substring ($langStart + 1)..($langEnd - 1) })
      
        let value = type read $type $it.value

        match $type {
          { type: "localestring" } => { key: $key, language: $language, value: $value },
          { type: "iconstring" } => { key: $key, language: $language, value: $value },
          { type: "array", contains: "localestring" } => { key: $key, language: $language, value: $value },
          { type: "array", contains: "iconstring" } => { key: $key, language: $language, value: $value },
          _ => { key: $key, value: $value }
      	}
      })
    }
  }
}
