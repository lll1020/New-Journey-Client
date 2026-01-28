local npc = {}

npc._config = teshudata["npc_631"]



local WINDOW_OPTS = {
    background = {skin = "res/custom/all_story_mission/3/631_bg.png"},
    closeButton = {x = 747, y = 380},
}
local key = "npc_631"
local btn_pos = {600, 100}
local cost_pos = {507 - 240, 202 + 40}

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

    local function UI_updata(node)
        if not node then
            return
        end

        GUI:removeAllChildren(node)
        npc.idx = 0
        npc.data.T_dljq[key] = (npc.data.T_dljq and npc.data.T_dljq[key]) and npc.data.T_dljq[key] or 0
        npc.data.T_dljq[key.."_s"] = (npc.data.T_dljq and npc.data.T_dljq[key.."_s"]) and npc.data.T_dljq[key.."_s"] or {}
        for i = 1,4 do
            --两行 每行两个
            local Button= GUI:Button_Create(node, "Button"..i, 262 + 290 + (i -1)%2 *120, 200 + 114 - math.floor((i -1)/2)*50, "res/custom/all_story_mission/3/btn_631_s_"..i..".png")
            GUI:addOnClickEvent(Button, function()
                if npc.idx and npc.idx ~= 0 then
                    local pre_btn = GUI:ui_delegate(node)["Button"..npc.idx]
                    if pre_btn then
                        GUI:removeChildByName(pre_btn, "select_img")
                    end
                end
                
                npc.idx = i
                GUI:setContentSize(GUI:Image_Create(Button, "select_img", 0, 0, "res/wy/public/003.png"), 80, 28)
            end)
            for idx, v in ipairs(npc.data.T_dljq[key.."_s"]) do
                if v == i then
                    GUI:Text_Create(Button, "name",70,3, 18, idx == 4 and "#FF0000" or "#00FF00", idx == 4 and "内鬼" or "忠")
                end
            end
        end
        
        local desc = GUI:Text_Create(node, "desc",180,130, 20, "#808080", "当前击杀："..(npc.data.sg_data[key] or 0).."可搜查次数："..math.floor((npc.data.sg_data[key] or 0)/npc._config.jl_num) - #npc.data.T_dljq[key.."_s"])
        GUI:Text_setFontName(desc, "fonts/500.ttf")
        GUI:Text_enableOutline(desc, "#00FFFF", 2)

        local ch_kuang = GUI:Image_Create(node, "ch_kuang", 240 + 320, 145, "res/wy/public/70_70_k.png")
        UiTools.showItemData(ch_kuang, SL:GetMetaValue("ITEM_DATA",SL:GetMetaValue("ITEM_INDEX_BY_NAME",npc._config.ch.."[称号]")))

        if npc.data.T_dljq[key] == 0 then --接取任务
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/custom/all_story_mission/2/btn_take.png")
            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        elseif npc.data.T_dljq[key] == 1 then --领取奖励
            local Button= GUI:Button_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/an_tongyong.png")
            local Button_wz = GUI:Text_Create(Button, "desc",116,52, 25, "#FFFBF0", "审问水手")
            GUI:setAnchorPoint(Button_wz, 0.5, 0.5)
            GUI:Text_setFontName(Button_wz, "fonts/500.ttf")
            GUI:Text_enableOutline(Button_wz, "#CA352C", 2)

            GUI:setAnchorPoint(Button, 0.5, 0.5)
            GUI:addOnClickEvent(Button, function()
                if npc.idx == 0 then
                    SL:ShowSystemTips("请选择一个选项！")
                    return
                end
                SL:SendLuaNetMsg(100, npcid, 1, npc.idx, "")
            end)
        elseif npc.data.T_dljq[key] == 2 then --已完成
            GUI:Image_Create(node, "Button", btn_pos[1], btn_pos[2], "res/wy/public/7_1.png")
        end

    

    end


    if p2 == 0 then
        npc.data = SL:JsonDecode(msgData,false)
        ensureWindow(npcid)
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data = SL:JsonDecode(msgData,false)
        UI_updata(npc.node)
    end
end

return npc
