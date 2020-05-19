params ["_vehicle"];

_vehicle setDriveOnPath [getpos _vehicle, getpos _vehicle vectoradd ((velocity _vehicle) vectorMultiply 2)];
true