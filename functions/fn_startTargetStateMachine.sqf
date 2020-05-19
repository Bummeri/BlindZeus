if (!isnil "Bum_blindzeus_targetStateMachine") exitWith {false};
if (Bum_Blindzeus_hideSetting isEqualTo 1) exitWith {false};

private _fnc_updateGroupList = {
	private _returnArray = [];
	{
		if !(player in units group _x) then {
			_returnArray pushBackUnique group _x;
		};
	} forEach curatorEditableObjects getAssignedCuratorLogic player;
	_returnArray
};

private _fnc_gatherManTargets = {
	private _targetsArray = [];
	{
		if ((_x getvariable ["Bum_Blindzeus_lastSeen", 0])< (CBA_missiontime - 15)) then { //We dont add units that have just been marked as seen.
			if (side group _x in Bum_Blindzeus_sidesToHide) then {
				_targetsArray pushBack _x;
			};
		};
	} forEach (leader _this nearentities ["CAManBase", 1000]);
	_this setVariable ["Bum_Blindzeus_groupsTargets", _targetsArray];
};

private _fnc_gatherVehicleTargets = {
	private _targetsArray = [];
	{
		if ((_x getvariable ["Bum_Blindzeus_lastSeen", 0])< (CBA_missiontime - 15)) then {
			if ([_x] call Bum_fnc_vehicleHideCheck) then {
				_targetsArray pushBack _x;
			};
		};
	} forEach (leader _this nearentities [["LandVehicle", "Air", "Ship"], 2000]);
	_this setVariable ["Bum_Blindzeus_groupsTargets", _targetsArray];
};

private _fnc_checkTarget = {
	private _targets = _this getVariable ["Bum_Blindzeus_groupsTargets",[]];
	if (count _targets == 0) exitWith {};
	private _leader = leader _this;
	private _target = _targets select 0;

	if ((_target getvariable ["Bum_Blindzeus_lastSeen", 0])< (CBA_missiontime - 15)) then {
		if ([missionNamespace, Bum_blindzeus_curatorViewStateMachine] call CBA_statemachine_fnc_getCurrentState in ["CuratorView","CuratorDialogView"]) then {
			if !(terrainIntersectASL [eyepos _leader, eyePos _target]) then {
				[_target,_this] remoteExecCall ["Bum_fnc_targetCheck", _leader];
			};
		} else {
			[_target, _this] call Bum_fnc_targetCheck;
		};
	};
	_targets deleteAt 0;
};

_targetStateMachine = [_fnc_updateGroupList,true] call CBA_statemachine_fnc_create;
_name = [_targetStateMachine, _fnc_gatherVehicleTargets, {}, {}, "AcquireVehicleTargets"] call CBA_statemachine_fnc_addState;
_name = [_targetStateMachine, _fnc_gatherManTargets, {}, {}, "AcquireManTargets"] call CBA_statemachine_fnc_addState;
_name = [_targetStateMachine, _fnc_checkTarget, {}, {}, "CheckManTargets"] call CBA_statemachine_fnc_addState;
_name = [_targetStateMachine, _fnc_checkTarget, {}, {}, "CheckVehicleTargets"] call CBA_statemachine_fnc_addState;

[_targetStateMachine, "AcquireVehicleTargets", "CheckVehicleTargets", {true}, {}] call CBA_statemachine_fnc_addTransition;
[_targetStateMachine, "CheckVehicleTargets", "AcquireManTargets", {count(_this getvariable "Bum_Blindzeus_groupsTargets")==0}, {}] call CBA_statemachine_fnc_addTransition;
[_targetStateMachine, "AcquireManTargets", "CheckManTargets", {true}, {}] call CBA_statemachine_fnc_addTransition;
[_targetStateMachine, "CheckManTargets", "AcquireVehicleTargets", {count(_this getvariable "Bum_Blindzeus_groupsTargets")==0}, {}] call CBA_statemachine_fnc_addTransition;

Bum_blindzeus_targetStateMachine = _targetStateMachine;
true