//General defines
private _nameBase = "Bum_Blindzeus";
private _settingsCategory = "Blindzeus settings";
private _settingName = "";
private _prettyName = "";
private _tooltip = "";

//Sub-Category 
//"General Blindzeus Settings"
private _prettySubCategoryName = "General Blindzeus Settings";

//enableDebug
_settingName = [_nameBase, "enableDebug"] joinString "_";
_prettyName = "Enable Debug";
_tooltip = "Enable some debug functionality";
[
    _settingName, // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    [_prettyName,_tooltip], // Pretty name shown inside the ingame settings menu. Can be stringtable entry. Also tooltip.
    [_settingsCategory,_prettySubCategoryName], // Category for the settings menu + optional sub-category <STRING, ARRAY>
    false,
    1 //1: all clients share the same setting, 2: setting can’t be overwritten (optional, default: 0)
] call cba_Settings_fnc_init;

//HideSettings
_settingName = [_nameBase, "hideSetting"] joinString "_"; //Bum_Blindzeus_hideSetting
_prettyName = "Unit hiding and showing";
_tooltip = "You can decide the degree to which you are able to see hidden units";
[
    _settingName,
    "LIST",
    [_prettyName,_tooltip],
    [_settingsCategory,_prettySubCategoryName],
    [[0,1,2], ["No units are hidden, use only this in SP", "Units remain hidden all the time","Units will get show for a brief time if seen by controlled units"],2],
    1
] call cba_Settings_fnc_init;

//Sub-Category
//"UnFuck"
_prettySubCategoryName = "UnFuck Module Settings";

//Requirements for flipping
_settingName = [_nameBase, "unFuck_flipReq"] joinString "_";
_prettyName = "Requirements to flip and move vehicles";
_tooltip = "You can decide what are the requirements for the vehicle to get flipped";
[
    _settingName,
    "LIST",
    [_prettyName,_tooltip],
    [_settingsCategory,_prettySubCategoryName],
    [[0,1,2], ["Always allow", "Allow if detected as flipped or repair near","Allow if repair vehicle nearby"],1],
    1
] call cba_Settings_fnc_init;

//Requirements for refitting
_settingName = [_nameBase, "unFuck_refitReq"] joinString "_";
_prettyName = "Refit Requirement";
_tooltip = "You can decide what are the requirements for the vehicle to get fix/rearm/refuel";
[
    _settingName,
    "LIST",
    [_prettyName,_tooltip],
    [_settingsCategory,_prettySubCategoryName],
    [[0,1,2,3], ["No vehicles needed nearby", "Repair vehicle can do everything","Each action needs specific vehicles", "Disable refit actions for the module"],2],
    1
] call cba_Settings_fnc_init;