params ["_target", "_group"];

private _groupCurators = objectCurators leader _group;
private _units = units _group;
private _firstUnitKnowledge = (_units select 0) targetKnowledge _target;

if (_firstUnitKnowledge select 0) then {
	if ((_firstUnitKnowledge select 2)> (CBA_missiontime - 10)) then {
		[_target, ["Bum_Blindzeus_lastSeen", floor CBA_missiontime]] remoteExecCall ["setVariable", _groupCurators];
	} else {
		_units deleteAt 0;
		{
			if ((_x targetKnowledge _target select 2)> (CBA_missiontime - 10)) exitWith {
				[_target, ["Bum_Blindzeus_lastSeen", floor CBA_missiontime]] remoteExecCall ["setVariable", _groupCurators];
			};
		} forEach _units;
	};
};