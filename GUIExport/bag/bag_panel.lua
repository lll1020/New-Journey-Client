local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", -41.00, 0.00)
	GUI:setChineseName(Scene, "背包场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 98.00, 340.00, 530.00, 469.00, false)
	GUI:setChineseName(Panel_1, "背包组合框")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, false)
	GUI:setTag(Panel_1, 2)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_1, "Image_bg", 301.00, 235.00, "res/private/bag_ui/bag_ui_mobile/bg_beibao_01.png")
	GUI:setChineseName(Image_bg, "背包_背景_图片1")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, true)
	GUI:setTag(Image_bg, 3)

	-- Create Text_Money1
	local Text_Money1 = GUI:Text_Create(Image_bg, "Text_Money1", 58.00, 98.00, 14, "#ffffff", [[文本]])
	GUI:setTouchEnabled(Text_Money1, false)
	GUI:setTag(Text_Money1, -1)
	GUI:Text_enableOutline(Text_Money1, "#000000", 1)

	-- Create Text_Money2
	local Text_Money2 = GUI:Text_Create(Image_bg, "Text_Money2", 204.00, 99.00, 14, "#ffffff", [[文本]])
	GUI:setTouchEnabled(Text_Money2, false)
	GUI:setTag(Text_Money2, -1)
	GUI:Text_enableOutline(Text_Money2, "#000000", 1)

	-- Create Text_Money3
	local Text_Money3 = GUI:Text_Create(Image_bg, "Text_Money3", 58.00, 60.00, 14, "#ffffff", [[文本]])
	GUI:setTouchEnabled(Text_Money3, false)
	GUI:setTag(Text_Money3, -1)
	GUI:Text_enableOutline(Text_Money3, "#000000", 1)

	-- Create Text_Money4
	local Text_Money4 = GUI:Text_Create(Image_bg, "Text_Money4", 203.00, 60.00, 14, "#ffffff", [[文本]])
	GUI:setTouchEnabled(Text_Money4, false)
	GUI:setTag(Text_Money4, -1)
	GUI:Text_enableOutline(Text_Money4, "#000000", 1)

	-- Create Text_Money5
	local Text_Money5 = GUI:Text_Create(Image_bg, "Text_Money5", 58.00, 22.00, 14, "#ffffff", [[文本]])
	GUI:setTouchEnabled(Text_Money5, false)
	GUI:setTag(Text_Money5, -1)
	GUI:Text_enableOutline(Text_Money5, "#000000", 1)

	-- Create ZongHeButton
	local ZongHeButton = GUI:Button_Create(Image_bg, "ZongHeButton", 307.00, 81.00, "res/custom/bag/btn_1.png")
	GUI:Button_setTitleText(ZongHeButton, "")
	GUI:Button_setTitleColor(ZongHeButton, "#ffffff")
	GUI:Button_setTitleFontSize(ZongHeButton, 10)
	GUI:Button_titleEnableOutline(ZongHeButton, "#000000", 1)
	GUI:setChineseName(ZongHeButton, "背包_货币兑换")
	GUI:setTouchEnabled(ZongHeButton, true)
	GUI:setTag(ZongHeButton, -1)

	-- Create FuWuButton
	local FuWuButton = GUI:Button_Create(Image_bg, "FuWuButton", 415.00, 81.00, "res/custom/bag/fuwu_btn.png")
	GUI:Button_setTitleText(FuWuButton, "")
	GUI:Button_setTitleColor(FuWuButton, "#ffffff")
	GUI:Button_setTitleFontSize(FuWuButton, 10)
	GUI:Button_titleEnableOutline(FuWuButton, "#000000", 1)
	GUI:setChineseName(FuWuButton, "背包_服务")
	GUI:setTouchEnabled(FuWuButton, true)
	GUI:setTag(FuWuButton, -1)

	-- Create HuiShouButton
	local HuiShouButton = GUI:Button_Create(Image_bg, "HuiShouButton", 308.00, 26.00, "res/custom/bag/btn_3.png")
	GUI:Button_setTitleText(HuiShouButton, "")
	GUI:Button_setTitleColor(HuiShouButton, "#ffffff")
	GUI:Button_setTitleFontSize(HuiShouButton, 10)
	GUI:Button_titleEnableOutline(HuiShouButton, "#000000", 1)
	GUI:setChineseName(HuiShouButton, "背包_在线回收")
	GUI:setTouchEnabled(HuiShouButton, true)
	GUI:setTag(HuiShouButton, -1)

	-- Create ZhengLiButton
	local ZhengLiButton = GUI:Button_Create(Image_bg, "ZhengLiButton", 415.00, 26.00, "res/custom/bag/btn_4.png")
	GUI:Button_setTitleText(ZhengLiButton, "")
	GUI:Button_setTitleColor(ZhengLiButton, "#ffffff")
	GUI:Button_setTitleFontSize(ZhengLiButton, 10)
	GUI:Button_titleEnableOutline(ZhengLiButton, "#000000", 1)
	GUI:setChineseName(ZhengLiButton, "背包_整理")
	GUI:setTouchEnabled(ZhengLiButton, true)
	GUI:setTag(ZhengLiButton, -1)

	-- Create Button_page1
	local Button_page1 = GUI:Button_Create(Panel_1, "Button_page1", -21.00, 395.00, "res/custom/bag/mobile_right_group1_2.png")
	GUI:Button_loadTexturePressed(Button_page1, "res/custom/bag/mobile_right_group1_1.png")
	GUI:Button_loadTextureDisabled(Button_page1, "res/custom/bag/mobile_right_group1_1.png")
	GUI:Button_setTitleText(Button_page1, "")
	GUI:Button_setTitleColor(Button_page1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page1, 14)
	GUI:Button_titleEnableOutline(Button_page1, "#000000", 1)
	GUI:setChineseName(Button_page1, "背包_第一页_组合框")
	GUI:setAnchorPoint(Button_page1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page1, false)
	GUI:setTag(Button_page1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page1, "PageText", 20.00, 60.00, 18, "#ffffff", [[一]])
	GUI:setChineseName(PageText, "背包_第一页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page1, "TouchSize", 3.00, 118.00, 35.00, 85.00, false)
	GUI:setChineseName(TouchSize, "背包_第一页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page2
	local Button_page2 = GUI:Button_Create(Panel_1, "Button_page2", -21.00, 301.00, "res/custom/bag/mobile_right_group2_2.png")
	GUI:Button_loadTexturePressed(Button_page2, "res/custom/bag/mobile_right_group2_1.png")
	GUI:Button_loadTextureDisabled(Button_page2, "res/custom/bag/mobile_right_group2_1.png")
	GUI:Button_setTitleText(Button_page2, "")
	GUI:Button_setTitleColor(Button_page2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page2, 14)
	GUI:Button_titleEnableOutline(Button_page2, "#000000", 1)
	GUI:setChineseName(Button_page2, "背包_第二页_组合框")
	GUI:setAnchorPoint(Button_page2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page2, false)
	GUI:setTag(Button_page2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page2, "PageText", 20.00, 60.00, 18, "#ffffff", [[二]])
	GUI:setChineseName(PageText, "背包_第二页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page2, "TouchSize", 3.00, 119.00, 35.00, 85.00, false)
	GUI:setChineseName(TouchSize, "背包_第二页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page3
	local Button_page3 = GUI:Button_Create(Panel_1, "Button_page3", -21.00, 206.00, "res/custom/bag/mobile_right_group3_2.png")
	GUI:Button_loadTexturePressed(Button_page3, "res/custom/bag/mobile_right_group3_1.png")
	GUI:Button_loadTextureDisabled(Button_page3, "res/custom/bag/mobile_right_group3_1.png")
	GUI:Button_setTitleText(Button_page3, "")
	GUI:Button_setTitleColor(Button_page3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page3, 14)
	GUI:Button_titleEnableOutline(Button_page3, "#000000", 1)
	GUI:setChineseName(Button_page3, "背包_第三页_组合框")
	GUI:setAnchorPoint(Button_page3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page3, false)
	GUI:setTag(Button_page3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page3, "PageText", 20.00, 60.00, 18, "#ffffff", [[三]])
	GUI:setChineseName(PageText, "背包_第三页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page3, "TouchSize", 2.00, 119.00, 35.00, 85.00, false)
	GUI:setChineseName(TouchSize, "背包_第三页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page4
	local Button_page4 = GUI:Button_Create(Panel_1, "Button_page4", -21.00, 110.00, "res/custom/bag/mobile_right_group3_2.png")
	GUI:Button_loadTexturePressed(Button_page4, "res/custom/bag/mobile_right_group3_1.png")
	GUI:Button_loadTextureDisabled(Button_page4, "res/custom/bag/mobile_right_group3_1.png")
	GUI:Button_setTitleText(Button_page4, "")
	GUI:Button_setTitleColor(Button_page4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page4, 14)
	GUI:Button_titleEnableOutline(Button_page4, "#000000", 1)
	GUI:setChineseName(Button_page4, "背包_第四页_组合框")
	GUI:setAnchorPoint(Button_page4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page4, false)
	GUI:setTag(Button_page4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page4, "PageText", 20.00, 60.00, 18, "#ffffff", [[四]])
	GUI:setChineseName(PageText, "背包_第四页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page4, "TouchSize", 1.00, 118.00, 35.00, 85.00, false)
	GUI:setChineseName(TouchSize, "背包_第四页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_page5
	local Button_page5 = GUI:Button_Create(Panel_1, "Button_page5", -21.00, 33.00, "res/public/1900000641_1.png")
	GUI:Button_loadTexturePressed(Button_page5, "res/public/1900000640_1.png")
	GUI:Button_loadTextureDisabled(Button_page5, "res/public/1900000640_1.png")
	GUI:Button_setTitleText(Button_page5, "")
	GUI:Button_setTitleColor(Button_page5, "#ffffff")
	GUI:Button_setTitleFontSize(Button_page5, 14)
	GUI:Button_titleEnableOutline(Button_page5, "#000000", 1)
	GUI:setChineseName(Button_page5, "背包_第五页_组合框")
	GUI:setAnchorPoint(Button_page5, 0.50, 0.50)
	GUI:setTouchEnabled(Button_page5, false)
	GUI:setTag(Button_page5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(Button_page5, "PageText", 20.00, 60.00, 18, "#ffffff", [[五]])
	GUI:setChineseName(PageText, "背包_第五页_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:setVisible(PageText, false)
	GUI:Text_enableOutline(PageText, "#000000", 1)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(Button_page5, "TouchSize", 0.00, 92.00, 33.00, 75.00, false)
	GUI:setChineseName(TouchSize, "背包_第五页_触摸区域")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_1, "Button_close", 603.00, 427.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 9, 8, 14, 14)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "背包_关闭按钮")
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 8)

	-- Create Image_gold
	local Image_gold = GUI:Image_Create(Panel_1, "Image_gold", 42.00, 102.00, "res/private/bag_ui/bag_ui_mobile/1900015220.png")
	GUI:setChineseName(Image_gold, "背包_金币图片")
	GUI:setAnchorPoint(Image_gold, 0.50, 0.50)
	GUI:setTouchEnabled(Image_gold, true)
	GUI:setTag(Image_gold, 5)
	GUI:setVisible(Image_gold, false)

	-- Create Button_store_hero_bag
	local Button_store_hero_bag = GUI:Button_Create(Panel_1, "Button_store_hero_bag", 445.00, -8.00, "res/public/1900000652.png")
	GUI:Button_loadTexturePressed(Button_store_hero_bag, "res/public/1900000652_1.png")
	GUI:Button_loadTextureDisabled(Button_store_hero_bag, "res/public/1900000652_1.png")
	GUI:setContentSize(Button_store_hero_bag, 120, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_store_hero_bag, false)
	GUI:Button_setTitleText(Button_store_hero_bag, "存入英雄背包")
	GUI:Button_setTitleColor(Button_store_hero_bag, "#ffffff")
	GUI:Button_setTitleFontSize(Button_store_hero_bag, 18)
	GUI:Button_titleEnableOutline(Button_store_hero_bag, "#000000", 1)
	GUI:setChineseName(Button_store_hero_bag, "背包_存入英雄背包_按钮")
	GUI:setAnchorPoint(Button_store_hero_bag, 0.50, 0.50)
	GUI:setTouchEnabled(Button_store_hero_bag, false)
	GUI:setTag(Button_store_hero_bag, 17)
	GUI:setVisible(Button_store_hero_bag, false)

	-- Create ScrollView_items
	local ScrollView_items = GUI:ScrollView_Create(Panel_1, "ScrollView_items", 16.00, 451.00, 498.00, 312.00, 1)
	GUI:ScrollView_setInnerContainerSize(ScrollView_items, 510.00, 320.00)
	GUI:setChineseName(ScrollView_items, "背包_物品列表")
	GUI:setAnchorPoint(ScrollView_items, 0.00, 1.00)
	GUI:setTouchEnabled(ScrollView_items, true)
	GUI:setTag(ScrollView_items, -1)

	-- Create Panel_addItems
	local Panel_addItems = GUI:Layout_Create(Panel_1, "Panel_addItems", 17.00, 451.00, 498.00, 312.00, false)
	GUI:setChineseName(Panel_addItems, "背包_添加物品层")
	GUI:setAnchorPoint(Panel_addItems, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_addItems, true)
	GUI:setTag(Panel_addItems, 10)

	-- Create ImageXiaoHui
	local ImageXiaoHui = GUI:Image_Create(Panel_1, "ImageXiaoHui", 606.00, 239.00, "res/custom/bag/xiaohui.png")
	GUI:setTouchEnabled(ImageXiaoHui, true)
	GUI:setTag(ImageXiaoHui, -1)
	GUI:setVisible(ImageXiaoHui, false)

	-- Create Button_XiaoHui
	local Button_XiaoHui = GUI:Button_Create(ImageXiaoHui, "Button_XiaoHui", 41.00, 15.00, "res/custom/bag/xiaohui_btn.png")
	GUI:Button_setTitleText(Button_XiaoHui, "")
	GUI:Button_setTitleColor(Button_XiaoHui, "#ffffff")
	GUI:Button_setTitleFontSize(Button_XiaoHui, 14)
	GUI:Button_titleEnableOutline(Button_XiaoHui, "#000000", 1)
	GUI:setTouchEnabled(Button_XiaoHui, true)
	GUI:setTag(Button_XiaoHui, -1)

	-- Create Button_XiaoHuiClose
	local Button_XiaoHuiClose = GUI:Button_Create(ImageXiaoHui, "Button_XiaoHuiClose", 190.00, 178.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_XiaoHuiClose, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_XiaoHuiClose, 9, 8, 14, 14)
	GUI:setContentSize(Button_XiaoHuiClose, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_XiaoHuiClose, false)
	GUI:Button_setTitleText(Button_XiaoHuiClose, "")
	GUI:Button_setTitleColor(Button_XiaoHuiClose, "#414146")
	GUI:Button_setTitleFontSize(Button_XiaoHuiClose, 14)
	GUI:Button_titleEnableOutline(Button_XiaoHuiClose, "#000000", 1)
	GUI:setChineseName(Button_XiaoHuiClose, "背包_关闭按钮")
	GUI:setTouchEnabled(Button_XiaoHuiClose, true)
	GUI:setTag(Button_XiaoHuiClose, 8)
	GUI:setVisible(Button_XiaoHuiClose, false)

	-- Create FuWuJieMian
	local FuWuJieMian = GUI:Image_Create(Panel_1, "FuWuJieMian", 604.00, 120.00, "res/custom/bag/fuwubg.png")
	GUI:setChineseName(FuWuJieMian, "服务按钮界面")
	GUI:setAnchorPoint(FuWuJieMian, 0.00, 0.50)
	GUI:setTouchEnabled(FuWuJieMian, false)
	GUI:setTag(FuWuJieMian, -1)
	GUI:setVisible(FuWuJieMian, false)

	-- Create FuWuJieMian_HuoBiDuiHuan
	local FuWuJieMian_HuoBiDuiHuan = GUI:Button_Create(FuWuJieMian, "FuWuJieMian_HuoBiDuiHuan", 14.00, 141.00, "res/custom/bag/btn_huobiduihuan.png")
	GUI:Button_setTitleText(FuWuJieMian_HuoBiDuiHuan, "")
	GUI:Button_setTitleColor(FuWuJieMian_HuoBiDuiHuan, "#ffffff")
	GUI:Button_setTitleFontSize(FuWuJieMian_HuoBiDuiHuan, 14)
	GUI:Button_titleEnableOutline(FuWuJieMian_HuoBiDuiHuan, "#000000", 1)
	GUI:setChineseName(FuWuJieMian_HuoBiDuiHuan, "货币兑换")
	GUI:setTouchEnabled(FuWuJieMian_HuoBiDuiHuan, true)
	GUI:setTag(FuWuJieMian_HuoBiDuiHuan, -1)

	-- Create FuWuJieMian_WuPinXiaoHui
	local FuWuJieMian_WuPinXiaoHui = GUI:Button_Create(FuWuJieMian, "FuWuJieMian_WuPinXiaoHui", 14.00, 80.00, "res/custom/bag/btn_wupinxiaohyui.png")
	GUI:Button_setTitleText(FuWuJieMian_WuPinXiaoHui, "")
	GUI:Button_setTitleColor(FuWuJieMian_WuPinXiaoHui, "#ffffff")
	GUI:Button_setTitleFontSize(FuWuJieMian_WuPinXiaoHui, 14)
	GUI:Button_titleEnableOutline(FuWuJieMian_WuPinXiaoHui, "#000000", 1)
	GUI:setChineseName(FuWuJieMian_WuPinXiaoHui, "物品销毁")
	GUI:setTouchEnabled(FuWuJieMian_WuPinXiaoHui, true)
	GUI:setTag(FuWuJieMian_WuPinXiaoHui, -1)

	-- Create FuWuJieMian_PingBiXiaoXi
	local FuWuJieMian_PingBiXiaoXi = GUI:Button_Create(FuWuJieMian, "FuWuJieMian_PingBiXiaoXi", 14.00, 19.00, "res/custom/bag/btn_pingbixiaoxi.png")
	GUI:Button_setTitleText(FuWuJieMian_PingBiXiaoXi, "")
	GUI:Button_setTitleColor(FuWuJieMian_PingBiXiaoXi, "#ffffff")
	GUI:Button_setTitleFontSize(FuWuJieMian_PingBiXiaoXi, 14)
	GUI:Button_titleEnableOutline(FuWuJieMian_PingBiXiaoXi, "#000000", 1)
	GUI:setChineseName(FuWuJieMian_PingBiXiaoXi, "屏蔽消息")
	GUI:setTouchEnabled(FuWuJieMian_PingBiXiaoXi, true)
	GUI:setTag(FuWuJieMian_PingBiXiaoXi, -1)
end
return ui