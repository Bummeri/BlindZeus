class CfgPatches
{
	class Bum_BlindZeus
	{
		units[] = {"Bum_ModuleBlindzeus","Bum_ModuleForceRoute", "Bum_ModuleRemoteControl","Bum_ModuleUnFuck","Bum_ModuleSetAISettings","Bum_ModuleShareClaimUnits"};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F","3DEN","cba_main","cba_xeh","cba_settings","ace_main", "ace_zeus"};
	};
};

class CfgFactionClasses
{
	//We create a section for blindzeus modules
	class Curator;
	class Bum_BlindZeus : Curator
	{
		displayName = "BlindZeus";
		priority = 2;
        side = 7;
	};
	class Bum_BlindZeusUtils : Curator
	{
		displayName = "BlindZeus Utilities";
		priority = 3;
        side = 7;
	};
};

class CfgFunctions
{
	class Bum
	{
		class BlindZeus
		{
			file = "x\Bum\addons\BlindZeus\functions";
			class startTargetStateMachine{};
			class endTargetStateMachine{};
			class targetCheck{};
			class moduleBlindzeus{};
			class Blindzeus{};
			class removeLogic{};
			class moduleForceRoute{};
			class stopForceRoute{};
			class handleForceRoute{};
			class executeForceRoute{};
			class moduleRemoteControl{};
			class moduleUnFuck{};
			class handleFlipVehicle{};
			class executeFlipVehicle{};
		};
		class BlindZeus_UI
		{
			file = "x\Bum\addons\BlindZeus\UI\functions";
			class createDialogVariables{};
			class saveOrLoadPreviousDialogSettings{};
			class createWaypointDialogAdditions{};
		};
	};
};

class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit; // Default edit box (i.e., text input field)
			class Combo; // Default combo box (i.e., drop-down menu)
			class Checkbox; // Default checkbox (returned value is Bool)
			class CheckboxNumber; // Default checkbox (returned value is Number)
			class ModuleDescription; // Module description
			class Units; // Selection of units on which the module is applied
		};
		class ModuleDescription
		{
			class Anything;
			class AnyPlayer;
			class AnyObject;
			class EmptyDetector;
			class AnyBrain;
		};
	};
	class Bum_ModuleBlindzeus: Module_F
	{
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 1;
		displayName = "Blindzeus"; // Name displayed in the menu
		icon = "x\Bum\addons\BlindZeus\UI\Portraits\blindcurator.paa"; // Map icon. Delete this entry to use the default icon
		category = "Curator";

		// Name of function triggered once conditions are met
		function = "Bum_fnc_moduleBlindzeus";
		// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		functionPriority = 10;
		// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isGlobal = 1;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 0;
		// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isDisposable = 1;
		// // 1 to run init function in Eden Editor as well
		is3DEN = 0;

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			class zeusUnit: Edit
  			{
				displayName = "Blindzeus Unit";
				tooltip = "The variable name of the unit who will be turned from a regular Zeus to a Blindzeus";
				defaultValue = "";
				property = "Bum_moduleBlindzeus_zeusUnit";
			};
			class blindWEST: Checkbox
			{
				displayName = "Blind towards: BLUFOR";
				tooltip = "Enable to make this blindzeus blind towards the units and vehicles of this faction";
				defaultValue = "true";
				property = "Bum_moduleBlindzeus_blindWEST";
			};
			class blindEAST: blindWEST
			{
				displayName = "Blind towards: OPFOR";
				defaultValue = "true";
				property = "Bum_moduleBlindzeus_blindEAST";
			};
			class blindINDEPENDENT: blindWEST
			{
				displayName = "Blind towards: INDFOR";
				defaultValue = "true";
				property = "Bum_moduleBlindzeus_blindINDEPENDENT";
			};
			
			class blindCIVILIAN: blindWEST
			{
				displayName = "Blind towards: CIVILIAN";
				defaultValue = "true";
				property = "Bum_moduleBlindzeus_blindCIVILIAN";
			};
			
			class ModuleDescription: ModuleDescription{};
		};
		class ModuleDescription: ModuleDescription
		{
			description = "This module will turn zeus into a Blindzeus. Use by defining the variable name of the zeus who will be turned blind. Do not sync."; // Short description, will be formatted as structured text
			sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
	class Bum_ModuleForceRoute: Module_F
	{
		mapSize = 1;
		vehicleClass = "Modules";
		side = 7;

		// Standard object definitions
		scope = 1; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		scopeCurator = 2;
		displayName = "Force Route"; // Name displayed in the menu
		//icon = "\myTag_addonName\data\iconNuke_ca.paa"; // Map icon. Delete this entry to use the default icon
		portrait = "x\Bum\addons\BlindZeus\UI\Portraits\force_route.paa";
		category = "Bum_BlindZeus";

		// Name of function triggered once conditions are met
		function = "Bum_fnc_moduleForceRoute";
		// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		functionPriority = 1;
		// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isGlobal = 2;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 0;
		// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isDisposable = 0;
		// 1 to run init function in Eden Editor as well
		is3DEN = 0;
		curatorCanAttach = 1; //Can stick to units

		// Menu displayed when the module is placed or double-clicked on by Zeus
		//curatorInfoType = "RscDisplayAttributeModuleNuke";
	};
	class Bum_ModuleRemoteControl: Bum_ModuleForceRoute
	{
		displayName = "Stackable Remote Control"; // Name displayed in the menu
		portrait = "\a3\Modules_F_Curator\Data\portraitRemoteControl_ca.paa";
		category = "Bum_BlindZeus";
		function = "Bum_fnc_moduleRemoteControl";
		isDisposable = 1;
	};
	class Bum_ModuleUnFuck: Bum_ModuleForceRoute
	{
		displayName = "UnFuck Vehicle"; // Name displayed in the menu
		portrait = "x\Bum\addons\BlindZeus\UI\Portraits\Unfuck_vehicle.paa";
		category = "Bum_BlindZeusUtils";
		function = "Bum_fnc_moduleUnFuck";
		isDisposable = 1;
	};
	class Bum_ModuleSetAISettings: Bum_ModuleForceRoute
	{
		displayName = "Set AI Settings"; // Name displayed in the menu
		portrait = "x\Bum\addons\BlindZeus\UI\Portraits\setAiSettings.paa";
		category = "Bum_BlindZeusUtils";
		function = "Bum_fnc_removeLogic"; //Remove the logic straightaway
		curatorInfoType = "Blindzeus_setAISettingsDialog"; //This opens the dialog when the module is used. The dialog function is called by the dialog config.
		curatorCanAttach = 0;
	};
	class Bum_ModuleShareClaimUnits: Bum_ModuleForceRoute
	{
		displayName = "Share or Claim Units"; // Name displayed in the menu
		portrait = "x\Bum\addons\BlindZeus\UI\Portraits\share_units.paa";
		category = "Bum_BlindZeusUtils";
		functionPriority = 0;
		function = "Bum_fnc_removeLogic"; //Remove the logic straightaway, save the placed position
		curatorInfoType = "Blindzeus_shareClaimUnitsDialog"; //This opens the dialog when the module is used. The dialog function is called by the dialog config.
		curatorCanAttach = 0;
	};
	//Remember to add new module also to cfgPatches!!
};

#include "cfgHints.cpp"
#include "CBASettings_preinit.cpp"
#include "UI\UI_config.cpp"