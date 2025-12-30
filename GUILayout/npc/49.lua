local npc = {}

npc._config = teshudata["npc_49"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/three_city/cqbg/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/three_city/cqbg/title.png"},
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

        GUI:Frames_Create(node, "eff", 470, 190, "res/custom/three_city/cqbg/eff/eff_", ".png", 1, 34,
            { speed = 75, count = 34, loop = -1})

        local rwjl_show = ItemNumByTable_img_new(npc._config.cost, nil,GUI:Node_Create(node, "cost", 0, 0))
        GUI:setPosition(rwjl_show, 145 + 454, 100)

        local kuang = GUI:Image_Create(node, "kuang", 410 , 30.00, "res/wy/public/58-60.png")
        UiTools.showItemData_Index(kuang, SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]"))


        local dbLayout = GUI:Layout_Create(node, "dbLayout", 34,130, 670, 200)
        for k,v in ipairs(npc._config.details) do
            if npc.data.T_data[""..k] and npc.data.T_data[""..k] == 1 then
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/cqbg/kuang/"..k..".png")
                GUI:setAnchorPoint(GUI:RichText_Create(kuang, "attr_desc", 106/2, 45, Player:showAttr(v.attr), 0, 0, "#f7f7de", 3,nil,nil)
                , 0.5, 1)
            else
                local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/custom/three_city/cqbg/kuang_b.png")
            end
        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=5, y=0}})

        local Button= GUI:Button_Create(node, "btn", 520, 10.00, "res/custom/three_city/cqbg/btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, '')
        end)

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        UI_updata(npc.node)
    end
end

return npc