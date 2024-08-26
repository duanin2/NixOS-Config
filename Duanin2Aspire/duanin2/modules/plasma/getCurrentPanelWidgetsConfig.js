let allPanels = panels();
print(`panels:\n`);
for (const panel of allPanels) {
  print(`  ${panel.id}:\n`);
  print(`    formFactor: ${panel.formFactor}\n`);
  print(`    screen: ${panel.screen}\n`);
  print(`    version: ${panel.version}\n`);
  print(`    lengthMode: ${panel.lengthMode}\n`);
  print(`    config:\n`);
  printConfig(panel, [], 3);
  print(`    globalConfig:\n`);
  printGlobalConfig(panel, [], 3);

  panel.currentConfigGroup = [ "General" ];
  let widgetOrder = panel.readConfig("AppletOrder", "").split(";");
  for (let i = 0; i < widgetOrder.length; i++) {
    widgetOrder[i] = parseInt(widgetOrder[i]);
  }

  print(`    widgets:\n`);
  let allWidgets = panel.widgets();
  for (const widget of allWidgets) {
    let index = widgetOrder.indexOf(widget.id);

    print(`      ${widget.id}:\n`);
    print(`        type: ${widget.type}\n`);
    print(`        version: ${widget.version}\n`);
    print(`        index: ${index}\n`);
    print(`        geometry:\n`);
    print(`          x: ${widget.geometry.x}\n`);
    print(`          y: ${widget.geometry.y}\n`);
    print(`          width: ${widget.geometry.width}\n`);
    print(`          height: ${widget.geometry.height}\n`);
    print(`        config:\n`);
    printConfig(widget, [], 5);
    print(`        globalConfig:\n`);
    printGlobalConfig(widget, [], 5);
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

