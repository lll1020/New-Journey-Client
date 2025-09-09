local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 10.00, -56.00)
	GUI:setChineseName(Scene, "仓库场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 35.00, 380.00, 354.00, 404.00, false)
	GUI:setChineseName(Panel_1, "仓库组合框")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 49)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 161.00, 206.00, "res/public_win32/bg_npc_06_win32.png")
	GUI:setChineseName(Image_bg, "仓库_背景图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 50)

	-- Create Node_page
	local Node_page = GUI:Node_Create(Panel_1, "Node_page", 339.00, 327.00)
	GUI:setChineseName(Node_page, "仓库_描点页")
	GUI:setAnchorPoint(Node_page, 0.50, 0.50)
	GUI:setTag(Node_page, 51)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_1, "Button_page1", 342.00, 298.00, "res/custom/warehouse/win32/group1_2.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/custom/warehouse/win32/group1_1.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/custom/warehouse/win32/group1_1.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleEnableOutline(Button_page1, "#000000", 1)
	GUI:setChineseName(Button_page1, "仓库_第一页_组合框")
	GUI:setAnchorPoint(Button_page1, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page1, false)
	GUI:setTag(Button_page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page1, "PageText", 0.00, 0.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page1, "TouchSize", 0.00, 70.00, 30.00, 50.00, false)
	GUI:setChineseName(TouchSize, "仓库_第一页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_1, "Button_page2", 342.00, 246.00, "res/custom/warehouse/win32/group2_2.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/custom/warehouse/win32/group2_1.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/custom/warehouse/win32/group2_1.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleEnableOutline(Button_page2, "#000000", 1)
	GUI:setChineseName(Button_page2, "仓库_第二页_组合框")
	GUI:setAnchorPoint(Button_page2, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page2, false)
	GUI:setTag(Button_page2, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page2, "TouchSize", 0.00, 69.00, 30.00, 50.00, false)
	GUI:setChineseName(TouchSize, "仓库_第二页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page2, "PageText", 0.00, 0.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_1, "Button_page3", 342.00, 195.00, "res/custom/warehouse/win32/group3_2.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/custom/warehouse/win32/group3_1.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/custom/warehouse/win32/group3_1.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleEnableOutline(Button_page3, "#000000", 1)
	GUI:setChineseName(Button_page3, "仓库_第三页_组合框")
	GUI:setAnchorPoint(Button_page3, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page3, false)
	GUI:setTag(Button_page3, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page3, "TouchSize", 0.00, 68.00, 30.00, 50.00, false)
	GUI:setChineseName(TouchSize, "仓库_第三页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page3, "PageText", 0.00, 0.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_1, "Button_page4", 342.00, 143.00, "res/custom/warehouse/win32/group4_2.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/custom/warehouse/win32/group4_1.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/custom/warehouse/win32/group4_1.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleEnableOutline(Button_page4, "#000000", 1)
	GUI:setChineseName(Button_page4, "仓库_第四页_组合框")
	GUI:setAnchorPoint(Button_page4, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page4, false)
	GUI:setTag(Button_page4, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page4, "TouchSize", 0.00, 70.00, 30.00, 50.00, false)
	GUI:setChineseName(TouchSize, "仓库_第四页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page4, "PageText", 0.00, 0.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Button_page5
	local Button_page5 = GUI:Button_Create(Panel_1, "Button_page5", 342.00, 92.00, "res/custom/warehouse/win32/group5_2.png")
	GUI:Button_loadTexturePressed(Button_page5, "res/custom/warehouse/win32/group5_1.png")
	GUI:Button_loadTextureDisabled(Button_page5, "res/custom/warehouse/win32/group5_1.png")
	GUI:Button_setTitleText(Button_page5, "")
	GUI:Button_setTitleColor(Button_page5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page5, 14)
	GUI:Button_titleEnableOutline(Button_page5, "#000000", 1)
	GUI:setChineseName(Button_page5, "仓库_第五页_组合框")
	GUI:setAnchorPoint(Button_page5, 0.00, 0.50)
	GUI:setTouchEnabled(Button_page5, false)
	GUI:setTag(Button_page5, -1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page5, "TouchSize", 0.00, 69.00, 30.00, 50.00, false)
	GUI:setChineseName(TouchSize, "仓库_第五页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page5, "PageText", 0.00, 0.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create Button_quick
	local Button_quick = GUI:Button_Create(Panel_1, "Button_quick", 57.00, 70.00, "res/private/bag_ui/bag_ui_win32/1900015210.png")
	GUI:Button_loadTexturePressed(Button_quick, "res/private/bag_ui/bag_ui_win32/1900015211.png")
	GUI:Button_setScale9Slice(Button_quick, 15, 15, 4, 4)
	GUI:setContentSize(Button_quick, 59, 21)
	GUI:setIgnoreContentAdaptWithSize(Button_quick, false)
	GUI:Button_setTitleText(Button_quick, "快速存取")
	GUI:Button_setTitleColor(Button_quick, "#ffe400")
	GUI:Button_setTitleFontSize(Button_quick, 12)
	GUI:Button_titleEnableOutline(Button_quick, "#111111", 2)
	GUI:setChineseName(Button_quick, "仓库_快速存取按钮")
	GUI:setAnchorPoint(Button_quick, 0.50, 0.50)
	GUI:setTouchEnabled(Button_quick, true)
	GUI:setTag(Button_quick, 52)
	GUI:setVisible(Button_quick, false)

	-- Create Button_cusomQuick
	local Button_cusomQuick = GUI:Button_Create(Panel_1, "Button_cusomQuick", 24.00, 52.00, "res/custom/warehouse/win32/btn1_1.png")
	GUI:Button_setTitleText(Button_cusomQuick, "")
	GUI:Button_setTitleColor(Button_cusomQuick, "#ffffff")
	GUI:Button_setTitleFontSize(Button_cusomQuick, 14)
	GUI:Button_titleEnableOutline(Button_cusomQuick, "#000000", 1)
	GUI:setTouchEnabled(Button_cusomQuick, true)
	GUI:setTag(Button_cusomQuick, -1)

	-- Create Button_reset
	local Button_reset = GUI:Button_Create(Panel_1, "Button_reset", 243.00, 77.00, "res/custom/warehouse/win32/btn_3.png")
	GUI:Button_setScale9Slice(Button_reset, 38, 38, 17, 16)
	GUI:setContentSize(Button_reset, 114, 50)
	GUI:setIgnoreContentAdaptWithSize(Button_reset, false)
	GUI:Button_setTitleText(Button_reset, "")
	GUI:Button_setTitleColor(Button_reset, "#ffe400")
	GUI:Button_setTitleFontSize(Button_reset, 12)
	GUI:Button_titleEnableOutline(Button_reset, "#111111", 2)
	GUI:setChineseName(Button_reset, "仓库_仓库整理按钮")
	GUI:setAnchorPoint(Button_reset, 0.50, 0.50)
	GUI:setTouchEnabled(Button_reset, true)
	GUI:setTag(Button_reset, 53)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 357.00, 362.00, "res/public/1900000511.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000510.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "仓库_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 54)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_close, "TouchSize", 1.00, 47.00, 40.00, 51.00, false)
	GUI:setChineseName(TouchSize, "仓库_关闭_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, 55)
	GUI:setVisible(TouchSize, false)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", -7.00, 369.00, 336.00, 252.00, false)
	GUI:setChineseName(Panel_items, "仓库_物品")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 56)

	-- Create Panel_itemstouch
	local Panel_itemstouch = GUI:Layout_Create(Panel_1, "Panel_itemstouch", -7.00, 369.00, 336.00, 252.00, false)
	GUI:setChineseName(Panel_itemstouch, "仓库_物品触摸区域")
	GUI:setAnchorPoint(Panel_itemstouch, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_itemstouch, false)
	GUI:setTag(Panel_itemstouch, 57)
end
return ui