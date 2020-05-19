//--- ShareClaimUnitsDialog
#define IDC_SHARECLAIMUNITSDIALOG_RSCTEXT_1000	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCTEXT_1001	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCLISTBOX_1500	522927
#define IDC_SHARECLAIMUNITSDIALOG_RSCLISTBOX_1501	522928
#define IDC_SHARECLAIMUNITSDIALOG_RSCBUTTON_1600	523027
#define IDC_SHARECLAIMUNITSDIALOG_RSCBUTTON_1601	523028
#define IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1800	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1801	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1802	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1803	-1
#define IDC_SHARECLAIMUNITSDIALOG_IGUIBACK_2200	-1
#define IDC_SHARECLAIMUNITSDIALOG_RSCCHECKBOX_2800	524227
#define IDC_SHARECLAIMUNITSDIALOG_RSCCHECKBOX_2801	524228

class Blindzeus_shareClaimUnitsDialog : Blindzeus_baseClasses{
	idd = 58385;
	onload = "[compile preprocessFileLineNumbers ""x\Bum\addons\BlindZeus\UI\UI_shareClaimUnitsDialog.sqf"", _this] call CBA_fnc_execNextFrame;";
	class controls {
		class IGUIBack_2200: IGUIBack
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_IGUIBACK_2200;
			x = 6 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 29.5 * GUI_GRID_W;
			h = 19 * GUI_GRID_H;
			moving = 1;
		};
		class RscFrame_1800: RscFrame
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1800;
			x = 6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 28.5 * GUI_GRID_W;
			h = 18 * GUI_GRID_H;
			moving = 1;
		};
		class RscFrame_1801: RscFrame
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1801;
			text = "Groups and Vehicles:"; //--- ToDo: Localize;
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 14 * GUI_GRID_W;
			h = 17 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscFrame_1802: RscFrame
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1802;
			text = "Zeuses:"; //--- ToDo: Localize;
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 12 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscFrame_1803: RscFrame
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCFRAME_1803;
			text = "Share or Claim Units"; //--- ToDo: Localize;
			x = 22 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.5 * GUI_GRID_W;
			h = 2.5 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class RscText_1000: RscText
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCTEXT_1000;
			text = "Share:"; //--- ToDo: Localize;
			x = 22.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class RscText_1001: RscText
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCTEXT_1001;
			text = "Claim:"; //--- ToDo: Localize;
			x = 27 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class Share: RscCheckbox
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCCHECKBOX_2800;
			x = 25 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Sharing makes the selected groups or vehicles editable to the selected Zeuses"; //--- ToDo: Localize;
		};
		class Claim: RscCheckbox
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCCHECKBOX_2801;
			x = 29.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 1 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			tooltip = "Claiming makes selected groups and vehicles uneditable to selected Zeuses"; //--- ToDo: Localize;
		};
		class OK: RscButton
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCBUTTON_1600;
			text = "OK"; //--- ToDo: Localize;
			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class Cancel: RscButton
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCBUTTON_1601;
			text = "Cancel"; //--- ToDo: Localize;
			x = 30 * GUI_GRID_W + GUI_GRID_X;
			y = 20.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
		};
		class GroupsAndVehicles: RscListbox
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCLISTBOX_1500;
			style = 32; //This makes it so that multiple things can be selected from the listbox
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 13 * GUI_GRID_W;
			h = 15.5 * GUI_GRID_H;
			tooltip = "Select one or more groups or vehicles to share with or claim from other Zeuses"; //--- ToDo: Localize;
		};
		class Curators: RscListbox
		{
			idc = IDC_SHARECLAIMUNITSDIALOG_RSCLISTBOX_1501;
			style = 32;
			x = 22.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 10.5 * GUI_GRID_H;
			tooltip = "Select all the Zeuses you want to share with or claim from"; //--- ToDo: Localize;
		};
	};
};
