local npc = {}

npc._config = teshudata["npc_64"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/ssyw/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/ssyw/title.png"},
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
    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)

        GUI:Frames_Create(Label_node, "eff", 20, 0, "res/custom/five_city/ssyw/eff/"..idx.."/eff_", ".png", 1, 75,
        { speed = 75, count = 75, loop = 0})

        
        GUI:Image_Create(Label_node, "wz1", 20, 0, "res/custom/five_city/ssyw/wz1.png")

        GUI:Text_setFontName(GUI:Text_Create(Label_node, "map",500,215, 30, "#B2F022", npc._config.config.syw[idx].map)
        , "fonts/500.ttf")

        GUI:Text_setFontName(GUI:Text_Create(Label_node, "boss",500,215 + 42, 30, "#FF0000", npc._config.config.syw[idx].boss)
        , "fonts/500.ttf")

        local kuang = GUI:Image_Create(Label_node, "kuang2", 213, 10, "res/wy/public/58-60.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.syw_ch.."[称号]")))

        -- 
        local cost = checkItemNumByTable_img_kuang({{npc._config.config.ls[npc.titles_sign].syw,1},{"元宝",1880000}}, nil,Label_node)
        GUI:setPosition(cost, 470, 110)
        npc.data.T_data.syw = npc.data.T_data.syw or {}

        if npc.data.T_data.syw[""..idx] and npc.data.T_data.syw[""..idx] == 1 then
            GUI:setAnchorPoint(GUI:Image_Create(Label_node, "Button", 620, 0.00, "res/wy/public/10_2.png"), 0.5, 0)
        else
            local Button = GUI:Button_Create(Label_node, "Button", 620, 0.00, "res/custom/five_city/ssyw/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 5, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
            end)    
        end
        
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.Label = GUI:Node_Create(node, "Label", 0, 0)


        npc.titles_sign = 1
        for i = 1, 5 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 30 + (i-1)*145, 337, "res/custom/five_city/ssyw/list/"..i..".png")
            GUI:setGrey(cbl_item, npc.titles_sign ~= i)
            GUI:addOnClickEvent(cbl_item, function()
                GUI:setGrey(GUI:ui_delegate(node)["item" .. npc.titles_sign], true)
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:setGrey(GUI:ui_delegate(node)["item" .. npc.titles_sign], false)
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc