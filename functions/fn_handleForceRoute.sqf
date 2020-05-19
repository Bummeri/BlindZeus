params ["_success", "_object", "_posASL", "_shiftPressed", "_ctrlPressed", "", ["_init", false, [false]], ["_vehicle", objNull, [objNull]], ["_logic", objNull, [objNull]]];

//Inline functions:

private _fnc_removeMarkerObjects = {
    private _oldLocationMarkers = missionNamespace getVariable ["bum_forceroute_oldLocationMarkers",[]];
    {
        deleteVehicle _x;
    } forEach _oldLocationMarkers;

    missionNamespace setVariable ["bum_forceroute_oldLocationMarkers",nil];
};

if (_init) then
{
    if (isNull _vehicle) exitWith {false};
    missionNamespace setVariable ["bum_forceroute_vehicle", _vehicle];
    missionNamespace setVariable ["bum_forceroute_positions", []];
    missionNamespace setVariable ["bum_forceroute_logic", _logic];

    [_vehicle, bum_fnc_handleForceRoute] call ace_zeus_fnc_getModuleDestination;
}
else
{
    _logic = missionNamespace getVariable "bum_forceroute_logic";
    _vehicle = missionNamespace getVariable "bum_forceroute_vehicle";
    if (_success) then
    {
        private _positionArray = missionNamespace getVariable "bum_forceroute_positions";
        _positionArray pushBack (ASLToAGL _posASL);
        if (_shiftPressed) then
        {
            //We are adding more waypoints
            missionNamespace setVariable ["bum_forceroute_positions", _positionArray];
            _posASL set [2, ((_posASL select 2)+1)];
            private _markerPosition =  _posASL;
            private _newLocationMarker = createSimpleObject ["a3\structures_f_bootcamp\vr\helpers\vr_3dselector_01_f.p3d", _markerPosition, true];
            private _oldLocationMarkers = missionNamespace getVariable ["bum_forceroute_oldLocationMarkers", []];
            _oldLocationMarkers pushBack _newLocationMarker;
            missionNamespace setVariable ["bum_forceroute_oldLocationMarkers", _oldLocationMarkers];

            [ace_zeus_fnc_getModuleDestination, [_newLocationMarker, bum_fnc_handleForceRoute]] call cba_fnc_execNextFrame;
        }
        else
        {
            //The last waypoint was added, move the vehicle
            [_vehicle, _positionArray] remoteExecCall ["Bum_fnc_executeForceRoute", _vehicle];
            [] call _fnc_removeMarkerObjects;

            private _fnc_removeModule = {
                //This function checks when the vehicle is "done" with the route and removes the force move module
                params ["_finalPos", ["_vehicle", objNull, [objNull]], ["_logic", objNull, [objNull]], "_thisFnc"];
                if (isNull _logic) exitWith {};
                if (count _finalPos > 3) then {
                    _finalPos resize 3;
                };
                if ((_vehicle distance2D _finalPos) < 7) then {
                    detach _logic;
                    deleteVehicle _logic;
                } else {
                    [_thisFnc, [_finalPos, _vehicle, _logic, _thisFnc], 0.5] call cba_fnc_waitAndExecute;
                };
            };
            private _finalPos = _positionArray select ((count _positionArray) - 1);
            [_fnc_removeModule, [_finalPos, _vehicle, _logic, _fnc_removeModule], 3] call cba_fnc_waitAndExecute;
        };
    } else {
        //Force move was aborted
        [] call _fnc_removeMarkerObjects;
        detach _logic;
        deleteVehicle _logic;
    };
};

