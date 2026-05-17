local npc = {}

npc._config = teshudata["npc_67"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/four_city/sxsh/bg.png", eff = true},
    -- title = {x = 56, y = 464, skin = "res/custom/four_city/sxsh/title.png"},
}
local attr_wz = {
    "对怪吸血+3%",
    "神圣一击概率+3%",
    "暴击伤害+3%",
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

    local function canActivate(idx)
        local state = npc.data and npc.data.T_data or {}
        local cfg = npc._config and npc._config.details and npc._config.details[idx]
        if not cfg or (state[""..idx] and state[""..idx] == 1) then
            return false
        end
        return checkItemNum(cfg.cost or {})
    end

    local function centerText(textNode, width, height)
        GUI:Text_setTextAreaSize(textNode, {width = width, height = height})
        GUI:Text_setTextHorizontalAlignment(textNode, 1)
    end

    local function UI_updata(node) --界面渲染
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        npc.titles_sign = npc.titles_sign or 1

        local layout = GUI:Layout_Create(node, "dbLayout", 50, 40, 270, 340)
        for i = 1, 12 do
            local cbl_item = GUI:Button_Create(layout, "item"..i, 0, 0, "res/custom/four_city/sxsh/list/"..i..".png")

            GUI:addOnClickEvent(cbl_item, function()
                npc.titles_sign = i
                UI_updata(node)
            end)
            if npc.titles_sign == i then
                GUI:setAnchorPoint(GUI:Image_Create(cbl_item, "x", 98/2, 94/2, "res/custom/four_city/sxsh/kuang.png"), 0.5, 0.5)
            end
            if npc.data.T_data[""..i] and npc.data.T_data[""..i] == 1 then
                GUI:Image_Create(cbl_item, "dui", 20, 0, "res/wy/public/6.png")
            elseif canActivate(i) then
                NPC_UI_HELPER.redpoint_create(cbl_item, {
                    x = 100 - 10,
                    y = 30 + 50 - 10,
                })
            end
            
        end
        GUI:UserUILayout(layout, {dir=3,addDir=1,colnum = 4,gap = {x=10, y=0}})

        for i=1,3 do
            local desc = GUI:Text_Create(node, "desc"..i,300 + 257 - 40,220 + 115 - (i-1)*96, 22, "#00FFFF", attr_wz[i])
            GUI:Text_setFontName(desc, "fonts/500.ttf")
            GUI:Text_enableOutline(desc, "#000000", 2)
            centerText(desc, 220, 32)
        end


        local kuang = GUI:Image_Create(node, "kuang2", 255, 28, "res/wy/public/58-60.png")
        UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        if npc.data.T_data[""..npc.titles_sign] and npc.data.T_data[""..npc.titles_sign] == 1 then
            GUI:setAnchorPoint(GUI:Image_Create(node, "Button", 620, 90.00, "res/wy/public/10_2.png"), 0.5, 0.5)
        else
            local Button = GUI:Button_Create(node, "Button", 620, 90.00, "res/custom/four_city/sxsh/btn.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, SL:JsonEncode({idx = npc.titles_sign}, false))
            end)
            if canActivate(npc.titles_sign) then
                NPC_UI_HELPER.redpoint_create(Button)
            end
        end

        
    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data.T_data[""..p3] = 1
        UI_updata(npc.node)
    end
end

return npc
