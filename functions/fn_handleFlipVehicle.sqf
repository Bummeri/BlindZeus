params ["_success", "_object", "_posASL", "_shiftPressed", "_ctrlPressed", "", ["_init", false, [false]], ["_vehicle", objNull, [objNull]]];

private _text = "Flip/move to, ESC cancels";
if (_init) then
{
    if (isNull _vehicle) exitWith {false};
    missionNamespace setVariable ["bum_flipVehicle_vehicle", _vehicle];
    [_vehicle, bum_fnc_handleFlipVehicle, _text] call ace_zeus_fnc_getModuleDestination;
}
else
{
    _vehicle = missionNamespace getVariable "bum_flipVehicle_vehicle";
    if (_success) then {
        private _distance = (getpos _vehicle) distance2D _posASL;
        private _maxDistance = 20;
        if (_distance > _maxDistance) then {
            private _errorText = format ["That position is %1m too far, try closer", (ceil (_distance - _maxDistance))];
            [ace_zeus_fnc_getModuleDestination, [_vehicle, bum_fnc_handleFlipVehicle, _text]] call cba_fnc_execNextFrame;
            [objNull, _errorText] call BIS_fnc_showCuratorFeedbackMessage;
        } else {
            [_vehicle, _posASL] remoteExecCall ["Bum_fnc_executeFlipVehicle", _vehicle];
            missionNamespace setVariable ["bum_flipVehicle_vehicle", nil];
        };
    };
};