--跨服 对战
local npc = {}
local npc_kf = {
}

local function decodeData(data)
    local decoded = SL:JsonDecode(data or "", false)
    if type(decoded) ~= "table" then
        decoded = {}
    end
    decoded.jf = tonumber(decoded.jf or 0) or 0
    decoded.cs = tonumber(decoded.cs or 0) or 0
    decoded.jl = type(decoded.jl) == "table" and decoded.jl or {}
    decoded.pm = type(decoded.pm) == "table" and decoded.pm or {}
    return decoded
end

local function removeNode(node)
    if node then
        GUI:removeFromParent(node)
    end
end

local function getEquipItemData(pos)
    local equip = SL:GetMetaValue("EQUIP_DATA", pos)
    if not equip or not equip.Index then
        return nil
    end
    return SL:GetMetaValue("ITEM_DATA", equip.Index)
end

local function buildRankTipHtml()
    local lines = {"<font color='#F4D179' size='18'>武道天榜</font>"}
    local rank = type(npc.data.pm) == "table" and npc.data.pm or {}
    if #rank == 0 then
        lines[#lines + 1] = "<font color='#FFFFFF' size='16'>暂无排行数据</font>"
    else
        for i, v in ipairs(rank) do
            if i > 10 then
                break
            end
            lines[#lines + 1] = string.format("<font color='#FFFFFF' size='16'>%02d. %s  %s分</font>", i, tostring(v[1] or "玩家"), tostring(v[2] or 0))
        end
    end
    lines[#lines + 1] = "<font color='#9FF06B' size='16'>周日24:00按排行发放跨服积分</font>"
    lines[#lines + 1] = "<font color='#F4D179' size='16'>排行奖励：1名100  2名80  3名70</font>"
    lines[#lines + 1] = "<font color='#F4D179' size='16'>4名60  5名50  6名40  7名30</font>"
    lines[#lines + 1] = "<font color='#F4D179' size='16'>8名25  9名20  10名15  10名后10</font>"
    return table.concat(lines, "<br>")
end

local function openRankTip(target)
    local pos = GUI:getWorldPosition(target)
    SL:OpenCommonDescTipsPop({
        str = buildRankTipHtml(),
        worldPos = {x = pos.x, y = pos.y},
        anchorPoint = {x = 0, y = 0},
        formatWay = 1
    })
end

local function createRuleText(parent, name, x, y, color, text, size)
    local node = GUI:Text_Create(parent, name, x, y, size or 18, color, text)
    GUI:setAnchorPoint(node, 0, 0.5)
    GUI:Text_enableOutline(node, "#000000", 2)
    return node
end

local function renderRuleText(parent)
    createRuleText(parent, "rule_title", 615 + 80, 272, "#F4D179", "跨服PK规则", 21)
    createRuleText(parent, "rule_1", 475 + 80, 240, "#FFF2B0", "1. 每周一至周五 20:00-22:00", 17)
    createRuleText(parent, "rule_2", 475 + 80, 216, "#FFF2B0", "2. 跨服1V1匹配，单局180秒", 17)
    createRuleText(parent, "rule_3", 475 + 80, 192, "#65FF6A", "3. 胜利：排位分+10，跨服积分+10", 17)
    createRuleText(parent, "rule_4", 475 + 80, 168, "#FF6A5F", "4. 失败：排位分+2，跨服积分+2", 17)
    createRuleText(parent, "rule_5", 475 + 80, 144, "#FFF2B0", "5. 周日24:00按排位分结算", 17)
    -- createRuleText(parent, "rule_6", 475, 120, "#F4D179", "排行奖励：1名100  2名80  3名70", 17)
    -- createRuleText(parent, "rule_7", 475, 96, "#F4D179", "4名60  5名50  6名40  7名30", 17)
    -- createRuleText(parent, "rule_8", 475, 72, "#F4D179", "8名25  9名20  10名15  10名后10", 17)
end


function npc.main(npcid, link, msg, data)
    if link == 0 then
        npc.data = decodeData(data)
        local parent = GUI:GetWindow(nil, "npc_"..npcid)
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_"..npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        -- local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651.png")
        -- GUI:setAnchorPoint(bjt, 0.5, 0.5)
        -- GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        -- GUI:setTouchEnabled(bjt, true)
        -- GUI:addOnClickEvent(bjt, function()
        --     GUI:Win_Close(parent)
        -- end)
        npc.bg = GUI:Image_Create(parent, "img_bj", 0.00, 0.00, "res/wy/public/kfdz_bj.png")
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        GUI:setAnchorPoint(GUI:Image_Create(npc.bg, 'tt', 540, 463, 'res/wy/public/kfdz_tt.png'), 0.5, 0.5)


        if msg == 1 then
            npc.but = GUI:Button_Create(npc.bg, "an1", 502.00, 39.00, "res/wy/public/kfdz_an2.png")
            GUI:addOnClickEvent(npc.but, function()
                SL:SendLuaNetMsg(100, npcid, 2, 0, "")
            end)
        elseif msg == 0 then
            npc.but = GUI:Button_Create(npc.bg, "an2", 502.00, 39.00, "res/wy/public/kfdz_an1.png")
            GUI:addOnClickEvent(npc.but, function()
                SL:SendLuaNetMsg(100, npcid, 1, 0, "")
            end)
        end



        GUI:Image_Create(npc.bg, 'kfdz_wz', 55, 340, 'res/wy/public/kfdz_wz.png')

        GUI:Text_Create(npc.bg, 'kfjf', 600, 305+32, 20, '#ffffff', '积分：'..npc.data.jf)
        GUI:Text_Create(npc.bg, 'kfpkcs', 600, 305, 20, '#FF00FF', '今日剩余进入pk队列次数：'.. ((8 - npc.data.cs) > 0  and (8 - npc.data.cs) or 0))
        renderRuleText(npc.bg)

        local kfzj_bj = GUI:Image_Create(npc.bg, 'kfzj_bj', 20, 0, 'res/wy/public/kfzj_bj.png')
        GUI:setAnchorPoint(GUI:Image_Create(kfzj_bj, 'tt', 262, 300, 'res/wy/public/kfzj_tt.png'), 0.5, 0.5)

        local jl = GUI:ListView_Create(kfzj_bj, "jl", 87.00, 40.00, 345.00, 200.00, 1)
        for i = 1, #npc.data.jl do
            local mz = nil
            if npc.data.jl[i][2] == "1" then
                mz = GUI:Image_Create(GUI:Image_Create(jl, 'kfzj_wz'..i, 0, 0, 'res/wy/public/kfzj_wz.png'), "jl", 100, 5, "res/wy/public/kfzj_w.png")
            else
                mz = GUI:Image_Create(GUI:Image_Create(jl, 'kfzj_wz'..i, 0, 0, 'res/wy/public/kfzj_wz.png'), "jl", 100, 5, "res/wy/public/kfzj_l.png")
            end
            GUI:setAnchorPoint(GUI:Text_Create(mz, "kfzj_mz"..i, 96, 5, 16, "#ffffff", npc.data.jl[i][1] == "" and "玩家" or npc.data.jl[i][1]),0.5,0)
        end

        npc.tip = GUI:Button_Create(npc.bg, "tip", 750.00, 39.00, "res/wy/public/kfdz_pm.png")
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(npc.tip, {onEnterFunc = function()
                openRankTip(npc.tip)
            end, onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end})
        else
            GUI:addOnClickEvent(npc.tip, function()
                openRankTip(npc.tip)
            end)
        end



        local close = GUI:Button_Create(npc.bg, 'close', 968, 437, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
    elseif link == 1 then
        removeNode(npc.but)
        npc.but = GUI:Button_Create(npc.bg, "an1", 502.00, 39.00, "res/wy/public/kfdz_an2.png")
        GUI:addOnClickEvent(npc.but, function()
            SL:SendLuaNetMsg(100, npcid, 2, 0, "")
        end)
    elseif link == 2 then
        removeNode(npc.but)
        npc.but = GUI:Button_Create(npc.bg, "an1", 502.00, 39.00, "res/wy/public/kfdz_an1.png")
        GUI:addOnClickEvent(npc.but, function()
            SL:SendLuaNetMsg(100, npcid, 1, 0, "")
        end)
    elseif link == 3 then
    elseif link == 4 then
        npc.data = decodeData(data)
        local parent = GUI:GetWindow(nil, "npc_"..npcid)
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("npc_"..npcid, cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Frames_Create(parent, "eff1",0, 0, "res/wy/eff/city/kfdz_dbj", ".png", 1, 15, {speed = 100, count = 15, loop = -1})
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Timeline_Window1(npc.bg)

        local weaponData = SL:GetMetaValue("ITEM_DATA", npc.data.weaponData) or nil
        local dressData = SL:GetMetaValue("ITEM_DATA",  npc.data.dressData) or nil
        local shieldData = SL:GetMetaValue("ITEM_DATA",  npc.data.shieldData) or nil
        local modelData = {}
        modelData = {
            clothID = dressData and dressData.Looks or nil,
            clothEffectID = dressData and dressData.sEffect or nil,
            weaponID = weaponData and weaponData.Looks or nil,
            weaponEffectID = weaponData and weaponData.sEffect or nil,
            shieldID = shieldData and shieldData.Looks or nil,
            shieldEffectID = shieldData and shieldData.sEffect or nil,
        }

        npc.djs = GUI:Frames_Create(npc.bg, "djs",483, 210, "res/wy/eff/city/djs_", ".png", 1, 41, {speed = 100, count = 41, loop = 1})
        GUI:setAnchorPoint(npc.djs, 0.5, 0.5)


        if dressData and dressData.shonourSell and tonumber(dressData.shonourSell) == 1 then
            modelData.notShowMold = true
            modelData.notShowHair = true
        end
        local UIModel = GUI:UIModel_Create(npc.bg, "UIMODEL", 783, 200, 0, modelData, nil, true)

        weaponData = getEquipItemData(1)
        dressData = getEquipItemData(0)
        shieldData = getEquipItemData(16)
        modelData = {}
        modelData = {
            clothID = dressData and dressData.Looks or nil,
            clothEffectID = dressData and dressData.sEffect or nil,
            weaponID = weaponData and weaponData.Looks or nil,
            weaponEffectID = weaponData and weaponData.sEffect or nil,
            shieldID = shieldData and shieldData.Looks or nil,
            shieldEffectID = shieldData and shieldData.sEffect or nil,
        }

        if dressData and dressData.shonourSell and tonumber(dressData.shonourSell) == 1 then
            modelData.notShowMold = true
            modelData.notShowHair = true
        end
        UIModel = GUI:UIModel_Create(npc.bg, "UIMODEL1", 214, 200, 0, modelData, nil, true)


        npc.dsq = SL:ScheduleOnce(function()
            GUI:Win_Close(parent)
        end, 4)
        SL:RegisterWndEvent(parent, "窗体注销", WND_EVENT_WND_DESTROY,
function()
            if npc.dsq then
                SL:UnSchedule(npc.dsq)
                npc.dsq = nil
            end
        end)

    end
end

return npc




