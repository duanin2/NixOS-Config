{ lib, libnotify, writers }: writers.writeNuBin "osd.nu" ''
def main [
	prompt: string,
	percent: int
] {
	${lib.getExe libnotify} -t 1000 -a "osd" -h $"int:value:($percent)" $"($prompt): ($percent)%"
}
''