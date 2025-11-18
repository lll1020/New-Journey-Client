local npc = {}

npc._config = teshudata["npc_6"]



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
        GUI:removeAllChildren(node)

        GUI:setAnchorPoint(
                GUI:RichText_Create(node, "desc", 200, 430,
                        "<font color='#00FF00' size='20' >除了每次升级带来的基础属性  还有相对应的全属性</font>"
                , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        , 0, 1)



        local kuang = GUI:Image_Create(node, "title", 750, 250, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))


        local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)
        if item then

            local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
            equipLevel = tonumber(equipLevel)

            local kuang = GUI:Image_Create(node, "kuang", 200, 250, "res/wy/public/70_70_k.png")
            UiTools.showItemData(kuang, item)

            local config = npc._config.config[equipLevel]
            if equipLevel < npc._config.max_level then
                kuang = GUI:Image_Create(node, "kuang2", 400, 250, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give)))

                GUI:Text_Create(node, "wz5",200,200, 20, "#FF0000", "消耗:")
                local cost_show = ItemNumByTable_img(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
                GUI:setPosition(cost_show, 200, 130)


            end


        end
        local Button= GUI:Button_Create(node, "Button", 750, 100.00, "res/public/1900000660.png")
        GUI:Button_setTitleText(Button, "升级")
        GUI:Button_setTitleFontSize(Button, 14)

        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)

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