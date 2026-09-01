-- npc加载
-- npclib 渲染地址

Npclib = setmetatable({}, {
	__index = function(Npclib, key)
		local fun = SL:Require("GUILayout/npc/" .. key, true)
		if fun then
			rawset(Npclib, key, fun)
			return Npclib[key]
		else
			return nil
		end
	end
})

local cf_teshunpc = {
    [501] = 500, [502] = 500, [503] = 500, [504] = 500, [505] = 500, [506] = 500, [507] = 500, [508] = 500, [509] = 500, -- 世界地图
    [32] = 32, [33] = 32, [34] = 32, [35] = 32, [36] = 32, [37] = 32, [38] = 32, [39] = 32, [40] = 32,-- 转生
    [15] = 15,-- 狂暴
    [21] = 21,-- 境界修为
    [17] = 17,-- 货币兑换
    [44] = 44,-- 仙府
    [24] = 24,-- 天书
    [64] = 64,-- 灵兽
    [70] = 70, -- 狂魔乱舞
    [86] = 86, [87] = 86, [88] = 86, [89] = 86, [90] = 86, [91] = 86, -- 日卡秘境
    [93] = 93, -- 通天塔
    [105] = 105,
    [1011] = 1011, -- 武道大会/跨服PK
    [1002] = 1002,[1003] = 1003,[1004] = 1003,[1005] = 1003,[1006] = 1003,[1007] = 1003, -- 各大陆时装兑换
    -- [69] = 64, -- 神兽圣遗物 --这个是特殊的 前端不要的
    [6] = 6,[7] = 7,[8] = 8,[9] = 9,[10] = 10,[11] = 11,[13] = 13,[14] = 14,[24] = 24,[22] = 22,[43] = 43,[26] = 26,[28] = 28,[25] = 25,[54] = 54,[27] = 27,[44] = 44,[64] = 64,[65] = 65,[70] = 70,--小提升
    [1] = 6,[2] = 7,
    [101] = 101,
    [9998] = 9998, -- 改名卡界面
    [46] = 46, -- 灾厄入侵
    [1028] = 16, -- 沙巴克

}

local _tb_forbidden_anim_cfg = {
    [1] = { path = "res/custom/treasureBasin/eff/1/eff_", ext = ".png", count = 28,loop = 2,bg_eff = true, },
    [2] = { path = "res/custom/treasureBasin/eff/2/eff_", ext = ".png", count = 25,loop = 1,bg_eff = false, },
    [3] = { path = "res/custom/treasureBasin/eff/3/eff_", ext = ".PNG", count = 16,loop = 2,bg_eff = false, },
}

local function _playTreasureBasinForbiddenAnim(showId)
    if not GUI or type(GUI.Win_Create) ~= "function" or type(GUI.Frames_Create) ~= "function" then
        return
    end
    local cfg = _tb_forbidden_anim_cfg[tonumber(showId) or 0] or _tb_forbidden_anim_cfg[1]
    local parent = GUI:GetWindow(nil, "__tb_forbidden_anim__")
    if parent then
        GUI:removeAllChildren(parent)
    else
        parent = GUI:Win_Create("__tb_forbidden_anim__", 0, 0, 0, 0, false, false, true, true, true, nil, 999)
    end
    local sw = tonumber(cogin and cogin.w) or 1280
    local sh = tonumber(cogin and cogin.h) or 720
    if cfg.bg_eff then
        local bg_eff = GUI:Frames_Create(parent, "bg_eff", sw / 2, sh / 2, "res/custom/treasureBasin/eff/UI252/eff_", ".png", 1, 25, {
            speed = 100,
            count = 25,
            loop = -1,
        })
        GUI:setAnchorPoint(bg_eff, 0.5, 0.5)
        GUI:setContentSize(bg_eff, sw, sh)
    end
    local bg_eff = GUI:Frames_Create(parent, "bg_eff", sw / 2, sh / 2, "res/custom/treasureBasin/eff/UI252/eff_", ".png", 1, 25, {
        speed = 100,
        count = 25,
        loop = -1,
    })
    GUI:setAnchorPoint(bg_eff, 0.5, 0.5)
    GUI:setContentSize(bg_eff, sw, sh)
    local bg = GUI:Frames_Create(parent, "bg", sw / 2, sh / 2, cfg.path, cfg.ext, 1, cfg.count, {
        speed = 100,
        count = cfg.count,
        loop = cfg.loop or 1,
        callback = function()
            local win = GUI:GetWindow(nil, "__tb_forbidden_anim__")
            if win then
                GUI:Win_Close(win)
            end
        end
    })

    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setContentSize(bg, sw, sh)
    GUI:setTouchEnabled(bg, false)
end

local __tb_forbidden_anim_seq = 0
SL:RegisterLuaNetMsg(107, function(msgID, showId, animSeq, p3, msgData)
    showId = tonumber(showId) or 0
    animSeq = tonumber(animSeq) or 0
    if animSeq > 0 and animSeq == __tb_forbidden_anim_seq then
        return
    end
    __tb_forbidden_anim_seq = animSeq
    _playTreasureBasinForbiddenAnim(showId)
end)
SL:RegisterLuaNetMsg(100, function(msgID, p1, p2, p3, msgData)
    if cf_teshunpc[p1] then
        Npclib[cf_teshunpc[p1]].main(p1, p2, p3, msgData)
    elseif p1 > 200 and p1 < 500 then
        Npclib[200].main(p1, p2, p3, msgData)
    elseif p1 > 500 and p1 < 520 then
        Npclib[500].main(p1, p2, p3, msgData)
    else
        Npclib[p1].main(p1, p2, p3, msgData)
	end
end)

SL:RegisterLuaNetMsg(101, function(msgID, p1, p2, p3, msgData)
    if Npclib["anniu"][p1] then
        Npclib["anniu"][p1](p2,p3,msgData)
    end
end)

SL:RegisterLuaNetMsg(103, function(msgID, p1, p2, p3, msgData)
    if p1 == 1 then  -- 初始化
        msgData = SL:JsonDecode(msgData, false)
        if  msgData.kqfz then
            cogin.sjtb.kqfz = msgData.kqfz
        end
        if msgData.rwid then
            cogin.sjtb.rwid = msgData.rwid
            cogin.sjtb.zxrwid = msgData.rwid
            if MainAssist and type(MainAssist.UpdateCurrentXylTaskWidget) == "function" then
                MainAssist.UpdateCurrentXylTaskWidget()
                SL:ScheduleOnce(function()
                    if MainAssist and type(MainAssist.UpdateCurrentXylTaskWidget) == "function" then
                        MainAssist.UpdateCurrentXylTaskWidget()
                    end
                end, 0.05)
            end
            if (tonumber(msgData.rwid) or 0) >= 16 and Npclib["anniu"] and Npclib["anniu"][1] then
                -- 二大陆主线节点生效后，立即刷新快捷栏，显示“马上发财”按钮。
                Npclib["anniu"][1](0, 1, "")
            end
        end
        if msgData.ngkg then
            cogin.sjtb.ngkg = msgData.ngkg
        end
        if msgData.hqcs then
            cogin.sjtb.hqcs = msgData.hqcs
        end
        if msgData.xjn then
            cogin.sjtb.xjn = msgData.xjn
        end
        if msgData.zbfc then
            cogin.sjtb.zbfc = msgData.zbfc
        end
        if msgData.kqts then
            cogin.sjtb.kqts = msgData.kqts
        end
        if msgData.tsqb then
            cogin.sjtb.tsqb = msgData.tsqb
        end
        if msgData.U_dlxz_bc then
            cogin.sjtb.U_dlxz_bc = msgData.U_dlxz_bc
        end
        if msgData.dl_all_unlock then
            cogin.sjtb.dl_all_unlock = msgData.dl_all_unlock
            if Npclib["anniu"] and Npclib["anniu"].refreshWorldMap then
                Npclib["anniu"].refreshWorldMap()
            end
        end
        if msgData.zhuboma and msgData.zhuboma == 1 then
            cogin.sjtb.zhuboma = true
            Npclib["anniu"][1](0,0,"")     -- 按钮初始化
        end
    end
    SL:ScheduleOnce(function ()
        Npclib["anniu"][1](0,1,"")
    end, 3)
end)

SL:RegisterLuaNetMsg(105, function(msgID, p1, p2, p3, msgData)
    local parent = GUI:GetWindow(GUI:Attach_SceneB(), "bossInfo")
    if parent then
        GUI:removeAllChildren(parent)
    else
        parent = GUI:Node_Create(GUI:Attach_SceneB(), "bossInfo", 0, 0)
    end
    local monsters = SL:JsonDecode(msgData,false)
    if type(monsters) ~= "table" then
        return
    end
    for _, v in pairs(monsters) do
        local posM = SL:ConvertMapPos2WorldPos(tonumber(v.x) or 1, tonumber(v.y) or 1)
        local node = GUI:Node_Create(parent, string.format("boss_text%s_%s%s", v.name, posM.x, posM.y), posM.x, posM.y)
        GUI:Effect_Create(node, "effect", 0,0, 1, 220, 0, 0, 0, 1)
        local text = GUI:Text_Create(node, "bossName",-15,20, 16, "#00FF00", v.name)
        GUI:Text_setTextAreaSize(text, {width = 100, height = 20})
        GUI:Text_setTextHorizontalAlignment(text, 1)
        text = GUI:Text_Create(node, "downTime",-15,0, 16, "#ffffff", "")
        GUI:Text_setTextAreaSize(text, {width = 100, height = 20})
        GUI:Text_setTextHorizontalAlignment(text, 1)
        GUI:Text_COUNTDOWN(text, v.time, function ()
            GUI:removeFromParent(node)
        end)
    end
end)

SL:RegisterLuaNetMsg(6000, function(msgID, p1, p2, p3, msgData)
    Npclib["GMbox"]:OpenUI(p1, p2, p3, msgData)
end)

SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, "切换地图(不同地图)", function(data)
end)

SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)

end)

SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "服务端属性下发", function(data)

end)



---飞剑相关（临时关闭）
-- 命中目标上报接口先保留空实现，避免旧调用报错。
function SL:SubmitForm(msgName,...)
    return false
end

-- 加载相关 lua 文件
SL:Require("GUILayout/lib/ease",true)
SL:Require("GUILayout/ldUtil/init",true)
SL:Require("GUILayout/logic/SkillEffectLogic",true)
SL:Require("GUILayout/npc/upgrade_helper", true)



