#include "UI_defines.cpp"
#include "UI_baseClasses.cpp"
#include "UI_SetAISettingsDialog.cpp"
#include "UI_ShareClaimUnitsDialog.cpp"

class RscDisplayAttributes;
class Controls: RscDisplayAttributes {
    class Title;
};

class RscDisplayAttributesWaypoint: RscDisplayAttributes 
{
	class Controls: Controls 
	{
		class Title: Title
		{
            onLoad = "[Bum_fnc_createWaypointDialogAdditions, _this] call CBA_fnc_execNextFrame;";
        };
	};
};