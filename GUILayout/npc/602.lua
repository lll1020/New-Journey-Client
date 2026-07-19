local npc = {}

npc._config = teshudata["npc_602"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/two_city/lgsz/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/two_city/lgsz/title.png"},
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
    local function GUI_createLabel(Label_node,idx)
        GUI:removeAllChildren(Label_node)
        local config = npc._config.details[idx]
        local model = GUI:Effect_Create(Label_node, "monster_model", 150, 230, 2, config.mob_shape or 0, 0, 0, 5)
        GUI:setScale(model, config.scale or 1)
        

        local state = (npc.data.T_dljq["npc_602"][""..idx] and npc.data.T_dljq["npc_602"][""..idx] == 2) and 2 or 1
        GUI:Text_setFontName(GUI:Text_Create(Label_node, "state",430,299, 25, state_info[state].color, state_info[state].text)
        , "fonts/501.ttf")
        GUI:Text_setFontName(GUI:Text_Create(Label_node, "time",430,299 - 53, 25, "#B2F022", config.time.."秒")
        , "fonts/501.ttf")
        GUI:Text_setFontName(GUI:Text_Create(Label_node, "nandu",430,299 - 53 - 53, 30, "#B2F022", config.nandu)
        , "fonts/502.ttf")
        GUI:Text_Create(Label_node, "yq",150,95 + 38, 20, "#F03022", config.yq)
        GUI:Text_Create(Label_node, "jl",150,95, 20, "#BEFF26", config.jl)

        if state == 1 then
            local Button= GUI:Button_Create(Label_node, "Button",250,0, "res/custom/two_city/lgsz/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, idx, "")
            end)
        else
            GUI:Image_Create(Label_node, "ywc",250,0, "res/wy/public/7_1.png")
        end
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
        for i = 1, 5 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/two_city/lgsz/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/two_city/lgsz/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/two_city/lgsz/list/l/"..npc.titles_sign..".png")
            end)
        end
        GUI_createLabel(npc.Label,npc.titles_sign)
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        npc.data.T_dljq["npc_602"] = npc.data.T_dljq["npc_602"] or {}
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc
