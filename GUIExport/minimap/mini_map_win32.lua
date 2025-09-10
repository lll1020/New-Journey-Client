local ui = {}
local _V = function(v) return SL:GetMetaValue(v) end
local FUNCQUEUE = {}
local TAGOBJ = {}

function ui.init(parent, __data__, __update__)
	if __update__ then return ui.update(__data__) end
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "大地图_节点")
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 568.00, 320.00, 676, 508, false)
	GUI:setChineseName(Panel_1, "大地图_组合")
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 55)
	TAGOBJ["55"] = Panel_1

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(Panel_1, "FrameLayout", 395.00, 268.00, 790, 536, false)
	GUI:setChineseName(FrameLayout, "大地图 _外组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", -22.00, 0.00, "res/custom/MiniMap_img/minimap_bg_win32.png")
	GUI:Image_setScale9Slice(FrameBG, 272, 272, 194, 194)
	GUI:setChineseName(FrameBG, "大地图 _背景图")
	GUI:setAnchorPoint(FrameBG, 0.00, 0.00)
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 104.00, 390.00, 20, "#d8c8ae", [[地图]])
	GUI:setChineseName(TitleText, "大地图 _标题_文本")
	GUI:setAnchorPoint(TitleText, 0.00, 0.00)
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:setVisible(TitleText, false)
	GUI:Text_enableOutline(TitleText, "#000000", 1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 690.00, 393.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, [[]])
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "大地图 _关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 0.00)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create zdy_Button1
	local zdy_Button1 = GUI:Button_Create(FrameLayout, "zdy_Button1", 499.00, 73.00, "res/custom/MiniMap_img/btn1.png")
	GUI:Button_setTitleText(zdy_Button1, [[]])
	GUI:Button_setTitleColor(zdy_Button1, "#ffffff")
	GUI:Button_setTitleFontSize(zdy_Button1, 14)
	GUI:Button_titleEnableOutline(zdy_Button1, "#000000", 1)
	GUI:setChineseName(zdy_Button1, "自定义按钮1")
	GUI:setAnchorPoint(zdy_Button1, 0.00, 0.00)
	GUI:setTouchEnabled(zdy_Button1, true)
	GUI:setTag(zdy_Button1, -1)

	-- Create zdy_Button2
	local zdy_Button2 = GUI:Button_Create(FrameLayout, "zdy_Button2", 499.00, 21.00, "res/custom/MiniMap_img/btn2.png")
	GUI:Button_setTitleText(zdy_Button2, [[]])
	GUI:Button_setTitleColor(zdy_Button2, "#ffffff")
	GUI:Button_setTitleFontSize(zdy_Button2, 14)
	GUI:Button_titleEnableOutline(zdy_Button2, "#000000", 1)
	GUI:setChineseName(zdy_Button2, "自定义按钮2")
	GUI:setAnchorPoint(zdy_Button2, 0.00, 0.00)
	GUI:setTouchEnabled(zdy_Button2, true)
	GUI:setTag(zdy_Button2, -1)

	-- Create Panel_map
	local Panel_map = GUI:Layout_Create(Panel_1, "Panel_map", 0.00, 0.00, 676, 508, false)
	GUI:setChineseName(Panel_map, "大地图_组合")
	GUI:setAnchorPoint(Panel_map, 0.00, 0.00)
	GUI:setTouchEnabled(Panel_map, false)
	GUI:setTag(Panel_map, 56)
	TAGOBJ["56"] = Panel_map

	-- Create Panel_minimap
	local Panel_minimap = GUI:Layout_Create(Panel_map, "Panel_minimap", 338.00, 254.00, 500, 350, false)
	GUI:setChineseName(Panel_minimap, "大地图_组合")
	GUI:setAnchorPoint(Panel_minimap, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_minimap, false)
	GUI:setTag(Panel_minimap, 58)
	TAGOBJ["58"] = Panel_minimap

	-- Create Image_mini_map
	local Image_mini_map = GUI:Image_Create(Panel_minimap, "Image_mini_map", 250.00, 175.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_mini_map, "大地图_大地图_图片")
	GUI:setAnchorPoint(Image_mini_map, 0.50, 0.50)
	GUI:setTouchEnabled(Image_mini_map, false)
	GUI:setTag(Image_mini_map, 59)
	TAGOBJ["59"] = Image_mini_map

	-- Create Panel_event
	local Panel_event = GUI:Layout_Create(Panel_minimap, "Panel_event", 250.00, 175.00, 200, 200, false)
	GUI:setChineseName(Panel_event, "大地图_事件")
	GUI:setAnchorPoint(Panel_event, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_event, true)
	GUI:setTag(Panel_event, 61)
	TAGOBJ["61"] = Panel_event

	-- Create Node_monster
	local Node_monster = GUI:Node_Create(Panel_minimap, "Node_monster", 0.00, 0.00)
	GUI:setChineseName(Node_monster, "大地图_怪物节点")
	GUI:setTag(Node_monster, 70)
	TAGOBJ["70"] = Node_monster

	-- Create Node_team
	local Node_team = GUI:Node_Create(Panel_minimap, "Node_team", 0.00, 0.00)
	GUI:setChineseName(Node_team, "大地图_队友节点")
	GUI:setTag(Node_team, 71)
	TAGOBJ["71"] = Node_team

	-- Create Node_portals
	local Node_portals = GUI:Node_Create(Panel_minimap, "Node_portals", 0.00, 0.00)
	GUI:setChineseName(Node_portals, "大地图_描述节点")
	GUI:setTag(Node_portals, 72)
	TAGOBJ["72"] = Node_portals

	-- Create Node_path
	local Node_path = GUI:Node_Create(Panel_minimap, "Node_path", 0.00, 0.00)
	GUI:setChineseName(Node_path, "大地图_路径")
	GUI:setTag(Node_path, 62)
	TAGOBJ["62"] = Node_path

	-- Create Image_point
	local Image_point = GUI:Layout_Create(Panel_minimap, "Image_point", 100.00, 80.00, 100, 20, false)
	GUI:Layout_setBackGroundImage(Image_point, "res/private/minimap/1900012108.png")
	GUI:Layout_setBackGroundColorType(Image_point, 1)
	GUI:Layout_setBackGroundColor(Image_point, "#ffffff")
	GUI:Layout_setBackGroundColorOpacity(Image_point, 0)
	GUI:Layout_setBackGroundImageScale9Slice(Image_point, 50, 50, 0, 0)
	GUI:setChineseName(Image_point, "大地图_坐标组合")
	GUI:setAnchorPoint(Image_point, 0.50, 0.50)
	GUI:setTouchEnabled(Image_point, false)
	GUI:setTag(Image_point, 63)
	TAGOBJ["63"] = Image_point

	-- Create Text_point
	local Text_point = GUI:Text_Create(Image_point, "Text_point", 50.00, 10.00, 12, "#00ff00", [[(123，123）]])
	GUI:setAnchorPoint(Text_point, 0.50, 0.50)
	GUI:setTouchEnabled(Text_point, false)
	GUI:setTag(Text_point, 64)
	TAGOBJ["64"] = Text_point
	GUI:Text_enableOutline(Text_point, "#000000", 1)

	-- Create Image_player
	local Image_player = GUI:Image_Create(Panel_minimap, "Image_player", 100.00, 50.00, "res/private/minimap/icon_xdtzy_02.png")
	GUI:setChineseName(Image_player, "大地图_玩家位置_图片")
	GUI:setAnchorPoint(Image_player, 0.50, 0.50)
	GUI:setTouchEnabled(Image_player, false)
	GUI:setTag(Image_player, 65)
	TAGOBJ["65"] = Image_player

	-- Create Text_mouse_pos
	local Text_mouse_pos = GUI:Text_Create(Panel_minimap, "Text_mouse_pos", 500.00, 0.00, 12, "#ffffff", [[99:99]])
	GUI:setChineseName(Text_mouse_pos, "大地图_鼠标指针_坐标")
	GUI:setAnchorPoint(Text_mouse_pos, 1.00, 0.00)
	GUI:setTouchEnabled(Text_mouse_pos, false)
	GUI:setTag(Text_mouse_pos, 12)
	TAGOBJ["12"] = Text_mouse_pos
	GUI:Text_enableOutline(Text_mouse_pos, "#000000", 1)

	-- Create Node_zjdqShow
	local Node_zjdqShow = GUI:Node_Create(Panel_minimap, "Node_zjdqShow", 0.00, 0.00)
	GUI:setTag(Node_zjdqShow, 0)

	-- Create Image_mapNameBG
	local Image_mapNameBG = GUI:Image_Create(Panel_1, "Image_mapNameBG", 332.00, 417.00, "res/private/minimap/1900012107.png")
	GUI:setChineseName(Image_mapNameBG, "大地图 _地图标题_背景")
	GUI:setAnchorPoint(Image_mapNameBG, 0.50, 1.00)
	GUI:setTouchEnabled(Image_mapNameBG, false)
	GUI:setTag(Image_mapNameBG, -1)
	GUI:setVisible(Image_mapNameBG, false)

	-- Create Text_mapName
	local Text_mapName = GUI:Text_Create(Panel_1, "Text_mapName", 169.00, 432.00, 16, "#ffffff", [[地图]])
	GUI:setChineseName(Text_mapName, "大地图 _地图名称_文本")
	GUI:setAnchorPoint(Text_mapName, 0.50, 1.00)
	GUI:setTouchEnabled(Text_mapName, false)
	GUI:setTag(Text_mapName, -1)
	GUI:Text_enableOutline(Text_mapName, "#000000", 1)

	ui.update(__data__)
	return Node
end

function ui.update(data)
	for _, func in pairs(FUNCQUEUE) do
		if func then func(data) end
	end
end

return ui
