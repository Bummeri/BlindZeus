params ["_dialog"];
if (!isnull curatorcamera) then {

	//////////////////
	//Inline Functions
	//////////////////

	private _fnc_dialogIsClosing = {
			params ["_dialog", "_exitCode"];

			if (_exitcode == 1) then {
				private _ctrl = _dialog getVariable "blindZeus_c_GroupsAndVehicles";
				private _lbData = _ctrl getVariable "blindzeus_c_lbData";
				private _unitsToHandle = [];
				
				{
					private _lbText = _ctrl lbText _x;
					private _groupOrVehicle = (_lbData select 1) select ((_lbData select 0) find _lbText); //We find the group or vehicle that matches the text from lb.

					if (typename _groupOrVehicle == "GROUP") then {
						{
							_unitsToHandle pushBack _x;
							if (vehicle _x != _x) then {
								if (effectiveCommander vehicle _x == _x) then {
									if ((vehicle _x) in (curatorEditableObjects (getAssignedCuratorLogic player))) then {
										_unitsToHandle pushBackUnique (vehicle _x);
									};
								};
							};
						} forEach units _groupOrVehicle;
					} else {
						_unitsToHandle pushBack _groupOrVehicle;
					}; 
				} forEach lbSelection _ctrl;

				private _curatorModulesToHandle = [];
				_ctrl = _dialog getVariable "blindZeus_c_Curators";
				_lbData = _ctrl getVariable "blindzeus_c_lbData";
				{
					private _lbText = _ctrl lbText _x;
					private _curator = (_lbData select 1) select ((_lbData select 0) find _lbText); //We find the curator that matches the text from lb.
					_curatorModulesToHandle pushBack (getAssignedCuratorLogic _curator);	
				} forEach lbSelection _ctrl;

				private _share = cbChecked (_dialog getVariable "blindZeus_c_Share");
				{
					if (_share) then {
						[_x,[_unitsToHandle,false]] remoteExec ["addCuratorEditableObjects",2];
					} else {
						[_x,[_unitsToHandle,false]] remoteExec ["removeCuratorEditableObjects",2];
					};
				} forEach _curatorModulesToHandle;
			};
		};



	private _fnc_shareOrClaim = {
		params ["_groupOrVehicle","_curatorLogic","_share"];

		private _units = [];
		if (typeName _groupOrVehicle == "GROUP") then {
			_units = units _groupOrVehicle;
			{

			} forEach units _groupOrVehicle;
		};
		if (typeName _groupOrVehicle == "OBJECT") then {
			_units = [_groupOrVehicle];
		};
		
		if (_share) then {
			[_curatorLogic, [_units]] remoteExec ["addCuratorEditableObjects", 2];
		} else {
			[_curatorLogic, [_units]] remoteExec ["removeCuratorEditableObjects", 2];
		};
	};

	private _fnc_listEditableGroupsAndVehicles = {
		private _editableObjects = curatorEditableObjects getAssignedCuratorLogic player;
		private _editableUnits = allUnits arrayIntersect _editableObjects;
		private _editableVehicles = vehicles arrayIntersect _editableObjects;

		private _editableGroups = [];
		{
			_editableGroups pushBackUnique group _x;
		} forEach _editableUnits;

		//These vehicles are under some of the groups that we are going to list. We will list them rigth after the group in the dialog.
		private _groupedVehicles = [];
		//These are not under the command of our groups, we will list them in the end separated.
		private _nonGroupedVehicles = [];
		{
			if ((effectiveCommander _x) in _editableUnits) then {
				_groupedVehicles pushBackUnique _x;
			} else {
				_nonGroupedVehicles pushBackUnique _x;
			};
		} forEach _editableVehicles;

		[_editableGroups,_groupedVehicles,_nonGroupedVehicles]
	};

	private _fnc_populateGroupAndVehicleLb = {
		params ["_ctrl", ["_groups", []], ["_vehicles",[]]];

		private _modulePos = missionNamespace getVariable "blindzeus_prevLogicPos";
		private _lbText = "";
		private _ctrlDataArray = [[],[]];//[[_lbtext], [_groupOrVehicle]];
		{
			private _distance = floor(_modulePos distance2D (getpos leader _x));
			private _side = "";
			switch (side _x) do {
				case blufor: {_side = "B"};
				case opfor: {_side = "O"};
				case independent: {_side = "I"};
				default {_side = "C"};
			};
			private _groupID = groupId _x;

			private _distanceText = str _distance;
			while {count _distanceText < 5} do {
				_distanceText = ["0", _distanceText] joinString "";
			};
			_lbText = format ["%1 - %2: %3",_distanceText, _side, _groupID];
			_ctrl lbAdd _lbText;
			(_ctrlDataArray select 0) pushBack _lbText;
			(_ctrlDataArray select 1) pushBack _x;
		} forEach _groups;

		{
			private _distance = floor(_modulePos distance2D (getpos _x));
			private _distanceText = str _distance;
			while {count _distanceText < 5} do {
				_distanceText = ["0", _distanceText] joinString "";
			};
			private _displayName = [configFile >> "CfgVehicles" >> typeOf _x] call BIS_fnc_displayName;

			_lbText = format ["%1 - %2",_distanceText, _displayName];
			_ctrl lbAdd _lbText;
			(_ctrlDataArray select 0) pushBack _lbText;
			(_ctrlDataArray select 1) pushBack _x;
		} forEach _vehicles;

		_ctrl setVariable ["blindzeus_c_lbData", _ctrlDataArray];
		lbSort _ctrl;
	};

	private _fnc_populateCuratorLb = {
		params ["_ctrl"];

		private _curatorLogics = allCurators;
		_curatorLogics = _curatorLogics - [getAssignedCuratorLogic player];
		private _curatorUnits = [];
		private _ctrlDataArray = [[],[]];
		{
			private _unit = getAssignedCuratorUnit _x;
			if (!isnull _unit) then {
				_curatorUnits pushBackUnique _unit;
			};
		} forEach _curatorLogics;

		{
			private _side = "";
			switch (side _x) do {
				case blufor: {_side = "B"};
				case opfor: {_side = "O"};
				case independent: {_side = "I"};
				case civilian: {_side = "C"};
				case default {_side = "L"};
			};
			private _roleDescription = roleDescription _x;
			private _name = name _x;
			private _lbText = format ["%1: %2 - %3",_side, _roleDescription, _name];
			_ctrl lbAdd _lbText;
			(_ctrlDataArray select 0) pushBack _lbText;
			(_ctrlDataArray select 1) pushBack _x;
		} forEach _curatorUnits;

		_ctrl setVariable ["blindzeus_c_lbData", _ctrlDataArray];
		lbSort _ctrl;
	};

	//Define dialog Ctrls from config to controls array and to _dialog namespace Variables so we can interact with them
	_controls = [_dialog] call Bum_fnc_createDialogVariables;

	//ADD Display Eventhandlers for closing the dialog, add actions to the ok and cancel buttons.
	_dialog displayAddEventHandler ["UnLoad", _fnc_dialogIsClosing];
	_dialog getVariable "blindZeus_c_OK" buttonSetAction "closeDialog 1";
	_dialog getVariable "blindZeus_c_Cancel" buttonSetAction "closeDialog 2";

	//Populate Listboxes
	private _groupsAndVehicles = [] call _fnc_listEditableGroupsAndVehicles;
	[_fnc_populateGroupAndVehicleLb, [_dialog getVariable "blindZeus_c_GroupsAndVehicles", _groupsAndVehicles select 0, _groupsAndVehicles select 2], 0.5] call CBA_fnc_waitAndExecute;
	[_dialog getVariable "blindZeus_c_Curators"] call _fnc_populateCuratorLb;

	//Post Hint
    [["Bum_Blindzeus", "ShareOrClaimUnits"], nil, nil, 30, "", true, true, true, true] call BIS_fnc_advHint;

	//EH that prevents both Share and Claim from being selected at the same time
	_dialog getVariable "blindZeus_c_Claim" ctrlAddEventHandler ["CheckedChanged", {if ((_this select 1) == 1) then {((ctrlParent (_this select 0)) getVariable "blindZeus_c_Share") cbSetChecked false;};}];
	_dialog getVariable "blindZeus_c_Share" ctrlAddEventHandler ["CheckedChanged", {if ((_this select 1) == 1) then {((ctrlParent (_this select 0)) getVariable "blindZeus_c_Claim") cbSetChecked false;};}];
};