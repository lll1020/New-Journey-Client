local ui = {}

function ui.init(parent)
	-- Create Panel_touch
	local Panel_touch = GUI:Layout_Create(parent, "Panel_touch", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_touch, "触摸层")
	GUI:setTouchEnabled(Panel_touch, true)
	GUI:setTag(Panel_touch, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(parent, "Panel_bg", 568.00, 320.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_bg, "创建角色_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, -1)

	-- Create Image_server_bg
	local Image_server_bg = GUI:Image_Create(Panel_bg, "Image_server_bg", 568.00, 667.00, "res/wy/public/login_main.png")
	GUI:setChineseName(Image_server_bg, "创建角色_区服背景图")
	GUI:setAnchorPoint(Image_server_bg, 0.50, 1.00)
	GUI:setTouchEnabled(Image_server_bg, false)
	GUI:setTag(Image_server_bg, -1)

	-- Create zc_dl
	local zc_dl = GUI:Image_Create(Image_server_bg, "zc_dl", 49.00, 308.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(zc_dl, 0, 0)
	GUI:setIgnoreContentAdaptWithSize(zc_dl, false)
	GUI:setTouchEnabled(zc_dl, false)
	GUI:setTag(zc_dl, -1)

	-- Create yc_dl
	local yc_dl = GUI:Image_Create(Image_server_bg, "yc_dl", 767.00, 308.00, "res/private/gui_edit/ImageFile.png")
	GUI:setContentSize(yc_dl, 0, 0)
	GUI:setIgnoreContentAdaptWithSize(yc_dl, false)
	GUI:setTouchEnabled(yc_dl, false)
	GUI:setTag(yc_dl, -1)

	-- Create Text_server_name
	local Text_server_name = GUI:Text_Create(Panel_bg, "Text_server_name", 569.00, 554.00, 15, "#ffffff", [[服务器名]])
	GUI:setChineseName(Text_server_name, "创建角色_区服名称_文本")
	GUI:setAnchorPoint(Text_server_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_server_name, false)
	GUI:setTag(Text_server_name, -1)
	GUI:Text_enableOutline(Text_server_name, "#000000", 1)

	-- Create Panel_role_1
	local Panel_role_1 = GUI:Layout_Create(Panel_bg, "Panel_role_1", 595.00, 650.00, 350.00, 400.00, false)
	GUI:setChineseName(Panel_role_1, "创建角色_角色框1_组合")
	GUI:setAnchorPoint(Panel_role_1, 1.00, 1.00)
	GUI:setTouchEnabled(Panel_role_1, true)
	GUI:setTag(Panel_role_1, -1)

	-- Create Node_anim_1
	local Node_anim_1 = GUI:Node_Create(Panel_role_1, "Node_anim_1", 143.00, 2.00)
	GUI:setChineseName(Node_anim_1, "创建角色_角色1_节点")
	GUI:setTag(Node_anim_1, -1)

	-- Create Panel_role_2
	local Panel_role_2 = GUI:Layout_Create(Panel_bg, "Panel_role_2", 503.00, 631.00, 350.00, 400.00, false)
	GUI:setChineseName(Panel_role_2, "创建角色_角色框2_组合")
	GUI:setAnchorPoint(Panel_role_2, 0.00, 1.00)
	GUI:setTouchEnabled(Panel_role_2, true)
	GUI:setTag(Panel_role_2, -1)

	-- Create Node_anim_2
	local Node_anim_2 = GUI:Node_Create(Panel_role_2, "Node_anim_2", 205.00, 21.00)
	GUI:setChineseName(Node_anim_2, "创建角色_角色2_节点")
	GUI:setTag(Node_anim_2, -1)

	-- Create Panel_info_1
	local Panel_info_1 = GUI:Layout_Create(Panel_bg, "Panel_info_1", 278.00, 0.00, 210.00, 200.00, false)
	GUI:setChineseName(Panel_info_1, "角色信息1_组合")
	GUI:setAnchorPoint(Panel_info_1, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_info_1, false)
	GUI:setTag(Panel_info_1, -1)

	-- Create Button_select_1
	local Button_select_1 = GUI:Button_Create(Panel_info_1, "Button_select_1", 235.00, 181.00, "res/wy/public/login_120.png")
	GUI:setContentSize(Button_select_1, 90, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_select_1, false)
	GUI:Button_setTitleText(Button_select_1, "")
	GUI:Button_setTitleColor(Button_select_1, "#ffffff")
	GUI:Button_setTitleFontSize(Button_select_1, 0)
	GUI:Button_titleDisableOutLine(Button_select_1)
	GUI:Win_SetParam(Button_select_1, {grey = 1}, "Button")
	GUI:setChineseName(Button_select_1, "角色信息_选择_按钮")
	GUI:setAnchorPoint(Button_select_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_select_1, true)
	GUI:setTag(Button_select_1, -1)

	-- Create Text_name_1
	local Text_name_1 = GUI:Text_Create(Panel_info_1, "Text_name_1", 96.00, 133.00, 16, "#ffffff", [[传奇经典]])
	GUI:setChineseName(Text_name_1, "角色信息_玩家昵称_文本")
	GUI:setAnchorPoint(Text_name_1, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_1, false)
	GUI:setTag(Text_name_1, -1)
	GUI:Text_enableOutline(Text_name_1, "#000000", 1)

	-- Create Text_level_1
	local Text_level_1 = GUI:Text_Create(Panel_info_1, "Text_level_1", 84.00, 104.00, 16, "#ffffff", [[9级]])
	GUI:setChineseName(Text_level_1, "角色信息_玩家等级_文本")
	GUI:setAnchorPoint(Text_level_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level_1, false)
	GUI:setTag(Text_level_1, -1)
	GUI:Text_enableOutline(Text_level_1, "#000000", 1)

	-- Create Text_job_1
	local Text_job_1 = GUI:Text_Create(Panel_info_1, "Text_job_1", 84.00, 72.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Text_job_1, "角色信息_玩家职业_文本")
	GUI:setAnchorPoint(Text_job_1, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job_1, false)
	GUI:setTag(Text_job_1, -1)
	GUI:Text_enableOutline(Text_job_1, "#000000", 1)

	-- Create Panel_info_2
	local Panel_info_2 = GUI:Layout_Create(Panel_bg, "Panel_info_2", 855.00, 0.00, 210.00, 200.00, false)
	GUI:setChineseName(Panel_info_2, "角色信息2_组合")
	GUI:setAnchorPoint(Panel_info_2, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_info_2, false)
	GUI:setTag(Panel_info_2, -1)

	-- Create Button_select_2
	local Button_select_2 = GUI:Button_Create(Panel_info_2, "Button_select_2", -21.00, 181.00, "res/wy/public/login_120.png")
	GUI:setContentSize(Button_select_2, 90, 35)
	GUI:setIgnoreContentAdaptWithSize(Button_select_2, false)
	GUI:Button_setTitleText(Button_select_2, "")
	GUI:Button_setTitleColor(Button_select_2, "#ffffff")
	GUI:Button_setTitleFontSize(Button_select_2, 0)
	GUI:Button_titleDisableOutLine(Button_select_2)
	GUI:Win_SetParam(Button_select_2, {grey = 1}, "Button")
	GUI:setChineseName(Button_select_2, "角色信息_选择_按钮")
	GUI:setAnchorPoint(Button_select_2, 0.50, 0.50)
	GUI:setTouchEnabled(Button_select_2, true)
	GUI:setTag(Button_select_2, -1)

	-- Create Text_name_2
	local Text_name_2 = GUI:Text_Create(Panel_info_2, "Text_name_2", 165.00, 133.00, 16, "#ffffff", [[传奇经典]])
	GUI:setChineseName(Text_name_2, "角色信息_玩家昵称_文本")
	GUI:setAnchorPoint(Text_name_2, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name_2, false)
	GUI:setTag(Text_name_2, -1)
	GUI:Text_enableOutline(Text_name_2, "#000000", 1)

	-- Create Text_level_2
	local Text_level_2 = GUI:Text_Create(Panel_info_2, "Text_level_2", 153.00, 104.00, 16, "#ffffff", [[9级]])
	GUI:setChineseName(Text_level_2, "角色信息_玩家等级_文本")
	GUI:setAnchorPoint(Text_level_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_level_2, false)
	GUI:setTag(Text_level_2, -1)
	GUI:Text_enableOutline(Text_level_2, "#000000", 1)

	-- Create Text_job_2
	local Text_job_2 = GUI:Text_Create(Panel_info_2, "Text_job_2", 154.00, 72.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Text_job_2, "角色信息_玩家职业_文本")
	GUI:setAnchorPoint(Text_job_2, 0.00, 0.50)
	GUI:setTouchEnabled(Text_job_2, false)
	GUI:setTag(Text_job_2, -1)
	GUI:Text_enableOutline(Text_job_2, "#000000", 1)

	-- Create Panel_act
	local Panel_act = GUI:Layout_Create(Panel_bg, "Panel_act", 564.00, 19.00, 350.00, 200.00, false)
	GUI:setChineseName(Panel_act, "角色操作_组合框")
	GUI:setAnchorPoint(Panel_act, 0.50, 0.00)
	GUI:setTouchEnabled(Panel_act, false)
	GUI:setTag(Panel_act, -1)

	-- Create Button_start
	local Button_start = GUI:Button_Create(Panel_act, "Button_start", 181.00, 130.00, "res/wy/public/login_203.png")
	GUI:setContentSize(Button_start, 150, 60)
	GUI:setIgnoreContentAdaptWithSize(Button_start, false)
	GUI:Button_setTitleText(Button_start, "")
	GUI:Button_setTitleColor(Button_start, "#ffffff")
	GUI:Button_setTitleFontSize(Button_start, 0)
	GUI:Button_titleDisableOutLine(Button_start)
	GUI:Win_SetParam(Button_start, {grey = 1}, "Button")
	GUI:setChineseName(Button_start, "角色操作_开始_按钮")
	GUI:setAnchorPoint(Button_start, 0.50, 0.50)
	GUI:setTouchEnabled(Button_start, true)
	GUI:setTag(Button_start, -1)

	-- Create Button_leave
	local Button_leave = GUI:Button_Create(Panel_act, "Button_leave", 243.00, 84.00, "res/wy/public/login_201.png")
	GUI:setContentSize(Button_leave, 80, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_leave, false)
	GUI:Button_setTitleText(Button_leave, "")
	GUI:Button_setTitleColor(Button_leave, "#ffffff")
	GUI:Button_setTitleFontSize(Button_leave, 0)
	GUI:Button_titleDisableOutLine(Button_leave)
	GUI:Win_SetParam(Button_leave, {grey = 1}, "Button")
	GUI:setChineseName(Button_leave, "角色操作_返回_按钮")
	GUI:setAnchorPoint(Button_leave, 0.50, 0.50)
	GUI:setTouchEnabled(Button_leave, true)
	GUI:setTag(Button_leave, -1)

	-- Create Button_create
	local Button_create = GUI:Button_Create(Panel_act, "Button_create", 110.00, 84.00, "res/wy/public/login_200.png")
	GUI:setContentSize(Button_create, 80, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_create, false)
	GUI:Button_setTitleText(Button_create, "")
	GUI:Button_setTitleColor(Button_create, "#ffffff")
	GUI:Button_setTitleFontSize(Button_create, 0)
	GUI:Button_titleDisableOutLine(Button_create)
	GUI:Win_SetParam(Button_create, {grey = 1}, "Button")
	GUI:setChineseName(Button_create, "角色操作_创建_按钮")
	GUI:setAnchorPoint(Button_create, 0.50, 0.50)
	GUI:setTouchEnabled(Button_create, true)
	GUI:setTag(Button_create, -1)

	-- Create Button_delete
	local Button_delete = GUI:Button_Create(Panel_act, "Button_delete", 243.00, 33.00, "res/wy/public/login_204.png")
	GUI:setContentSize(Button_delete, 80, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_delete, false)
	GUI:Button_setTitleText(Button_delete, "")
	GUI:Button_setTitleColor(Button_delete, "#ffffff")
	GUI:Button_setTitleFontSize(Button_delete, 0)
	GUI:Button_titleDisableOutLine(Button_delete)
	GUI:Win_SetParam(Button_delete, {grey = 1}, "Button")
	GUI:setChineseName(Button_delete, "角色操作_删除_按钮")
	GUI:setAnchorPoint(Button_delete, 0.50, 0.50)
	GUI:setTouchEnabled(Button_delete, true)
	GUI:setTag(Button_delete, -1)

	-- Create Button_restore
	local Button_restore = GUI:Button_Create(Panel_act, "Button_restore", 110.00, 33.00, "res/wy/public/login_202.png")
	GUI:setContentSize(Button_restore, 80, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_restore, false)
	GUI:Button_setTitleText(Button_restore, "")
	GUI:Button_setTitleColor(Button_restore, "#ffffff")
	GUI:Button_setTitleFontSize(Button_restore, 0)
	GUI:Button_titleDisableOutLine(Button_restore)
	GUI:Win_SetParam(Button_restore, {grey = 1}, "Button")
	GUI:setChineseName(Button_restore, "角色操作_恢复_按钮")
	GUI:setAnchorPoint(Button_restore, 0.50, 0.50)
	GUI:setTouchEnabled(Button_restore, true)
	GUI:setTag(Button_restore, -1)
end

return ui