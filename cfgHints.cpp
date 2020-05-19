class CfgHints
{
	class Bum_Blindzeus
	{
		// Topic title (displayed only in topic listbox in Field Manual)
		displayName = "Blindzeus";
		class ForceRoute
		{
			// Hint title, filled by arguments from 'arguments' param
			displayName = "Force Route";
			// Optional hint subtitle, filled by arguments from 'arguments' param
			displayNameShort = "Force movements for land vehicles";
			// Structured text, filled by arguments from 'arguments' param
			description = "Use the module on a tracked or wheeled vehicle. The vehicle will be forced to move along the assigned route.";
			// Optional structured text, filled by arguments from 'arguments' param (first argument is %11, see notes bellow), grey color of text
			tip = "%2 You can press shift to give multiple waypoints, ESC to cancel <br/> %2 The vehicle will crash if waypoints tell it to<br/> %2 You can stop the vehicle by giving it a new waypoint, new forced route or removing the module<br/> %2 Vehicles tend to cut corners, tracked wont move if first waypoint is too close";
			arguments[] = {};
			// Optional image
			image = "x\Bum\addons\BlindZeus\UI\Portraits\force_route.paa";
			// optional parameter for not showing of image in context hint in mission (default false))
			noImage = false;
			// -1 Creates no log in player diary, 0 Creates diary log ( default when not provided )
			// if a dlc's appID Number is used ( see [[getDLCs]] ) and the user does not have the required dlc installed then the advHint will be replaced with
			// configfile >> "CfgHints" >> "DlcMessage" >> "Dlc#"; where # is this properties ( dlc appID ) number
			dlc = -1;
		};
		class UnFuck
		{
			displayName = "UnFuck Vehicle";
			displayNameShort = "Fix common issues with vehicles";
			description = "Use the module on a tracked or wheeled vehicle. The vehicle is then made functional and controllable in Zeus.";
			tip = "%2 You can change the behavior and requirements from CBA settings <br/> %2 Overturned vehicles can be unflipped and moved <br/> %2 Vehicle leadership and crew will be sorted to a functional state<br/> %2 Vehicle can be fixed/rearmed/refueled";
			arguments[] = {};
			image = "x\Bum\addons\BlindZeus\UI\Portraits\Unfuck_vehicle.paa";
		};
		class StackableRemoteControl
		{
			displayName = "Stackable Remote Control";
			description = "Use this module by placing on top of vehicle or group. Will enable you to remote control the unit.";
			tip = "%2 Functions much like ACE remote control. <br/> %2 Difference is that if vehicle is already remote controlled by another zeus, it will take another crewmember instead.";
			arguments[] = {};
			image = "\a3\Modules_F_Curator\Data\portraitRemoteControl_ca.paa";
		};
		class SetAISettings
		{
			displayName = "Set AI Settings module";
			displayNameShort = "Set usefull settings that change AI behaviour";
			description = "Use this module by placing on top of vehicle or group. You can also place it anywhere empty and set settings for all editable objects.";
			image = "x\Bum\addons\BlindZeus\UI\Portraits\setAiSettings.paa";
		};
		class ShareOrClaimUnits
		{
			displayName = "Share or Claim Units module";
			displayNameShort = "Transfer unit Control to/from others";
			description = "Use this module by placing it anywhere. You can then select one or more groups and empty vehicles to share with, or claim from other zeuses. Sharing allows others to edit the units. Claimig disallows others from interacting with them.";
			tip = "%2 Use Shift or CTRL to select multiple groups/vehicles or Curators. <br/> %2 Groups are listed in order of distance from module position.<br/> %2 Only empty vehicles are listed. Manned vehicles are handled as a part of the group mannign them.";
			image = "x\Bum\addons\BlindZeus\UI\Portraits\share_units.paa";
		};
	};
};