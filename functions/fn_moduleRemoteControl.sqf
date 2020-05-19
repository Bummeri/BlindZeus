_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated && local _logic && !isnull curatorcamera) then {
    if (_logic getVariable ["Bum_logicHandled", false]) exitWith {false};
    _logic setVariable ["Bum_logicHandled", true];

    private _fnc_transferGroupOwnershipToController = {
        private _fnc_returnGroupOwnership = {
            params ["_group"];
            private _owner = 2;
            if (!isnil "Bum_Blindzeus_AiOwner") then {
                _owner = Bum_Blindzeus_AiOwner;
            };
            if (local _group) then {
                [_group, _owner] remoteExecCall ["setGroupOwner", 2];
            };
        };
        private _controlledUnit = missionnamespace getvariable "bis_fnc_moduleRemoteControl_unit";
        private _group = group _controlledUnit;
        private _doTransfer = true;
        {
            if (!isNull(_x getvariable ["bis_fnc_moduleRemoteControl_owner", objnull]) || _x in allPlayers) exitWith {
                _doTransfer = false;
            };
        } forEach (units _group - [_controlledUnit]);

        if (_doTransfer) then {
            [_group, clientOwner] remoteExecCall ["setGroupOwner", 2];
            [{isnull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])}, _fnc_returnGroupOwnership, [_group]] call CBA_fnc_waitUntilAndExecute;
        };
    };

    //--- Terminate when remote control is already in progress
    if !(isnull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])) exitwith {};

    //--- Get unit under cursor
    _unit = objnull;
    _mouseOver = missionnamespace getvariable ["bis_fnc_curatorObjectPlaced_mouseOver",[""]];
    if ((_mouseOver select 0) == typename objnull) then {_unit = _mouseOver select 1;};
    _unit = effectivecommander _unit;

    //--- Temp owner, We will change remotecontrol target to another crew memeber if the gunner is already remotecontrolled
    private _tempOwner = _unit getvariable ["bis_fnc_moduleRemoteControl_owner", objnull];
    if (!isnull _tempOwner && {_tempOwner in allPlayers}) then {
        if (vehicle _unit != _unit) then
        {
            {
                if ((!isNull _x) && {_x != _unit} && {isNull (_x getvariable ["bis_fnc_moduleRemoteControl_owner", objnull])}) exitWith {
                    missionnamespace setVariable ["bis_fnc_curatorObjectPlaced_mouseOver",["OBJECT", _x]];
                };
            } forEach [driver vehicle _unit, gunner vehicle _unit, commander vehicle _unit];
        };
    };

    //Locality change is disabled due to issues caused to AI by locality changes. The AI get completely stuck sometimes.
    //[{!isNull (missionnamespace getvariable ["bis_fnc_moduleRemoteControl_unit",objnull])}, _fnc_transferGroupOwnershipToController, [], 3] call CBA_fnc_waitUntilAndExecute;
    [_logic, _units, _activated] call Ace_zeus_fnc_bi_moduleRemoteControl;
    [{[["Bum_Blindzeus", "StackableRemoteControl"], nil, nil, 30, "", true, true, true, true] call BIS_fnc_advHint}, [], 2] call CBA_fnc_waitAndExecute;
};