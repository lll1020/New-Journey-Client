local npc = {}

npc._config = teshudata["npc_658"]

local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/658_bg.png"},
    closeButton = {x = 747, y = 380},
}

local key = "npc_658"
local btn_pos = {600, 110}
local cost_pos = {507 + 25, 202 + 10}

local function closeAnswerPopup()
    local popup = npc.answerPopup
    npc.answerPopup = nil
    npc.answerPopupInput = nil
    if popup then
        pcall(function()
            GUI:removeFromParent(popup)
        end)
    end
end

local function getAnswerValue()
    if not npc.answerPopupInput then
        return nil
    end
    local value = tostring(GUI:TextInput_getString(npc.answerPopupInput) or "")
    value = string.gsub(value, "^%s*(.-)%s*$", "%1")
    if value == "" then
        SL:ShowSystemTips("请输入答案")
        return nil
    end
    return value
end

function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(npcid)
        local opts = {}
        for k, v in pairs(WINDOW_OPTS) do
            opts[k] = v
        end
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.node = npc._window.node
        return npc.node
    end

    local function openAnswerPopup()
        closeAnswerPopup()

        npc.answerPopup = GUI:Node_Create(npc.bg, "answer_popup", 0, 0)
        GUI:setLocalZOrder(npc.answerPopup, 100)

        local overlay = GUI:Image_Create(npc.answerPopup, "overlay", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(overlay, 0, 0)
        GUI:setContentSize(overlay, 818, 542)
        GUI:setIgnoreContentAdaptWithSize(overlay, false)
        GUI:setTouchEnabled(overlay, true)
        GUI:addOnClickEvent(overlay, closeAnswerPopup)

        local panel = GUI:Image_Create(npc.answerPopup, "panel", 409, 271, "res/wy/public/500-300.png")
        GUI:setAnchorPoint(panel, 0.5, 0.5)
        GUI:setContentSize(panel, 360, 220)
        GUI:setIgnoreContentAdaptWithSize(panel, false)
        GUI:setTouchEnabled(panel, true)

        local title = GUI:Text_Create(panel, "title", 180, 188, 22, "#F4D179", "输入答案")
        GUI:setAnchorPoint(title, 0.5, 0.5)
        GUI:Text_setFontName(title, "fonts/502.ttf")
        GUI:Text_enableOutline(title, "#CA352C", 2)

        local closeBtn = GUI:Button_Create(panel, "close", 332, 190, "res/wy/public/close_red_big.png")
        GUI:addOnClickEvent(closeBtn, closeAnswerPopup)

        local tip = GUI:Text_Create(panel, "tip", 180, 145, 18, "#F5E6C6", "请输入字谜答案后确认")
        GUI:setAnchorPoint(tip, 0.5, 0.5)
        GUI:Text_enableOutline(tip, "#6B4D2E", 1)

        local inputBg = GUI:Image_Create(panel, "input_bg", 70, 92, "res/public/1900000668.png")
        GUI:setContentSize(inputBg, 220, 36)
        GUI:setIgnoreContentAdaptWithSize(inputBg, false)

        local input = GUI:TextInput_Create(inputBg, "input", 10, 4, 200, 28, 18)
        GUI:TextInput_setInputMode(input, 6)
        GUI:TextInput_setMaxLength(input, 8)
        GUI:TextInput_setPlaceHolder(input, "请输入答案")
        GUI:TextInput_setFontColor(input, "#ffffff")
        npc.answerPopupInput = input

        local confirm = GUI:Button_Create(panel, "confirm", 180, 0, "res/wy/public/an_tongyong.png")
        GUI:setAnchorPoint(confirm, 0.5, 0)
        local confirmText = GUI:Text_Create(confirm, "confirm_text", 116, 52, 25, "#FFFBF0", "确定")
        GUI:setAnchorPoint(confirmText, 0.5, 0.5)
        GUI:Text_setFontName(confirmText, "fonts/502.ttf")
        GUI:Text_enableOutline(confirmText, "#CA352C", 2)
        GUI:addOnClickEvent(confirm, function()
            local msg = getAnswerValue()
            if msg == nil then
                return
            end
            closeAnswerPopup()
            SL:SendLuaNetMsg(100, npcid, 1, 0, msg)
        end)
    end

    local function UI_updata(node)
        if not node then
            return
        end

        closeAnswerPopup()
        GUI:removeAllChildren(node)
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        local jl = ItemNumByTable_img_new({npc._config.jl[1], {npc._config.ch .. "[称号]", 1}}, nil, GUI:Node_Create(node, "jl", 0, 0))
        GUI:setPosition(jl, 175, 110)

        if npc.data.T_dljq[key] == 0 then
            local Button = GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then
            local desc = GUI:Text_Create(node, "desc", 500, 180, 20, "#F4D179", "当前击杀：" .. (npc.data.sg_data[key] or 0))
            GUI:Text_setFontName(desc, "fonts/502.ttf")
            GUI:Text_enableOutline(desc, "#CA352C", 2)

            if (npc.data.sg_data[key] or 0) >= npc._config.num then
                local Button = GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/an_tongyong.png")
                local Button_wz = GUI:Text_Create(Button, "desc", 116, 52, 25, "#FFFBF0", "回答问题")
                GUI:setAnchorPoint(Button_wz, 0.5, 0.5)
                GUI:Text_setFontName(Button_wz, "fonts/502.ttf")
                GUI:Text_enableOutline(Button_wz, "#CA352C", 2)

                GUI:setAnchorPoint(Button, 0.5, 0.5)
                GUI:addOnClickEvent(Button, function()
                    openAnswerPopup()
                end)
            else
                GUI:Image_Create(node, "000", 190, 215, "res/wy/public/000.png")
                GUI:Image_Create(node, "0001", 300, 215, "res/wy/public/000.png")
            end
        elseif npc.data.T_dljq[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end
    end

    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.T_dljq[key] = p3
        UI_updata(npc.node)
    end
end

return npc



