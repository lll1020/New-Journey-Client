local npc = {}

npc._config = teshudata["npc_8"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/8_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/8_title.png"},
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

        
        

        if item then

            GUI:setAnchorPoint(GUI:RichText_Create(node, "attr_desc", 100, 330,  "<font color='#00FF00'>人物生命+"..(npc._config.config[Player:getEquipFieldByIndex(item.Index, 1)] and npc._config.config[Player:getEquipFieldByIndex(item.Index, 1)].ex_arrt[1] or 1).."%</font>\n"..Player:showEquipBaseAttr(item), 200, 17, "#f7f7de", 3,nil,nil)
            , 0, 1)
            local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
            equipLevel = tonumber(equipLevel)

            local kuang = GUI:Image_Create(node, "kuang", 415, 280, "res/wy/public/70_70_k.png")
            UiTools.showItemData(kuang, item)

            local config = npc._config.config[equipLevel]
            if equipLevel < npc._config.max_level then
                kuang = GUI:Image_Create(node, "kuang2", 415 + 209, 280, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give)))
                
                local cost_show = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
                GUI:setPosition(cost_show, 490, 140)

                GUI:setAnchorPoint(GUI:RichText_Create(node, "attr_desc_next", 100, 330 - 185,  "<font color='#00FF00'>人物生命+"..config.ex_arrt[1].."%</font>\n"..Player:showEquipBaseAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give))), 200, 17, "#f7f7de", 3,nil,nil)
                , 0, 1)
                local Button= GUI:Button_Create(node, "Button", 450, 10.00, "res/custom/one_city/btn_1.png")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                end)

            else
                GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",460,150, 30, "#FF0000", "已达最高等级")
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