local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "背包场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 100.00, 500.00, 390.00, 340.00, false)
	GUI:setChineseName(Panel_1, "背包组合框")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 18)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 205.00, 152.00, "res/private/bag_ui/bag_ui_win32/bg_beibao_01.png")
	GUI:setChineseName(Image_bg, "背包_背景_图片")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 20)

	-- Create Image_bg_tt
	local Image_bg_tt = GUI:Image_Create(Panel_1, "Image_bg_tt", 346.00, 475.00, "res/private/bag_ui/bag_ui_win32/bg_beibao_03.png")
	GUI:setChineseName(Image_bg_tt, "背包_背景_tt")
	GUI:setAnchorPoint(Image_bg_tt, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg_tt, false)
	GUI:setTag(Image_bg_tt, 100)

	-- Create Button1
	local Button1 = GUI:Button_Create(Image_bg, "Button1", 63 + 240, 40, "res/wy/public/an_zl.png")
	GUI:Button_setTitleColor(Button1, "#ffff00")
	GUI:Button_setTitleFontSize(Button1, 14)
	GUI:Button_titleEnableOutline(Button1, "#000000", 1)
	GUI:setTouchEnabled(Button1, true)
	GUI:setTag(Button1, -1)

	---- Create Button2
	--local Button2 = GUI:Button_Create(Image_bg, "Button2", 63, 40, "res/wy/public/an_dh.png")
	--GUI:Button_setTitleColor(Button2, "#ffff00")
	--GUI:Button_setTitleFontSize(Button2, 14)
	--GUI:Button_titleEnableOutline(Button2, "#000000", 1)
	--GUI:setTouchEnabled(Button2, true)
	--GUI:setTag(Button2, -1)

	-- Create Button3
	local Button3 = GUI:Button_Create(Image_bg, "Button3", 63 + 160, 40, "res/wy/public/an_hs.png")
	GUI:Button_setTitleColor(Button3, "#ffff00")
	GUI:Button_setTitleFontSize(Button3, 14)
	GUI:Button_titleEnableOutline(Button3, "#000000", 1)
	GUI:setTouchEnabled(Button3, true)
	GUI:setTag(Button3, -1)

	-- Create Button4
	local Button4 = GUI:Button_Create(Image_bg, "Button4", 63, 40, "res/wy/public/an_ck.png")
	GUI:Button_setTitleColor(Button4, "#ffff00")
	GUI:Button_setTitleFontSize(Button4, 14)
	GUI:Button_titleEnableOutline(Button4, "#000000", 1)
	GUI:setTouchEnabled(Button4, true)
	GUI:setTag(Button4, -1)

	-- Create Button5
	local Button5 = GUI:Button_Create(Image_bg, "Button5", 63 + 80, 40, "res/wy/public/an_bbsq.png")
	GUI:Button_setTitleColor(Button5, "#ffff00")
	GUI:Button_setTitleFontSize(Button5, 14)
	GUI:Button_titleEnableOutline(Button5, "#000000", 1)
	GUI:setTouchEnabled(Button5, true)
	GUI:setTag(Button5, -1)

	-- Create Button6
	local Button6 = GUI:Button_Create(Image_bg, "Button6", 63 + 320, 40, "res/wy/public/an_kjhs.png")
	GUI:Button_setTitleColor(Button6, "#ffff00")
	GUI:Button_setTitleFontSize(Button6, 14)
	GUI:Button_titleEnableOutline(Button6, "#000000", 1)
	GUI:setTouchEnabled(Button6, true)
	GUI:setTag(Button6, -1)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_1, "Button_page1", 5.00, 287.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleEnableOutline(Button_page1, "#000000", 1)
	GUI:setChineseName(Button_page1, "背包_第一页_组合框")
	GUI:setAnchorPoint(Button_page1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page1, false)
	GUI:setTag(Button_page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page1, "PageText", 13.00, 45.00, 14, "#ffffff", [[一]])
	GUI:setChineseName(PageText, "背包_第一页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page1, "TouchSize", 0.00, 67.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "背包_第一页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_1, "Button_page2", 5.00, 237.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleEnableOutline(Button_page2, "#000000", 1)
	GUI:setChineseName(Button_page2, "背包_第二页_组合框")
	GUI:setAnchorPoint(Button_page2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page2, false)
	GUI:setTag(Button_page2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page2, "PageText", 13.00, 45.00, 14, "#ffffff", [[二]])
	GUI:setChineseName(PageText, "背包_第二页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page2, "TouchSize", 0.00, 67.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "背包_第二页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_1, "Button_page3", 5.00, 187.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleEnableOutline(Button_page3, "#000000", 1)
	GUI:setChineseName(Button_page3, "背包_第三页_组合框")
	GUI:setAnchorPoint(Button_page3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page3, false)
	GUI:setTag(Button_page3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page3, "PageText", 13.00, 45.00, 14, "#ffffff", [[三]])
	GUI:setChineseName(PageText, "背包_第三页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page3, "TouchSize", 0.00, 67.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "背包_第三页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_1, "Button_page4", 5.00, 137.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleEnableOutline(Button_page4, "#000000", 1)
	GUI:setChineseName(Button_page4, "背包_第四页_组合框")
	GUI:setAnchorPoint(Button_page4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page4, false)
	GUI:setTag(Button_page4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page4, "PageText", 13.00, 45.00, 14, "#ffffff", [[四]])
	GUI:setChineseName(PageText, "背包_第四页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page4, "TouchSize", 0.00, 67.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "背包_第四页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page5
	local Button_page5 = GUI:Button_Create(Panel_1, "Button_page5", 5.00, 87.00, "res/public_win32/1900000683_1_f.png")
	GUI:Button_loadTexturePressed(Button_page5, "res/public_win32/1900000683_f.png")
	GUI:Button_loadTextureDisabled(Button_page5, "res/public_win32/1900000683_f.png")
	GUI:Button_setTitleText(Button_page5, "")
	GUI:Button_setTitleColor(Button_page5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page5, 14)
	GUI:Button_titleEnableOutline(Button_page5, "#000000", 1)
	GUI:setChineseName(Button_page5, "背包_第五页_组合框")
	GUI:setAnchorPoint(Button_page5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page5, false)
	GUI:setTag(Button_page5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page5, "PageText", 13.00, 45.00, 14, "#ffffff", [[五]])
	GUI:setChineseName(PageText, "背包_第五页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page5, "TouchSize", 0.00, 67.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "背包_第五页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 392.00, 316.00, 'res/public/1900000511.png')
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "背包_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 19)

	-- Create Panel_items
	local Panel_items = GUI:Layout_Create(Panel_1, "Panel_items", 32.00, 316.00, 338.00, 214.00, false)
	GUI:setChineseName(Panel_items, "背包_物品")
	GUI:setAnchorPoint(Panel_items, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_items, true)
	GUI:setTag(Panel_items, 21)

	-- Create Image_goldBg
	GUI:Image_Create(Panel_1, "Image_goldBg1", 263, 120.00, "res/wy/public/bag_hb_1.png")
	GUI:Image_Create(Panel_1, "Image_goldBg2", 263, 95.00, "res/wy/public/bag_hb_2.png")
	GUI:Image_Create(Panel_1, "Image_goldBg3", 263, 70.00, "res/wy/public/bag_hb_3.png")

	GUI:Image_Create(Panel_1, "Image_bd_goldBg1", 63.00, 120.00, "res/wy/public/bag_bd_hb_1.png")
	GUI:Image_Create(Panel_1, "Image_bd_goldBg2", 63.00, 95.00, "res/wy/public/bag_bd_hb_2.png")
	GUI:Image_Create(Panel_1, "Image_bd_goldBg3", 63.00, 70.00, "res/wy/public/bag_bd_hb_3.png")

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_1, "Image_gold", 37.00, 75.00, "res/private/bag_ui/bag_ui_win32/1900015220.png")
	GUI:setChineseName(Image_gold, "背包_金币图片")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, true)
	GUI:setTag(Image_gold, 23)

	-- Create Button_store_hero_bag
	local Button_store_hero_bag = GUI:Button_Create(Panel_1, "Button_store_hero_bag", 305.00, 85.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_store_hero_bag, "res/public/1900000652_1.png")
	GUI:Button_loadTextureDisabled(Button_store_hero_bag, "res/public/1900000652_1.png")
	GUI:setContentSize(Button_store_hero_bag, 89, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_store_hero_bag, false)
	GUI:Button_setTitleText(Button_store_hero_bag, "存入英雄背包")
	GUI:Button_setTitleColor(Button_store_hero_bag, "#ffffff")
	GUI:Button_setTitleFontSize(Button_store_hero_bag, 13)
	GUI:Button_titleEnableOutline(Button_store_hero_bag, "#000000", 1)
	GUI:setChineseName(Button_store_hero_bag, "背包_存入英雄背包_按钮")
	GUI:setAnchorPoint(Button_store_hero_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_store_hero_bag, true)
	GUI:setTag(Button_store_hero_bag, 17)

	-- Create ScrollView_items
	local ScrollView_items = GUI:ScrollView_Create(Panel_1, "ScrollView_items", 32.00, 316.00, 338.00, 214.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_items, 340.00, 214.00)
	GUI:setChineseName(ScrollView_items, "背包_物品列表")
	GUI:setAnchorPoint(ScrollView_items, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_items, true)
	GUI:setTag(ScrollView_items, -1)

	-- Create Panel_addItems
	local Panel_addItems = GUI:Layout_Create(Panel_1, "Panel_addItems", 32.00, 316.00, 338.00, 214.00, false)
	GUI:setChineseName(Panel_addItems, "背包_添加物品层")
	GUI:setAnchorPoint(Panel_addItems, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItems, true)
	GUI:setTag(Panel_addItems, 22)
	-- Create Text_goldNum1
	local Text_goldNum1 = GUI:Text_Create(Panel_1, "Text_goldNum1", 263.00 + 125, 120.00 + 3, 14, "#FFFF00", [[0]])
	GUI:setChineseName(Text_goldNum1, "背包_金币数量")
	GUI:setAnchorPoint(Text_goldNum1, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum1, false)
	GUI:setTag(Text_goldNum1, 25)
	GUI:Text_enableOutline(Text_goldNum1, "#000000", 1)

	-- Create Text_goldNum3
	local Text_goldNum3 = GUI:Text_Create(Panel_1, "Text_goldNum3", 63.00 + 150, 120.00 + 3, 14, "#00FF00", [[0]])
	GUI:setChineseName(Text_goldNum3, "背包_绑定金币数量")
	GUI:setAnchorPoint(Text_goldNum3, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum3, false)
	GUI:setTag(Text_goldNum3, -1)
	GUI:Text_enableOutline(Text_goldNum3, "#000000", 1)

	-- Create Text_goldNum2
	local Text_goldNum2 = GUI:Text_Create(Panel_1, "Text_goldNum2", 263.00 + 125, 95.00 + 3, 14, "#FFFF00", [[0]])
	GUI:setChineseName(Text_goldNum2, "背包_元宝数量")
	GUI:setAnchorPoint(Text_goldNum2, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum2, false)
	GUI:setTag(Text_goldNum2, -1)
	GUI:Text_enableOutline(Text_goldNum2, "#000000", 1)

	-- Create Text_goldNum4
	local Text_goldNum4 = GUI:Text_Create(Panel_1, "Text_goldNum4", 63.00 + 150, 95.00 + 3, 14, "#00FF00", [[0]])
	GUI:setChineseName(Text_goldNum4, "背包_绑定元宝数量")
	GUI:setAnchorPoint(Text_goldNum4, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum4, false)
	GUI:setTag(Text_goldNum4, -1)
	GUI:Text_enableOutline(Text_goldNum4, "#000000", 1)

	-- Create Text_goldNum7
	local Text_goldNum7 = GUI:Text_Create(Panel_1, "Text_goldNum7", 263.00 + 125, 70.00 + 3, 14, "#FFFF00", [[0]])
	GUI:setChineseName(Text_goldNum7, "背包_钻石数量")
	GUI:setAnchorPoint(Text_goldNum7, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum7, false)
	GUI:setTag(Text_goldNum7, -1)
	GUI:Text_enableOutline(Text_goldNum7, "#000000", 1)

	-- Create Text_goldNum8
	local Text_goldNum8 = GUI:Text_Create(Panel_1, "Text_goldNum8", 63.00 + 150, 70.00 + 3, 14, "#00FF00", [[0]])
	GUI:setChineseName(Text_goldNum8, "背包_绑定钻石数量")
	GUI:setAnchorPoint(Text_goldNum8, 0.50, 0)
	GUI:setTouchEnabled(Text_goldNum8, false)
	GUI:setTag(Text_goldNum8, -1)
	GUI:Text_enableOutline(Text_goldNum8, "#000000", 1)
end
return ui