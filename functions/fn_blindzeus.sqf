if (!hasInterface) exitWith {};
Params ["_sidesToHide","_zeusUnit"];
if (isnull player) exitWith {
    [{!isNull player}, Bum_fnc_blindzeus, [_sidesToHide,_zeusUnit]] call CBA_fnc_waitUntilAndExecute;  
};
if !(player isEqualTo _zeusUnit) exitWith {};

//Functions
Bum_fnc_ShowObjects = {
    private _allUnits = allUnits;
    _allUnits append alldeadmen; //dead are not shown otherwise.
    _allUnits append vehicles; //Make sure all vehicles are also shown.
    _allunits = _allUnits - Bum_Blindzeus_DontTouchTheseObjects;
    {
        _x hideobject false; //Shows every hidden unit/body/vehicle from all sides.
    } forEach _allUnits;
};

Bum_fnc_vehicleHideCheck = {
    params ["_vehicle"];
    private _vehicleSide = side group _vehicle;
    if (_vehicleSide == sideUnknown) then {
        _vehicleSide = (configFile >> "CfgVehicles" >> typeOf _vehicle >> "side") call BIS_fnc_getCfgData;
        switch (_vehicleSide) do
        {
            case 0: {_vehicleSide = east};
            case 1: {_vehicleSide = west};
            case 2: {_vehicleSide = independent};
            case 3: {_vehicleSide = civilian};
        };
    };
    if ((_vehicle getVariable ["Bum_Blindzeus_forcedVehicleSide",""]) in Bum_Blindzeus_vehicleSidesToHide) exitWith {true};
    if (_vehicleSide in Bum_Blindzeus_vehicleSidesToHide) exitWith {true};
    false
};

Bum_fnc_hideCheck = {
    private _return = false;
    if (_this iskindOf "Man") then {
        if (side group _this in Bum_Blindzeus_sidesToHide) then {_return = true};
    } else {
        _return = [_this] call Bum_fnc_vehicleHideCheck;
    };
    if (_return && {((_this getVariable ["Bum_Blindzeus_lastSeen",0]) +30) < CBA_missiontime}) then {_return = true} else {_return = false};
    _return
};

Bum_fnc_startIntermittentHide = {
    if (!isnil "Bum_blindzeus_hideStateMachine") exitWith {false};
    
    private _fnc_updateUnitList = {
        private _returnArray = [];
        _returnArray append allUnits;
        _returnArray append vehicles;
        _returnArray = _returnArray - Bum_Blindzeus_DontTouchTheseObjects;
        _returnArray
    };

    _hideStateMachine = [_fnc_updateUnitList,true] call CBA_statemachine_fnc_create;
    _name = [_hideStateMachine, {}, {}, {}, "Initial"] call CBA_statemachine_fnc_addState;
    _name = [_hideStateMachine, {hideObject _this}, {}, {}, "Hidden"] call CBA_statemachine_fnc_addState;
    _name = [_hideStateMachine, {_this hideObject false}, {}, {}, "Shown"] call CBA_statemachine_fnc_addState;

    [_hideStateMachine, "Initial", "Hidden", Bum_fnc_hideCheck, {}] call CBA_statemachine_fnc_addTransition;
    [_hideStateMachine, "Initial", "Shown", {!(_this call Bum_fnc_hideCheck)}, {}] call CBA_statemachine_fnc_addTransition;
    [_hideStateMachine, "Shown", "Hidden", Bum_fnc_hideCheck, {}] call CBA_statemachine_fnc_addTransition;
    [_hideStateMachine, "Hidden", "Shown", {!(_this call Bum_fnc_hideCheck)}, {}] call CBA_statemachine_fnc_addTransition;

    Bum_blindzeus_hideStateMachine = _hideStateMachine;
    true
};

Bum_fnc_endIntermittentHide = {
    if (!isnil "Bum_blindzeus_hideStateMachine") then {
        [Bum_blindzeus_hideStateMachine] call CBA_statemachine_fnc_delete;
        Bum_blindzeus_hideStateMachine = nil;
    };
};

Bum_fnc_HideObjects = {
    private _allUnits = allUnits - Bum_Blindzeus_DontTouchTheseObjects;
    private _allVehicles = vehicles - Bum_Blindzeus_DontTouchTheseObjects;

    {
        if (side group _x in Bum_Blindzeus_sidesToHide) then //If unit is on the side that needs to be hidden, hide it.
        {
            hideobject _x;
        };
    } forEach _allUnits;

    {
        if ([_x] call Bum_fnc_vehicleHideCheck) then {
            hideObject _x;
        };
    } forEach _allVehicles;
};

private _bum_fnc_curatorModuleActions = {
    //This is a local inline function that needs to be run when zeusmodule is assigned. This sets the restrictions on the blindzeus and assigns the CuratorView Statemachine.
    //
    params ["_sidesToHide", "_zeusUnit"];
    if !(player isEqualTo _zeusUnit) exitWith {false};
    if !(isNil "Bum_blindzeus_initialized") exitWith {false};
    Bum_blindzeus_initialized = true;
    private _zeusCuratorModule = getAssignedCuratorLogic player; //Wont work at time 0, not defined.

    //Define Variables
    //
    if (isnil "Bum_Blindzeus_sidesToHide") then {Bum_Blindzeus_sidesToHide = _sidesToHide};
    if (isnil "Bum_Blindzeus_vehicleSidesToHide") then {Bum_Blindzeus_vehicleSidesToHide = +Bum_Blindzeus_sidesToHide};
    if (isnil "Bum_Blindzeus_DontTouchTheseObjects") then {Bum_Blindzeus_DontTouchTheseObjects = []};
    Bum_Blindzeus_sidesToHide append [sideEnemy ,sideUnknown];

    _zeusCuratorModule setVariable ["Bum_blindzeus_isBlind", true, true];

     if (Bum_Blindzeus_hideSetting isEqualTo 0) then {
        Bum_Blindzeus_vehicleSidesToHide = [];
        Bum_Blindzeus_sidesToHide = [];
    };

    //Restrict modules Curator can use
    //
    [_zeusCuratorModule, [
    "Bum_ModuleForceRoute",0,
    "Bum_ModuleRemoteControl",0,
    "Bum_ModuleUnFuck",0,
    "Bum_ModuleSetAISettings",0,
    "Bum_ModuleShareClaimUnits",0,
    "ace_zeus_moduleSuppressiveFire",0,
    "ace_zeus_moduleDefendArea",0,
    "ace_zeus_modulePatrolArea",0,
    "ace_zeus_moduleSearchArea",0,
    "ace_zeus_moduleSearchNearby",0,
    "ace_zeus_moduleToggleFlashlight",0]] call BIS_fnc_curatorObjectRegisteredTable;

    [_zeusCuratorModule, ["Edit", -1e10]] remoteExec ["setCuratorCoef",2]; //prevent zeus from moving units around. Executed on the server.
    [_zeusCuratorModule, ["Delete", -1e10]] remoteExec ["setCuratorCoef",2]; //gives error when zeus tries to remove stuff. Does not prevent it due to a bug.
    [_zeusCuratorModule, ["ace_interaction", "ace_rearm"]] remoteExec ["removeCuratorAddons",2];
    [_zeusCuratorModule] call BIS_fnc_drawCuratorLocations; //Draw location names on map.

    if ((count (curatorEditingArea _zeusCuratorModule)) == 0) then {
        [_zeusCuratorModule, [10,[0,0,0],1]] remoteExec ["addCuratorEditingArea",2];
        [_zeusCuratorModule, true] remoteExec ["setCuratorEditingAreaType",2];
        [_zeusCuratorModule, true] remoteExec ["allowCuratorLogicIgnoreAreas",2];
    };

    _zeusCuratorModule addEventHandler ["CuratorGroupSelectionChanged", {
        params ["", "_group"];
        if (isMultiplayer) then {
            if (local _group && !(player in (units _group))) then {
                private _owner = 2;
                if (!isnil "Bum_Blindzeus_AiOwner") then {
                    _owner = Bum_Blindzeus_AiOwner;
                };
                [_group, _owner] remoteExec ["setGroupOwner",2];
                systemChat format ["Group: %1 ownership transferred to server or defined AiOwner. Units cannot be local to blindzeus!",_group];
            };
        };
    }];
    
    private _fnc_handleCuratorDialogs = {
        private _dialogClass = findDisplay -1 getVariable "BIS_fnc_initDisplay_configClass";
        if ("achilles_ui_f" in activatedAddons) then //we need to hide stuff from achilles if its on.
        {
            _classesToHandle = ["RscDisplayAttributesGroup", "RscDisplayAttributesVehicle", "RscDisplayAttributesMan"];
            if (_dialogClass in _classesToHandle) then {
                private _allCtrls = allControls findDisplay -1;
                private _ControlClassesToHide = ["ButtonBehaviour","ButtonSide","ButtonCargo","ButtonAmmo","ButtonDamage","ButtonSensors","ButtonFlag"];
                {
                    if (ctrlClassName _x in _ControlClassesToHide) then
                    {
                        _x ctrlShow false;
                    };
                } forEach _allCtrls;
            };
        };
    };

    private _fnc_addCuratorMapEH = {
        //Prevent changing mouse icon in map when over objects that arent editable
        ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["Draw",{
            if (curatorMouseOver select 0 == "OBJECT") then {
                if !((curatormouseOver select 1) in curatorEditableObjects (getAssignedCuratorLogic player)) then {
                    if (count (curatorSelected select 0) > 0 || {count (curatorSelected select 1) > 0 || {count (curatorSelected select 2) > 0}}) then {
                        (_this select 0) ctrlMapCursor ["","CuratorPlaceWaypoint"];    
                    } else {
                        (_this select 0) ctrlMapCursor ["","Curator"];
                    };
                };
            };
        }];

        //Prevent editing objects that arent editable, in map
        ((findDisplay 312) displayCtrl 50) ctrlAddEventHandler ["MouseButtonDblClick",{
            if (curatorMouseOver select 0 in "OBJECT") then {
                if !((curatormouseOver select 1) in curatorEditableObjects (getAssignedCuratorLogic player)) then {
                    [{findDisplay -1 closeDisplay 2}] call CBA_fnc_execNextFrame;
                };
            };
        }];
    };
    
    //ADD Curator View Statemachine
    //
    Bum_blindzeus_curatorViewStateMachine = [[missionNamespace]] call CBA_statemachine_fnc_create;
    [Bum_blindzeus_curatorViewStateMachine, {}, {[] call Bum_fnc_ShowObjects;}, {}, "NormalView"] call CBA_statemachine_fnc_addState;
    [Bum_blindzeus_curatorViewStateMachine, {}, {[] call Bum_fnc_HideObjects; [] call Bum_fnc_startIntermittentHide; [] call Bum_fnc_startTargetStateMachine;}, {[] call Bum_fnc_endIntermittentHide;}, "CuratorView"] call CBA_statemachine_fnc_addState;
    [Bum_blindzeus_curatorViewStateMachine, {}, {[] call Bum_fnc_ShowObjects;}, {}, "NumEnterView"] call CBA_statemachine_fnc_addState;
    [Bum_blindzeus_curatorViewStateMachine, {}, {[] call Bum_fnc_ShowObjects;}, {}, "CuratorMapView"] call CBA_statemachine_fnc_addState;
    [Bum_blindzeus_curatorViewStateMachine, _fnc_handleCuratorDialogs, {}, {}, "CuratorDialogView"] call CBA_statemachine_fnc_addState;

    [Bum_blindzeus_curatorViewStateMachine, "NormalView", "CuratorView", {!isNull findDisplay 312}, _fnc_addCuratorMapEH] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorView", "NormalView", {isNull findDisplay 312}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorView", "NumEnterView", {cameraOn != vehicle player}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorView", "CuratorMapView", {visibleMap}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorView", "CuratorDialogView", {!isNull findDisplay -1}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "NumEnterView", "NormalView", {isNull findDisplay 312}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "NumEnterView", "CuratorView", {cameraOn == vehicle player && {!isNull findDisplay 312}}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "NumEnterView", "CuratorMapView", {visibleMap}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "NumEnterView", "CuratorDialogView", {!isNull findDisplay 312 && {!isnull findDisplay -1}}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorMapView", "CuratorView", {!visibleMap}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorMapView", "CuratorDialogView", {!isNull findDisplay -1}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorDialogView", "CuratorMapView", {isNull findDisplay -1 && {visibleMap}}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorDialogView", "CuratorView", {isnull findDisplay -1 && {cameraOn == vehicle player}}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "CuratorDialogView", "NumEnterView", {isnull findDisplay -1 && {cameraOn != vehicle player}}, {}] call CBA_statemachine_fnc_addTransition;

    [Bum_blindzeus_curatorViewStateMachine, {}, {}, {}, "NonBlindCurator"] call CBA_statemachine_fnc_addState;
    [Bum_blindzeus_curatorViewStateMachine, "NormalView", "NonBlindCurator", {!((getAssignedCuratorLogic player) getVariable ["Bum_blindzeus_isBlind", false])}, {}] call CBA_statemachine_fnc_addTransition;
    [Bum_blindzeus_curatorViewStateMachine, "NonBlindCurator", "NormalView", {(getAssignedCuratorLogic player) getVariable ["Bum_blindzeus_isBlind", false]}, {}] call CBA_statemachine_fnc_addTransition;


    private _fnc_enableStateDebug = {
        if (missionNamespace getVariable ["Bum_Blindzeus_enableDebug", false]) then {
            private _fnc_stateCheck = {
                params ["", "_handle"];
                if (!Bum_Blindzeus_enableDebug) exitWith {
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };
                private _prevState = missionNamespace getVariable ["Bum_Blindzeus_debugPrevViewState", ""];
                private _currentState = [missionNamespace, Bum_blindzeus_curatorViewStateMachine] call CBA_statemachine_fnc_getCurrentState;
                if !(_prevState isEqualTo _currentState) then {
                    missionNamespace setVariable ["Bum_Blindzeus_debugPrevViewState", _currentState];
                    systemChat format ["BZ viewStateChanged: %1", _currentState];
                };
            };
            [_fnc_stateCheck] call CBA_fnc_addPerFrameHandler;
        };
    };
    [{!isNil "Bum_Blindzeus_enableDebug"}, _fnc_enableStateDebug] call CBA_fnc_waitUntilAndExecute;

    if ("achilles_ui_f" in activatedAddons) then //we need to hide stuff from achilles if its on.
    {
        Achilles_var_availableModuleClasses = ["Achilles_Create_Universal_Target_Module",
        "Ares_Module_Behaviour_Search_Nearby_And_Garrison",
        "Ares_Module_Behaviour_Search_Nearby_Building",
        "Achilles_Suppressive_Fire_Module",
        "Ares_Module_Bahaviour_SurrenderUnit",
        "Ares_Module_Bahaviour_UnGarrison"];

        private _bum_fnc_achillesActionsAfterInit = {
            params ["_zeusCuratorModule"];
            [_zeusCuratorModule, "group",["GroupID2","Formation2","Behaviour2","CombatMode2","SpeedMode2","UnitPos2"]] call BIS_fnc_setCuratorAttributes;
            [_zeusCuratorModule, "object",["Engine","Headlight","UnitPos2","ace_cargo"]] call BIS_fnc_setCuratorAttributes;

            //We overwrite the deep paste storage so it cant circumvent editing areas
            [{Achilles_var_ObjectClipboard = []}, 0] call CBA_fnc_addPerFrameHandler;
        };
        [{!isNil "ares_category_list"}, _bum_fnc_achillesActionsAfterInit, [_zeusCuratorModule]] call CBA_fnc_waitUntilAndExecute;
    }
    else
    {
        [_zeusCuratorModule, "object",["unitPos"]] call BIS_fnc_setCuratorAttributes; //defines what interactions zeus can have with objects.
        [_zeusCuratorModule, "group",["Formation","Behaviour","GroupID","unitPos"]] call BIS_fnc_setCuratorAttributes; //With groups
    };
};

private _fnc_fixJipIssues = {
    Params ["_sidesToHide","_zeusUnit"];
    private _text = "Trying To solve Curaror Jip-issue, try opening curator UI again!";
    systemChat _text;
    hint _text;
    {
        if (getAssignedCuratorUnit _x isEqualTo player) exitWith {
            _x remoteExecCall ["unassignCurator", 2];
            [{_this remoteExecCall ["assignCurator", 2]}, [player, _x], 0.5] call CBA_fnc_waitAndExecute;
            [Bum_fnc_blindzeus, [_sidesToHide,_zeusUnit], 1] call CBA_fnc_waitAndExecute;
            //TODO Tarkasta tuleeko addonit takas tällöin vai pitääkö ne lisätä addCuratorAddons activatedAddons?
        };
    } forEach allCurators;
};

//SCRIPT STARTS here
//
[{!isNull (getAssignedCuratorLogic player)}, _bum_fnc_curatorModuleActions, [_sidesToHide,_zeusUnit], 30, _fnc_fixJipIssues] call CBA_fnc_waitUntilAndExecute;