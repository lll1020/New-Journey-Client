local npc = {}

npc._config = teshudata["npc_54"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/cuiti/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/cuiti/title.png"},
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
        --                 "<font color='#00FF00' size='20' >每次提升的概率为50%，成功加一级失败不减</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)


        for v,k in ipairs(npc._config.config) do
            local l = GUI:Node_Create(node, "l_"..v, 270, (94 + 51*4) - 51*(v-1))
            GUI:RichText_Create(l, "text_name", 20 + 236, 15,
                            SetCompletionProgress((npc.data.dj_data[""..v] or 0), npc._config.max_level)
            , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
            local cost_show = ItemNumByTable_img(npc._config.cost, nil,GUI:Node_Create(l, "cost_show", 0, 0))
            GUI:setPosition(cost_show, 60, 2)
            if (npc.data.dj_data[""..v] or 0) >= npc._config.max_level then
                GUI:Image_Create(l, "Button", 350, 5, "res/wy/public/rwjd_3.png")
            else
                local Button= GUI:Button_Create(l, "Button", 350, 5, "res/custom/three_city/cuiti/btn.png")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, 0, '{"idx":'..v..'}')
                end)
                if checkItemNum(npc._config.cost) then
                    NPC_UI_HELPER.redpoint_create(Button,{x = 180,y = 28,autoScale = 1})
                end
            end

            
        end

        local kuang = GUI:Image_Create(node, "kuang2", 360, 18, "res/wy/public/70_70_k.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.title.."[称号]")))

        -- local Button= GUI:Button_Create(node, "Button", 510, 0.00, "res/custom/three_city/cuiti/btn_all.png")
        -- GUI:addOnClickEvent(Button, function()
        --     SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        -- end)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc
