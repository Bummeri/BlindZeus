if (!hasInterface) exitWith {};
private _zeusUnit = "";
private _sidesToHide = [];
// Argument 0 is module logic.
_logic = param [0,objNull,[objNull]];
// Argument 1 is list of affected units (affected by value selected in the 'class Units' argument))
_units = param [1,[],[[]]];
// True when the module was activated, false when it's deactivated (i.e., synced triggers are no longer active)
_activated = param [2,true,[true]];
// Module specific behavior. Function can extract arguments from logic and use them.
if (_activated) then {
	// Attribute values are saved in module's object space under their class names
	_zeusUnit = call compile (_logic getVariable ["zeusUnit",""]); //(as per the previous example, but you can define your own.)
    _sidesToHide = [];
    if (_logic getvariable ["blindWEST", false]) then {
         _sidesToHide pushBackUnique west;
     };
    if (_logic getvariable ["blindEAST", false]) then {
        _sidesToHide pushBackUnique east;
    };
    if (_logic getvariable ["blindINDEPENDENT", false]) then {
        _sidesToHide pushBackUnique independent;
    };
    if (_logic getvariable ["blindCIVILIAN", false]) then {
        _sidesToHide pushBackUnique civilian;
    };
};
[_sidesToHide, _zeusUnit] call Bum_fnc_blindzeus;