{ lib, nushell, writeScriptBin, socat }: writeScriptBin "hyprlandSock2.nu" ''
let socket = $"UNIX-CONNECT:($env.XDG_RUNTIME_DIR)/hypr/($env.HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock"

let data = ${lib.getExe socat} -U - $socket | lines
let splitData = $data | each { parse "{event}>>{data}" }
let parsedData = $splitData | each {
    match $in.event {
        "workspace" => ($in | upsert data ($in.data | parse "{workspaceName}")),
        "workspacev2" => ($in | upsert data ($in.data | parse "{workspaceId},{workspaceName}")),
        "focusedmon" => ($in | upsert data ($in.data | parse "{monName},{workspaceName}")),
        "activewindow" => ($in | upsert data ($in.data | parse "{windowsClass},{windowsTitle}")),
        "activewindowv2" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "fullscreen" => ($in | upsert data ($in.data | parse "{fullscreen}" | upsert fullscreen (if ($in.fullscreen == 0) { false } else { true }))),
        "monitorremoved" => ($in | upsert data ($in.data | parse "{monitorName}")),
        "monitoradded" => ($in | upsert data ($in.data | parse "{monitorName}")),
        "monitoraddedv2" => ($in | upsert data ($in.data | parse "{monitorId},{monitorName},{monitorDescription}")),
        "createworkspace" => ($in | upsert data ($in.data | parse "{workspaceName}")),
        "createworkspacev2" => ($in | upsert data ($in.data | parse "{workspaceId},{workspaceName}")),
        "destroyworkspace" => ($in | upsert data ($in.data | parse "{workspaceName}")),
        "destroyworkspacev2" => ($in | upsert data ($in.data | parse "{workspaceId},{workspaceName}")),
        "moveworkspace" => ($in | upsert data ($in.data | parse "{workspaceName},{monName}")),
        "moveworkspacev2" => ($in | upsert data ($in.data | parse "{workspaceId},{workspaceName},{monName}")),
        "renameworkspace" => ($in | upsert data ($in.data | parse "{workspaceId},{newName}")),
        "activespecial" => ($in | upsert data ($in.data | parse "{workspaceName},{monName}")),
        "activelayout" => ($in | upsert data ($in.data | parse "{keyboardName},{layoutName}")),
        "openwindow" => ($in | upsert data ($in.data | parse "{windowAddress},{workspaceName},{windowClass},{windowTitle}")),
        "closewindow" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "movewindow" => ($in | upsert data ($in.data | parse "{windowsAddress},{workspaceName}")),
        "movewindowv2" => ($in | upsert data ($in.data | parse "{windowsAddress},{workspaceId},{workspaceName}")),
        "openlayer" => ($in | upsert data ($in.data | parse "{namespace}")),
        "closelayer" => ($in | upsert data ($in.data | parse "{namespace}")),
        "submap" => ($in | upsert data ($in.data | parse "{submapName}")),
        "changefloatingmode" => ($in | upsert data ($in.data | parse "{windowAddress},{floating}")),
        "urgent" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "minimize" => ($in | upsert data ($in.data | parse "{windowAddress},{minimize}")),
        "screencast" => ($in | upsert data ($in.data | parse "{state},{owner}")),
        "windowtitle" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "togglegroup" => ($in | upsert data ($in.data | parse "{state},{windowAddresses}" | upsert windowAddresses ($in.windowAddresses | str split ",") | upsert state (if ($in.state == 0) { false } else { true }))),
        "moveintogroup" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "moveoutofgroup" => ($in | upsert data ($in.data | parse "{windowAddress}")),
        "ignoregrouplock" => ($in | upsert data ($in.data | parse "{ignored}" | upsert ignored (if ($in.ignored == 0) { false } else { true }))),
        "lockgroups" => ($in | upsert data ($in.data | parse "{locked}" | upsert locked (if ($in.locked == 0) { false } else { true }))),
        "configreloaded" => ($in | upsert data ($in.data | parse "")),
        "pin" => ($in | upsert data ($in.data | parse "{windoAddress},{pinState}"))
    }
}
'';
