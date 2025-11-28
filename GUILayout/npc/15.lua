local npc = {}

npc._config = teshudata["npc_15"]



local WINDOW_OPTS = {
    background = {skin = "res/wy/public/*.png"},
    closeButton = {x = 350, y = 180, skin = "res/wy/public/close_red_big.png"},
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

    npc.bg = GUI:Frames_Create(npc.bg, "eff", 0, 0, "res/custom/one_city/kbzl/bg/eff_", ".png", 1, 75,
        { speed = 75, count = 75, loop = -1})
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)

    GUI:setLocalZOrder(npc._window.node, 99)
    npc.node = npc._window.node
    return npc.node
end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        

        GUI:setAnchorPoint(GUI:Image_Create(node, "kuang2", 0, 0, "res/custom/one_city/kbzl/up.png")
        , 0.5, 0.5)


        -- GUI:setAnchorPoint(
        --         GUI:RichText_Create(node, "desc", 200, 430,
        --                 "<font color='#00FF00' size='20' >1000仙玉(非绑)</font>"
        --         , 500, 20, "#f7f7de", 3,nil,nil,{outlineSize = 2,outlineColor = SL:ConvertColorFromHexString("#100808")})
        -- , 0, 1)




        -- local kuang = GUI:Image_Create(node, "kuang2", 750, 250, "res/wy/public/70_70_k.png")
        -- UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.give.ch.."[称号]")))


        local Button= GUI:Button_Create(node, "Button", 100, -250, "res/custom/one_city/kbzl/btn.png")
        GUI:addOnClickEvent(Button, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        --npc.data = SL:JsonDecode(msgData,false)
        --UI_updata(npc.node)
    end
end

return npc