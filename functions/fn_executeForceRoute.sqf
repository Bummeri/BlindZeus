params ["_vehicle", "_positionArray"];

if (isNull _vehicle) exitWith {false};

//Inline Functions

private _fnc_getAdditionalPoint = {
	//This function returns an additional point between two points that can help vehicle stay on course during SetDriveOnPath order
	params ["_pos1", "_pos2", "_additionalPositionDistance"];

	private _distanceBetween = _pos1 distance _pos2;
	private _additionalPosition = [];

	if (_distanceBetween > (_additionalPositionDistance + 1)) then
	{
		private _unitVector = _pos1 vectorFromTo _pos2;
		_additionalPosition = _pos1 vectorAdd (_unitVector vectorMultiply _additionalPositionDistance);
	} else {
		_additionalPosition = (_pos1 vectorDiff _pos2) vectorMultiply 0.5;
	};
	private _returnArray = [_additionalPosition];
	_returnArray
};

private _fnc_getLastPoint = {
	//This function returns an additional point after the last that will help make sure SetDriveOnPath wont make vehicles stuck
	params ["_pos1", "_pos2", "_additionalPositionDistance"];

	private _unitVector = _pos1 vectorFromTo _pos2;
	private _additionalPosition = _pos2 vectorAdd (_unitVector vectorMultiply _additionalPositionDistance);
	private _returnArray = [_additionalPosition];
	_returnArray
};

private _vehiclePos = getPos _vehicle;
private _pointDistance = 5;
private _isTank = _vehicle isKindOf "Tank";
if (_isTank) then {
	_pointDistance = (sizeOf typeOf _vehicle) * 0.7;
};
private _finalArray = [];
{
	if (_forEachIndex == 0) then
	{
		_finalArray append [_vehiclePos];
		private _additionalPoint = [_vehiclePos, _x, _pointDistance] call _fnc_getAdditionalPoint;
		_finalArray append _additionalPoint;
	};

	if (_forEachIndex == ((count _positionArray) - 1)) then
	{
		_finalArray append [_x];
		private _prevPoint = [];
		if (_forEachIndex == 0) then
		{
			_prevPoint = _vehiclePos;
		} else {
			_prevPoint = _positionArray select (_forEachIndex - 1);
		};
		private _additionalPoint = [_prevPoint, _x, _pointDistance] call _fnc_getLastPoint;
		_finalArray append _additionalPoint;
	} else {
		private _currentPoint = _x;
		private _nextPoint = _positionArray select (_forEachIndex + 1);
		_finalArray append [_currentPoint];
		private _returnArray = [_currentPoint, _nextPoint, _pointDistance] call _fnc_getAdditionalPoint;
		_finalArray append _returnArray;
	};
} forEach _positionArray;

private _vehicleHeight = 0.1;
{
	_x set [2, _vehicleHeight];
	if (_isTank) then {
		if (_foreachindex >= (count _finalarray - 2)) then {
			_x set [3, 7]; //Set a speed limit to tanks for the final two points
		};
	};
} forEach _finalArray;

_vehicle setDriveOnPath _finalArray;

if (Bum_Blindzeus_enableDebug) then {
		hint format ["_finalArray is: %1", _finalArray];
	finalArray = _finalArray;

	{
		_x resize 3;
		createSimpleObject ["a3\structures_f_bootcamp\vr\helpers\vr_3dselector_01_f.p3d", AGLToASL _x, true];
	} forEach _finalArray;
};


true