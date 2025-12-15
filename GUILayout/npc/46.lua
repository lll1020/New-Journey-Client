local npc = {}

npc._config = teshudata["npc_46"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/zerq/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/zerq/title.png"},
}

local state_info = {
    [1] = {
        color = "#FF0000", -- 红色
        text = "未完成"
    },
    [2] = {
        color = "#00FF00", -- 绿色
        text = "已通过"
    }
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


        local function GUI_createLabel(label_node, idx)
            GUI:removeAllChildren(label_node)

            local config = npc._config.details[idx]
            local model = GUI:Effect_Create(label_node, "monster_model", 150, 130, 2, config.mob_eff or 0, 0, 0, 5)
            GUI:setScale(model, config.scale or 1)
            local mob_name = GUI:Text_Create(label_node, "mob_name",100 + 70,150 + 211, 28, "#FF0000", config.mob_name)
            GUI:Text_setFontName(mob_name, "fonts/500.ttf")
            GUI:setAnchorPoint(mob_name, 0.5, 0.5)
            GUI:Image_Create(label_node, "w", 310, 340, "res/custom/three_city/zerq/w_"..idx..".png")


            GUI:Text_Create(label_node, "name",460,293, 20, "#FF0000", config.mob_name)
            GUI:Text_Create(label_node, "map",460,293 - 44, 20, "#FF0000", config.map)
            local spa = GUI:Text_Create(label_node, "spa",460,293 - 44 - 44, 20, "#FF0000", config.spa)
            GUI:Text_enableUnderline(spa)
            tip_node(spa, config.spa_details)
            local kz = GUI:Text_Create(label_node, "kz",460,293 - 44 - 44 - 44, 20, "#FF0000", config.kz)
            GUI:Text_enableUnderline(kz)
            tip_node(kz, config.kz_details)
            -- GUI:Text_Create(label_node, "kz",460,293 - 44 - 44 - 44, 20, "#FF0000", config.kz)
            local state = (npc.data.T_data["npc_46"][""..idx] and npc.data.T_data["npc_46"][""..idx] == 1) and 2 or 1
            GUI:Text_Create(label_node, "state",460,293 - 44 - 44 - 44 - 44, 20, state_info[state].color, state_info[state].text)
            
        end


        local kuang = GUI:Image_Create(node, "kuang2", 320 + 140, 15, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        npc.Label = GUI:Node_Create(node, "Label", 0, 0)

        if SL:GetMetaValue("TITLE_DATA_BY_ID", SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch)) then
            
        else
            local Button= GUI:Button_Create(node, "Button_all", 540, 10.00, "res/custom/three_city/zerq/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        end
        


        for i = 1, 4 do
            local cbl_item = GUI:Button_Create(node, "item" .. i, 27 + (i-1)*182, 390, "res/custom/three_city/zerq/k_"..i..".png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:removeChildByName(GUI:ui_delegate(node)["item" .. npc.titles_sign], "kuang")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)
                GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "kuang", 182/2, 60/2, "res/custom/three_city/zerq/kuang.png")
                , 0.5, 0.5)
            end)
            if npc.titles_sign == nil or i == npc.titles_sign then
                npc.titles_sign = i
                GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "kuang", 182/2, 60/2, "res/custom/three_city/zerq/kuang.png")
                , 0.5, 0.5)
            end
        end
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
        


    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_data["npc_46"] = npc.data.T_data["npc_46"] or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc