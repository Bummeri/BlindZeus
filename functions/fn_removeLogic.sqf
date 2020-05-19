if (isDedicated) exitWith {false};

params [["_logic", objNull, [objNull]]];
if (local _logic) then {
	private _pos = getPos _logic;
	missionNamespace setVariable ["blindzeus_prevLogicPos", _pos];
	if (!isnull attachedTo _logic) then {
		detach _logic;
	};
	deleteVehicle _logic;
};