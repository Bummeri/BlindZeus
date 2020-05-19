params [["_logic",objNull,[objNull]], "", ["_activated",true,[true]]];

if (_activated && local _logic && !isnull curatorcamera) then {
	if (_logic getVariable ["Bum_logicHandled", false]) exitWith {false};
    _logic setVariable ["Bum_logicHandled", true];

    private _error= "";
    private _fnc_handleError = {
        params ["_error", "_logic"];
        [objNull, _error] call BIS_fnc_showCuratorFeedbackMessage;
        deleteVehicle _logic;
        false
    };

	private _fnc_checkNearRefitCapabilities = {
		params ["_vehicle", "_distance"];

		private _return = [];
		private _nearVehicles = getPos _vehicle nearEntities ["LandVehicle", _distance];
		_nearVehicles pushBackUnique _vehicle;
		{
			private _capabilities = [];
			if ((_x getvariable ["ACE_isRepairVehicle",false]) || (([configFile >> "CfgVehicles" >> typeof _x ,"ace_repair_canRepair", 0] call BIS_fnc_returnConfigEntry) == 1)) then {
				_capabilities pushBack "Repair";
			};
			if (([_x] call ace_refuel_fnc_getFuel > 0) || (([configFile >> "CfgVehicles" >> typeof _x ,"ace_refuel_fuelCargo", 0] call BIS_fnc_returnConfigEntry)> 0)) then {
				_capabilities pushBack "Refuel";
			};
			if (([_x] call ace_rearm_fnc_getSupplyCount > 0) || (([configFile >> "CfgVehicles" >> typeof _x ,"ace_rearm_defaultSupply", 0] call BIS_fnc_returnConfigEntry)> 0)) then {
				_capabilities pushBack "Rearm";
			};
			{
				_return pushBackUnique _x;
			} forEach _capabilities;
		} forEach _nearVehicles;
		_return
	};

	//Determine if a tank or car is under the placed module
    private _vehicle = objnull;
    private _mouseOver = missionnamespace getvariable ["bis_fnc_curatorObjectPlaced_mouseOver",[""]];
    if ((_mouseOver select 0) == typename objnull) then {
    	_mouseOverObject = _mouseOver select 1;
    	if (_mouseOverObject isKindOf "Tank" || _mouseOverObject isKindOf "Car") then
		{
			_vehicle = _mouseOverObject;
		} else {
			_error = "Place module on a tracked or wheeled vehicle!";
		};
	} else {
		_error = "Place module on a tracked or wheeled vehicle!";
	};
	if (_error != "") exitWith {[_error, _logic] call _fnc_handleError};

	//Determine if vehicle is being remotecontrolled by someone or is driven by a player
    if (!isnull (effectiveCommander _vehicle getvariable ["bis_fnc_logicRemoteControl_owner", objnull])) then {_error = "Vehicle is being remote controlled by someone!"};
    if (isPlayer driver _vehicle) then {_error = "Vehicle is being driven by a player!"};
    if (_error != "") exitWith {[_error, _logic] call _fnc_handleError};

	//We make the commander of the vehicle the group leader also
	if (effectiveCommander _vehicle != leader group effectiveCommander _vehicle) then {
		[group effectiveCommander _vehicle, effectiveCommander _vehicle] remoteExec ["selectLeader", effectiveCommander _vehicle];
	};

    if (isnull driver _vehicle) then {
        _error = "No driver in vehicle!";
    } else {
        if (!alive driver _vehicle) then {_error = "The driver is dead!"};
        if (lifeState driver _vehicle == "INCAPACITATED") then {_error = "The driver is unconscious!"};
    };
	if (_error != "") then {
		[objNull, _error] call BIS_fnc_showCuratorFeedbackMessage;
	};

	//We make crew to be members of the effectiveCommanders group
	{
		if !(_x in (units effectiveCommander _vehicle)) then {
			[_x] joinSilent (group effectiveCommander _vehicle);
		};
	} forEach [gunner _vehicle, driver _vehicle, commander _vehicle ];

	

	private _nearRefitCapabilities = [_vehicle, 30] call _fnc_checkNearRefitCapabilities;
	//Handle vehicle flipping and moving
	private _allowFlip = false;
	switch (Bum_Blindzeus_unFuck_flipReq) do {
		case 1: {
			if (((acos((vectorUp _vehicle) vectorCos [0,0,1])) > 33) || ("Repair" in _nearRefitCapabilities)) then {
				_allowFlip = true;
			};
		};
		case 2: {
			if ("Repair" in _nearRefitCapabilities) then {
				_allowFlip = true;
			};
		};
		default {_allowFlip = true};
	};
	if (_allowFlip) then {
		[bum_fnc_handleFlipVehicle, [nil,nil,nil,nil,nil,nil,true,_vehicle]] call cba_fnc_execNextFrame;
	};

	//Handle Vehicle refit
	private _allowedRefitActions = [];
	switch (Bum_Blindzeus_unFuck_refitReq) do {
		case 1: {
			if ("Repair" in _nearRefitCapabilities) then {
				_allowedRefitActions = ["Repair","Refuel","Rearm"];
			} else {
				_allowedRefitActions = _nearRefitCapabilities;
			};
		};
		case 2: {
			_allowedRefitActions = _nearRefitCapabilities;
		};
		case 3: {
			_allowedRefitActions = [];
		};
		default {_allowedRefitActions = ["Repair","Refuel","Rearm"];};
	};

	if ("Repair" in _allowedRefitActions) then {
		_vehicle setDamage 0;
		private _vehicleHitpointsDamage = getAllHitPointsDamage _vehicle;
		{
			if (((_vehicleHitpointsDamage select 2) select _foreachindex) > 0) then {
				[_vehicle, [_x, 0, false]] remoteExecCall ["setHitPointDamage", _vehicle];
			};
		} forEach (_vehicleHitpointsDamage select 0);
	};

	if ("Refuel" in _allowedRefitActions) then {
		[_vehicle, 1] remoteExecCall ["setFuel", _vehicle];
	};

	if ("Rearm" in _allowedRefitActions) then {
		private _assignedGearScript = (_vehicle getVariable ["Bum_blindzeus_unFuck_assignedGearScript", ""]);
		if (_assignedGearScript != "") then {
			[_vehicle] remoteExecCall [_assignedGearScript, _vehicle];
		} else {
			[_vehicle, 1] remoteExecCall ["setVehicleAmmoDef", _vehicle];
		};
	};

	//Post advanced hint for user
    [["Bum_Blindzeus", "UnFuck"], nil, nil, 30, "", true, true, true, true] call BIS_fnc_advHint;

	detach _logic;
    deleteVehicle _logic;
};
true