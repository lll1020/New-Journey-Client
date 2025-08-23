local ui = {}
function ui.init(parent)
	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(parent, "CloseLayout", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(CloseLayout, 1)
	GUI:Layout_setBackGroundColor(CloseLayout, "#000000")
	GUI:Layout_setBackGroundColorOpacity(CloseLayout, 150)
	GUI:setChineseName(CloseLayout, "商店框架_范围点击关闭")
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create FrameLayout
	local FrameLayout = GUI:Layout_Create(parent, "FrameLayout", 568.00, 384.00, 645.00, 460.00, false)
	GUI:setChineseName(FrameLayout, "商店框架_组合")
	GUI:setAnchorPoint(FrameLayout, 0.50, 0.50)
	GUI:setTouchEnabled(FrameLayout, true)
	GUI:setTag(FrameLayout, -1)

	-- Create FrameBG
	local FrameBG = GUI:Image_Create(FrameLayout, "FrameBG", 0.00, 0.00, "res/wy/public/guild_0.png")
	GUI:setChineseName(FrameBG, "商店框架_背景图")
	GUI:setTouchEnabled(FrameBG, false)
	GUI:setTag(FrameBG, -1)

	-- Create DressIMG
	local DressIMG = GUI:Image_Create(FrameLayout, "DressIMG", 17.00, 443.00, "res/public_win32/1900000610_1.png")
	GUI:setChineseName(DressIMG, "商店框架_装饰图")
	GUI:setAnchorPoint(DressIMG, 0.50, 0.50)
	GUI:setTouchEnabled(DressIMG, false)
	GUI:setTag(DressIMG, -1)
	GUI:setVisible(DressIMG, false)

	-- Create TitleText
	local TitleText = GUI:Text_Create(FrameLayout, "TitleText", 168.00, 435.00, 17, "#d8c8ae", [[123]])
	GUI:setChineseName(TitleText, "商店框架_标题_文本")
	GUI:setAnchorPoint(TitleText, 0.00, 0.50)
	GUI:setTouchEnabled(TitleText, false)
	GUI:setTag(TitleText, -1)
	GUI:Text_enableOutline(TitleText, "#000000", 2)

	-- Create AttachLayout
	local AttachLayout = GUI:Layout_Create(FrameLayout, "AttachLayout", 73.00, 18.00, 606.00, 390.00, false)
	GUI:setChineseName(AttachLayout, "商店框架_详细信息")
	GUI:setTouchEnabled(AttachLayout, false)
	GUI:setTag(AttachLayout, -1)

	-- Create CloseButton
	local CloseButton = GUI:Button_Create(FrameLayout, "CloseButton", 695.00, 433.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(CloseButton, "res/public/1900000511.png")
	GUI:Button_setTitleText(CloseButton, "")
	GUI:Button_setTitleColor(CloseButton, "#ffffff")
	GUI:Button_setTitleFontSize(CloseButton, 10)
	GUI:Button_titleEnableOutline(CloseButton, "#000000", 1)
	GUI:setChineseName(CloseButton, "商店框架_关闭_按钮")
	GUI:setAnchorPoint(CloseButton, 0.00, 0.50)
	GUI:setTouchEnabled(CloseButton, true)
	GUI:setTag(CloseButton, -1)

	-- Create page_cell_1
	local page_cell_1 = GUI:Button_Create(FrameLayout, "page_cell_1", 698.00, 354.00, "res/wy/public/guild_1.png")
	GUI:Button_loadTexturePressed(page_cell_1, "res/wy/public/guild_2.png")
	GUI:Button_loadTextureDisabled(page_cell_1, "res/wy/public/guild_2.png")
	GUI:setContentSize(page_cell_1, 35, 60)
	GUI:setIgnoreContentAdaptWithSize(page_cell_1, false)
	GUI:Button_setTitleText(page_cell_1, "")
	GUI:Button_setTitleColor(page_cell_1, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_1, 14)
	GUI:Button_titleDisableOutLine(page_cell_1)
	GUI:setChineseName(page_cell_1, "商店框架_热销组合")
	GUI:setTouchEnabled(page_cell_1, false)
	GUI:setTag(page_cell_1, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_1, "PageText", 15.00, 32.00, 15, "#807256", [[热
销]])
	GUI:setChineseName(PageText, "商店框架_热销_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_1, "TouchSize", 4.00, 58.00, 26.00, 55.00, false)
	GUI:setChineseName(TouchSize, "商店框架_热销_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_2
	local page_cell_2 = GUI:Button_Create(FrameLayout, "page_cell_2", 698.00, 294.00, "res/wy/public/guild_1.png")
	GUI:Button_loadTexturePressed(page_cell_2, "res/wy/public/guild_2.png")
	GUI:Button_loadTextureDisabled(page_cell_2, "res/wy/public/guild_2.png")
	GUI:setContentSize(page_cell_2, 35, 60)
	GUI:setIgnoreContentAdaptWithSize(page_cell_2, false)
	GUI:Button_setTitleText(page_cell_2, "")
	GUI:Button_setTitleColor(page_cell_2, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_2, 14)
	GUI:Button_titleDisableOutLine(page_cell_2)
	GUI:setChineseName(page_cell_2, "商店框架_补给组合")
	GUI:setTouchEnabled(page_cell_2, false)
	GUI:setTag(page_cell_2, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_2, "PageText", 15.00, 32.00, 15, "#807256", [[元
宝]])
	GUI:setChineseName(PageText, "商店框架_补给_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_2, "TouchSize", 4.00, 57.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "商店框架_补给_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_3
	local page_cell_3 = GUI:Button_Create(FrameLayout, "page_cell_3", 698.00, 234.00, "res/wy/public/guild_1.png")
	GUI:Button_loadTexturePressed(page_cell_3, "res/wy/public/guild_2.png")
	GUI:Button_loadTextureDisabled(page_cell_3, "res/wy/public/guild_2.png")
	GUI:setContentSize(page_cell_3, 35, 60)
	GUI:setIgnoreContentAdaptWithSize(page_cell_3, false)
	GUI:Button_setTitleText(page_cell_3, "")
	GUI:Button_setTitleColor(page_cell_3, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_3, 14)
	GUI:Button_titleEnableOutline(page_cell_3, "#000000", 1)
	GUI:setChineseName(page_cell_3, "商店框架_强化组合")
	GUI:setTouchEnabled(page_cell_3, false)
	GUI:setTag(page_cell_3, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_3, "PageText", 15.00, 32.00, 15, "#807256", [[灵
符]])
	GUI:setChineseName(PageText, "商店框架_强化_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_3, "TouchSize", 3.00, 58.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "商店框架_强化_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_4
	local page_cell_4 = GUI:Button_Create(FrameLayout, "page_cell_4", 698.00, 174.00, "res/wy/public/guild_1.png")
	GUI:Button_loadTexturePressed(page_cell_4, "res/wy/public/guild_2.png")
	GUI:Button_loadTextureDisabled(page_cell_4, "res/wy/public/guild_2.png")
	GUI:setContentSize(page_cell_4, 35, 60)
	GUI:setIgnoreContentAdaptWithSize(page_cell_4, false)
	GUI:Button_setTitleText(page_cell_4, "")
	GUI:Button_setTitleColor(page_cell_4, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_4, 14)
	GUI:Button_titleDisableOutLine(page_cell_4)
	GUI:setChineseName(page_cell_4, "商店框架_技能组合")
	GUI:setTouchEnabled(page_cell_4, false)
	GUI:setTag(page_cell_4, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_4, "PageText", 15.00, 32.00, 15, "#807256", [[技
能]])
	GUI:setChineseName(PageText, "商店框架_技能_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_4, "TouchSize", 4.00, 58.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "商店框架_技能_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)

	-- Create page_cell_5
	local page_cell_5 = GUI:Button_Create(FrameLayout, "page_cell_5", 698.00, 115.00, "res/wy/public/guild_1.png")
	GUI:Button_loadTexturePressed(page_cell_5, "res/wy/public/guild_2.png")
	GUI:Button_loadTextureDisabled(page_cell_5, "res/wy/public/guild_2.png")
	GUI:setContentSize(page_cell_5, 35, 60)
	GUI:setIgnoreContentAdaptWithSize(page_cell_5, false)
	GUI:Button_setTitleText(page_cell_5, "")
	GUI:Button_setTitleColor(page_cell_5, "#ffffff")
	GUI:Button_setTitleFontSize(page_cell_5, 14)
	GUI:Button_titleDisableOutLine(page_cell_5)
	GUI:setChineseName(page_cell_5, "商店框架_充值组合")
	GUI:setTouchEnabled(page_cell_5, false)
	GUI:setTag(page_cell_5, -1)

	-- Create PageText
	local PageText = GUI:Text_Create(page_cell_5, "PageText", 15.00, 32.00, 15, "#807256", [[充
值]])
	GUI:setChineseName(PageText, "商店框架_充值_文本")
	GUI:setAnchorPoint(PageText, 0.50, 0.50)
	GUI:setTouchEnabled(PageText, false)
	GUI:setTag(PageText, -1)
	GUI:Text_enableOutline(PageText, "#111111", 2)

	-- Create TouchSize
	local TouchSize = GUI:Layout_Create(page_cell_5, "TouchSize", 3.00, 58.00, 25.00, 55.00, false)
	GUI:setChineseName(TouchSize, "商店框架_充值_触摸")
	GUI:setAnchorPoint(TouchSize, 0.00, 1.00)
	GUI:setTouchEnabled(TouchSize, true)
	GUI:setTag(TouchSize, -1)
end
return ui