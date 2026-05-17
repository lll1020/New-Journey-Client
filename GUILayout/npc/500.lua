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

local function canEnterByCfg(cfg)
    local dl = _to_num(cfg and cfg[6], 1)
    if type(dl_sz) == "function" then
        if dl <= 5 then
            return dl_sz(dl) == true
        end
    end
    if dl >= 6 and dl <= 8 then
        local rebirthLevel = _to_num(SL:GetMetaValue("RELEVEL"), 0)
        return rebirthLevel >= (dl - 1) * 10
    end
    return true
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
        local enterOK = canEnterByCfg(cfg)
        local bgSize = (npc.bg and GUI:getContentSize(npc.bg)) or {width = 798, height = 452}
        -- 传送入口不再展示底部进入条件文案，只保留按钮本身与锁定状态表现。
        local effect = GUI:Image_Create(node, "enter_effect", math.floor(bgSize.width / 2) + 50, 136, "res/custom/dlcs/tj.png")
        GUI:setAnchorPoint(effect, 0.5, 0.5)
        GUI:setOpacity(effect, enterOK and 180 or 120)
        GUI:runAction(effect, GUI:ActionRepeatForever(GUI:ActionSequence(
            GUI:ActionScaleTo(0.9, 1.03),
            GUI:ActionScaleTo(0.9, 0.98)
        )))
        -- 进入按钮
        local button = GUI:Button_Create(node, "btn_enter", math.floor(bgSize.width / 2) + 50, 50, "res/custom/dlcs/btn.png")
        GUI:setAnchorPoint(button, 0.5, 0.5)
        if not enterOK then
            GUI:setGrey(button, true)
        end
        GUI:addOnClickEvent(button, function()
            if not enterOK then
                return
            end
            if npcid == 503 then
                if not _ywl_has_third_continent_half_entry() then
                    NPC_UI_HELPER.guochang_3()
                    return
                end
            end
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
        local stateText = GUI:Text_Create(node, "lock_state", math.floor(bgSize.width / 2) + 50, 138, 22, enterOK and "#FFF1CC" or "#D0D0D0", enterOK and "点击进入" or "暂未解锁")
        GUI:Text_setFontName(stateText, "fonts/500.ttf")
        GUI:Text_enableOutline(stateText, "#000000", 2)
        GUI:setAnchorPoint(stateText, 0.5, 0.5)
    end
    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData, false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end
return npc
