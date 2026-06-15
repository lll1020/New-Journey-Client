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
    local skin = string.format("res/custom/dlcs/%s/bg.png", tostring(idx))
    if SL and SL.IsFileExist and SL:IsFileExist(skin) then
        return skin
    end
    return "res/custom/dlcs/2/bg.png"
end
-- 根据大陆序号给出进入条件文案（与 GUIUtil 的大陆开放条件保持一致）
local function getEnterNeedText(dl)
    dl = _to_num(dl, 1)
    if dl <= 1 then
        return "无"
    elseif dl == 2 then
        return "跟随主线引导进入"
    elseif dl == 3 then
        return "跟随主线引导进入"
    elseif dl == 4 then
        return "三大陆剧情完成度85% + 三大陆转生 + 等级150"
    elseif dl == 5 then
        return "四大陆剧情完成度95% + 四大陆转生 + 激活全部灵根"
    elseif dl == 6 then
        return "五大陆剧情完成度95% + 五大陆转生 + 完成天道命盘"
    elseif dl == 7 then
        return "六大陆剧情完成度100% + 六大陆转生 + 世界符文·[真我]"
    elseif dl == 8 then
        return "完成七大陆转生"
    end
    return "请按主线推进"
end
local function canEnterByCfg(cfg)
    local dl = _to_num(cfg and cfg[6], 1)
    if type(dl_sz) == "function" then
        return dl_sz(dl) == true
    end
    return true
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
local function hasThirdContinentHalfEntry()
    local raw = Player and Player.getServerVar and Player:getServerVar("T13") or ""
    if not raw or raw == "" then
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
        npc.node = npc._window.node
        return npc.node
    end
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local cfg = npc._config and npc._config[npcid] or nil
        local needText = getEnterNeedText(cfg and cfg[6])
        local enterOK = canEnterByCfg(cfg)
        local bgSize = (npc.bg and GUI:getContentSize(npc.bg)) or {width = 798, height = 452}
        -- 条件面板
        local cond = GUI:Image_Create(node, "tj", 0, 148, "res/custom/dlcs/tj.png")
        GUI:setAnchorPoint(cond, 0, 0)
        local condSize = GUI:getContentSize(cond) or {width = 566, height = 82}
        GUI:setPosition(cond, math.floor((bgSize.width - condSize.width) / 2) + 50, 100)
        local stateColor = enterOK and "#00ff00" or "#ff3333"
        local stateText = enterOK and "（已解锁）" or "（未解锁）"
        local lockText = GUI:Text_Create(cond, "lock", condSize.width / 2, 14 + 15, 20, stateColor, needText .. stateText)
        GUI:Text_setFontName(lockText, "fonts/500.ttf")
        GUI:Text_enableOutline(lockText, "#000000", 2)
        GUI:setAnchorPoint(lockText, 0.5, 0.5)
        -- 进入按钮
        local button = GUI:Button_Create(node, "btn_enter", math.floor(bgSize.width / 2) + 50, 50, "res/custom/dlcs/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0.5)
        GUI:addOnClickEvent(button, function()
            if npcid == 503 then
                if not hasThirdContinentHalfEntry() then
                    NPC_UI_HELPER.guochang_3()
                    return
                end
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
