local npc = {}

npc._config = teshudata["npc_74"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/tdmp/bg.png", eff = false},
}


local opt = {
    {x = 100 + 254,y = 2 + 319},
    {x = 200 - 3,y = 2 + 181},
    {x = 300 + 53,y = 2 + 30},
    {x = 400 + 89,y = 2 + 181},
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
    local function xjm_UI_updata(idx) --界面渲染

        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, npcid, {
            windowName = "npc_anniu_74_xjm",
            background = {skin = "res/custom/five_city/tdmp/xjm/"..idx..".png"},
            closeButton = {x = 330 - 65, y = 180 + 180 - 21, skin = "res/wy/public/close_red_big.png"},
        })
        npc.xjm_node = npc.xjm_window.node

        GUI:setAnchorPoint(GUI:RichText_Create(npc.xjm_node, "attr_desc", 100, 270, Player:showAttr(npc._config.details[idx].attrs), 200, 16, "#FF00FF", 0,nil,nil)
        , 0, 1)
        npc.data.T_data["npc_74"] = npc.data.T_data["npc_74"] or {}
        if npc.data.T_data["npc_74"][""..idx] then
            
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "Button", 308/2, 20, "res/wy/public/10_2.png")
            , 0.5, 0)
        else
            local Button = GUI:Button_Create(npc.xjm_node, "Button", 308/2, 20, "res/custom/five_city/tdmp/xjm/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = idx}, false))
            end)   
        end

    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.idx = 0

        for i=1,#opt do
            local Button = GUI:Button_Create(node, "Button"..i, opt[i].x, opt[i].y, "res/custom/five_city/tdmp/"..i..".png")
            GUI:addOnClickEvent(Button, function()
                -- SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = i}, false))
                npc.idx = i
                xjm_UI_updata(i)
            end)
        end




    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        xjm_UI_updata(npc.idx)

    end
end

return npc