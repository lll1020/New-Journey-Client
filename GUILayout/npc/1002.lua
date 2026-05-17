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

local function _formatShapeName(name)
    name = tostring(name or "")
    return (string.gsub(name, "^(足迹：)(.+)$", "%1\n%2"):gsub("^(时装：)(.+)$", "%1\n%2"))
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
                    SL:SendLuaNetMsg(100, npc.npcid, 0, 0, "")
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
                SL:SendLuaNetMsg(101, 23, 1, nextIdx, "")
                state.visible = true
                GUI_createLabel(npc.Label,npc.titles_sign)
            end)
        else
            local lockedBtn = GUI:Image_Create(card, "activate_btn_" .. state.idx, 83, 0, "res/custom/one_city/shape/bz1.png")
            GUI:setAnchorPoint(lockedBtn, 0.5, 0.5)
            GUI:setTouchEnabled(lockedBtn, true)
            GUI:addOnClickEvent(lockedBtn, function()
                if state.canActivate then
                    SL:SendLuaNetMsg(101, 23, 1, state.idx, "")
                    
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
        if idx ~= 4 then
            GUI:Image_Create(Label_node, "wz1", 600 - 70, 20, "res/custom/one_city/shape/wz1.png")
        end


        if idx == 1 then
            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (216 * math.ceil(#npc._config.details.sz/3)))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (216 * math.ceil(#npc._config.details.sz/3)))
            for k,v in ipairs(npc._config.details.sz) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/one_city/shape/kuang1.png")

                -- GUI:Text_enableOutline(wz5, "#FFFFFF", 1)
                GUI:Effect_Create(kuang, "rw", 60, 60, 4, v.shape, 0, 0, 3, 1)
                if npc.data.T_data.dqzb == k then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "xz", 166/2, 30, "res/custom/one_city/shape/bz2.png")
                    , 0.5, 0.5)
                elseif npc.data.T_data.yjs[""..k] and npc.data.T_data.yjs[""..k] == 1 then
                    local btn = GUI:Button_Create(kuang, "btn", 166/2, 30, "res/custom/one_city/shape/btn.png")
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                    GUI:addOnClickEvent(btn, function()
                        SL:SendLuaNetMsg(100, npcid, 1, k, "")
                    end)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "wjs", 166/2, 30, "res/custom/one_city/shape/bz1.png")
                    , 0.5, 0.5)
                end
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnTouchEvent(kuang, function(self)
                    local pos = GUI:getWorldPosition(kuang)
                    SL:OpenItemTips({typeId = SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name), pos = {x = pos.x, y = pos.y}})
                end)
                local wz5 = GUI:Text_Create(kuang, "wz5",10, 185, 25, "#FF0000", _formatShapeName(v.name))
                GUI:setAnchorPoint(wz5, 0, 0.5)
                GUI:Text_setFontName(wz5, "fonts/502.ttf")
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=0, y=0}})

        elseif idx == 2 then
            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (216 * math.ceil(#npc._config.details.ch/2)))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (216 * math.ceil(#npc._config.details.ch/2)))
            for k,v in ipairs(npc._config.details.ch) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/one_city/shape/kuang2.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",256/2, 185, 25, "#FF0000", _formatShapeName(v.name))
                GUI:setAnchorPoint(wz5, 0.5, 0.5)
                GUI:Text_setFontName(wz5, "fonts/font4.ttf")
                GUI:Effect_Create(kuang, "rw", 120, 80, 0, v.sEffect, 0, 0, 3, 1)
                if SL:GetMetaValue("ACTIVATE_TITLE") == SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name) then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "xz", 256/2, 30, "res/custom/one_city/shape/bz2.png")
                    , 0.5, 0.5)
                elseif SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name)) then
                    local btn = GUI:Button_Create(kuang, "btn", 256/2, 30, "res/custom/one_city/shape/btn.png")
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                    GUI:addOnClickEvent(btn, function()
                        SL:ResquestActivateTitle(SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name))
                        GUI:Button_loadTextures(btn, "res/custom/one_city/shape/bz2.png")
                        GUI:Button_setBright(btn, true)
                    end)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "wjs", 256/2, 30, "res/custom/one_city/shape/bz1.png")
                    , 0.5, 0.5)
                end

            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 2,gap = {x=0, y=0}})
        elseif idx == 3 then
            local ScrollView = GUI:ScrollView_Create(Label_node, "ScrollView", 30, 12, 670, 370, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, 670, (216 * math.ceil(#npc._config.details.zj/3)))
            local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0,0, 670, (216 * math.ceil(#npc._config.details.zj/3)))
            for k,v in ipairs(npc._config.details.zj) do
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/one_city/shape/kuang1.png")
                local wz5 = GUI:Text_Create(kuang, "wz5",166/2, 185, 25, "#FF0000", _formatShapeName(v.name))
                GUI:setAnchorPoint(wz5, 0.5, 0.5)
                GUI:Text_setFontName(wz5, "fonts/font4.ttf")
                -- GUI:Text_enableOutline(wz5, "#FFFFFF", 1)
                GUI:Effect_Create(kuang, "zj", 60, 60, 0, v.sEffect, 0, 0, 3, 1)

                GUI:Effect_Create(kuang, "rw", 60, 60, 4, 0, 0, 0, 3, 1)
                if npc.data.T_data.dqzj == k then
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "xz", 166/2, 30, "res/custom/one_city/shape/bz2.png")
                    , 0.5, 0.5)
                elseif npc.data.T_data.yjszj[""..k] and npc.data.T_data.yjszj[""..k] == 1 then
                    local btn = GUI:Button_Create(kuang, "btn", 166/2, 30, "res/custom/one_city/shape/btn.png")
                    GUI:setAnchorPoint(btn, 0.5, 0.5)
                    GUI:addOnClickEvent(btn, function()
                        SL:SendLuaNetMsg(100, npcid, 2, k, "")
                    end)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(kuang, "wjs", 166/2, 30, "res/custom/one_city/shape/bz1.png")
                    , 0.5, 0.5)
                end
                GUI:setTouchEnabled(kuang, true)
                GUI:addOnTouchEvent(kuang, function(self)
                    local pos = GUI:getWorldPosition(kuang)
                    SL:OpenItemTips({typeId = SL:GetMetaValue("ITEM_INDEX_BY_NAME",v.name), pos = {x = pos.x, y = pos.y}})
                end)
            end
            GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 3,gap = {x=0, y=0}})

        elseif idx == 4 then
            renderBodyAuraTab(Label_node)
        end
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
