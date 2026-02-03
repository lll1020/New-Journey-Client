local npc = {}

npc._config = teshudata["npc_42"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/42_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/two_city/42_title.png"},
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

        GUI:Image_Create(node, "x", 0, 0.00, "res/custom/two_city/42_x.png")


        local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)
        if item then

            local itemShow = GUI:ItemShow_Create(node, "next", 545, 337, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.give), look = true, bgVisible = false })
            itemShow:setAnchorPoint(cc.p(0.5, 0.5))

            for i, v in ipairs(npc._config.cost) do
                GUI:ItemShow_Create(node, "cost"..(i > 1 and i+1 or i), 400 + ((i > 1 and i+1 or i) - 1) * 86, 197, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",v[1]),count = v[2], look = true, bgVisible = false })
                if i  == 1 then
                    GUI:ItemShow_Create(node, "cost"..2, 400 + (i) * 86, 197, { index = SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.now), look = true, bgVisible = false })
                end 
            end

            -- local cost_show = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
            -- GUI:setPosition(cost_show, 200, 130)

        end
        local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
        equipLevel = tonumber(equipLevel)
        if equipLevel >= 12 then
            GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",450,100, 30, "#FF0000", "已经合成完毕")
            , "fonts/502.ttf")
        else
            local Button= GUI:Button_Create(node, "Button", 450, 20.00, "res/custom/two_city/41_btn.png")

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
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