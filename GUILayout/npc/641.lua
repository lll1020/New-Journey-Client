local npc = {}

npc._config = teshudata["npc_641"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/641_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_641"
local btn_pos = {640, 110}
local cost_pos = {507 + 25, 202 + 10}

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
        for k,v in ipairs(npc._config.xz) do
            local box_node = GUI:Node_Create(list, "box_node"..k, 0, 0)
            if k%1 == 0 then
                GUI:setContentSize(GUI:Image_Create(box_node, "box", 0, -10, "res/custom/five_city/sgshz/box.png"), 590, 62)
            end
            if k > 0 then
                local config = teshudata["npc_"..v.idx]
                npc.data.T_dljq["npc_"..v.idx] = (npc.data.T_dljq and npc.data.T_dljq["npc_"..v.idx]) and npc.data.T_dljq["npc_"..v.idx] or 0
                GUI:Text_setFontName(GUI:Text_Create(box_node, "lv",15,10, 25, "#00FFFF", config.name), "fonts/501.ttf")     -- 
                GUI:Text_setFontName(GUI:Text_Create(box_node, "attr_desc",220,10, 25, "#FF00FF", v.wz), "fonts/501.ttf")
                GUI:Image_Create(box_node, "Button", 560 - 130, 0, "res/wy/public/"..(npc.data.T_dljq["npc_"..v.idx] >= 2 and "rwjd_3" or "rwjd_2")..".png")

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
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
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
