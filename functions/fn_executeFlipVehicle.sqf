params ["_vehicle", "_newPos"];

_vehicle setpos [_newPos select 0, _newpos select 1, 0.5];
_vehicle setVectorUp [0,0,1];
true