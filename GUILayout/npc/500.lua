local npc = {}
npc._config = teshudata["sjdt"]
local function _to_num(v, defaultValue)
    local n = tonumber(v)
    if n == nil then
        return defaultValue or 0
    end
    return n
end
-- 读取大陆背景图：优先使用 npcid 对应目录（501->1, 502->2 ...）
-- 若资源不存在，则回退到 dlcs/2/bg.png，保证界面可正常打开。
local function getBgSkinByNpcid(npcid)
    local idx = _to_num(npcid, 0) - 500
    local skin = string.format("res/custom/dlcs/%s/eff_1.png", tostring(idx))
    if SL and SL.IsFileExist and SL:IsFileExist(skin) then
        return skin
    end
    return "res/custom/dlcs/2/bg.png"
end
local function getBgFramePathByNpcid(npcid)
    local idx = _to_num(npcid, 0) - 500
    local firstFrame = string.format("res/custom/dlcs/%s/eff_1.png", tostring(idx))
    if SL and SL.IsFileExist and SL:IsFileExist(firstFrame) then
        return string.format("res/custom/dlcs/%s/eff_", tostring(idx))
    end
    return "res/custom/dlcs/2/eff_"
end
local function _escape_rich_text(text)
    text = tostring(text or "")
    text = text:gsub("&", "&amp;")
    text = text:gsub("<", "&lt;")
    text = text:gsub(">", "&gt;")
    return text
end

local function _format_condition_segment(text, ok)
    local color = ok and "#00FF00" or "#FF3333"
    return string.format("<font color='%s'>%s</font>", color, _escape_rich_text(text))
end

local function _join_condition_segments(segments)
    if type(segments) ~= "table" or #segments < 1 then
        return "<font color='#F5E6C6'>请按主线推进</font>"
    end
    local out = {}
    for index, segment in ipairs(segments) do
        out[#out + 1] = _format_condition_segment(segment.text, segment.ok)
        if index < #segments then
            out[#out + 1] = "<font color='#F5E6C6'> + </font>"
        end
    end
    return table.concat(out, "")
end

local function _build_enter_condition_data(dl)
    if type(getContinentGateData) == "function" then
        local ok, gate = pcall(getContinentGateData, dl)
        if ok and type(gate) == "table" then
            return {
                richText = _join_condition_segments(gate.conditions),
                ok = gate.ok == true,
                tip = gate.tip,
            }
        end
    end
    return {
        richText = "<font color='#FF3333'>大陆条件数据暂不可用</font>",
        ok = false,
    }
end

local function getEnterNeedRichText(dl)
    return (_build_enter_condition_data(dl) or {}).richText or "<font color='#F5E6C6'>请按主线推进</font>"
end
local function canEnterByCfg(cfg)
    local dl = _to_num(cfg and cfg[6], 1)
    return (_build_enter_condition_data(dl) or {}).ok == true
end
local function _story_node_done(node)
    if node == nil then
        return false
    end
    if type(node) == "number" then
        return tonumber(node) >= 2
    end
    if type(node) == "table" then
        if tonumber(node[1] or node["1"] or 0) >= 2 then
            return true
        end
        if tonumber(node.wc or node.finish or node.done or node.ok or 0) >= 1 then
            return true
        end
        if tonumber(node.cnt or node.num or 0) >= 2 then
            return true
        end
    end
    return false
end

local function hasThirdContinentFullEntry()
    local raw = Player and Player.getServerVar and Player:getServerVar("T13") or ""
    if type(raw) ~= "string" or raw == "" then
        return false
    end
    local ok, storyData = pcall(function()
        return Player:JsonToTbl(raw)
    end)
    if not ok or type(storyData) ~= "table" then
        return false
    end
    return _story_node_done(storyData["npc_46"])
end

function npc.main(npcid, p2, p3, msgData)
    local function ensureWindow(npcid)
        local opts = {
            background = {skin = getBgSkinByNpcid(npcid)},
            closeButton = {x = 760 - 40, y = 420 - 70},
        }
        opts.titleText = NPC_UI_HELPER.formatNpcTitle(npcid, npc._config)
        opts.subTitle = npc._config and npc._config.title
        npc._window = NPC_UI_HELPER.ensureWindow(npc._window, npcid, opts)
        npc.bg = npc._window.bg
        npc.bg = GUI:Frames_Create(npc.bg, "dlcs_bg_eff", 0, 0, getBgFramePathByNpcid(npcid), ".png", 1, 150, {
            speed = 75,
            count = 150,
            loop = -1,
        })
        -- GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setLocalZOrder(npc._window.node, 99)
        npc.node = npc._window.node
        return npc.node
    end
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local cfg = npc._config and npc._config[npcid] or nil
        local needText = getEnterNeedRichText(cfg and cfg[6])
        local enterOK = canEnterByCfg(cfg)
        local bgSize = (npc.bg and GUI:getContentSize(npc.bg)) or {width = 798, height = 452}
        -- 条件面板
        local cond = GUI:Image_Create(node, "tj", 0, 148, "res/custom/dlcs/tj.png")
        GUI:setAnchorPoint(cond, 0, 0)
        local condSize = GUI:getContentSize(cond) or {width = 566, height = 82}
        GUI:setPosition(cond, math.floor((bgSize.width - condSize.width) / 2) + 50, 100)
        local lockText = GUI:RichText_Create(cond, "lock", condSize.width / 2, 14 + 15, needText, 1000, 20, "#FFFFFF", 1, nil, nil, {
            outlineSize = 2,
            outlineColor = SL:ConvertColorFromHexString("#000000"),
        })
        GUI:setAnchorPoint(lockText, 0.5, 0.5)
        -- 进入按钮
        local button = GUI:Button_Create(node, "btn_enter", math.floor(bgSize.width / 2) + 50, 50, "res/custom/dlcs/btn.png")
            GUI:setAnchorPoint(button, 0.5, 0.5)
            GUI:addOnClickEvent(button, function()
            if npcid == 503 and not hasThirdContinentFullEntry() then
                NPC_UI_HELPER.guochang_3()
                return
            end
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
    end
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end
return npc








