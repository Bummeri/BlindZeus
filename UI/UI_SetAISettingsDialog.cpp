//--- BLINDZEUS_SETAISETTINGSDIALOG
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1000	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1001	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1002	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1003	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1004	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1005	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1006	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1007	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1008	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1009	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCBUTTON_1600	39739
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCBUTTON_1601	39740
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1800	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1801	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1802	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_IGUIBACK_2200	-1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2800	310939
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2801	310940
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2802	310941
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2803	310942
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2804	310943
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2805	310944
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2806	310945
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2807	310946
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2808	310947
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1010 -1
#define IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1011 310948

class Blindzeus_setAISettingsDialog : Blindzeus_baseClasses{
	idd = 38385;
	onload = "_this call compile preprocessFileLineNumbers ""x\Bum\addons\BlindZeus\UI\UI_setAISettingsDialog.sqf""";
	class controls {
		class IGUIBack_2200: IGUIBack
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_IGUIBACK_2200;
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 22.5 * GUI_GRID_W;
			h = 9.5 * GUI_GRID_H;//11.5 if you want to include waypoint
			moving = 1;
		};
		class RscFrame_1800: RscFrame
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1800;
			text = "Set AI Settings"; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 21.5 * GUI_GRID_W; 
			h = 9 * GUI_GRID_H; //11 if you want to include waypoint
			sizeEx = 1 * GUI_GRID_H;
			moving = 1;
		};
		class RscFrame_1801: RscFrame
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1801;
			text = "Vehicle Specific settings"; //--- ToDo: Localize;
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 13 * GUI_GRID_W;
			h = 4 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscFrame_1802: RscFrame
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCFRAME_1802;
			text = "Selection"; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 10 * GUI_GRID_H + GUI_GRID_Y;
			w = 21.5 * GUI_GRID_W;
			h = 3.5 * GUI_GRID_H;//5.5 if you want to include waypoint
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscText_1000: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1000;
			text = "Apply to all Editable objects: "; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 7.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1001: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1001;
			text = "Apply to group under module :"; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12 * GUI_GRID_H + GUI_GRID_Y;
			w = 11 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1003: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1003;
			text = "AutoCombat :"; //--- ToDo: Localize;
			x = 8 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1004: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1004;
			text = "Allow Fleeing :"; //--- ToDo: Localize;
			x = 8 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1005: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1005;
			text = "Enable Attack :"; //--- ToDo: Localize;
			x = 8 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1006: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1006;
			text = "Unload in combat;"; //--- ToDo: Localize;
			x = 16 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.9 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1007: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1007;
			text = "Crew disembarks from Immobilized :"; //--- ToDo: Localize;
			x = 16 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1008: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1008;
			text = "Turrets:"; //--- ToDo: Localize;
			x = 21.1 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.2 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1009: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1009;
			text = "Cargo:"; //--- ToDo: Localize;
			x = 24.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class OK: RscButton
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCBUTTON_1600;
			text = "OK"; //--- ToDo: Localize;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class Cancel: RscButton
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCBUTTON_1601;
			text = "Cancel"; //--- ToDo: Localize;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class ApplyToEditable: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2800;
			x = 21.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Apply settings to every editable group and vehicle you have"; //--- ToDo: Localize;
		};
		class ApplyToGroup: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2801;
			x = 21.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Apply only to group under the placed module"; //--- ToDo: Localize;
		};
		class AutoCombat: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2803;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Units can automatically change to COMBAT-mode"; //--- ToDo: Localize;
		};
		class AllowFleeing: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2804;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Units can flee"; //--- ToDo: Localize;
		};
		class EnableAttack: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2805;
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Group will send small teams on combat tasks. They can last a long time and you lose control of the units for the duration."; //--- ToDo: Localize;
		};
		class UnloadTurrets: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2806;
			x = 23.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Allow automatic unload of units from vehicles turrets if in combat"; //--- ToDo: Localize;
		};
		class UnloadImmobilized: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2807;
			x = 25.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Automatically unload all the crew when vehicle is immobilized"; //--- ToDo: Localize;
		};
		class UnloadCargo: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2808;
			x = 26.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Allow automatic unload of units from vehicles cargo seats if in combat"; //--- ToDo: Localize;
		};
		/*
		class ApplyOnWaypoint: RscCheckbox
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCCHECKBOX_2802;
			x = 21.5 * GUI_GRID_W + GUI_GRID_X;
			y = 13 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Check and apply settings to each vehicle and group, each time you give a waypoint to them"; //--- ToDo: Localize;
		};
		class RscText_1010: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1010;
			text = "Waypoint checking:"; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class ApplyOnWaypointInfo: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1011;
			text = "Disabled"; //--- ToDo: Localize;
			x = 12.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorText[] = {1,0,0,1};
			tooltip = "Tells if the settings are being applied to each group and vehicle you are issuing waypoints"; //--- ToDo: Localize;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		class RscText_1002: RscText
		{
			idc = IDC_BLINDZEUS_SETAISETTINGSDIALOG_RSCTEXT_1002;
			text = "Apply each time you give vehicle or group a waypoint :"; //--- ToDo: Localize;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 13 * GUI_GRID_H + GUI_GRID_Y;
			w = 13.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 0.7 * GUI_GRID_H;
		};
		*/
	};
};


