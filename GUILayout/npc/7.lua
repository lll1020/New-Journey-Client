local npc = {}

npc._config = teshudata["npc_7"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/7_bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/7_title.png"},
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
        GUI:Effect_Create(npc.bg, "eff", 160, 260, 0, 60450)

        npc.node = npc._window.node
        return npc.node
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local item = SL:GetMetaValue("EQUIP_DATA", npc._config.where)

         local tipText = GUI:Text_Create(node, "lock_tip", 50,40, 25, "#FF0000", "满级后获得称号:")
        GUI:Text_setFontName(tipText, "fonts/font4.ttf")
        GUI:Text_enableOutline(tipText, "#000000", 2)
        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240, 20, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))


        
       

        if item then
            local attrDesc = GUI:RichText_Create(node, "attr_desc", 370, 320, Player:showEquipBaseAttr(item), 200, 17, "#f7f7de", 3, nil, nil, {
                outlineSize = 2,
                outlineColor = SL:ConvertColorFromHexString("#000000"),
            })
            GUI:setAnchorPoint(attrDesc, 0, 1)
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

                local attrDescNext = GUI:RichText_Create(node, "attr_desc_next", 360 + 350, 320, Player:showEquipBaseAttr(SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",config.give))), 200, 17, "#f7f7de", 3, nil, nil, {
                    outlineSize = 2,
                    outlineColor = SL:ConvertColorFromHexString("#000000"),
                })
                GUI:setAnchorPoint(attrDescNext, 1, 1)
                local Button= GUI:Button_Create(node, "Button", 450, 10.00, "res/custom/one_city/btn_1.png")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, 0, "")
                end)
                NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, Button, node, npcid, 1,{dir = 5})
                if checkItemNum(config.cost) then
                    NPC_UI_HELPER.redpoint_create(Button)
                end
            else
                local tipMax = GUI:Text_Create(node, "tip_max",450,100, 30, "#FF0000", "已达最高等级")
                GUI:Text_setFontName(tipMax, "fonts/500.ttf")
                GUI:Text_enableOutline(tipMax, "#000000", 2)
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
