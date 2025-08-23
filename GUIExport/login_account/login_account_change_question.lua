local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "修改密保场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Scene, "Panel_bg", 568.00, 320.00, 640.00, 475.00, false)
	GUI:setChineseName(Panel_bg, "修改密保_组合")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 241)

	-- Create Image_1
	local Image_1 = GUI:Image_Create(Panel_bg, "Image_1", 328.00, 233.00, "res/wy/public/login_6.png")
	GUI:setChineseName(Image_1, "修改密保_背景图")
	GUI:setAnchorPoint(Image_1, 0.50, 0.50)
	GUI:setTouchEnabled(Image_1, false)
	GUI:setTag(Image_1, 242)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_bg, "Button_close", 631.00, 425.00, "res/public/btn_normal_2.png")
	GUI:Button_setScale9Slice(Button_close, 7, 7, 11, 11)
	GUI:setContentSize(Button_close, 23, 30)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "修改密保_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 244)

	-- Create TextField_username
	local TextField_username = GUI:TextInput_Create(Panel_bg, "TextField_username", 264.00, 350.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_username, "")
	GUI:TextInput_setFontColor(TextField_username, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_username, 12)
	GUI:setChineseName(TextField_username, "修改密保_账号输入")
	GUI:setAnchorPoint(TextField_username, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_username, true)
	GUI:setTag(TextField_username, 257)

	-- Create TextField_password
	local TextField_password = GUI:TextInput_Create(Panel_bg, "TextField_password", 264.00, 302.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_password, "")
	GUI:TextInput_setFontColor(TextField_password, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_password, 12)
	GUI:setChineseName(TextField_password, "修改密保_密码输入")
	GUI:setAnchorPoint(TextField_password, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_password, true)
	GUI:setTag(TextField_password, 258)

	-- Create TextField_question
	local TextField_question = GUI:TextInput_Create(Panel_bg, "TextField_question", 264.00, 254.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_question, "")
	GUI:TextInput_setFontColor(TextField_question, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_question, 12)
	GUI:setChineseName(TextField_question, "修改密保_原密保输入")
	GUI:setAnchorPoint(TextField_question, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_question, true)
	GUI:setTag(TextField_question, 259)

	-- Create TextField_answer
	local TextField_answer = GUI:TextInput_Create(Panel_bg, "TextField_answer", 264.00, 206.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_answer, "")
	GUI:TextInput_setFontColor(TextField_answer, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_answer, 12)
	GUI:setChineseName(TextField_answer, "修改密保_原答案输入")
	GUI:setAnchorPoint(TextField_answer, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_answer, true)
	GUI:setTag(TextField_answer, 260)

	-- Create TextField_question_new
	local TextField_question_new = GUI:TextInput_Create(Panel_bg, "TextField_question_new", 264.00, 158.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_question_new, "")
	GUI:TextInput_setFontColor(TextField_question_new, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_question_new, 12)
	GUI:setChineseName(TextField_question_new, "修改密保_新密保输入")
	GUI:setAnchorPoint(TextField_question_new, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_question_new, true)
	GUI:setTag(TextField_question_new, 261)

	-- Create TextField_answer_new
	local TextField_answer_new = GUI:TextInput_Create(Panel_bg, "TextField_answer_new", 264.00, 110.00, 190.00, 30.00, 22)
	GUI:TextInput_setString(TextField_answer_new, "")
	GUI:TextInput_setFontColor(TextField_answer_new, "#ffffff")
	GUI:TextInput_setMaxLength(TextField_answer_new, 12)
	GUI:setChineseName(TextField_answer_new, "修改密保_新答案输入")
	GUI:setAnchorPoint(TextField_answer_new, 0.00, 0.50)
	GUI:setTouchEnabled(TextField_answer_new, true)
	GUI:setTag(TextField_answer_new, 262)

	-- Create Button_submit
	local Button_submit = GUI:Button_Create(Panel_bg, "Button_submit", 346.00, 59.00, "res/wy/public/login_12.png")
	GUI:Button_loadTexturePressed(Button_submit, "res/wy/public/login_13.png")
	GUI:Button_setScale9Slice(Button_submit, 39, 38, 14, 15)
	GUI:setContentSize(Button_submit, 116, 43)
	GUI:setIgnoreContentAdaptWithSize(Button_submit, false)
	GUI:Button_setTitleText(Button_submit, "")
	GUI:Button_setTitleColor(Button_submit, "#414146")
	GUI:Button_setTitleFontSize(Button_submit, 14)
	GUI:Button_titleDisableOutLine(Button_submit)
	GUI:setChineseName(Button_submit, "修改密保_提交_按钮")
	GUI:setAnchorPoint(Button_submit, 0.50, 0.50)
	GUI:setTouchEnabled(Button_submit, true)
	GUI:setTag(Button_submit, 263)
end
return ui