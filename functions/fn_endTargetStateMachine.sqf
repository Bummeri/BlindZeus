if (!isnil "Bum_blindzeus_targetStateMachine") then {
	[Bum_blindzeus_targetStateMachine] call CBA_statemachine_fnc_delete;
	Bum_blindzeus_targetStateMachine = nil;
};