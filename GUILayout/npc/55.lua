local npc = {}

npc._config = {

     rwjl = {{"仙草种子",9},{"元宝",200000}},
}


local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/xfts/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/xfts/title.png"},
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




        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >领取任务 共计击杀200只怪物，当前击杀："..(npc.data.sg_data.npc_55 or 0).."</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)
        --显示奖励
        local rwjl_show = ItemNumByTable_img_new(npc._config.rwjl, nil,GUI:Node_Create(node, "rwjl", 0, 0))
        GUI:setPosition(rwjl_show, 490, 80)
        



        if npc.data.jq_data["npc_55"] and npc.data.jq_data["npc_55"] == 2 then
            GUI:Text_setFontName(GUI:Text_Create(node, "tip",450,30, 25, "#00FF00", "任务已完成，恭喜您！")
            , "fonts/500.ttf")
        elseif npc.data.jq_data["npc_55"] and npc.data.jq_data["npc_55"] == 1 then

            local desc = GUI:Text_Create(node, "desc",500,200, 20, "#808080", "当前击杀："..(npc.data.sg_data.npc_55 or 0))
            GUI:Text_setFontName(desc, "fonts/500.ttf")
            GUI:Text_enableOutline(desc, "#00FFFF", 2)


            local Button= GUI:Button_Create(node, "Button2", 450, 0.00, "res/custom/three_city/xfts/btn.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        else
            local Button= GUI:Button_Create(node, "Button", 450, 0.00, "res/wy/public/an_lqrw.png")
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
        npc.data.jq_data["npc_55"] = p3
        UI_updata(npc.node)
    end
end

return npc