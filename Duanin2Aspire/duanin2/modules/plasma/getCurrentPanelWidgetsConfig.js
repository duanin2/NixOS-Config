let allPanels = panels();
for (const panel of allPanels) {
  print(`${panel.id}:\n`);
  let allWidgets = panel.widgets();
  for (const widget of allWidgets) {
    print(`  ${widget.id}:\n`);
    print(`    type: ${widget.type}\n`);
    print(`    version: ${widget.version}\n`);
    print(`    index: ${widget.index}\n`);
    print(`    geometry:\n`);
    print(`      x: ${widget.geometry.x}\n`);
    print(`      y: ${widget.geometry.y}\n`);
    print(`      width: ${widget.geometry.width}\n`);
    print(`      height: ${widget.geometry.height}\n`);
    print(`    config:\n`);
    printConfig(widget, [], 3);
    print(`    globalConfig:\n`);
    printGlobalConfig(widget, [], 3);
  }
}

function printConfig(widget, currentConfigGroup, offset = 0) {
  let offsetter = "";
  for (let i = 0; i < offset; i++) {
    offsetter += "  ";
  }
  widget.currentConfigGroup = cloneArray(currentConfigGroup);

  for (const configKey of widget.configKeys) {
    print(`${offsetter}${configKey}: ${widget.readConfig(configKey)}\n`);
  }

  for (const configGroup of widget.configGroups) {
    print(`${offsetter}${configGroup}:\n`);
    let newConfigGroup = cloneArray(currentConfigGroup);
    newConfigGroup.push(configGroup);
    printConfig(widget, newConfigGroup, offset + 1);
    widget.currentConfigGroup = cloneArray(currentConfigGroup);
  }
}
function printGlobalConfig(widget, currentConfigGroup, offset = 0) {
  let offsetter = "";
  for (let i = 0; i < offset; i++) {
    offsetter += "  ";
  }
  widget.currentGlobalConfigGroup = cloneArray(currentConfigGroup);

  for (const configKey of widget.globalConfigKeys) {
    print(`${offsetter}${configKey}: ${widget.readGlobalConfig(configKey)}\n`);
  }

  for (const configGroup of widget.globalConfigGroups) {
    print(`${offsetter}${configGroup}:\n`);
    let newConfigGroup = cloneArray(currentConfigGroup);
    newConfigGroup.push(configGroup);
    printGlobalConfig(widget, newConfigGroup, offset + 1);
    widget.currentGlobalConfigGroup = cloneArray(currentConfigGroup);
  }
}

function cloneArray(array) {
  let result = [];

  for (const item of array) {
    result.push(item);
  }

  return result;
}

