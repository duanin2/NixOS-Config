{ pkgs }: ''
#!${pkgs.nodejs_20}
const timers = require('node:timers/promises')
const execFile = require('node:util').promisify(require('node:child_process').execFile)

async function focus(window, focusedWorkspace) {
    let command = `hyprctl --batch "keyword general:no_cursor_warps true;`

    if (window.workspace.id < 0) {
				command += `dispatch movetoworkspacesilent ${focusedWorkspace.id},address:${window.address};`
    }
    command += `dispatch focuswindow address:${window.address};`
    command += `keyword general:no_cursor_warps false"`
    return command
}
async function minimize(window) {
    return `hyprctl dispatch movetoworkspacesilent special,address:${window.address}`
}
async function close(window) {
    return `hyprctl dispatch closewindow address:${window.address}`
}

async function genJSON(windows, focusedWorkspace, focusedWindow) {
    let out = []

    for (window of windows) {
        if (window.class == "") {
            continue
				}
				out[out.length] = {
						isFocused: (focusedWindow.address == window.address) ? true : false,
						focus: await focus(window, focusedWorkspace),
						minimize: await minimize(window),
						close: await close(window),
						title: window.title
				}
		}
    return out
}

(async function() {
		let windows, focusedWindow, focusedWorkspace
		let prevWindows, prevFocusedWindow, prevFocusedWorkspace 
		for await (const json of timers.setInterval(1000, genJSON)) {
				prevWindows = windows
				prevFocusedWindow = focusedWindow
				prevFocusedWorkspace = focusedWorkspace
				
				try {
						windows = (await execFile('hyprctl', ['clients', '-j'])).stdout
						focusedWindow = (await execFile('hyprctl', ['activewindow', '-j'])).stdout
						focusedWorkspace = (await execFile('hyprctl', ['activeworkspace', '-j'])).stdout
				} catch (err) {
						console.error(err)
						continue
				}

				if (windows != prevWindows || focusedWindow != prevFocusedWindow || focusedWorkspace != prevFocusedWorkspace) {
						console.log(JSON.stringify(await genJSON(JSON.parse(windows), JSON.parse(focusedWorkspace), JSON.parse(focusedWindow))))
				}
		}
})()
''
