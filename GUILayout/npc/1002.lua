local npc = {}

npc._config = teshudata["npc_1002"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/shape/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/shape/title.png"},
}

local BODY_AURA_CARD_CFG = {
    [1] = {
        name = "攻击",
        effect = "每3刀额外造成1000伤害",
        need = "转生等级达到10级",
        lockedTip = "需要转生等级达到10级",
    },
    [2] = {
        name = "防御",
        effect = "每3刀额外造成888伤害",
        need = "领取首充礼包",
        lockedTip = "需要先领取首充礼包",
    },
    [3] = {
        name = "斩杀",
        effect = "每3刀额外造成1000伤害",
        need = "购买超级特权",
        lockedTip = "需要先激活超级特权",
    },
}

local BODY_AURA_EFFECT = {
    11501,
    11506,
    11505,
}

local function bindPressFeedback(target, onClick)
    if not target then
        return
    end
    GUI:setTouchEnabled(target, true)
    GUI:addOnTouchEvent(target, function(sender, touchType)
        if touchType == SLDefine.TouchEventType.began then
            GUI:setScale(sender, 0.96)
        elseif touchType == SLDefine.TouchEventType.ended then
            GUI:setScale(sender, 1)
            if onClick then
                onClick()
            end
        elseif touchType == SLDefine.TouchEventType.canceled then
            GUI:setScale(sender, 1)
        end
    end)
end

local function _formatShapeName(name)
    name = tostring(name or "")
    return (string.gsub(name, "^(足迹：)(.+)$", "%1\n%2"):gsub("^(时装：)(.+)$", "%1\n%2"))
end

local function _displayShapeName(name)
    name = tostring(name or "")
    return string.gsub(name, "^(足迹：|时装：)", "")
end
function npc.main(npcid, p2, p3, msgData)

    local function getBodyAuraData()
        local data = npc.data and npc.data.body_aura
        if type(data) ~= "table" then
            return {aura = {}, active = 0}
        end
        data.aura = type(data.aura) == "table" and data.aura or {}
        return data
    end

    local function getBodyAuraInfo(idx)
        local auraData = getBodyAuraData()
        local info = auraData.aura[idx] or auraData.aura[tostring(idx)]
        return type(info) == "table" and info or {}
    end

    local function getBodyAuraActiveIdx()
        local auraData = getBodyAuraData()
        local active = tonumber(auraData.active or 0) or 0
        if active >= 1 and active <= 3 then
            return active
        end
        for idx = 1, 3 do
            local info = getBodyAuraInfo(idx)
            if tonumber(info.active or 0) == 1 then
                return idx
            end
        end
        return 0
    end

    local function buildBodyAuraStates()
        local states = {}
        local activeIdx = getBodyAuraActiveIdx()
        for idx, cfg in ipairs(BODY_AURA_CARD_CFG) do
            local info = getBodyAuraInfo(idx)
            states[idx] = {
                idx = idx,
                name = cfg.name,
                effect = cfg.effect,
                need = cfg.need,
                lockedTip = cfg.lockedTip,
                canActivate = tonumber(info.open or 0) == 1,
                active = activeIdx == idx or tonumber(info.active or 0) == 1,
                visible = activeIdx == idx or tonumber(info.active or 0) == 1,
            }
        end
        return states
    end


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

    local function registerBodyAuraAutoRefresh()
        if npc._body_aura_refresh_registered then
            return
        end
        npc._body_aura_refresh_registered = true
        local function refreshBodyAuraTab()
            if npc._body_aura_refresh_pending then
                return
            end
            if not (npc.node and not tolua.isnull(npc.node) and npc.npcid and npc.titles_sign == 4) then
                return
            end
            npc._body_aura_refresh_pending = true
            SL:ScheduleOnce(function()
                npc._body_aura_refresh_pending = false
                if npc.node and not tolua.isnull(npc.node) and npc.npcid and npc.titles_sign == 4 then
                    SL:SendLuaNetMsg(100, npc.npcid, 3, -1, "")
                end
            end, 0)
        end
        SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "shape_body_aura_refresh_prop", refreshBodyAuraTab)
        SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "shape_body_aura_refresh_server", refreshBodyAuraTab)
        SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "shape_body_aura_refresh_buff", refreshBodyAuraTab)
    end

    local function setBodyAuraTextStyle(textObj, outlineColor)
        GUI:Text_setFontName(textObj, "fonts/502.ttf")
        GUI:Text_enableOutline(textObj, outlineColor or "#081800", 1)
        GUI:setAnchorPoint(textObj, 0.5, 0.5)
    end

    local function renderBodyAuraCard(parent, state, x, y)
        local card = GUI:Image_Create(parent, "huti_card_" .. state.idx, x, y, "res/custom/one_city/shape/kuang1.png")
        GUI:setAnchorPoint(card, 0, 0)
        GUI:setTouchEnabled(card, true)

        local equipData = SL:GetMetaValue("EQUIP_DATA", 0) or {}
        GUI:Effect_Create(card, "effect", 60, 60, 0, BODY_AURA_EFFECT[state.idx], 0, 0, 0, 0.85)
        GUI:Effect_Create(card, "role", 60, 60, 4, equipData.Shape or 1300, 0, 0, 3, 0.72)

        local nameText = GUI:Text_Create(card, "name_" .. state.idx, 83, 185, 25, "#FF0000", state.name or "")
        GUI:setAnchorPoint(nameText, 0.5, 0.5)
        GUI:Text_setFontName(nameText, "fonts/font4.ttf")

        -- local effectText = GUI:Text_Create(card, "effect_" .. state.idx, 83, 145, 14, "#FFF2BE", state.effect or "")
        -- GUI:setAnchorPoint(effectText, 0.5, 0.5)
        -- GUI:Text_setFontName(effectText, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(effectText, "#4B2403", 1)

        -- local needText = GUI:Text_Create(card, "need_" .. state.idx, 83, 124, 14, state.canActivate and "#7CFF7C" or "#FFB36A", state.canActivate and "已满足开启条件" or (state.need or ""))
        -- GUI:setAnchorPoint(needText, 0.5, 0.5)
        -- GUI:Text_setFontName(needText, "fonts/font4.ttf")
        -- GUI:Text_enableOutline(needText, "#4B2403", 1)

        if state.canActivate then
            local switchSkin = state.visible and "res/custom/one_city/shape/bz2.png" or "res/custom/one_city/shape/btn.png"
            local switchBtn = GUI:Button_Create(card, "switch_btn_" .. state.idx, 83, 0, switchSkin)
            GUI:setAnchorPoint(switchBtn, 0.5, 0.5)
            GUI:addOnClickEvent(switchBtn, function()
                local nextIdx = state.active and 0 or state.idx
                SL:SendLuaNetMsg(100, npcid, 3, nextIdx, "")
            end)
        else
            local lockedBtn = GUI:Image_Create(card, "activate_btn_" .. state.idx, 83, 0, "res/custom/one_city/shape/bz1.png")
            GUI:setAnchorPoint(lockedBtn, 0.5, 0.5)
            bindPressFeedback(lockedBtn, function()
                if state.canActivate then
                    SL:SendLuaNetMsg(100, npcid, 3, state.idx, "")
                    
                else
                    SL:ShowSystemTips(state.lockedTip or "当前条件未满足")
                end
            end)
        end
    end

    local function renderBodyAuraTab(Label_node)
        local states = buildBodyAuraStates()
        local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 670, 216)
        GUI:ScrollView_setBounceEnabled(ScrollView, true)
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0, 160, 670, 216)
        for idx = 1, 3 do
            renderBodyAuraCard(dbLayout, states[idx], 0, 0)
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=0, y=0}})
    end

    function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        if idx == 4 then
            renderBodyAuraTab(Label_node)
            return
        end

        local list = idx == 1 and npc._config.details.sz or (idx == 2 and npc._config.details.ch or npc._config.details.zj)
        local ownedMap = idx == 1 and npc.data.T_data.yjs or (idx == 2 and {} or npc.data.T_data.yjszj)
        local activeIndex = idx == 1 and tonumber(npc.data.T_data.dqzb or 0) or (idx == 3 and tonumber(npc.data.T_data.dqzj or 0) or 0)
        local activeTitle = idx == 2 and SL:GetMetaValue("ACTIVATE_TITLE") or nil
        npc._selectedShapeIndex = npc._selectedShapeIndex or {}

        local function itemId(entry)
            return SL:GetMetaValue("ITEM_INDEX_BY_NAME", entry.name)
        end

        local function isOwned(k, entry)
            if idx == 2 then
                return SL:GetMetaValue("TITLE_DATA_BY_ID", itemId(entry)) ~= nil
            end
            return tonumber(ownedMap["" .. k] or 0) == 1
        end

        local function isActive(k, entry)
            if idx == 2 then
                return activeTitle == itemId(entry)
            end
            return activeIndex == k
        end

        local function getActionType()
            return idx == 1 and "shape" or (idx == 2 and "title" or "footstep")
        end

        local previewNode = GUI:Node_Create(Label_node, "preview", 0, 0)
        local listNode = GUI:Node_Create(Label_node, "list", 0, 0)

        local function createPreview(parent, entry, x, y)
            if not entry then
                return
            end
            if idx == 1 then
                GUI:Effect_Create(parent, "current_shape", x, y, 4, entry.shape, 0, 0, 3, 0.86)
                GUI:setTouchEnabled(parent, true)
                GUI:addOnTouchEvent(parent, function(self)
                    local pos = GUI:getWorldPosition(parent)
                    SL:OpenItemTips({typeId = SL:GetMetaValue("ITEM_INDEX_BY_NAME",entry.name.."[展示]"), pos = {x = pos.x, y = pos.y}})
                end)
            elseif idx == 3 then
                GUI:Effect_Create(parent, "current_effect", x, y, 0, entry.sEffect, 0, 0, 3, 0.86)
                GUI:setTouchEnabled(parent, true)
                GUI:addOnTouchEvent(parent, function(self)
                    local pos = GUI:getWorldPosition(parent)
                    SL:OpenItemTips({typeId = SL:GetMetaValue("ITEM_INDEX_BY_NAME",entry.name.."[展示]"), pos = {x = pos.x, y = pos.y}})
                end)
            else
                GUI:Effect_Create(parent, "current_effect", x + 15, y, 0, entry.sEffect, 0, 0, 3, 0.86)
            end
        end

        local currentIndex = tonumber(npc._selectedShapeIndex[idx] or 0) or 0
        if currentIndex < 1 or currentIndex > #list then
            currentIndex = activeIndex
        end
        if idx == 2 and currentIndex == 0 then
            for k, entry in ipairs(list) do
                if isActive(k, entry) then
                    currentIndex = k
                    break
                end
            end
        end
        if currentIndex < 1 or currentIndex > #list then
            currentIndex = #list > 0 and 1 or 0
        end
        npc._selectedShapeIndex[idx] = currentIndex
        local function renderPreview(selectedIndex)
            GUI:removeAllChildren(previewNode)
            local currentEntry = list[selectedIndex]
            local currentOwned = currentEntry and isOwned(selectedIndex, currentEntry)
            local currentActive = currentEntry and isActive(selectedIndex, currentEntry)

            local currentTitle = GUI:Text_Create(previewNode, "current_title", 82 + 33, 386 - 60, 20, "#F5EAD3", "装扮预览")
            GUI:setAnchorPoint(currentTitle, 0.5, 0.5)
            GUI:Text_setFontName(currentTitle, "fonts/font4.ttf")
            GUI:Text_enableOutline(currentTitle, "#18110C", 2)
            local currentFrame = GUI:Image_Create(previewNode, "current_frame", 82 + 33, 252 - 60, "res/custom/one_city/shape/kuang1.png")
            GUI:setAnchorPoint(currentFrame, 0.5, 0.5)
            if currentEntry then
                createPreview(currentFrame, currentEntry, 82 - 16, 97 - 29)
                local currentColor = currentActive and "#FFE66B" or (currentOwned and "#70FF6A" or "#A9A9A9")
                local currentName = GUI:Text_Create(previewNode, "current_name", 82 + 33, 130 - 60, 17, currentColor, _displayShapeName(currentEntry.name))
                GUI:setAnchorPoint(currentName, 0.5, 0.5)
                GUI:Text_setFontName(currentName, "fonts/font4.ttf")
                GUI:Text_enableOutline(currentName, "#081800", 2)
                if currentActive then
                    local currentState = GUI:Image_Create(previewNode, "current_state", 82 + 33, 73 - 40, "res/custom/three_city/xianfu/zhuangshi/new.png")
                    GUI:setAnchorPoint(currentState, 0.5, 0.5)
                elseif currentOwned then
                    local equipButton = GUI:Button_Create(previewNode, "current_equip", 82 + 33, 73 - 40, "res/custom/three_city/xianfu/zhuangshi/btn.png")
                    GUI:setAnchorPoint(equipButton, 0.5, 0.5)
                    bindPressFeedback(equipButton, function()
                        local actionType = getActionType()
                        if actionType == "shape" then
                            SL:SendLuaNetMsg(100, npcid, 1, selectedIndex, "")
                        elseif actionType == "title" then
                            SL:ResquestActivateTitle(itemId(currentEntry))
                        else
                            SL:SendLuaNetMsg(100, npcid, 2, selectedIndex, "")
                        end
                    end)
                else
                    local notOwned = GUI:Text_Create(previewNode, "current_not_owned", 82 + 33, 73 - 60, 16, "#A9A9A9", "尚未拥有")
                    GUI:setAnchorPoint(notOwned, 0.5, 0.5)
                    GUI:Text_setFontName(notOwned, "fonts/font4.ttf")
                    GUI:Text_enableOutline(notOwned, "#18110C", 1)
                end
            else
                local empty = GUI:Text_Create(previewNode, "current_empty", 82 + 33, 252 - 60, 17, "#B7B7B7", "暂无装扮")
                GUI:setAnchorPoint(empty, 0.5, 0.5)
                GUI:Text_setFontName(empty, "fonts/font4.ttf")
                GUI:Text_enableOutline(empty, "#18110C", 1)
            end
        end

        renderPreview(currentIndex)

        local columns = 2
        local rows = math.max(1, math.ceil(#list / columns))
        local ScrollView = GUI:ScrollView_Create(listNode, "ScrollView", 185 + 40, 0, 405, 402 - 20, 1)
        GUI:ScrollView_setBounceEnabled(ScrollView, true)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 350, rows * (22 + 216))
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0, 0, 350, rows * (22 + 216))

        for k, v in ipairs(list) do
            local owned = isOwned(k, v)
            local selected = currentIndex == k
            local kuang = GUI:Image_Create(dbLayout, "kuang" .. k, 0, 0, "res/custom/one_city/shape/kuang1.png")
            if idx == 1 then
                GUI:Effect_Create(kuang, "shape", 166/2 - 28, 82 - 13, 4, v.shape, 0, 0, 3, 0.72)
            else
                GUI:Effect_Create(kuang, "effect", 166/2, 82, 0, v.sEffect, 0, 0, 3, 0.72)
            end

            local nameColor = selected and "#FFE66B" or (owned and "#70FF6A" or "#8A8A8A")
            local nameText = GUI:Text_Create(kuang, "name", 166/2, 139 + 54, 14, nameColor, _displayShapeName(v.name))
            GUI:setAnchorPoint(nameText, 0.5, 0.5)
            GUI:Text_setFontName(nameText, "fonts/font4.ttf")
            GUI:Text_enableOutline(nameText, "#081800", 1)

            bindPressFeedback(kuang, function()
                npc._selectedShapeIndex[idx] = k
                renderPreview(k)
            end)
        end

        GUI:UserUILayout(dbLayout, {dir = 3, addDir = 1, colnum = columns, gap = {x = 22, y = 22}})
    end

    local function UI_updata(node) --鐣岄潰娓叉煋
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = tonumber(npc.titles_sign) or 1
        if npc.titles_sign < 1 or npc.titles_sign > 4 then
            npc.titles_sign = 1
        end
        for i = 1, 4 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/one_city/shape/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/shape/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/shape/list/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)

    end


    if p2 == 0 then--鐣岄潰
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.dqzb = npc.data.T_data.dqzb or 0
        npc.data.T_data.dqzj = npc.data.T_data.dqzj or 0
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        npc.data.T_data.yjszj = npc.data.T_data.yjszj or {}
        npc.data.body_aura = type(npc.data.body_aura) == "table" and npc.data.body_aura or {aura = {}, active = 0}
        npc.npcid = npcid
        registerBodyAuraAutoRefresh()
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--鐣岄潰
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.dqzb = npc.data.T_data.dqzb or 0
        npc.data.T_data.dqzj = npc.data.T_data.dqzj or 0
        npc.data.T_data.yjs = npc.data.T_data.yjs or {}
        npc.data.T_data.yjszj = npc.data.T_data.yjszj or {}
        npc.data.body_aura = type(npc.data.body_aura) == "table" and npc.data.body_aura or {aura = {}, active = 0}
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc
