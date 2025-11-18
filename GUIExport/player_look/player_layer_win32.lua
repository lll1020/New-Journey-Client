local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", -300.00, -100.00)
	GUI:setChineseName(Scene, "玩家面板场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 715.00, 51.00, 465.00, 519.00, false)
	GUI:setChineseName(Panel_1, "玩家面板_组合")
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 125)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 0.00, 0.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015000.png")
	GUI:setChineseName(Image_bg, "玩家面板_背景图")
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 131)

	-- Create Image_20
	local Image_20 = GUI:Image_Create(Panel_1, "Image_20", 0.00, 0.00, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015001.png")
	GUI:setChineseName(Image_20, "玩家面板_背景图")
	GUI:setTouchEnabled(Image_20, false)
	GUI:setTag(Image_20, 132)
	-- Create Text_Name
	local Text_Name = GUI:Text_Create(Panel_1, "Text_Name", 224.00, 502.00, 18, "#ffe400", [[]])
	GUI:setChineseName(Text_Name, "玩家面板_玩家昵称_文本")
	GUI:setAnchorPoint(Text_Name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_Name, false)
	GUI:setTag(Text_Name, 132)
	GUI:Text_enableOutline(Text_Name, "#0e0e0e", 1)

	-- Create ButtonClose
	local ButtonClose = GUI:Button_Create(Panel_1, "ButtonClose", 410.00, 516.00, "res/private/player_main_layer_ui/close.png")
	GUI:Button_setTitleText(ButtonClose, "")
	GUI:Button_setTitleColor(ButtonClose, "#414146")
	GUI:Button_setTitleFontSize(ButtonClose, 14)
	GUI:Button_titleDisableOutLine(ButtonClose)
	GUI:Win_SetParam(ButtonClose, {grey = 1}, "Button")
	GUI:setChineseName(ButtonClose, "玩家面板_关闭按钮")
	GUI:setAnchorPoint(ButtonClose, 0.50, 0.50)
	GUI:setTouchEnabled(ButtonClose, true)
	GUI:setTag(ButtonClose, 133)

	-- Create Node_panel
	local Node_panel = GUI:Node_Create(Panel_1, "Node_panel", 20.00, 0.00)
	GUI:setChineseName(Node_panel, "玩家面板_节点")
	GUI:setAnchorPoint(Node_panel, 0.50, 0.50)
	GUI:setTag(Node_panel, 134)

	-- Create Panel_btnList
	local Panel_btnList = GUI:Layout_Create(Panel_1, "Panel_btnList", 383.00, 494.00, 112.00, 340.00, false)
	GUI:setChineseName(Panel_btnList, "玩家面板_侧边条组合")
	GUI:setAnchorPoint(Panel_btnList, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_btnList, false)
	GUI:setTag(Panel_btnList, 130)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_btnList, "Button_1", 0.00, 340.00, "res/private/player_main_layer_ui/name1.png")
	GUI:Button_loadTexturePressed(Button_1, "res/private/player_main_layer_ui/name1_n.png")
	GUI:Button_loadTextureDisabled(Button_1, "res/private/player_main_layer_ui/name1_n.png")
	GUI:Button_setTitleText(Button_1, "")
	GUI:Button_setTitleColor(Button_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleDisableOutLine(Button_1)
	GUI:Win_SetParam(Button_1, {grey = 1}, "Button")
	GUI:setChineseName(Button_1, "玩家面板_装备_按钮")
	GUI:setAnchorPoint(Button_1, 0.00, 1.00)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, -1)

	-- Create Button_6
	local Button_6 = GUI:Button_Create(Panel_btnList, "Button_6", 0.00, 270.00, "res/private/player_main_layer_ui/name5.png")
	GUI:Button_loadTexturePressed(Button_6, "res/private/player_main_layer_ui/name5_n.png")
	GUI:Button_loadTextureDisabled(Button_6, "res/private/player_main_layer_ui/name5_n.png")
	GUI:Button_setTitleText(Button_6, "")
	GUI:Button_setTitleColor(Button_6, "#ffffff")
	GUI:Button_setTitleFontSize(Button_6, 14)
	GUI:Button_titleDisableOutLine(Button_6)
	GUI:Win_SetParam(Button_6, {grey = 1}, "Button")
	GUI:setChineseName(Button_6, "玩家面板_称号_按钮")
	GUI:setAnchorPoint(Button_6, 0.00, 1.00)
	GUI:setTouchEnabled(Button_6, true)
	GUI:setTag(Button_6, -1)

	-- Create Button_11
	local Button_11 = GUI:Button_Create(Panel_btnList, "Button_11", 0.00, 200.00, "res/private/player_main_layer_ui/name2.png")
	GUI:Button_loadTexturePressed(Button_11, "res/private/player_main_layer_ui/name2_n.png")
	GUI:Button_loadTextureDisabled(Button_11, "res/private/player_main_layer_ui/name2_n.png")
	GUI:Button_setTitleText(Button_11, "")
	GUI:Button_setTitleColor(Button_11, "#ffffff")
	GUI:Button_setTitleFontSize(Button_11, 14)
	GUI:Button_titleDisableOutLine(Button_11)
	GUI:Win_SetParam(Button_11, {grey = 1}, "Button")
	GUI:setChineseName(Button_11, "玩家面板_时装_按钮")
	GUI:setAnchorPoint(Button_11, 0.00, 1.00)
	GUI:setTouchEnabled(Button_11, true)
	GUI:setTag(Button_11, -1)
	-- Create Image_name
	local Image_name = GUI:Image_Create(Button_11, "Image_name", 0.00, -36.00, "res/private/player_main_layer_ui/img.png")
	GUI:setTouchEnabled(Image_name, false)
	GUI:setTag(Image_name, -1)

end
return ui