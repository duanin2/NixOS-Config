{ lib, nushell, writeScriptBin }: writeScriptBin "nmcli.nu" ''
#!${lib.getExe nushell}

# the NetworkManager CLI utility for Nushell
export def "main" [
    --ask(-a)          # ask for missing parameters
    --help(-h) 	       # print this help
    --show-secrets(-s) # allow displaying passwords
    --version(-v)      # show program version
    --wait(-w) 	       # set timeout waiting for finishing operations
]: [nothing -> nothing, nothing -> table<device: string, type: string, state: string, ip4Connectivity: string, ip6Connectivity: string, dbusPath: string, connection: string, conUuid: string>] {
    if ($version) {
        let version = main general | get 0.version
	echo $"nmcli, version ($version)"
    } else {
      	main device
    }
}

# general information about NetworkManager
export def "main general" [
    --ask(-a)          # ask for missing parameters
    --help(-h) 	       # print this help
    --show-secrets(-s) # allow displaying passwords
    --version(-v)      # show program version
    --wait(-w) 	       # set timeout waiting for finishing operations
]: nothing -> table<running: bool, version: string, state: string, startup: string, connectivity: string, networking: string, wifiHw: string, wifi: string, wwanHw: string, wwan: string> {
    ^nmcli -t -f all general | lines | parse --regex "^(?P<running>[^:]*):(?P<version>[^:]*):(?P<state>[^:]*):(?P<startup>[^:]*):(?P<connectivity>[^:]*):(?P<networking>[^:]*):(?P<wifiHw>[^:]*):(?P<wifi>[^:]*):(?P<wwanHw>[^:]*):(?P<wwan>[^:]*)$" | update 
}

export def "main networking" [] {
    ^nmcli -t networking
}

export def "main radio" [] {
    ^nmcli -t -f all radio | lines | parse --regex "^(?P<wifiHw>[^:]*):(?P<wifi>[^:]*):(?P<wwanHw>[^:]*):(?P<wwan>[^:]*)$"
}

export def "main connection" [] {
    ^nmcli -t -f all connection | lines | parse --regex "^(?P<name>[^:]*):(?P<uuid>[^:]*):(?P<type>[^:]*):(?P<timestamp>[^:]*):(?P<timestampReal>[^:]*):(?P<autoconnect>[^:]*):(?P<autoconnectPriority>[^:]*):(?P<readonly>[^:]*):(?P<dbusPath>[^:]*):(?P<active>[^:]*):(?P<device>[^:]*):(?P<state>[^:]*):(?P<activePath>[^:]*):(?P<slave>[^:]*):(?P<filename>[^:]*)$"
}

export def "main device" []: nothing -> table<device: string, type: string, state: string, ip4Connectivity: string, ip6Connectivity: string, dbusPath: string, connection: string, conUuid: string> {
    ^nmcli -t -f all device | lines | parse --regex "^(?P<device>[^:]*):(?P<type>[^:]*):(?P<state>[^:]*):(?P<ip4Connectivity>[^:]*):(?P<ip6Connectivity>[^:]*):(?P<dbusPath>[^:]*):(?P<connection>[^:]*):(?P<conUuid>[^:]*)"
}
''
