local npc = {}

npc._config = teshudata["npc_27"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/jnqh/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/jnqh/title.png"},
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
        local k = npc._config.details[idx]
        local Layout1 = GUI:Layout_Create(Label_node, "Layout1", 20, 140, 560, 190, true)

        GUI:Effect_Create(Layout1, "gjtx", 40, 40, 3,k.eff, 0, 0, 2, 0.8)
        GUI:Effect_Create(Layout1, "rw1", 40, 40, 4, SL:GetMetaValue("EQUIP_DATA", 0) and SL:GetMetaValue("EQUIP_DATA", 0).Shape or 1300, 0, 2, 2, 0.8)
        GUI:Effect_Create(Layout1, "wq", 40, 40, 5, SL:GetMetaValue("EQUIP_DATA", 1) and SL:GetMetaValue("EQUIP_DATA", 1).Shape or 6, 0, 2, 2, 0.8)

        GUI:RichTextFCOLOR_Create(Label_node, "text_name", 200, 350,
                        (npc.data.T_data.level[""..idx] or 0).."/"..k.max_level
        , 500, 25, "#f7f7de", 3,nil,"fonts/500.ttf",{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        
        GUI:Text_setFontName(GUI:Text_Create(Label_node, "wz",190,108, 25, "#00FF00", "技能伤害提升2%")
        , "fonts/501.ttf")

        local tip = GUI:Image_Create(Label_node, "tip", 380, 350, "res/custom/three_city/jnqh/wz.png")
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = k.mz, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end, onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end})
        else
            GUI:setTouchEnabled(tip, true)
            GUI:addOnTouchEvent(tip, function(self)
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = k.mz, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 0})
            end)
        end
        
        local cost_show = ItemNumByTable_img(k.cost, nil,GUI:Node_Create(Label_node, "cost_show", 0, 0))
        GUI:setPosition(cost_show, 80, 20)

        local Button= GUI:Button_Create(Label_node, "Button", 350, 5, "res/custom/three_city/jnqh/btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, idx, '')
        end)
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)

        npc.titles_sign = 1
        for i = 1, 6 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/three_city/jnqh/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/jnqh/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/three_city/jnqh/list/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data.level = npc.data.T_data.level or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 0 then--界面渲染
        npc.data.T_data.level[""..npc.titles_sign] = (npc.data.T_data.level[""..npc.titles_sign] or 0) + 1
        UI_updata(npc.node)
        GUI_createLabel(npc.Label,npc.titles_sign)
    end
end

return npc