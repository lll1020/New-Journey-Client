local npc = {}

npc._config = teshudata["npc_73"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/five_city/dysy/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/five_city/dysy/title.png"},
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

        GUI:Text_setFontName(GUI:Text_Create(node, "tip",430,150 + 177, 20, "#00FFFF", "更强的怪物，更丰厚的奖励！")
        , "fonts/500.ttf")

        local cost = checkItemNumByTable_img_kuang(npc._config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
        GUI:setPosition(cost, 400, 110)

        cost = checkItemNumByTable_img_kuang({{"元宝",1},{"金币",1},{"灵石",1}}, nil,GUI:Node_Create(node, "jl_show", 0, 0))
        GUI:setPosition(cost, 400, 110 + 115)

        local Button = GUI:Button_Create(node, "Button", 620, 0.00, "res/custom/five_city/dysy/btn.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)    
    

        
       
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
        
    end
end

return npc