{ lib, ueventNu, writers }: writers.writeNuBin "battery.nu" ''
use ${lib.getExe ueventNu}

def intPadding [
    value: int
] {
  if ($value < 10) {
    "0" + ($value | into string)
  } else {
    $value | into string
  }
}

def batteries [] {
  ls /sys/class/power_supply/*/uevent | par-each { |it|
    let data = open $it.name | uevent parseData
    if (($data | uevent getVar "DEVTYPE" | get 0) == "power_supply" and ($data | uevent getVar "POWER_SUPPLY_TYPE" | get 0) == "Battery" and ($data | uevent getVar "POWER_SUPPLY_PRESENT" | get 0) == 1) {
      $it.name
    } else {
      null
    }
                                                 }
}

def main [] {
  mut lastData = []
  
  while true {
    sleep 200ms
    let data = batteries | par-each { open $in | uevent parseData }

    if ($lastData == $data) { continue }
    $lastData = $data

    $data | par-each { |it|
      let name = $it | uevent getVar "POWER_SUPPLY_NAME" | get 0
      let capacity = $it | uevent getVar "POWER_SUPPLY_CAPACITY" | get 0
      let health = (($it | uevent getVar "POWER_SUPPLY_CHARGE_FULL" | get 0) / ($it | uevent getVar "POWER_SUPPLY_CHARGE_FULL_DESIGN" | get 0) * 100) | math round
      let status = $it | uevent getVar "POWER_SUPPLY_STATUS"
      let remainTimeTotal = try { ($it | uevent getVar "POWER_SUPPLY_CHARGE_NOW" | get 0) / ($it | uevent getVar "POWER_SUPPLY_CURRENT_NOW" | get 0) * 60 * 60 | math round } catch { 0 }
      let remainTimeSeconds = $remainTimeTotal mod 60
      let remainTimeMinutes = ($remainTimeTotal - $remainTimeSeconds) / 60 mod 60
      let remainTimeHours = (($remainTimeTotal - $remainTimeSeconds) / 60 - $remainTimeMinutes) / 60
      let remainTime = $"(intPadding $remainTimeHours):(intPadding $remainTimeMinutes):(intPadding $remainTimeSeconds)"

      let icon = if ($capacity >= 95) {
    	  if ($status == "Charging") {
	        "󰂅"
	      } else {
	        "󰁹"
	      }
          } else if ($capacity >= 85) {
    	  if ($status == "Charging") {
	        "󰂋"
	      } else {
	        "󰂂"
	      }
          } else if ($capacity >= 75) {
    	  if ($status == "Charging") {
	        "󰂊"
	      } else {
	        "󰂁"
	      }
          } else if ($capacity >= 65) {
    	  if ($status == "Charging") {
	        "󰢞"
	      } else {
	        "󰂀"
	      }
          } else if ($capacity >= 55) {
     	  if ($status == "Charging") {
	        "󰂉"
	      } else {
	        "󰁿"
	      }
          } else if ($capacity >= 45) {
    	  if ($status == "Charging") {
	        "󰢝"
	      } else {
	        "󰁾"
	      }
          } else if ($capacity > 35) {
    	  if ($status == "Charging") {
	        "󰂈"
	      } else {
	        "󰁽"
	      }
          } else if ($capacity >= 25) {
    	  if ($status == "Charging") {
	        "󰂇"
	      } else {
	        "󰁼"
	      }
          } else if ($capacity >= 15) {
    	  if ($status == "Charging") {
	        "󰂆"
	      } else {
	        "󰁻"
	      }
          } else if ($capacity >= 5) {
    	  if ($status == "Charging") {
	        "󰢜"
	      } else {
	        "󰁺"
	      }
          } else if ($capacity >= 0) {
    	  if ($status == "Charging") {
	        "󰢟"
	      } else {
	        "󰂎"
	      }
          } else {
    	  "󰂑"
          }
      let icon = $icon
      {
        name: $name
    	  capacity: $capacity
	      health: $health
	      remainTime: $remainTime
	      icon: $icon
      }
                     } | sort-by -n name | to json -r | print
  }
}
''
