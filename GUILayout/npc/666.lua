local npc = {}

npc._config = teshudata["npc_666"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/4/666_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_666"
local btn_pos = {600, 110}
local cost_pos = {507 + 30 - 270, 202 + 15}

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
        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240 + 320 - 410 + 235 - 191, 93, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))
        npc.data.jq_data[key] = (npc.data.jq_data and npc.data.jq_data[key]) and npc.data.jq_data[key] or 0

        if npc._config.cost then
            local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
            GUI:setPosition(cost, cost_pos[1], cost_pos[2])
        end

        

        if npc.data.jq_data[key] == 0 then --接取任务
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.jq_data[key] == 1 then --领取奖励
            local desc = GUI:Text_Create(node, "desc",520,200, 20, "#FFFFFF", "当前击杀："..(npc.data.sg_data[key] or 0))
            GUI:Text_setFontName(desc, "fonts/font4.ttf")
            GUI:Text_enableOutline(desc, "#CA352C", 2)
        
            
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_give.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        elseif npc.data.jq_data[key] == 2 then --已完成
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.jq_data[key] = p3
        UI_updata(npc.node)
    end
end

return npc
