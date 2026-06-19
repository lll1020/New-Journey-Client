local npc = {}

npc._config = teshudata["npc_641"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/641_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_641"
local btn_pos = {640, 110}
local cost_pos = {507 + 25, 202 + 10}

local function createText(parent, name, x, y, size, color, text, ax, ay)
    local label = GUI:Text_Create(parent, name, x, y, size or 22, color or "#FFFFFF", text or "")
    GUI:Text_setFontName(label, "fonts/502.ttf")
    GUI:Text_enableOutline(label, "#111111", 2)
    if ax ~= nil and ay ~= nil then
        GUI:setAnchorPoint(label, ax, ay)
    end
    return label
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

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        local list = GUI:ListView_Create(node, "list", 150, 150, 700, 240,1)
        GUI:ListView_setItemsMargin(list, 54)
        GUI:ListView_setBounceEnabled(list, true)

        GUI:Image_Create(node, "fgx", 150, 150, "res/custom/all_story_mission/4/fgx.png")

        GUI:Node_Create(list, "box_node"..0, 0, 0)
        local nextOpenIndex = nil
        for i, cfg in ipairs(npc._config.xz or {}) do
            local stateKey = "npc_" .. tostring(cfg.idx)
            local state = npc.data.T_dljq and npc.data.T_dljq[stateKey] or 0
            if (tonumber(state) or 0) < 2 then
                nextOpenIndex = i
                break
            end
        end
        for k,v in ipairs(npc._config.xz) do
            local box_node = GUI:Node_Create(list, "box_node"..k, 0, 0)
            if k%1 == 0 then
                GUI:setContentSize(GUI:Image_Create(box_node, "box", 0, -10, "res/custom/five_city/sgshz/box.png"), 590, 62)
            end
            if k > 0 then
                local config = teshudata["npc_"..v.idx]
                npc.data.T_dljq["npc_"..v.idx] = (npc.data.T_dljq and npc.data.T_dljq["npc_"..v.idx]) and npc.data.T_dljq["npc_"..v.idx] or 0
                createText(box_node, "lv", 15, 10, 24, "#63F7FF", config.name)
                createText(box_node, "attr_desc", 220, 10, 24, "#FF78E8", v.wz)
                local state = tonumber(npc.data.T_dljq["npc_"..v.idx] or 0) or 0
                local stateSkin = "rwjd_1"
                if state >= 2 then
                    stateSkin = "rwjd_3"
                elseif nextOpenIndex == k then
                    stateSkin = "rwjd_2"
                end
                GUI:Image_Create(box_node, "Button", 560 - 130, 0, "res/wy/public/"..stateSkin..".png")

            end
        end

        local kuang = GUI:Image_Create(node, "kuang1", 255, 96, "res/wy/public/50-50.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.cost[1][1])))

        kuang = GUI:Image_Create(node, "kuang2", 460, 96, "res/wy/public/50-50.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0

        if npc.data.T_dljq[key] == 1 or npc.data.T_dljq[key] == 0 then
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            -- createText(Button, "btn_text", 112, 26, 26, "#FFD685", "领取奖励", 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
            -- createText(node, "finish_text", btn_pos[1], btn_pos[2], 24, "#B8FFB8", "已领取", 0.5, 0.5)
        end


    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.T_dljq[key] = p3
        UI_updata(npc.node)
    end
end

return npc
