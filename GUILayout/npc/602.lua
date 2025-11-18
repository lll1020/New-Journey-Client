
local npc = {}

npc._config = teshudata["npc_602"]



local WINDOW_OPTS = {}

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
        local GUI_list = GUI:ListView_Create(node, "GUI_list", 200, 100, 900, 270, 2)
        for i = 1, 5 do
            local kuang = GUI:Image_Create(GUI_list, "kuang"..i, 0, 0, "res/wy/public/anniu_999_bj.png")
            GUI:setContentSize(kuang, 150, 270)

            GUI:setAnchorPoint(GUI:Text_Create(kuang, "wz5",150/2,230, 20, "#FF0000", npc._config.mob[i])
            , 0.5, 0.5)

            local Button= GUI:Button_Create(kuang, "Button", 150/2, 50, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:Button_setTitleFontSize(Button, 14)
            npc.data.T_dljq["npc_602"] = npc.data.T_dljq["npc_602"] or {}
            if npc.data.T_dljq["npc_602"][""..i] and npc.data.T_dljq["npc_602"][""..i] == 1 then
                GUI:Button_setTitleText(Button, "激活")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 2, i, "")
                end)
            else
                GUI:Button_setTitleText(Button, "挑战")
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(100, npcid, 1, i, "")
                end)
            end



        end

    end


    if p2 == 0 then--界面
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    end
end

return npc