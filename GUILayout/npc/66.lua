local npc = {}

npc._config = teshudata["npc_66"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/fwcq/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/four_city/fwcq/title.png"},
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



    local function xjm_UI_updata(node) --界面渲染

        GUI:removeAllChildren(node)
        
        local remainText = GUI:Text_Create(node, "remainTimes", 575, 110 + 231, 26, "#FF00FF", string.format("%d", npc.data.T_data.wins or 0))
        GUI:setAnchorPoint(remainText, 0.5, 0.5)
        npc.data.T_data.dh = npc.data.T_data.dh or {}

        for i = 1, 4 do

            local item_node = GUI:Node_Create(node, "item_node"..i, 0, 220 - (i-1)*61)

            GUI:setAnchorPoint(
                GUI:RichText_Create(item_node, "num" .. i, 200 + 122 + 20, 10,
                                SetCompletionProgress((npc.data.T_data.wins or 0), npc._config.shop[i].win_num)
                , 500, 30, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            , 0.5, 0)

            local kuang = GUI:Image_Create(item_node, "kuang", 70, -3, "res/custom/four_city/fwcq/shop/kuang.png")
            if npc._config.shop[i].ch then
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.shop[i].ch.."[称号]")))
            elseif npc._config.shop[i].give then
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.shop[i].give[1][1])))
            end
            if npc.data.T_data.dh["" .. i] then
                GUI:Image_Create(item_node, "item" .. i, 500, 0, "res/custom/four_city/fwcq/shop/ok.png")
            else
                local cbl_item = GUI:Button_Create(item_node, "item" .. i, 500, 0, "res/custom/four_city/fwcq/shop/btn.png")
                GUI:addOnClickEvent(cbl_item, function()
                    SL:SendLuaNetMsg(100, npcid, 2, 0, SL:JsonEncode({idx = i}, false))
                end)
            end
            
            
        end

    end
    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        local T_data = npc.data and npc.data.T_data or {}
        local usedCount = tonumber(T_data.count) or 0
        local maxCount = 3
        local remainCount = maxCount - usedCount
        if remainCount < 0 then
            remainCount = 0
        end

        local remainText = GUI:Text_Create(node, "remainTimes", 570, 113, 26, "#FFFFFF", string.format("%d/%d", remainCount, maxCount))
        GUI:Text_setFontName(remainText, "fonts/500.ttf")
        GUI:setAnchorPoint(remainText, 0.5, 0.5)

        npc.titles_sign = 0

        for i = 1, 3 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 570 + (i-1)*120 - 200, 150, "res/custom/four_city/fwcq/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(node)["item" .. npc.titles_sign], "res/custom/four_city/fwcq/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI:Button_loadTextureNormal(GUI:ui_delegate(node)["item" .. npc.titles_sign], "res/custom/four_city/fwcq/list/l/"..npc.titles_sign..".png")
            end)
        end

        local Button= GUI:Button_Create(node, "btn", 630, 0, "res/custom/four_city/fwcq/btn.png")
        GUI:setAnchorPoint(Button,0.5, 0)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({choice = npc.titles_sign}, false))
        end)

        Button= GUI:Button_Create(node, "btn_shop", 400, 0, "res/custom/four_city/fwcq/btn_shop.png")
        GUI:setAnchorPoint(Button,0.5, 0)
        GUI:addOnClickEvent(Button, function()
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
                windowName = "npc_anniu_66_xjm",
                overlay = {skin = "res/public/1900000651_1.png"},
                background = {skin = "res/custom/four_city/fwcq/shop/bg.png"},
                closeButton = {x = 330 + 220 + 185 - 109, y = 180 + 180 + 103 - 155, skin = "res/wy/public/close_red_big.png"},
            })
            npc.xjm_node = npc.xjm_window.node
            xjm_UI_updata(npc.xjm_node)
        end)

        



    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    elseif p2 == 2 then
        npc.data = SL:JsonDecode(msgData,false)
        xjm_UI_updata(npc.xjm_node)
    end
end

return npc