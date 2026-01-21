local npc = {}

npc._config = teshudata["npc_6"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/6_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/6_title.png"},
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
        local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)

        GUI:Text_setFontName(GUI:Text_Create(node, "tip",50,40, 25, "#FF0000", "满级后获得称号:")
        , "fonts/500.ttf")
        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240, 20, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))


        
       
        if item then

             GUI:setAnchorPoint(GUI:RichText_Create(node, "attr_desc", 370, 320,  Player:showEquipBaseAttr(item), 200, 17, "#f7f7de", 3,nil,nil)
            , 0, 1)

            local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
            equipLevel = tonumber(equipLevel)

            local kuang = GUI:Image_Create(node, "kuang", 404, 353, "res/wy/public/70_70_k.png")
            UiTools.showItemData(kuang, item)

            local config = npc._config.config[equipLevel]
            if equipLevel < npc._config.max_level then

                kuang = GUI:Image_Create(node, "kuang2", 404 + 209, 353, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give)))
                
                local cost_show = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
                GUI:setPosition(cost_show, 450, 100)

                GUI:setAnchorPoint(GUI:RichText_Create(node, "attr_desc_next", 370 + 350, 320,  Player:showEquipBaseAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give))), 200, 17, "#f7f7de", 3,nil,nil)
                , 1, 1)

                local Button= GUI:Button_Create(node, "Button", 450, 10.00, "res/custom/one_city/btn_1.png")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                end)
            else
                GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",450,100, 30, "#FF0000", "已达最高等级")
                , "fonts/500.ttf")
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