params ["_dialog"];

//Creates useful variables to dialog namespace for dialog control from bz dialog config. Also returns them in an array.
//Example uiNamespace Variable name for dialog "SetAISettingsDialog" - "OK" buttons ctrl would be: blindZeus_c_OK
//Get it using: _ctrl = _dialog getVariable "blindZeus_c_OK";
private _return = [];
{
	if (CtrlIdc _x != -1) then {
		[_x,_dialog] call compile format ["(_this select 1) setVariable [""blindZeus_c_%1"", _this select 0];",ctrlClassName _x];
		_return pushBack _x;
	};
} forEach allControls _dialog;
_return