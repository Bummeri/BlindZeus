params ["_dialog","_controls","_saving"];

//Will save or load previous settings of the dialogs controls into/from missionNamespace.
//Variable name will be: "blindzeus_Settings_*dialogClassname"
//Variable format will be: [[_ctrlClassname1, _ctrlClassname2...],[_valueForCtrl1, _valueForCtrl2,...]]
//If you dont want to handle some control from dialog, just dont put it into _controls parameter

private _dialogClassName = _dialog getVariable ["BIS_fnc_initDisplay_configClass", ""];//Todo test!
private _dialogSettingsVarName = format ["blindzeus_Settings_%1",_dialogClassName];
private _prevSettings = missionNamespace getVariable [_dialogSettingsVarName, []];
private _newSettings = [[],[]];

if (!_saving && (_prevSettings isEqualTo [])) exitWith {
	//Nothing to load
};

{
	private _ctrl = _x;
	private _ctrlClassname = ctrlClassName _ctrl;
	private _value = true;
	if (_saving) then {
		switch (ctrlType _ctrl) do {//You can add cases here for different types of controls to support them
			case 77: {_value = cbChecked _ctrl};
		};
		(_newSettings select 0) pushBack _ctrlClassname;
		(_newSettings select 1) pushBack _value;
	} else {
		//Loading
		private _ctrlValuePos = (_prevSettings select 0) find _ctrlClassname;
		if (_ctrlValuePos > -1) then {
			_value = (_prevSettings select 1) select _ctrlValuePos; 
			switch (ctrlType _ctrl) do {//You can add cases here for different types of controls to support them
				case 77: {_ctrl cbSetChecked _value};
			};
		};
	};
} forEach _controls;

if (_saving) then {
	missionNamespace setVariable [_dialogSettingsVarName, _newSettings];
};