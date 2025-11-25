local npc = {}

npc._config = teshudata["npc_9"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/9_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/9_title.png"},
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

        for i=1,2 do
            local item_node = GUI:Node_Create(node, 'item_node'..i, 362 - (i-1) * 362, 0)
            local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where[i])
            if item then

                local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
                equipLevel = tonumber(equipLevel)

                local kuang = GUI:Image_Create(item_node, "kuang", 173, 95, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, item)

                local config = npc._config.config[i][equipLevel]
                if equipLevel < npc._config.max_level then
                    kuang = GUI:Image_Create(item_node, "kuang2", 173, 260, "res/wy/public/70_70_k.png")
                    UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give)))
                    
                    ItemNumByTable_img({config.cost[1]}, nil,GUI:Node_Create(item_node, "cost_show1", 73, 147))
                    ItemNumByTable_img({config.cost[2]}, nil,GUI:Node_Create(item_node, "cost_show2", 294, 147))

                    local Button= GUI:Button_Create(item_node, "Button", 110, 10.00, "res/custom/one_city/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, npcid, 1, i, "")
                    end)
                else
                    GUI:Text_setFontName(GUI:Text_Create(item_node, "tip_max",120,30, 30, "#FF0000", "已达最高等级")
                    , "fonts/500.ttf")
                    GUI:setPosition(kuang, 173, 260)
                end
            end
            
        end
        

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc