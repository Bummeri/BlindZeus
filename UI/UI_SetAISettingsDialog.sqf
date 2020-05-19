params ["_dialog"];

if (!isnull curatorcamera) then {

	//////////////////
	//Inline Functions
	//////////////////
	
	private _fnc_dialogIsClosing = {
		params ["_dialog", "_exitCode"];

		if (_exitcode == 1) then {
			private _applyToEditable = cbChecked (_dialog getVariable "blindZeus_c_ApplyToEditable");
			private _applyToGroup = cbChecked (_dialog getVariable "blindZeus_c_ApplyToGroup");
			private _autocombat = cbChecked (_dialog getVariable "blindZeus_c_AutoCombat");
			private _allowFleeing = cbChecked (_dialog getVariable "blindZeus_c_AllowFleeing");
			private _enableAttack = cbChecked (_dialog getVariable "blindZeus_c_EnableAttack");
			private _unloadTurrets = cbChecked (_dialog getVariable "blindZeus_c_unloadTurrets");
			private _unloadCargo = cbChecked (_dialog getVariable "blindZeus_c_unloadCargo");
			private _unloadImmobilized = cbChecked (_dialog getVariable "blindZeus_c_unloadImmobilized");
			private _groups = [_dialog getVariable "blindzeus_group"];
			private _groupsVehicles = _dialog getVariable "blindzeus_groupsVehicles";

			if (_applyToEditable || _applyToGroup) then {
				if (_applyToEditable) then {
					private _allEditableObjects = curatorEditableObjects getassignedCuratorLogic player;
					{
						if (_x in vehicles) then {
							_groupsVehicles pushBackUnique _x;
						} else {
							if (_x in allunits) then {
								_groups pushBackUnique (group _x);
							};
						};
					} forEach _allEditableObjects;
				};

				if (_allowFleeing) then {
					_allowFleeing = 0.2;
				} else {
					_allowFleeing = 0;
				};

				{
					{
						if (_autocombat) then {
							_x enableAI "AUTOCOMBAT";
							[_x,"AUTOCOMBAT"] remoteExec ["enableAI", _x];
						} else {
							_x disableAI "AUTOCOMBAT";
							[_x,"AUTOCOMBAT"] remoteExec ["disableAI", _x];
						};
					} forEach units _x;

					[_x, _enableAttack] remoteExec ["enableAttack", groupOwner _x];
					[_x, _allowFleeing] remoteExec ["allowFleeing", groupOwner _x];
				} forEach _groups;

				{
					[_x,[_unloadCargo, _unloadTurrets]] remoteExec ["setUnloadInCombat", _x];
					[_x,(!_unloadImmobilized)] remoteExec ["allowCrewInImmobile", _x];
				} forEach _groupsVehicles;
			};

			[_dialog, allControls _dialog, true] call Bum_fnc_saveOrLoadPreviousDialogSettings;
		};
	};

	//Check if the module was placed on a group or its members.
	private _group = grpNull;
	private _groupsVehicles = [];
    private _mouseOver = missionnamespace getvariable ["bis_fnc_curatorObjectPlaced_mouseOver",[""]];

	if ((_mouseOver select 0) == typename grpNull) then {
		_group = (_mouseOver select 1);
	};

	if ((_mouseOver select 0) == typename objNull) then {
		private _object = (_mouseOver select 1);
		if ((_object isKindOf "Man") || (_object isKindOf "LandVehicle")) then {
			_group = group _object;
		};
	};

	if (!isnull _group) then {
		{
			private _vehicle = vehicle _x;
			if (_vehicle != _x) then {
				if (effectiveCommander _vehicle == _x) then {
					_groupsVehicles pushBackUnique _vehicle;
				};
			};
		} forEach units _group;
	};
	_dialog setVariable ["blindzeus_group", _group];
	_dialog setVariable ["blindzeus_groupsVehicles", _groupsVehicles];

	//Define dialog Ctrls from config to controls array and to _dialog namespace Variables so we can interact with them
	_controls = [_dialog] call Bum_fnc_createDialogVariables;

	//ADD Display Eventhandlers for closing the dialog, add actions to the ok and cancel buttons.
	_dialog displayAddEventHandler ["UnLoad", _fnc_dialogIsClosing];
	_dialog getVariable "blindZeus_c_OK" buttonSetAction "closeDialog 1";
	_dialog getVariable "blindZeus_c_Cancel" buttonSetAction "closeDialog 2";

	// Load previous settings
	[_dialog, _controls, false] call Bum_fnc_saveOrLoadPreviousDialogSettings;

	//Lock group settings if no group under module
	if (isNull _group) then {
		_dialog getVariable "blindZeus_c_ApplyToGroup" cbSetChecked false;
		_dialog getVariable "blindZeus_c_ApplyToGroup" ctrlEnable false;
	};

	

	/* DISABLED ATM----If Waypoint behavior is enabled, Change infoText and color! Also change the checkbox nnbbv
	if (missionNamespace getVariable ["Blindzeus_ApplyOnWaypointEnabled", false]) then {
		_dialog getVariable "blindZeus_c_ApplyOnWaypointInfo" ctrlSetText "Enabled";
		_dialog getVariable "blindZeus_c_ApplyOnWaypointInfo" ctrlSetTextColor [0, 1, 0, 1];
		_dialog getVariable "blindZeus_c_ApplyOnWaypoint" cbSetChecked true;
		_dialog getVariable "blindZeus_c_ApplyToGroup" cbSetChecked false;
		_dialog getVariable "blindZeus_c_ApplyToGroup" ctrlEnable false;
		_dialog getVariable "blindZeus_c_ApplyToEditable" cbSetChecked false;
		_dialog getVariable "blindZeus_c_ApplyToEditable" ctrlEnable false;
	} else {
		_dialog getVariable "blindZeus_c_ApplyOnWaypoint" cbSetChecked false;
	}; */
} else {
	closeDialog 2;
};

