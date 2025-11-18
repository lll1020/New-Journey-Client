local npc = {}

npc._config = teshudata["npc_9"]



local WINDOW_OPTS = {}

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
        local function main_updata(main_node) --主界面渲染

            GUI:removeAllChildren(main_node)

            GUI:setAnchorPoint(
                    GUI:RichText_Create(main_node, "desc", 200, 430,
                            "<font color='#00FF00' size='20' >除了每次升级带来的基础属性  还有相对应的攻击</font>"
                    , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0, 1)

            local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where[npc.dq_idx])
            if item then
                local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
                equipLevel = tonumber(equipLevel)

                local kuang = GUI:Image_Create(main_node, "kuang", 200, 250, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, item)

                local config = npc._config.config[npc.dq_idx][equipLevel]
                if equipLevel < npc._config.max_level then
                    kuang = GUI:Image_Create(main_node, "kuang2", 400, 250, "res/wy/public/70_70_k.png")
                    UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give)))

                    GUI:Text_Create(node, "wz5",200,200, 20, "#FF0000", "消耗:")
                    local cost_show = ItemNumByTable_img(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
                    GUI:setPosition(cost_show, 200, 130)
                end
            end
            local Button= GUI:Button_Create(main_node, "Button", 750, 100.00, "res/public/1900000660.png")
            GUI:Button_setTitleText(Button, "升级")
            GUI:Button_setTitleFontSize(Button, 14)

            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, npc.dq_idx, "")
            end)
        end

        npc.dq_idx = npc.dq_idx or 1
        GUI:removeAllChildren(node)

        local main_node = GUI:Node_Create(node, "main_node", 0, 0)

        local menu = {"复活","麻痹"}

        for i = 1, 2, 1 do
            local btn = GUI:Button_Create(node, 'btn'..i, 200 + (i-1)*200, 500, "res/public/1900000660.png")

            GUI:Button_setTitleText(btn, menu[i])
            GUI:Button_setTitleFontSize(btn, 14)

            GUI:addOnClickEvent(btn, function()
                if i~=npc.dq_idx then
                    npc.dq_idx = i
                    main_updata(main_node)
                end
            end)
        end
        main_updata(main_node)
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