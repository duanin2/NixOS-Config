{ pkgs, ... }: ''
#!${pkgs.nodejs_20}/bin/node

const { env } = require('node:process');
const { EOL } = require('node:os');
const fs = require('node:fs/promises');
const path = require('node:path');

class Locale {
		#language;
		#country;
		#encoding;
		#modifier;
		
		constructor(lang) {
				this.#language = lang.split("@")[0].split(".")[0].split("_")[0];
				try {
						this.#country = lang.split("@")[0].split(".")[0].split("_")[1];
				} catch (err) { }
				try {
						this.#encoding = lang.split("@")[0].split(".")[1];
				} catch (err) { }
				try {
						this.#modifier = lang.split("@")[1];
				} catch (err) { }
		}

		get language() {
				return this.#language;
		}
		get country() {
				return this.#country;
		}
		get encoding() {
				return this.#encoding;
		}
		get modifier() {
				return this.#modifier;
		}

		static matchLangLang(lang1, lang2) {
				const locale1 = new Locale(lang1);
				const locale2 = new Locale(lang2);

				if (locale1 == locale2) {
						return true;
				} else if (locale1.language == locale2.language && (!locale1.country || !locale2.country || locale1.country == locale2.country) && (!locale1.encoding || !locale2.encoding || locale1.encoding == locale2.encoding) && (!locale1.modifier || !locale2.modifier || locale1.modifier == locale2.modifier)) {
						return true;
				} else {
						return false;
				};
		}

		static matchLangLocale(lang1, locale2) {
				const locale1 = new Locale(lang1);

				if (locale1 == locale2) {
						return true;
				} else if (locale1.language == locale2.language && (!locale1.country || !locale2.country || locale1.country == locale2.country) && (!locale1.encoding || !locale2.encoding || locale1.encoding == locale2.encoding) && (!locale1.modifier || !locale2.modifier || locale1.modifier == locale2.modifier)) {
						return true;
				} else {
						return false;
				};
		}

		static matchLocaleLocale(locale1, locale2) {
				if (locale1 == locale2) {
						return true;
				} else if (locale1.language == locale2.language && (!locale1.country || !locale2.country || locale1.country == locale2.country) && (!locale1.encoding || !locale2.encoding || locale1.encoding == locale2.encoding) && (!locale1.modifier || !locale2.modifier || locale1.modifier == locale2.modifier)) {
						return true;
				} else {
						return false;
				};
		}

		toString() {
				return this.#language + this.#country ? "_" + this.#country : "" + this.#encoding ? "." + this.#encoding : "" + this.#modifier ? "@" + this.#modifier : "";
		}
}

class DesktopEntryValue {
		#value;
		constructor(value) {
				this.#value = value;
		}

		get value() {
				return this.#value;
		}

		valueOf() {
				return this.#value;
		}

		toString() {
				return this.#value.toString();
		}
}

class DesktopEntryString extends DesktopEntryValue {
		constructor(value) {
				super(value.toString());
		}
}

class DesktopEntryLocalestring extends DesktopEntryString {
		#locale;
		constructor(value, locale = undefined) {
				super(value);
				if (!locale instanceof Locale) {
						throw new TypeError("Expected Locale.");
				}
				this.#locale = locale;
		}

		get locale() {
				return this.#locale;
		}
}

class DesktopEntryBoolean extends DesktopEntryValue {
		constructor(value) {
				let trueValue;
				if (value == "true") {
						trueValue = true;
				} else if (value == "false") {
						trueValue = false;
				} else {
						throw new RangeError(`Expected "true" or "false".`);
				}
				super(trueValue);
		}
}

class DesktopEntryNumber extends DesktopEntryValue {
		constructor(value) {
				super(Number(value));
		}
}

class DesktopEntry {
		#Type;
		#Version;
		#Name = [];
		#GenericName = [];
		#NoDisplay;
		#Comment = [];
		#Icon = [];
		#Hidden;
		#OnlyShowIn = [];
		#NotShowIn = [];
		#DBusActivatable;
		#TryExec;
		#Exec;
		#Path;
		#Terminal;
		#Actions = [];
		#MimeType = [];
		#Categories = [];
		#Keywords = [];
		#StartupNotify;
		#StartupWMClass;
		#URL;
#fileLocation;

		constructor(fileContents, fileLocation = undefined) {
				fileContents = fileContents.split(EOL);
				this.#fileLocation = fileLocation;

				let hasBegun = 0;
				
				for (let line = 0; line < fileContents.length; line++) {
						const lineContents = fileContents[line];
						if (lineContents != "[Desktop Entry]" && hasBegun == 0) {
								continue;
						}
						hasBegun = 1;

						/*for (const action of this.#Actions) {
								if (lineContents == "[Desktop Action " + action + "]") {
										hasBegun == action;
										break;
								}
						}*/

						if (lineContents == "") {
								continue;
						}

						if (!(lineContents.includes("="))) {
								//break;
								continue;
						}

						let key = lineContents.split("=")[0];
						let value = lineContents.split("=")[1];
						let locale;

						if (key.match(/\[.*\]/g)) {
								locale = new Locale(key.slice(key.search(/\[.*\]/g)+1, key.length-1));
								key = key.replace("[" + locale + "]", "");
						}

						switch (key) {
						case "Type":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Type = new DesktopEntryString(value);
								break;
						case "Version":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Version = new DesktopEntryString(value);
								break;
						case "Name":
								this.#Name.push(new DesktopEntryLocalestring(value, locale))
								break;
						case "GenericName":
								this.#GenericName.push(new DesktopEntryLocalestring(value, locale))
								break;
						case "NoDisplay":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#NoDisplay = new DesktopEntryBoolean(value);
								break;
						case "Comment":
								this.#Comment.push(new DesktopEntryLocalestring(value, locale));
								break;
						case "Icon":
								this.#Icon.push(new DesktopEntryLocalestring(value, locale));
								break;
						case "Hidden":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Hidden = new DesktopEntryBoolean(value);
								break;
						case "OnlyShowIn":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#OnlyShowIn.push(new DesktopEntryString(val));
								}
								break;
						case "NotShowIn":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#NotShowIn.push(new DesktopEntryString(val));
								}
								break;
						case "DBusActivatable":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#DBusActivatable = new DesktopEntryBoolean(value);
								break;
						case "TryExec":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#TryExec = new DesktopEntryString(value);
								break;
						case "Exec":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Exec = new DesktopEntryString(value);
								break;
						case "Path":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Path = new DesktopEntryString(value);
								break;
						case "Terminal":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#Terminal = new DesktopEntryBoolean(value);
								break;
						case "Actions":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#Actions.push(new DesktopEntryString(val));
								}
								break;
						case "MimeType":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#MimeType.push(new DesktopEntryString(val));
								}
								break;
						case "Categories":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#Categories.push(new DesktopEntryString(val));
								}
								break;
						case "Keywords":
								for (let val of value.split(";")) {
										if (!val) {
												continue;
										}

										this.#Keywords.push(new DesktopEntryLocalestring(val, locale));
								}
								break;
						case "StartupNotify":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#StartupNotify = new DesktopEntryBoolean(value);
								break;
						case "StartupWMClass":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#StartupWMClass = new DesktopEntryString(value);
								break;
						case "URL":
								if (locale) {
										throw new TypeError("Unexpected locale.");
								}
								this.#URL = new DesktopEntryString(value);
								break;
						/*default:
								console.error(new RangeError("Unknown key " + key));*/
						}
				}

				if (!this.#Type || !this.#Name || (this.#Type == "Link" && !this.#URL)) {
						throw new RangeError("Required parameter is missing.");
				}
		}

		get Type() {
				return this.#Type;
		}
		get Version() {
				return this.#Version;
		}
		get Name() {
				return this.#Name;
		}
		get GenericName() {
				return this.#GenericName;
		}
		get NoDisplay() {
				return this.#NoDisplay;
		}
		get Comment() {
				return this.#Comment;
		}
		get Icon() {
				return this.#Icon;
		}
		get Hidden() {
				return this.#Hidden;
		}
		get OnlyShowIn() {
				return this.#OnlyShowIn;
		}
		get NotShowIn() {
				return this.#NotShowIn;
		}
		get DBusActivatable() {
				return this.#DBusActivatable;
		}
		get TryExec() {
				return this.#TryExec;
		}
		get Exec() {
				return this.#Exec;
		}
		get Path() {
				return this.#Path;
		}
		get Terminal() {
				return this.#Terminal;
		}
		get Actions() {
				return this.#Actions;
		}
		get MimeType() {
				return this.#MimeType;
		}
		get Categories() {
				return this.#Categories;
		}
		get Keywords() {
				return this.#Keywords;
		}
		get StartupNotify() {
				return this.#StartupNotify;
		}
		get StartupWMClass() {
				return this.#StartupWMClass;
		}
		get URL() {
				return this.#URL;
		}
		get fileLocation() {
				return this.#fileLocation;
		}
}

const appDirs = (function() {
		let dirs = env.XDG_DATA_DIRS.split(":");

		for (let i = 0; i < dirs.length; i++) {
				dirs[i] = path.join(dirs[i], "applications");
		}

		return dirs;
})();
const currentDesktop = env.XDG_CURRENT_DESKTOP;
const locale = new Locale(env.LANG);

(async function() {
		let menu = [];
		const apps = await (async function() {
				let apps = [];
				for (let i = appDirs.length - 1; i >= 0; i--) {
						try {
								const files = await fs.readdir(appDirs[i]);
								
								for (const file of files) {
										if (path.extname(file) != ".desktop") {
												continue;
										}
										try {
												apps.push(new DesktopEntry(await fs.readFile(path.join(appDirs[i], file), "utf-8"), path.join(appDirs[i], file)));
										} catch (err) {
												console.log(err);
										}
								}
						} catch (err) {
								if (err.code == 'ENOENT') {
										continue;
								}
								console.error(err);
						}
				}
				
				return apps;
		})();
		
		for (const app of apps) {
				if (app.Hidden || app.NoDisplay) {
						continue;
				}

				if (app.OnlyShowIn.length > 0) {
						let isForCurrentDesktop = false;
						for (const desktop of app.OnlyShowIn) {
								if (desktop == currentDesktop) {
										isForCurrentDesktop = true;
										break;
								}
						}
						if (!isForCurrentDesktop) {
								continue;
						}
				}

				if (app.NotShowIn.length > 0) {
						let isForCurrentDesktop = true;
						for (const desktop of app.NotShowIn) {
								if (desktop == currentDesktop) {
										isForCurrentDesktop = false;
										break;
								}
						}
						if (!isForCurrentDesktop) {
								continue;
						}
				}
				
				if (app.TryExec != undefined) {
						if (path.isAbsolute(app.TryExec.toString())) {
								try {
										await fs.readFile(app.TryExec.toString());
								} catch (err) {
										if (!err.code == "ENOENT") {
												console.error(err);
										}
										continue;
								}
						} else {
								let exists = false;
								for (const dir of env.PATH.split(":")) {
										try {
												await fs.readFile(path.join(dir, app.TryExec.toString()));
												exists = true;
												break;
										} catch (err) {
												if (!err.code == "ENOENT") {
														console.error(err);
												}
												continue;
										}
								}
								if (!exists) {
										continue;
								}
						}
				}

				const localestringSearch = async function(values) {
						let defaultValue;
						for (value of app.Name) {
								if (value.locale == undefined) {
										defaultValue = value.value;
										continue;
								}
								if (Locale.matchLocaleLocale(value.locale, locale)) {
										return value.value;
								}
						}
						
						return defaultValue;
				};

				const name = await localestringSearch(app.Name);
				const icon = await localestringSearch(app.Icon);

				let exec = app.Exec.value;
				exec = exec.replace(" %f", "");
				exec = exec.replace(" %F", "");
				exec = exec.replace(" %u", "");
				exec = exec.replace(" %U", "");
				exec = exec.replace(" %i", icon ? "--icon " + icon : "");
				exec = exec.replace(" %c", name);
				exec = exec.replace(" %k", app.fileLocation ? app.fileLocation : "");

				menu.push({
						name,
						comment: await localestringSearch(app.Comment),
						workDir: app.Path != undefined ? app.Path.value : env.HOME,
						terminal: app.Terminal != undefined ? app.Terminal.value : false, 
						exec
				});
		}

		console.log(JSON.stringify(menu));
})();
''
