{ writers }: writers.writeNuBin "uevent.nu" ''
export def "parseData" [] {
  lines | parse "{name}={value}" | transpose -r
}

export def "getVar" [
  name: string
] {
  get -i $name
}
''