local npc = {}
npc._config = teshudata["npc_"..1010]



local WINDOW_OPTS = {
    background = {skin = "res/custom/zmhs/bg.png", eff = true},
    title = {x = 56, y = 464, skin = "res/custom/zmhs/title.png"},
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

    local function UI_updata(node) --鐣岄潰娓叉煋
        if not node then
            return
        end

        GUI:removeAllChildren(node)

        local dbLayout = GUI:Layout_Create(node, "dbLayout", 40,20, 670, 350)
        for k,v in ipairs(npc._config.details) do
            local kuang = GUI:Image_Create(dbLayout, "kuang"..k, 0, 0.00, "res/wy/public/58-60.png")
            UiTools.showItemData(kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",v)))
            

        end
        GUI:UserUILayout(dbLayout, {dir=3,addDir=1,colnum = 4,gap = {x=8, y=15}})

        
    end


    if p2 == 0 then--鐣岄潰
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc