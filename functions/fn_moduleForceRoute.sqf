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

    //Determine if the vehicle is capable of moving
    if (!canMove _vehicle) then {_error = "Vehicle is damaged and cannot move!"};
    if (fuel _vehicle == 0) then {_error = "The vehicle is out of fuel!"};
    if (isnull driver _vehicle) then {
        _error = "No driver in vehicle!";
    } else {
        if (!alive driver _vehicle) then {_error = "The driver is dead!"};
        if (lifeState driver _vehicle == "INCAPACITATED") then {_error = "The driver is unconscious!"};
    };
    if (effectivecommander _vehicle != leader group effectivecommander _vehicle) then {_error = "UnFuck the vehicle first!"};
    if (_error != "") exitWith {[_error, _logic] call _fnc_handleError};

    //Determine if unit has previous similar modules and remove them
    {
        if (!isnull _x && {typeOf _x == "Bum_ModuleForceRoute"}) then
        {
            if (_x != _logic) then
            {
                detach _x;
                deleteVehicle _x;
            };
        };
    } forEach (attachedObjects _vehicle);

    //Make sure Module removal checking has started for this module type
    if !(missionnamespace getVariable ["Bum_forceRouteEHStarted", false]) then
    {
        //stops vehicles when you delete the module manually
        private _curatorModule = getAssignedCuratorLogic player;
        _curatorModule addEventHandler ["CuratorObjectDeleted", {
            params ["", "_entity"];

            if ("Bum_ModuleForceRoute" == (typeOf _entity)) then
            {
                Private _attachedTo = attachedTo _entity;
                _attachedTo remoteExecCall ["Bum_fnc_stopForceRoute", _attachedTo];
            };
        }];

        //Stops vehicle and prohibits waypoint weirdness when a waypoint is given to a unit with force move executing
        _curatorModule addEventHandler ["CuratorWaypointPlaced", {
            params ["", "_group", "_waypointID"];

            private _assignedVehicle = assignedVehicle leader _group;
            if (!isNull _assignedVehicle) then
            {
                if ((effectiveCommander _assignedVehicle) in units _group) then
                {
                    {
                        if ("Bum_ModuleForceRoute" == (typeOf _x)) exitWith
                        {
                            _assignedVehicle remoteExecCall ["Bum_fnc_stopForceRoute", _assignedVehicle];
                            detach _x;
                            deleteVehicle _x;
                            deleteWaypoint [_group, _waypointID];
                        };
                    } forEach attachedObjects _assignedVehicle;
                };
            };
        }];
        missionNamespace setVariable ["Bum_forceRouteEHStarted", true];
    };

    //Post advanced hint for user
    [["Bum_Blindzeus", "ForceRoute"], nil, nil, 30, "", true, true, true, true] call BIS_fnc_advHint;

    //Start handling the route gathering
    [nil,nil,nil,nil,nil,nil,true,_vehicle,_logic] call bum_fnc_handleForceRoute;
};
true