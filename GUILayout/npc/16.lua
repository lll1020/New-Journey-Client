local npc = {}

npc._config = teshudata["npc_16"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/sbk/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/one_city/sbk/title.png"},
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
        GUI:Image_Create(Label_node, "bg", 0, 0, "res/custom/one_city/sbk/bg_"..idx..".png")
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
        for i = 1, 2 do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/one_city/sbk/list/"..(npc.titles_sign == i and "l" or "n").."/"..i..".png")
            -- GUI:Button_setTitleText(cbl_item, titles[i])
            -- GUI:Button_setTitleFontSize(cbl_item, 14)
            GUI:Image_Create(npc.cbl_list, "fgx"..i, 0, 0, "res/custom/fulitating/list/fgx.png")
            GUI:addOnClickEvent(cbl_item, function()
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/sbk/list/n/"..npc.titles_sign..".png")
                npc.titles_sign = i
                GUI_createLabel(npc.Label,i)

                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/one_city/sbk/list/l/"..npc.titles_sign..".png")
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