local npc = {}
npc._config = teshudata["npc_13"]
local function _build_rate_tip_html()
    local lines = {}
    local maxLevel = tonumber(npc._config.max_level or 0) or 0
    for level = 1, maxLevel do
        local cfg = npc._config.config and npc._config.config[level] or nil
        local rate = tonumber(cfg and cfg.gl or 0) or 0
        lines[#lines + 1] = string.format("<font color='#ffffff'>第%s次赠礼：成功率 %s%%</font>", tostring(level), tostring(rate))
    end
    return table.concat(lines, "<br>")
end

local function _bind_common_tip(widget, tipText)
    if not widget or not tipText or tipText == "" then
        return
    end
    if SL:GetMetaValue("WINPLAYMODE") then
        GUI:addMouseMoveEvent(widget, {
            onEnterFunc = function()
                local pos = GUI:getWorldPosition(widget)
                SL:OpenCommonDescTipsPop({str = tipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
            end,
            onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end
        })
    else
        GUI:setTouchEnabled(widget, true)
        GUI:addOnTouchEvent(widget, function()
            local pos = GUI:getWorldPosition(widget)
            SL:OpenCommonDescTipsPop({str = tipText, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
        end)
    end
end

local function _get_percent_text(level)
    local maxLevel = tonumber(npc._config.max_level or 0) or 0
    local rewardPercent = tonumber(npc._config.reward_percent or 100) or 100
    level = tonumber(level or 0) or 0
    if npc.data and npc.data.percent ~= nil then
        return tostring(npc.data.percent) .. "%"
    end
    if maxLevel <= 0 then
        return "0%"
    end
    if level >= maxLevel then
        return tostring(rewardPercent) .. "%"
    end
    return tostring(math.floor(level * rewardPercent / maxLevel)) .. "%"
end
local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/13_bg.png", eff = true},
}
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
    local function UI_updata(node) --界面渲染
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local rateTipText = _build_rate_tip_html()
        -- local rateTipLabel = GUI:Text_Create(node, "rate_tip_label", 640, 357, 20, "#F6D27F", "概率公示")
        -- GUI:Text_setFontName(rateTipLabel, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(rateTipLabel, "#000000", 2)
        local rateTipIcon = GUI:Image_Create(node, "rate_tip_icon", 715, 357 - 300, "res/wy/public/xqh_tip.png")
        GUI:setAnchorPoint(rateTipIcon, 0.5, 0.5)
        -- _bind_common_tip(rateTipLabel, rateTipText)
        _bind_common_tip(rateTipIcon, rateTipText)
        if npc.data.dj_num < npc._config.max_level then
            local config = npc._config.config[npc.data.dj_num + 1]
            GUI:Text_setFontName(GUI:Text_Create(node, "desc1",500,351, 25, "#FB0000", _get_percent_text(npc.data.dj_num))
            , "fonts/font4.ttf")
            local desc2 = GUI:Text_Create(node, "desc2",490,305, 25, "#9DB9C8", "人物切割："..npc._config.config[npc.data.dj_num].ratio.." -》"..npc._config.config[npc.data.dj_num + 1].ratio)
            GUI:Text_setFontName(desc2, "fonts/501.ttf")
            GUI:Text_enableOutline(desc2, "#000000", 2)
            local cost_show = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 750 - 250, 120)
            if npc.data.dj_num < npc._config.max_level then
                GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",390,240, 30, "#FF0000", "好感度达到100%时：")
                , "fonts/font4.ttf")
                local kuang = GUI:Image_Create(node, "kuang10", 850 - 240 + 30, 220, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.final_give or npc._config.half_give)))
            end
             local Button= GUI:Button_Create(node, "Button2", 450, 20.00, "res/custom/one_city/btn_3.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, '')
            end)
            if checkItemNum(config.cost) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        else
            GUI:Text_setFontName(GUI:Text_Create(node, "desc1",490,353, 25, "#ffffff", _get_percent_text(npc.data.dj_num))
            , "fonts/font4.ttf")
            GUI:Text_setFontName(GUI:Text_Create(node, "desc2",490,305, 25, "#ffffff", "人物切割："..npc._config.config[npc.data.dj_num].ratio)
            , "fonts/font4.ttf")
            GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",400,250, 30, "#FF0000", "好感度已达最高等级")
            , "fonts/font4.ttf")
        end
    end
    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        local ret = msgData ~= "" and SL:JsonDecode(msgData,false) or {}
        npc.data.dj_num = ret.dj_num or (npc.data.dj_num + 1)
        npc.data.percent = ret.percent
        UI_updata(npc.node)
    end
end
return npc
