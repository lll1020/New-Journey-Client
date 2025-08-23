local ui = {}
function ui.init(parent)
	-- Create Panel_role
	local Panel_role = GUI:Layout_Create(parent, "Panel_role", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_role, "创建角色面板")
	GUI:setAnchorPoint(Panel_role, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_role, false)
	GUI:setTag(Panel_role, -1)

	-- Create Panel_anim
	local Panel_anim = GUI:Layout_Create(Panel_role, "Panel_anim", 568.00, 595.00, 350.00, 400.00, false)
	GUI:setChineseName(Panel_anim, "创建角色_模型展示")
	GUI:setAnchorPoint(Panel_anim, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_anim, false)
	GUI:setTag(Panel_anim, -1)

	-- Create Node_anim
	local Node_anim = GUI:Node_Create(Panel_anim, "Node_anim", 175.00, 0.00)
	GUI:setChineseName(Node_anim, "创建角色_模型节点")
	GUI:setTag(Node_anim, -1)

	-- Create Panel_info
	local Panel_info = GUI:Layout_Create(Panel_role, "Panel_info", 568.00, 595.00, 350.00, 420.00, false)
	GUI:setChineseName(Panel_info, "创建角色_详情组合")
	GUI:setAnchorPoint(Panel_info, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_info, false)
	GUI:setTag(Panel_info, -1)

	-- Create Image_2
	local Image_2 = GUI:Image_Create(Panel_info, "Image_2", 175.00, 210.00, "res/wy/public/login_207.png")
	GUI:setChineseName(Image_2, "创建角色_背景图")
	GUI:setAnchorPoint(Image_2, 0.50, 0.50)
	GUI:setTouchEnabled(Image_2, false)
	GUI:setTag(Image_2, -1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_info, "Button_close", 304.00, 384.00, "res/public/btn_normal_2.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/btn_pressed_2.png")
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#ffffff")
	GUI:Button_setTitleFontSize(Button_close, 10)
	GUI:Button_titleEnableOutline(Button_close, "#000000", 1)
	GUI:setChineseName(Button_close, "创建角色_关闭按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, -1)

	-- Create Image_7
	local Image_7 = GUI:Image_Create(Panel_info, "Image_7", 182.00, 365.00, "res/private/login/word_cjzy_01.png")
	GUI:setChineseName(Image_7, "创建角色_姓名文字_图片")
	GUI:setAnchorPoint(Image_7, 0.50, 0.50)
	GUI:setTouchEnabled(Image_7, false)
	GUI:setTag(Image_7, -1)

	-- Create TextInput_name
	local TextInput_name = GUI:TextInput_Create(Panel_info, "TextInput_name", 176.00, 329.00, 153.00, 28.00, 20)
	GUI:TextInput_setString(TextInput_name, "玩家名字")
	GUI:TextInput_setFontColor(TextInput_name, "#ffffff")
	GUI:TextInput_setMaxLength(TextInput_name, 7)
	GUI:setChineseName(TextInput_name, "创建角色_昵称输入")
	GUI:setAnchorPoint(TextInput_name, 0.50, 0.50)
	GUI:setTouchEnabled(TextInput_name, true)
	GUI:setTag(TextInput_name, -1)

	-- Create Button_rand
	local Button_rand = GUI:Button_Create(Panel_info, "Button_rand", 285.00, 328.00, "res/wy/public/login_208.png")
	GUI:Button_loadTexturePressed(Button_rand, "res/private/login/btn_cjzy_03_1.png")
	GUI:Button_setTitleText(Button_rand, "")
	GUI:Button_setTitleColor(Button_rand, "#ffffff")
	GUI:Button_setTitleFontSize(Button_rand, 10)
	GUI:Button_titleEnableOutline(Button_rand, "#000000", 1)
	GUI:setChineseName(Button_rand, "创建角色_筛子_按钮")
	GUI:setAnchorPoint(Button_rand, 0.50, 0.50)
	GUI:setTouchEnabled(Button_rand, true)
	GUI:setTag(Button_rand, -1)

	-- Create Button_job_1
	local Button_job_1 = GUI:Button_Create(Panel_info, "Button_job_1", 90.00, 210.00, "res/private/login/icon_cjzy_01.png")
	GUI:Button_loadTextureDisabled(Button_job_1, "res/private/login/icon_cjzy_01_1.png")
	GUI:Button_setTitleText(Button_job_1, "")
	GUI:Button_setTitleColor(Button_job_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_job_1, 10)
	GUI:Button_titleEnableOutline(Button_job_1, "#000000", 1)
	GUI:setChineseName(Button_job_1, "创建角色_职业_战士_按钮")
	GUI:setAnchorPoint(Button_job_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_job_1, true)
	GUI:setTag(Button_job_1, -1)
	GUI:setVisible(Button_job_1, false)

	-- Create Button_job_2
	local Button_job_2 = GUI:Button_Create(Panel_info, "Button_job_2", 136.00, 210.00, "res/private/login/icon_cjzy_02.png")
	GUI:Button_loadTextureDisabled(Button_job_2, "res/private/login/icon_cjzy_02_1.png")
	GUI:Button_setTitleText(Button_job_2, "")
	GUI:Button_setTitleColor(Button_job_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_job_2, 10)
	GUI:Button_titleEnableOutline(Button_job_2, "#000000", 1)
	GUI:setChineseName(Button_job_2, "创建角色_职业_法师_按钮")
	GUI:setAnchorPoint(Button_job_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_job_2, true)
	GUI:setTag(Button_job_2, -1)
	GUI:setVisible(Button_job_2, false)

	-- Create Button_job_3
	local Button_job_3 = GUI:Button_Create(Panel_info, "Button_job_3", 182.00, 210.00, "res/private/login/icon_cjzy_03.png")
	GUI:Button_loadTextureDisabled(Button_job_3, "res/private/login/icon_cjzy_03_1.png")
	GUI:Button_setTitleText(Button_job_3, "")
	GUI:Button_setTitleColor(Button_job_3, "#ffffff")
	GUI:Button_setTitleFontSize(Button_job_3, 10)
	GUI:Button_titleEnableOutline(Button_job_3, "#000000", 1)
	GUI:setChineseName(Button_job_3, "创建角色_职业_道士_按钮")
	GUI:setAnchorPoint(Button_job_3, 0.50, 0.50)
	GUI:setTouchEnabled(Button_job_3, true)
	GUI:setTag(Button_job_3, -1)
	GUI:setVisible(Button_job_3, false)

	-- Create Button_job_4
	local Button_job_4 = GUI:Button_Create(Panel_info, "Button_job_4", 229.00, 210.00, "res/private/login/icon_cjzy_04.png")
	GUI:Button_loadTexturePressed(Button_job_4, "res/private/login/icon_cjzy_04.png")
	GUI:Button_setTitleText(Button_job_4, "")
	GUI:Button_setTitleColor(Button_job_4, "#ffffff")
	GUI:Button_setTitleFontSize(Button_job_4, 10)
	GUI:Button_titleEnableOutline(Button_job_4, "#000000", 1)
	GUI:setChineseName(Button_job_4, "创建角色_职业_待定_按钮")
	GUI:setAnchorPoint(Button_job_4, 0.50, 0.50)
	GUI:setTouchEnabled(Button_job_4, true)
	GUI:setTag(Button_job_4, -1)
	GUI:setVisible(Button_job_4, false)

	-- Create Button_sex_1
	local Button_sex_1 = GUI:Button_Create(Panel_info, "Button_sex_1", 136.00, 105.00, "res/private/login/icon_cjzy_06.png")
	GUI:Button_loadTextureDisabled(Button_sex_1, "res/private/login/icon_cjzy_06_1.png")
	GUI:Button_setTitleText(Button_sex_1, "")
	GUI:Button_setTitleColor(Button_sex_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_sex_1, 10)
	GUI:Button_titleEnableOutline(Button_sex_1, "#000000", 1)
	GUI:setChineseName(Button_sex_1, "创建角色_性别_男_按钮")
	GUI:setAnchorPoint(Button_sex_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sex_1, true)
	GUI:setTag(Button_sex_1, -1)
	GUI:setVisible(Button_sex_1, false)

	-- Create Button_sex_2
	local Button_sex_2 = GUI:Button_Create(Panel_info, "Button_sex_2", 182.00, 105.00, "res/private/login/icon_cjzy_05.png")
	GUI:Button_loadTextureDisabled(Button_sex_2, "res/private/login/icon_cjzy_05_1.png")
	GUI:Button_setTitleText(Button_sex_2, "")
	GUI:Button_setTitleColor(Button_sex_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_sex_2, 10)
	GUI:Button_titleEnableOutline(Button_sex_2, "#000000", 1)
	GUI:setChineseName(Button_sex_2, "创建角色_性别_女_按钮")
	GUI:setAnchorPoint(Button_sex_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_sex_2, true)
	GUI:setTag(Button_sex_2, -1)
	GUI:setVisible(Button_sex_2, false)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_info, "Button_submit", 175.00, 49.00, "res/wy/public/login_12.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/wy/public/login_121.png")
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#ffffff")
	GUI:Button_setTitleFontSize(Button_submit, 0)
	GUI:Button_titleDisableOutLine(Button_submit)
	GUI:setChineseName(Button_submit, "创建角色_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, -1)
end
return ui