private _fnc_dialogIsClosing = {
	params ["_dialog", "_exitCode"];
	if (_exitcode == 1) then {

		private _fnc_setGroupWaypointStance = {
			//Data is stored on the group in form: [[waypoint1],[stance1],[waypoint2],[stance2],...];
			params ["_stance", "_group", "_waypoint"];

			private _fnc_handleGroupWaypointStance = {
				Params ["_args","_handle"];
				_args params ["_group","_waypoint"];

				private _fnc_removeWaypointStanceData = {
					params ["_waypoint", "_group", "_unitPosArray"];
					private _removalIndex = _unitPosArray find _waypoint;
					_unitPosArray deleteAt _removalIndex; // Remove Waypoint data
					_unitPosArray deleteAt _removalIndex; // And Stance data
					private _groupCurators = objectCurators leader _group;
					[_group, ["Bum_Blindzeus_GroupStanceArray", _unitPosArray]] remoteExecCall ["setVariable", _groupCurators];
				};

				private _unitPosArray = _group getVariable ["Bum_Blindzeus_GroupStanceArray", []];
				if (_waypoint in (waypoints _group)) then {
					if (((waypoints _group) select (currentWaypoint _group)) isEqualTo _waypoint) then {
						_unitPos = _unitPosArray select ((_unitPosArray find _waypoint) + 1);
						{
							[_x,_unitPos] remoteExecCall ["setUnitPos", _x];
							_x setUnitPos _unitPos; //We are setting this also locally so the "unitpos" command returns it correctly riight away.
						} forEach  units _group;
						[_handle] call CBA_fnc_removePerFrameHandler;
						[_waypoint, _group, _unitPosArray] call _fnc_removeWaypointStanceData;
					};
				} else {
					[_handle] call CBA_fnc_removePerFrameHandler;
					[_waypoint, _group, _unitPosArray] call _fnc_removeWaypointStanceData;
				};
			};

			private _unitPosArray = _group getVariable ["Bum_Blindzeus_GroupStanceArray", []];
			private _oldDataPos = _unitPosArray find _waypoint;
			if (_oldDataPos == -1) then {
				_unitPosArray pushBack _waypoint;
				_unitPosArray pushBack _stance;
			} else {
				_unitPosArray set [_oldDataPos + 1, _stance];
			};
			private _groupCurators = objectCurators leader _group;
			[_group, ["Bum_Blindzeus_GroupStanceArray", _unitPosArray]] remoteExecCall ["setVariable", _groupCurators];
			[_fnc_handleGroupWaypointStance, 1, [_group, _waypoint]] call CBA_fnc_addPerFrameHandler;
		};

		private _waypoint = _dialog getVariable "Bum_Blindzeus_Waypoint";
		private _forcedBehavior = _dialog getVariable "Bum_Blindzeus_ForceBehavior";
		if (_forcedBehavior == 1) then {
			_forcedBehavior = true;
		} else {
			_forcedBehavior = false;
		};
		private _group = _waypoint select 0;
		private _stance = _dialog getVariable "Bum_Blindzeus_Stance";
		_waypoint setWaypointForceBehaviour _forcedBehavior;
		if (_stance != "UNCHANGED") then {
			[_stance, _group, _waypoint] call _fnc_setGroupWaypointStance;
		};
	};
};

params ["_ctrl"];
private _dialog = ctrlParent _ctrl;
private _waypoint = [curatorMouseOver select 1,curatorMouseOver select 2];
private _group = curatorMouseOver select 1;
private _forcedBehavior =  waypointForceBehaviour _waypoint;
private _unitPosArray = (curatorMouseOver select 1) getVariable ["Bum_Blindzeus_GroupStanceArray", []];
private _stance = "UNCHANGED";
if (_waypoint in _unitPosArray) then {
	_stance = _unitPosArray select ((_unitPosArray find _waypoint) + 1);
};
if (currentWaypoint _group == (_waypoint select 1)) then {
	_stance = unitpos (leader _group);
};

_dialog setVariable ["Bum_Blindzeus_Waypoint",_waypoint];
_dialog displayAddEventHandler ["UnLoad", _fnc_dialogIsClosing];

//Luodaan nappulat
private _okCtrl = controlNull;
{
	if (ctrlClassName _x == "ButtonOK") exitWith {
		_okCtrl = _x;
	};
} forEach allControls _dialog;

//We use the ok button as reference
private _okCtrlPos = ctrlPosition _okCtrl;
private _okCtrlHeight = _okCtrlPos select 3;
private _okCtrlWidth = _okCtrlPos select 2;
private _okCtrlPosX = _okCtrlPos select 0;
private _okCtrlPosY = _okCtrlPos select 1;

private _ctrlStance = _dialog ctrlCreate ["RscListBox", 141141];
Private _index = _ctrlStance lbAdd "UNCHANGED";
_ctrlStance lbSetPicture [_index, "\a3\ui_f_curator\Data\default_ca.paa"];
_index = _ctrlStance lbAdd "AUTO";
_ctrlStance lbSetPicture [_index, "\a3\Ui_f\data\IGUI\cfg\simpleTasks\types\use_ca.paa"];        
_index = _ctrlStance lbAdd "UP";
_ctrlStance lbSetPicture [_index, "\a3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_stand_ca.paa"];
_index = _ctrlStance lbAdd "MIDDLE";
_ctrlStance lbSetPicture [_index, "\a3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_crouch_ca.paa"];
_index = _ctrlStance lbAdd "DOWN";
_ctrlStance lbSetPicture [_index, "\a3\Ui_f\data\IGUI\RscIngameUI\RscUnitInfo\SI_prone_ca.paa"];

_ctrlStance ctrlAddEventHandler ["LBSelChanged", {ctrlParent (_this select 0) setVariable ["Bum_Blindzeus_Stance", (_this select 0) lbText (_this select 1)];}];

for "_i" from 0 to (lbSize _ctrlStance) do {
	_ctrlStance lbSetPictureColor [_i, [1,1,1,1]];
	if (_ctrlStance lbText _i == _stance) then {
		_ctrlStance lbSetCurSel _i;
	};
};
private _ctrlBackground = _dialog ctrlCreate ["RscBackgroundGUI",-1]; //create it first so its in the back-

private _ctrlHeight = (_okCtrlHeight * 5);
private _ctrlStackHeight = _ctrlHeight;
_ctrlStance ctrlSetPosition [_okCtrlPosX+_okCtrlWidth, _okCtrlPosY-_ctrlHeight, _okCtrlWidth * 1.5, _ctrlHeight];
_ctrlStance ctrlCommit 0;

private _ctrlStanceText = _dialog ctrlCreate ["RscText", -1];
_ctrlHeight = _okCtrlHeight;
_ctrlStackHeight = _ctrlStackHeight + _ctrlHeight;
_ctrlStanceText ctrlSetPosition [_okCtrlPosX+_okCtrlWidth, _okCtrlPosY-_ctrlStackHeight, _okCtrlWidth * 1.5, _ctrlHeight];
_ctrlStanceText ctrlSetText "Stance:";
_ctrlStanceText ctrlCommit 0;

private _ctrlForceBehahvior = _dialog ctrlCreate ["RscCheckBox", 141141];
_ctrlHeight = _okCtrlHeight;
_ctrlStackHeight = _ctrlStackHeight + _ctrlHeight;
_ctrlForceBehahvior ctrlSetPosition [_okCtrlPosX+(_okCtrlWidth*2), _okCtrlPosY - _ctrlStackHeight, _okCtrlWidth*(1/3), _okCtrlHeight];
_ctrlForceBehahvior ctrlCommit 0;
_ctrlForceBehahvior cbSetChecked _forcedBehavior;
_ctrlForceBehahvior ctrlSetTooltip "Force Group Behavior to remain as set. Disables AUTOCOMBAT during this waypoint";
_ctrlForceBehahvior ctrlAddEventHandler ["CheckedChanged",{ctrlParent (_this select 0) setVariable ["Bum_Blindzeus_ForceBehavior",_this select 1]}];

private _ctrlForceBehahviorText = _dialog ctrlCreate ["RscText", -1];
_ctrlForceBehahviorText ctrlSetText "Force Behaviour:";
_ctrlForceBehahviorText ctrlSetPosition [_okCtrlPosX+_okCtrlWidth, _okCtrlPosY-_ctrlStackHeight, _okCtrlWidth * 1.5, _ctrlHeight];
_ctrlForceBehahviorText ctrlCommit 0;

_ctrlBackground ctrlSetPosition [_okCtrlPosX+_okCtrlWidth, _okCtrlPosY-_ctrlStackHeight, _okCtrlWidth * 1.5, _ctrlStackHeight];
_ctrlBackground ctrlCommit 0;
_ctrlBackground ctrlEnable false;
