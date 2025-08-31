--npc加载
--npclib 渲染地址

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

}


SL:RegisterLuaNetMsg(100, function(msgID, p1, p2, p3, msgData)
    if cf_teshunpc[p1] then
        Npclib[cf_teshunpc[p1]].main(p1, p2, p3, msgData)
    elseif p1 > 200 and p1 < 400 then
        Npclib[1].main(p1, p2, p3, msgData)
	elseif p1 > 1000 then
		Npclib[701].main(p1, p2, p3, msgData)
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
    if p1 == 1 then  --初始化
        msgData = SL:JsonDecode(msgData, false)
        if  msgData.kqfz then
            cogin.sjtb.kqfz = msgData.kqfz
        end
        if msgData.rwid then
            if cogin.sjtb.rwid and cogin.sjtb.rwid ~= msgData.rwid then
                cogin.sjtb.rwid = msgData.rwid
            end
        end
        if msgData.ngkg then
            cogin.sjtb.ngkg = msgData.ngkg
        end
        if msgData.sczt then
            cogin.sjtb.sczt = msgData.sczt
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
        if msgData.zhuboma and msgData.zhuboma == 1 then
            cogin.sjtb.zhuboma = true
            Npclib["anniu"][1](0,0,"")     --按钮初始化
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


SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, "角色装备数据操作", function(data)

end)

SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_INITED, "玩家角色属性初始化完毕", function(data)
    Npclib["anniu"][1](2,0,"")
end)
SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, "切换地图(不同地图)", function(data)
end)

SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)

end)

SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "服务端属性下发",  function(data)
    --if data.key == "T14" then
    --    cogin.sjtb.bbsq = SL:JsonDecode(data.value, false)
    --end
end)