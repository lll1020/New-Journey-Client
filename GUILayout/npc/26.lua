local npc = {}

npc._config = teshudata["npc_26"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/qyzb/bg.png", eff = false},
    closeButton = {x = 850, y = 450,},
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
        for v,k in ipairs(npc._config.details) do
            local kuang = GUI:Image_Create(node, "kuang"..v, 50 + (v-1)*190, 170, "res/custom/two_city/qyzb/"..v..".png")
            -- UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)))
            if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",k)) then
                local contentSize = kuang:getContentSize()
                GUI:setAnchorPoint(GUI:Image_Create(kuang, "kuang", contentSize.width / 2, contentSize.height / 2, "res/custom/two_city/qyzb/kuang.png")
                , 0.5, 0.5)
            end
        end

        -- local cost = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        -- GUI:setPosition(cost, 800, 200)
        
        GUI:Text_setFontName(GUI:Text_Create(node, "U_num",860,55, 25, "#00FF95", npc.data.U_num or 0)
        , "fonts/500.ttf")

            
        GUI:setAnchorPoint(GUI:Image_Create(node, "wz", 520, 120.00, "res/custom/two_city/qyzb/wz.png")
        , 0.5, 0.5)
        if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.details[5])) then
            GUI:setAnchorPoint(GUI:Image_Create(node, "Button", 520, 60.00, "res/wy/public/15.png"), 0.5, 0.5)
        else
            local Button= GUI:Button_Create(node, "Button", 520, 60.00, "res/custom/two_city/qyzb/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
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
        npc.data.U_num = npc.data.U_num + 1
        UI_updata(npc.node)
    end 
end

return npc