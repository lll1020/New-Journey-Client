local npc = {}

npc._config = teshudata["npc_13"]




local WINDOW_OPTS = {
    background = {skin = "res/custom/one_city/13_bg.png", eff = true},
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
        if npc.data.dj_num < npc._config.max_level then
            local config = npc._config.config[npc.data.dj_num + 1]
            GUI:Text_setFontName(GUI:Text_Create(node, "desc1",490,353, 25, "#FB0000", npc.data.dj_num)
            , "fonts/500.ttf")
            local desc2 = GUI:Text_Create(node, "desc2",490,305, 25, "#9DB9C8", "人物切割："..npc._config.config[npc.data.dj_num].ratio.." -》"..npc._config.config[npc.data.dj_num + 1].ratio)
            GUI:Text_setFontName(desc2, "fonts/501.ttf")
            GUI:Text_enableOutline(desc2, "#000000", 2)

            

            local cost_show = checkItemNumByTable_img_kuang(config.cost, nil,GUI:Node_Create(node, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 750 - 250, 120)

            if npc.data.dj_num <= 5 then
                GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",400,250, 30, "#FF0000", "到达好感度5级时：")
                , "fonts/502.ttf")
                local kuang = GUI:Image_Create(node, "kuang10", 850 - 240 + 30, 220, "res/wy/public/70_70_k.png")
                UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.half_give)))
            end

             local Button= GUI:Button_Create(node, "Button2", 450, 20.00, "res/custom/one_city/btn_3.png")
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, '')
            end)
            if checkItemNum(config.cost) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        else

            GUI:Text_setFontName(GUI:Text_Create(node, "desc1",490,353, 25, "#ffffff", "10")
            , "fonts/500.ttf")

            GUI:Text_setFontName(GUI:Text_Create(node, "desc2",490,305, 25, "#ffffff", "人物切割："..npc._config.config[npc.data.dj_num].ratio)
            , "fonts/500.ttf")


            GUI:Text_setFontName(GUI:Text_Create(node, "tip_max",400,250, 30, "#FF0000", "好感度已达最高等级")
            , "fonts/500.ttf")
    
        end


       

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.dj_num = npc.data.dj_num + 1
        UI_updata(npc.node)
    end
end

return npc
