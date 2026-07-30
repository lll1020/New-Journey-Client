local npc = {
}
local REWARD_ITEM_EFFECT_14193 = 14193
local REWARD_ITEM_EFFECT_13048 = 13048
local function _resolve_reward_effect_parent(parent)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local preferredNames = {"kuang", "box", "slot", "item_bg", "itemBg", "itembg", "frame", "bg"}
    for _, childName in ipairs(preferredNames) do
        local child = GUI:getChildByName(parent, childName)
        if child and not tolua.isnull(child) then
            return child
        end
    end
    return parent
end

local function _get_reward_layer(parent, layerName, zOrder)
    if not parent or tolua.isnull(parent) then
        return nil
    end
    local layer = GUI:getChildByName(parent, layerName)
    if not layer or tolua.isnull(layer) then
        layer = GUI:Node_Create(parent, layerName, 0, 0)
    end
    GUI:setLocalZOrder(layer, zOrder)
    return layer
end

local function _get_reward_item_layer(parent)
    return _get_reward_layer(parent, "item_layer", 20)
end

local function _raise_reward_count_text(textNode)
    if textNode and not tolua.isnull(textNode) then
        GUI:setLocalZOrder(textNode, 30)
    end
    return textNode
end

local function _raise_reward_item_icon(parent)
    if not parent or tolua.isnull(parent) then
        return
    end
    local itemLayer = GUI:getChildByName(parent, "item_layer")
    if itemLayer and not tolua.isnull(itemLayer) then
        GUI:setLocalZOrder(itemLayer, 20)
        parent = itemLayer
    end
    local item = GUI:getChildByName(parent, "item")
    if item and not tolua.isnull(item) then
        GUI:setLocalZOrder(item, 20)
    end
    for i = 1, 20 do
        local itemN = GUI:getChildByName(parent, "item" .. i)
        if itemN and not tolua.isnull(itemN) then
            GUI:setLocalZOrder(itemN, 20)
        end
    end
    for _, textName in ipairs({"count", "num", "sl", "xysl"}) do
        local textNode = GUI:getChildByName(parent, textName)
        _raise_reward_count_text(textNode)
    end
    for i = 1, 20 do
        local countN = GUI:getChildByName(parent, "count" .. i)
        _raise_reward_count_text(countN)
        local numN = GUI:getChildByName(parent, "num" .. i)
        _raise_reward_count_text(numN)
        local slN = GUI:getChildByName(parent, "sl" .. i)
        _raise_reward_count_text(slN)
        local xyslN = GUI:getChildByName(parent, "xysl" .. i)
        _raise_reward_count_text(xyslN)
    end
end

local function _add_reward_item_effect(parent, name, x, y, scale, effectId)
    local effectParent = _resolve_reward_effect_parent(parent)
    if not effectParent then
        return nil
    end
    local effectLayer = _get_reward_layer(effectParent, "effect_layer", 5) or effectParent
    local effect = GUI:Effect_Create(effectLayer, name or "reward_item_eff", x or 0, y or 0, 0, effectId or REWARD_ITEM_EFFECT_14193, 0, 0, 0, 1)
    GUI:setScale(effect, scale or 1)
    if effect then
        GUI:setLocalZOrder(effect, 1)
    end
    _raise_reward_item_icon(effectParent)
    return effect
end
local function _add_reward_effect_for_table(node, effectName, x, y, scale, effectId)
    if not node or tolua.isnull(node) then
        return
    end
    local listView = GUI:getChildByName(node, "cllist")
    if not listView or tolua.isnull(listView) then
        return
    end
    local children = GUI:getChildren(listView) or {
    }
    for _, child in pairs(children) do
        if child and not tolua.isnull(child) then
            _add_reward_item_effect(child, effectName, x, y, scale, effectId)
        end
    end
end
npc.iconpx = {
    {
        -- {15, "天天省钱",509,1}, {3, "福利大厅",511,2}, {17, "游戏攻略",512,3},{4, "活动大厅",507,4},{14, "首充礼包",501,5},{16, "仙途奇缘",515,515},{20, "护体光环",23,23},{21, "马上发财",31,31}
        {15, "天天省钱",509,1}, {3, "福利大厅",511,2}, {17, "游戏攻略",512,3},{4, "活动大厅",507,4},{14, "首充礼包",501,5},{21, "马上发财",31,31}
    },
    {
        -- {19, "在线充值", 502,11}, {5, "交易行",510,12},{2, "解绑特权",504,13},{7, "狂暴之力",513,14},{12, "世界地图",514,15},{10, "免费赞助",516,16},{22, "灵兽",64,64},{6, "聚宝盆",517,517},
        {19, "在线充值", 502,11}, {5, "交易行",510,12},{2, "解绑特权",504,13},{10, "免费赞助",516,16},{22, "灵兽",64,64},{6, "聚宝盆",517,517},
    }
}
npc.LeftTop = GUI:Attach_LeftTop()
npc.RightTop = GUI:Attach_RightTop()
npc.RightBottom = GUI:Attach_RightBottom()
npc.qiehuan = GUI:Win_FindParent(109)
npc.xinjn = GUI:Win_FindParent(1104)
npc.xinjn32 = GUI:Win_FindParent(1003)
npc.db_anniu = {
}
npc.db_shortcut_entries = {
}
npc._shortcut_collapsed = false
local zbz = {
}
npc.rw = {
}
npc.zjkmw_opt = {
    {-80, 500 - 85},
    {-80 - 80, 500 - 85 - 80 - 18},
}
npc.woodcut_doll = {
    tab = "doll_machine",
    payload = {doll = {}},
    lastResult = nil,
    skipAnim = false,
    reveal = nil,
}
local WINDOW_STYLE = {
    reward = {
        windowName = "npc_jiangli",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/01.png",
        },
        closeButton = false,
    },
    recycle = {
        windowName = "npc_huishou",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            x = -100,
            skin = "res/wy/public/hs_bj.png",
        },
        closeButton = {
            x = 840 - 293,
            y = 490 - 150,
            skin = "res/wy/public/red_close.png",
        },
    },
    welfare = {
        windowName = "npc_fldt",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/tongyong_0.png",
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
        title = {
            x = 56,
            y = 464,
            skin = "res/custom/fulitating/title.png",
        },
    },
    strategy = {
        windowName = "npc_yxgl",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/strategy/bg_0.png",
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
        title = {
            x = 56,
            y = 464,
            skin = "res/custom/strategy/title.png",
        },
    },
    firstCharge = {
        windowName = "npc_sclb",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/top/shochong/bg.png",
        },
        closeButton = {
            x = 740,
            y = 460 - 150,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    onlineRecharge = {
        windowName = "npc_zxcz",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/chongzhi/bg.png",
            eff = true,
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
        title = {
            x = 56,
            y = 464,
            skin = "res/custom/chongzhi/title.png",
        },
    },
    unbind = {
        windowName = "npc_jbtq",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/tongyong_0.png",
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    patrol = {
        windowName = "npc_mrtq",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/tongyong_0.png",
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    chosen = {
        windowName = "npc_txzz",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/activity/tx.png",
        },
        closeButton = {
            x = 800,
            y = 400,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    activity = {
        windowName = "npc_hd",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/activity/bg.png",
        },
        closeButton = {
            x = 780,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
        title = {
            x = 56,
            y = 464,
            skin = "res/custom/activity/title.png",
        },
    },
    recordStone = {
        windowName = "npc_jilushi",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/jys_bj.png",
        },
        closeButton = {
            x = 467,
            y = 449,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    storyLog = {
        windowName = "npc_ywl",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/ywl/bg.png",
        },
        closeButton = {
            x = 900,
            y = 500,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    newbieGift = {
        windowName = "npc_xslb",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/xinshoulibao/bg.png",
        },
        closeButton = {
            x = 740,
            y = 300,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    worldMap = {
        windowName = "npc_sjdt",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/102.png",
        },
        closeButton = {
            x = 330,
            y = 180,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    fairyFate = {
        windowName = "npc_qy",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/fairyFate/bg.png",
            eff = true,
        },
        closeButton = {
            x = 740,
            y = 460,
            skin = "res/wy/public/close_red_big.png",
        },
        title = {
            x = 56,
            y = 464,
            skin = "res/custom/fairyFate/title.png",
        },
    },
    freeSponsor = {
        windowName = "npc_anniu_516",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/mfzz/bg.png",
        },
        closeButton = {
            x = 740 + 76.0,
            y = 410,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    treasureBasin = {
        windowName = "npc_106_shortcut",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/wy/public/*.png",
        },
        closeButton = {
            x = 330,
            y = 180,
            skin = "res/wy/public/close_red_big.png",
        },
    },
    bodyAura = {
        windowName = "npc_23",
        overlay = {
            skin = "res/public/1900000651_1.png",
        },
        background = {
            skin = "res/custom/htgh/bg.png",
        },
        closeButton = {
            x = 875,
            y = 500,
            skin = "res/wy/public/close_red_big.png",
        },
    },
}
local windowCache = {
}
local function cloneTable(src)
    local dst = {
    }
    for k, v in pairs(src or {
    }) do
        dst[k] = type(v) == "table" and cloneTable(v) or v
    end
    return dst
end
local function mergeOptions(base, extra)
    local opts = cloneTable(base)
    for k, v in pairs(extra or {
    }) do
        if type(v) == "table" then
            opts[k] = cloneTable(v)
        else
            opts[k] = v
        end
    end
    return opts
end
local function ensureWindow(name, npcid, extraOpts)
    local opts = mergeOptions(WINDOW_STYLE[name], extraOpts)
    windowCache[name] = NPC_UI_HELPER.ensureWindow(windowCache[name], npcid or 0, opts)
    return windowCache[name]
end
local function closeActivityWindow()
    NPC_UI_HELPER.closeWindow(windowCache.activity)
    windowCache.activity = nil
end
local function openFirstChargeWelfareConfirm()
    SL:OpenCommonTipsPop({
        str = "你可以领取全部的限时福利了！无需等待！是否立即领取？",
        btnType = 2,
        callback = function(atype)
            if atype == 1 then
                NPC_UI_HELPER.closeWindow(windowCache.firstCharge)
                windowCache.firstCharge = nil
                SL:SendLuaNetMsg(105, 105, 105, 0, "")
            end
        end,
    })
end
-- 这两个快捷入口判定会在函数定义前被引用，先前置声明，避免运行时落到全局查找。
local _shortcut_is_firstcharge_completed
local _shortcut_is_unbind_completed
local function _shortcut_should_show_persistent_redpoint(cfg)
    local npcid = tonumber(cfg and cfg[3] or 0) or 0
    if npcid == 501 then
        return not _shortcut_is_firstcharge_completed()
    end
    if npcid == 504 then
        local totalCharge = tonumber(SL:GetMetaValue("MONEY", 23) or 0) or 0
        local realCharge = tonumber(SL:GetMetaValue("REAL_RECHARGE") or 0) or 0
        return math.max(totalCharge, realCharge) <= 0 and not _shortcut_is_unbind_completed()
    end
    return false
end
local function createShortcutButton(container, cfg, order, prefix, opts)
    opts = opts or {
    }
    local btnName = string.format("%s_%d", prefix, order)
    local posX = tonumber(opts.x) or (498 - 80 * order)
    local posY = tonumber(opts.y) or 0
    local button = GUI:Button_Create(container, btnName, posX, posY, "res/wy/icon/top_" .. cfg[1] .. ".png")
    local keepRedPoint = _shortcut_should_show_persistent_redpoint(cfg)
    if tonumber(cfg[3]) == 517 then
        local helper = SL:Require("GUILayout/npc/upgrade_helper", true)
        local state = helper and helper.treasureBasinRedState and helper.treasureBasinRedState()
        keepRedPoint = state and state.any == true
    end
    GUI:addOnClickEvent(button, function()
        if tonumber(cfg[3]) == 1029 then
            SL:SendLuaNetMsg(105, cfg[3], 1029, 0, "")
            if not keepRedPoint then
                GUI:removeAllChildren(button)
            end
            return
        end
        if tonumber(cfg[3]) == 517 then
            SL:SendLuaNetMsg(101, 517, 0, 0, "")
            if not keepRedPoint then
                GUI:removeAllChildren(button)
            end
            return
        end
        SL:SendLuaNetMsg(101, cfg[3], 0, 0, "")
        if not keepRedPoint then
            GUI:removeAllChildren(button)
        end
    end)
    if keepRedPoint then
        NPC_UI_HELPER.redpoint_create_eff(button, {
            x = 80,
            y = 60,
        })
    end
    local cacheMap = opts.cacheMap or npc.db_anniu
    cacheMap["" .. cfg[4]] = button
    return button
end
local function _shortcut_has_title(titleName)
    if not titleName or titleName == "" then
        return false
    end
    local titleList = {
        tostring(titleName or ""),
    }
    if string.find(titleName, "%[称号%]") then
        titleList[#titleList + 1] = string.gsub(titleName, "%[称号%]$", "")
    else
        titleList[#titleList + 1] = tostring(titleName) .. "[称号]"
    end
    local used = {
    }
    for _, oneName in ipairs(titleList) do
        if oneName ~= "" and not used[oneName] then
            used[oneName] = true
            local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", oneName) or 0) or 0
            if idx > 0 and SL:GetMetaValue("TITLE_DATA_BY_ID", idx) ~= nil then
                return true
            end
        end
    end
    return false
end
local function _shortcut_get_server_json(varName)
    if varName == "T50" and type(rawget(_G, "NPC64_LAST_T_DATA")) == "table" then
        return rawget(_G, "NPC64_LAST_T_DATA")
    end
    if not Player or not Player.getServerVar or not Player.JsonToTbl then
        return {
        }
    end
    local raw = Player:getServerVar(varName)
    if not raw or raw == "" then
        return {
        }
    end
    local data = Player:JsonToTbl(raw)
    return type(data) == "table" and data or {
    }
end
local function _shortcut_get_firstcharge_state()
    local T_data = npc.data_501 and npc.data_501.T_data
    if type(T_data) == "table" and next(T_data) ~= nil then
        return T_data
    end
    return _shortcut_get_server_json("T39")
end
local function _shortcut_is_freesponsor_completed()
    local cfg = teshudata and teshudata["anniu_516"]
    local details = cfg and cfg.details or {
    }
    if #details <= 0 then
        return false
    end
    if npc.data_516 and npc.data_516.T_data then
        local allDone = true
        for i = 1, #details do
            local flag = npc.data_516.T_data["zzlb_" .. i]
            if not (flag == true or tonumber(flag or 0) == 1) then
                allDone = false
                break
            end
        end
        if allDone then
            return true
        end
    end
    local finalTitle = details[#details] and details[#details].ch
    return _shortcut_has_title(finalTitle)
end
_shortcut_is_firstcharge_completed = function()
    local T_data = _shortcut_get_firstcharge_state()
    local mainClaimed = tonumber(T_data["main_claimed"] or T_data["other_lb"] or T_data["_lb"] or 0) or 0
    if mainClaimed >= 1 then
        return true
    end
    local cfg = teshudata and teshudata["anniu_501"] or {
    }
    local finalTitle = tostring(cfg.final_title or cfg.ch or "")
    if finalTitle ~= "" and _shortcut_has_title(finalTitle) then
        return true
    end
    return false
end
local function _shortcut_is_kuangbao_completed()
    local cfg = teshudata and teshudata["npc_15"]
    local titleName = cfg and cfg.give and cfg.give.ch or "狂暴之力"
    return _shortcut_has_title(titleName)
end
local function _feijian_has_main_buff(buffId)
    local actorId = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not actorId then
        return false
    end
    return SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", actorId, buffId) ~= nil
end
local function _feijian_get_buff_left_seconds(buffId)
    local actorId = SL:GetMetaValue("MAIN_ACTOR_ID")
    if not actorId then
        return nil
    end
    local buffData = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", actorId, buffId)
    if type(buffData) ~= "table" then
        return nil
    end
    local now = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0
    local function _to_left_by_abs(ts)
        local t = tonumber(ts)
        if not t then
            return nil
        end
        if now > 0 and t > now then
            return math.max(math.floor(t - now), 0)
        end
        return nil
    end
    local function _to_left_by_sec(secOrTs)
        local v = tonumber(secOrTs)
        if not v then
            return nil
        end
        if now > 0 and v > now then
            return math.max(math.floor(v - now), 0)
        end
        if v > 0 then
            return math.max(math.floor(v), 0)
        end
        return nil
    end
    local absKeys = {
        "endTime",
        "end_time",
        "expireTime",
        "expire_time",
        "overTime",
    }
    for _, key in ipairs(absKeys) do
        local left = _to_left_by_abs(buffData[key])
        if left and left >= 0 then
            return left
        end
    end
    local secKeys = {
        "left",
        "leftTime",
        "left_time",
        "remain",
        "remainTime",
        "remain_time",
        "time",
        "duration",
    }
    for _, key in ipairs(secKeys) do
        local left = _to_left_by_sec(buffData[key])
        if left and left >= 0 then
            return left
        end
    end
    return nil
end
local function _feijian_format_left_seconds(seconds)
    local left = math.max(tonumber(seconds) or 0, 0)
    if SL.TimeFormatToStr then
        local ok, result = pcall(function()
            return SL:TimeFormatToStr(left)
        end)
        if ok and result and result ~= "" then
            return result
        end
    end
    local h = math.floor(left / 3600)
    local m = math.floor((left % 3600) / 60)
    local s = math.floor(left % 60)
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end
_shortcut_is_unbind_completed = function()
    if npc.kryb and tonumber(npc.kryb.mztq or 0) == 1 then
        return true
    end
    local cfg = teshudata and teshudata["anniu_504"]
    local titleName = (cfg and cfg.ch) or "超级特权"
    return _shortcut_has_title(titleName)
end
local HUTI_CARD_CFG = {
    [1] = {
        name = "攻击",
        effect = "每3刀额外造成1000伤害",
        need = "转生等级达到10级",
        lockedTip = "需要转生等级达到10级",
    },
    [2] = {
        name = "防御",
        effect = "每3刀额外造成888伤害",
        need = "领取首充礼包",
        lockedTip = "需要先领取首充礼包",
    },
    [3] = {
        name = "斩杀",
        effect = "每3刀额外造成1000伤害",
        need = "购买超级特权",
        lockedTip = "需要先激活超级特权",
    },
}
local function _huti_get_server_data()
    return type(npc.data_23) == "table" and npc.data_23 or {
    }
end
local function _huti_get_aura_info(idx)
    local data = _huti_get_server_data()
    local aura = type(data.aura) == "table" and data.aura or {
    }
    local info = aura[idx] or aura[tostring(idx)]
    return type(info) == "table" and info or {
    }
end
local function _huti_get_local_open_flag(idx)
    if idx == 1 then
        return (tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0) >= 1
    end
    if idx == 2 then
        return _shortcut_is_firstcharge_completed()
    end
    if idx == 3 then
        return _shortcut_is_unbind_completed()
    end
    return false
end
local function _huti_is_open(idx)
    local info = _huti_get_aura_info(idx)
    local localOpen = _huti_get_local_open_flag(idx)
    if info.open ~= nil then
        return tonumber(info.open or 0) == 1 or localOpen == true
    end
    return localOpen
end
local function _huti_get_active_idx()
    local data = _huti_get_server_data()
    local active = tonumber(data.active or 0) or 0
    if active >= 1 and active <= 3 then
        return active
    end
    for idx = 1, 3 do
        local info = _huti_get_aura_info(idx)
        if tonumber(info.active or 0) == 1 then
            return idx
        end
    end
    return 0
end
local function _shortcut_is_body_aura_completed()
    for idx = 1, 3 do
        if not _huti_is_open(idx) then
            return false
        end
    end
    return true
end
local function _shortcut_is_current_xyl_task(taskName)
    local current = tostring(rawget(_G, "XYL_CURRENT_TASK_NAME") or "")
    if current == "" then
        return false
    end
    local function normalize(name)
        local value = tostring(name or "")
        value = value:gsub("%s+", "")
        value = value:gsub("（.-）", "")
        value = value:gsub("%(.-%)", "")
        return value
    end
    return normalize(current) == normalize(taskName)
end
local function _shortcut_has_reached_xyl_task(taskName)
    taskName = tostring(taskName or "")
    if taskName == "" then
        return false
    end
    local cur = tostring((npc.current_ywl_task and (npc.current_ywl_task.dq or npc.current_ywl_task.current_xyl_dq or npc.current_ywl_task.currentXylDq)) or "")
    if cur == "" then
        local ywlData = (npc.data and npc.data.ywl) or _shortcut_get_server_json("T26")
        cur = tostring(ywlData and ywlData.dq or "")
    end
    local ci, cj, cz = cur:match("^(%d+)_(%d+)_(%d+)$")
    ci, cj, cz = tonumber(ci), tonumber(cj), tonumber(cz)
    if not (ci and cj and cz) then
        return _shortcut_is_current_xyl_task(taskName)
    end
    for i, lCfg in ipairs(npc.xyl or {}) do
        for j, zCfg in ipairs(lCfg or {}) do
            for z, task in ipairs((zCfg and zCfg.jq) or {}) do
                if tostring(task and task[1] or "") == taskName then
                    if ci > i then return true end
                    if ci == i and cj > j then return true end
                    if ci == i and cj == j and cz >= z then return true end
                    return false
                end
            end
        end
    end
    return _shortcut_is_current_xyl_task(taskName)
end
local function _shortcut_get_mainline_rwid()
    local rwid = math.max(
        tonumber(cogin and cogin.sjtb and cogin.sjtb.zxrwid or 0) or 0,
        tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid or 0) or 0
    )
    if rwid <= 0 and Player and type(Player.getServerVar) == "function" then
        rwid = tonumber(Player:getServerVar("U11") or 0) or 0
    end
    return rwid
end
local function _shortcut_should_show_pet_contract()
    if rawget(_G, "NPC64_HIDE_CONTRACT_SHORTCUT") == true then
        return false
    end
    local data = _shortcut_get_server_json("T50")
    local battlePet = tonumber(data.dqzh or 0) or 0
    if battlePet > 0 then
        return false
    end
    if _shortcut_get_mainline_rwid() >= 28 then
        return true
    end
    return _shortcut_has_reached_xyl_task("灵兽孵化")
end
local function _huti_get_card_states()
    local result = {
    }
    local activeIdx = _huti_get_active_idx()
    for idx, cfg in ipairs(HUTI_CARD_CFG) do
        local info = _huti_get_aura_info(idx)
        local canActivate = _huti_is_open(idx)
        local active = activeIdx == idx or tonumber(info.active or 0) == 1
        result[idx] = {
            idx = idx,
            name = cfg.name,
            effect = cfg.effect,
            need = cfg.need,
            lockedTip = cfg.lockedTip,
            canActivate = canActivate,
            active = active == true,
            visible = active == true,
        }
    end
    return result
end
local function _shortcut_should_show(cfg)
    local npcid = tonumber(cfg and cfg[3] or 0)
    if npcid == 31 then
        -- 马上发财：二大陆主线阶段（rwid >= 16）后才显示快捷按钮。
        return (tonumber(cogin and cogin.sjtb and cogin.sjtb.rwid) or 0) >= 16
    end
    if npcid == 516 then
        return not _shortcut_is_freesponsor_completed()
    end
    if npcid == 501 then
        return not _shortcut_is_firstcharge_completed()
    end
    if npcid == 513 then
        return not _shortcut_is_kuangbao_completed()
    end
    if npcid == 23 then
        return not _shortcut_is_body_aura_completed()
    end
    if npcid == 517 then
        local data = _shortcut_get_server_json("T44")
        return (tonumber(data.task_fixed or 0) or 0) >= 1 or _shortcut_get_mainline_rwid() >= 24
    end
    if npcid == 504 then
        return not _shortcut_is_unbind_completed()
    end
    if npcid == 64 then
        return false
    end
    return true
end
local function _format_pet_countdown(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    if h > 0 then
        return string.format("%02d:%02d:%02d", h, m, s)
    end
    return string.format("%02d:%02d", m, s)
end
local function _get_lingshou_main_data()
    local data = rawget(_G, "NPC64_LAST_T_DATA")
    if type(data) ~= "table" then
        data = _shortcut_get_server_json("T50")
    end
    data.hatch = type(data.hatch) == "table" and data.hatch or {}
    return data
end
local function _is_activity_rank_window_visible()
    local panel = MainAssist and MainAssist._ui and MainAssist._ui["Panel_hide"]
    if not panel or tolua.isnull(panel) then
        return false
    end
    local win = GUI:getChildByName(panel, "tyec_bj")
    return win and not tolua.isnull(win)
end
local function _should_show_lingshou_main_entry(data)
    data = data or _get_lingshou_main_data()
    if rawget(_G, "NPC64_HIDE_CONTRACT_SHORTCUT") == true then
        return false
    end
    if _is_activity_rank_window_visible() then
        return false
    end
    if (tonumber(data.dqzh or 0) or 0) > 0 then
        return false
    end
    if npc._force_show_lingshou_main_entry == true then
        return true
    end
    local choice = tonumber(data.baby_choice or 0) or 0
    if choice > 0 then
        local hatch = data.hatch and data.hatch[tostring(choice)] or nil
        local status = tostring(hatch and hatch.status or "")
        if status == "hatching" then
            return true
        end
        if status == "done" or (tonumber((data.ls or {})[tostring(choice)] or 0) or 0) > 0 then
            return false
        end
        return true
    end
    return false
end
local function _get_lingshou_hatch_left(data)
    data = data or _get_lingshou_main_data()
    local choice = tonumber(data.baby_choice or 0) or 0
    local hatch = choice > 0 and data.hatch and data.hatch[tostring(choice)] or nil
    local expireAt = tonumber(hatch and hatch.expireAt or 0) or 0
    if expireAt <= 0 then
        return nil
    end
    return math.max(0, expireAt - os.time())
end
local function _open_lingshou_contract_entry()
    rawset(_G, "NPC64_OPEN_CONTRACT_ONCE", true)
    SL:SendLuaNetMsg(105, 1029, 1029, 0, "")
end
npc.refreshLingshouMainEntry = function()
    if not npc.LeftTop or tolua.isnull(npc.LeftTop) then
        return
    end
    if rawget(_G, "NPC64_HIDE_CONTRACT_SHORTCUT") == true then
        npc._lingshou_main_render_sig = nil
        if npc.lingshou_main_entry and not tolua.isnull(npc.lingshou_main_entry) then
            GUI:removeFromParent(npc.lingshou_main_entry)
        end
        npc.lingshou_main_entry = nil
        npc.lingshou_main_button = nil
        return
    end
    local data = _get_lingshou_main_data()
    local hasBabyChoice = (tonumber(data.baby_choice or 0) or 0) > 0
    if npc._lingshou_main_guiding == true then
        if not hasBabyChoice then
            return
        end
        npc._lingshou_main_guiding = nil
    end
    local left = _get_lingshou_hatch_left(data)
    local showEntry = _should_show_lingshou_main_entry(data)
    local choice = tonumber(data.baby_choice or 0) or 0
    local hatch = choice > 0 and data.hatch and data.hatch[tostring(choice)] or nil
    local expireAt = tonumber(hatch and hatch.expireAt or 0) or 0
    local isDoneToDeploy = choice > 0 and hatch and hatch.status == "done" and (tonumber((data.ls or {})[tostring(choice)] or 0) or 0) <= 0
    local activityRankVisible = _is_activity_rank_window_visible()
    local renderSig = string.format("%s|%s|%s|%s|%s|%s",
        tostring(showEntry),
        tostring(tonumber(data.dqzh or 0) or 0),
        tostring(choice),
        tostring(left == nil and "nil" or (left > 0 and "countdown" or "ready")),
        tostring(expireAt),
        tostring(activityRankVisible)
    )
    if npc._lingshou_main_render_sig == renderSig
        and npc.lingshou_main_entry
        and not tolua.isnull(npc.lingshou_main_entry)
        and showEntry then
        return
    end
    npc._lingshou_main_render_sig = renderSig
    if npc.lingshou_main_entry and not tolua.isnull(npc.lingshou_main_entry) then
        GUI:removeFromParent(npc.lingshou_main_entry)
    end
    npc.lingshou_main_entry = nil
    npc.lingshou_main_button = nil
    if not showEntry then
        return
    end
    if not npc.LeftTop or tolua.isnull(npc.LeftTop) then
        return
    end
    local oldEntry = GUI:getChildByName(npc.LeftTop, "lingshou_main_entry")
    if oldEntry and not tolua.isnull(oldEntry) then
        GUI:removeFromParent(oldEntry)
    end
    local node = GUI:Layout_Create(npc.LeftTop, "lingshou_main_entry", 330 - 110, -195, 90, 100, false)
    if not node or tolua.isnull(node) then
        return
    end
    npc.lingshou_main_entry = node
    local btn = GUI:Button_Create(node, "button", 0, 0, "res/wy/icon/lignshou.png")
    if not btn or tolua.isnull(btn) then
        return
    end
    GUI:setScale(btn, 0.7)
    npc.lingshou_main_button = btn
    GUI:addOnClickEvent(btn, function()
        npc._force_show_lingshou_main_entry = nil
        _open_lingshou_contract_entry()
    end)
    if left ~= nil and left > 0 then
        local cd = nil
        if node and not tolua.isnull(node) then
            cd = GUI:Text_Create(node, "countdown", (145 * 0.7) / 2, 0, 13, "#45FF93", _format_pet_countdown(left))
        end
        if cd and not tolua.isnull(cd) then
            GUI:setAnchorPoint(cd, 0.5, 0.5)
            GUI:Text_enableOutline(cd, "#000000", 1)
            GUI:Text_COUNTDOWN(cd, left, function()
                if npc.refreshLingshouMainEntry then
                    npc._lingshou_main_render_sig = nil
                    npc.refreshLingshouMainEntry()
                end
            end)
        end
    elseif left ~= nil or isDoneToDeploy then
        NPC_UI_HELPER.redpoint_create_eff(btn, {
            x = 76 + 53 + 10,
            y = 70 + 29 + 10,
        })
    end
end
local function refreshLingshouMainEntrySoon()
    if npc.refreshLingshouMainEntry then
        npc.refreshLingshouMainEntry()
        SL:ScheduleOnce(function()
            if npc.refreshLingshouMainEntry then
                npc.refreshLingshouMainEntry()
            end
        end, 0.1)
        SL:ScheduleOnce(function()
            if npc.refreshLingshouMainEntry then
                npc.refreshLingshouMainEntry()
            end
        end, 0.6)
        SL:ScheduleOnce(function()
            if npc.refreshLingshouMainEntry then
                npc.refreshLingshouMainEntry()
            end
        end, 1.5)
    end
end
local function requestLingshouMainDataOnce()
    if npc._lingshou_main_data_requested then
        return
    end
    if _shortcut_get_mainline_rwid() < 28 and not _shortcut_has_reached_xyl_task("灵兽孵化") then
        return
    end
    npc._lingshou_main_data_requested = true
    rawset(_G, "NPC64_SILENT_SYNC_ONLY", true)
    SL:SendLuaNetMsg(100, 64, 8, 0, "")
    SL:ScheduleOnce(function()
        if rawget(_G, "NPC64_SILENT_SYNC_ONLY") then
            rawset(_G, "NPC64_SILENT_SYNC_ONLY", nil)
        end
    end, 3)
end
local function startLingshouMainEntryLoginRefresh()
    if npc._lingshou_login_refresh_started then
        return
    end
    npc._lingshou_login_refresh_started = true
    local checks = 0
    local function tick()
        checks = checks + 1
        if type(rawget(_G, "NPC64_LAST_T_DATA")) ~= "table" then
            requestLingshouMainDataOnce()
        end
        refreshLingshouMainEntrySoon()
        local data = _get_lingshou_main_data()
        if _get_lingshou_hatch_left(data) ~= nil or checks >= 12 then
            return
        end
        SL:ScheduleOnce(tick, 1)
    end
    SL:ScheduleOnce(tick, 0.2)
end
local function startLingshouMainGuide(retryCount)
    npc._force_show_lingshou_main_entry = true
    if npc.refreshLingshouMainEntry then
        npc.refreshLingshouMainEntry()
    end
    if not npc.lingshou_main_button or tolua.isnull(npc.lingshou_main_button) then
        retryCount = tonumber(retryCount or 0) or 0
        if retryCount > 0 then
            SL:ScheduleOnce(function()
                startLingshouMainGuide(retryCount - 1)
            end, 0.2)
        end
        return false
    end
    local guideParent = GUI:getParent(npc.lingshou_main_button) or npc.LeftTop
    npc._lingshou_main_guiding = true
    NPC_UI_HELPER.startGuide({
        dir = 3,
        guideWidget = npc.lingshou_main_button,
        guideParent = guideParent,
        guideDesc = "点击领取灵兽蛋",
        isForce = false,
        hideMask = false,
    })
    GUI:Timeline_FadeIn(npc.lingshou_main_button, 0.2)
    SL:ScheduleOnce(function()
        npc._lingshou_main_guiding = nil
    end, 1)
    return true
end
local SHORTCUT_COLLAPSED_SHOW_COUNT = 3
local SHORTCUT_COLLAPSED_PREVIEW_NPC = {
    511,
    514,
    502,
}
local function _get_visible_shortcut_list()
    local result = {
    }
    for _, row in ipairs(npc.iconpx or {
    }) do
        for _, cfg in ipairs(row or {
        }) do
            if _shortcut_should_show(cfg) then
                table.insert(result, cfg)
            end
        end
    end
    return result
end
local function _get_collapsed_preview_shortcut_list()
    local preview = {
    }
    local used = {
    }
    for _, targetNpcId in ipairs(SHORTCUT_COLLAPSED_PREVIEW_NPC) do
        for _, row in ipairs(npc.iconpx or {
        }) do
            for _, cfg in ipairs(row or {
            }) do
                if tonumber(cfg and cfg[3]) == tonumber(targetNpcId) and not used[targetNpcId] then
                    table.insert(preview, cfg)
                    used[targetNpcId] = true
                    break
                end
            end
            if used[targetNpcId] then
                break
            end
        end
    end
    if #preview >= SHORTCUT_COLLAPSED_SHOW_COUNT then
        return preview
    end
    for _, cfg in ipairs(_get_visible_shortcut_list()) do
        local npcid = tonumber(cfg and cfg[3])
        if npcid and not used[npcid] then
            table.insert(preview, cfg)
            used[npcid] = true
            if #preview >= SHORTCUT_COLLAPSED_SHOW_COUNT then
                break
            end
        end
    end
    return preview
end
local function _get_collapsed_shortcut_target(index)
    return {
        x = 418 - (index - 1) * 80,
        y = 70,
    }
end
local function _set_shortcut_entry_visible(entry, visible)
    if not (entry and entry.button) then
        return
    end
    GUI:setVisible(entry.button, visible == true)
    GUI:setTouchEnabled(entry.button, visible == true)
end
local function _refresh_shortcut_collapsed_state(withAnim)
    if not npc.dbLayout or not npc.dbshousuo then
        return
    end
    GUI:setFlippedX(npc.dbshousuo, npc._shortcut_collapsed == true)
    GUI:setPosition(npc.dbLayout, zbz[1], zbz[2])
    if npc._shortcut_collapsed then
        local keepList = _get_collapsed_preview_shortcut_list()
        local keepMap = {
        }
        for index, cfg in ipairs(keepList) do
            local key = tostring(cfg and cfg[4] or "")
            if key ~= "" then
                keepMap[key] = index
            end
        end
        for _, entry in ipairs(npc.db_shortcut_entries or {
        }) do
            local key = tostring(entry and entry.key or "")
            local keepIndex = keepMap[key]
            if keepIndex then
                local target = _get_collapsed_shortcut_target(keepIndex)
                _set_shortcut_entry_visible(entry, true)
                GUI:stopAllActions(entry.button)
                if withAnim ~= false then
                    GUI:Timeline_EaseSineIn_MoveTo(entry.button, {
                        x = target.x,
                        y = target.y,
                    }, 0.2)
                    GUI:Timeline_FadeIn(entry.button, 0.2)
                else
                    GUI:setPosition(entry.button, target.x, target.y)
                    GUI:setOpacity(entry.button, 255)
                end
            else
                GUI:stopAllActions(entry.button)
                if withAnim ~= false then
                    GUI:Timeline_EaseSineIn_MoveTo(entry.button, {
                        x = entry.originX + 50,
                        y = entry.originY,
                    }, 0.18)
                    GUI:Timeline_FadeOut(entry.button, 0.18, function()
                        _set_shortcut_entry_visible(entry, false)
                        GUI:setPosition(entry.button, entry.originX, entry.originY)
                        GUI:setOpacity(entry.button, 255)
                    end)
                else
                    _set_shortcut_entry_visible(entry, false)
                    GUI:setPosition(entry.button, entry.originX, entry.originY)
                    GUI:setOpacity(entry.button, 255)
                end
            end
        end
    else
        for _, entry in ipairs(npc.db_shortcut_entries or {
        }) do
            _set_shortcut_entry_visible(entry, true)
            GUI:stopAllActions(entry.button)
            if withAnim ~= false then
                GUI:Timeline_EaseSineIn_MoveTo(entry.button, {
                    x = entry.originX,
                    y = entry.originY,
                }, 0.2)
                GUI:Timeline_FadeIn(entry.button, 0.2)
            else
                GUI:setPosition(entry.button, entry.originX, entry.originY)
                GUI:setOpacity(entry.button, 255)
            end
        end
    end
end
local function _build_shortcut_render_signature()
    local parts = {
    }
    local count = 0
    for rowIndex, row in ipairs(npc.iconpx or {
    }) do
        for _, cfg in ipairs(row or {
        }) do
            if _shortcut_should_show(cfg) then
                local extraState = ""
                if tonumber(cfg[3] or 0) == 64 then
                    local petData = _shortcut_get_server_json("T50")
                    extraState = table.concat({
                        tostring(_shortcut_get_mainline_rwid()),
                        tostring(petData.dqzh or 0),
                        tostring(petData.baby_choice or 0),
                    }, ",")
                end
                count = count + 1
                parts[#parts + 1] = table.concat({
                    rowIndex,
                    tostring(cfg[1] or ""),
                    tostring(cfg[2] or ""),
                    tostring(cfg[3] or ""),
                    tostring(cfg[4] or ""),
                    _shortcut_should_show_persistent_redpoint(cfg) and "1" or "0",
                    extraState,
                }, ":")
            end
        end
    end
    return table.concat(parts, "|"), count
end
local function rebuildShortcutButtons(filterKey)
    if not npc.dbLayout then
        return
    end
    local signature, visibleCount = _build_shortcut_render_signature()
    if npc._shortcut_render_signature == signature and #(npc.db_shortcut_entries or {
    }) == visibleCount then
        _refresh_shortcut_collapsed_state(false)
        return
    end
    GUI:removeAllChildren(npc.dbLayout)
    npc.db_anniu = {
    }
    npc.db_shortcut_entries = {
    }
    local function renderRow(list, rowY, prefix)
        local order = 1
        for _, cfg in ipairs(list) do
            if _shortcut_should_show(cfg) then
                local posX = 498 - 70 * order
                local posY = rowY
                local button = createShortcutButton(npc.dbLayout, cfg, order, prefix, {
                    x = posX,
                    y = posY,
                })
                table.insert(npc.db_shortcut_entries, {
                    key = cfg[4],
                    cfg = cfg,
                    button = button,
                    originX = posX,
                    originY = posY,
                })
                order = order + 1
            end
        end
    end
    renderRow(npc.iconpx[1], 70, "anniu_1")
    renderRow(npc.iconpx[2], -10, "anniu_2")
    npc._shortcut_render_signature = signature
    _refresh_shortcut_collapsed_state(false)
end
npc.removeShortcutByNpcId = function(npcid)
    npcid = tonumber(npcid)
    if not npcid then
        return
    end
    if npc.db_anniu then
        for key, button in pairs(npc.db_anniu) do
            local matched = false
            for _, row in ipairs(npc.iconpx or {}) do
                for _, cfg in ipairs(row or {}) do
                    if tostring(cfg and cfg[4] or "") == tostring(key) and tonumber(cfg and cfg[3] or 0) == npcid then
                        matched = true
                        break
                    end
                end
                if matched then
                    break
                end
            end
            if matched then
                pcall(function()
                    GUI:removeFromParent(button)
                end)
                npc.db_anniu[key] = nil
            end
        end
    end
    if npc.db_shortcut_entries then
        for i = #npc.db_shortcut_entries, 1, -1 do
            local entry = npc.db_shortcut_entries[i]
            if tonumber(entry and entry.cfg and entry.cfg[3] or 0) == npcid then
                pcall(function()
                    GUI:removeFromParent(entry.button)
                end)
                table.remove(npc.db_shortcut_entries, i)
            end
        end
    end
    npc._shortcut_render_signature = nil
    if npc.dbLayout then
        rebuildShortcutButtons("")
    end
end
-- 按 NPCID 从顶部快捷栏缓存中查找按钮，用于异闻录任务引导直接指向顶部入口。
local function findShortcutButtonByNpcId(npcid)
    npcid = tonumber(npcid)
    for _, entry in ipairs(npc.db_shortcut_entries or {}) do
        if tonumber(entry.cfg and entry.cfg[3] or 0) == npcid then
            return entry.button
        end
    end
    return nil
end
local function registerShortcutTitleRefresh()
    if npc._shortcut_title_refresh_registered then
        return
    end
    npc._shortcut_title_refresh_registered = true
    local function _refresh_shortcut()
        if npc._shortcut_refresh_pending or not npc.dbLayout then
            return
        end
        npc._shortcut_refresh_pending = true
        SL:ScheduleOnce(function()
            npc._shortcut_refresh_pending = false
            if npc.dbLayout then
                rebuildShortcutButtons("")
            end
            refreshLingshouMainEntrySoon()
        end, 0)
    end
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, "anniu_shortcut_title_refresh_prop", _refresh_shortcut)
    SL:RegisterLUAEvent(LUA_EVENT_SERVER_VALUE_CHANGE, "anniu_shortcut_title_refresh_server", _refresh_shortcut)
    SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "anniu_shortcut_title_refresh_buff", _refresh_shortcut)
    SL:RegisterLUAEvent(LUA_EVENT_MAPINFOCHANGE, "anniu_shortcut_title_refresh_map", _refresh_shortcut)
end
local UPGRADE_HELPER = SL:Require("GUILayout/npc/upgrade_helper", true)
if cogin.isWin32 then
    zbz = {
        -700,
        -150,
        200,
        -180,
        -70,
    }
else
    zbz = {
        -700,
        -150,
        200,
        -170,
        -70,
    }
end
local function ensureTopPanelExpanded()
    if npc.dbshousuo and npc._shortcut_collapsed then
        npc._shortcut_collapsed = false
        _refresh_shortcut_collapsed_state(false)
    end
end
local function openClientBagForGuide()
    SL:JumpTo(7)
    SL:OpenBagUI()
    SL:ScheduleOnce(function()
        SL:RefreshBagPos()
        SL:OpenBagUI()
    end, 0.1)
end
local function startGuideOnButton(data)
    if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide(data and data.rwid) then
        return
    end
    ensureTopPanelExpanded()
    local targetKey = tostring(data.an)
    local target = npc.db_anniu[targetKey]
    if (not target) and data.rwid then
        cogin.sjtb.rwid = math.max(tonumber(cogin.sjtb.rwid) or 0, tonumber(data.rwid) or 0)
        rebuildShortcutButtons("")
        ensureTopPanelExpanded()
        target = npc.db_anniu[targetKey]
    end
    if not target then
        SL:ScheduleOnce(function()
            rebuildShortcutButtons("")
            ensureTopPanelExpanded()
            local retryTarget = npc.db_anniu[targetKey]
            if retryTarget then
                NPC_UI_HELPER.startGuide({
                    dir = data.fx,
                    guideWidget = retryTarget,
                    guideParent = npc.dbLayout,
                    guideDesc = data.ms,
                    isForce = false,
                    hideMask = false,
                })
            end
        end, 0.2)
        return
    end
    SL:release_print("startGuideOnButton", data.an, target and "found" or "not found")
    NPC_UI_HELPER.startGuide({
        dir = data.fx,
        guideWidget = target,
        guideParent = npc.dbLayout,
        guideDesc = data.ms,
        isForce = false,
        hideMask = false,
    })
end
local function triggerNavigate(point, meta)
    if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide() then
        return
    end
    if meta and tonumber(meta.type or 0) == 1 then
        local npcID = tonumber(meta.index or 0) or 0
        if npcID > 0 and SL.RequestNPCTalk then
            -- SL:RequestNPCTalk(npcID)
            if SL.GetMetaValue and SL:GetMetaValue("BATTLE_IS_AFK") then
                SL:SetMetaValue("BATTLE_AFK_END")
            end
            SL:SendLuaNetMsg(105, npcID, npcID, 0, "")
            
            return
        end
    end
    -- local rwxx = SL:GetMetaValue("ACTOR_MAP_X", SL:GetMetaValue("MAIN_ACTOR_ID"))
    -- local safeX = (point.map == rwxx) and (point.x + 1) or point.x
    -- SL:release_print(point.map, safeX, point.y, SL:JsonEncode(meta))
    -- SL:SetMetaValue("BATTLE_MOVE_BEGIN", point.map, safeX + 1, point.y + 1, meta, 1)
end
local function openBagGuide(desc, pcWidget, mobileWidget)
    SL:RefreshBagPos()
    if cogin.isWin32 then
        NPC_UI_HELPER.startGuide({
            dir = 2,
            guideWidget = pcWidget,
            guideParent = MainProperty._ui.Panel_act,
            guideDesc = desc,
            isForce = false,
            hideMask = false,
        })
        GUI:Timeline_FadeIn(pcWidget, 0.2)
    else
        NPC_UI_HELPER.startGuide({
            dir = 1,
            guideWidget = mobileWidget,
            guideParent = npc.RightTop,
            guideDesc = desc,
            isForce = false,
            hideMask = false,
        })
    end
end
local function openRoleGuide()
    if cogin.isWin32 then
        NPC_UI_HELPER.startGuide({
            dir = 3,
            guideWidget = MainProperty._ui.Button_role,
            guideParent = MainProperty._ui.Panel_act,
            guideDesc = "打开人物界面",
            isForce = false,
            hideMask = false,
        })
        GUI:Timeline_FadeIn(MainProperty._ui.Button_role, 0.2)
    else
        NPC_UI_HELPER.startGuide({
            dir = 1,
            guideWidget = npc.jueshe,
            guideParent = npc.RightTop,
            guideDesc = "打开人物界面",
            isForce = false,
            hideMask = false,
        })
    end
end
local function openNpcPanelForGuide(npcid)
    if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide() then
        return
    end
    npcid = tonumber(npcid) or 0
    if npcid <= 0 then
        return
    end
    if SL.GetMetaValue and SL:GetMetaValue("BATTLE_IS_AFK") then
        SL:SetMetaValue("BATTLE_AFK_END")
    end
    SL:SendLuaNetMsg(105, npcid, npcid, 0, "")
end
local MAINLINE_PANEL_GUIDE = {
    [17] = 24, -- 天书强化
    [18] = 24, -- 天书仙法
    [26] = 43, -- 江湖称号升级
}
local guideDispatch = {
    [1] = function(data)
        startGuideOnButton(data)
    end,
    [2] = function(data)
        if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide(data and data.rwid) then
            return
        end
        if tostring(data.npcdt or "") == "二大陆主城" and type(dl_sz) == "function" and not dl_sz(2) then
            SL:ShowSystemTips("<font color='#FF0000'>需完成主线引导后才可进入二大陆</font>")
            return
        end
        SL:ScheduleOnce(function()
            triggerNavigate({
                map = data.npcdt,
                x = tonumber(data.xx) or 0,
                y = tonumber(data.yy) or 0,
            }, {
                type = 1,
                index = data.npcid,
            })
        end, 0.2)
    end,
    [3] = function(data)
        if data.rwid then
            cogin.sjtb.zxrwid = data.rwid
            cogin.sjtb.rwid = math.max(tonumber(cogin.sjtb.rwid) or 0, tonumber(data.rwid) or 0)
            rebuildShortcutButtons("")
        end
        if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide(data and data.rwid) then
            return
        end
        local rwid = tonumber(data and data.rwid) or 0
        if rwid == 22 or rwid == 32 then
            openRoleGuide()
            return
        end
        local npcid = MAINLINE_PANEL_GUIDE[rwid]
        if npcid then
            openNpcPanelForGuide(npcid)
            return
        end
        openClientBagForGuide()
    end,
    [4] = function(data)
        if NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide(data and data.rwid) then
            return
        end
        SL:ScheduleOnce(function()
            local yd = data and data.yd or {
            }
            triggerNavigate({
                map = data.npcdt,
                x = tonumber(yd[2]) or 0,
                y = tonumber(yd[3]) or 0,
            }, {
                type = 0,
            })
        end, 0.2)
    end,
    [14] = function()
        SL:JumpTo(1)
    end,
}
npc[0] = function(p2, p3, msgData)
    if p2 == 1 then
        local zysj = SL:JsonDecode(msgData, false)
        if tonumber(zysj and zysj.an or 0) == 64 and tonumber(zysj and zysj.rwid or 0) >= 28 then
            cogin.sjtb.zxrwid = math.max(tonumber(cogin.sjtb.zxrwid) or 0, tonumber(zysj.rwid) or 28)
            cogin.sjtb.rwid = math.max(tonumber(cogin.sjtb.rwid) or 0, tonumber(zysj.rwid) or 28)
            refreshLingshouMainEntrySoon()
            startLingshouMainGuide(3)
            return
        end
        local handler = guideDispatch[zysj.lx]
        if handler then
            handler(zysj)
        end
    elseif p2 == 9 then
        local da = SL:JsonDecode(msgData, false)
        local rewardWindow = ensureWindow("reward", 0, {
            titleText = "奖励预览",
            background = {
                skin = "res/wy/public/0-" .. (p3 == 1000 and 2 or 1) .. ".png",
            },
        })
        local parent = rewardWindow.bg
        GUI:removeAllChildren(parent)
        local Layout1 = GUI:Layout_Create(parent, "Layout1", 831.0 / 2, 170, #da.item * 71, 60.0, false)
        GUI:setAnchorPoint(Layout1, 0.5, 0)
        for k, v in ipairs(da.item) do
            local k = GUI:Image_Create(Layout1, "item" .. k, 0.0, 0.0, "res/wy/public/555.png")
            GUI:ItemShow_Create(k, "kuang", 20, 20, {
                index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", v[1]),
                look = true,
                count = v[2],
            })
            -- _add_reward_item_effect(k, "reward_item_eff", 20, 20, 0.9, REWARD_ITEM_EFFECT_14193)
        end
        GUI:UserUILayout(Layout1, {
            dir = 2,
            addDir = 2,
            interval = 1,
            gap = {
                x = 20,
            },
        })
        local Button = GUI:Button_Create(parent, "Button", 831.0 / 2, 80, "res/wy/public/0-1_an.png")
        GUI:setAnchorPoint(Button, 0.5, 0)
        GUI:addOnClickEvent(Button, function()
            GUI:Win_Close(rewardWindow.parent)
        end)
        GUI:setScaleX(parent, 0)
        GUI:Timeline_ScaleTo(parent, 1, 0.2)
    end
end
npc[1] = function(p2, p3, msgData)
    if p2 == 0 then
        if p3 == 0 then
            local guaji = {
            }
            if cogin.isWin32 then
                guaji[1] = GUI:Button_Create(npc.RightBottom, "guaji", -80, 500, "res/wy/icon/base.png")
                if SL:GetMetaValue("USER_NAME") == "玩家名字k" or SL:GetMetaValue("USER_NAME") == "玩家名字" or true then
                    local Button_1 = GUI:Button_Create(npc.RightBottom, "Button_1", -150, 340 + 100, "res/private/player_main_layer_ui/player_main_layer_ui_win32/1900015011.png")
                    GUI:Button_setTitleText(Button_1, "测试")
                    GUI:addOnClickEvent(Button_1, function()
                        SL:SendLuaNetMsg(105, 9999, 9999, 0, "")
                    end)
                end
                npc.an_cbl = GUI:Button_Create(npc.RightBottom, "an_cbl", -70, 320 - 70, "res/private/main/bottom/1900012580.png")
                GUI:addOnClickEvent(npc.an_cbl, function()
                    local parent = GUI:GetWindow(nil, "main_cbl")
                    if parent then
                        GUI:removeAllChildren(parent)
                    else
                        parent = GUI:Win_Create("main_cbl", 0, 0, 0, 0, false, false, true, true, true, idx, 1)
                    end
                    local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/public/1900000651_1.png")
                    GUI:setAnchorPoint(bjt, 0.5, 0.5)
                    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
                    GUI:setTouchEnabled(bjt, true)
                    local cbl = GUI:Image_Create(parent, "bj", cogin.w, 0, "res/wy/public/main_cbl_bj.png")
                    GUI:setAnchorPoint(cbl, 1, 0)
                    GUI:setTouchEnabled(cbl, true)
                    GUI:addOnClickEvent(bjt, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {
                            x = cogin.w + 300,
                            y = 0,
                        }, 0.5, function()
                            GUI:Win_Close(parent)
                        end)
                    end)
                    GUI:addMouseOverTips(bjt, "", {
                        x = 0,
                        y = 0,
                    }, {
                        x = 0,
                        y = 0,
                    })
                    local width = GUI:getContentSize(cbl).width
                    GUI:setContentSize(cbl, width, cogin.h)
                    GUI:setPosition(cbl, cogin.w + width, 0)
                    local close = GUI:Button_Create(cbl, 'close', width - 10, cogin.h - 10, 'res/wy/public/main_cbl_close.png')
                    GUI:setAnchorPoint(close, 1, 1)
                    GUI:addOnClickEvent(close, function()
                        GUI:Timeline_EaseSineIn_MoveTo(cbl, {
                            x = cogin.w + 300,
                            y = 0,
                        }, 0.5, function()
                            GUI:Win_Close(parent)
                        end)
                    end)
                    local hh = GUI:Button_Create(GUI:Image_Create(cbl, "hh", 10, 150, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_hh.png")
                    local sz = GUI:Button_Create(GUI:Image_Create(cbl, "sz", 110, 50, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_sz.png")
                    local exit = GUI:Button_Create(GUI:Image_Create(cbl, "exit", 210, 50, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_exit.png")
                    local sj_xz = GUI:Button_Create(GUI:Image_Create(cbl, "paimai", 210, 150, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_xz.png")
                    local haoyou = GUI:Button_Create(GUI:Image_Create(cbl, "haoyou", 110, 150, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_haoyou.png")
                    local paihang = GUI:Button_Create(GUI:Image_Create(cbl, "paihang", 10, 50, "res/wy/public/main_cbl_kuang.png"), "img", 39, 34.5, "res/private/main/bottom/sj_paihang.png")
                    GUI:setAnchorPoint(hh, 0.5, 0.5)
                    GUI:setAnchorPoint(sz, 0.5, 0.5)
                    GUI:setAnchorPoint(exit, 0.5, 0.5)
                    GUI:setAnchorPoint(sj_xz, 0.5, 0.5)
                    GUI:setAnchorPoint(haoyou, 0.5, 0.5)
                    GUI:setAnchorPoint(paihang, 0.5, 0.5)
                    GUI:addOnClickEvent(hh, function()
                        SL:JumpTo(31)
                    end)
                    GUI:addOnClickEvent(sj_xz, function()
                        SL:SendLuaNetMsg(105, 1002, 1002, 0, "")
                    end)
                    GUI:addOnClickEvent(haoyou, function()
                        SL:JumpTo(28)
                    end)
                    GUI:addOnClickEvent(sz, function()
                        SL:JumpTo(23)
                    end)
                    GUI:addOnClickEvent(paihang, function()
                        SL:JumpTo(32)
                    end)
                    GUI:addOnClickEvent(exit, function()
                        SL:JumpTo(29)
                    end)

                    local zz = GUI:Button_Create(cbl, "lbg", width/2, cogin.h - 80, "res/wy/public/main_cbl_htgh.png")
                    local syt = GUI:Button_Create(cbl, "sqt", width/2, cogin.h - 80 - 105 - 30, "res/wy/public/main_cbl_kbzl.png")
                    local ldl = GUI:Button_Create(cbl, "tj", width/2, cogin.h - 80 - 210 - 60, "res/wy/public/main_cbl_xtqy.png")
                    GUI:setAnchorPoint(zz, 0.5, 1)
                    GUI:setAnchorPoint(syt, 0.5, 1)
                    GUI:setAnchorPoint(ldl, 0.5, 1)

                    GUI:addOnClickEvent(zz, function() SL:SendLuaNetMsg(101, 23, 0, 0, "") end)
                    GUI:addOnClickEvent(syt, function() SL:SendLuaNetMsg(105, 15, 15, 0, "") end)
                    GUI:addOnClickEvent(ldl, function()  SL:SendLuaNetMsg(101, 515, 0, 0, "") end)


                    GUI:Timeline_EaseSineIn_MoveTo(cbl, {
                        x = cogin.w,
                        y = 0,
                    }, 0.5)
                end)
                local moji = GUI:Effect_Create(npc.RightBottom, "moji", -260, 40, 0, 7060, 0, 0, 0, 1)
                local Layout = GUI:Layout_Create(moji, "Layout", 0, 0, 48, 48, false)
                GUI:setTouchEnabled(Layout, true)
                GUI:addOnClickEvent(Layout, function()
                    SL:OpenChatExtendUI(2)
                end)
                
            else
                npc.sjbeibao = GUI:Button_Create(npc.RightTop, "beibao", -160, -230, "res/private/main/bottom/bag.png")
                npc.jueshe = GUI:Button_Create(npc.RightTop, "jueshe", -240, -230, "res/private/main/bottom/js.png")
                GUI:addOnClickEvent(npc.sjbeibao, function()
                    SL:OpenBagUI()
                end)
                GUI:addOnClickEvent(npc.jueshe, function()
                    SL:OpenMyPlayerUI()
                end)
                guaji[1] = GUI:Button_Create(npc.RightTop, "guaji", -80, -230, "res/wy/icon/base.png")
            end

            local function renderContinent5Button()
                if GUI:getChildByName(npc.RightBottom, "zjkmw") then
                    return
                end
                local continent5Unlocked = false
                if type(dl_unlock_check) == "function" then
                    local ok = dl_unlock_check(5)
                    continent5Unlocked = ok == true
                elseif type(dl_sz) == "function" then
                    local ok = dl_sz(5)
                    continent5Unlocked = ok == true
                end
                if not continent5Unlocked then
                    local adminUnlock = cogin and cogin.sjtb and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
                    local syncContinent = cogin and cogin.sjtb and tonumber(cogin.sjtb.U_dlxz_bc or 0) or 0
                    if adminUnlock == 1 or adminUnlock >= 5 or syncContinent >= 5 then
                        continent5Unlocked = true
                    end
                end
                if not continent5Unlocked then
                    return
                end
                local zjkmw = GUI:Button_Create(npc.RightBottom, "zjkmw", cogin.isWin32 and npc.zjkmw_opt[1][1] or npc.zjkmw_opt[2][1], cogin.isWin32 and npc.zjkmw_opt[1][2] or npc.zjkmw_opt[2][2], "res/custom/five_city/zjkmw/img.png")
                GUI:addOnClickEvent(zjkmw, function()
                    local item = SL:GetMetaValue("EQUIP_DATA", 16)
                    if item then
                        local equipLevel = Player:getEquipFieldByIndex(item.Index, 1)
                        equipLevel = tonumber(equipLevel)
                        if equipLevel < 13 then
                            SL:ShowSystemTips("需要先进入满醉意值状态")
                            return
                        end
                    else
                        SL:ShowSystemTips("需要先进入满醉意值状态")
                        return
                    end
                    if GUI:getChildByName(zjkmw, "img_bj") then
                        GUI:removeChildByName(zjkmw, "img_bj")
                        return
                    end
                    npc.bg = GUI:Image_Create(zjkmw, "img_bj", 100, 0, "res/custom/five_city/zjkmw/bg.png")
                    GUI:setTouchEnabled(npc.bg, true)
                    GUI:setAnchorPoint(npc.bg, 1, 0.5)
                    GUI:setOpacity(npc.bg, 0)
                    GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, 0, 0), GUI:ActionFadeIn(0.3)))
                    npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
                    local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", SL:GetMetaValue("MAIN_ACTOR_ID"), 20103)
                    local Button = GUI:Button_Create(npc.node, "Button", 0, 10.0, "res/custom/five_city/zjkmw/btn_" .. (buff and 2 or 1) .. ".png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(100, 70, 2, 0, "")
                    end)
                    SL:RegisterLUAEvent(LUA_EVENT_MAINBUFFUPDATE, "主玩家buff刷新", function(data)
                        if data.buffID == 20103 then
                            local buff = SL:GetMetaValue("ACTOR_BUFF_DATA_BY_ID", SL:GetMetaValue("MAIN_ACTOR_ID"), 20103)
                            GUI:Button_loadTextures(Button, "res/custom/five_city/zjkmw/btn_" .. (buff and 2 or 1) .. ".png")
                            if buff then
                                GUI:Frames_Create(zjkmw, "eff", 0, 0, "res/custom/five_city/zjkmw/eff/eff_", ".png", 1, 75, {
                                    speed = 75,
                                    count = 75,
                                    loop = 0,
                                })
                            else
                                GUI:removeChildByName(zjkmw, "eff")
                            end
                        end
                    end)
                end)
            end
            if SL and SL.scheduleOnce then
                SL:scheduleOnce(npc.RightTop, renderContinent5Button, 1)
            elseif SL and SL.ScheduleOnce then
                SL:ScheduleOnce(renderContinent5Button, 1)
            else
                renderContinent5Button()
            end


            GUI:addOnClickEvent(guaji[1], function()
                if SL:GetMetaValue("BATTLE_IS_AFK") then
                    SL:SetMetaValue("BATTLE_AFK_END")
                else
                    SL:SetMetaValue("BATTLE_AFK_BEGIN")
                end
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKBEGIN, "开始自动挂机", function()
                guaji[3] = GUI:Effect_Create(guaji[1], "moji", 32, 32, 0, 4005, 0, 0, 0, 1)
                GUI:setScale(guaji[3], 0.6)
                SL:RegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用", function(data)
                    if SL:GetMetaValue("BATTLE_IS_AFK") then
                        if data.act == 25 then
                            if cogin.guajikawei[1] == 6 or cogin.guajikawei[1] == 1 then
                                if cogin.guajikawei[2] > 5 then
                                    cogin.guajikawei[2] = 0
                                else
                                    cogin.guajikawei[1] = 0
                                    cogin.guajikawei[2] = cogin.guajikawei[2] + 1
                                end
                            else
                                if cogin.guajikawei[2] > 0 then
                                    cogin.guajikawei[2] = 0
                                end
                            end
                        else
                            cogin.guajikawei[1] = data.act
                        end
                    end
                end)
            end)
            SL:RegisterLUAEvent(LUA_EVENT_AFKEND, "结束自动挂机", function()
                SL:UnRegisterLUAEvent(LUA_EVENT_PLAYER_ACTION_BEGIN, "主玩家行为动作开始-挂机用")
                if guaji[3] then
                    GUI:removeFromParent(guaji[3])
                end
            end)
            npc.dbLayout = GUI:Layout_Create(npc.RightTop, "Layout1", zbz[1], zbz[2], 490, 160, false)
            npc.dbshousuo = GUI:Button_Create(npc.RightTop, "shousuo", zbz[4], zbz[5], "res/wy/icon/s.png")
            GUI:setAnchorPoint(npc.dbshousuo, 0.5, 0)
            GUI:addOnClickEvent(npc.dbshousuo, function(self)
                npc._shortcut_collapsed = not npc._shortcut_collapsed
                _refresh_shortcut_collapsed_state(true)
            end)
            rebuildShortcutButtons("")
            refreshLingshouMainEntrySoon()
            startLingshouMainEntryLoginRefresh()
            registerShortcutTitleRefresh()
            UPGRADE_HELPER.registerOpenNpcButtons()
            UPGRADE_HELPER.startEquipChangeRefresh()
            UPGRADE_HELPER.startAutoRefresh(20 * 1)
        elseif p3 == 1 then
            rebuildShortcutButtons(msgData or "")
            refreshLingshouMainEntrySoon()
            startLingshouMainEntryLoginRefresh()
            registerShortcutTitleRefresh()
            
            SL:WinClick(widget)
            UPGRADE_HELPER.registerOpenNpcButtons()
            UPGRADE_HELPER.startEquipChangeRefresh()
            UPGRADE_HELPER.startAutoRefresh(20 * 1)
        end
    elseif p2 == 10 then
        if tonumber(p3 or 0) == 31 then
            return
        end
        if npc.db_anniu["" .. p3] and not GUI:ui_delegate(npc.db_anniu["" .. p3]).redpoint then
            NPC_UI_HELPER.redpoint_create_eff(npc.db_anniu["" .. p3], {
                x = 80,
                y = 60,
            })
        end
    end
end
npc[2] = function(p2, p3, msgData)
    if p2 == 8 then
        openClientBagForGuide()
    elseif p2 == 2 then
        local shuju = SL:JsonDecode(msgData, false)
        shuju.xz = shuju.xz or {
        }
        shuju.kg = shuju.kg or {
        }
        local recycleWindow = ensureWindow("recycle", 2, {
            titleText = "装备回收",
        })
        local parent = recycleWindow.parent
        npc.bg = recycleWindow.bg
        GUI:setTouchEnabled(npc.bg, true)
        GUI:Win_SetDrag(parent, npc.bg)
        GUI:Win_SetZPanel(parent, npc.bg)
        GUI:removeChildByName(parent, "bjt")
        local function syncSelection(key, isSelected)
            shuju.xz[key] = isSelected and 1 or nil
            SL:SendLuaNetMsg(101, 2, 2, 0, key)
        end
        local function clearSelectionIfNeeded(key)
            if key and shuju.xz[key] and shuju.xz[key] == 1 then
                syncSelection(key, false)
            end
        end
        local hs_tab_map = {
            [1] = "zzhs",
            [2] = "zsfj",
            [3] = "sqhs",
            [4] = "gwfj",
            [5] = "ssfj",
            [6] = "clfj",
            [7] = "teshuhuihsou",
        }
        local refresh_bulk_select_state
        local function setRecycleText(widget, color, size, outline)
            GUI:Text_enableOutline(widget, outline or "#110b05", 2)
            if color then
                GUI:Text_setTextColor(widget, color)
            end
            if size then
                GUI:Text_setFontSize(widget, size)
            end
        end
        local function getGroupNameColor(name)
            local text = tostring(name or "")
            local colorByTier = {
                "#72F26B",
                "#66F0A9",
                "#72E9D8",
                "#79D7FF",
                "#8CB9FF",
                "#A99BFF",
                "#C58CFF",
                "#E688FF",
                "#FF8EDC",
                "#FF9FB0",
                "#FFAE7A",
                "#FFC15F",
                "#FFD451",
                "#FFE46C",
                "#FFF08A",
            }
            local function clampTier(tier)
                tier = tonumber(tier or 1) or 1
                if tier < 1 then
                    tier = 1
                elseif tier > #colorByTier then
                    tier = #colorByTier
                end
                return tier
            end
            local startTier = string.match(text, "制式装备(%d+)%-%d+")
            if startTier then
                local tier = tonumber(startTier) or 1
                return colorByTier[clampTier(tier)]
            end
            startTier = string.match(text, "基础装备(%d+)%-%d+")
            if startTier then
                local tier = tonumber(startTier) or 1
                return colorByTier[clampTier(tier)]
            end
            local zishuTier = string.match(text, "专属附加(%d+)")
            if zishuTier then
                return colorByTier[clampTier(zishuTier)]
            end
            local dlNameTierMap = {
                ["世界专属"] = 1,
                ["极光城"] = 2,
                ["苍云城"] = 3,
                ["若水"] = 4,
                ["红尘"] = 5,
                ["灵虚"] = 6,
                ["七大陆主城"] = 7,
                ["八大陆主城"] = 8,
                ["九大陆主城"] = 9,
            }
            if dlNameTierMap[text] then
                return colorByTier[clampTier(dlNameTierMap[text])]
            end
            local dlTier = string.match(text, "([三四五六七八九])大陆")
            if dlTier then
                local tierMap = {
                    ["三"] = 3,
                    ["四"] = 4,
                    ["五"] = 5,
                    ["六"] = 6,
                    ["七"] = 7,
                    ["八"] = 8,
                    ["九"] = 9,
                }
                return colorByTier[clampTier(tierMap[dlTier] or 3)]
            end
            local shizhuangTier = string.match(text, "时装首饰(%d+)")
            if shizhuangTier then
                return colorByTier[clampTier((tonumber(shizhuangTier) or 1) + 5)]
            end
            local shengxiaoTier = string.match(text, "生肖(%d+)")
            if shengxiaoTier then
                return colorByTier[clampTier((tonumber(shengxiaoTier) or 1) + 1)]
            end
            local guwanTierMap = {
                ["唐代"] = 1,
                ["宋代"] = 3,
                ["元代"] = 5,
                ["明代"] = 7,
                ["清代"] = 9,
                ["近代"] = 11,
            }
            for key, tier in pairs(guwanTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end
            local shenshiTierMap = {
                ["稀有"] = 4,
                ["史诗"] = 7,
                ["神话"] = 11,
                ["传说"] = 14,
            }
            for key, tier in pairs(shenshiTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end            local cailiaoTierMap = {
                ["普通材料"] = 1,
                ["通用材料"] = 3,
                ["二大陆剧情材料"] = 4,
                ["三大陆剧情材料"] = 6,
                ["四大陆剧情材料"] = 8,
                ["五大陆剧情材料"] = 10,
                ["六大陆剧情材料"] = 12,
                ["特殊功能材料"] = 14,
            }
            for key, tier in pairs(cailiaoTierMap) do
                if string.find(text, key) then
                    return colorByTier[clampTier(tier)]
                end
            end
            return "#F5E6B2"
        end
        local function formatRecycleGroupDisplayName(categoryKey, groupName)
            local text = tostring(groupName or "")
            if categoryKey ~= "zsfj" or text == "" or text == "世界专属" then
                return text
            end
            local continentMap = {
                ["极光城"] = 2,
                ["苍云大陆"] = 3,
                ["若水大陆"] = 4,
                ["红尘大陆"] = 5,
                ["灵虚大陆"] = 6,
                ["万灵界域"] = 7,
                ["诸天之上"] = 8,
                ["九大陆主城"] = 9,
                ["九大路主城"] = 9,
            }
            local continent = continentMap[text]
            if not continent then
                return text
            end
            local continentTextMap = {
                [2] = "二",
                [3] = "三",
                [4] = "四",
                [5] = "五",
                [6] = "六",
                [7] = "七",
                [8] = "八",
                [9] = "九",
            }
            local continentText = continentTextMap[continent]
            if not continentText then
                return text
            end
            return string.format("%s大陆|%s", continentText, text)
        end
        local function formatRecycleReward(cfg)
            if type(cfg) ~= "table" then
                return ""
            end
            local groupType = tonumber(cfg.gl or cfg[1] or 0) or 0
            local countA = tonumber(cfg[4] or 0) or 0
            local countB = tonumber(cfg[5] or 0) or 0
            local countC = tonumber(cfg[6] or 0) or 0
            if groupType == 2 then
                if countB == 1 then
                    return "辉耀水晶*" .. tostring(countA)
                end
                if countC == 1 then
                    return "辉耀水晶*" .. tostring(countA)
                end
                return "不返还"
            end
            local parts = {
            }
            if countA > 0 then
                parts[#parts + 1] = "金币*" .. tostring(countA)
            end
            if countB > 0 then
                parts[#parts + 1] = "元宝*" .. tostring(countB)
            end
            return #parts > 0 and table.concat(parts, " ") or "无"
        end
        local function isRecycleTitleItem(cfg)
            local itemName = tostring(cfg and cfg[3] or "")
            return string.find(itemName, "^·%-%-%-") ~= nil
        end
        local function recycleGroupUnlockState(continent)
            continent = tonumber(continent or 0) or 0
            if continent <= 1 then
                return true
            end
            local adminUnlock = cogin and cogin.sjtb and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
            if adminUnlock == 1 or adminUnlock >= continent then
                return true
            end
            if continent <= 3 then
                if type(dl_sz) == "function" then
                    return dl_sz(continent) == true
                end
                return true
            end
            local function recycleGetRelevel()
                local zslv = tonumber(Player and Player.getServerVar and Player:getServerVar("U43") or 0) or 0
                if zslv <= 0 then
                    zslv = tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0
                end
                return zslv
            end
            local function recycleGetLevel()
                return tonumber(SL:GetMetaValue("LEVEL") or 0) or 0
            end
            local function recycleHasAllLinggen()
                local data = Player and Player.JsonToTbl and Player:getServerVar("T41") and Player:JsonToTbl(Player:getServerVar("T41")) or {}
                local levels = type(data) == "table" and type(data.level) == "table" and data.level or {}
                for idx = 1, 5 do
                    if (tonumber(levels[tostring(idx)] or levels[idx]) or 0) < 1 then
                        return false
                    end
                end
                return true
            end
            local function recycleHasAllDestiny()
                local data = Player and Player.JsonToTbl and Player:getServerVar("T13") and Player:JsonToTbl(Player:getServerVar("T13")) or {}
                local state = type(data) == "table" and type(data["npc_74"]) == "table" and data["npc_74"] or {}
                local cfg74 = type(teshudata) == "table" and teshudata["npc_74"] or {}
                local need = tonumber(cfg74 and cfg74.all) or 4
                return (tonumber(state.all) or 0) >= need
            end
            local function recycleHasTitle(titleName)
                local itemIdx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName) or 0) or 0
                if itemIdx <= 0 then
                    return false
                end
                return SL:GetMetaValue("TITLE_DATA_BY_ID", itemIdx) ~= nil
            end
            local function recycleGetTaskStoryPoint(task)
                local total = 0
                local rewards = type(task) == "table" and task.jl or nil
                if type(rewards) ~= "table" then
                    return 0
                end
                for _, reward in ipairs(rewards) do
                    if type(reward) == "table" and reward[1] == "剧情点" then
                        total = total + (tonumber(reward[2]) or 0)
                    end
                end
                return total
            end
            local recycleExtraProgressChapters = {
                ["苍云秘闻"] = true,
                ["若水秘闻"] = true,
                ["灵兽奥秘"] = true,
                ["灵虚秘闻"] = true,
            }
            local function recycleShouldSkipProgressChapter(chapter)
                if type(chapter) ~= "table" then
                    return false
                end
                return recycleExtraProgressChapters[tostring(chapter.name or "")] == true
            end
            local function recycleGetStoryProgress(targetContinent)
                local chapters = npc.xyl and npc.xyl[targetContinent] or nil
                local ywl = rawget(_G, "XYL_YWL_CACHE") or {}
                local done = 0
                local total = 0
                if type(chapters) ~= "table" or type(ywl) ~= "table" then
                    return nil, nil
                end
                for chapterIdx, chapter in ipairs(chapters) do
                    local skipTotal = recycleShouldSkipProgressChapter(chapter)
                    local tasks = type(chapter) == "table" and chapter.jq or nil
                    if type(tasks) == "table" then
                        local chapterKey = "jl_" .. targetContinent .. "_" .. chapterIdx
                        local chapterReceived = tonumber(ywl[chapterKey] or 0) == 1
                        for taskIdx, task in ipairs(tasks) do
                            local point = recycleGetTaskStoryPoint(task)
                            if not skipTotal then
                                total = total + point
                            end
                            local taskReceived = tonumber(ywl[chapterKey .. "_" .. taskIdx] or 0) == 1
                            if point > 0 and (chapterReceived or taskReceived) then
                                done = done + point
                            end
                        end
                    end
                end
                return done, total
            end
            local function recycleStoryTarget(total, percent)
                total = tonumber(total) or 0
                if total <= 0 then
                    return 0
                end
                return math.ceil(total * (tonumber(percent) or 100) / 100)
            end
            if continent == 4 then
                local done, total = recycleGetStoryProgress(3)
                return total and total > 0 and done >= recycleStoryTarget(total, 85) and recycleGetRelevel() >= 30 and recycleGetLevel() >= 150
            elseif continent == 5 then
                local done, total = recycleGetStoryProgress(4)
                return total and total > 0 and done >= recycleStoryTarget(total, 95) and recycleGetRelevel() >= 40 and recycleHasAllLinggen()
            elseif continent == 6 then
                local done, total = recycleGetStoryProgress(5)
                return total and total > 0 and done >= recycleStoryTarget(total, 95) and recycleGetRelevel() >= 50 and recycleHasAllDestiny()
            elseif continent == 7 then
                local done, total = recycleGetStoryProgress(6)
                return total and total > 0 and done >= recycleStoryTarget(total, 100) and recycleGetRelevel() >= 60 and recycleHasTitle("世界符文·[真我]")
            elseif continent == 8 then
                return recycleGetRelevel() >= 70
            end
            return true
        end
        local function recycleGroupVisible(categoryKey, groupName)
            groupName = tostring(groupName or "")
            if categoryKey == "zsfj" then
                local continentMap = {
                    ["世界专属"] = 1,
                    ["极光城"] = 2,
                    ["苍云大陆"] = 3,
                    ["若水大陆"] = 4,
                    ["红尘大陆"] = 5,
                    ["灵虚大陆"] = 6,
                    ["万灵界域"] = 7,
                    ["诸天之上"] = 8,
                    ["九大路主城"] = 9,
                }
                local continent = continentMap[groupName]
                if continent then
                    return recycleGroupUnlockState(continent)
                end
            elseif categoryKey == "clfj" then
                local continentMap = {
                    ["二大陆剧情材料"] = 2,
                    ["三大陆剧情材料"] = 3,
                    ["四大陆剧情材料"] = 4,
                    ["五大陆剧情材料"] = 5,
                    ["六大陆剧情材料"] = 6,
                }
                local continent = continentMap[groupName]
                if continent then
                    return recycleGroupUnlockState(continent)
                end
            end
            return true
        end
        local function filterRecycleCategoryData(categoryKey, data)
            if type(data) ~= "table" then
                return data
            end
            if categoryKey ~= "zsfj" and categoryKey ~= "clfj" then
                return data
            end
            local filtered = {}
            for groupIdx, groupData in pairs(data) do
                if type(groupData) == "table" then
                    local subgroupMap = {}
                    local hasVisible = false
                    for subIdx, subgroupCfg in pairs(groupData) do
                        if type(subgroupCfg) == "table" and type(subgroupCfg.l) == "table" then
                            if recycleGroupVisible(categoryKey, subgroupCfg.name) then
                                subgroupMap[subIdx] = subgroupCfg
                                hasVisible = true
                            end
                        end
                    end
                    if hasVisible then
                        filtered[groupIdx] = subgroupMap
                    end
                end
            end
            return filtered
        end
        local function resolveRecycleGroupToken(defaultGroupIdx, subgroupCfg)
            if type(subgroupCfg) == "table" and type(subgroupCfg.l) == "table" then
                for _, itemCfg in pairs(subgroupCfg.l) do
                    if type(itemCfg) == "table" and type(itemCfg[1]) == "number" then
                        return itemCfg[1]
                    end
                end
            end
            return defaultGroupIdx
        end
        local function collect_current_select_keys()
            local keyMap = {
            }
            local category_key = hs_tab_map[npc.s]
            if not category_key then
                return {
                }
            end
            local function add_key(key)
                if key ~= nil and key ~= "" then
                    keyMap[tostring(key)] = true
                end
            end
            local function normalize_category_data_for_bulk()
                local source = cogin.hs[category_key]
                if type(source) ~= "table" then
                    return {
                    }
                end
                if category_key == "zzhs" then
                    local merged = {
                    }
                    for k, v in pairs(source) do
                        merged[k] = v
                    end
                    for k, v in pairs(cogin.hs.fzfj or {
                    }) do
                        merged[k] = v
                    end
                    return merged
                end
                local by_tab = source[npc.s]
                if type(by_tab) == "table" then
                    if by_tab.l then
                        return {
                            [npc.s] = {
                                by_tab,
                            },
                        }
                    end
                    return {
                        [npc.s] = by_tab,
                    }
                end
                if source.l then
                    return {
                        [npc.s] = {
                            source,
                        },
                    }
                end
                if category_key == "teshuhuihsou" then
                    local group_idx = npc.s
                    for _, cfg in pairs(source) do
                        if type(cfg) == "table" and cfg[1] then
                            group_idx = cfg[1]
                            break
                        end
                    end
                    return {
                        [group_idx] = {
                            {
                                name = "teshuhuihsou",
                                l = source,
                            },
                        },
                    }
                end
                for k, v in pairs(source) do
                    if type(v) == "table" and type(v.l) == "table" then
                        return {
                            [k] = {
                                v,
                            },
                        }
                    end
                end
                return filterRecycleCategoryData(category_key, source)
            end
            local category_data = filterRecycleCategoryData(category_key, normalize_category_data_for_bulk())
            for v, group_data in pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local group_token = resolveRecycleGroupToken(v, subgroup_cfg)
                            local group_key = tostring(npc.s) .. "_" .. tostring(group_token)
                            local subgroup_key = group_key .. "_" .. tostring(vv)
                            add_key(group_key)
                            add_key(subgroup_key)
                        end
                    end
                end
            end
            local keys = {
            }
            for key, _ in pairs(keyMap) do
                keys[#keys + 1] = key
            end
            return keys
        end
        local function batch_set_current_select_state(isSelected)
            local keys = collect_current_select_keys()
            for _, key in ipairs(keys) do
                local current = shuju.xz[key] and shuju.xz[key] == 1 or false
                if current ~= isSelected then
                    syncSelection(key, isSelected)
                end
            end
        end
        local function hasGroupSelection(config)
            if not config or not config.gl or not config[1] then
                return false
            end
            local prefix = tostring(config.gl) .. "_" .. tostring(config[1])
            if shuju.xz[prefix] then
                return true
            end
            if config[2] and shuju.xz[prefix .. "_" .. tostring(config[2])] then
                return true
            end
            return false
        end
        function xiaohui_update()
            if not npc.bbzs then
                return
            end
            GUI:removeAllChildren(npc.bbzs)
            local rowLayouts = {
            }
            local bagItems = SL:GetMetaValue("BAG_DATA") or {
            }
            npc.hs = {
            }
            local rowIndex = 0
            local slotIndex = 1
            local inRecycle = {
            }
            local itemWidgets = {
            }
            local huishou_jc_list = cogin.huishou_jc_list
            local function removeFromRecycleList(index)
                for idx = #npc.hs, 1, -1 do
                    if npc.hs[idx] == index then
                        table.remove(npc.hs, idx)
                        break
                    end
                end
            end
            local function setRecycleSelection(index, shouldSelect)
                local widget = itemWidgets[index]
                if not widget then
                    return
                end
                GUI:ItemShow_setItemShowChooseState(widget, shouldSelect)
                if shouldSelect then
                    if not inRecycle[index] then
                        table.insert(npc.hs, index)
                    end
                    inRecycle[index] = true
                else
                    if inRecycle[index] then
                        removeFromRecycleList(index)
                    end
                    inRecycle[index] = false
                end
            end
            local function toggleRecycleSelection(index)
                setRecycleSelection(index, not inRecycle[index])
            end
            for bagIndex, bagItem in pairs(bagItems) do
                if slotIndex > 12 * rowIndex then
                    rowIndex = rowIndex + 1
                    rowLayouts[rowIndex] = GUI:Layout_Create(npc.bbzs, "h" .. rowIndex, 0, 0, 500, 41, false)
                end
                local config = huishou_jc_list[bagItem.Index]
                if config and not isRecycleTitleItem(config) then
                    local rowParent = rowLayouts[rowIndex]
                    if rowParent then
                        local slot = GUI:Image_Create(rowParent, "kuang" .. slotIndex, (((slotIndex - 1) % 12) * 41) + 4, 0, "res/wy/public/40-40.png")
                        if slot then
                            local itemShow = GUI:ItemShow_Create(slot, "item" .. slotIndex, 20, 20, {
                                itemData = bagItem,
                                count = bagItem.Count,
                                look = true,
                                bgVisible = false,
                            })
                            if itemShow then
                                if not cogin.isWin32 then
                                    GUI:setScale(itemShow, 0.7)
                                end
                                GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                                GUI:setTouchEnabled(slot, true)
                                itemWidgets[bagIndex] = itemShow
                                inRecycle[bagIndex] = false
                                GUI:addOnClickEvent(slot, function()
                                    toggleRecycleSelection(bagIndex)
                                end)
                                GUI:ItemShow_addReplaceClickEvent(itemShow, function()
                                    toggleRecycleSelection(bagIndex)
                                end)
                                local shouldSelect = hasGroupSelection(config) or shuju.xz["" .. bagItem.Index]
                                if shouldSelect then
                                    setRecycleSelection(bagIndex, true)
                                end
                            end
                        end
                    end
                    slotIndex = slotIndex + 1
                end
            end
        end
        local ty_node = GUI:Node_Create(recycleWindow.node, "ty_node", 0, 0)
        local jm_node = GUI:Node_Create(recycleWindow.node, "jm_node", 0, 0)
        npc.bbzs = GUI:ListView_Create(ty_node, "bbzs", 226, 140, 404, 98, 1)
        GUI:ListView_setItemsMargin(npc.bbzs, 2)
        GUI:ListView_setGravity(npc.bbzs, 2)
        local function new_hs_update()
            GUI:removeAllChildren(jm_node)
            local category_key = hs_tab_map[npc.s]
            if not category_key then
                return
            end
            local function sorted_pairs(tbl)
                local keys = {
                }
                for key in pairs(tbl or {
                }) do
                    keys[#keys + 1] = key
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    end
                    return tostring(a) < tostring(b)
                end)
                local idx = 0
                return function()
                    idx = idx + 1
                    local key = keys[idx]
                    if key ~= nil then
                        return key, tbl[key]
                    end
                end
            end
            local function normalize_category_data()
                local source = cogin.hs[category_key]
                if type(source) ~= "table" then
                    return {
                    }
                end
                if category_key == "zzhs" then
                    local merged = {
                    }
                    for k, v in pairs(source) do
                        merged[k] = v
                    end
                    for k, v in pairs(cogin.hs.fzfj or {
                    }) do
                        merged[k] = v
                    end
                    return merged
                end
                local by_tab = source[npc.s]
                if type(by_tab) == "table" then
                    if by_tab.l then
                        return {
                            [npc.s] = {
                                by_tab,
                            },
                        }
                    end
                    return {
                        [npc.s] = by_tab,
                    }
                end
                if source.l then
                    return {
                        [npc.s] = {
                            source,
                        },
                    }
                end
                if category_key == "teshuhuihsou" then
                    local group_idx = npc.s
                    for _, cfg in pairs(source) do
                        if type(cfg) == "table" and cfg[1] then
                            group_idx = cfg[1]
                            break
                        end
                    end
                    return {
                        [group_idx] = {
                            {
                                name = "teshuhuihsou",
                                l = source,
                            },
                        },
                    }
                end
                for k, v in pairs(source) do
                    if type(v) == "table" and type(v.l) == "table" then
                        return {
                            [k] = {
                                v,
                            },
                        }
                    end
                end
                return filterRecycleCategoryData(category_key, source)
            end
            local category_data = filterRecycleCategoryData(category_key, normalize_category_data())
            local flat_subgroups = {
            }
            for v, group_data in sorted_pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in sorted_pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local group_token = resolveRecycleGroupToken(v, subgroup_cfg)
                            local group_key = npc.s .. "_" .. tostring(group_token)
                            flat_subgroups[#flat_subgroups + 1] = {
                                group_idx = v,
                                subgroup_idx = vv,
                                group_token = group_token,
                                group_key = group_key,
                                subgroup_key = group_key .. "_" .. tostring(vv),
                                cfg = subgroup_cfg,
                            }
                        end
                    end
                end
            end
            if category_key ~= "zzhs" then
                local visible_width = 414
                local visible_height = 228
                local left_width = 202
                local gap_width = 12
                local right_width = visible_width - left_width - gap_width
                local material_wrap = GUI:Layout_Create(jm_node, "material_wrap", 135, 112, visible_width, visible_height, false)
                local left_bg = material_wrap
                GUI:setContentSize(left_bg, left_width, visible_height)
                GUI:setOpacity(left_bg, 185)
                local right_bg = GUI:Node_Create(material_wrap, "right_bg", left_width + gap_width)
                GUI:setOpacity(right_bg, 185)
                local divider = GUI:Layout_Create(material_wrap, "divider", left_width + 4 + 12, 6, 4, visible_height - 12, false)
                GUI:Layout_setBackGroundColorType(divider, 1)
                GUI:Layout_setBackGroundColor(divider, "#000000")
                GUI:Layout_setBackGroundColorOpacity(divider, 220)
                if #flat_subgroups <= 0 then
                    local empty_text = GUI:Text_Create(right_bg, "empty_text", right_width / 2, visible_height / 2, 18, "#F3E8CE", "当前暂无可展示的材料")
                    GUI:setAnchorPoint(empty_text, 0.5, 0.5)
                    setRecycleText(empty_text, "#F3E8CE", 18, "#110b05")
                    return
                end
                npc.recycle_subgroup_key_by_tab = npc.recycle_subgroup_key_by_tab or {
                }
                local selected_subgroup_key = npc.recycle_subgroup_key_by_tab[npc.s]
                local selected_entry = flat_subgroups[1]
                for _, subgroup_entry in ipairs(flat_subgroups) do
                    if subgroup_entry.subgroup_key == selected_subgroup_key then
                        selected_entry = subgroup_entry
                        break
                    end
                end
                npc.recycle_subgroup_key_by_tab[npc.s] = selected_entry.subgroup_key
                local function subgroup_all_selected(subgroup_entry)
                    if (shuju.xz[subgroup_entry.group_key] and shuju.xz[subgroup_entry.group_key] == 1) or (shuju.xz[subgroup_entry.subgroup_key] and shuju.xz[subgroup_entry.subgroup_key] == 1) then
                        return true
                    end
                    local hasEntry = false
                    for item_idx, item_cfg in sorted_pairs(subgroup_entry.cfg.l) do
                        if not isRecycleTitleItem(item_cfg) then
                            hasEntry = true
                            if not (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1) then
                                return false
                            end
                        end
                    end
                    return hasEntry
                end
                local function item_is_selected(subgroup_entry, item_idx)
                    return (shuju.xz[subgroup_entry.group_key] and shuju.xz[subgroup_entry.group_key] == 1)
                        or (shuju.xz[subgroup_entry.subgroup_key] and shuju.xz[subgroup_entry.subgroup_key] == 1)
                        or (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1)
                end
                local dual_refresh_lock = false
                local left_row_widgets = {
                }
                local right_item_widgets = {
                }
                local function refresh_dual_pane_selection_state()
                    dual_refresh_lock = true
                    for _, widget in ipairs(left_row_widgets) do
                        local is_checked = subgroup_all_selected(widget.subgroup_entry)
                        local is_selected = widget.subgroup_entry.subgroup_key == selected_entry.subgroup_key
                        GUI:setOpacity(widget.row, is_selected and 118 or (is_checked and 190 or 128))
                        GUI:setOpacity(widget.row_checkbox_slot, is_selected and 220 or 165)
                        GUI:CheckBox_setSelected(widget.row_checkbox, is_checked)
                        local name_color = is_selected and "#F4FDFF" or (is_checked and "#F0C14B" or getGroupNameColor(widget.group_name))
                        setRecycleText(widget.row_text, name_color, is_selected and 19 or 18, "#110b05")
                    end
                    for _, widget in ipairs(right_item_widgets) do
                        local item_checked = item_is_selected(selected_entry, widget.item_idx)
                        GUI:setOpacity(widget.item_row, item_checked and 245 or 165)
                        GUI:CheckBox_setSelected(widget.item_checkbox, item_checked)
                        setRecycleText(widget.item_name_text, item_checked and "#FFE58F" or "#F3E8CE", 19, "#110b05")
                    end
                    dual_refresh_lock = false
                end
                local left_scroll = GUI:ScrollView_Create(left_bg, "left_scroll", 0, 6, left_width - 12 + 30, visible_height - 12, 1)
                local left_inner_height = math.max(visible_height - 12, #flat_subgroups * 43) + 10
                GUI:ScrollView_setInnerContainerSize(left_scroll, left_width - 12, left_inner_height)
                GUI:setTouchEnabled(left_scroll, true)
                -- GUI:ScrollView_setClippingEnabled(left_scroll, false) 
                GUI:ScrollView_setBounceEnabled(left_scroll, true)
                local left_list = GUI:Layout_Create(left_scroll, "left_list", 0, 0, left_width - 12, left_inner_height, false)
                for idx, subgroup_entry in ipairs(flat_subgroups) do
                    local row = GUI:Image_Create(left_list, "subgroup_row" .. idx, 0, 0, "res/wy/public/new_kuang.png")
                    GUI:setContentSize(row, left_width - 12, 44)
                    local group_name = subgroup_entry.cfg.name or ("分组" .. tostring(idx))
                    local is_selected = subgroup_entry.subgroup_key == selected_entry.subgroup_key
                    local is_checked = subgroup_all_selected(subgroup_entry)
                    GUI:setOpacity(row, is_selected and 118 or (is_checked and 190 or 128))
                    if is_selected then
                        local selected_cover = GUI:Image_Create(row, "selected_cover", 0, 3, "res/wy/public/huishou/hsan_kuang.png")
                        GUI:setContentSize(selected_cover, left_width + 16 + 30, 40)
                        GUI:setOpacity(selected_cover, 255)
                    end
                    local row_checkbox_slot = GUI:Image_Create(row, "checkbox_slot", left_width - 46, 7, "res/wy/public/40-40.png")
                    GUI:setContentSize(row_checkbox_slot, 30, 30)
                    GUI:setOpacity(row_checkbox_slot, is_selected and 220 or 165)
                    local row_checkbox = GUI:CheckBox_Create(row, "CheckBox", left_width - 42 - 5, 7, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                    GUI:CheckBox_setSelected(row_checkbox, is_checked)
                    GUI:CheckBox_addOnEvent(row_checkbox, function(self)
                        if dual_refresh_lock then
                            return
                        end
                        local selected = GUI:CheckBox_isSelected(self)
                        syncSelection(subgroup_entry.subgroup_key, selected)
                        if selected then
                            clearSelectionIfNeeded(subgroup_entry.group_key)
                        else
                            clearSelectionIfNeeded(subgroup_entry.group_key)
                            clearSelectionIfNeeded(subgroup_entry.subgroup_key)
                        end
                        refresh_dual_pane_selection_state()
                        if refresh_bulk_select_state then
                            refresh_bulk_select_state()
                        end
                    end)
                    local display_group_name = formatRecycleGroupDisplayName(category_key, group_name)
                    local name_color = is_selected and "#F4FDFF" or (is_checked and "#F0C14B" or getGroupNameColor(group_name))
                    local row_text = GUI:Text_Create(row, "name", is_selected and 20 or 14, 22, is_selected and 19 or 18, name_color, display_group_name)
                    GUI:setAnchorPoint(row_text, 0, 0.5)
                    setRecycleText(row_text, name_color, is_selected and 19 or 18, "#110b05")
                    GUI:setTouchEnabled(row, true)
                    GUI:addOnClickEvent(row, function()
                        npc.recycle_subgroup_key_by_tab[npc.s] = subgroup_entry.subgroup_key
                        new_hs_update()
                    end)
                    left_row_widgets[#left_row_widgets + 1] = {
                        row = row,
                        row_checkbox = row_checkbox,
                        row_checkbox_slot = row_checkbox_slot,
                        row_text = row_text,
                        subgroup_entry = subgroup_entry,
                        group_name = group_name,
                    }
                end
                GUI:UserUILayout(left_list, {
                    dir = 3,
                    addDir = 1,
                    gap = {
                        x = 0,
                        y = 0,
                    },
                })
                local right_scroll = GUI:ScrollView_Create(right_bg, "right_scroll", 6, 6, right_width - 12 + 40, visible_height - 12, 1)
                local visible_item_count = 0
                for _, item_cfg in pairs(selected_entry.cfg.l or {
                }) do
                    if not isRecycleTitleItem(item_cfg) then
                        visible_item_count = visible_item_count + 1
                    end
                end
                local item_row_height = 45
                local right_inner_height = math.max(visible_height - 12, visible_item_count * (item_row_height))
                GUI:ScrollView_setInnerContainerSize(right_scroll, right_width - 12, right_inner_height)
                GUI:setTouchEnabled(right_scroll, true)
                GUI:ScrollView_setBounceEnabled(right_scroll, true)
                local right_list = GUI:Layout_Create(right_scroll, "right_list", 0, 0, right_width - 12, right_inner_height, false)
                for item_idx, item_cfg in sorted_pairs(selected_entry.cfg.l) do
                    if not isRecycleTitleItem(item_cfg) then
                        local item_checked = item_is_selected(selected_entry, item_idx)
                        local item_row = GUI:Image_Create(right_list, "item_row" .. tostring(item_idx), 0, 0, "res/wy/public/new_kuang.png")
                        GUI:setContentSize(item_row, right_width - 16, item_row_height)
                        GUI:setOpacity(item_row, item_checked and 245 or 165)
                        local icon_bg = GUI:Image_Create(item_row, "icon_bg", 20, 15, "res/wy/public/40-40.png")
                        GUI:setContentSize(icon_bg, 20, 20)
                        GUI:setOpacity(icon_bg, 215)
                        local item_show = GUI:ItemShow_Create(icon_bg, "item", 10, 10, {
                            index = item_idx,
                            look = true,
                            bgVisible = false,
                        })
                        GUI:setScale(item_show, 0.5)
                        GUI:setAnchorPoint(item_show, 0.5, 0.5)
                        local item_count = tonumber(SL:GetMetaValue("ITEM_COUNT", item_idx) or 0) or 0
                        if item_count > 0 then
                            local count_text = GUI:Text_Create(icon_bg, "count", 12, -12, 16, "#FFF6D6", "x" .. tostring(item_count))
                            GUI:setAnchorPoint(count_text, 0, 0)
                            GUI:Text_enableOutline(count_text, "#000000", 2)
                            GUI:Text_setFontName(count_text, "fonts/502.ttf")
                        end
                        local item_name = item_cfg and item_cfg[3] or tostring(item_idx)
                        local reward_desc = formatRecycleReward(item_cfg)
                        local item_name_text = GUI:Text_Create(item_row, "item_name", 62, 25, 19, item_checked and "#FFE58F" or "#F3E8CE", item_name)
                        GUI:setAnchorPoint(item_name_text, 0, 0.5)
                        setRecycleText(item_name_text, item_checked and "#FFE58F" or "#F3E8CE", 19, "#110b05")
                        -- local reward_text = GUI:Text_Create(item_row, "reward", 62, 18, 16, item_checked and "#FFF1C2" or "#D8C39A", reward_desc)
                        -- GUI:setAnchorPoint(reward_text, 0, 0.5)
                        -- setRecycleText(reward_text, item_checked and "#FFF1C2" or "#D8C39A", 16, "#110b05")
                        -- local item_checkbox_slot = GUI:Image_Create(item_row, "checkbox_slot", right_width - 68, 14, "res/wy/public/40-40.png")
                        -- GUI:setContentSize(item_checkbox_slot, 34, 34)
                        -- GUI:setOpacity(item_checkbox_slot, 165)
                        local item_checkbox = GUI:CheckBox_Create(item_row, "CheckBox", right_width - 64 + 40, 8, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                        GUI:CheckBox_setSelected(item_checkbox, item_checked)
                        GUI:CheckBox_addOnEvent(item_checkbox, function(self)
                            if dual_refresh_lock then
                                return
                            end
                            syncSelection(tostring(item_idx), GUI:CheckBox_isSelected(self))
                            clearSelectionIfNeeded(selected_entry.group_key)
                            clearSelectionIfNeeded(selected_entry.subgroup_key)
                            refresh_dual_pane_selection_state()
                            if refresh_bulk_select_state then
                                refresh_bulk_select_state()
                            end
                        end)
                        right_item_widgets[#right_item_widgets + 1] = {
                            item_row = item_row,
                            item_checkbox = item_checkbox,
                            item_name_text = item_name_text,
                            item_idx = item_idx,
                        }
                    end
                end
                GUI:UserUILayout(right_list, {
                    dir = 3,
                    addDir = 1,
                    gap = {
                        x = 0,
                        y = 0,
                    },
                })
                return
            end
            local subgroup_count = math.max(#flat_subgroups, 1)
            local visible_width = 414
            local visible_height = 228
            local list_height = math.max(visible_height, 58 * math.ceil(subgroup_count / 2))
            local ScrollView = GUI:ScrollView_Create(jm_node, "ScrollView", 135.0, 112.0, visible_width, visible_height, 1)
            GUI:ScrollView_setInnerContainerSize(ScrollView, visible_width, list_height)
            GUI:setTouchEnabled(ScrollView, true)
            GUI:ScrollView_setBounceEnabled(ScrollView, true)
            local s_list = GUI:Layout_Create(ScrollView, "s_list", 0.0, 0.0, visible_width, list_height)
            local function open_subgroup_popup(anchor_btn, group_key, subgroup_key, subgroup_cfg)
                local xjm_parent = npc.hs_xbj
                if xjm_parent then
                    GUI:removeFromParent(xjm_parent)
                    npc.hs_xbj = nil
                end
                npc.hs_xbj = GUI:Image_Create(jm_node, "bj", 258 + 329, 318, "res/private/item_tips/bg_tipszy_05.png")
                GUI:setAnchorPoint(npc.hs_xbj, 0, 1)
                GUI:setTouchEnabled(npc.hs_xbj, true)
                GUI:setContentSize(npc.hs_xbj, 252, 300)
                GUI:Win_SetZPanel(jm_node, npc.hs_xbj)
                GUI:setLocalZOrder(npc.hs_xbj, 99)
                local titleText = GUI:Text_Create(npc.hs_xbj, "popup_title", 126, 268, 24, "#F4D879", subgroup_cfg.name or "回收分组")
                GUI:setAnchorPoint(titleText, 0.5, 0.5)
                setRecycleText(titleText, "#F4D879", 24, "#110b05")
                local x_close = GUI:Button_Create(npc.hs_xbj, "close", 252, 300, "res/public/1900000511.png")
                GUI:setAnchorPoint(x_close, 0, 1)
                GUI:addOnClickEvent(x_close, function()
                    GUI:removeFromParent(npc.hs_xbj)
                    npc.hs_xbj = nil
                end)
                local function popup_is_all_selected()
                    if (shuju.xz[group_key] and shuju.xz[group_key] == 1) or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1) then
                        return true
                    end
                    local hasEntry = false
                    for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                        if not isRecycleTitleItem(item_cfg) then
                            hasEntry = true
                            if not (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1) then
                                return false
                            end
                        end
                    end
                    return hasEntry
                end
                local s_s_s_list = GUI:ListView_Create(npc.hs_xbj, "s_s_s_list", 11, 46, 230, 198, 1)
                GUI:ListView_setGravity(s_s_s_list, 2)
                GUI:ListView_setItemsMargin(s_s_s_list, 6)
                for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                    if not isRecycleTitleItem(item_cfg) then
                        local s_s_s_btn = GUI:Image_Create(s_s_s_list, "s_s_s_btn" .. item_idx, 0, 0, "res/wy/public/new_kuang.png")
                        GUI:setContentSize(s_s_s_btn, 228, 50)
                        local iconBg = GUI:Image_Create(s_s_s_btn, "icon_bg", 8, 8, "res/wy/public/40-40.png")
                        local itemShow = GUI:ItemShow_Create(iconBg, "item", 20, 20, {
                            index = item_idx,
                            look = true,
                            bgVisible = false,
                        })
                        GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                        local s_s_s_CheckBox = GUI:CheckBox_Create(s_s_s_btn, "CheckBox", 186, 12, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                        GUI:CheckBox_setSelected(s_s_s_CheckBox, (shuju.xz[group_key] and shuju.xz[group_key] == 1) or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1) or (shuju.xz[tostring(item_idx)] and shuju.xz[tostring(item_idx)] == 1))
                        GUI:CheckBox_addOnEvent(s_s_s_CheckBox, function(self)
                            syncSelection(tostring(item_idx), GUI:CheckBox_isSelected(self))
                            clearSelectionIfNeeded(group_key)
                            clearSelectionIfNeeded(subgroup_key)
                        end)
                        local item_name = item_cfg and item_cfg[3] or tostring(item_idx)
                        local reward_desc = formatRecycleReward(item_cfg)
                        local s_s_s_wz = GUI:RichText_Create(s_s_s_btn, "s_s_s_wz", 120, 35, item_name, 200, 16, "#f0c14b", 1, nil, nil, {
                        })
                        GUI:setAnchorPoint(s_s_s_wz, 0.5, 0.5)
                        local rewardText = GUI:Text_Create(s_s_s_btn, "reward", 110, 17, 16, "#F3E8CE", reward_desc)
                        GUI:setAnchorPoint(rewardText, 0.5, 0.5)
                        setRecycleText(rewardText, "#F3E8CE", 16, "#110b05")
                    end
                end
                local allSelectBtn = GUI:Button_Create(npc.hs_xbj, "all_select", 126, 4, "res/public/1900000660.png")
                GUI:setAnchorPoint(allSelectBtn, 0.5, 0)
                GUI:Button_setTitleText(allSelectBtn, popup_is_all_selected() and "取消全选" or "全选")
                GUI:Button_setTitleColor(allSelectBtn, "#F4E7B5")
                GUI:Button_setTitleFontSize(allSelectBtn, 20)
                GUI:Button_titleEnableOutline(allSelectBtn, "#110b05", 2)
                GUI:addOnClickEvent(allSelectBtn, function()
                    local targetSelected = not popup_is_all_selected()
                    if targetSelected then
                        syncSelection(subgroup_key, true)
                        clearSelectionIfNeeded(group_key)
                    else
                        clearSelectionIfNeeded(group_key)
                        clearSelectionIfNeeded(subgroup_key)
                        for item_idx, item_cfg in sorted_pairs(subgroup_cfg.l) do
                            if not isRecycleTitleItem(item_cfg) then
                                clearSelectionIfNeeded(tostring(item_idx))
                            end
                        end
                    end
                    new_hs_update()
                    if refresh_bulk_select_state then
                        refresh_bulk_select_state()
                    end
                    open_subgroup_popup(anchor_btn, group_key, subgroup_key, subgroup_cfg)
                end)
            end
            for v, group_data in sorted_pairs(category_data) do
                if type(group_data) == "table" then
                    for vv, subgroup_cfg in sorted_pairs(group_data) do
                        if type(subgroup_cfg) == "table" and type(subgroup_cfg.l) == "table" then
                            local s_s_btn = GUI:Image_Create(s_list, "s_s_btn" .. tostring(v) .. "_" .. tostring(vv), 0, 0, "res/wy/public/new_kuang.png")
                            GUI:setContentSize(s_s_btn, 198, 48)
                            local s_s_CheckBox = GUI:CheckBox_Create(s_s_btn, "CheckBox", 164, 11, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
                            local group_key = npc.s .. "_" .. tostring(v)
                            local subgroup_key = group_key .. "_" .. tostring(vv)
                            GUI:CheckBox_setSelected(s_s_CheckBox, (shuju.xz[group_key] and shuju.xz[group_key] == 1) or (shuju.xz[subgroup_key] and shuju.xz[subgroup_key] == 1))
                            GUI:CheckBox_addOnEvent(s_s_CheckBox, function(self)
                                local selected = GUI:CheckBox_isSelected(self)
                                syncSelection(subgroup_key, selected)
                                if selected then
                                    clearSelectionIfNeeded(group_key)
                                end
                            end)
                            local group_name = subgroup_cfg.name or ("分组" .. tostring(vv))
                            local display_group_name = formatRecycleGroupDisplayName(category_key, group_name)
                            local color = getGroupNameColor(group_name)
                            local s_s_wz = GUI:Text_Create(s_s_btn, "wz", 84, 26, 18, color, display_group_name)
                            GUI:setAnchorPoint(s_s_wz, 0.5, 0.5)
                            setRecycleText(s_s_wz, color, 18, "#110b05")
                            GUI:setTouchEnabled(s_s_btn, true)
                            GUI:addOnClickEvent(s_s_btn, function()
                                open_subgroup_popup(s_s_btn, group_key, subgroup_key, subgroup_cfg)
                            end)
                        end
                    end
                end
            end
            GUI:UserUILayout(s_list, {
                dir = 3,
                addDir = 1,
                colnum = 2,
                gap = {
                    x = 12,
                    y = 10,
                },
            })
        end
        npc.s = 1
        npc.s_s = 1
        npc.s_s_s = 1
        npc.hs_btn = {
        }
        local l_list = GUI:ListView_Create(ty_node, "ListView", 15.0, 15.0, 120.0, 325.0, 1)
        GUI:ListView_setItemsMargin(l_list, 8)
        GUI:ListView_setGravity(l_list, 2)
        for ii = 1, 6 do
            GUI:Image_Create(l_list, "fgx" .. ii, 0, 0, "res/wy/public/huishou/hsan_fgx.png")
            npc.hs_btn["s_" .. ii] = GUI:Button_Create(l_list, "san" .. ii, 0, 0, "res/wy/public/huishou/hsan_nsan_" .. ii .. ".png")
            GUI:addOnClickEvent(npc.hs_btn["s_" .. ii], function()
                GUI:Button_loadTextureNormal(npc.hs_btn["s_" .. npc.s], "res/wy/public/huishou/hsan_nsan_" .. npc.s .. ".png")
                GUI:removeChildByName(GUI:ui_delegate(l_list)["fgx" .. npc.s], "kuang")
                npc.s = ii
                npc.s_s = 1
                npc.s_s_s = 1
                GUI:Button_loadTextureNormal(npc.hs_btn["s_" .. npc.s], "res/wy/public/huishou/hsan_lsan_" .. npc.s .. ".png")
                GUI:Image_Create(GUI:ui_delegate(l_list)["fgx" .. npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
                new_hs_update()
                if refresh_bulk_select_state then
                    refresh_bulk_select_state()
                end
            end)
        end
        GUI:Button_loadTextureNormal(npc.hs_btn["s_" .. npc.s], "res/wy/public/huishou/hsan_lsan_" .. npc.s .. ".png")
        GUI:Image_Create(GUI:ui_delegate(l_list)["fgx" .. npc.s], "kuang", -5, -43, "res/wy/public/huishou/hsan_kuang.png")
        local CheckBox_zdhs = GUI:CheckBox_Create(ty_node, "kaiguan1", 380, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox_zdhs, shuju.kg[4] == 1)
        GUI:CheckBox_addOnEvent(CheckBox_zdhs, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 4, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        local CheckBox2 = GUI:CheckBox_Create(ty_node, "kaiguan2", 250, 30, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox2, shuju.kg[3] == 1)
        GUI:CheckBox_addOnEvent(CheckBox2, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 3, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        local CheckBox3 = GUI:CheckBox_Create(ty_node, "kaiguan3", 250, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_setSelected(CheckBox3, shuju.kg[2] == 1)
        GUI:CheckBox_addOnEvent(CheckBox3, function(self)
            SL:SendLuaNetMsg(101, 2, 4, 1, GUI:CheckBox_isSelected(self) and 1 or 0)
            SL:SendLuaNetMsg(101, 2, 4, 2, GUI:CheckBox_isSelected(self) and 1 or 0)
        end)
        local CheckBox4 = GUI:CheckBox_Create(ty_node, "kaiguan4", 380, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        local CheckBox5
        local bulk_checkbox_lock = false
        refresh_bulk_select_state = function()
            local keys = collect_current_select_keys()
            local allSelected = #keys > 0
            for _, key in ipairs(keys) do
                if not (shuju.xz[key] and shuju.xz[key] == 1) then
                    allSelected = false
                    break
                end
            end
            bulk_checkbox_lock = true
            GUI:CheckBox_setSelected(CheckBox4, allSelected)
            GUI:CheckBox_setSelected(CheckBox5, not allSelected)
            bulk_checkbox_lock = false
        end
        GUI:CheckBox_addOnEvent(CheckBox4, function(self)
            if bulk_checkbox_lock then
                return
            end
            batch_set_current_select_state(true)
            refresh_bulk_select_state()
            new_hs_update()
        end)
        CheckBox5 = GUI:CheckBox_Create(ty_node, "kaiguan5", 510, 65, "res/wy/public/xz0.png", "res/wy/public/xz1.png")
        GUI:CheckBox_addOnEvent(CheckBox5, function(self)
            if bulk_checkbox_lock then
                return
            end
            batch_set_current_select_state(false)
            refresh_bulk_select_state()
            new_hs_update()
        end)
        npc.yjcz = GUI:Button_Create(ty_node, 'yjcz', 430, 15, 'res/wy/public/hsan_11.png')
        GUI:addOnClickEvent(npc.yjcz, function()
            if npc.s >= 1 and npc.s <= 7 then
                local item = SL:GetMetaValue("BAG_DATA")
                local hs = {
                }
                local huishou_jc_list = cogin.huishou_jc_list
                for k, v in pairs(item) do
                    if huishou_jc_list[v.Index] and (hasGroupSelection(huishou_jc_list[v.Index]) or shuju.xz["" .. v.Index]) then
                        table.insert(hs, k)
                    end
                end
                if #hs > 0 then
                    SL:SendLuaNetMsg(101, 2, 5, 1, SL:JsonEncode(hs, false))
                    SL:ShowSystemTips("<font color='#00ff00'>一键回收执行完成</font>")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未发现可分解物品</font>")
                end
            end
        end)
        new_hs_update()
        refresh_bulk_select_state()
    elseif p2 == 4 then
        if npc.bbzs then
        end
    end
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close", function(self)
        if self == "npc_huishou" then
            SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "recycle_close")
            local xjm_parent = npc.hs_xbj
            if xjm_parent then
                GUI:removeFromParent(xjm_parent)
                npc.hs_xbj = nil
            end
        end
    end)
end
npc.xyl = SL:Require("GUILayout/Data/xyl.lua", true)
local LUA_EVENT_YWL_CURRENT_TASK_CHANGE = "伏妖录当前任务变更"
npc[11] = function(p2, p3, Data)
    local AUTO_GUIDE_TASKS = {
        ["天书强化"] = true,
        ["初识仙法"] = true,
        ["天书仙法"] = true,
        ["限时福利"] = true,
        ["扫荡野火帮"] = true,
        ["气运占卜"] = true,
        ["深入野火"] = true,
        ["本命灵根"] = true,
        ["修复聚宝盆"] = true,
        ["聚宝盆"] = true,
        ["聚宝盆任务"] = true,
        ["洗炼天书"] = true,
        ["引导天书使者洗炼一次"] = true,
        ["装备强化"] = true,
        ["装备强化1次"] = true,
        ["守护森林"] = true,
        ["江湖称号升级1次"] = true,
        ["杀伐之路"] = true,
        ["灵兽孵化"] = true,
        ["掘墓人"] = true,
        ["讨伐夜魔"] = true,
        ["古刹之谜"] = true,
        ["修复轩辕剑"] = true,
        ["筑基"] = true,
        ["提升修为至筑基境"] = true,
        ["转生·二"] = true,
        ["完成转生"] = true,
        ["完转生"] = true,
        ["完成2大陆转生"] = true,
        ["开辟仙府"] = true,
        ["寻宝大师"] = true,
    }
    local function _ywl_get_task_name_from_current_task(currentTask)
        if type(currentTask) ~= "table" then
            return ""
        end
        local taskName = tostring(currentTask.name or currentTask.task_name or currentTask.taskName or "")
        if taskName ~= "" then
            return taskName
        end
        local dq = tostring(currentTask.dq or currentTask.current_xyl_dq or currentTask.currentXylDq or "")
        local i, j, z = string.match(dq, "^(%d+)_(%d+)_(%d+)$")
        i = tonumber(i)
        j = tonumber(j)
        z = tonumber(z)
        local task = i and j and z and npc.xyl and npc.xyl[i] and npc.xyl[i][j] and npc.xyl[i][j].jq and npc.xyl[i][j].jq[z]
        if type(task) == "table" then
            return tostring(task[1] or task.title or "")
        end
        return ""
    end
    local function _ywl_is_auto_chapter_continent(i)
        return tonumber(i) == 2
    end
    local function _ywl_get_current_dq(payload)
        local payloadDq = tostring(payload and payload.ywl and payload.ywl.dq or "")
        if payloadDq ~= "" then
            return payloadDq
        end
        local currentTask = npc.current_ywl_task or {}
        local dq = tostring(currentTask.dq or currentTask.current_xyl_dq or currentTask.currentXylDq or "")
        if dq ~= "" then
            return dq
        end
        local ywlData = payload and payload.ywl or (npc.data and npc.data.ywl) or {}
        return tostring(ywlData.dq or "")
    end
    local function _ywl_should_hide_storylog(payload)
        return _ywl_get_current_dq(payload):match("^2_%d+_%d+$") ~= nil
    end
    local function _ywl_close_storylog()
        NPC_UI_HELPER.closeGuideByDomain("xyl")
        NPC_UI_HELPER.closeWindow(windowCache.storyLog)
        windowCache.storyLog = nil
        npc.bg = nil
        npc.node_11 = nil
        npc.ywl_list = nil
        npc._ywl_auto_guided_chapter = nil
        npc._ywl_auto_guided_reward_key = nil
    end
    local function _ywl_is_chapter_reward_ready(i, j)
        if _ywl_is_auto_chapter_continent(i) then
            return false
        end
        local lCfg = npc.xyl and npc.xyl[i]
        local zjCfg = type(lCfg) == "table" and lCfg[j] or nil
        local tasks = zjCfg and zjCfg.jq or nil
        if type(tasks) ~= "table" or #tasks <= 0 then
            return false
        end
        local ywlData = npc.data and npc.data.ywl or {
        }
        if ywlData["jl_" .. i .. "_" .. j] == 1 then
            return false
        end
        for idx = 1, #tasks do
            if ywlData["jl_" .. i .. "_" .. j .. "_" .. idx] ~= 1 then
                return false
            end
        end
        return true
    end
    local function _ywl_try_start_chapter_reward_guide(guideParent, force)
        if not npc.jl then
            return false
        end
        local i = tonumber(npc.l) or 0
        local j = tonumber(npc.zj) or 0
        if i <= 0 or j <= 0 then
            return false
        end
        if not _ywl_is_chapter_reward_ready(i, j) then
            return false
        end
        local guideKey = string.format("%s_%s_reward", tostring(i), tostring(j))
        if not force and npc._ywl_auto_guided_reward_key == guideKey then
            return false
        end
        npc._ywl_auto_guided_reward_key = guideKey
        NPC_UI_HELPER.startGuide({
            dir = 3,
            guideWidget = npc.jl,
            guideParent = guideParent or GUI:getParent(npc.jl),
            guideDesc = "点击领取章节奖励",
            isForce = false,
            hideMask = true,
        })
        return true
    end
    local function _ywl_find_next_chapter(curL, curZj)
        local startL = tonumber(curL) or 2
        local startZj = tonumber(curZj) or 0
        for i = startL, #npc.xyl do
            local lCfg = npc.xyl[i]
            if type(lCfg) == "table" and #lCfg > 0 then
                local begin = 1
                if i == startL then
                    begin = math.max(1, startZj + 1)
                end
                for j = begin, #lCfg do
                    return i, j
                end
            end
        end
        return nil, nil
    end
    local function _ywl_is_valid_gui_node(node)
        if not node then
            return false
        end
        return not tolua.isnull(node)
    end
    local function _ywl_story_node_done(node)
        if node == nil then
            return false
        end
        if type(node) == "number" then
            return tonumber(node) >= 2
        end
        if type(node) == "table" then
            if tonumber(node[1] or node["1"] or 0) >= 2 then
                return true
            end
            if tonumber(node.wc or node.finish or node.done or node.ok or 0) >= 1 then
                return true
            end
            if tonumber(node.cnt or node.num or 0) >= 2 then
                return true
            end
        end
        return false
    end
    local function _ywl_story_node_started(node)
        if node == nil then
            return false
        end
        if type(node) == "number" then
            return tonumber(node) > 0
        end
        if type(node) == "table" then
            if tonumber(node[1] or node["1"] or 0) > 0 then
                return true
            end
            if tonumber(node.wc or node.finish or node.done or node.ok or 0) > 0 then
                return true
            end
            if tonumber(node.cnt or node.num or 0) > 0 then
                return true
            end
        end
        return false
    end
    local function _ywl_is_task_started_or_done_by_story(taskName, task)
        local raw = Player:getServerVar("T13")
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end
        local tk = task and task.tk
        if tk and _ywl_story_node_started(storyData[tk]) then
            return true
        end
        if taskName == "开辟仙府" then
            local xianfuRaw = Player:getServerVar("T47")
            if xianfuRaw and xianfuRaw ~= "" then
                local xianfuOk, xianfuData = pcall(function()
                    return Player:JsonToTbl(xianfuRaw)
                end)
                return xianfuOk and type(xianfuData) == "table" and next(xianfuData) ~= nil
            end
        end
        return false
    end
    local function _ywl_has_third_continent_full_entry()
        local raw = Player:getServerVar("T13")
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end
        return _ywl_story_node_done(storyData["npc_46"])
    end
    function _ywl_has_third_continent_half_entry()
        local raw = Player:getServerVar("T13")
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end
        return _ywl_story_node_done(storyData["npc_46"])
    end
    local function _ywl_is_third_continent_half_chapter(name)
        if not name or name == "" then
            return false
        end
        return name == "灰界开篇" or name == "壮志凌云"
    end
    local function _ywl_append_reward_entries(outList, rewardList, seenMap, continent)
        if type(rewardList) ~= "table" then
            return
        end
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and entry[1] ~= nil and entry[2] ~= nil then
                local key = tostring(entry[1])
                local count = tonumber(entry[2]) or 0
                if key ~= "" and count > 0 then
                    local pos = seenMap[key]
                    if pos then
                        outList[pos][2] = (tonumber(outList[pos][2]) or 0) + count
                    else
                        table.insert(outList, {
                            entry[1],
                            count,
                        })
                        seenMap[key] = #outList
                    end
                end
            end
        end
    end
    local function _ywl_filter_reward_entries(rewardList, continent)
        if type(rewardList) ~= "table" then
            return rewardList
        end
        return rewardList
    end
    local function _ywl_normalize_title_reward_name(titleName)
        if type(titleName) ~= "string" then
            return ""
        end
        local rewardName = string.gsub(titleName, "^%s+", "")
        rewardName = string.gsub(rewardName, "%s+$", "")
        if rewardName == "" then
            return ""
        end
        local oldTitleName = string.match(rewardName, "^称号%[(.-)%]$")
        if type(oldTitleName) == "string" and oldTitleName ~= "" then
            rewardName = oldTitleName
        else
            rewardName = string.gsub(rewardName, "%[称号%]$", "")
        end
        return rewardName .. "[称号]"
    end
    local function _ywl_append_title_reward(outList, titleName, seenMap)
        local rewardName = _ywl_normalize_title_reward_name(titleName)
        if rewardName == "" then
            return
        end
        local pos = seenMap[rewardName]
        if pos then
            outList[pos][2] = math.max(tonumber(outList[pos][2]) or 0, 1)
        else
            table.insert(outList, {
                rewardName,
                1,
            })
            seenMap[rewardName] = #outList
        end
    end
    local function _ywl_is_title_reward_name(name)
        return type(name) == "string" and (string.find(name, "%[称号%]") ~= nil or string.match(name, "^称号%[.+%]$") ~= nil)
    end
    local function _ywl_trim_reward_display(rewardList)
        if type(rewardList) ~= "table" or #rewardList <= 0 then
            return {
            }
        end
        local titleRewards = {
        }
        local otherRewards = {
        }
        for _, entry in ipairs(rewardList) do
            if type(entry) == "table" and _ywl_is_title_reward_name(entry[1]) then
                table.insert(titleRewards, entry)
            else
                table.insert(otherRewards, entry)
            end
        end
        local merged = {
        }
        for _, entry in ipairs(titleRewards) do
            table.insert(merged, entry)
        end
        for _, entry in ipairs(otherRewards) do
            table.insert(merged, entry)
        end
        local result = {
        }
        for i = 1, math.min(2, #merged) do
            result[i] = merged[i]
        end
        return result
    end
    local function _ywl_collect_task_rewards(task, continent)
        if type(task) ~= "table" then
            return {
            }
        end
        local rewardList = {
        }
        local seenMap = {
        }
        _ywl_append_reward_entries(rewardList, task.jl, seenMap, continent)
        _ywl_append_reward_entries(rewardList, task.rwjl, seenMap, continent)
        _ywl_append_reward_entries(rewardList, task.give, seenMap, continent)
        _ywl_append_title_reward(rewardList, task.ch, seenMap)
        local handledNpcIds = {
        }
        local function appendNpcReward(npcId)
            npcId = tonumber(npcId)
            if not npcId or npcId <= 0 or handledNpcIds[npcId] then
                return
            end
            handledNpcIds[npcId] = true
            local cfg = teshudata and teshudata["npc_" .. tostring(npcId)]
            if type(cfg) == "table" then
                _ywl_append_reward_entries(rewardList, cfg.rwjl, seenMap, continent)
                _ywl_append_reward_entries(rewardList, cfg.jl, seenMap, continent)
                _ywl_append_reward_entries(rewardList, cfg.give, seenMap, continent)
                _ywl_append_title_reward(rewardList, cfg.ch, seenMap)
            end
        end
        if type(task.tk) == "string" then
            appendNpcReward(task.tk:match("^npc_(%d+)$"))
        end
        if type(task.yd) == "table" then
            appendNpcReward(task.yd[3])
        end
        return _ywl_trim_reward_display(rewardList)
    end
    -- 读取单个伏妖录任务奖励中的剧情点数量，用作大陆进度权重。
    local function _ywl_get_task_story_point(task)
        local total = 0
        local rewards = type(task) == "table" and task.jl or nil
        if type(rewards) ~= "table" then
            return 0
        end
        for _, reward in ipairs(rewards) do
            if type(reward) == "table" and reward[1] == "剧情点" then
                total = total + (tonumber(reward[2]) or 0)
            end
        end
        return total
    end
    -- 统计当前大陆所有伏妖录剧情点领取进度，用于替代原章节奖励展示。
    -- 注意：这里只按奖励领取标记统计，任务已完成但未点击领取不计入进度。
    local function _ywl_collect_continent_progress(continent)
        local l = tonumber(continent) or 0
        local chapters = npc.xyl and npc.xyl[l] or nil
        local ywlData = npc.data and npc.data.ywl or {}
        local done = 0
        local total = 0
        if type(chapters) ~= "table" then
            return 0, 0, 0
        end
        for j, chapter in ipairs(chapters) do
            local tasks = chapter and chapter.jq or nil
            if type(tasks) == "table" then
                local chapterDone = tonumber(ywlData["jl_" .. l .. "_" .. j] or 0) == 1
                for idx, task in ipairs(tasks) do
                    local storyPoint = _ywl_get_task_story_point(task)
                    total = total + storyPoint
                    local taskDoneByReward = tonumber(ywlData["jl_" .. l .. "_" .. j .. "_" .. idx] or 0) == 1
                    if chapterDone or taskDoneByReward then
                        done = done + storyPoint
                    end
                end
            end
        end
        local percent = total > 0 and math.floor(done * 100 / total) or 0
        return done, total, math.max(0, math.min(100, percent))
    end
    -- 展示本大陆全部伏妖录任务的剧情点领取进度。
    local function _ywl_render_continent_progress(node)
        local done, total = _ywl_collect_continent_progress(npc.l)
        local percent = total > 0 and math.floor(done * 100 / total) or 0
        local root = GUI:Layout_Create(node, "continent_progress", 515 - 260, 40, 420, 45, false)
        local title = GUI:Text_Create(root, "title", 0, 22, 22, "#F4D179", "剧情\n进度")
        GUI:setAnchorPoint(title, 0, 0.5)
        GUI:Text_setFontName(title, "fonts/502.ttf")
        GUI:Text_enableOutline(title, "#1B0B02", 3)

        local barBg = GUI:Layout_Create(root, "bar_bg", 60, 10, 180, 24, false)
        GUI:Layout_setBackGroundColorType(barBg, 1)
        GUI:Layout_setBackGroundColor(barBg, "#2A160B")
        GUI:Layout_setBackGroundColorOpacity(barBg, 220)

        local fillW = math.max(1, math.floor(178 * percent / 100))
        local barFill = GUI:Layout_Create(barBg, "bar_fill", 1, 2, fillW, 20, false)
        GUI:Layout_setBackGroundColorType(barFill, 1)
        GUI:Layout_setBackGroundColor(barFill, "#D46A18")
        GUI:Layout_setBackGroundColorOpacity(barFill, 255)

        local progressText = GUI:Text_Create(barBg, "progress_text", 90, 12, 20, "#FFFF00", tostring(done) .. "/" .. tostring(total))
        GUI:setAnchorPoint(progressText, 0.5, 0.5)
        GUI:Text_setFontName(progressText, "fonts/502.ttf")
        GUI:Text_enableOutline(progressText, "#000000", 2)
    end
    if p2 == 0 then
        npc.data = Data and SL:JsonDecode(Data, false) or {
        }
        if type(npc.data) == "table" and npc.data.dl_all_unlock ~= nil and cogin and cogin.sjtb then
            cogin.sjtb.dl_all_unlock = tonumber(npc.data.dl_all_unlock) or 0
        end
        if type(npc.data) == "table" and type(npc.data.ywl) == "table" and next(npc.data.ywl) ~= nil then
            rawset(_G, "XYL_YWL_CACHE", npc.data.ywl)
        end
        if _ywl_should_hide_storylog(npc.data) then
            _ywl_close_storylog()
            return
        end
        npc._ywl_auto_guided_chapter = nil
        local function isChapterDone(i, j)
            return npc.data and npc.data.ywl and npc.data.ywl["jl_" .. i .. "_" .. j] == 1
        end
        local function ywlGetRelevel()
            local zslv = tonumber(Player and Player.getServerVar and Player:getServerVar("U43") or 0) or 0
            if zslv <= 0 then
                zslv = tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0
            end
            return zslv
        end
        local function ywlGetLevel()
            return tonumber(SL:GetMetaValue("LEVEL") or 0) or 0
        end
        local function ywlHasAllLinggen()
            local data = Player and Player.JsonToTbl and Player:getServerVar("T41") and Player:JsonToTbl(Player:getServerVar("T41")) or {}
            local levels = type(data) == "table" and type(data.level) == "table" and data.level or {}
            for idx = 1, 5 do
                if (tonumber(levels[tostring(idx)] or levels[idx]) or 0) < 1 then
                    return false
                end
            end
            return true
        end
        local function ywlHasAllDestiny()
            local data = Player and Player.JsonToTbl and Player:getServerVar("T13") and Player:JsonToTbl(Player:getServerVar("T13")) or {}
            local state = type(data) == "table" and type(data["npc_74"]) == "table" and data["npc_74"] or {}
            local cfg74 = type(teshudata) == "table" and teshudata["npc_74"] or {}
            local need = tonumber(cfg74 and cfg74.all) or 4
            return (tonumber(state.all) or 0) >= need
        end
        local function ywlHasTitle(titleName)
            local itemIdx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName) or 0) or 0
            if itemIdx <= 0 then
                return false
            end
            return SL:GetMetaValue("TITLE_DATA_BY_ID", itemIdx) ~= nil
        end
        local _YWL_EXTRA_PROGRESS_CHAPTERS = {
            ["苍云秘闻"] = true,
            ["若水秘闻"] = true,
            ["灵兽奥秘"] = true,
            ["灵虚秘闻"] = true,
        }
        local function ywlShouldSkipProgressChapter(chapter)
            if type(chapter) ~= "table" then
                return false
            end
            return _YWL_EXTRA_PROGRESS_CHAPTERS[tostring(chapter.name or "")] == true
        end
        local function ywlGetStoryProgress(continent)
            local chapters = npc.xyl and npc.xyl[continent] or nil
            local ywl = npc.data and npc.data.ywl or {}
            local done = 0
            local total = 0
            if type(chapters) ~= "table" then
                return 0, 0
            end
            for chapterIdx, chapter in ipairs(chapters) do
                local skipTotal = ywlShouldSkipProgressChapter(chapter)
                local tasks = type(chapter) == "table" and chapter.jq or nil
                if type(tasks) == "table" then
                    local chapterKey = "jl_" .. continent .. "_" .. chapterIdx
                    local chapterReceived = tonumber(ywl[chapterKey] or 0) == 1
                    for taskIdx, task in ipairs(tasks) do
                        local point = _ywl_get_task_story_point(task)
                        if not skipTotal then
                            total = total + point
                        end
                        local taskReceived = tonumber(ywl[chapterKey .. "_" .. taskIdx] or 0) == 1
                        if point > 0 and (chapterReceived or taskReceived) then
                            done = done + point
                        end
                    end
                end
            end
            return done, total
        end
        local function ywlStoryTarget(total, percent)
            total = tonumber(total) or 0
            if total <= 0 then
                return 0
            end
            return math.ceil(total * (tonumber(percent) or 100) / 100)
        end
        local function isYwlContinentUnlocked(continent)
            continent = tonumber(continent) or 0
            local adminUnlock = cogin and cogin.sjtb and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
            if adminUnlock == 1 or adminUnlock >= continent then
                return true
            end
            if continent <= 3 then
                return type(dl_sz) ~= "function" or dl_sz(continent) == true
            elseif continent == 4 then
                local done, total = ywlGetStoryProgress(3)
                return done >= ywlStoryTarget(total, 85) and ywlGetRelevel() >= 30 and ywlGetLevel() >= 150
            elseif continent == 5 then
                local done, total = ywlGetStoryProgress(4)
                return done >= ywlStoryTarget(total, 95) and ywlGetRelevel() >= 40 and ywlHasAllLinggen()
            elseif continent == 6 then
                local done, total = ywlGetStoryProgress(5)
                return done >= ywlStoryTarget(total, 95) and ywlGetRelevel() >= 50 and ywlHasAllDestiny()
            elseif continent == 7 then
                local done, total = ywlGetStoryProgress(6)
                return done >= ywlStoryTarget(total, 100) and ywlGetRelevel() >= 60 and ywlHasTitle("世界符文·[真我]")
            elseif continent == 8 then
                return ywlGetRelevel() >= 70
            end
            return true
        end
        local function findNearestUnfinished()
            for i = 2, #npc.xyl do
                local lCfg = npc.xyl[i]
                if type(lCfg) == "table" and #lCfg > 0 then
                    for j = 1, #lCfg do
                        if not isChapterDone(i, j) then
                            return i, j
                        end
                    end
                end
            end
            local li, zj = 2, 1
            for i = 2, #npc.xyl do
                local lCfg = npc.xyl[i]
                if type(lCfg) == "table" and #lCfg > 0 then
                    li = i
                    zj = #lCfg
                end
            end
            return li, zj
        end
        if npc.l == nil or npc.zj == nil then
            npc.l, npc.zj = findNearestUnfinished()
        end
        local curCfg = npc.xyl[npc.l]
        if type(curCfg) ~= "table" or #curCfg == 0 then
            npc.l, npc.zj = findNearestUnfinished()
            curCfg = npc.xyl[npc.l]
        end
        if type(curCfg) == "table" and #curCfg > 0 then
            npc.zj = math.max(1, math.min(npc.zj, #curCfg))
        else
            npc.l, npc.zj = 2, 1
        end
        local win = ensureWindow("storyLog", 11, {
            titleText = "异闻录",
        })
        npc.bg = win.bg
        npc.node_11 = win.node
        local chapterList = GUI:ListView_Create(npc.bg, "chapter_list", 25, 23, 230, 520 - 23, 1, false)
        GUI:ListView_setGravity(chapterList, 2)
        GUI:ListView_setItemsMargin(chapterList, 3)
        npc.ywl_list = chapterList
        local function renderTasks(node)
            GUI:removeAllChildren(node)
            local lCfg = npc.xyl[npc.l]
            if not lCfg then
                return
            end
            npc.zj = math.min(npc.zj, #lCfg)
            local zjCfg = lCfg[npc.zj]
            if not zjCfg then
                return
            end
            local tasks = zjCfg.jq or zjCfg
            local taskCount = #tasks
            local curJqd = tonumber(SL:GetMetaValue("TMONEY", "剧情点")) or 0
            local need = tonumber(zjCfg.jqd) or 0
            local lackJqd = zjCfg.jqd and curJqd < need
            local lockInfo = npc.xyl and npc.xyl.get_chapter_lock_info and npc.xyl.get_chapter_lock_info(npc.l, npc.zj, curJqd) or nil
            local lockExtTips = {
            }
            if lockInfo then
                need = tonumber(lockInfo.need_jqd) or need
                lackJqd = lockInfo.lack_jqd and true or false
                lockExtTips = lockInfo.ext_tips or {
                }
            end
            local lockedByJqd = lockInfo and lockInfo.locked or lackJqd
            if lockedByJqd then
                GUI:Image_Create(node, "500-300", 250, 108, 'res/wy/public/500-300.png')
                GUI:Image_Create(node, "lock", 250, 100, 'res/wy/public/xz_img.png')
                GUI:setContentSize(GUI:ui_delegate(node)["lock"], 675, 414)
                GUI:setContentSize(GUI:ui_delegate(node)["500-300"], 675, 414)
                local tip = lockInfo and lockInfo.tip or nil
                if not tip or tip == "" then
                    tip = lackJqd and string.format("剧情点不足：%d/%d", curJqd, need) or "章节未解锁"
                end
                local tipText = GUI:Text_Create(node, "lock_tip", 588, 160, 24, "#FFFFFF", tip)
                GUI:Text_setFontName(tipText, "fonts/502.ttf")
                GUI:Text_enableOutline(tipText, "#000000", 2)
                GUI:setAnchorPoint(tipText, 0.5, 0.5)
                for i, txt in ipairs(lockExtTips) do
                    local extTip = GUI:Text_Create(node, "lock_tip_ext_" .. i, 588, 128 - ((i - 1) * 30), 20, "#FFE9A3", txt)
                    GUI:Text_setFontName(extTip, "fonts/502.ttf")
                    GUI:Text_enableOutline(extTip, "#000000", 2)
                    GUI:setAnchorPoint(extTip, 0.5, 0.5)
                end
            else
                local scroll = GUI:ScrollView_Create(node, "task_scroll", 250, 110, 675, 414, 2)
                GUI:ScrollView_setBounceEnabled(scroll, true)
                local taskCardWidth = 232
                local taskCardGapX = 0
                local taskCardStepX = taskCardWidth + taskCardGapX
                local layoutWidth = taskCount * taskCardStepX + taskCardStepX - 70
                GUI:ScrollView_setInnerContainerSize(scroll, layoutWidth, 414)
                local layout = GUI:Layout_Create(scroll, "task_layout", 0, 0, layoutWidth, 414, false)
                local autoGuideWidget = nil
                local autoGuideDesc = nil
                local taskSlots = {
                }
                local taskSlotState = {
                }
                local function _slot_state(slot)
                    return taskSlotState[slot]
                end
                local function _relayout_task_cards(withAnim)
                    local x = 0
                    for _, slot in ipairs(taskSlots) do
                        local slotUi = _slot_state(slot)
                        local targetY = 0
                        if withAnim then
                            GUI:stopAllActions(slot)
                            GUI:runAction(slot, GUI:ActionMoveTo(0.12, x, targetY))
                        else
                            GUI:setPosition(slot, x, targetY)
                        end
                        local w = (slotUi and (slotUi.current_w or slotUi.base_w)) or taskCardWidth
                        x = x + w + taskCardGapX
                    end
                    local innerWidth = math.max(layoutWidth, x + taskCardGapX)
                    GUI:setContentSize(layout, innerWidth, 414)
                end
                local function _ywl_vertical_text(text)
                    if not text then
                        return ""
                    end
                    local s = tostring(text)
                    local out = {
                    }
                    local i = 1
                    while i <= #s do
                        local c = string.byte(s, i)
                        local len = 1
                        if c >= 240 then
                            len = 4
                        elseif c >= 224 then
                            len = 3
                        elseif c >= 192 then
                            len = 2
                        end
                        local ch = string.sub(s, i, i + len - 1)
                        if ch == "（" or ch == "(" then
                            local close = (ch == "（") and "）" or ")"
                            local j = i + len
                            while j <= #s do
                                local cb = string.byte(s, j)
                                local clen = 1
                                if cb >= 240 then
                                    clen = 4
                                elseif cb >= 224 then
                                    clen = 3
                                elseif cb >= 192 then
                                    clen = 2
                                end
                                local cj = string.sub(s, j, j + clen - 1)
                                if cj == close then
                                    j = j + clen
                                    break
                                end
                                j = j + clen
                            end
                            i = j
                        else
                            table.insert(out, ch)
                            i = i + len
                        end
                    end
                    return table.concat(out, "\n")
                end
                local function _ywl_build_task_desc(task)
                    if npc.xyl and npc.xyl.build_task_desc then
                        local ok, built = pcall(npc.xyl.build_task_desc, task)
                        if ok and built and built ~= "" then
                            return built
                        end
                    end
                    return (type(task) == "table" and (task.desc or task.wz)) or "暂无任务简介"
                end
                local function _ywl_get_task_title_color(taskName, task, taskDesc)
                    local text = tostring(taskName or "") .. " " .. tostring((type(task) == "table" and (task.desc or task.wz or task.tip)) or "") .. " " .. tostring(taskDesc or "")
                    if text:find("大陆", 1, true) or text:find("等级", 1, true) or text:find("Lv", 1, true) or text:find("解锁", 1, true) or text:find("达到", 1, true) then
                        return "#FF4D3A", "#330000"
                    end
                    if text:find("剧情", 1, true) or text:find("主线", 1, true) or text:find("章节", 1, true) or text:find("灾厄", 1, true) then
                        return "#FF8A1C", "#3A1600"
                    end
                    return "#FFD66B", "#3A1A06"
                end
                local expandedSlot = nil
                local function _set_task_slot_open(slot, slotUi, isOpen)
                    local targetW = slotUi.base_w + (isOpen and slotUi.expand_w or 0)
                    slotUi.current_w = targetW
                    GUI:setContentSize(slot, targetW, slotUi.base_h)
                    GUI:setLocalZOrder(slot, isOpen and (10000 + slotUi.base_z) or slotUi.base_z)
                end
                local function _collapse_task_slot(slot, onDone)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end
                    local cover = slotUi.cover
                    if not cover then
                        slotUi.cover_open = false
                        _set_task_slot_open(slot, slotUi, false)
                        _relayout_task_cards(true)
                        if expandedSlot == slot then
                            expandedSlot = nil
                        end
                        if onDone then
                            onDone()
                        end
                        return
                    end
                    slotUi.cover_anim = true
                    GUI:stopAllActions(cover)
                    GUI:runAction(cover, GUI:ActionSequence(GUI:ActionMoveTo(0.12, slotUi.cover_start_x, slotUi.cover_y), GUI:CallFunc(function()
                        GUI:setVisible(cover, false)
                        slotUi.cover_open = false
                        _set_task_slot_open(slot, slotUi, false)
                        _relayout_task_cards(true)
                        slotUi.cover_anim = false
                        if expandedSlot == slot then
                            expandedSlot = nil
                        end
                        if onDone then
                            onDone()
                        end
                    end)))
                end
                local function _expand_task_slot(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end
                    local cover = slotUi.ensure_cover and slotUi.ensure_cover() or slotUi.cover
                    if not cover then
                        return
                    end
                    slotUi.cover_anim = true
                    _set_task_slot_open(slot, slotUi, true)
                    _relayout_task_cards(true)
                    GUI:stopAllActions(cover)
                    GUI:setPosition(cover, slotUi.cover_start_x, slotUi.cover_y)
                    GUI:setVisible(cover, true)
                    GUI:runAction(cover, GUI:ActionSequence(GUI:ActionMoveTo(0.12, slotUi.cover_end_x, slotUi.cover_y), GUI:CallFunc(function()
                        slotUi.cover_open = true
                        slotUi.cover_anim = false
                        expandedSlot = slot
                    end)))
                end
                local function _expand_task_slot_immediately(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi then
                        return
                    end
                    local cover = slotUi.ensure_cover and slotUi.ensure_cover() or slotUi.cover
                    if not cover then
                        return
                    end
                    _set_task_slot_open(slot, slotUi, true)
                    GUI:stopAllActions(cover)
                    GUI:setPosition(cover, slotUi.cover_end_x, slotUi.cover_y)
                    GUI:setVisible(cover, true)
                    slotUi.cover_open = true
                    slotUi.cover_anim = false
                    expandedSlot = slot
                end
                local function _toggle_task_slot(slot)
                    local slotUi = _slot_state(slot)
                    if not slotUi or slotUi.cover_anim then
                        return
                    end
                    if expandedSlot and expandedSlot ~= slot then
                        local prevUi = _slot_state(expandedSlot)
                        if prevUi and prevUi.cover_anim then
                            return
                        end
                        local prevSlot = expandedSlot
                        _collapse_task_slot(prevSlot, function()
                            _expand_task_slot(slot)
                        end)
                        return
                    end
                    if slotUi.cover_open then
                        _collapse_task_slot(slot)
                    else
                        _expand_task_slot(slot)
                    end
                end
                for idx, task in ipairs(tasks) do
                    local taskName = task[1] or task.title or "任务"
                    local chapterDone = npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1
                    local taskDoneByReward = npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj .. "_" .. idx] == 1
                    local khdDone = (task.id == 999 and task.khdjy) and (task.khdjy(task) == true) or false
                    local storyStarted = _ywl_is_task_started_or_done_by_story(taskName, task)
                    local taskProgressDone = chapterDone or taskDoneByReward or khdDone
                    local needReceive = task.need_receive == true
                    local rwjdSkin = "res/wy/public/rwjd_2.png"
                    if taskProgressDone then
                        rwjdSkin = "res/wy/public/rwjd_3.png"
                    elseif needReceive and not storyStarted then
                        rwjdSkin = "res/wy/public/rwjd_1.png"
                    end
                    local cardSlot = GUI:Layout_Create(layout, "card_slot" .. idx, 0, 0, taskCardWidth, 414, false)
                    GUI:setLocalZOrder(cardSlot, idx)
                    local slotUi = {
                        base_w = taskCardWidth,
                        base_h = 414,
                        base_z = idx,
                        expand_w = taskCardStepX,
                        current_w = taskCardWidth,
                        cover_open = false,
                        cover_anim = false,
                    }
                    taskSlotState[cardSlot] = slotUi
                    GUI:Layout_setClippingEnabled(cardSlot, false)
                    table.insert(taskSlots, cardSlot)
                    local card = GUI:Image_Create(cardSlot, "card" .. idx, 0, 0, 'res/custom/ywl/kuang.png')
                    local imgSkinIndex = (((tonumber(npc.l) or 0) + (tonumber(npc.zj) or 0) + idx - 3) % 3) + 1
                    local imgSkin = string.format('res/custom/ywl/kuang%d.png', imgSkinIndex)
                    local img = GUI:Image_Create(card, "img", 214 / 2, 410 / 2 - 20, imgSkin)
                    if rwjdSkin ~= "res/wy/public/rwjd_2.png" then
                        GUI:Image_Create(img, "rwjd", 25, 350, rwjdSkin)
                    end
                    GUI:setAnchorPoint(img, 0.5, 0.5)
                    local function ensure_cover()
                        if slotUi.cover then
                            return slotUi.cover
                        end
                        local taskTitle = task[1] or task.title or "任务"
                        local taskDesc = _ywl_build_task_desc(task)
                        local taskTitleColor, taskTitleOutline = _ywl_get_task_title_color(taskTitle, task, taskDesc)
                        local rewardData = _ywl_collect_task_rewards(task, npc.l)
                        local size = GUI:getContentSize(img)
                        local imgPos = GUI:getPosition(img)
                        local coverWidth = size.width - 50
                        local coverHeight = size.height - 60
                        slotUi.cover_end_x = imgPos.x + size.width / 2 + coverWidth / 2
                        slotUi.cover_start_x = slotUi.cover_end_x + coverWidth / 2
                        slotUi.cover_y = imgPos.y + 25
                        local coverRightX = slotUi.cover_end_x + coverWidth / 2
                        local overflowRight = math.max(0, coverRightX - slotUi.base_w)
                        slotUi.expand_w = math.min(taskCardStepX, math.floor(overflowRight + 10))
                        local cover = GUI:Image_Create(cardSlot, "cover_" .. idx, slotUi.cover_start_x, slotUi.cover_y, "res/wy/public/500-300.png")
                        GUI:setContentSize(cover, coverWidth, coverHeight)
                        GUI:setAnchorPoint(cover, 0.5, 0.5)
                        GUI:setVisible(cover, false)
                        GUI:setLocalZOrder(cover, 99999)
                        GUI:setTouchEnabled(cover, true)
                        GUI:addOnClickEvent(cover, function()
                            _toggle_task_slot(cardSlot)
                        end)
                        local title = GUI:Text_Create(cover, "title_wz", 10, 310, 20, taskTitleColor, taskTitle)
                        GUI:Text_setFontName(title, "fonts/502.ttf")
                        GUI:Text_enableOutline(title, taskTitleOutline, 2)
                        local jl = GUI:Text_Create(cover, "jl_wz", 10, 280, 20, "#10FF00", "完成奖励")
                        GUI:Text_enableUnderline(jl)
                        GUI:Text_setFontName(jl, "fonts/502.ttf")
                        GUI:Text_enableOutline(jl, "#000000", 2)
                        local okReward, rewardNode = pcall(function()
                            return ItemNumByTable_img_new(rewardData, nil, jl)
                        end)
                        if okReward and rewardNode then
                            GUI:setPosition(rewardNode, 0, -60)
                        end
                        local desc = GUI:Text_Create(cover, "desc_wz", 10, 172, 20, "#FFFFFF", "任务简介")
                        GUI:Text_enableUnderline(desc)
                        GUI:Text_setFontName(desc, "fonts/502.ttf")
                        GUI:Text_enableOutline(desc, "#000000", 2)
                        local okDesc, descNode = pcall(function()
                            return GUI:RichText_Create(desc, "desc", 0, -5, "<font face=\'fonts/font4.ttf\'>" .. taskDesc .. "</font>", 160, 15, "#f7f7de", 3, nil, nil)
                        end)
                        if okDesc and descNode then
                            GUI:setAnchorPoint(descNode, 0, 1)
                        else
                            local descPlain = GUI:Text_Create(desc, "desc_plain", 0, -5, 16, "#f7f7de", taskDesc)
                            GUI:Text_setFontName(descPlain, "fonts/502.ttf")
                            GUI:setAnchorPoint(descPlain, 0, 1)
                        end
                        slotUi.cover = cover
                        return cover
                    end
                    slotUi.ensure_cover = ensure_cover
                    GUI:setTouchEnabled(img, true)
                    GUI:addOnClickEvent(img, function()
                        _toggle_task_slot(cardSlot)
                    end)
                    GUI:setTouchEnabled(card, false)
                    local titleColor, titleOutline = _ywl_get_task_title_color(taskName, task, _ywl_build_task_desc(task))
                    local title = GUI:Text_Create(GUI:Image_Create(img, "name_kuang", 150, 200, "res/custom/ywl/name_kuang.png"), "title", 38, 190, 30, titleColor, _ywl_vertical_text(taskName))
                    GUI:setLocalZOrder(title, 100)
                    GUI:setAnchorPoint(title, 0.5, 1)
                    GUI:Text_setFontName(title, "fonts/502.ttf")
                    GUI:Text_enableOutline(title, titleOutline, 2)
                    local enable = khdDone
                    if taskDoneByReward or chapterDone then
                        GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232 / 2, 90, 'res/custom/ywl/ylq.png'), 0.5, 0.5)
                    else
                        if lockedByJqd then
                            local lockText = GUI:Text_Create(img, "lock", 232 / 2, 90, 22, "#FF3B30", "未解锁")
                            GUI:setAnchorPoint(lockText, 0.5, 0.5)
                        else
                            local btnSkin = enable and 'res/custom/ywl/btn_1.png' or 'res/custom/ywl/btn_2.png'
                            local goBtn = GUI:Button_Create(img, "goBtn", 55, 90, btnSkin)
                            GUI:setScale(goBtn, 0.8)
                            GUI:setAnchorPoint(goBtn, 0, 0.5)
                            GUI:addOnClickEvent(goBtn, function()
                                SL:SendLuaNetMsg(101, 11, enable and 3 or 1, 0, string.format('{"i":%d,"j":%d,"k":0,"z":%d}', npc.l, npc.zj, idx))
                                if enable then
                                    GUI:removeFromParent(goBtn)
                                    GUI:setAnchorPoint(GUI:Image_Create(img, "ylq", 232 / 2, 90, 'res/custom/ywl/ylq.png'), 0.5, 0.5)
                                end
                            end)
                            if AUTO_GUIDE_TASKS[taskName] and not autoGuideWidget then
                                if not chapterDone and not taskDoneByReward and not khdDone and not storyStarted then
                                    if taskName == "本命灵根"
                                        or taskName == "筑基"
                                        or taskName == "提升修为至筑基境" then
                                        if cogin.isWin32 and MainProperty and MainProperty._ui then
                                            autoGuideWidget = MainProperty._ui.Button_role
                                        else
                                            autoGuideWidget = npc.jueshe
                                        end
                                        autoGuideDesc = "打开人物界面"
                                    elseif taskName == "江湖称号升级1次" then
                                        ensureTopPanelExpanded()
                                        local titleShortcut = findShortcutButtonByNpcId(43)
                                        if not titleShortcut then
                                            rebuildShortcutButtons("")
                                            ensureTopPanelExpanded()
                                            titleShortcut = findShortcutButtonByNpcId(43)
                                        end
                                        if titleShortcut then
                                            autoGuideWidget = titleShortcut
                                            autoGuideDesc = "点击江湖称号"
                                        end
                                    elseif taskName == "灵兽孵化" then
                                        startLingshouMainGuide(3)
                                        if npc.lingshou_main_button and not tolua.isnull(npc.lingshou_main_button) then
                                            autoGuideWidget = npc.lingshou_main_button
                                            autoGuideDesc = "点击灵兽孵化"
                                        end
                                    end
                                    if not autoGuideWidget and taskName ~= "灵兽孵化" then
                                        autoGuideWidget = goBtn
                                        autoGuideDesc = "点击前往" .. taskName
                                    end
                                end
                            end
                        end
                    end
                end
                if #taskSlots > 0 then
                    _expand_task_slot_immediately(taskSlots[1])
                end
                _relayout_task_cards(false)
                GUI:Image_Create(node, "wz1", 340, 100, 'res/custom/ywl/wz.png')
                _ywl_render_continent_progress(node)
                -- 保留大陆剧情完成度进度条，同时恢复原章节奖励展示与领取。
                local chapterReward = _ywl_filter_reward_entries(zjCfg.jl, npc.l)
                if chapterReward and #chapterReward > 0 and not _ywl_is_auto_chapter_continent(npc.l) then
                    local chapterRewardTitle = GUI:Text_Create(node, "chapter_reward_title", 530, 62, 22, "#F4D179", "章节\n奖励")
                    GUI:setAnchorPoint(chapterRewardTitle, 0.5, 0.5)
                    GUI:Text_setFontName(chapterRewardTitle, "fonts/502.ttf")
                    GUI:Text_enableOutline(chapterRewardTitle, "#1B0B02", 3)
                    local rewardNode = ItemNumByTable_img(chapterReward, nil, node)
                    GUI:setPosition(rewardNode, 560, 40)
                    _add_reward_effect_for_table(rewardNode, "ywl_chapter_reward_eff", 25, 25, 0.9, REWARD_ITEM_EFFECT_14193)
                end
                if npc.data and npc.data.ywl and npc.data.ywl["jl_" .. npc.l .. "_" .. npc.zj] == 1 then
                    GUI:Image_Create(node, "done", 750, 40, 'res/wy/public/rwjd_3.png')
                elseif not _ywl_is_auto_chapter_continent(npc.l) then
                    npc.jl = GUI:Button_Create(node, "btn_reward", 710, 0, 'res/custom/ywl/btn_3.png')
                    GUI:addOnClickEvent(npc.jl, function()
                        SL:SendLuaNetMsg(101, 11, 2, 0, string.format('{"i":%d,"j":%d,"k":0}', npc.l, npc.zj))
                    end)
                    if not autoGuideWidget and _ywl_is_chapter_reward_ready(npc.l, npc.zj) then
                        autoGuideWidget = npc.jl
                        autoGuideDesc = "点击领取章节奖励"
                    end
                end
                local chapterKey = tostring(npc.l) .. "_" .. tostring(npc.zj)
                if npc._ywl_auto_guided_chapter ~= chapterKey then
                    npc._ywl_auto_guided_chapter = chapterKey
                    if autoGuideWidget
                        and not (NPC_UI_HELPER.shouldSuppressGrayWorldGuide and NPC_UI_HELPER.shouldSuppressGrayWorldGuide()) then
                        local guideParent = GUI:getParent(autoGuideWidget) or node
                        NPC_UI_HELPER.startGuide({
                            dir = 3,
                            guideWidget = autoGuideWidget,
                            guideParent = guideParent,
                            guideDesc = autoGuideDesc or "建议优先领取",
                            isForce = false,
                            hideMask = true,
                        })
                    end
                end
                -- _ywl_try_start_chapter_reward_guide(node, false)
            end
            if (tonumber(npc.l) or 0) < 3 then
                local TMONEY = GUI:Text_Create(node, "TMONEY", 50 + 278, 40 + 9, 25, "#FF0000", SL:GetMetaValue("TMONEY", "剧情点"))
                SL:release_print("当前剧情点", SL:GetMetaValue("TMONEY", "剧情点"))
                GUI:Text_setFontName(TMONEY, "fonts/502.ttf")
                GUI:setAnchorPoint(TMONEY, 0.5, 0.5)
            end
        end
        local function renderChapterList()
            GUI:removeAllChildren(chapterList)
            for i = 2, #npc.xyl do
                if type(npc.xyl[i]) == "table" and #npc.xyl[i] > 0 then
                    local btn = GUI:Button_Create(chapterList, "chap_" .. i, 0, 0, 'res/custom/ywl/list/dl_' .. i .. '.png')
                    GUI:addOnClickEvent(btn, function()
                        if i == 3 then
                            if not _ywl_has_third_continent_half_entry() then
                                NPC_UI_HELPER.guochang_3()
                                return
                            end
                        elseif not isYwlContinentUnlocked(i) then
                            SL:ShowSystemTips("<font color='#FF0000'>还未解锁该大章节</font>")
                            return
                        end
                        npc.l = i
                        npc.zj = 1
                        renderChapterList()
                        renderTasks(npc.node_11)
                    end)
                    if i == npc.l then
                        for y = 1, #npc.xyl[npc.l] do
                            local x_chap = GUI:Layout_Create(chapterList, "x_chap_" .. y, 0, 0, 84, 40, false)
                            local x_btn = GUI:Button_Create(x_chap, "x_chap", 84 / 2, 40 / 2, 'res/custom/ywl/list/xz.png')
                            GUI:setAnchorPoint(x_btn, 0.5, 0.5)
                            local zj_name = GUI:Text_Create(x_chap, "wz", 84 / 2, 40 / 2, 23, "#FFFFFF", npc.xyl[npc.l][y].name)
                            GUI:Text_setFontName(zj_name, "fonts/502.ttf")
                            GUI:Text_enableOutline(zj_name, "#000000", 2)
                            GUI:setAnchorPoint(zj_name, 0.5, 0.5)
                            GUI:addOnClickEvent(x_btn, function()
                                if npc.l == 3 and not _ywl_is_third_continent_half_chapter(npc.xyl[npc.l][y].name) then
                                    if not _ywl_has_third_continent_full_entry() then
                                        SL:ShowSystemTips("<font color='#FF0000'>需要完成灾厄入侵后才能进入该章节</font>")
                                        return
                                    end
                                end
                                local curJqd = tonumber(SL:GetMetaValue("TMONEY", "剧情点")) or 0
                                local lockInfo = npc.xyl and npc.xyl.get_chapter_lock_info and npc.xyl.get_chapter_lock_info(npc.l, y, curJqd) or nil
                                if lockInfo and lockInfo.locked then
                                    SL:ShowSystemTips(string.format("<font color='#FF0000'>%s</font>", tostring(lockInfo.tip or "章节未解锁")))
                                    return
                                end
                                GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FFFFFF")
                                npc.zj = y
                                GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                                renderTasks(npc.node_11)
                            end)
                            if y == npc.zj then
                                GUI:Text_setTextColor(GUI:ui_delegate(GUI:ui_delegate(chapterList)["x_chap_" .. npc.zj]).wz, "#FF0000")
                            end
                        end
                    end
                end
            end
        end
        renderChapterList()
        renderTasks(npc.node_11)
        SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面", function(self)
            if self == "npc_ywl" then
                SL:UnRegisterLUAEvent(LUA_EVENT_CLOSEWIN, "关闭界面")
            end
        end)
    elseif p2 == 2 then
        local data = SL:JsonDecode(Data, false) or {
        }
        if p3 == 1 then
        elseif p3 == 2 then
            npc.data = npc.data or {
            }
            npc.data.ywl = npc.data.ywl or {
            }
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j] = 1
            rawset(_G, "XYL_YWL_CACHE", npc.data.ywl)
            local nextL, nextZj = _ywl_find_next_chapter(data.i, data.j)
            if nextL and nextZj then
                npc.l, npc.zj = nextL, nextZj
            else
                npc.l = tonumber(data.i) or npc.l
                npc.zj = tonumber(data.j) or npc.zj
            end
            npc[11](0, 0, SL:JsonEncode(npc.data, false))
            return
        elseif p3 == 3 then
            npc.data = npc.data or {
            }
            npc.data.ywl = npc.data.ywl or {
            }
            npc.data.ywl["jl_" .. data.i .. "_" .. data.j .. "_" .. data.z] = 1
            rawset(_G, "XYL_YWL_CACHE", npc.data.ywl)
            npc.l = tonumber(data.i) or npc.l
            npc.zj = tonumber(data.j) or npc.zj
        end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        if type(npc.data) == "table" and type(npc.data.ywl) == "table" and next(npc.data.ywl) ~= nil then
            rawset(_G, "XYL_YWL_CACHE", npc.data.ywl)
        end
        npc[11](0, 0, Data)
    elseif p2 == 9 then
        local currentTask = SL:JsonDecode(Data, false) or {
        }
        npc.current_ywl_task = currentTask
        rawset(_G, "XYL_CURRENT_TASK_NAME", _ywl_get_task_name_from_current_task(currentTask))
        if _ywl_should_hide_storylog() then
            _ywl_close_storylog()
        end
        SL:onLUAEvent(LUA_EVENT_YWL_CURRENT_TASK_CHANGE, currentTask)
        rebuildShortcutButtons("")
    end
end
npc[12] = function(p2, p3, Data)
    local function openActivityEntry(kf, idx)
        idx = tonumber(idx) or 0
        closeActivityWindow()
        if idx == 7 then
            SL:SendLuaNetMsg(101, 506, 0, 0, "")
            return
        end
        -- npc[507] uses p2=1 as "enter activity"; the real activity id is p3.
        -- The server payload's kf field is activity metadata, not npc[507]'s p2.
        SL:SendLuaNetMsg(101, 507, 1, idx, "")
    end
    local function closeActivityShortcut()
        local autoRunCheck = npc.hdan and GUI:getChildByName(npc.hdan, "CheckBox")
        if autoRunCheck and GUI:CheckBox_isSelected(autoRunCheck) then
            SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
            SL:SetMetaValue("BATTLE_MOVE_END")
        end
        if npc.hdan then
            GUI:removeFromParent(npc.hdan)
            npc.hdan = nil
        end
        local parent = GUI:GetWindow(nil, "npc_hdtb_bj")
        if parent then
            GUI:Win_Close(parent)
        end
    end
    local function getActivityShortcutName(idx)
        local names = {
            [1] = "保卫村庄",
            [2] = "全民夺矿",
            [3] = "全民答题",
            [5] = "土城跑酷",
            [6] = "美食狂欢",
            [7] = "天选之人",
            [8] = "正邪大战",
            [9] = "武林盟主",
            [10] = "武道大会",
            [13] = "随机夺宝",
            [14] = "黑暗禁地",
        }
        return names[tonumber(idx) or 0] or "活动"
    end
    local function createShortcutTextButton(parent, name, x, y, w, h, text, color, cb)
        local btn = GUI:Layout_Create(parent, name, x, y, w, h, false)
        GUI:setTouchEnabled(btn, true)
        local label = GUI:Text_Create(btn, name .. "_text", w / 2, h / 2, 16, color or "#F7F7DE", text)
        GUI:setAnchorPoint(label, 0.5, 0.5)
        GUI:Text_enableOutline(label, "#000000", 1)
        GUI:addOnClickEvent(btn, cb)
        return btn
    end
    local function createShortcutImageButton(parent, name, x, y, text, cb)
        local btn = GUI:Button_Create(parent, name, x, y, "res/wy/public/an15.png")
        GUI:Button_setTitleText(btn, text)
        GUI:Button_setTitleFontSize(btn, 16)
        GUI:Button_titleEnableOutline(btn, "#100808", 2)
        GUI:addOnClickEvent(btn, cb)
        return btn
    end
    local function setActivityShortcutHidden(hidden, activityIdx)
        if not npc.hdan then
            return
        end
        local function safeSetVisible(node, visible)
            if node then
                GUI:setVisible(node, visible)
            end
        end
        local img = GUI:getChildByName(npc.hdan, "shortcut_img")
        local enterBtn = GUI:getChildByName(npc.hdan, "shortcut_enter")
        local hideBtn = GUI:getChildByName(npc.hdan, "shortcut_hide")
        local closeBtn = GUI:getChildByName(npc.hdan, "shortcut_close")
        local djs = GUI:getChildByName(npc.hdan, "djs")
        local nameBtn = GUI:getChildByName(npc.hdan, "shortcut_name")
        local autoText = GUI:getChildByName(npc.hdan, "Text")
        local autoCheck = GUI:getChildByName(npc.hdan, "CheckBox")
        safeSetVisible(img, not hidden)
        safeSetVisible(enterBtn, not hidden)
        safeSetVisible(hideBtn, not hidden)
        safeSetVisible(closeBtn, not hidden)
        safeSetVisible(djs, not hidden)
        safeSetVisible(autoText, not hidden)
        safeSetVisible(autoCheck, not hidden)
        safeSetVisible(nameBtn, hidden)
    end
    local function addActivityShortcutControls(parent, activityIdx)
        createShortcutTextButton(parent, "shortcut_hide", 210 - 90, 88 - 8, 52, 28, "【隐藏】", "#F7F7DE", function()
            setActivityShortcutHidden(true, activityIdx)
        end)
        createShortcutTextButton(parent, "shortcut_close", 264 - 90, 88 - 8, 52, 28, "【关闭】", "#F7B0A0", function()
            closeActivityShortcut()
        end)
        createShortcutImageButton(parent, "shortcut_enter", 150 - 70, 42 - 20, "进入", function()
            openActivityEntry(npc.hd_data and npc.hd_data.kf, activityIdx)
        end)
        createShortcutTextButton(parent, "shortcut_name",  210 - 90, 88 - 8, 110, 30, "【" .. getActivityShortcutName(activityIdx) .. "】", "#F7F7DE", function()
            setActivityShortcutHidden(false, activityIdx)
        end)
        GUI:setVisible(GUI:getChildByName(parent, "shortcut_name"), false)
    end

    if p2 == 1 then
        npc.hd_data = SL:JsonDecode(Data, false) or {}
        local activityIdx = tonumber((npc.hd_data and npc.hd_data.idx) or p3) or 0
        local activitySeconds = (tonumber(npc.hd_data.sk) or 0) * 60
        if npc.hdan then
            closeActivityShortcut()
        end
        if cogin.isWin32 then
            npc.hdan = GUI:Layout_Create(npc.RightTop, "hdan", -367, -300, 320, 116, false)
            GUI:Image_Create(npc.hdan, "shortcut_img", 0, 0, "res/custom/activity/" .. activityIdx .. ".png")
            addActivityShortcutControls(npc.hdan, activityIdx)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 9999, 9999, 16, "#F7F7DE", "")
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:setVisible(npc.djs, true)
            GUI:Text_COUNTDOWN(npc.djs, activitySeconds, function()
                if npc.hdan then
                    closeActivityShortcut()
                end
            end)
        else
            npc.hdan = GUI:Layout_Create(npc.RightTop, "hdan", -390 - 125 + 226 - 55 - 160, -240 - 61 - 31 + 50, 320, 116, false)
            GUI:Image_Create(npc.hdan, "shortcut_img", 0, 0, "res/custom/activity/" .. activityIdx .. ".png")
            addActivityShortcutControls(npc.hdan, activityIdx)
            npc.djs = GUI:Text_Create(npc.hdan, "djs", 9999, 9999, 16, "#F7F7DE", "")
            GUI:setAnchorPoint(npc.djs, 0.5, 0.5)
            GUI:setVisible(npc.djs, true)
            GUI:Text_COUNTDOWN(npc.djs, activitySeconds, function()
                if npc.hdan then
                    closeActivityShortcut()
                end
            end)
        end
        if activityIdx == 5 then
            local txt = GUI:Text_Create(npc.hdan, "Text", 10 + 60, -22, 14, "#ffffff", "勾选自动跑酷")
            GUI:Text_enableOutline(txt, "#000000", 1)
            local CheckBox = GUI:CheckBox_Create(npc.hdan, "CheckBox", -20 + 60, -22, "res/public/1900000550.png", "res/public/1900000551.png")
            GUI:CheckBox_addOnEvent(CheckBox, function(self)
                if GUI:CheckBox_isSelected(self) then
                    if SL:GetMetaValue("MAP_ID") == "xtc" then
                        SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                        SL:RegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束", function()
                            if not npc.hdan then
                                SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                            end
                            SL:SetMetaValue("BATTLE_MOVE_BEGIN", "xtc", math.random(128, 146), math.random(129, 147))
                        end, txt)
                    else
                        GUI:CheckBox_setSelected(self, false)
                        SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#ff0500'>只能在土城才能使用</font></outline>")
                    end
                else
                    SL:UnRegisterLUAEvent(LUA_EVENT_AUTOMOVEEND, "跑酷寻路结束")
                    SL:SetMetaValue("BATTLE_MOVE_END")
                end
            end)
        end
    elseif p2 == 4 then
        if npc.hdan then
            closeActivityShortcut()
        end
    end
end
npc[13] = function(p2, p3, msgData)
    if p2 == 0 then
        SL:SendLuaNetMsg(101, 13, 0, 0, "")
        return
    end
    local function renderRecordStone(records)
        local win = ensureWindow("recordStone", 13, {
            titleText = "记录石",
        })
        local node = win.node
        GUI:removeAllChildren(node)
        npc.recordStoneLabels = {
        }
        local scroll = GUI:ScrollView_Create(node, "scroll", 56, 37, 458, 347, 1)
        GUI:ScrollView_setInnerContainerSize(scroll, 458, 495)
        local content = GUI:Image_Create(scroll, "content", 0, 0.5, "res/wy/public/jys_wz.png")
        for i = 1, 10 do
            local slot = records and records["dtm" .. i]
            local text = slot and (slot[2] .. "(" .. slot[3] .. "," .. slot[4] .. ")") or "暂未记录"
            npc.recordStoneLabels[i] = GUI:Text_Create(content, "pos_" .. i, 164, 524 - i * 50, 16, "#ffffff", text)
            GUI:setAnchorPoint(npc.recordStoneLabels[i], 0.5, 0.5)
            GUI:Text_enableOutline(npc.recordStoneLabels[i], "#000000", 1)
            local idxLabel = GUI:Text_Create(content, "idx_" .. i, 40, 524 - i * 50, 16, "#ffffff", i)
            GUI:setAnchorPoint(idxLabel, 0.5, 0.5)
            GUI:Text_enableOutline(idxLabel, "#000000", 1)
            local saveBtn = GUI:Button_Create(content, "btn_save_" .. i, 271, 504 - i * 50, "res/wy/public/jys_jl.png")
            GUI:addOnClickEvent(saveBtn, function()
                SL:OpenCommonTipsPop({
                    str = "是否记录该地图点位？将覆盖原有记录。",
                    btnType = 2,
                    callback = function(atype)
                        if atype == 1 then
                            SL:SendLuaNetMsg(101, 13, 1, i, "")
                        end
                    end,
                })
            end)
            local gotoBtn = GUI:Button_Create(content, "btn_goto_" .. i, 369, 504 - i * 50, "res/wy/public/jys_cs.png")
            GUI:addOnClickEvent(gotoBtn, function()
                if records and records["dtm" .. i] then
                    SL:SendLuaNetMsg(101, 13, 2, i, "")
                else
                    SL:ShowSystemTips("<font color='#ff0000'>未记录该位置，无法传送！</font>")
                end
            end)
        end
    end
    if p2 == 1 then
        npc.jls = SL:JsonDecode(msgData, false)
        renderRecordStone(npc.jls)
    elseif p2 == 2 then
        if p3 and p3 > 0 and p3 <= 10 then
            npc.jls = SL:JsonDecode(msgData, false)
            if npc.recordStoneLabels and npc.jls["dtm" .. p3] then
                GUI:Text_setString(npc.recordStoneLabels[p3], npc.jls["dtm" .. p3][2] .. "(" .. npc.jls["dtm" .. p3][3] .. "," .. npc.jls["dtm" .. p3][4] .. ")")
            end
        end
    elseif p2 == 3 then
        GUI:Win_CloseByID("npc_jilushi")
    end
end
npc[17] = function(p2, p3, Data)
end
npc[18] = function(p2, p3, Data)
    local function renderNewbieGift(node)
        GUI:removeAllChildren(node)
        local Layout1 = GUI:Layout_Create(node, "Layout1", 429, 186, 100, 60.0, false)
        for i = 1, 4 do
            GUI:setContentSize(GUI:Image_Create(Layout1, "skill" .. i, 0.0, 0.0, "res/custom/xinshoulibao/skill_" .. i .. ".png"), 42, 42)
        end
        GUI:UserUILayout(Layout1, {
            dir = 2,
            addDir = 1,
            gap = {
                x = 23,
            },
        })
        local jl_itme = {
            {
                "复活戒指",
                1,
            },
            {
                "麻痹戒指",
                1,
            },
            {
                "斗笠",
                1,
            },
            {
                "攻速之镰[lv1]",
                1,
            },
            {
                "切割之斧[lv1]",
                1,
            },
        }
        Layout1 = GUI:Layout_Create(node, "Layout2", 400, 100, 100, 60.0, false)
        for i = 1, 5 do
            GUI:ItemShow_Create(Layout1, "itme" .. i, 0, 0, {
                index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", jl_itme[i][1]),
                look = true,
            })
        end
        GUI:UserUILayout(Layout1, {
            dir = 2,
            addDir = 1,
            gap = {
                x = 23 + 10,
            },
        })
        local btn = GUI:Button_Create(node, "btn_get_gift", 420, 0, "res/custom/xinshoulibao/btn.png")
        GUI:addOnClickEvent(btn, function()
            SL:SendLuaNetMsg(101, 18, 1, 0, "")
        end)
        NPC_UI_HELPER.startGuide({
            dir = 5,
            guideWidget = btn,
            guideParent = node,
            guideDesc = "点击领取",
            isForce = true,
            hideMask = false,
        })
    end
    if p2 == 0 then
        npc.data_18 = Data and SL:JsonDecode(Data, false) or {
        }
        local win = ensureWindow("newbieGift", 18, {
            titleText = "新手礼包",
        })
        renderNewbieGift(win.node)
    end
end
npc[23] = function(p2, p3, Data)
    local cardPosX = {
        100,
        360,
        620,
    }
    local UI_updata
    local function setCommonText(textObj, outlineColor)
        GUI:Text_setFontName(textObj, "fonts/502.ttf")
        GUI:Text_enableOutline(textObj, outlineColor or "#081800", 1)
        GUI:setAnchorPoint(textObj, 0.5, 0.5)
    end
    local function bindPressFeedback(target, onClick)
        if not target then
            return
        end
        GUI:setTouchEnabled(target, true)
        GUI:addOnTouchEvent(target, function(sender, touchType)
            if touchType == SLDefine.TouchEventType.began then
                GUI:setScale(sender, 0.96)
            elseif touchType == SLDefine.TouchEventType.ended then
                GUI:setScale(sender, 1)
                if onClick then
                    onClick()
                end
            elseif touchType == SLDefine.TouchEventType.canceled then
                GUI:setScale(sender, 1)
            end
        end)
    end
    local eff = {
        11501,
        11506,
        11505,
    }
    local function renderCard(node, state)
        local idx = state.idx
        local card = GUI:Image_Create(node, "huti_card_" .. idx, cardPosX[idx], 34 + 30, "res/custom/htgh/item_" .. idx .. ".png")
        GUI:setAnchorPoint(card, 0, 0)
        GUI:setScale(GUI:Effect_Create(card, "effect", 115, 320 - 46, 0, eff[idx], 0, 0, 0, 1), 1)
        GUI:Effect_Create(card, "rw1", 115, 320 - 46, 4, SL:GetMetaValue("EQUIP_DATA", 0) and SL:GetMetaValue("EQUIP_DATA", 0).Shape or 1300, 0, 0, 2, 0.8)
        if not state.canActivate then
            local btn = GUI:Button_Create(card, "activate_btn_" .. idx, 78 + 60, 110 - 30 - 8, "res/custom/htgh/btn_activate.png")
            GUI:setAnchorPoint(btn, 0.5, 0.5)
            bindPressFeedback(btn, function()
                if not state.canActivate then
                    SL:ShowSystemTips(state.lockedTip or "当前条件未满足")
                    return
                end
                SL:SendLuaNetMsg(101, 23, 1, idx, "")
            end)
        end
    end
    UI_updata = function(node)
        GUI:removeAllChildren(node)
        local states = _huti_get_card_states()
        GUI:Image_Create(node, "wz1", 150 + 117, 34 + 451, "res/custom/htgh/wz1.png")
        GUI:Image_Create(node, "wz2", 100, 34, "res/custom/htgh/wz2.png")
        for idx = 1, 3 do
            renderCard(node, states[idx])
        end
    end
    if p2 == 0 then
        npc.data_23 = not Data and {
        } or SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        local win = ensureWindow("bodyAura", 23, {
            titleText = "护体光环",
        })
        npc.bg = win.bg
        npc.node = win.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_23 = not Data and {
        } or SL:JsonDecode(Data, false)
        if npc.node and not tolua.isnull(npc.node) then
            UI_updata(npc.node)
        end
        rebuildShortcutButtons("")
    end
end
npc[20] = function(p2, p3, Data)
    local function UI_updata(node, idx)
        GUI:removeAllChildren(node)
        local dbLayout = GUI:Layout_Create(node, "dbLayout", 23, 13, 300, 150)
        for i = 1, 8 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow" .. i, 0, 0, 102 + i, false, {
                    look = true,
                    movable = true,
                    bgVisible = false,
                    doubleTakeOff = true,
                })
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow" .. i, 0, 0, {
                    itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 102 + i),
                    look = true,
                })
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {
                dir = 3,
                addDir = 1,
                colnum = 4,
                gap = {
                    x = 11,
                    y = 5,
                },
            })
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 40, 0)
            GUI:UserUILayout(dbLayout, {
                dir = 3,
                addDir = 1,
                colnum = 4,
                gap = {
                    x = 42,
                    y = 42,
                },
            })
        end
    end
    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>神石数据异常，请稍后再试...</font>")
            return
        end
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end
        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_shenshi.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -300, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)
    end
end
npc[21] = function(p2, p3, Data)
    local function UI_updata(node, idx)
        GUI:removeAllChildren(node)
        local dbLayout = GUI:Layout_Create(node, "dbLayout", 33, 13, 300, 150)
        for i = 1, 6 do
            if idx == 0 then
                local EquipShow = GUI:EquipShow_Create(dbLayout, "EquipShow" .. i, 0, 0, 110 + i, false, {
                    look = true,
                    movable = true,
                    bgVisible = false,
                    doubleTakeOff = true,
                })
                GUI:EquipShow_setAutoUpdate(EquipShow)
            elseif idx == 1 then
                GUI:ItemShow_Create(dbLayout, "EquipShow" .. i, 0, 0, {
                    itemData = SL:GetMetaValue("L.M.EQUIP_DATA", 110 + i),
                    look = true,
                })
            end
        end
        if idx == 0 then
            GUI:UserUILayout(dbLayout, {
                dir = 3,
                addDir = 1,
                colnum = 3,
                gap = {
                    x = 19,
                    y = 5,
                },
            })
        elseif idx == 1 then
            GUI:setPosition(dbLayout, 50, 0)
            GUI:UserUILayout(dbLayout, {
                dir = 3,
                addDir = 1,
                colnum = 3,
                gap = {
                    x = 50,
                    y = 42,
                },
            })
        end
    end
    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerSuperEquip.gzd
        elseif p3 == 1 then
            logg = PlayerSuperEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>古玩数据异常，请稍后再试...</font>")
            return
        end
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end
        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_guwan.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -270, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)
    end
end
npc[22] = function(p2, p3, Data)
    local function UI_updata(node, idx)
        GUI:removeAllChildren(node)
        local metaKey = idx == 1 and "L.M.EQUIP_DATA" or "EQUIP_DATA"
        local items = {
            {
                id = 71,
                x = 138,
                y = 131,
                name = "时光之杖[未激活]",
            },
            {
                id = 72,
                x = 246,
                y = 94,
                name = "雷霆双子剑[未激活]",
            },
            {
                id = 73,
                x = 65,
                y = 60,
                name = "秘宝·万鬼啸【鬼】[未激活]",
            },
            {
                id = 74,
                x = 65,
                y = 131,
                name = "秘宝·破龙吟【兵】[未激活]",
            },
            {
                id = 75,
                x = 138,
                y = 60,
                name = "酒仙剑[未激活]",
            },
        }
        for _, cfg in ipairs(items) do
            local item = SL:GetMetaValue(metaKey, cfg.id)
            if item then
                local EquipShow = GUI:EquipShow_Create(node, "EquipShow" .. cfg.id, cfg.x, cfg.y, cfg.id, false, {
                    look = true,
                    movable = true,
                    bgVisible = false,
                    doubleTakeOff = true,
                })
                GUI:EquipShow_setAutoUpdate(EquipShow)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            else
                local EquipShow = GUI:ItemShow_Create(node, "EquipShow" .. cfg.id, cfg.x, cfg.y, {
                    index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", cfg.name),
                    look = true,
                })
                GUI:ItemShow_setIconGrey(EquipShow, true)
                GUI:setAnchorPoint(EquipShow, 0.5, 0.5)
            end
        end
    end
    if p2 == 0 then
        local logg
        if p3 == 0 then
            logg = PlayerEquip.gzd
        elseif p3 == 1 then
            logg = PlayerEquip_Look.gzd
        end
        if not logg then
            SL:ShowSystemTips("<font color='#FF0000'>法宝数据异常，请稍后再试...</font>")
            return
        end
        if GUI:getChildByName(logg, "img_bj") then
            GUI:removeChildByName(logg, "img_bj")
            return
        end
        npc.bg = GUI:Image_Create(logg, "img_bj", 0, 0, 'res/wy/public/bg_fabao.png')
        GUI:setTouchEnabled(npc.bg, true)
        GUI:setOpacity(npc.bg, 0)
        GUI:runAction(npc.bg, GUI:ActionSpawn(GUI:ActionMoveTo(0.3, -340, 0), GUI:ActionFadeIn(0.3)))
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        UI_updata(npc.node, p3)
    end
end
npc[30] = function(p2, p3, Data)
    local function btn_updata_1_xjm()
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {
                skin = "res/custom/three_city/xianfu/kanshu/updata_1/bg.png",
            },
            closeButton = {
                x = 650,
                y = 320,
            },
        })
        npc.xjm_node = npc.xjm_window.node
        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 210, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_" .. npc.data_30.T_data.axe .. ".png"), 0.5, 0.5)
        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_1", 210, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_" .. npc.data_30.T_data.axe .. ".png"), 0.5, 0.5)
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[1].details[npc.data_30.T_data.axe].cost[1][2]), "fonts/501.ttf")
        if npc.data_30.T_data.axe >= config.updata[1].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_2", 488, 235, "res/custom/three_city/xianfu/kanshu/updata_1/level_" .. (npc.data_30.T_data.axe + 1) .. ".png"), 0.5, 0.5)
            GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "wz_2", 488, 150, "res/custom/three_city/xianfu/kanshu/updata_1/wz_" .. (npc.data_30.T_data.axe + 1) .. ".png"), 0.5, 0.5)
            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_1/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(101, 30, 1, 1, '')
            end)
        end
    end
    local function btn_updata_2_xjm()
        local config = teshudata["anniu_30"]
        npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
            windowName = "npc_anniu_30_xjm",
            background = {
                skin = "res/custom/three_city/xianfu/kanshu/updata_2/bg.png",
            },
            closeButton = {
                x = 650,
                y = 320,
            },
        })
        npc.xjm_node = npc.xjm_window.node
        GUI:setAnchorPoint(GUI:Image_Create(npc.xjm_node, "level_1", 420, 350, "res/custom/three_city/xianfu/kanshu/updata_2/level_" .. npc.data_30.T_data.auto .. ".png"), 0.5, 0.5)
        GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 370, 105, 30, "#FFFFFF", config.updata[2].details[npc.data_30.T_data.auto].cost[1][2]), "fonts/501.ttf")
        if npc.data_30.T_data.auto >= config.updata[2].max_level then
            GUI:setAnchorPoint(GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/wy/public/15.png"), 0.5, 0)
        else
            local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/updata_2/btn.png")
            GUI:setAnchorPoint(btn, 0.5, 0)
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(101, 30, 1, 2, '')
            end)
        end
    end
    local function format_doll_number(value)
        local num = tonumber(value) or 0
        local formatted = tostring(math.floor(num + 0.5))
        local result = formatted
        local k = 0
        while true do
            result, k = result:gsub('^(-?%d+)(%d%d%d)', '%1,%2')
            if k == 0 then
                break
            end
        end
        return result
    end

    local function format_doll_cost(cost)
        if type(cost) ~= 'table' then
            return '—'
        end
        local parts = {}
        for _, value in pairs(cost) do
            if type(value) == 'table' and value[1] then
                parts[#parts + 1] = string.format('%s x%s', value[1], format_doll_number(value[2] or 0))
            end
        end
        table.sort(parts)
        return (#parts > 0) and table.concat(parts, ' / ') or '—'
    end

    local function format_doll_attr_value(value, percent)
        local num = tonumber(value) or 0
        if tonumber(percent or 0) == 1 then
            return string.format('%s%%', tostring(math.floor(num / 100)))
        end
        return format_doll_number(num)
    end

    local function get_doll_cost_count(cost, itemName)
        if type(cost) ~= 'table' then
            return 0
        end
        local total = 0
        local targetName = tostring(itemName or '')
        for _, entry in ipairs(cost) do
            if type(entry) == 'table' and tostring(entry[1] or '') == targetName then
                total = total + (tonumber(entry[2] or 0) or 0)
            end
        end
        return total
    end

    local function get_doll_attr_label(entryCfg, count)
        local attrDesc = tostring((entryCfg or {}).attr_desc or '')
        if attrDesc == '' then
            return '属性加成'
        end
        local ownedCount = math.max(1, tonumber(count) or 1)
        if ownedCount <= 1 then
            return attrDesc
        end
        return string.gsub(attrDesc, '%+([%d%.]+)(%%?)', function(value, suffix)
            local num = tonumber(value) or 0
            local total = num * ownedCount
            if total == math.floor(total) then
                total = math.floor(total)
            end
            return '+' .. tostring(total) .. tostring(suffix or '')
        end)
    end

    local function build_doll_preview_batch_cost(doll, cfg, count)
        local drawTotal = tonumber((doll or {}).draw_total or 0) or 0
        local firstCount = tonumber((cfg or {}).first_draw_count or 0) or 0
        local drawCount = math.max(1, tonumber(count) or 1)
        local useFirstTenCost = drawTotal <= 0 and drawCount == firstCount and firstCount > 0
        local total = 0
        for _ = 1, drawCount do
            if useFirstTenCost then
                total = total + get_doll_cost_count((cfg or {}).first_draw_cost or {}, '仙府币')
            else
                total = total + get_doll_cost_count((cfg or {}).normal_draw_cost or {}, '仙府币')
            end
            drawTotal = drawTotal + 1
        end
        return total
    end

    local function get_doll_cfg()
        return ((teshudata['npc_44'] or {}).DollCfg or {})
    end

    local function get_doll_result_cfg(resultId)
        return ((get_doll_cfg().results or {})[resultId])
    end

    local function get_doll_asset(resultId)
        local cfg = get_doll_result_cfg(resultId)
        if not cfg then
            return nil
        end
        local qualityMap = {
            normal = '普通',
            red = '红',
            hidden = '隐藏',
        }
        local group = tostring(cfg.asset_group or 1)
        local quality = qualityMap[cfg.quality or 'normal'] or '普通'
        return string.format('res/custom/three_city/xianfu/仙府部分/收藏柜/娃娃/娃娃%s/%s.png', group, quality)
    end

    local function request_open_doll_machine()
        npc.woodcut_doll.tab = 'doll_machine'
        SL:SendLuaNetMsg(101, 30, 4, 0, '')
    end

    local function request_draw_doll_machine(count)
        local payload = {
            count = tonumber(count) == 10 and 10 or 1,
        }
        SL:SendLuaNetMsg(101, 30, 5, 0, SL:JsonEncode(payload, false))
    end

    local open_doll_machine

    -- Cocos UI 节点有效性判定，避免旧窗口关闭后动画/回调继续操作失效节点。
    local function is_valid_cobj(target)
        if not target then
            return false
        end
        if tolua and tolua.isnull then
            return not tolua.isnull(target)
        end
        return true
    end

    local function get_doll_tab_skin(tabId)
        local folderMap = {
            doll_machine = '娃娃机',
            doll_cabinet = '收藏柜',
        }
        local folder = folderMap[tabId] or '娃娃机'
        local state = npc.woodcut_doll.tab == tabId and '亮' or '暗'
        return string.format('res/custom/three_city/xianfu/仙府部分/左侧按钮/%s/%s.png', folder, state)
    end

    local function build_doll_owned_list(doll)
        local owned = (doll or {}).owned or {}
        local result = {}
        local order = get_doll_cfg().cabinet_order or {}
        local marked = {}
        for _, resultId in ipairs(order) do
            local count = tonumber(owned[resultId]) or 0
            if count > 0 then
                result[#result + 1] = {
                    id = resultId,
                    count = count,
                    cfg = get_doll_result_cfg(resultId),
                }
                marked[resultId] = true
            end
        end
        for resultId, count in pairs(owned) do
            count = tonumber(count) or 0
            if count > 0 and not marked[resultId] then
                result[#result + 1] = {
                    id = resultId,
                    count = count,
                    cfg = get_doll_result_cfg(resultId),
                }
            end
        end
        return result
    end

    local function format_doll_rate_text(rate, base)
        local percent = ((tonumber(rate) or 0) * 100) / math.max(1, tonumber(base) or 1)
        if math.floor(percent) == percent then
            return string.format('%.0f%%', percent)
        end
        if percent >= 1 then
            return string.format('%.2f%%', percent)
        end
        return string.format('%.4f%%', percent)
    end

    local function build_doll_tip_html()
        local cfg = get_doll_cfg()
        local lines = {}
        local normalRate = math.max(0, (tonumber(cfg.red_rate_base) or 10000) - (tonumber(cfg.red_rate) or 0) - (tonumber((cfg.hidden or {}).rate) or 0))
        local normalPool = cfg.normal_pool or {}
        local redPool = cfg.red_pool or {}
        local hiddenPool = (cfg.hidden or {}).pool or {}
        if #normalPool > 0 then
            lines[#lines + 1] = string.format("<font color='#ffffff'>普通款总概率：%s</font>", format_doll_rate_text(normalRate, cfg.red_rate_base))
            local everyNormal = normalRate / #normalPool
            for _, resultId in ipairs(normalPool) do
                local resultCfg = get_doll_result_cfg(resultId) or {}
                lines[#lines + 1] = string.format("<font color='#ffffff'>%s\t%s</font>", tostring(resultCfg.name or resultId), format_doll_rate_text(everyNormal, cfg.red_rate_base))
            end
        end
        if #redPool > 0 then
            lines[#lines + 1] = string.format("<font color='#ffffff'>红款总概率：%s</font>", format_doll_rate_text(cfg.red_rate, cfg.red_rate_base))
            local everyRed = (tonumber(cfg.red_rate) or 0) / #redPool
            for _, resultId in ipairs(redPool) do
                local resultCfg = get_doll_result_cfg(resultId) or {}
                lines[#lines + 1] = string.format("<font color='#ffffff'>%s\t%s</font>", tostring(resultCfg.name or resultId), format_doll_rate_text(everyRed, cfg.red_rate_base))
            end
        end
        if #hiddenPool > 0 then
            lines[#lines + 1] = string.format("<font color='#ffffff'>隐藏款总概率：%s</font>", format_doll_rate_text((cfg.hidden or {}).rate, (cfg.hidden or {}).rate_base or cfg.red_rate_base))
            local everyHidden = (tonumber((cfg.hidden or {}).rate) or 0) / #hiddenPool
            for _, resultId in ipairs(hiddenPool) do
                local resultCfg = get_doll_result_cfg(resultId) or {}
                lines[#lines + 1] = string.format("<font color='#ffffff'>%s\t%s</font>", tostring(resultCfg.name or resultId), format_doll_rate_text(everyHidden, (cfg.hidden or {}).rate_base or cfg.red_rate_base))
            end
        end
        if tonumber(cfg.pity_need) and tonumber(cfg.pity_need) > 0 then
            lines[#lines + 1] = string.format("<font color='#ffffff'>连续%s次未出红款，下次必出红款</font>", format_doll_number(cfg.pity_need))
        end
        if cfg.every_draw_reward and next(cfg.every_draw_reward) then
            lines[#lines + 1] = string.format("<font color='#ffffff'>每次固定奖励：%s</font>", format_doll_cost(cfg.every_draw_reward))
        end
        return table.concat(lines, "<br>")
    end

    local function render_doll_side_tabs(parent)
        local tabs = {
            {id = 'doll_machine', x = 6 - 42, y = 247 + 50 + 88},
            {id = 'doll_cabinet', x = 6 - 42, y = 123 + 50 + 88},
        }
        for _, tab in ipairs(tabs) do
            local btn = GUI:Button_Create(parent, 'doll_side_tab_' .. tab.id, tab.x, tab.y, get_doll_tab_skin(tab.id))
            GUI:setAnchorPoint(btn, 0, 1)
            GUI:addOnClickEvent(btn, function()
                if npc.woodcut_doll.tab ~= tab.id then
                    npc.woodcut_doll.tab = tab.id
                    open_doll_machine()
                end
            end)
        end
    end

    local function open_doll_draw_popup(results, drawCount)
        results = type(results) == 'table' and results or {}
        if #results <= 0 then
            return
        end
        local parent = GUI:GetWindow(nil, 'doll_xjm')
        if not is_valid_cobj(parent) then
            parent = nil
        end
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create('doll_xjm', 0, 0, 0, 0, false, false, true, true, true, nil, 30)
        end
        if not is_valid_cobj(parent) then
            return
        end
        local popupToken = string.format('doll_popup_%s_%s', tostring(os.clock()), tostring(math.random(1000, 9999)))
        npc.woodcut_doll.popupToken = popupToken
        npc.woodcut_doll.popupRendered = nil
        local function is_popup_alive()
            return npc.woodcut_doll.popupToken == popupToken and is_valid_cobj(parent)
        end
        local startFrame = npc.woodcut_doll.skipAnim and 120 or 1
        local endFrame = 150
        local overlay = GUI:Image_Create(parent, 'bjt', 0, 0, 'res/public/1900000651_1.png')
        GUI:setAnchorPoint(overlay, 0.5, 0.5)
        GUI:setContentSize(overlay, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(overlay, true)
        local qualityColor = {
            normal = '#d9edf8',
            red = '#ff8f80',
            hidden = '#ffe37e',
        }
        local function close_popup()
            if npc.woodcut_doll.popupToken == popupToken then
                npc.woodcut_doll.popupToken = nil
            end
            if is_valid_cobj(parent) then
                GUI:Win_Close(parent)
            end
        end
        local function render_result_layer()
            if not is_popup_alive() then
                return
            end
            if npc.woodcut_doll.popupRendered == popupToken then
                return
            end
            npc.woodcut_doll.popupRendered = popupToken
            local resultLayer = GUI:Layout_Create(parent, 'doll_result_layer', 0, 0, cogin.w, cogin.h, false)
            GUI:setLocalZOrder(resultLayer, 20)
            GUI:setTouchEnabled(resultLayer, true)
            local title = GUI:Text_Create(resultLayer, 'doll_draw_title', cogin.w / 2, cogin.h - 92, 28, '#ffe9c2', drawCount >= 10 and '十连抽取结果' or '抓取成功')
            GUI:setAnchorPoint(title, 0.5, 0.5)
            GUI:Text_enableOutline(title, '#100808', 2)
            local hint = GUI:Text_Create(resultLayer, 'doll_draw_hint', cogin.w / 2, 88, 18, '#ffffff', '点击关闭返回娃娃机')
            GUI:setAnchorPoint(hint, 0.5, 0.5)
            GUI:Text_enableOutline(hint, '#100808', 2)
            local closeBtn = GUI:Button_Create(resultLayer, 'know_btn', cogin.w / 2, 120, 'res/wy/public/kb_btn.png')
            GUI:setAnchorPoint(closeBtn, 0.5, 0)
            GUI:Button_setTitleText(closeBtn, '关闭')
            GUI:Button_setTitleFontSize(closeBtn, 18)
            GUI:setLocalZOrder(closeBtn, 100)
            GUI:addOnClickEvent(closeBtn, function()
                close_popup()
            end)
            if drawCount <= 1 then
                local entry = results[1] or {}
                local asset = get_doll_asset(entry.resultId)
                local previewWrap = GUI:Layout_Create(resultLayer, 'doll_draw_single_wrap', cogin.w / 2 - 80, cogin.h / 2 - 120, 160, 220, false)
                local preview
                if asset then
                    preview = GUI:Image_Create(previewWrap, 'doll_draw_preview', 80, 140, asset)
                    GUI:setAnchorPoint(preview, 0.5, 0.5)
                    GUI:setOpacity(preview, 0)
                end
                local quality = tostring(entry.quality or 'normal')
                local name = GUI:Text_Create(resultLayer, 'doll_draw_name', cogin.w / 2, cogin.h / 2 - 86 - 100, 46, qualityColor[quality] or '#ffffff', tostring(entry.name or ''))
                GUI:setAnchorPoint(name, 0.5, 0)
                GUI:Text_setFontName(name, 'fonts/448.ttf')
                GUI:Text_enableOutline(name, '#000000', 2)
                local attr_desc = GUI:RichText_Create(preview, 'doll_draw_attr_desc', 67, 164-155 + 20, tostring(entry.attrDesc or ''), 420, 14, '#f7f7de', 1, nil, nil)
                GUI:setAnchorPoint(attr_desc, 0.5, 1)
                GUI:setOpacity(name, 0)
                GUI:setOpacity(attr_desc, 0)
                if preview and is_valid_cobj(preview) then
                    GUI:runAction(preview, GUI:ActionFadeIn(0.25))
                end
                GUI:runAction(name, GUI:ActionFadeIn(0.25))
                GUI:runAction(attr_desc, GUI:ActionFadeIn(0.25))
                return
            end
            local cols = 5
            local cardW = 96 + 30
            local cardH = 152 + 50
            local startX = cogin.w / 2 - 232
            local startY = cogin.h / 2 + 46
            for idx, entry in ipairs(results) do
                local col = (idx - 1) % cols
                local row = math.floor((idx - 1) / cols)
                local posX = startX + col * 150
                local posY = startY - row * 230
                local card = GUI:Layout_Create(resultLayer, 'doll_draw_card_' .. idx, posX, posY, cardW, cardH, false)
                GUI:setLocalZOrder(card, 50)
                GUI:setVisible(card, false)
                local asset = get_doll_asset(entry.resultId)
                if asset then
                    GUI:Image_Create(card, 'doll_draw_card_asset_' .. idx, 0, 0, asset)
                end
                local quality = tostring(entry.quality or 'normal')
                local qualityText = GUI:Text_Create(card, 'doll_draw_card_quality_' .. idx, 8, cardH - 26, 14, qualityColor[quality] or '#ffffff', tostring(entry.qualityName or ''))
                GUI:Text_enableOutline(qualityText, '#100808', 2)
                local nameText = GUI:Text_Create(card, 'doll_draw_card_name_' .. idx, 67, 164-155 + 20, 14, '#f8eed8', tostring(entry.name or ''))
                GUI:setAnchorPoint(nameText, 0.5, 0)
                GUI:Text_enableOutline(nameText, '#100808', 2)
                local attrText = GUI:Text_Create(card, 'doll_draw_card_attr_' .. idx, 67, 164-155, 14, '#fff0c0', tostring(entry.attrDesc or ''))
                GUI:setAnchorPoint(attrText, 0.5, 0)
                GUI:Text_enableOutline(attrText, '#100808', 2)
                GUI:addOnClickEvent(card, function()
                    local worldPos = GUI:getWorldPosition(card)
                    SL:OpenCommonDescTipsPop({
                        str = string.format("<font color='#ffe9c2'>%s[%s]</font><br><font color='#ffffff'>%s</font>", tostring(entry.name or ''), tostring(entry.qualityName or ''), tostring(entry.attrDesc or '')),
                        worldPos = {x = worldPos.x, y = worldPos.y},
                        anchorPoint = {x = 0, y = 1},
                        formatWay = 1
                    })
                end)
                GUI:setVisible(card, true)
                GUI:setOpacity(card, 0)
                GUI:setScale(card, 0.9)
                GUI:runAction(card, GUI:ActionSpawn(
                    GUI:ActionFadeIn(0.5),
                    GUI:ActionSequence(
                        GUI:ActionScaleTo(0.3, 1.04),
                        GUI:ActionScaleTo(0.3, 1)
                    )
                ))
            end
        end
        local bg = GUI:Frames_Create(parent, 'bg', cogin.w / 2, cogin.h / 2 + 100, 'res/custom/three_city/xianfu/仙府部分/娃娃机/bg/eff_', '.png', startFrame, endFrame,
            { speed = 50, count = 150, loop = 1, callback = function(self)
                if not is_popup_alive() then
                    return
                end
                render_result_layer()
            end })
        GUI:setContentSize(bg, cogin.w + 300, cogin.h + 300)
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        GUI:setTouchEnabled(bg, true)
        if not npc.woodcut_doll.skipAnim then
            GUI:Timeline_DelayTime(parent, 8, function()
                if is_popup_alive() then
                    render_result_layer()
                end
            end)
        else
            GUI:Timeline_DelayTime(parent, 0.05, function()
                if is_popup_alive() then
                    render_result_layer()
                end
            end)
        end
    end

    local function render_doll_draw_overlay(parent)
        local reveal = npc.woodcut_doll.reveal
        if type(reveal) ~= 'table' then
            return
        end
        local results = reveal.results or {}
        if #results <= 0 then
            return
        end
        local overlay = GUI:Layout_Create(parent, 'doll_draw_overlay', -40, 0, 840, 500, false)
        local mask = GUI:Image_Create(overlay, 'overlay_mask', 0, 0, 'res/public/1900000651_1.png')
        GUI:setOpacity(mask, 225)
        GUI:setTouchEnabled(mask, true)
        if reveal.phase == 'opening' then
            local eff = GUI:Frames_Create(overlay, 'overlay_eff', 0, 0, 'res/custom/three_city/xianfu/仙府部分/娃娃机/bg/eff_', '.png', 1, 150, {
                speed = 75,
                count = 150,
                loop = 1
            })
            GUI:setLocalZOrder(eff, 2)
            if not reveal.openingScheduled then
                reveal.openingScheduled = true
                local token = reveal.token
                GUI:Timeline_DelayTime(overlay, 115, function()
                    local current = npc.woodcut_doll.reveal
                    if current ~= reveal or current.token ~= token then
                        return
                    end
                    current.openingScheduled = nil
                    current.phase = npc.woodcut_doll.skipAnim and 'summary' or 'reveal'
                    current.showCount = npc.woodcut_doll.skipAnim and #results or 1
                    open_doll_machine()
                end)
            end
            return
        end
        local effStatic = GUI:Image_Create(overlay, 'overlay_eff_static', 0, 0, 'res/custom/three_city/xianfu/仙府部分/娃娃机/bg/eff_150.png')
        GUI:setLocalZOrder(effStatic, 2)
        local title = GUI:Text_Create(overlay, 'overlay_title', cogin.w / 2 - 40, 446, 26, '#ffe9c2', reveal.phase == 'summary' and (#results >= 10 and '十连结果' or '抽取结果') or '娃娃抓取中')
        GUI:Text_enableOutline(title, '#100808', 2)
        GUI:setAnchorPoint(title, 0.5, 0.5)
        local hintText = reveal.phase == 'summary' and '点击关闭返回娃娃机，点击任意结果查看属性' or '开奖结果揭晓中'
        local hint = GUI:Text_Create(overlay, 'overlay_hint', cogin.w / 2 - 40, 412, 18, '#ffffff', hintText)
        GUI:Text_enableOutline(hint, '#100808', 2)
        GUI:setAnchorPoint(hint, 0.5, 0.5)
        local closeBtn = GUI:Button_Create(overlay, 'overlay_close', cogin.w / 2 - 150, 86, 'res/wy/public/kb_btn.png')
        GUI:setLocalZOrder(closeBtn, 5)
        GUI:Button_setTitleText(closeBtn, '关闭')
        GUI:Button_setTitleFontSize(closeBtn, 18)
        GUI:addOnClickEvent(closeBtn, function()
            npc.woodcut_doll.reveal = nil
            open_doll_machine()
        end)

        local qualityColor = {
            normal = '#d9edf8',
            red = '#ff8f80',
            hidden = '#ffe37e',
        }
        local cardNodes = {}
        local visibleCount = math.max(0, math.min(#results, tonumber(reveal.showCount or 0) or 0))
        local cols = (#results >= 10) and 5 or math.min(#results, 3)
        local cardW = (#results >= 10) and 96 or 138
        local cardH = (#results >= 10) and 152 or 214
        local startX = (#results >= 10) and 148 or (cogin.w / 2 - 40 - math.floor((cols - 1) * 82))
        local baseY = (#results >= 10) and 210 or 138
        for idx, entry in ipairs(results) do
            local col = (idx - 1) % cols
            local row = math.floor((idx - 1) / cols)
            local posX = startX + col * ((#results >= 10) and 104 or 164)
            local posY = baseY - row * ((#results >= 10) and 166 or 0)
            local card = GUI:Layout_Create(overlay, 'overlay_card_' .. idx, posX, posY, cardW, cardH, false)
            GUI:setLocalZOrder(card, 4)
            local asset = get_doll_asset(entry.resultId)
            if asset then
                GUI:Image_Create(card, 'overlay_card_asset_' .. idx, 0, 0, asset)
            end
            local labelBg = GUI:Image_Create(card, 'overlay_card_labelbg_' .. idx, -8, cardH - 56, 'res/custom/three_city/xianfu/仙府部分/娃娃机/下方透明底.png')
            GUI:setScaleX(labelBg, 0.28)
            GUI:setScaleY(labelBg, 0.42)
            GUI:setOpacity(labelBg, 180)
            local qualityText = GUI:Text_Create(card, 'overlay_card_quality_' .. idx, 8, cardH - 26, 14, qualityColor[tostring(entry.quality or 'normal')] or '#ffffff', tostring(entry.qualityName or ''))
            GUI:Text_enableOutline(qualityText, '#100808', 2)
            local nameText = GUI:Text_Create(card, 'overlay_card_name_' .. idx, math.floor(cardW / 2), cardH - 46, (#results >= 10) and 13 or 15, '#f8eed8', tostring(entry.name or ''))
            GUI:setAnchorPoint(nameText, 0.5, 0)
            GUI:Text_enableOutline(nameText, '#100808', 2)
            local attrText = GUI:Text_Create(card, 'overlay_card_attr_' .. idx, math.floor(cardW / 2), 10, (#results >= 10) and 12 or 14, '#fff0c0', tostring(entry.attrDesc or ''))
            GUI:setAnchorPoint(attrText, 0.5, 0)
            GUI:Text_enableOutline(attrText, '#100808', 2)
            GUI:setVisible(card, idx <= visibleCount or reveal.phase == 'summary')
            if reveal.phase ~= 'summary' and idx == visibleCount and visibleCount > 0 then
                GUI:setOpacity(card, 0)
                GUI:setScale(card, 0.8)
                GUI:runAction(card, GUI:ActionSpawn(
                    GUI:ActionFadeIn(0.12),
                    GUI:ActionSequence(
                        GUI:ActionScaleTo(0.08, 1.08),
                        GUI:ActionScaleTo(0.08, 1)
                    )
                ))
            end
            GUI:addOnClickEvent(card, function()
                local worldPos = GUI:getWorldPosition(card)
                SL:OpenCommonDescTipsPop({
                    str = string.format("<font color='#ffe9c2'>%s[%s]</font><br><font color='#ffffff'>%s</font>", tostring(entry.name or ''), tostring(entry.qualityName or ''), tostring(entry.attrDesc or '')),
                    worldPos = {x = worldPos.x, y = worldPos.y},
                    anchorPoint = {x = 0, y = 1},
                    formatWay = 1
                })
            end)
            cardNodes[#cardNodes + 1] = card
        end
        if reveal.phase == 'summary' and #results == 1 then
            local entry = results[1] or {}
            local quality = tostring(entry.quality or 'normal')
            local summaryTitle = GUI:Text_Create(overlay, 'overlay_single_title', cogin.w / 2 - 40, 144, 42, qualityColor[quality] or '#ffffff', tostring(entry.name or ''))
            GUI:setAnchorPoint(summaryTitle, 0.5, 0)
            GUI:Text_setFontName(summaryTitle, 'fonts/448.ttf')
            GUI:Text_enableOutline(summaryTitle, '#100808', 2)
            local summaryDesc = GUI:RichText_Create(overlay, 'overlay_single_desc', cogin.w / 2 - 40, 116, tostring(entry.attrDesc or ''), 360, 20, '#f7f7de', 1, nil, nil)
            GUI:setAnchorPoint(summaryDesc, 0.5, 1)
        end
        if reveal.phase ~= 'summary' and not reveal.skipAnim and not reveal.stepScheduled then
            reveal.stepScheduled = true
            local token = reveal.token
            GUI:Timeline_DelayTime(overlay, 18, function()
                local current = npc.woodcut_doll.reveal
                if current ~= reveal or current.token ~= token then
                    return
                end
                current.stepScheduled = nil
                current.showCount = math.min(#results, (tonumber(current.showCount or 0) or 0) + 1)
                if current.showCount >= #results then
                    current.phase = 'summary'
                end
                open_doll_machine()
            end)
        end
    end

    local function render_doll_machine_panel(parent)
        local payload = npc.woodcut_doll.payload or {}
        local doll = payload.doll or {}
        local cfg = get_doll_cfg()
        local bg = GUI:Frames_Create(parent, "eff", 0 - 40, 0, "res/custom/three_city/xianfu/仙府部分/娃娃机/bg/eff_", ".png", 1, 150,
        { speed = 75, count = 150, loop = -1})
        GUI:Image_Create(parent, 'machine_rule_img', 498 - 40, 273, 'res/custom/three_city/xianfu/仙府部分/娃娃机/游戏规则.png')
        GUI:Image_Create(parent, 'machine_material_title', 58 - 20, 132, 'res/custom/three_city/xianfu/仙府部分/娃娃机/所需材料.png')
        local panel = GUI:Image_Create(parent, 'machine_info_bg', 42 - 20, 8, 'res/custom/three_city/xianfu/仙府部分/娃娃机/下方透明底.png')
        local tip = GUI:Image_Create(parent, 'machine_tip', 650 - 40 -553, 402 - 389, 'res/custom/msfc/page1/wenhao.png')

        GUI:setAnchorPoint(panel, 0, 0)
        GUI:setOpacity(panel, 185)
        local tipHtml = build_doll_tip_html()
        if SL:GetMetaValue("WINPLAYMODE") then
            GUI:addMouseMoveEvent(tip, {onEnterFunc = function()
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = tipHtml, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
            end, onLeaveFunc = function()
                SL:CloseCommonDescTipsPop()
            end})
        else
            GUI:setTouchEnabled(tip, true)
            GUI:addOnTouchEvent(tip, function(self)
                local pos = GUI:getWorldPosition(tip)
                SL:OpenCommonDescTipsPop({str = tipHtml, worldPos = {x = pos.x, y = pos.y}, anchorPoint = {x = 0, y = 0}, formatWay = 1})
            end)
        end
        local pityNeed = doll.pity_need or cfg.pity_need or 0
        local tokenCount = tonumber(SL:GetMetaValue('TMONEY', '仙府币') or 0) or 0
        local singleCost = doll.current_cost or cfg.normal_draw_cost or {}
        local tenNeed = build_doll_preview_batch_cost(doll, cfg, 10)
        local tenCost = payload.ten_cost or {{'仙府币', tenNeed}}
        local guang = GUI:Image_Create(panel, "cost_ten_value_img",  26, 86, "res/wy/public/guang.png")
        GUI:setContentSize(guang, 180 + 120, 30)
        GUI:setScale(GUI:ItemShow_Create(guang, "icon", 105, 5, {index = SL:GetMetaValue("ITEM_INDEX_BY_NAME","仙府币")}), 0.6)
        GUI:Text_setFontName(GUI:Text_Create(guang, "Text_Money2", 3.00, 2.00, 22, "#ffffff", [[所需消耗:]]), "fonts/501.ttf")
        local singleNeed = get_doll_cost_count(singleCost, '仙府币')
        local currentTokenColor = tokenCount >= singleNeed and "#45ff93" or "#ff6666"
        GUI:RichText_Create(guang, "text", 130, 5, string.format("<font color='%s'>%s</font><font color='#FFFFFF'>/%s</font>", currentTokenColor, format_doll_number(tokenCount), format_doll_cost(singleCost)), 300, 16, "#FFFFFF", 0, nil, nil)
        local tenColor = tokenCount >= tenNeed and '#45ff93' or '#ff6666'
        -- local infoRows = {
        --     string.format('累计抓取：%s', format_doll_number(doll.draw_total or 0)),
        --     string.format('新手剩余：%s', format_doll_number(doll.newbie_left or 0)),
        --     string.format('红款保底：%s/%s', format_doll_number(doll.pity_progress or 0), format_doll_number(pityNeed)),
        --     string.format('隐藏已出：%s', format_doll_number(doll.hidden_count or 0)),
        --     string.format('十连消耗：%s', format_doll_cost(tenCost)),
        -- }
        -- local rowColors = {'#ffe1a8', '#9fe8ff', '#ffd38f', '#ffb3a0', tenColor}
        -- for idx, text in ipairs(infoRows) do
        --     local rowLabel = GUI:Text_Create(panel, 'machine_info_row_' .. idx, 26, 62 - (idx - 1) * 18, 16, rowColors[idx] or '#ffffff', text)
        --     GUI:Text_enableOutline(rowLabel, '#100808', 2)
        -- end
        local lastResultId = ((npc.woodcut_doll.lastResult or {}).resultId) or doll.last_result
        local resultCfg = lastResultId and get_doll_result_cfg(lastResultId) or nil
        -- if resultCfg then
        --     local resultName = GUI:Text_Create(panel, 'machine_result_name', 388, 86, 18, '#ffd66b', string.format('最近获得：%s[%s]', resultCfg.name or '', resultCfg.quality_name or ''))
        --     local resultDesc = GUI:Text_Create(panel, 'machine_result_desc', 388, 58, 16, '#ffffff', resultCfg.attr_desc or '')
        --     GUI:Text_enableOutline(resultName, '#100808', 2)
        --     GUI:Text_enableOutline(resultDesc, '#100808', 2)
        --     local asset = get_doll_asset(lastResultId)
        --     if asset then
        --         local preview = GUI:Image_Create(panel, 'machine_result_preview', 655, 8, asset)
        --         GUI:setScale(preview, 0.42)
        --         GUI:setAnchorPoint(preview, 0.5, 0)
        --     end
        -- else
        --     local emptyText = GUI:Text_Create(panel, 'machine_result_empty', 388, 72, 18, '#ffffff', '尚未抓到娃娃')
        --     GUI:Text_enableOutline(emptyText, '#100808', 2)
        -- end
        local skipWrap = GUI:Layout_Create(parent, 'doll_skip_wrap', 560, 92, 160, 28, false)
        local skipBtn = GUI:CheckBox_Create(skipWrap, 'doll_skip_check', 0, 0, 'res/public/1900000550.png', 'res/public/1900000551.png')
        GUI:CheckBox_setSelected(skipBtn, npc.woodcut_doll.skipAnim == true)
        GUI:CheckBox_addOnEvent(skipBtn, function(self)
            npc.woodcut_doll.skipAnim = GUI:CheckBox_isSelected(self)
        end)
        local skipLabel = GUI:Image_Create(skipWrap, 'doll_skip_label', 30, -2, 'res/custom/three_city/xianfu/仙府部分/娃娃机/跳过动画.png')
        GUI:setTouchEnabled(skipLabel, false)
        local drawBtn = GUI:Button_Create(parent, 'doll_draw_btn', 630, 40, 'res/custom/three_city/xianfu/仙府部分/娃娃机/抓一次.png')
        GUI:setAnchorPoint(drawBtn, 0.5, 0.5)
        GUI:addOnClickEvent(drawBtn, function()
            request_draw_doll_machine(1)
        end)
        local drawTenBtn = GUI:Button_Create(parent, 'doll_draw_ten_btn', 400, 40, 'res/custom/three_city/xianfu/仙府部分/娃娃机/抓十次.png')
        GUI:setAnchorPoint(drawTenBtn, 0.5, 0.5)
        GUI:addOnClickEvent(drawTenBtn, function()
            request_draw_doll_machine(10)
        end)
        if tonumber(doll.draw_total or 0) <= 0 then
            local firstTenTips = GUI:Text_Create(parent, 'doll_first_ten_discount', 400, 74 + 10, 20, '#FF0000', '首次十连 2 折')
            GUI:setAnchorPoint(firstTenTips, 0.5, 0.5)
            GUI:Text_setFontName(firstTenTips, 'fonts/502.ttf')
            GUI:Text_enableOutline(firstTenTips, '#100808', 2)
        end
    end

    local function render_doll_cabinet_panel(parent)
        local payload = npc.woodcut_doll.payload or {}
        local doll = payload.doll or {}
        local ownedList = build_doll_owned_list(doll)
        GUI:Image_Create(parent, 'cabinet_room_bg', 0 - 40, 0, 'res/custom/three_city/xianfu/仙府部分/收藏柜/收藏柜背景.png')
        local viewX = 66
        local viewY = 66 - 50
        local viewW = 644
        local viewH = 394 + 50
        local scroll = GUI:ScrollView_Create(parent, 'cabinet_scroll', viewX, viewY, viewW, viewH, 1)
        GUI:ScrollView_setBounceEnabled(scroll, true)
        GUI:setTouchEnabled(scroll, true)
        local cols = 4
        local cellW = 139
        local cellH = 214
        local rows = math.max(1, math.ceil(math.max(#ownedList, 1) / cols))
        local innerH = math.max(viewH, rows * cellH + 10)
        GUI:ScrollView_setInnerContainerSize(scroll, viewW, innerH)
        local layout = GUI:Layout_Create(scroll, 'cabinet_layout', 0, 0, viewW, innerH, false)
        if #ownedList <= 0 then
            local emptyText = GUI:Text_Create(layout, 'cabinet_empty_text', 260, math.floor(innerH / 2), 22, '#f3ead4', '暂无已解锁娃娃')
            GUI:Text_enableOutline(emptyText, '#100808', 2)
        else
            local qualityColor = {
                normal = '#d9edf8',
                red = '#ff8f80',
                hidden = '#ffe37e',
            }
            for idx, entry in ipairs(ownedList) do
                local col = (idx - 1) % cols
                local row = math.floor((idx - 1) / cols)
                local posX = 8 + col * cellW
                local posY = innerH - 208 - 8 - row * cellH
                local slot = GUI:Layout_Create(layout, 'cabinet_owned_' .. idx, posX, posY, 134, 208, false)
                local asset = get_doll_asset(entry.id)
                if asset then
                    GUI:Image_Create(slot, 'cabinet_owned_img_' .. idx, 0, 0, asset)
                end
                local attrLabel = GUI:Text_Create(slot, 'cabinet_attr_label_' .. idx, 67, 164 - 155, 14, '#ffe084', get_doll_attr_label(entry.cfg or {}, entry.count))
                GUI:setAnchorPoint(attrLabel, 0.5, 0)
                GUI:Text_enableOutline(attrLabel, '#100808', 2)
                local dollName = tostring((entry.cfg or {}).name or '')
                local nameText = GUI:Text_Create(slot, 'cabinet_name_' .. idx, 67, 164 - 155 + 20, 14, '#f3ead4', dollName)
                GUI:setAnchorPoint(nameText, 0.5, 0)
                GUI:Text_enableOutline(nameText, '#100808', 2)
                local quality = tostring((entry.cfg or {}).quality or 'normal')
                local qualityName = tostring((entry.cfg or {}).quality_name or '')
                local qualityText = GUI:Text_Create(slot, 'cabinet_quality_' .. idx, 8, 184, 14, qualityColor[quality] or '#ffffff', qualityName)
                GUI:Text_enableOutline(qualityText, '#100808', 2)
                local countText = GUI:Text_Create(slot, 'cabinet_count_' .. idx, 126, 184, 14, '#ffe084', 'x' .. format_doll_number(entry.count))
                GUI:setAnchorPoint(countText, 1, 0)
                GUI:Text_enableOutline(countText, '#100808', 2)
            end
        end
    end

    open_doll_machine = function()
        local skin = 'res/wy/public/tongyong_0.png'
        npc.doll_window = NPC_UI_HELPER.ensureWindow(npc.doll_window or {}, 30, {
            windowName = 'npc_anniu_30_doll',
            background = {
                skin = skin,
            },
            closeButton = {x = 782, y = 470},
            title = {x = 50, y = 464, skin = "res/custom/three_city/xianfu/仙府部分/标题.png"},
        })
        local node = npc.doll_window and npc.doll_window.node
        if not node then
            return
        end
        render_doll_side_tabs(node)
        if npc.woodcut_doll.tab == 'doll_cabinet' then
            render_doll_cabinet_panel(node)
        else
            render_doll_machine_panel(node)
        end
    end
    -- local function btn_buy_xjm()
    --     local config = teshudata["anniu_30"]
    --     npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
    --         windowName = "npc_anniu_30_xjm",
    --         background = {
    --             skin = "res/custom/three_city/xianfu/kanshu/buy/bg.png",
    --         },
    --         closeButton = {
    --             x = 600,
    --             y = 260,
    --         },
    --     })
    --     npc.xjm_node = npc.xjm_window.node
    --     GUI:Text_setFontName(GUI:Text_Create(npc.xjm_node, "cost", 422, 100, 30, "#FFFFFF", (npc.data_30.T_data.dh_num + 1) > #config.dh.details and config.dh.cost[1][2] or config.dh.details[npc.data_30.T_data.dh_num + 1].cost[1][2]), "fonts/501.ttf")
    --     GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item1", 250, 196, {
    --         index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", "仙府币"),
    --         count = 1,
    --         look = true,
    --     }), 0.5, 0.5)
    --     GUI:setAnchorPoint(GUI:ItemShow_Create(npc.xjm_node, "item2", 490, 196, {
    --         index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", "砍树盲盒"),
    --         count = 1,
    --         look = true,
    --     }), 0.5, 0.5)
    --     local btn = GUI:Button_Create(npc.xjm_node, "btn", 364, 10, "res/custom/three_city/xianfu/kanshu/buy/btn.png")
    --     GUI:setAnchorPoint(btn, 0.5, 0)
    --     GUI:addOnClickEvent(btn, function()
    --         request_open_doll_machine()
    --     end)
    -- end
    if p2 == 0 then
        npc.data_30 = not Data and {
        } or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        local config = teshudata["anniu_30"]
        local parent = GUI:GetWindow(nil, "anniu_30")
        if parent then
            GUI:removeAllChildren(parent)
        else
            parent = GUI:Win_Create("anniu_30", 0, 0, 0, 0, false, false, true, true, true, nil, 1)
        end
        npc.mainWindow = parent
        local bjt = GUI:Image_Create(parent, "bjt", cogin.w / 2, cogin.h / 2, "res/custom/three_city/xianfu/kanshu/bg_1/eff_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w, cogin.h)
        GUI:setTouchEnabled(bjt, true)
        GUI:addMouseOverTips(bjt, "", {
            x = 0,
            y = 0,
        }, {
            x = 0,
            y = 0,
        })
        local bg = GUI:Frames_Create(bjt, "bg", cogin.w / 2, cogin.h / 2, "res/custom/three_city/xianfu/kanshu/bg_" .. npc.data_30.T_data.axe .. "/eff_", ".png", 1, 75, {
            speed = 75,
            count = 75,
            loop = -1,
        })
        GUI:setContentSize(bg, cogin.w, cogin.h)
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        local heidi = GUI:Image_Create(bg, "heidi", 0, cogin.h, "res/custom/three_city/xianfu/kanshu/heidi.png")
        GUI:setAnchorPoint(heidi, 0, 1)
        GUI:setContentSize(heidi, cogin.w, GUI:getContentSize(heidi).height)
        local tip_wz = GUI:Image_Create(heidi, "tip_wz", cogin.w / 2, 30, "res/custom/three_city/xianfu/kanshu/tip_wz.png")
        GUI:setAnchorPoint(tip_wz, 0.5, 0.5)
        local lz_wz = GUI:Image_Create(bg, "lz_wz", 0, cogin.h - 200, "res/custom/three_city/xianfu/kanshu/lz_wz.png")
        GUI:setAnchorPoint(lz_wz, 0, 1)
        local re_wz = GUI:Image_Create(bg, "re_wz", cogin.w, 0, "res/custom/three_city/xianfu/kanshu/re_wz.png")
        GUI:setAnchorPoint(re_wz, 1, 0)
        npc.node = GUI:Node_Create(bg, "node", 0, 0)
        SL:schedule(npc.node, function()
            SL:SendLuaNetMsg(101, 30, 2, 1, '')
        end, (config.updata[1].details[npc.data_30.T_data.axe].ratio * config.updata[2].details[math.max(npc.data_30.T_data.auto, 1)].ratio * config.base_time))
        npc.wz1 = GUI:Text_Create(re_wz, "wz1", 133, 483, 20, "#FFFFFF", npc.data_30.T_data.num)
        npc.wz2 = GUI:Text_Create(re_wz, "wz2", 133, 449, 20, "#FFFFFF", npc.data_30.T_data.dh_num)
        local btn_updata_2 = GUI:Button_Create(re_wz, "btn_updata_2", 278 / 2, 300 - 210, "res/custom/three_city/xianfu/kanshu/btn_updata_2.png")
        -- local btn_buy = GUI:Button_Create(re_wz, "btn_buy", 278 / 2, 300 - 70, "res/custom/three_city/xianfu/kanshu/btn_buy.png")
        local btn_tip = GUI:Button_Create(re_wz, "btn_tip", 278 / 2, 300, "res/custom/three_city/xianfu/kanshu/btn_tip.png")
        local btn_updata_1 = GUI:Button_Create(re_wz, "btn_updata_", 278 / 2, 300 - 140, "res/custom/three_city/xianfu/kanshu/btn_updata_1.png")
        local btn_doll = GUI:Button_Create(re_wz, "btn_doll", 278 / 2, 300 - 70, "res/custom/three_city/xianfu/仙府部分/抓娃娃机.png")
        GUI:setAnchorPoint(btn_updata_2, 0.5, 0.5)
        -- GUI:setAnchorPoint(btn_buy, 0.5, 0.5)
        GUI:setAnchorPoint(btn_tip, 0.5, 0.5)
        GUI:setAnchorPoint(btn_updata_1, 0.5, 0.5)
        GUI:setAnchorPoint(btn_doll, 0.5, 0.5)
        GUI:addOnClickEvent(btn_updata_2, function()
            btn_updata_2_xjm()
        end)
        -- GUI:addOnClickEvent(btn_buy, function()
        --     btn_buy_xjm()
        -- end)
        GUI:addOnClickEvent(btn_doll, function()
            request_open_doll_machine()
        end)
        GUI:addOnClickEvent(btn_tip, function()
            npc.xjm_window = NPC_UI_HELPER.ensureWindow(nil, 30, {
                windowName = "npc_anniu_30_xjm",
                background = {
                    skin = "res/custom/three_city/xianfu/kanshu/tip/bg.png",
                },
                closeButton = {
                    x = 200,
                    y = 10,
                    skin = "res/custom/three_city/xianfu/kanshu/tip/btn.png",
                },
            })
        end)
        GUI:addOnClickEvent(btn_updata_1, function()
            btn_updata_1_xjm()
        end)
        if npc.data_30.T_data.auto == 0 then
            local open_auto = GUI:Button_Create(re_wz, "open_auto", 278 / 2, 300 - 210, "res/custom/three_city/xianfu/kanshu/btn_auto.png")
            GUI:setAnchorPoint(open_auto, 0.5, 0.5)
            NPC_UI_HELPER.redpoint_create(open_auto)
            GUI:addOnClickEvent(open_auto, function()
                SL:SendLuaNetMsg(101, 30, 3, 1, '')
            end)
            GUI:setVisible(btn_updata_2, false)
            NPC_UI_HELPER.tryStartXylGuide(npc, open_auto, re_wz, "woodcut_start", {
                taskName = "了解砍树",
                dir = 5,
                desc = "开启自动砍树",
            })
        end
        local closeBtn = GUI:Button_Create(bg, 'close', cogin.w - 100, cogin.h - 70, 'res/wy/public/anniu_4_x_close.png')
        GUI:addOnClickEvent(closeBtn, function()
            GUI:Win_Close(parent)
        end)
    elseif p2 == 1 then
        npc.data_30 = not Data and {
        } or SL:JsonDecode(Data, false)
        npc.data_30.T_data.axe = npc.data_30.T_data.axe or 1
        npc.data_30.T_data.auto = npc.data_30.T_data.auto or 0
        npc.data_30.T_data.num = npc.data_30.T_data.num or 0
        npc.data_30.T_data.dh_num = npc.data_30.T_data.dh_num or 0
        if is_valid_cobj(npc.wz1) then
            GUI:Text_setString(npc.wz1, npc.data_30.T_data.num)
        end
        if is_valid_cobj(npc.wz2) then
            GUI:Text_setString(npc.wz2, npc.data_30.T_data.dh_num)
        end
    elseif p2 == 2 then
        npc.data_30 = not Data and {
        } or SL:JsonDecode(Data, false)
        if p3 == 1 then
            btn_updata_1_xjm()
        elseif p3 == 2 then
            btn_updata_2_xjm()
        end
    elseif p2 == 3 then
        npc.json = SL:JsonDecode(Data, false) or {
        }
        if not is_valid_cobj(npc.node) then
            return
        end
        for i = 1, #npc.json do
            local btn = GUI:ItemShow_Create(npc.node, "item" .. os.clock(), math.random(300, 400), math.random(300, 400), {
                index = SL:GetMetaValue("ITEM_INDEX_BY_NAME", npc.json[i][1]),
                count = 1,
                look = true,
            })
            if not is_valid_cobj(btn) then
                break
            end
            local endPos = GUI:p(math.random(100, 500), math.random(100, 50))
            local controlPoint_1 = GUI:p(300, 600)
            local controlPoint_2 = GUI:p(300, 600)
            local endPosition = endPos
            local bezier = GUI:ActionBezierTo(0.5, controlPoint_1, controlPoint_2, endPosition)
            if is_valid_cobj(btn) then
                GUI:runAction(btn, GUI:ActionSequence(bezier, GUI:DelayTime(10), GUI:CallFunc(function()
                    if is_valid_cobj(btn) then
                        GUI:removeFromParent(btn)
                    end
                end)))
            end
            if is_valid_cobj(npc.node) then
                GUI:Timeline_DelayTime(npc.node, 100, function()
                    if is_valid_cobj(btn) then
                        GUI:removeFromParent(btn)
                    end
                end)
            end
        end
    elseif p2 == 4 then
        npc.woodcut_doll.payload = (not Data or Data == '') and {doll = {}} or (SL:JsonDecode(Data, false) or {doll = {}})
        npc.woodcut_doll.reveal = nil
        npc.woodcut_doll.tab = npc.woodcut_doll.tab or 'doll_machine'
        open_doll_machine()
    elseif p2 == 5 then
        local payload = (not Data or Data == '') and {doll = {}} or (SL:JsonDecode(Data, false) or {doll = {}})
        npc.woodcut_doll.payload = payload
        npc.woodcut_doll.lastResult = payload.extra or npc.woodcut_doll.lastResult
        local results = ((payload.extra or {}).results or {})
        local count = tonumber((payload.extra or {}).count) or #results
        if count <= 0 then
            count = math.max(#results, 1)
        end
        if #results <= 0 and payload.extra then
            results = {payload.extra}
        end
        npc.woodcut_doll.reveal = nil
        npc.woodcut_doll.tab = 'doll_machine'
        open_doll_machine()
        open_doll_draw_popup(results, count)
    end
end
npc[498] = function(p2, p3, Data)
    local function hasRankingWindow()
        return npc.tyec and GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
    end
    local function createRankingWindow()
        if hasRankingWindow() then
            return
        end
        npc.tyec = GUI:Image_Create(MainAssist._ui["Panel_hide"], "tyec_bj", 18, 0.0, "res/wy/public/tycccc.png")
        GUI:setLocalZOrder(npc.tyec, 10000)
        GUI:setContentSize(npc.tyec, 260, 185)
        local height = GUI:getContentSize(npc.tyec).height
        GUI:setPositionY(npc.tyec, height)
        GUI:runAction(npc.tyec, GUI:ActionMoveBy(0.3, 0, -height))
        local desc = GUI:Text_Create(npc.tyec, "Text", 70.0, 164.0, 14, "#d6a573", "排名数据/10s刷新")
        GUI:Text_enableOutline(desc, "#000000", 1)
        npc.tyecdesc = desc
        local campScore = GUI:Text_Create(npc.tyec, "camp_score", 108.0, 145.0 + 5, 14, "#d6a573", "正方:0  邪方:0")
        GUI:setAnchorPoint(campScore, 0.5, 0.5)
        GUI:Text_enableOutline(campScore, "#000000", 1)
        npc.tyeccamp = campScore
        local activityState = GUI:Text_Create(npc.tyec, "activity_state", 108.0, 128.0, 14, "#d6a573", "")
        GUI:setAnchorPoint(activityState, 0.5, 0.5)
        GUI:Text_enableOutline(activityState, "#000000", 1)
        npc.tyecstate = activityState
        local scoreLabel = GUI:Text_Create(npc.tyec, "Text_1", 72.0, 6.0, 14, "#d6a573", "当前个人积分:")
        GUI:Text_enableOutline(scoreLabel, "#000000", 1)
        npc.tyecscoreLabel = scoreLabel
        npc.tyecgr = GUI:Text_Create(scoreLabel, "Textxx", 92.0, 0.0, 14, "#d6a573", "0")
        GUI:Text_enableOutline(npc.tyecgr, "#000000", 1)
        local list = GUI:ListView_Create(npc.tyec, "ListView", 0.0, 29.0, 261.0, 112.0, 1)
        GUI:ListView_setItemsMargin(list, 2)
        npc.tyecpmm = {
        }
        npc.tyecpmf = {
        }
        npc.tyecpmprefix = {
        }
        for i = 1, 5 do
            local row = GUI:Image_Create(list, "rank_row_" .. i, 0, 0, "res/wy/public/guang.png")
            GUI:setContentSize(row, 260, 25)
            local prefix = GUI:Text_Create(row, "rank_prefix", 10.0, 3.0, 14, "#d6a573", string.format("NO.%d    ", i))
            GUI:Text_enableOutline(prefix, "#000000", 1)
            npc.tyecpmprefix[i] = prefix
            npc.tyecpmm[i] = GUI:Text_Create(row, "player_" .. i, 55.0, 3.0, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmm[i], "#000000", 1)
            npc.tyecpmf[i] = GUI:Text_Create(row, "score_" .. i, 200.0, 3.0, 14, "#d6a573", "")
            GUI:Text_enableOutline(npc.tyecpmf[i], "#000000", 1)
        end
        if npc.refreshLingshouMainEntry then
            npc._lingshou_main_render_sig = nil
            npc.refreshLingshouMainEntry()
        end
    end
    local function updateRankingWidgets(data)
        local mode = tostring(data.mode or "")
        if mode == "" and data.question then
            mode = "qmdt"
        elseif mode == "" and (data.hjf or data.ljf) then
            mode = "zxdz"
        end
        if mode == "qmdt" then
            if npc.tyecdesc then
                GUI:Text_setString(npc.tyecdesc, "当前题目")
            end
            if npc.tyecscoreLabel then
                GUI:Text_setString(npc.tyecscoreLabel, "")
            end
            for i = 1, 5 do
                if npc.tyecpmprefix and npc.tyecpmprefix[i] then
                    GUI:Text_setString(npc.tyecpmprefix[i], "")
                end
                GUI:setPositionX(npc.tyecpmm[i], 16)
                GUI:Text_setString(npc.tyecpmm[i], "")
                GUI:Text_setString(npc.tyecpmf[i], "")
            end
            local idx = tonumber(data.idx or 0) or 0
            local total = tonumber(data.total or 0) or 0
            local question = tostring(data.question or "")
            GUI:Text_setString(npc.tyecpmm[1], string.format("第%s/%s题", tostring(idx), tostring(total)))
            GUI:Text_setString(npc.tyecpmm[2], question)
            GUI:Text_setString(npc.tyecgr, "")
            local remain = tonumber(data.limit_sec or 0) or 0
            local endTs = tonumber(data.end_ts or 0) or 0
            if endTs > 0 then
                local nowTs = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0
                if nowTs <= 0 then
                    nowTs = os.time()
                end
                remain = math.max(0, math.floor(endTs - nowTs))
            end
            if npc.tyeccamp then
                GUI:Text_setString(npc.tyeccamp, "答题倒计时：" .. tostring(remain) .. "秒")
            end
            if npc.tyecstate then
                GUI:Text_setString(npc.tyecstate, "")
            end
            return
        end
        if mode == "bwcz" then
            if npc.tyecdesc then
                GUI:Text_setString(npc.tyecdesc, "怪物剩余/10s刷新")
            end
            if npc.tyecscoreLabel then
                GUI:Text_setString(npc.tyecscoreLabel, "当前个人积分:")
            end
            for i = 1, 5 do
                if npc.tyecpmprefix and npc.tyecpmprefix[i] then
                    GUI:Text_setString(npc.tyecpmprefix[i], "")
                end
                GUI:setPositionX(npc.tyecpmm[i], 16)
                local info = data.mon_left and data.mon_left[i]
                if type(info) == "table" then
                    GUI:Text_setString(npc.tyecpmm[i], tostring(info.name or ""))
                    GUI:Text_setString(npc.tyecpmf[i], tostring(info.left or 0))
                else
                    GUI:Text_setString(npc.tyecpmm[i], "")
                    GUI:Text_setString(npc.tyecpmf[i], "")
                end
            end
            GUI:Text_setString(npc.tyecgr, data.grjf or 0)
            if npc.tyeccamp then
                GUI:Text_setString(npc.tyeccamp, string.format("军团:%s", tostring(data.wave_name or "未知")))
            end
            if npc.tyecstate then
                GUI:Text_setString(npc.tyecstate, string.format("总剩余:%s", tostring(data.left_mon or 0)))
            end
            return
        end
        local mc = 1
        if npc.tyecdesc then
            GUI:Text_setString(npc.tyecdesc, "排名数据/10s刷新")
        end
        if npc.tyecscoreLabel then
            GUI:Text_setString(npc.tyecscoreLabel, "当前个人积分:")
        end
        for i = 1, 5 do
            if npc.tyecpmprefix and npc.tyecpmprefix[i] then
                GUI:Text_setString(npc.tyecpmprefix[i], string.format("NO.%d    ", i))
            end
            GUI:setPositionX(npc.tyecpmm[i], 55)
            if data.pmsj and data.pmsj[i * 2] and data.pmsj[i * 2] > 0 then
                GUI:Text_setString(npc.tyecpmm[i], data.pmsj[mc])
                GUI:Text_setString(npc.tyecpmf[i], data.pmsj[i * 2])
                mc = mc + 2
            else
                GUI:Text_setString(npc.tyecpmm[i], "")
                GUI:Text_setString(npc.tyecpmf[i], "")
            end
        end
        GUI:Text_setString(npc.tyecgr, data.grjf or 0)
        if npc.tyeccamp then
            if data.wave_name or data.left_mon then
                GUI:Text_setString(npc.tyeccamp, string.format("军团:%s", tostring(data.wave_name or "未知")))
            elseif mode == "zxdz" or data.hjf ~= nil or data.ljf ~= nil then
                GUI:Text_setString(npc.tyeccamp, string.format("正方:%s  邪方:%s", data.hjf or 0, data.ljf or 0))
            else
                GUI:Text_setString(npc.tyeccamp, "")
            end
        end
        if npc.tyecstate then
            if data.wave_name or data.left_mon then
                GUI:Text_setString(npc.tyecstate, string.format("剩余怪物:%s", tostring(data.left_mon or 0)))
            else
                GUI:Text_setString(npc.tyecstate, "")
            end
        end
    end
    if p2 == 0 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if not hasRankingWindow() then
            createRankingWindow()
        end
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 1 then
        npc.tyecsj = SL:JsonDecode(Data, false)
        if not hasRankingWindow() then
            createRankingWindow()
        end
        updateRankingWidgets(npc.tyecsj)
    elseif p2 == 2 then
        if GUI:getChildByName(MainAssist._ui["Panel_hide"], "tyec_bj") then
            GUI:removeChildByName(MainAssist._ui["Panel_hide"], "tyec_bj")
            npc.tyec = nil
            if npc.refreshLingshouMainEntry then
                npc._lingshou_main_render_sig = nil
                npc.refreshLingshouMainEntry()
            end
        end
    end
end
npc[501] = function(p2, p3, Data)
    local function get_cfg()
        return teshudata["anniu_501"] or {
        }
    end
    local function get_slots()
        local details = (get_cfg().details or {
        })
        return details.slots or {
        }
    end
    local function get_welfare()
        local details = (get_cfg().details or {
        })
        return details.welfare or {
        }
    end
    local function get_state()
        local payload = npc.data_501 or {
        }
        local T_data = payload.T_data or {
        }
        T_data.main_claimed = tonumber(T_data.main_claimed or T_data.other_lb or T_data._lb or 0) or 0
        T_data.welfare_select = tonumber(T_data.welfare_select or 0) or 0
        T_data.welfare_claimed = tonumber(T_data.welfare_claimed or 0) or 0
        T_data.welfare_start = tonumber(T_data.welfare_start or 0) or 0
        payload.T_data = T_data
        return payload, T_data
    end
    local function get_server_time(payload)
        local now = tonumber(payload and payload.server_time or 0) or 0
        if now <= 0 then
            now = tonumber(SL:GetMetaValue("SERVER_TIME") or 0) or 0
        end
        return now
    end
    local function get_left_seconds(payload, T_data, idx)
        local welfare = get_welfare()
        local cfg = welfare[idx]
        if not cfg then
            return 0
        end
        local startTs = tonumber(T_data.welfare_start or 0) or 0
        if startTs <= 0 then
            return tonumber(cfg.wait_sec or 0) or 0
        end
        local now = get_server_time(payload)
        if now <= 0 then
            return tonumber(payload.wait_left or 0) or 0
        end
        return math.max(startTs + (tonumber(cfg.wait_sec or 0) or 0) - now, 0)
    end
    local function create_reward_box(parent, name, count, x, y, giftTag)
        local box = GUI:Image_Create(parent, "box_" .. tostring(x) .. "_" .. tostring(y), x, y, "res/custom/top/shochong/kuang.png")
        _add_reward_item_effect(box, "reward_eff", 25, 24, (name == "聚宝盆碎片" or name == "时装：小小裁决战士") and 0.8 or 0.9,  (name == "聚宝盆碎片" or name == "时装：小小裁决战士") and 13054 or 14192)
        -- _add_reward_item_effect(box, "reward_eff", 25, 24, 0.9, 10267)
        local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name) or 0) or 0
        local itemLayer = _get_reward_item_layer(box) or box
        if itemIndex > 0 then
            local item = GUI:ItemShow_Create(itemLayer, "item", 25, 24, {
                index = itemIndex,
                look = true,
            })
            GUI:setAnchorPoint(item, 0.5, 0.5)
            _raise_reward_item_icon(box)
        else
            local label = GUI:RichText_Create(box, "label", 25, 26, tostring(name or ""), 44, 12, "#f0c14b", 1, nil, nil)
            GUI:setAnchorPoint(label, 0.5, 0.5)
        end
        if tonumber(count or 0) > 1 then
            local num = GUI:Text_Create(itemLayer, "count", 25, 2, 12, "#FFFFFF", tostring(count))
            GUI:setAnchorPoint(num, 0.5, 0)
            GUI:Text_enableOutline(num, "#000000", 1)
            _raise_reward_count_text(num)
        end
        if giftTag then
            GUI:Image_Create(box, "tip_give", 20, 20, "res/wy/public/tip_give.png")
        end
        return box

    end
    local function create_outline_text(parent, name, x, y, size, color, text, outline)
        local label = GUI:Text_Create(parent, name, x, y, size, color, text)
        GUI:Text_enableOutline(label, outline or "#000000", 1)
        return label
    end
    local function render_main_area(node, T_data)
        local slots = get_slots()
        local startX = 387 - 100
        local itemOffset = {
            {
                -28,
                215,
            },
            {
                28,
                215,
            },
        }
        for i = 1, #slots do
            local slot = slots[i] or {
            }
            local slotX = startX + (i - 1) * 162
            local rewardList = slot.show or {
            }
            for j = 1, math.min(#rewardList, 2) do
                local pos = itemOffset[j] or {
                    0,
                    197,
                }
                create_reward_box(node, rewardList[j][1], rewardList[j][2], slotX + pos[1], pos[2])
            end
            local stateText, stateColor = "未激活", "#ff7056"
            if tonumber(T_data.main_claimed or 0) >= 1 then
                stateText = "已领取"
                stateColor = "#33ff99"
            elseif tonumber(T_data.ok or 0) == 1 then
                stateText = "可领取"
                stateColor = "#ffe07a"
            end
        end
        local show_eff = GUI:Image_Create(node, "show_eff", 150, 30, "res/wy/public/itembg.png")
        GUI:setAnchorPoint(show_eff, 0.5, 0.5)
        GUI:setContentSize(show_eff, 170, 50)
        GUI:Effect_Create(node, "reward_item_eff", 150 - 21, 30 + 10, 4, 1312, 0, 1, 3, 1)

        local btnSkin = "res/custom/top/shochong/btn_2.png"
        local mainBtn = GUI:Button_Create(node, "main_btn", 550, 80, btnSkin)
        GUI:setAnchorPoint(mainBtn, 0.5, 0.5)
        if tonumber(T_data.ok or 0) == 1 and tonumber(T_data.main_claimed or 0) < 1 then
            GUI:Button_loadTextureNormal(mainBtn, "res/wy/public/npc_19_tip_jl.png")
            -- GUI:Button_setTitleText(mainBtn, "领取奖励")
            -- GUI:Button_setTitleColor(mainBtn, "#FFF6D8")
            -- GUI:Button_setTitleFontSize(mainBtn, 20)
            -- GUI:Button_titleEnableOutline(mainBtn, "#5A1D0C", 2)
        end
        GUI:addOnClickEvent(mainBtn, function()
            if tonumber(T_data.ok or 0) ~= 1 then
                SL:SendLuaNetMsg(101, 501, 1, 0, "")
                return
            end
            if tonumber(T_data.main_claimed or 0) >= 1 then
                SL:ShowSystemTips("<font color='#FFCC66'>首充主礼包已领取</font>")
                return
            end
            SL:SendLuaNetMsg(101, 501, 1, 0, "")
        end)
    end
    local function render_welfare_area(node, payload, T_data, UI_updata)
        local welfare = get_welfare()
        local title = create_outline_text(node, "welfare_title", 636, 410, 18, "#f7dfb3", "限时福利（按顺序选择）", "#5a1d0c")
        GUI:setAnchorPoint(title, 0.5, 0.5)
        for i = 1, #welfare do
            local cfg = welfare[i] or {
            }
            local rowY = 378 - (i - 1) * 30
            local label = tostring(cfg.label or ("第" .. i .. "档"))
            local actionType = 0
            create_outline_text(node, "welfare_label_" .. i, 430, rowY, 15, "#fff3cf", string.format("%d. %s", i, label))
            if tonumber(T_data.main_claimed or 0) < 1 then
                local state = create_outline_text(node, "welfare_status_" .. i, 664, rowY, 15, "#ff7056", "请先领主礼包")
                GUI:setAnchorPoint(state, 0.5, 0.5)
            elseif tonumber(T_data.welfare_claimed or 0) >= i then
                local state = create_outline_text(node, "welfare_status_" .. i, 664, rowY, 15, "#33ff99", "已领取")
                GUI:setAnchorPoint(state, 0.5, 0.5)
            else
                local expected = (tonumber(T_data.welfare_claimed or 0) or 0) + 1
                if i ~= expected then
                    local state = create_outline_text(node, "welfare_status_" .. i, 664, rowY, 15, "#9d9d9d", "未到本档")
                    GUI:setAnchorPoint(state, 0.5, 0.5)
                elseif (tonumber(T_data.welfare_select or 0) or 0) ~= i or (tonumber(T_data.welfare_start or 0) or 0) <= 0 then
                    local state = create_outline_text(node, "welfare_status_" .. i, 664, rowY, 15, "#ffe07a", "点击选择")
                    GUI:setAnchorPoint(state, 0.5, 0.5)
                    actionType = 2
                else
                    local left = get_left_seconds(payload, T_data, i)
                    if left > 0 then
                        local prefix = create_outline_text(node, "welfare_prefix_" .. i, 624, rowY, 15, "#8fd3ff", "倒计时")
                        GUI:setAnchorPoint(prefix, 0.5, 0.5)
                        local state = create_outline_text(node, "welfare_status_" .. i, 704, rowY, 15, "#8fd3ff", _feijian_format_left_seconds(left))
                        GUI:setAnchorPoint(state, 0.5, 0.5)
                        GUI:Text_COUNTDOWN(state, left, function()
                            if npc.node and not tolua.isnull(npc.node) then
                                UI_updata(npc.node)
                            end
                        end)
                    else
                        local state = create_outline_text(node, "welfare_status_" .. i, 664, rowY, 15, "#33ff99", "可领取")
                        GUI:setAnchorPoint(state, 0.5, 0.5)
                        actionType = 3
                    end
                end
            end
            local rowBtn = GUI:Button_Create(node, "welfare_btn_" .. i, 812, rowY - 12, "res/public/bg_bti_07.png")
            GUI:setContentSize(rowBtn, 92, 24)
            GUI:Button_setTitleText(rowBtn, actionType == 3 and "领取" or (actionType == 2 and "选择" or "查看"))
            GUI:Button_setTitleColor(rowBtn, "#ffffff")
            GUI:Button_setTitleFontSize(rowBtn, 14)
            GUI:Button_titleEnableOutline(rowBtn, "#000000", 1)
            GUI:addOnClickEvent(rowBtn, function()
                if actionType == 2 then
                    SL:SendLuaNetMsg(101, 501, 2, i, "")
                elseif actionType == 3 then
                    SL:SendLuaNetMsg(101, 501, 3, i, "")
                else
                    SL:ShowSystemTips("<font color='#FFCC66'>当前档位暂不可操作</font>")
                end
            end)
        end
    end
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local payload, T_data = get_state()
        GUI:Frames_Create(node, "claim_btn", 0, 0, "res/custom/top/shochong/eff/eff_", ".png", 1, 30, {
            speed = 75,
            count = 30,
            loop = -1,
        })
        render_main_area(node, T_data)
    end
    if p2 == 0 then
        npc.data_501 = not Data and {
        } or SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        local firstChargeWin = ensureWindow("firstCharge", 501, {
            titleText = "首充礼包",
            background = {
                skin = "res/custom/top/shochong/bg1.png",
            },
            closeButton = {
                x = 878,
                y = 350,
                skin = "res/wy/public/close_red_big.png",
            },
        })
        npc.bg = firstChargeWin.bg
        npc.node = firstChargeWin.node
        UI_updata(npc.node)
    elseif p2 == 1 or p2 == 2 or p2 == 3 then
        npc.data_501 = not Data and (npc.data_501 or {
        }) or SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        if p2 == 1 and tonumber(p3 or 0) == 1 then
            NPC_UI_HELPER.closeWindow(windowCache.firstCharge)
            windowCache.firstCharge = nil
            return
        end
        if npc.node and not tolua.isnull(npc.node) then
            UI_updata(npc.node)
        end
    end
end
npc[502] = function(p2, p3, Data)
    local function create_502_item(parent, itemName, itemCount, itemKey)
        local itemNode = GUI:Image_Create(parent, "itme" .. tostring(itemKey or itemName), 0, 0, "dev/res/wy/public/40-42.png")
        
        if itemKey == 4 then
            _add_reward_item_effect(itemNode, "reward_eff", 20, 21, 0.6, 13054)
        end
        -- _add_reward_item_effect(itemNode, "reward_eff", 20, 21, 0.7, itemKey < 3 and 10266 or 10267)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        local itemLayer = _get_reward_item_layer(itemNode) or itemNode
        if tonumber(itemIndex) and tonumber(itemIndex) > 0 then
            local itemShow = GUI:ItemShow_Create(itemLayer, "item", 40 / 2, 42 / 2, {
                index = itemIndex,
                look = true,
            })
            GUI:setScale(itemShow,0.8)
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
            _raise_reward_item_icon(itemNode)
            
        end
        if tonumber(itemCount or 0) > 1 then
            local countText = GUI:Text_Create(itemLayer, "count", 40 / 2, 5, 13, "#FFFFFF", SL:GetSimpleNumber(itemCount, 0))
            GUI:setAnchorPoint(countText, 0.5, 0.5)
            _raise_reward_count_text(countText)
        end
        return itemNode
    end
    local function get_502_show_list(cfg)
        if type(cfg) ~= "table" then
            return {
            }
        end
        local list = {
        }
        for _, item in ipairs(cfg.give or {
        }) do
            list[#list + 1] = {
                item[1],
                item[2],
            }
        end
        if cfg.ch then
            list[#list + 1] = {
                cfg.ch .. "[称号]",
                1,
            }
        end
        if cfg.skill then
            list[#list + 1] = {
                cfg.skill,
                1,
            }
        end
        if type(cfg.show) == "table" and #cfg.show > 0 then
            for _, item in ipairs(cfg.show) do
                list[#list + 1] = {
                    item[1],
                    item[2],
                }
            end
        end
        if tonumber(cfg.token_count or 0) and tonumber(cfg.token_count or 0) > 0 and not (type(cfg.show) == "table" and #cfg.show > 0 and tostring((cfg.show[1] or {})[1] or "") == (((teshudata["npc_101"] or {}).token_name) or "鹤嘴锄")) then
            local tokenName = ((teshudata["npc_101"] or {
            }).token_name) or "鹤嘴锄"
            list[#list + 1] = {
                tokenName,
                tonumber(cfg.token_count or 0),
            }
        end
        return list
    end
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local guideAmount = tonumber(npc._onlineRechargeGuideAmount or 0) or 0
        local guideButton = nil
        local Input = GUI:TextInput_Create(node, "Input", 180.0 + 324, 50.0 + 363, 50.0, 20.0, 13)
        GUI:TextInput_setPlaceHolder(Input, "最少10")
        GUI:setTouchEnabled(Input, true)
        local num = GUI:Text_Create(node, "num", 180.0 + 324 + 30, 80.0 + 363, 20, "#FFFFFF", SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "累计充值")))
        GUI:setAnchorPoint(num, 0.5, 0.5)
        num = GUI:TextAtlas_Create(npc.bg, "num1", 690, 30, SL:GetThousandSepString(SL:GetMetaValue("TMONEY", "真充积分")), "res/custom/public/text1.png", 14, 30, ".")
        GUI:setAnchorPoint(num, 0, 0.5)
        local cz_an = GUI:Button_Create(node, "cz_an", 300 + 274, 38 + 350, "res/custom/chongzhi/btn.png")
        GUI:addOnClickEvent(cz_an, function()
            local msg = tonumber(GUI:TextInput_getString(Input))
            if msg then
                SL:SendLuaNetMsg(101, 502, 0, 3, msg)
            end
        end)
        for i = 1, 3 do
            GUI:Image_Create(node, "way_" .. i, 180 + (i - 1) * 30, 38 + 350 + 32, "res/custom/chongzhi/way_" .. i .. ".png")
        end
        local rechargeList = (teshudata["anniu_502"] and teshudata["anniu_502"].fj) or {
        }
        local rechargeRows = math.max(2, math.ceil(#rechargeList / 4))
        local ScrollView = GUI:ScrollView_Create(node, "ScrollView", 30, 50, 720, 350, 1)
        GUI:ScrollView_setInnerContainerSize(ScrollView, 720, 185 + (234 * rechargeRows))
        local dbLayout = GUI:Layout_Create(ScrollView, "dbLayout", 0, 185, 108 * 4, (234 * rechargeRows))
        for i = 1, #rechargeList do
            local rechargeAmount = rechargeList[i]
            local Button = GUI:Image_Create(dbLayout, "img_lf" .. i, 0, 0, "res/custom/chongzhi/" .. rechargeAmount .. ".png")
            GUI:setTouchEnabled(Button, true)
            if guideAmount > 0 and tonumber(rechargeAmount) == guideAmount then
                guideButton = Button
            end
            if npc.data_502["cz502_" .. rechargeAmount] and npc.data_502["cz502_" .. rechargeAmount] == 1 then
            else
                GUI:Image_Create(Button, "double", 100, 100, "res/custom/chongzhi/double.png")
                local list = GUI:Layout_Create(Button, "list", 10, 35, 40 * 4, 42)
                local rewardList = get_502_show_list(teshudata["anniu_502"].jl[i])
                for j = 1, math.min(#rewardList, 4) do
                    create_502_item(list, rewardList[j][1], rewardList[j][2], j)
                end
                GUI:UserUILayout(list, {
                    dir = 3,
                    addDir = 1,
                    colnum = 4,
                    gap = {
                        x = 0,
                        y = 0,
                    },
                })
            end
            GUI:addOnClickEvent(Button, function()
                SL:SendLuaNetMsg(101, 502, 0, 2, rechargeAmount)
            end)
        end
        GUI:UserUILayout(dbLayout, {
            dir = 3,
            addDir = 1,
            colnum = 4,
            gap = {
                x = 0,
                y = 0,
            },
        })
        GUI:Image_Create(ScrollView, "k_1", 0, 0, "res/custom/chongzhi/k_1.png")
        if guideButton then
            npc._onlineRechargeGuideAmount = nil
            SL:ScheduleOnce(function()
                if guideButton and not tolua.isnull(guideButton) then
                    NPC_UI_HELPER.startGuide({
                        dir = 1,
                        guideWidget = guideButton,
                        guideParent = dbLayout,
                        guideDesc = "点击10元档位获取筑基丹",
                        isForce = false,
                        hideMask = false,
                    })
                end
            end, 0.1)
        end
    end
    if p2 == 0 or p2 == 8 then
        if p2 == 8 then
            npc._onlineRechargeGuideAmount = tonumber(p3) or 10
        end
        npc.data_502 = not Data and {
        } or SL:JsonDecode(Data, false)
        local rechargeWin = ensureWindow("onlineRecharge", 502, {
            titleText = "在线充值",
        })
        npc.bg = rechargeWin.bg
        npc.node = rechargeWin.node
        UI_updata(npc.node)
    elseif p2 == 1 then
        npc.data_502 = not Data and {
        } or SL:JsonDecode(Data, false)
        UI_updata(npc.node)
    end
end
npc[999] = function(p2, p3, Data)
    local parent = GUI:GetWindow(nil, "npc_czxz")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_czxz", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    GUI:setTouchEnabled(bjt, true)
    GUI:addOnClickEvent(bjt, function()
        GUI:Win_Close(parent)
    end)
    local bg = GUI:Image_Create(parent, "img_bj", 0.0, 0.0, "res/wy/public/anniu_999_bj.png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:setTouchEnabled(bg, true)
    GUI:Timeline_Window3(bg)
    local close = GUI:Button_Create(bg, 'close', 585, 290, 'res/wy/public/20.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    GUI:Image_Create(bg, "wz1", 160.0, 250.0, "res/wy/public/anniu_999_wz1.png")
    GUI:Image_Create(bg, "wz2", 160.0, 91.0, "res/wy/public/anniu_999_wz2.png")
    local txt = GUI:Text_Create(bg, "txt", 380.0, 91.0, 20, "#ffffff", p2)
    local Button = {
    }
    for i = 1, 3, 1 do
        Button[i] = GUI:Button_Create(bg, "Button_" .. i, 90 + (i - 1) * 160, 155.0, "res/wy/public/cz_" .. i .. "1.png")
        GUI:addOnClickEvent(Button[i], function()
            if Data == "1" then
                SL:RequestPay(i, p3, p2, 0)
            else
                SL:RequestPay(i, p3, p2, 0)
            end
            SL:SendLuaNetMsg(101, 502, i, 1, "")
        end)
    end
end
npc[504] = function(p2, p3, Data)
    local function create_reward_box(parent, itemName, itemCount, x, y, giftTag)
        local box = GUI:Image_Create(parent, "reward_box_" .. tostring(x) .. "_" .. tostring(y), x, y, "res/custom/top/shochong/kuang.png")
        _add_reward_item_effect(box, "reward_eff", 25, 24, 0.8, 13054)
        local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName) or 0) or 0
        local itemLayer = _get_reward_item_layer(box) or box
        if itemIndex > 0 then
            local item = GUI:ItemShow_Create(itemLayer, "item", 25, 24, {
                index = itemIndex,
                look = true,
            })
            GUI:setAnchorPoint(item, 0.5, 0.5)
            _raise_reward_item_icon(box)
        else
            local label = GUI:RichText_Create(box, "label", 25, 26, tostring(itemName or ""), 44, 11, "#f0c14b", 1, nil, nil)
            GUI:setAnchorPoint(label, 0.5, 0.5)
        end
        if tonumber(itemCount or 0) > 1 then
            local num = GUI:Text_Create(itemLayer, "num", 25, 2, 12, "#ffffff", tostring(itemCount))
            GUI:setAnchorPoint(num, 0.5, 0)
            GUI:Text_enableOutline(num, "#000000", 1)
            _raise_reward_count_text(num)
        end
        if giftTag then
            
            GUI:setLocalZOrder(GUI:Image_Create(box, "tip_give", 20, 20, "res/wy/public/tip_give.png"), 99)
        end
    end
    local function set_text_style(label, outline)
        GUI:Text_enableOutline(label, outline or "#000000", 1)
    end
    if p2 == 0 then
        npc.kryb = SL:JsonDecode(Data, false)
        rebuildShortcutButtons("")
        local parent = GUI:GetWindow(nil, "npc_sclb")
        if parent then
            GUI:removeAllChildren(parent)
            GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
        else
            parent = GUI:Win_Create("npc_sclb", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
        end
        local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
        GUI:setAnchorPoint(bjt, 0.5, 0.5)
        GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
        GUI:setTouchEnabled(bjt, true)
        GUI:addOnClickEvent(bjt, function()
            GUI:Win_Close(parent)
        end)
        npc.bg = GUI:Frames_Create(parent, "bg", 0, 0, "res/wy/eff/city/gm_bj", ".png", 1, 60, {
            speed = 50,
            count = 60,
            loop = -1,
        })
        GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
        GUI:setTouchEnabled(npc.bg, true)
        npc.node = GUI:Node_Create(npc.bg, "node", 0, 0)
        GUI:Image_Create(npc.node, "img_6", 542, 138, "res/custom/top/kryb/img_6.png")
        GUI:Image_Create(npc.node, "tit", 100, 350, "res/custom/top/kryb/tit.png")
        GUI:Image_Create(npc.node, "wz1", 150, 0, "res/custom/top/kryb/wz1.png")
        local close = GUI:Button_Create(npc.bg, 'close', 850, 450, 'res/wy/public/close.png')
        GUI:addOnClickEvent(close, function()
            GUI:Win_Close(parent)
        end)
        local rewardList = (teshudata["anniu_504"] and teshudata["anniu_504"].show) or {
        }
        local startX = 110
        local startY = 132 + 60 + 10
        local stepX = 92
        local stepY = 88
        for i = 1, #rewardList do
            local item = rewardList[i]
            local x = startX + (i - 1) * stepX
            create_reward_box(npc.node, item[1], item[2], x, startY, tostring(item[1] or "") == "灵石")
        end
        if tonumber(npc.kryb.mztq or 0) == 0 then
            local btn = GUI:Button_Create(npc.node, "buy_btn", 100, 44, "res/custom/top/kryb/btn.png")
            GUI:addOnClickEvent(btn, function()
                SL:SendLuaNetMsg(101, 504, 1, 0, "")
            end)
        else
            GUI:Image_Create(npc.node, "done", 170, 44, "res/wy/public/6.png")
        end
    end
end
local guaji_ms = {
    "挂机时被攻击 自动随机传送（30秒冷却）",
    "挂机时未击杀 切换地图（120秒触发）",
    "挂机死亡或者回城后60秒随机下图",
    "每10分钟自动切换地图",
}
npc._patrolRefs = npc._patrolRefs or {
}
local patrolRefs = npc._patrolRefs
npc[505] = function(p2, p3, Data)
    local function buildPatrolUI(data)
        local win = ensureWindow("patrol", 505, {
            titleText = "自动巡航",
        })
        local panel = win.node
        GUI:setPosition(panel, 150, 50)
        local patrolOpen = _shortcut_is_firstcharge_completed()
        npc.ksgj = GUI:Button_Create(panel, "ksgj", 439.0 - 130, 22.0, "res/public/1900000660.png")
        GUI:Button_setTitleText(npc.ksgj, data.gjkg and "停止挂机" or "开始挂机")
        GUI:Button_setTitleColor(npc.ksgj, "#ffffff")
        GUI:Button_setTitleFontSize(npc.ksgj, 14)
        GUI:Button_titleEnableOutline(npc.ksgj, "#000000", 1)
        GUI:addOnClickEvent(npc.ksgj, function()
            if not patrolOpen then
                SL:ShowSystemTips("<font color='#FF6666'>需要先领取首充礼包</font>")
                return
            end
            SL:SendLuaNetMsg(101, 505, 4, 0, "")
        end)
        -- 巡航界面标题与提示统一使用“自动巡航”文案，和当前首充解锁规则保持一致。
        local unlockText = patrolOpen and "已解锁：领取首充礼包后激活自动巡航/传送3秒CD" or "解锁条件：领取首充礼包"
        local unlockColor = patrolOpen and "#33ff99" or "#ff7056"
        local tip = GUI:Text_Create(panel, "patrol_unlock_tip", 309 - 214, 420, 16, unlockColor, unlockText)
        GUI:Text_enableOutline(tip, "#000000", 1)
        local listView = GUI:ListView_Create(panel, "ListView", 26.0 - 134, 22.0 - 57, 300.0, 445.0, 1)
        GUI:ListView_setGravity(listView, 5)
        GUI:ListView_setItemsMargin(listView, 10)
        npc.fu_gx = {
        }
        npc.dtwb = {
        }
        for i = 1, 10 do
            local btn = GUI:Button_Create(listView, "Button" .. i, 0.0, 0.0, "res/public/bg_bti_07.png")
            GUI:setContentSize(btn, 300, 50)
            local check = GUI:CheckBox_Create(btn, "fu_gx" .. i, 4.0, 0, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(check, data["fgx" .. i])
            GUI:addOnClickEvent(btn, function()
                if not patrolOpen then
                    SL:ShowSystemTips("<font color='#FF6666'>需要先领取首充礼包</font>")
                    return
                end
                SL:SendLuaNetMsg(101, 505, 2, i, "")
            end)
            GUI:CheckBox_addOnEvent(check, function()
                if not patrolOpen then
                    GUI:CheckBox_setSelected(check, false)
                    SL:ShowSystemTips("<font color='#FF6666'>需要先领取首充礼包</font>")
                    return
                end
                SL:SendLuaNetMsg(101, 505, 3, i, "")
            end)
            npc.fu_gx[i] = check
            npc.dtwb[i] = GUI:Text_Create(check, "dtmz" .. i, 50.0, 15.0, 16, "#ffffff", "当前记录地图：" .. (data["dt" .. i] or "点击记录"))
        end
        for i, label in ipairs(guaji_ms) do
            local toggle = GUI:CheckBox_Create(panel, "zhu_gx" .. i, 345.0 - 130, 340 - (i - 1) * 80, "res/public/btn_sifud_04.png", "res/public/btn_sifud_05.png")
            GUI:CheckBox_setSelected(toggle, data["zgx" .. (i == 3 and 4 or i == 4 and 5 or i)])
            GUI:Text_Create(toggle, "Text", 48.0, 15.0, 16, "#ffffff", label)
            GUI:CheckBox_addOnEvent(toggle, function()
                if not patrolOpen then
                    GUI:CheckBox_setSelected(toggle, false)
                    SL:ShowSystemTips("<font color='#FF6666'>需要先领取首充礼包</font>")
                    return
                end
                SL:SendLuaNetMsg(101, 505, 5, i == 3 and 4 or i == 4 and 5 or i, "")
            end)
        end
    end
    if p2 == 1 then
        npc.data = SL:JsonDecode(Data, false)
        buildPatrolUI(npc.data)
    elseif p2 == 2 then
        if npc.dtwb and npc.dtwb[p3] then
            GUI:Text_setString(npc.dtwb[p3], "当前记录地图：" .. (Data or ""))
        end
    elseif p2 == 3 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.fu_gx and npc.fu_gx[p3] then
            GUI:CheckBox_setSelected(npc.fu_gx[p3], npc.data["fgx" .. p3])
        end
    elseif p2 == 4 then
        npc.data = SL:JsonDecode(Data, false)
        if npc.ksgj then
            GUI:Button_setTitleText(npc.ksgj, npc.data.gjkg and "停止挂机" or "开始挂机")
        end
    end
end
npc[506] = function(p2, p3, Data)
    local function renderChosenUI(payload)
        local win = ensureWindow("chosen", 506, {
            titleText = "天选之人",
        })
        npc.bg = win.bg
        npc.node = win.node
        GUI:removeAllChildren(npc.node)
        local bg = npc.bg
        local Node = GUI:Node_Create(bg, "Node", 0, 0)
        local function updatePage(dq)
            for i = 1, 10 do
                local name = (payload.A_txzz and payload.A_txzz["md" .. dq] and payload.A_txzz["md" .. dq][i] and payload.A_txzz["md" .. dq][i][1]) or "未开奖"
                local value = (payload.A_txzz and payload.A_txzz["md" .. dq] and payload.A_txzz["md" .. dq][i] and payload.A_txzz["md" .. dq][i][2]) or "0"
                local nameLabel = GUI:ScrollText_Create(Node, "name" .. dq .. "" .. i, 600 - 474 + ((dq - 1) * 185), 360 - 70 - (i - 1) * 20, 90, 12, "#E317B3", name, 10, nil)
                GUI:setAnchorPoint(nameLabel, 0.5, 0.5)
                local valLabel = GUI:Text_Create(Node, "value" .. dq .. "" .. i, 760 - 562 + ((dq - 1) * 185), 360 - 70 - (i - 1) * 20, 12, "#E317B3", value)
                GUI:setAnchorPoint(valLabel, 0.5, 0.5)
                GUI:Text_enableOutline(valLabel, "#000000", 1)
            end
        end
        updatePage(1)
        updatePage(2)
        updatePage(3)
        updatePage(4)
        GUI:setPosition(ItemNumByTable_img_new({
            {
                "天选之子",
                1,
            },
            {
                "光速起步",
                1,
            },
            {
                "策划的手机",
                1,
            },
            {
                "技术的电脑",
                1,
            },
        }, nil, GUI:Node_Create(Node, "jl_show", 0, 0)), 400 + 111, 110 + 112 + 147)
    end
    if p3 == 0 then
        npc.txzz_data = not Data and {
        } or SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    elseif p3 == 1 and npc.txzz_data then
        npc.txzz_data = SL:JsonDecode(Data, false)
        renderChosenUI(npc.txzz_data)
    end
end
npc[507] = function(p2, p3, Data)
    local activity_cfg = teshudata["anniu_507"] or {
    }
    local function richText(label, name, x, y, width, size, html)
        local rich = GUI:RichText_Create(label, name, x, y, html, width, size, "#f7f7de", 0, nil, nil, {
            outlineSize = 2,
            outlineColor = SL:ConvertColorFromHexString("#100808"),
        })
        GUI:setAnchorPoint(rich, 0, 1)
        return rich
    end
    local function makeRewardText(items)
        if type(items) ~= "table" or #items <= 0 then
            return "奖励以活动实际结算为准"
        end
        local parts = {
        }
        for _, one in ipairs(items) do
            local name = one[1] or one.item or ""
            local count = tonumber(one[2] or one.count or 0) or 0
            if name ~= "" then
                if count > 1 then
                    parts[#parts + 1] = tostring(name) .. "x" .. tostring(count)
                else
                    parts[#parts + 1] = tostring(name)
                end
            end
        end
        if #parts <= 0 then
            return "奖励以活动实际结算为准"
        end
        return table.concat(parts, "、")
    end
    local function rewardCount(v)
        if type(v) == "table" then
            return tonumber(v[2] or v.max or v[1] or v.min or 1) or 1
        end
        return tonumber(v or 1) or 1
    end
    local function appendRewardItem(out, seen, name, count)
        name = tostring(name or "")
        if name == "" then
            return
        end
        count = rewardCount(count)
        if count <= 0 then
            count = 1
        end
        local pos = seen[name]
        if pos then
            out[pos][2] = math.max(rewardCount(out[pos][2]), count)
            return
        end
        seen[name] = #out + 1
        out[#out + 1] = {
            name,
            count,
        }
    end
    local function appendRewardList(out, seen, list)
        if type(list) ~= "table" then
            return
        end
        for _, one in ipairs(list) do
            if type(one) == "table" then
                appendRewardItem(out, seen, one[1] or one.item or one.name, one[2] or one.count or 1)
            end
        end
    end
    local function appendRankRewards(out, seen, rewards)
        if type(rewards) ~= "table" then
            return
        end
        for _, one in ipairs(rewards) do
            appendRewardList(out, seen, one and one.items)
        end
    end
    local function appendHdjdRewards(out, seen, rewards)
        if type(rewards) ~= "table" then
            return
        end
        for _, one in ipairs(rewards) do
            appendRewardList(out, seen, one and one.give)
            if type(one) == "table" and type(one.random_one) == "table" then
                for _, group in ipairs(one.random_one) do
                    appendRewardList(out, seen, group)
                end
            end
        end
    end
    local function appendSjdbRewards(out, seen, circles)
        if type(circles) ~= "table" then
            return
        end
        for _, circle in ipairs(circles) do
            if type(circle) == "table" and type(circle.drops) == "table" then
                for _, drop in ipairs(circle.drops) do
                    if type(drop) == "table" then
                        appendRewardItem(out, seen, drop.item, drop.count)
                    end
                end
            end
        end
    end
    local function appendNamedRewards(out, seen, names)
        if type(names) ~= "table" then
            return
        end
        for _, name in ipairs(names) do
            appendRewardItem(out, seen, name, 1)
        end
    end
    local function buildRewardItems(...)
        local out = {
        }
        local seen = {
        }
        local args = {
            ...
        }
        for _, fn in ipairs(args) do
            if type(fn) == "function" then
                fn(out, seen)
            end
        end
        return out
    end
    local function getRewardItemIndex(item)
        if type(item) ~= "table" then
            return 0
        end
        return tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", item[1])) or 0
    end
    local function isRewardEquip(item)
        local itemIndex = getRewardItemIndex(item)
        if itemIndex <= 0 then
            return false
        end
        local itemData = SL:GetMetaValue("ITEM_DATA", itemIndex)
        if type(itemData) ~= "table" then
            return false
        end
        local itemTypeEnum = SL:GetMetaValue("ITEMTYPE_ENUM") or {}
        return SL:GetMetaValue("ITEMTYPE", itemData) == itemTypeEnum.Equip
    end
    local function sortRewardItems(items)
        local equips = {
        }
        local others = {
        }
        for _, item in ipairs(items or {}) do
            if isRewardEquip(item) then
                equips[#equips + 1] = item
            else
                others[#others + 1] = item
            end
        end
        local sorted = {
        }
        for _, item in ipairs(equips) do
            sorted[#sorted + 1] = item
        end
        for _, item in ipairs(others) do
            sorted[#sorted + 1] = item
        end
        return sorted
    end
    local function renderRewardItems(label, cfg)
        local items = sortRewardItems(cfg and cfg.rewardItems or {})
        if #items <= 0 then
            return
        end
        local root = GUI:Node_Create(label, "reward_items", 82, 52 - 23)
        local maxPerRow = 6
        local gapX = 66
        local gapY = 62
        for idx, item in ipairs(items) do
            if idx > 4 then
                break
            end
            local row = math.floor((idx - 1) / maxPerRow)
            local col = (idx - 1) % maxPerRow
            local slot = GUI:Image_Create(root, "slot_" .. idx, col * gapX, -row * gapY, "res/wy/public/58-60.png")
            _add_reward_item_effect(slot, "activity_reward_eff", 29, 30, 0.85, REWARD_ITEM_EFFECT_14193)
            local itemIndex = getRewardItemIndex(item)
            local itemLayer = _get_reward_item_layer(slot) or slot
            if itemIndex > 0 then
                local itemShow = GUI:ItemShow_Create(itemLayer, "item", 29, 30, {
                    index = itemIndex,
                    count = 1,
                    look = true,
                })
                GUI:setAnchorPoint(itemShow, 0.5, 0.5)
                _raise_reward_item_icon(slot)
            end
        end
    end
    local function getActivityDisplayCfg(i)
        local qmdt = activity_cfg.qmdt or {
        }
        local qmdk = activity_cfg.qmdk or {
        }
        local hdjd = activity_cfg.hdjd or {
        }
        local bwcz = activity_cfg.bwcz or {
        }
        local mskh = activity_cfg.mskh or {
        }
        local sjdb = activity_cfg.sjdb or {
        }
        local sbk = teshudata["sbk"] or {
        }
        local txzr = teshudata["anniu_506"] or {
        }
        local qmdtState = (npc.data_507 and npc.data_507.qmdt) or {
        }
        local qmdkState = (npc.data_507 and npc.data_507.qmdk) or {
        }
        local detailCfg = nil
        for _, one in ipairs(activity_cfg.details or {
        }) do
            if tonumber(one.idx) == tonumber(i) then
                detailCfg = one
                break
            end
        end
        local cfg = {
            title = detailCfg and detailCfg.name or ("活动" .. tostring(i)),
            time = "活动时间请关注游戏内公告",
            desc = "活动开启后可通过当前入口参与，主要看玩法流程与规则。",
            reward = "奖励以活动实际结算为准",
            rewardItems = {
            },
            btnSkin = "res/custom/activity/btn.png",
        }
        if i == 1 then
            local open = tonumber((((npc.data_507 or {}).open_state or {})[1]) or 0) or 0
            local myData = (npc.data_507 and npc.data_507.bwcz) or {}
            cfg.title = "保卫村庄"
            cfg.time = string.format("每日%02d:%02d开启，持续%s分钟", tonumber(bwcz.start_hour or 18) or 18, tonumber(bwcz.start_minute_clock or 0) or 0, tostring(bwcz.duration_min or 30))
            if open == 1 then
                cfg.time = cfg.time .. "\n当前活动进行中，可直接点击参与"
            end
            cfg.desc = string.format("进入【%s】后守住村庄并清理来袭怪物，核心是持续清怪和争取更高表现。", tostring(bwcz.display_map or bwcz.map or "村庄"))
            cfg.reward = "击杀奖励：金币18W、金币88W、元宝5W；前三名达到镇境武侯可得50元真实充值"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                local killReward = bwcz.kill_reward or {}
                appendRewardList(out, seen, killReward.small)
                appendRewardList(out, seen, killReward.elite)
                appendRewardList(out, seen, killReward.boss)
                appendRankRewards(out, seen, bwcz.rank_rewards)
            end)
        elseif i == 2 then
            cfg.title = "全民夺矿"
            cfg.time = string.format("每日%02d:%02d开启，持续%s分钟", tonumber(qmdk.start_hour or 19) or 19, tonumber(qmdk.start_minute_clock or 0) or 0, tostring(qmdk.duration_min or 20))
            cfg.desc = string.format("进入【%s】争夺矿区，重点是占点、守点和阻止对手持续得分。", tostring(qmdk.map or "全民夺矿"))
            cfg.reward = "参与奖励：" .. makeRewardText(qmdk.join_reward)
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendRewardList(out, seen, qmdk.join_reward)
                appendRankRewards(out, seen, qmdk.rank_rewards)
            end)
        elseif i == 3 then
            local open = tonumber(qmdtState.open or 0) or 0
            local currentIdx = tonumber(qmdtState.current_idx or 0) or 0
            local remain = tonumber(qmdtState.limit_sec or 0) or 0
            cfg.title = "全民答题"
            cfg.time = string.format("开服第%s分钟开启，持续%s分钟；共%s题，每题%s秒", tostring(qmdt.start_minute or 33), tostring(qmdt.duration_min or 5), tostring(qmdt.question_count or 5), tostring(qmdt.per_question_sec or 60))
            cfg.desc = "活动开启后参与答题，按题目顺序作答，考验反应和判断。"
            cfg.reward = "参与奖励：" .. makeRewardText(qmdt.join_reward)
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendRewardList(out, seen, qmdt.join_reward)
                appendRankRewards(out, seen, qmdt.rank_rewards)
            end)
        elseif i == 4 then
            cfg.title = "勇夺镖车"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "围绕镖车进行护送或争夺，重点是路线把控、拦截和护送。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 5 then
            cfg.title = "土城跑酷"
            cfg.time = "活动入口直达土城地图，具体开启时段以游戏公告为准"
            cfg.desc = "进入跑酷地图后按路线前进，主要比走位、反应和路线熟悉度。"
            cfg.reward = "奖励丰厚"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendNamedRewards(out, seen, {
                    "10W经验卷",
                    "20W经验卷",
                    "50W经验卷",
                    "元宝[5000]",
                    "元宝[10000]",
                    "1元真实充值",
                    "冥海圣刃",
                    "冥海圣武甲",
                    "苍月圣狂斩",
                    "苍月圣魂甲",
                    "龙魂吊坠",
                    "王权圣戒",
                })
            end)
        elseif i == 6 then
            local open = tonumber((((npc.data_507 or {}).open_state or {})[6]) or 0) or 0
            local myData = (npc.data_507 and npc.data_507.mskh) or {}
            cfg.title = "美食狂欢"
            cfg.time = string.format("每日%02d:%02d开启，持续%s分钟", tonumber(mskh.start_hour or 16) or 16, tonumber(mskh.start_minute_clock or 0) or 0, tostring(mskh.duration_min or 30))
            if open == 1 then
                cfg.time = cfg.time .. "\n当前活动进行中，可直接点击参与"
            end
            cfg.desc = string.format("进入【%s】击杀并收集肉类，利用收集与兑换推进活动进度。", tostring(mskh.map or "美食狂欢"))
            cfg.reward = "鸡肉=1积分，羊肉=5积分，鹿肉=10积分；可在屠夫处兑换美食家、时光之杖、时光鉴定石"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                local shop = mskh.shop or {}
                for _, one in ipairs(shop) do
                    if type(one) == "table" and type(one.reward) == "table" then
                        if one.reward.kind == "item" then
                            appendRewardList(out, seen, one.reward.give)
                        elseif one.reward.kind == "title" then
                            appendRewardItem(out, seen, tostring(one.reward.name or "") .. "[称号]", 1)
                        end
                    end
                end
            end)
        elseif i == 7 then
            cfg.title = "天选之人"
            cfg.time = tostring((txzr.notice and txzr.notice[1]) or "30分钟一轮，共四轮")
            local txzrState = (npc.data_507 or {}).txzr or {}
            local txzrMinute = tonumber(txzrState.minute or 0) or 0
            local txzrRound = tonumber(txzrState.round or 0) or 0
            local txzrOpen = tonumber(txzrState.open or 0) or 0
            if txzrOpen == 1 or (txzrRound < 4 and txzrMinute > 0 and txzrMinute < 30) then
                cfg.time = cfg.time .. "\n当前活动进行中，可直接点击参与"
            end
            cfg.desc = "活动按轮次进行幸运比拼，参与玩家随机点数排名，每轮点数最高者获得奖励。"
            cfg.reward = "查看具体页面可以预览奖励"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                for rewardIdx = 1, 10 do
                    appendRewardItem(out, seen, txzr[rewardIdx], 1)
                end
                local joinReward = txzr.join_reward or {}
                appendRewardItem(out, seen, joinReward.item, joinReward.count)
                for _, one in ipairs(txzr.shenqi or {}) do
                    appendRewardItem(out, seen, one and one.name, 1)
                end
            end)
        elseif i == 8 then
            cfg.title = "正邪大战"
            local open = tonumber((((npc.data_507 or {}).open_state or {})[8]) or 0) or 0
            cfg.time = "每日22:00开启，持续10分钟"
            if open == 1 then
                cfg.time = cfg.time .. "\n当前活动进行中，可直接点击参与"
            end
            cfg.desc = "进入地图后自动分阵营，围绕对抗、击杀和阵营胜负展开。"
            cfg.reward = "个人前三：跨服积分30/20/15；胜利方：跨服积分50；失败方：跨服积分20"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendRewardItem(out, seen, "跨服积分", 30)
            end)
        elseif i == 9 then
            cfg.title = "武林盟主"
            cfg.time = "开服第25分钟开启，持续5分钟"
            cfg.desc = "进入【比武大会】自由混战，尽量击败对手并活到最后。"
            cfg.reward = "胜者可获得盟主荣誉与活动结算奖励"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendRewardItem(out, seen, "绑定元宝", 380000)
                appendRewardItem(out, seen, "1元真实充值", 38)
                appendRewardItem(out, seen, "武林盟主[称号]", 1)
            end)
        elseif i == 10 then
            local open = tonumber((((npc.data_507 or {}).open_state or {})[10]) or 0) or 0
            cfg.title = "武道大会"
            cfg.time = "每周一至周五20:00-22:00开启；周日24:00结算排行"
            if open == 1 then
                cfg.time = cfg.time .. "\n当前活动进行中，可进入跨服报名匹配"
            end
            cfg.desc = "跨服1V1匹配玩法，报名后进行单挑对决，拼操作和对局节奏。"
            cfg.reward = "周排行奖励：第1名100跨服积分，第2名80，第3名70，第4名60，第5名50，第6名40，第7名30，第8名25，第9名20，第10名15，10名后10"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendRewardItem(out, seen, "跨服积分", 100)
            end)
        elseif i == 11 then
            cfg.title = "沙巴克"
            cfg.time = "请通过沙巴克专属入口参与攻城"
            cfg.desc = "大型行会攻城玩法，围绕皇宫和据点展开攻防对抗。"
            cfg.reward = "行会奖励"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                local rewardItemName = tostring(sbk.money or "绑定灵符")
                rewardItemName = string.gsub(rewardItemName, "#.*$", "")
                local winReward = tonumber(sbk.kf_winReward or sbk.winReward or 10000) or 10000
                local loserReward = tonumber(sbk.kf_loserReward or sbk.loserReward or 3000) or 3000
                appendRewardItem(out, seen, rewardItemName, math.max(winReward, loserReward))
                appendRewardItem(out, seen, "沙巴克城主[称号]", 1)
                appendRewardItem(out, seen, "沙巴克[称号]", 1)
            end)
        elseif i == 12 then
            cfg.title = "讨伐BOSS"
            cfg.time = "当前暂未开放，开放后可通过本页直接参与"
            cfg.desc = "活动开启后投放特殊首领，重点是集火输出和争夺归属。"
            cfg.reward = "开放后公布活动奖励"
        elseif i == 13 then
            cfg.title = "随机夺宝"
            cfg.time = string.format("开服第15分钟开启，在【%s】地图持续%s秒投放宝物", tostring(sjdb.map or "天降财宝"), tostring(sjdb.keep_sec or 300))
            cfg.desc = string.format("活动会在【%s】持续投放宝物，核心是寻找、争抢和走位。", tostring(sjdb.map or "天降财宝"))
            cfg.reward = "随机夺宝"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendSjdbRewards(out, seen, sjdb.circles)
            end)
        elseif i == 14 then
            cfg.title = "黑暗禁地"
            cfg.time = string.format("每日%02d:%02d开启，持续%s分钟", tonumber(hdjd.start_hour or 19) or 19, tonumber(hdjd.start_minute_clock or 30) or 30, tostring(hdjd.duration_min or 20))
            cfg.desc = string.format("进入【%s】寻找随机刷新目标并完成采集，考验找图和路线判断。", tostring(hdjd.map or "黑暗禁地"))
            cfg.reward = "金币*38W、元宝*2000-8000、1元真实充值*1、五行石/杀伐神石[小]/千年玄铁随机其一"
            cfg.rewardItems = buildRewardItems(function(out, seen)
                appendHdjdRewards(out, seen, hdjd.rewards)
            end)
        end
        return cfg
    end
    local ACTIVITY_STATUS_OPEN = 1
    local ACTIVITY_STATUS_WAIT = 2
    local ACTIVITY_STATUS_END = 3
    local function getTxzrRuntimeState()
        local txzrState = (npc.data_507 or {}).txzr or {}
        local minute = tonumber(txzrState.minute or 0) or 0
        local round = tonumber(txzrState.round or 0) or 0
        local open = tonumber(txzrState.open or 0) or 0
        return minute, round, open
    end
    local function activityIsOpen(i)
        i = tonumber(i) or 0
        if i == 7 then
            local minute, round, open = getTxzrRuntimeState()
            if open == 1 or (round < 4 and minute > 0 and minute < 30) then
                return true
            end
        end
        return tonumber((((npc.data_507 or {}).open_state or {})[i]) or 0) == 1
    end
    local function getServerMinute()
        local nowMinute = tonumber((npc.data_507 or {}).now_minute)
        if nowMinute and nowMinute >= 0 then
            return nowMinute
        end
        return nil
    end
    local function statusByDayTime(startHour, startMinute, durationMin)
        local nowMinute = getServerMinute()
        if not nowMinute then
            return ACTIVITY_STATUS_WAIT
        end
        local startAt = (tonumber(startHour) or 0) * 60 + (tonumber(startMinute) or 0)
        local finishAt = startAt + math.max(1, tonumber(durationMin) or 1)
        if nowMinute < startAt then
            return ACTIVITY_STATUS_WAIT
        end
        if nowMinute >= finishAt then
            return ACTIVITY_STATUS_END
        end
        return ACTIVITY_STATUS_OPEN
    end
    local function statusByOpenMinute(startMinute, durationMin)
        local kqfz = tonumber((npc.data_507 or {}).kqfz or 0) or 0
        local startAt = tonumber(startMinute) or 0
        local finishAt = startAt + math.max(1, tonumber(durationMin) or 1)
        if kqfz < startAt then
            return ACTIVITY_STATUS_WAIT
        end
        if kqfz >= finishAt then
            return ACTIVITY_STATUS_END
        end
        return ACTIVITY_STATUS_OPEN
    end
    local function getActivityStatus(i)
        i = tonumber(i) or 0
        if activityIsOpen(i) then
            return ACTIVITY_STATUS_OPEN
        end
        local qmdt = activity_cfg.qmdt or {}
        local qmdk = activity_cfg.qmdk or {}
        local hdjd = activity_cfg.hdjd or {}
        local bwcz = activity_cfg.bwcz or {}
        local mskh = activity_cfg.mskh or {}
        local sjdb = activity_cfg.sjdb or {}
        if i == 1 then
            return statusByDayTime(bwcz.start_hour or 18, bwcz.start_minute_clock or 0, bwcz.duration_min or 30)
        elseif i == 2 then
            return statusByDayTime(qmdk.start_hour or 19, qmdk.start_minute_clock or 0, qmdk.duration_min or 20)
        elseif i == 3 then
            return statusByOpenMinute(qmdt.start_minute or 35, qmdt.duration_min or 4)
        elseif i == 5 then
            return statusByOpenMinute(5, 3)
        elseif i == 6 then
            return statusByDayTime(mskh.start_hour or 16, mskh.start_minute_clock or 0, mskh.duration_min or 30)
        elseif i == 7 then
            return statusByOpenMinute(30, 120)
        elseif i == 8 then
            return statusByDayTime(22, 0, 10)
        elseif i == 9 then
            return statusByOpenMinute(25, 5)
        elseif i == 10 then
            return statusByDayTime(20, 0, 120)
        elseif i == 13 then
            return statusByOpenMinute(15, math.max(1, math.ceil((tonumber(sjdb.keep_sec) or 300) / 60)))
        elseif i == 14 then
            return statusByDayTime(hdjd.start_hour or 19, hdjd.start_minute_clock or 30, hdjd.duration_min or 20)
        end
        return ACTIVITY_STATUS_WAIT
    end
    local function sortActivityIds(activityIds)
        local sorted = {}
        for _, activityId in ipairs(activityIds or {}) do
            sorted[#sorted + 1] = activityId
        end
        table.sort(sorted, function(a, b)
            local statusA = getActivityStatus(a)
            local statusB = getActivityStatus(b)
            if statusA ~= statusB then
                return statusA < statusB
            end
            return tonumber(a) < tonumber(b)
        end)
        return sorted
    end
    local function addActivityStatusTip(item, activityId)
        local tip = GUI:Image_Create(item, "activity_status_tip", 6, 62, "res/custom/activity/tip_" .. tostring(getActivityStatus(activityId)) .. ".png")
        GUI:setAnchorPoint(tip, 0, 0.5)
        GUI:setLocalZOrder(tip, 10)
    end
    local function GUI_createLabel_507(label, i)
        GUI:removeAllChildren(label)
        local cfg = getActivityDisplayCfg(i)
        GUI:Image_Create(label, "img_bj", 6, 350, "res/custom/activity/img/img_" .. i .. ".png")
        local btn = GUI:Button_Create(label, "btn", 340, 14, cfg.btnSkin or "res/custom/activity/btn.png")
        GUI:addOnClickEvent(btn, function()
            closeActivityWindow()
            if tonumber(i) == 7 then
                SL:SendLuaNetMsg(101, 506, 0, 0, "")
                return
            end
            SL:SendLuaNetMsg(101, 507, 1, i, "")
        end)
        -- local title = GUI:Text_Create(label, "title", 22, 315, 24, "#F3E2B6", cfg.title or "")
        -- GUI:Text_setFontName(title, "fonts/500.ttf")
        -- GUI:Text_enableOutline(title, "#100808", 2)
        richText(label, "tip", 60, 252 + 40, 468, 18, "<font color='#f3e2b6' size='16'>" .. tostring(cfg.desc or "") .. "</font>")
        richText(label, "time", 60, 153 + 30, 468, 18, "<font color='#9ff06b' size='16'>" .. tostring(cfg.time or "") .. "</font>")
        renderRewardItems(label, cfg)
    end
    local function renderActivity(node)
        GUI:removeAllChildren(node)
        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -20, 50, 300, 420, 1)
        GUI:ListView_setGravity(npc.cbl_list, 2)
        npc.Label = GUI:Node_Create(node, "Label", 250, 15)
        local activityIds = {
            1,
            2,
            3,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            13,
            14,
        }
        local visibleMap = {
        }
        activityIds = sortActivityIds(activityIds)
        for _, activityId in ipairs(activityIds) do
            visibleMap[activityId] = true
        end
        if not visibleMap[tonumber(npc.titles_sign or 0) or 0] then
            npc.titles_sign = activityIds[1]
        end
        for _, i in ipairs(activityIds) do
            local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/activity/list/" .. (npc.titles_sign == i and "l" or "n") .. "/" .. (npc.titles_sign == i and "l_" or "n_") .. i .. ".png")
            GUI:setContentSize(cbl_item, GUI:getContentSize(cbl_item).width * 0.8, GUI:getContentSize(cbl_item).height * 0.8)
            addActivityStatusTip(cbl_item, i)
            GUI:addOnClickEvent(cbl_item, function()
                local oldBtn = GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign]
                if oldBtn and not tolua.isnull(oldBtn) then
                    GUI:Button_loadTextureNormal(oldBtn, "res/custom/activity/list/n/n_" .. npc.titles_sign .. ".png")
                end
                npc.titles_sign = i
                GUI_createLabel_507(npc.Label, i)
                GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/activity/list/l/l_" .. npc.titles_sign .. ".png")
            end)
        end
    end
    if p2 == 0 then
        npc.data_507 = not Data and {
        } or SL:JsonDecode(Data, false)
        local win = ensureWindow("activity", 507, {
            titleText = "游戏活动",
        })
        npc.bg = win.bg
        npc.node = win.node
        npc.title = win.title
        renderActivity(npc.node)
        GUI_createLabel_507(npc.Label, npc.titles_sign or 1)
    end
end
npc[511] = function(p2, p3, Data)
    local fldt_data_cfg = teshudata["fldt"] or {
    }
    local fldt_cfg_table = fldt_data_cfg["fldt_cfg"]
    local fldt_seven_cfg = (fldt_cfg_table and fldt_cfg_table.seven_login) or {
    }
    local fldt_online_limit = fldt_seven_cfg.online_limit or 10
    local fldt_number_days = tonumber(fldt_seven_cfg.number_days or 4) or 4
    if fldt_number_days < 1 then
        fldt_number_days = 1
    elseif fldt_number_days > 7 then
        fldt_number_days = 7
    end
    local function fldt_decode_json(raw)
        if type(raw) == "table" then
            return raw
        end
        if not raw or raw == "" then
            return {
            }
        end
        return SL:JsonDecode(raw, false) or {
        }
    end
    local function fldt_get_state()
        npc.fldt_data = npc.fldt_data or {
        }
        npc.ts_data = npc.ts_data or {
        }
        npc.sign = npc.sign or 1
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {
        }
        return npc.fldt_data.T_qrbq
    end
    local function fldt_get_flip_digits()
        local fp = fldt_get_state()["7rqd_fp"]
        if type(fp) ~= "table" then
            fp = {
            }
        end
        return fp
    end
    local function fldt_get_mat_reward_by_day(day)
        local tqrbq = fldt_get_state()
        local matData = tqrbq and tqrbq["7rqd_mat"] or nil
        if type(matData) ~= "table" then
            return nil
        end
        local record = matData[day]
        if record == nil then
            record = matData[tostring(day)]
        end
        if record == nil then
            for _, one in ipairs(matData) do
                if type(one) == "table" and (tonumber(one.day) or 0) == (tonumber(day) or 0) then
                    record = one
                    break
                end
            end
        end
        if type(record) ~= "table" then
            return nil
        end
        if type(record.give) == "table" and #record.give > 0 then
            return record.give
        end
        return nil
    end
    local function fldt_calc_flip_value(fp)
        local total = 0
        if type(fp) ~= "table" then
            return total
        end
        for i = 1, 7 do
            local value = fp[i]
            if value == nil then
                value = fp[tostring(i)]
            end
            total = total + (tonumber(value) or 0) * (10 ^ (i - 1))
        end
        return total
    end
    local function fldt_format_digits(fp)
        local seq = {
        }
        for i = 7, 1, -1 do
            local v = fp[i] or fp[tostring(i)]
            seq[#seq + 1] = v ~= nil and tostring(v) or "?"
        end
        return table.concat(seq, " ")
    end
    local function sort_by_state(grss)
        table.sort(grss, function(a, b)
            local order = {
                [1] = 1,
                [3] = 2,
                [0] = 2,
                [2] = 3,
            }
            local a_order = order[a.state] or 99
            local b_order = order[b.state] or 99
            if a_order == b_order then
                return a.idx < b.idx
            else
                return a_order < b_order
            end
        end)
    end
    local state_info = {
        [1] = {
            color = "#FF0000",
            text = "可领取",
        },
        [0] = {
            color = "#FFFF00",
            text = "未达成",
        },
        [2] = {
            color = "#00FF00",
            text = "已领取",
        },
        [3] = {
            color = "#FF0000",
            text = "需特权",
        },
    }
    local fldt_section_key_map = {
        [4] = "grss",
        [5] = "grsb",
        [6] = "qqsb",
    }
    local fldt_section_flag_map = {
        [4] = "grss_can_claim",
        [5] = "grsb_can_claim",
        [6] = "qqsb_can_claim",
    }
    local function fldt_to_bool(v)
        if type(v) == "boolean" then
            return v
        end
        if type(v) == "number" then
            return v ~= 0
        end
        if type(v) == "string" then
            local lower = string.lower(v)
            return lower == "1" or lower == "true"
        end
        return false
    end
    local function fldt_has_claimable_by_state_key(stateKey, stateTable)
        local cfg = fldt_data_cfg[stateKey] or {
        }
        local st = stateTable or npc.ts_data or {
        }
        for idx, _ in pairs(cfg) do
            if tonumber(st[tostring(idx)] or st[idx] or 0) == 1 then
                return true
            end
        end
        return false
    end
    local function fldt_get_reward_state(stateTable, idx)
        if type(stateTable) ~= "table" then
            return 0
        end
        return tonumber(stateTable[tostring(idx)] or stateTable[idx] or 0) or 0
    end
    local function fldt_build_state_rows(stateKey, stateTable)
        local cfg = fldt_data_cfg[stateKey] or {
        }
        local rows = {
        }
        for idx, entry in pairs(cfg) do
            rows[#rows + 1] = {
                idx = idx,
                state = fldt_get_reward_state(stateTable, idx),
                name = entry.name,
            }
        end
        sort_by_state(rows)
        return rows
    end
    local function fldt_apply_state_button(button, state)
        local info = state_info[state] or state_info[0]
        local canClick = state == 1 or state == 3
        GUI:Button_setTitleText(button, info.text)
        GUI:Button_setTitleColor(button, info.color)
        GUI:Button_setTitleFontSize(button, 14)
        GUI:setTouchEnabled(button, canClick)
        GUI:Button_setBright(button, canClick)
    end
    local function fldt_get_qqsb_owner_name(idx)
        if type(npc.T_qqsb) ~= "table" then
            return ""
        end
        return tostring(npc.T_qqsb[tostring(idx)] or npc.T_qqsb[idx] or "")
    end
    local function fldt_section_has_claimable(idx)
        if idx == 1 then
            local tqrbq = fldt_get_state()
            local loginDays = tonumber(npc.fldt_data and npc.fldt_data.U_dlts) or 0
            local claimed = tonumber(tqrbq["7rqd"]) or 0
            local rewards = fldt_data_cfg["7rqd"] or {
            }
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and loginDays >= nextIdx
        elseif idx == 2 then
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["zxjl"]) or 0
            local onlineMinutes = tonumber(npc.fldt_data and npc.fldt_data.J_zxsj) or 0
            local rewards = fldt_data_cfg["zxjl"] or {
            }
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and onlineMinutes >= (tonumber(nextCfg.time) or 0)
        elseif idx == 3 then
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["sgjl"]) or 0
            local killCount = tonumber(npc.fldt_data and npc.fldt_data.U_sgsl) or 0
            local rewards = fldt_data_cfg["sgjl"] or {
            }
            local nextIdx = claimed + 1
            local nextCfg = rewards[nextIdx]
            return nextCfg ~= nil and killCount >= (tonumber(nextCfg.num) or 0)
        elseif idx >= 4 and idx <= 6 then
            local flagKey = fldt_section_flag_map[idx]
            local stateKey = fldt_section_key_map[idx]
            local hasClaimable = false
            if npc.fldt_data and flagKey and npc.fldt_data[flagKey] ~= nil then
                hasClaimable = fldt_to_bool(npc.fldt_data[flagKey])
            elseif npc.fldt_state_cache and type(npc.fldt_state_cache[stateKey]) == "table" then
                hasClaimable = fldt_has_claimable_by_state_key(stateKey, npc.fldt_state_cache[stateKey])
            end
            if npc.titles_sign == idx and type(npc.ts_data) == "table" then
                hasClaimable = fldt_has_claimable_by_state_key(stateKey, npc.ts_data)
                npc.fldt_state_cache = npc.fldt_state_cache or {
                }
                npc.fldt_state_cache[stateKey] = npc.ts_data
                if npc.fldt_data and flagKey then
                    npc.fldt_data[flagKey] = hasClaimable and 1 or 0
                end
            end
            return hasClaimable
        end
        return false
    end
    local function fldt_refresh_side_redpoints()
        if not npc.cbl_list then
            return
        end
        local ui = GUI:ui_delegate(npc.cbl_list)
        for i = 1, 6 do
            local btn = ui and ui["item" .. i] or nil
            if btn then
                local hasClaimable = fldt_section_has_claimable(i)
                if hasClaimable then
                    local btnUi = GUI:ui_delegate(btn)
                    if not (btnUi and btnUi.redpoint) then
                        NPC_UI_HELPER.redpoint_create(btn, {
                            x = 180,
                            y = 32,
                        })
                    end
                else
                    GUI:removeChildByName(btn, "redpoint")
                end
            end
        end
    end
    local function levelrush_to_int(v, d)
        return tonumber(v or d or 0) or (d or 0)
    end
    local function levelrush_reward_cfg(row)
        local cfgList = ((teshudata or {})["npc_102"] or {}).rewards or {}
        return cfgList[levelrush_to_int(row and row.idx, 0)] or {}
    end
    local function levelrush_merge_row(row)
        row = row or {}
        local cfg = levelrush_reward_cfg(row)
        local limit = levelrush_to_int(row.limit, cfg.limit)
        local used = levelrush_to_int(row.used)
        local remaining = row.remaining
        if remaining == nil then
            remaining = limit > 0 and math.max(0, limit - used) or -1
        end
        return {
            idx = levelrush_to_int(row.idx),
            level = levelrush_to_int(row.level, cfg.level),
            title = tostring(cfg.title or ""),
            desc = tostring(cfg.desc or ""),
            items = cfg.items or {},
            limit = limit,
            used = used,
            remaining = remaining,
            claimed = levelrush_to_int(row.claimed),
            can_claim = levelrush_to_int(row.can_claim),
            order_ok = levelrush_to_int(row.order_ok, 1),
            no_reward = levelrush_to_int(row.no_reward),
        }
    end
    local function levelrush_item_index(name)
        if not name or name == "" then
            return 0
        end
        return tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name) or 0) or 0
    end
    local function levelrush_title_index(name)
        if not name or name == "" then
            return 0
        end
        local idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name .. "[称号]") or 0) or 0
        if idx <= 0 then
            idx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", name) or 0) or 0
        end
        return idx
    end
    local function levelrush_reward_icons(row)
        row = levelrush_merge_row(row)
        local list = {}
        if row.title ~= "" then
            list[#list + 1] = {idx = levelrush_title_index(row.title), count = 1}
        end
        if type(row.items) == "table" then
            for _, item in ipairs(row.items) do
                if type(item) == "table" and tostring(item[1] or "") ~= "" then
                    list[#list + 1] = {
                        idx = levelrush_item_index(tostring(item[1] or "")),
                        count = levelrush_to_int(item[2], 1),
                    }
                end
            end
        end
        return list
    end
    local function levelrush_open_tip(widget, row)
        row = levelrush_merge_row(row)
        local limit = levelrush_to_int(row.limit)
        local used = levelrush_to_int(row.used)
        local quotaText = limit > 0 and string.format("总名额：%d<br>已发送：%d<br>剩余：%d", limit, used, math.max(0, limit - used)) or "总名额：无限"
        -- if tostring(row.desc or "") ~= "" then
        --     quotaText = quotaText .. "<br><font color='#F2D78D'>奖励：" .. tostring(row.desc or "") .. "</font>"
        -- end
        local pos = GUI:getWorldPosition(widget)
        SL:OpenCommonDescTipsPop({
            str = string.format("<font color='#F4D179' size='20'>%s级 %s</font><br><font color='#DCEBFF' size='18'>%s</font>", tostring(row.level or 0), tostring(row.title or ""), quotaText),
            worldPos = {x = pos.x, y = pos.y},
            anchorPoint = {x = 0, y = 0},
            formatWay = 1
        })
    end
    local function levelrush_render_icons(parent, row, startX, posY)
        local rewards = levelrush_reward_icons(row)
        local gap = 55
        for i, reward in ipairs(rewards) do
            if levelrush_to_int(reward.idx) > 0 then
                local frame = GUI:Image_Create(parent, "cj_frame_" .. tostring(row.idx) .. "_" .. i, startX + (i - 1) * gap, posY, "res/custom/xinquchongji/装备框-.png")
                GUI:setAnchorPoint(frame, 0.5, 0.5)
                local item = GUI:ItemShow_Create(frame, "item", 25, 25, {index = reward.idx, look = true, bgVisible = false})
                GUI:setAnchorPoint(item, 0.5, 0.5)
                if levelrush_to_int(reward.count) > 1 then
                    local countText = GUI:Text_Create(frame, "count", 47, 9, 15, "#F8E0A0", tostring(reward.count))
                    GUI:setAnchorPoint(countText, 1, 0.5)
                    GUI:Text_enableOutline(countText, "#05080C", 2)
                end
            end
        end
    end
    local function GUI_createLabel(Label_node, idx)
        GUI:removeAllChildren(Label_node)
        GUI:Image_Create(Label_node, "bg", 0, 0, "res/custom/fulitating/bg_" .. idx .. ".png")
        npc.fldt_data = npc.fldt_data or {
        }
        if idx == 1 then
            local base = npc.fldt_data
            base.T_qrbq = base.T_qrbq or {
            }
            local tqrbq = base.T_qrbq
            local loginDays = tonumber(base.U_dlts) or 0
            local onlineMinutes = tonumber(base.J_zxsj) or 0
            local claimed = tonumber(tqrbq["7rqd"]) or 0
            local flipDigits = fldt_get_flip_digits()
            local digitDisplay = fldt_format_digits(flipDigits)
            local finalSum = tonumber(tqrbq["7rqd_final_yb"]) or fldt_calc_flip_value(flipDigits)
            local finalMultiple = tonumber(tqrbq["7rqd_final_mul"]) or 1
            local finalAward = tonumber(tqrbq["7rqd_final_award"]) or 0
            for i = 7, 1, -1 do
                local slotX = 47 - (i - 7) * 82
                local v = flipDigits[i] or flipDigits[tostring(i)]
                local isClaimedDay = claimed >= i
                if i > fldt_number_days and isClaimedDay then
                    local matGive = fldt_get_mat_reward_by_day(i)
                    local matRow = type(matGive) == "table" and matGive[1] or nil
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 308, "res/custom/fulitating/num/kongbai.png"), 0.5, 0.5)
                    if type(matRow) == "table" and matRow[1] then
                        local matNode = ItemNumByTable_img({
                            matRow,
                        }, nil, GUI:Node_Create(Label_node, "mat_node_" .. i, 0, 0))
                        GUI:setPosition(matNode, slotX - 25, 283)
                    end
                elseif i <= fldt_number_days and isClaimedDay and v ~= nil then
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 308, "res/custom/fulitating/num/" .. v .. ".png"), 0.5, 0.5)
                    local effwu = GUI:Frames_Create(Label_node, "effwu" .. i, slotX, 328, "res/custom/fulitating/eff/" .. i .. "/y_", ".png", 1, 15, {
                        speed = 75,
                        count = 15,
                        loop = 1,
                        finishhide = false,
                    })
                    GUI:setAnchorPoint(effwu, 0.5, 0.5)
                else
                    GUI:setAnchorPoint(GUI:Image_Create(Label_node, "img_bj_l_" .. i, slotX, 328, "res/custom/fulitating/eff/" .. i .. "/y_1.png"), 0.5, 0.5)
                end
            end
            local sevenRewards = fldt_data_cfg["7rqd"] or {
            }
            local totalDays = #sevenRewards
            local todayIdx = claimed + 1
            local todayCfg = sevenRewards[math.min(todayIdx, totalDays)]
            local canShow = todayCfg ~= nil
            local canClaimToday = canShow and loginDays >= todayIdx and todayIdx <= totalDays
            local dayLayout = GUI:Layout_Create(Label_node, "seven_day_layout", 150, 0, 620, 200)
            local card = GUI:Node_Create(dayLayout, "seven_card_today", 0, 0)
            local rewardNode = GUI:Node_Create(card, "give_today", 0, 0)
            ItemNumByTable_img(todayCfg.jl, nil, rewardNode)
            GUI:setPosition(rewardNode, 10, 10)
            if canClaimToday then
                local claimButton = GUI:Button_Create(card, "Button_today", 240, -10, "res/custom/fulitating/btn_2.png")
                GUI:addOnClickEvent(claimButton, function()
                    SL:SendLuaNetMsg(101, 511, 1, 1, string.format('{"7rqd":%d}', todayIdx))
                end)
                NPC_UI_HELPER.redpoint_create(claimButton)
                NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, claimButton, card, 511, 1, {
                    dir = 5,
                    taskMap = {[511] = 10,},
                    desc = "点击领取七日登录奖励",
                    isForce = false
                })
            else
                local tipText
                if not canShow or todayIdx > totalDays then
                    tipText = "七日登录奖励已全部领取"
                elseif loginDays < todayIdx then
                    tipText = string.format("今日奖励已经领取完毕，达到第%d天可继续领取", todayIdx)
                elseif onlineMinutes < fldt_online_limit then
                    tipText = string.format("今日在线满%d分钟后可领取奖励", fldt_online_limit)
                else
                    tipText = "今日暂无可领取奖励"
                end
                GUI:Text_Create(Label_node, "seven_state_tip", 200, 63, 18, "#FFA043", tipText)
            end
        elseif idx == 2 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["zxjl"]) or 0
            local onlineMinutes = tonumber(npc.fldt_data and npc.fldt_data.J_zxsj) or 0
            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F", string.format("当前在线：%d分钟", onlineMinutes))
            local onlineRewards = fldt_data_cfg["zxjl"] or {
            }
            for v, k in ipairs(onlineRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_' .. (v % 2 == 1 and 1 or 2) .. '.png')
                local canClaimNow = (v == (claimed + 1)) and (onlineMinutes >= (tonumber(k.time) or 0))
                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("在线满%d分钟", k.time))
                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)
                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false
                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if onlineMinutes >= (k.time or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d分钟", onlineMinutes, k.time or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end
                if enable then
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 2, '{"zxjl":' .. v .. '}')
                    end)
                    if canClaimNow then
                        NPC_UI_HELPER.redpoint_create(Button, {
                            x = 110,
                            y = 30,
                        })
                    end
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 3 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 0, 600, 330, 1)
            local tqrbq = fldt_get_state()
            local claimed = tonumber(tqrbq["sgjl"]) or 0
            local killCount = tonumber(npc.fldt_data and npc.fldt_data.U_sgsl) or 0
            GUI:Text_Create(Label_node, "online_desc", 260, 50 + 400, 18, "#FFD56F", string.format("今日已击杀：%d只", killCount))
            local killRewards = fldt_data_cfg["sgjl"] or {
            }
            for v, k in ipairs(killRewards) do
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. v, 0, 0, 'res/custom/fulitating/list_fgx_' .. (v % 2 == 1 and 1 or 2) .. '.png')
                local canClaimNow = (v == (claimed + 1)) and (killCount >= (tonumber(k.num) or 0))
                GUI:Text_Create(l, "wz", 30, 20, 20, "#FFEE8A", string.format("击杀%d只怪物", k.num))
                local give = ItemNumByTable_img(k.jl, nil, GUI:Node_Create(l, "give", 0, 0))
                GUI:setPosition(give, 260, 5)
                local stateDesc = "未解锁"
                local btnText = "待解锁"
                local stateColor = "#FFFF66"
                local enable = false
                if v <= claimed then
                    stateDesc = "已领取"
                    btnText = "已领取"
                    stateColor = "#00FF7F"
                elseif v == claimed then
                    if killCount >= (k.num or 0) then
                        stateDesc = "可领取"
                        btnText = "领取"
                        stateColor = "#00FF7F"
                        enable = true
                    else
                        stateDesc = string.format("%d/%d只", killCount, k.num or 0)
                        btnText = stateDesc
                    end
                else
                    enable = true
                end
                if enable then
                    local Button = GUI:Button_Create(l, "Button", 440, 10, "res/custom/fulitating/btn_1.png")
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 3, '{"sgjl":' .. v .. '}')
                    end)
                    if canClaimNow then
                        NPC_UI_HELPER.redpoint_create(Button, {
                            x = 110,
                            y = 30,
                        })
                    end
                else
                    GUI:Image_Create(l, "ylq", 440, 10, 'res/wy/public/4.png')
                end
            end
        elseif idx == 4 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grss = {
            }
            for v, k in pairs(teshudata["fldt"]["grss"]) do
                if npc.ts_data["" .. v] == nil then
                    table.insert(grss, {
                        idx = v,
                        state = 0,
                        name = k.name,
                    })
                else
                    table.insert(grss, {
                        idx = v,
                        state = npc.ts_data["" .. v],
                        name = teshudata["fldt"]["grss"][tonumber(v)].name,
                    })
                end
            end
            sort_by_state(grss)
            for i = (npc.sign - 1) * 7 + 1, (npc.sign - 1) * 7 + 7 do
                if not grss[i] then
                    break
                end
                local v = grss[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. i, 0, 0, 'res/custom/fulitating/list_fgx_' .. (v.idx % 2 == 1 and 1 or 2) .. '.png')
                GUI:setContentSize(l, 580, 40)
                GUI:Text_Create(l, "wz", 35, 5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5, ItemNumByTable(teshudata["fldt"]["grss"][v.idx].give), 500, 18, "#f7f7de", 3, nil, nil, {
                    outlineSize = 2,
                    outlineColor = SL:ConvertColorFromHexString("#100808"),
                })
                local Button = GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 4, '{"grss":"' .. (v.idx) .. '"}')
                end)
            end
            local Button_all = GUI:Button_Create(Label_node, "grss_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 4, '{"isall":1}')
            end)
            local Button = GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == math.ceil(#grss / 10) then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            Button = GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            GUI:setAnchorPoint(GUI:Text_Create(Label_node, "state", 225, 20, 18, "#ffffff", string.format("第%d页/共%d页", npc.sign, math.ceil(#grss / 10))), 0.5, 0.5)
        elseif idx == 5 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local grsb = {
            }
            for v, k in pairs(teshudata["fldt"]["grsb"]) do
                if npc.ts_data["" .. v] == nil then
                    table.insert(grsb, {
                        idx = v,
                        state = 0,
                        name = k.name,
                    })
                else
                    table.insert(grsb, {
                        idx = v,
                        state = npc.ts_data["" .. v],
                        name = teshudata["fldt"]["grsb"][tonumber(v)].name,
                    })
                end
            end
            sort_by_state(grsb)
            local totalPage = math.max(1, math.ceil(#grsb / 7))
            for i = (npc.sign - 1) * 7 + 1, (npc.sign - 1) * 7 + 7 do
                if not grsb[i] then
                    break
                end
                local v = grsb[i]
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. i, 0, 0, 'res/custom/fulitating/list_fgx_' .. (v.idx % 2 == 1 and 1 or 2) .. '.png')
                GUI:setContentSize(l, 600, 40)
                GUI:Text_Create(l, "wz", 35, 5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220, 5, ItemNumByTable(teshudata["fldt"]["grsb"][v.idx].give), 500, 18, "#f7f7de", 3, nil, nil, {
                    outlineSize = 2,
                    outlineColor = SL:ConvertColorFromHexString("#100808"),
                })
                local Button = GUI:Button_Create(l, "Button", 436, -2, "res/public/1900000660.png")
                GUI:Button_setTitleText(Button, state_info[v.state].text)
                GUI:Button_setTitleColor(Button, state_info[v.state].color)
                GUI:Button_setTitleFontSize(Button, 14)
                GUI:addOnClickEvent(Button, function()
                    SL:SendLuaNetMsg(101, 511, 1, 5, '{"grsb":"' .. (v.idx) .. '"}')
                end)
            end
            local Button_all = GUI:Button_Create(Label_node, "grsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            GUI:addOnClickEvent(Button_all, function()
                SL:SendLuaNetMsg(101, 511, 1, 5, '{"isall":1}')
            end)
            local Button = GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            Button = GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            GUI:setAnchorPoint(GUI:Text_Create(Label_node, "state", 225, 20, 18, "#ffffff", string.format("第%d页/共%d页", npc.sign, totalPage)), 0.5, 0.5)
        elseif idx == 6 then
            local Label_list = GUI:ListView_Create(Label_node, "Label_list", 0, 55, 600, 280, 1)
            local qqsb = fldt_build_state_rows("qqsb", npc.ts_data)
            sort_by_state(qqsb)
            local totalPage = math.max(1, math.ceil(#qqsb / 7))
            for i = (npc.sign - 1) * 7 + 1, (npc.sign - 1) * 7 + 7 do
                if not qqsb[i] then
                    break
                end
                local v = qqsb[i]
                local cfg = teshudata["fldt"]["qqsb"][v.idx]
                local l = GUI:Image_Create(Label_list, "img_bj_l_" .. i, 0, 0, 'res/custom/fulitating/list_fgx_' .. (i % 2 == 1 and 1 or 2) .. '.png')
                GUI:setContentSize(l, 600, 40)
                GUI:Text_Create(l, "wz", 20, 5, 20, "#FF0000", v.name)
                GUI:RichText_Create(l, "jl", 220 - 78, 5, ItemNumByTable(cfg.give), 500, 18, "#f7f7de", 3, nil, nil, {
                    outlineSize = 2,
                    outlineColor = SL:ConvertColorFromHexString("#100808"),
                })
                local ownerName = fldt_get_qqsb_owner_name(v.idx)
                local ownerDisplayName = ownerName ~= "" and ownerName or "※虚位以待※"
                local ownerColor = ownerName ~= "" and "#00FF00" or "#FFFFFF"
                GUI:Text_Create(l, "owner_" .. i, 300, 8, 18, ownerColor, ownerDisplayName)
                if v.state == 1 or v.state == 3 then
                    local Button = GUI:Button_Create(l, "Button", 505 - 55, -2, "res/public/1900000660.png")
                    fldt_apply_state_button(Button, v.state)
                    GUI:addOnClickEvent(Button, function()
                        SL:SendLuaNetMsg(101, 511, 1, 6, '{"qqsb":"' .. (v.idx) .. '"}')
                    end)
                end
            end
            local Button_all = GUI:Button_Create(Label_node, "qqsb_all", 500, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button_all, 0.5, 0)
            GUI:Button_setTitleText(Button_all, "一键领取")
            GUI:Button_setTitleFontSize(Button_all, 14)
            local qqsbCanClaim = fldt_has_claimable_by_state_key("qqsb", npc.ts_data)
            GUI:setTouchEnabled(Button_all, qqsbCanClaim)
            GUI:Button_setBright(Button_all, qqsbCanClaim)
            if qqsbCanClaim then
                GUI:addOnClickEvent(Button_all, function()
                    SL:SendLuaNetMsg(101, 511, 1, 6, '{"isall":1}')
                end)
            end
            local Button = GUI:Button_Create(Label_node, "next", 350, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "下一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == totalPage then
                    SL:ShowSystemTips("已经是最后一页了！！！")
                    return
                end
                npc.sign = npc.sign + 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            Button = GUI:Button_Create(Label_node, "shangyiy", 100, 0, "res/public/1900000660.png")
            GUI:setAnchorPoint(Button, 0.5, 0)
            GUI:Button_setTitleText(Button, "上一页")
            GUI:Button_setTitleFontSize(Button, 14)
            GUI:addOnClickEvent(Button, function()
                if npc.sign == 1 then
                    SL:ShowSystemTips("已经是第一页了！！！")
                    return
                end
                npc.sign = npc.sign - 1
                GUI_createLabel(npc.Label, npc.titles_sign)
            end)
            GUI:setAnchorPoint(GUI:Text_Create(Label_node, "state", 225, 20, 18, "#ffffff", string.format("第%d页/共%d页", npc.sign, totalPage)), 0.5, 0.5)
        elseif idx == 8 then --冲级奖励
            local rushData = npc.cj_data or {}
            local rows = rushData.rows or {}
            local myLevel = levelrush_to_int(rushData.player_level)
            -- GUI:Text_Create(Label_node, "cj_my_level", 670, 368, 18, "#EAF6FF", "当前等级：" .. tostring(myLevel))
            -- GUI:Text_enableOutline(GUI:ui_delegate(Label_node).cj_my_level, "#05080C", 2)
            for index, row in ipairs(rows) do
                row = levelrush_merge_row(row)
                local posY = 311 - (index - 1) * 58
                
                GUI:setContentSize(GUI:Image_Create(Label_node, "cj_line_" .. index, 32, posY - 30, "res/custom/xinquchongji/分割线-.png"), 580, 12)
                local levelText = GUI:Text_Create(Label_node, "cj_level_" .. index, 110 - 18, posY, 21, "#EAF6FF", tostring(row.level or 0) .. "级")
                GUI:setAnchorPoint(levelText, 0.5, 0.5)
                GUI:Text_enableOutline(levelText, "#05080C", 2)
                local quotaText = "无限"
                if levelrush_to_int(row.limit) > 0 then
                    quotaText = string.format("%d/%d", math.max(0, levelrush_to_int(row.limit) - levelrush_to_int(row.used)), levelrush_to_int(row.limit))
                end
                local quotaNode = GUI:Text_Create(Label_node, "cj_quota_" .. index, 312 - 25, posY, 21, "#DCEBFF", quotaText)
                GUI:setAnchorPoint(quotaNode, 0.5, 0.5)
                GUI:Text_enableOutline(quotaNode, "#05080C", 2)
                GUI:Text_enableUnderline(quotaNode)
                GUI:setTouchEnabled(quotaNode, true)
                if SL:GetMetaValue("WINPLAYMODE") then
                    GUI:addMouseMoveEvent(quotaNode, {onEnterFunc = function()
                        levelrush_open_tip(quotaNode, row)
                    end, onLeaveFunc = function()
                        SL:CloseCommonDescTipsPop()
                    end})
                else
                    GUI:addOnTouchEvent(quotaNode, function()
                        levelrush_open_tip(quotaNode, row)
                    end)
                end
                levelrush_render_icons(Label_node, row, 460 - 30, posY + 3)
            end
        end
    end
    local function UI_updata(node)
        GUI:removeAllChildren(node)
        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 10)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)
        local titles = {
            "七日登录",
            "在线奖励",
            "杀怪奖励",
            "怪物首杀",
            "个人首爆",
            "全区首爆",
            "积分抽取（废除）",
            "冲级奖励",
        }
        npc.titles_sign = 1
        for i = 1, #titles do
            if titles[i] == "积分抽取（废除）" then
            else
                local cbl_item = GUI:Button_Create(npc.cbl_list, "item" .. i, 0, 0, "res/custom/fulitating/list/" .. (npc.titles_sign == i and "l" or "n") .. "/" .. i .. ".png")
                GUI:Image_Create(npc.cbl_list, "fgx" .. i, 0, 0, "res/custom/fulitating/list/fgx.png")
                GUI:addOnClickEvent(cbl_item, function()
                    GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/n/" .. npc.titles_sign .. ".png")
                    npc.titles_sign = i
                    if i >= 4 then
                        SL:SendLuaNetMsg(101, 511, 2, i, "")
                        npc.sign = 1
                    else
                        GUI_createLabel(npc.Label, i)
                    end
                    GUI:Button_loadTextureNormal(GUI:ui_delegate(npc.cbl_list)["item" .. npc.titles_sign], "res/custom/fulitating/list/l/" .. npc.titles_sign .. ".png")
                end)
            end
        end
        GUI:Image_Create(node, "bg_fgx", 0, 0, "res/custom/fulitating/bg_fgx.png")
        fldt_refresh_side_redpoints()
    end
    if p2 == 0 then
        npc.fldt_data = fldt_decode_json(Data)
        npc.fldt_data.T_qrbq = npc.fldt_data.T_qrbq or {
        }
        npc.ts_data = npc.ts_data or {
        }
        npc.fldt_state_cache = {
        }
        local welfareWindow = ensureWindow("welfare", 511, {
            titleText = "福利大厅",
        })
        npc.bg = welfareWindow.bg
        npc.node = welfareWindow.node
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    elseif p2 == 1 then
        if p3 == 1 then
            npc.fldt_data = npc.fldt_data or {
            }
            npc.fldt_data.T_qrbq = fldt_decode_json(Data)
            if npc.Label and (npc.titles_sign or 1) <= 3 then
                GUI_createLabel(npc.Label, npc.titles_sign or 1)
            end
            fldt_refresh_side_redpoints()
        end
    elseif p2 == 2 then
        if p3 == 8 then
            npc.cj_data = fldt_decode_json(Data)
        else
            npc.ts_data = fldt_decode_json(Data)
        end
        npc.titles_sign = p3
        local stateKey = fldt_section_key_map[p3]
        local flagKey = fldt_section_flag_map[p3]
        if stateKey then
            npc.fldt_state_cache = npc.fldt_state_cache or {
            }
            npc.fldt_state_cache[stateKey] = npc.ts_data
        end
        if stateKey and flagKey and npc.fldt_data then
            npc.fldt_data[flagKey] = fldt_has_claimable_by_state_key(stateKey, npc.ts_data) and 1 or 0
        end
        GUI_createLabel(npc.Label, p3)
        fldt_refresh_side_redpoints()
    elseif p2 == 10 then
        npc.T_qqsb = fldt_decode_json(Data)
    end
end
npc[512] = function(p2, p3, Data)
    local strategyPages = {
        {
            key = "intro",
            main = "本服简介",
            subs = {
                {name = "游戏简介", img = "res/custom/strategy/本服简介-游戏简介/本服简介-游戏简介.png"},
                {name = "等级相关", img = "res/custom/strategy/本服简介-等级相关.png"},
            },
        },
        {
            key = "start",
            main = "起号抗米",
            subs = {
                {name = "白嫖玩家", img = "res/custom/strategy/起号抗米-白嫖玩家.png"},
                {name = "小资玩家", img = "res/custom/strategy/起号抗米-小资玩家-.png"},
                {name = "土豪玩家", img = "res/custom/strategy/起号抗米-土豪玩家--.png"},
            },
        },
        {
            key = "equip",
            main = "装备预览",
            subs = {
                {name = "装备分类", img = "res/custom/strategy/装备预览-装备分类-.png"},
                {name = "顶级装备", img = "res/custom/strategy/顶级装备背景.png"},
                {name = "全服孤品", img = "res/custom/strategy/全服孤品背景.png"},
            },
        },
        {
            key = "play",
            main = "玩法攻略",
            subs = {
                {name = "玩法攻略", img = "res/custom/strategy/玩法攻略/玩法攻略.png"},
                -- {name = "灵根部分", img = "res/custom/strategy/玩法攻略/灵根部分.png", w = 1392, h = 162},
            },
        },
        {
            key = "map",
            main = "地图走法",
            map = true,
            subs = {
                {name = "地图走法", img = "res/custom/strategy/地图走法/地图走法.png", w = 1944, h = 1286},
            },
        },
    }
    local function getPage(idx)
        return strategyPages[tonumber(idx or 1) or 1] or strategyPages[1]
    end
    local function getSub(page, idx)
        page = page or strategyPages[1]
        return page.subs[tonumber(idx or 1) or 1] or page.subs[1]
    end
    local function strategyFileExists(path)
        return SL and SL.IsFileExist and SL:IsFileExist(path)
    end
    local function getSideButtonSkin(name, selected, fallback)
        local path = "res/custom/strategy/左侧按钮/" .. (selected and "亮" or "暗") .. "/" .. name .. ".png"
        if strategyFileExists(path) then
            return path
        end
        return fallback or "res/custom/strategy/list/" .. (selected and "l" or "n") .. "/1.png"
    end
    local function setButtonSkin(btn, name, selected)
        if not btn then
            return
        end
        GUI:Button_loadTextureNormal(btn, getSideButtonSkin(name, selected))
    end
    local function createSideButton(parent, id, name, selected, fallback, onClick)
        local btn = GUI:Button_Create(parent, id, 0, 0, getSideButtonSkin(name, selected, fallback))
        if not strategyFileExists("res/custom/strategy/左侧按钮/暗/" .. name .. ".png") then
            local txt = GUI:Text_Create(btn, "txt", 85, 21, 20, selected and "#fff3c0" or "#79808b", name)
            GUI:setAnchorPoint(txt, 0.5, 0.5)
            GUI:Text_enableOutline(txt, "#100808", 2)
        end
        if onClick then
            GUI:addOnClickEvent(btn, onClick)
        end
        return btn
    end
    local function createScaleButton(parent, name, x, y, text, callback)
        local btn = GUI:Button_Create(parent, name, x, y, "res/wy/public/kb_btn.png")
        -- GUI:setScale(btn, 0.8)
        GUI:Button_setTitleText(btn, text)
        GUI:Button_setTitleFontSize(btn, 20)
        
        -- local label = GUI:Text_Create(btn, "txt", 58, 17, 22, "#fff2c2", text)
        -- GUI:setAnchorPoint(label, 0.5, 0.5)
        -- GUI:Text_enableOutline(label, "#251008", 2)
        GUI:addOnClickEvent(btn, callback)
        return btn
    end
    local function renderNormalPage(Label_node, page)
        local viewW, viewH = 584, 444
        local subIdx = (npc.strategy_sub_sign and npc.strategy_sub_sign[page.key]) or 1
        local sub = getSub(page, subIdx)
        local imgW, imgH = sub.w or 584, sub.h or 444
        local scroll = GUI:ScrollView_Create(Label_node, "ScrollView", 0, 0, viewW, viewH, imgW > viewW and 2 or 1)
        GUI:ScrollView_setBounceEnabled(scroll, true)
        local innerW, innerH = math.max(viewW, imgW), math.max(viewH, imgH)
        GUI:ScrollView_setInnerContainerSize(scroll, innerW, innerH)
        local img = GUI:Image_Create(scroll, "content", 0, math.max(0, innerH - imgH), sub.img)
        GUI:setAnchorPoint(img, 0, 0)
    end
    local equipPreviewData = {
        ["顶级装备"] = {
            groups = {
                {title = "世界专属", items = {"龙魂吊坠", "王权圣戒", "烈焰指环", "炽焰护腕", "傲霜孤", "月华流影"}},
                {title = "二大陆", items = {"黄金靴子", "黄金腰带", "黄金瞬影戒", "黄金银河护手", "黄金冥王链", "黄金幽灵盔"}},
                {title = "三大陆", items = {"雷霆幻", "龙鳞震岳", "啸风逐电", "天罚雷击", "烈焰焚天", "霜雪之间"}},
                {title = "四大陆", items = {"雪隐残锋", "惊雷震世", "烬海残光", "苍穹寂灭", "月华流影", "傲霜孤"}},
                {title = "五大陆", items = {"深渊游行", "龙骨战魂", "★★寒鸦★★", "紫琅", "烬痕", "长夜メ"}},
                {title = "六大陆", items = {"天下太平", "封刃护生", "破军弑神", "碎星戮仙", "世事无常", "但求无悔"}},
                {title = "七大陆", items = {"玄武震天尊", "致命节奏", "熱翔", "东皇钟魂", "净世真言", "天恩圣符"}},
            },
        },
        ["全服孤品"] = {
            items = {"卍乱·阴阳卍", "卍锁·轮回卍", "卍斩·因果卍", "卍破·万法卍", "卍渎·神祁卍"}
        },
    }
    local function createEquipPreviewItem(parent, name, x, y, itemName)
        local itemIndex = SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)
        if not itemIndex or itemIndex <= 0 then
            return
        end
        local holder = GUI:Layout_Create(parent, name, x, y, 84, 106, false)
        local slotBg = GUI:Image_Create(holder, "slot_bg", 13, 34, "res/wy/public/58_58_kuang.png")
        GUI:setScale(slotBg, 1)
        local item = GUI:ItemShow_Create(holder, "item", 42, 63, {index = itemIndex, look = true, bgVisible = true})
        GUI:setAnchorPoint(item, 0.5, 0.5)
        GUI:setScale(item, 1)
        if GUI.ItemShow_setItemTouchSwallow then
            GUI:ItemShow_setItemTouchSwallow(item, true)
        end
        local text = GUI:Text_Create(holder, "name", 42, 2 + 10, 15, "#F7E7C4", itemName)
        GUI:setAnchorPoint(text, 0.5, 0)
        GUI:Text_enableOutline(text, "#1A120B", 2)
        -- GUI:Text_setTextAreaSize(text, {width = 82, height = 34})
        GUI:Text_setTextHorizontalAlignment(text, 1)
    end
    local function renderEquipPreviewPage(Label_node, page)
        local viewW, viewH = 584, 444
        local subIdx = (npc.strategy_sub_sign and npc.strategy_sub_sign[page.key]) or 1
        local sub = getSub(page, subIdx)
        local root = GUI:Layout_Create(Label_node, "equip_preview_root", 0, 0, viewW, viewH, false)
        GUI:Image_Create(root, "equip_preview_bg", 0, 0, sub.img)
        if sub.name == "装备分类" or sub.name == "追梦神器" then
            return
        end
        local cfg = equipPreviewData[sub.name]
        if not cfg then
            return
        end
        if cfg.groups then
            local scroll = GUI:ScrollView_Create(root, "equip_group_scroll", 14, 10, 556, 440, 2)
            GUI:ScrollView_setBounceEnabled(scroll, true)
            local groupWidth, groupHeight = 174, 314
            local gap = 8
            local innerW = math.max(556, #cfg.groups * (groupWidth + gap) + gap)
            GUI:ScrollView_setInnerContainerSize(scroll, innerW, 374)
            local titleColors = {"#FFD77B", "#7BE2FF", "#C792FF", "#7BFFA7", "#FF9E7B", "#FF7BC6", "#B7FF7B"}
            for i, group in ipairs(cfg.groups) do
                local gx = gap + (i - 1) * (groupWidth + gap)
                local panel = GUI:Layout_Create(scroll, "group_panel_" .. i, gx, 0, groupWidth, groupHeight, false)
                local panelBg = GUI:Image_Create(panel, "panel_bg", 0, 0, "res/wy/public/anniu_999_bj.png")
                GUI:setContentSize(panelBg, groupWidth, groupHeight + 50 + 40)
                local titleColor = titleColors[i] or "#FFD77B"
                local title = GUI:Text_Create(panel, "group_title_" .. i, groupWidth / 2, groupHeight - 24 + 70, 25, titleColor, group.title)
                GUI:setAnchorPoint(title, 0.5, 0.5)
                GUI:Text_setFontName(title, "fonts/502.ttf")
                GUI:Text_enableOutline(title, "#2C1708", 2)
                local line = GUI:Image_Create(panel, "line_" .. i, 18, groupHeight, "res/custom/strategy/list/fgx.png")
                GUI:setScaleX(line, 1.08)
                GUI:setScaleY(line, 1.05)
                for idx, itemName in ipairs(group.items or {}) do
                    local itemCol = (idx - 1) % 2
                    local itemRow = math.floor((idx - 1) / 2)
                    createEquipPreviewItem(panel, "group_item_" .. i .. "_" .. idx, 5 + itemCol * 82, 160 - itemRow * 88 + 40, itemName)
                end
            end
            return
        end
        -- local titleBg = GUI:Image_Create(root, "single_title_bg", 170, 382, "res/custom/strategy/title.png")
        -- GUI:setScale(titleBg, 0.92)
        -- local title = GUI:Text_Create(root, "single_title", viewW / 2, 410, 24, "#FFD77B", sub.name)
        -- GUI:setAnchorPoint(title, 0.5, 0.5)
        -- GUI:Text_enableOutline(title, "#3A220C", 2)
        local startX, startY = 78, 238
        for idx, itemName in ipairs(cfg.items or {}) do
            local col = (idx - 1) % 3
            local row = math.floor((idx - 1) / 3)
            SL:release_print("createEquipPreviewItem", row)
            createEquipPreviewItem(root, "equip_item_" .. idx, startX + col * 138 + (row == 1 and 67 or 0), startY - row * 126, itemName)
        end
    end
    local function renderMapPage(Label_node, page)
        local viewW, viewH = 584, 444
        GUI:Image_Create(Label_node, "map_bg", 0, 0, "res/custom/strategy/地图走法/地图走法背景.png")
        local mapInfo = getSub(page, (npc.strategy_sub_sign and npc.strategy_sub_sign[page.key]) or 1)
        npc.strategy_map_scale = npc.strategy_map_scale or 0.72
        npc.strategy_map_pos = npc.strategy_map_pos or {}
        local mapKey = tostring(page.key or "default")
        local dragLayer = GUI:Layout_Create(Label_node, "map_drag_layer", 0, 0, viewW, viewH, true)
        local function clampMapPos(posX, posY, imgW, imgH)
            local minX = math.min(0, viewW - imgW)
            local minY = math.min(0, viewH - imgH)
            local maxX = imgW > viewW and 0 or math.floor((viewW - imgW) / 2)
            local maxY = imgH > viewH and 0 or math.floor((viewH - imgH) / 2)
            posX = math.max(minX, math.min(maxX, posX or 0))
            posY = math.max(minY, math.min(maxY, posY or 0))
            return posX, posY
        end
        local function refreshMap()
            GUI:removeAllChildren(dragLayer)
            local scale = npc.strategy_map_scale or 0.32
            local imgW = math.floor((mapInfo.w or 1944) * scale)
            local imgH = math.floor((mapInfo.h or 1286) * scale)
            local cachePos = npc.strategy_map_pos[mapKey] or {}
            local posX, posY = clampMapPos(cachePos.x, cachePos.y, imgW, imgH)
            npc.strategy_map_pos[mapKey] = {x = posX, y = posY}
            local img = GUI:Image_Create(dragLayer, "map_img", posX, posY, mapInfo.img)
            GUI:setAnchorPoint(img, 0, 0)
            GUI:setScale(img, scale)
            GUI:setTouchEnabled(dragLayer, true)
            GUI:addOnTouchEvent(dragLayer, function(sender, eventType)
                if eventType == SLDefine.TouchEventType.began then
                    sender._drag_begin_touch = GUI:getTouchBeganPosition(sender)
                    sender._drag_begin_map = GUI:getPosition(img)
                elseif eventType == SLDefine.TouchEventType.moved then
                    local beginTouch = sender._drag_begin_touch
                    local beginMap = sender._drag_begin_map
                    local moveTouch = GUI:getTouchMovePosition(sender)
                    if beginTouch and beginMap and moveTouch then
                        local nextX = (beginMap.x or 0) + (moveTouch.x - beginTouch.x)
                        local nextY = (beginMap.y or 0) + (moveTouch.y - beginTouch.y)
                        nextX, nextY = clampMapPos(nextX, nextY, imgW, imgH)
                        GUI:setPosition(img, nextX, nextY)
                        npc.strategy_map_pos[mapKey] = {x = nextX, y = nextY}
                    end
                end
            end)
        end
        refreshMap()
        local tools = GUI:Layout_Create(Label_node, "map_tools", 370, 405, 200, 36, false)
        createScaleButton(tools, "zoom_out", -50, -400, "-", function()
            npc.strategy_map_scale = math.max(0.25, (npc.strategy_map_scale or 0.72) - 0.08)
            refreshMap()
        end)
        createScaleButton(tools, "zoom_reset", 40, -400, "复位", function()
            npc.strategy_map_scale = 0.72
            npc.strategy_map_pos[mapKey] = nil
            refreshMap()
        end)
        createScaleButton(tools, "zoom_in", 130, -400, "+", function()
            npc.strategy_map_scale = math.min(1.2, (npc.strategy_map_scale or 0.72) + 0.08)
            refreshMap()
        end)
    end
    local function GUI_createLabel(Label_node, idx)
        GUI:removeAllChildren(Label_node)
        local page = getPage(idx)
        if page.map then
            renderMapPage(Label_node, page)
        elseif page.key == "equip" then
            renderEquipPreviewPage(Label_node, page)
        else
            renderNormalPage(Label_node, page)
        end
    end
    local function UI_updata(node)
        GUI:removeAllChildren(node)
        npc.cbl_list = GUI:ListView_Create(node, "cbl_list", -5, 10, 170, 440, 1)
        GUI:ListView_setGravity(npc.cbl_list, 1)
        GUI:ListView_setItemsMargin(npc.cbl_list, 6)
        npc.Label = GUI:Node_Create(node, "Label", 170, 15)
        npc.titles_sign = npc.titles_sign or 1
        npc.strategy_sub_sign = npc.strategy_sub_sign or {}
        for i, page in ipairs(strategyPages) do
            local selectedMain = npc.titles_sign == i
            local cbl_item = createSideButton(npc.cbl_list, "main_" .. i, page.main, selectedMain, nil, function()
                npc.titles_sign = i
                npc.strategy_sub_sign[page.key] = npc.strategy_sub_sign[page.key] or 1
                UI_updata(node)
                GUI_createLabel(npc.Label, i)
            end)
            GUI:Image_Create(npc.cbl_list, "fgx" .. i, 0, 0, "res/custom/strategy/list/fgx.png")
            if selectedMain then
                -- GUI:Image_Create(cbl_item, "selected", -1, -2, "res/custom/strategy/左侧按钮/选中框.png")
            end
            if selectedMain and #(page.subs or {}) > 1 then
                for subIdx, sub in ipairs(page.subs) do
                    local selectedSub = (npc.strategy_sub_sign[page.key] or 1) == subIdx
                    local subBtn = createSideButton(npc.cbl_list, "sub_" .. i .. "_" .. subIdx, sub.name, selectedSub, "res/custom/strategy/左侧按钮/" .. (selectedSub and "亮" or "暗") .. "/游戏简介.png", function()
                        npc.strategy_sub_sign[page.key] = subIdx
                        UI_updata(node)
                        GUI_createLabel(npc.Label, i)
                    end)
                    GUI:setScale(subBtn, 0.82)
                    GUI:setPositionX(subBtn, 34)
                end
            end
        end
    end
    if p2 == 0 then
        npc.data_512 = not Data and {
        } or SL:JsonDecode(Data, false)
        local strategyWindow = ensureWindow("strategy", 512, {
            titleText = "游戏攻略",
        })
        npc.bg = strategyWindow.bg
        npc.node = strategyWindow.node
        GUI:setContentSize(GUI:Frames_Create(npc.bg, "eff1", 0, 0, "res/wy/eff/city/tongyong_0_dx_1_", ".png", 1, 45, {
            speed = 75,
            count = 45,
            loop = -1,
        }), GUI:getContentSize(npc.bg))
        GUI:setContentSize(GUI:Frames_Create(npc.bg, "eff2", 0, 0, "res/wy/eff/city/tongyong_0_dx_2_", ".png", 1, 45, {
            speed = 75,
            count = 45,
            loop = -1,
        }), GUI:getContentSize(npc.bg))
        GUI:removeAllChildren(npc.node)
        UI_updata(npc.node)
        GUI_createLabel(npc.Label, npc.titles_sign or 1)
    end
end
npc[514] = function(p2, p3, Data)
    local function storyNodeDone(node)
        if node == nil then
            return false
        end
        if type(node) == "number" then
            return tonumber(node) >= 2
        end
        if type(node) == "table" then
            if tonumber(node[1] or node["1"] or 0) >= 2 then
                return true
            end
            if tonumber(node.wc or node.finish or node.done or node.ok or 0) >= 1 then
                return true
            end
            if tonumber(node.cnt or node.num or 0) >= 2 then
                return true
            end
        end
        return false
    end
    local function hasThirdContinentHalfEntry()
        local raw = Player and Player.getServerVar and Player:getServerVar("T13") or ""
        if not raw or raw == "" then
            return false
        end
        local ok, storyData = pcall(function()
            return Player:JsonToTbl(raw)
        end)
        if not ok or type(storyData) ~= "table" then
            return false
        end
        return storyNodeDone(storyData["npc_46"])
    end
    local pos = {
        {
            100 + 123 - 58,
            100 + 267,
        },
        {
            200 + 211 - 58,
            100 + 354 - 90,
        },
        {
            600 - 48 - 58,
            100 + 363 - 90,
        },
        {
            600 - 48 - 58 + 80,
            100 + 363 - 90,
        },
        {
            300 - 196,
            100 + 91,
        },
        {
            500 - 212,
            100 + 91,
        },
        {
            400 + 79,
            100 + 91,
        },
        {
            400 + 79 + 100,
            100 + 91,
        },
    }
    local function worldMapGetRelevel()
        local zslv = tonumber(Player and Player.getServerVar and Player:getServerVar("U43") or 0) or 0
        if zslv <= 0 then
            zslv = tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0
        end
        return zslv
    end
    local function worldMapGetLevel()
        return tonumber(SL:GetMetaValue("LEVEL") or 0) or 0
    end
    local function worldMapGetTaskStoryPoint(task)
        local total = 0
        local rewards = type(task) == "table" and task.jl or nil
        if type(rewards) ~= "table" then
            return 0
        end
        for _, reward in ipairs(rewards) do
            if type(reward) == "table" and reward[1] == "剧情点" then
                total = total + (tonumber(reward[2]) or 0)
            end
        end
        return total
    end
    local _WORLD_MAP_EXTRA_PROGRESS_CHAPTERS = {
        ["苍云秘闻"] = true,
        ["若水秘闻"] = true,
        ["灵兽奥秘"] = true,
        ["灵虚秘闻"] = true,
    }
    local function worldMapShouldSkipProgressChapter(chapter)
        if type(chapter) ~= "table" then
            return false
        end
        return _WORLD_MAP_EXTRA_PROGRESS_CHAPTERS[tostring(chapter.name or "")] == true
    end
    local function worldMapGetStoryProgress(continent)
        local xylCfg = nil
        local ok, cfg = pcall(function()
            return SL:Require("GUILayout/Data/xyl.lua", true)
        end)
        if ok and type(cfg) == "table" then
            xylCfg = cfg
        end
        local chapters = type(xylCfg) == "table" and xylCfg[continent] or nil
        local ywl = {}
        local cached = rawget(_G, "XYL_YWL_CACHE")
        if type(cached) == "table" and next(cached) ~= nil then
            ywl = cached
        else
            local raw = Player and Player.getServerVar and Player:getServerVar("T26") or ""
            if raw ~= "" and Player and Player.JsonToTbl then
                local okJson, data = pcall(function()
                    return Player:JsonToTbl(raw)
                end)
                if okJson and type(data) == "table" then
                    ywl = data
                end
            end
        end
        local done = 0
        local total = 0
        if type(chapters) ~= "table" then
            return 0, 0
        end
        for chapterIdx, chapter in ipairs(chapters) do
            local skipTotal = worldMapShouldSkipProgressChapter(chapter)
            local tasks = type(chapter) == "table" and chapter.jq or nil
            if type(tasks) == "table" then
                local chapterKey = "jl_" .. continent .. "_" .. chapterIdx
                local chapterReceived = tonumber(ywl[chapterKey] or 0) == 1
                for taskIdx, task in ipairs(tasks) do
                    local point = worldMapGetTaskStoryPoint(task)
                    if not skipTotal then
                        total = total + point
                    end
                    local taskReceived = tonumber(ywl[chapterKey .. "_" .. taskIdx] or 0) == 1
                    if point > 0 and (chapterReceived or taskReceived) then
                        done = done + point
                    end
                end
            end
        end
        return done, total
    end
    local function worldMapStoryTarget(total, percent)
        total = tonumber(total) or 0
        if total <= 0 then
            return 0
        end
        return math.ceil(total * (tonumber(percent) or 100) / 100)
    end
    local function worldMapHasAllLinggen()
        local raw = Player and Player.getServerVar and Player:getServerVar("T41") or ""
        local data = {}
        if raw ~= "" and Player and Player.JsonToTbl then
            local ok, decoded = pcall(function()
                return Player:JsonToTbl(raw)
            end)
            if ok and type(decoded) == "table" then
                data = decoded
            end
        end
        local levels = type(data.level) == "table" and data.level or {}
        for idx = 1, 5 do
            if (tonumber(levels[tostring(idx)] or levels[idx]) or 0) < 1 then
                return false
            end
        end
        return true
    end
    local function worldMapHasAllDestiny()
        local raw = Player and Player.getServerVar and Player:getServerVar("T13") or ""
        local data = {}
        if raw ~= "" and Player and Player.JsonToTbl then
            local ok, decoded = pcall(function()
                return Player:JsonToTbl(raw)
            end)
            if ok and type(decoded) == "table" then
                data = decoded
            end
        end
        local state = type(data["npc_74"]) == "table" and data["npc_74"] or {}
        local cfg74 = type(teshudata) == "table" and teshudata["npc_74"] or {}
        local need = tonumber(cfg74 and cfg74.all) or 4
        return (tonumber(state.all) or 0) >= need
    end
    local function worldMapHasTitle(titleName)
        local itemIdx = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", titleName) or 0) or 0
        if itemIdx <= 0 then
            return false
        end
        return SL:GetMetaValue("TITLE_DATA_BY_ID", itemIdx) ~= nil
    end
    -- 世界地图大陆按钮：按客户端当前大陆解锁状态切换亮/灰两套贴图。
    local function isWorldMapContinentUnlocked(idx)
        local continent = tonumber(idx or 0) or 0
        if continent <= 1 then
            return true
        end
        local adminUnlock = cogin and cogin.sjtb and tonumber(cogin.sjtb.dl_all_unlock or 0) or 0
        if adminUnlock == 1 or adminUnlock >= continent then
            return true
        end
        if (tonumber(SL:GetMetaValue("RELEVEL") or 0) or 0) >= 70 and (tonumber(SL:GetMetaValue("LEVEL") or 0) or 0) >= 150 then
            return true
        end
        if continent == 4 then
            local done, total = worldMapGetStoryProgress(3)
            return done >= worldMapStoryTarget(total, 85) and worldMapGetRelevel() >= 30 and worldMapGetLevel() >= 150
        elseif continent == 5 then
            local done, total = worldMapGetStoryProgress(4)
            return done >= worldMapStoryTarget(total, 95) and worldMapGetRelevel() >= 40 and worldMapHasAllLinggen()
        elseif continent == 6 then
            local done, total = worldMapGetStoryProgress(5)
            return done >= worldMapStoryTarget(total, 95) and worldMapGetRelevel() >= 50 and worldMapHasAllDestiny()
        elseif continent == 7 then
            local done, total = worldMapGetStoryProgress(6)
            return done >= worldMapStoryTarget(total, 100) and worldMapGetRelevel() >= 60 and worldMapHasTitle("世界符文·[真我]")
        elseif continent == 8 then
            return worldMapGetRelevel() >= 70
        end
        if type(dl_sz) == "function" then
            return dl_sz(continent) == true
        end
        return true
    end
    local function renderWorldMap(node)
        GUI:removeAllChildren(node)
        local bg = GUI:Frames_Create(node, "bg", 0, 0, "res/custom/sjdt/eff/eff_", ".png", 1, 8, {
            speed = 75,
            count = 8,
            loop = -1,
        })
        GUI:setAnchorPoint(bg, 0.5, 0.5)
        for i = 1, 8 do
            local isUnlocked = isWorldMapContinentUnlocked(i)
            local skinState = isUnlocked and "l" or "n"
            local btn = GUI:Button_Create(bg, 'btn' .. i, pos[i][1], pos[i][2], 'res/custom/sjdt/dl/' .. skinState .. '/' .. i .. '.png')
            GUI:addOnClickEvent(btn, function()
                if not isUnlocked then
                    SL:ShowSystemTips("<font color='#FF0000'>还未达到进入条件，不能传送</font>")
                    return
                end
                if i == 3 then
                    if not hasThirdContinentHalfEntry() then
                        NPC_UI_HELPER.guochang_3()
                        return
                    end
                end
                if i == 7 then
                    SL:ShowSystemTips("<font color='#FF0000'>暂未开放</font>")
                    return
                end
                SL:SendLuaNetMsg(100, 500 + i, 1, 0, "")
            end)
        end
    end
    npc.refreshWorldMap = function()
        local win = npc._worldMapWin
        if win and win.node and not (tolua and tolua.isnull and tolua.isnull(win.node)) then
            renderWorldMap(win.node)
        end
    end
    if p2 == 0 then
        local win = ensureWindow("worldMap", 514, {
            titleText = "世界地图",
        })
        npc._worldMapWin = win
        renderWorldMap(win.node)
    end
end
npc[515] = function(p2, p3, Data)
    return Npclib["anniu_515"].main(515, p2, p3, Data)
end
npc[516] = function(p2, p3, Data)
    local function mfzz_get_details()
        return (teshudata["anniu_516"] and teshudata["anniu_516"].details) or {
        }
    end
    local function mfzz_decode(data)
        if type(data) == "string" and data ~= "" then
            return SL:JsonDecode(data, false) or {
            }
        end
        return type(data) == "table" and data or {
        }
    end
    local function mfzz_get_data()
        npc.data_516 = npc.data_516 or {
        }
        npc.data_516.T_data = npc.data_516.T_data or {
        }
        return npc.data_516
    end
    local function mfzz_is_claimed(idx)
        local tData = mfzz_get_data().T_data or {
        }
        local v = tData["zzlb_" .. idx]
        return v == true or tonumber(v or 0) == 1
    end
    local function mfzz_is_cz502_claimed(amount)
        local tData = npc.data_502 and npc.data_502.T_data or {
        }
        local v = tData["cz502_" .. tostring(amount or 0)]
        return v == true or tonumber(v or 0) == 1
    end
    local function mfzz_get_cz502_requirement(cfg)
        cfg = cfg or {
        }
        local needIdx = tonumber(cfg.need_cz502_idx or 0) or 0
        if needIdx > 0 then
            local rechargeList = (teshudata["anniu_502"] and teshudata["anniu_502"].fj) or {
            }
            return tonumber(rechargeList[needIdx] or 0) or 0, needIdx
        end
        return tonumber(cfg.need_cz502 or 0) or 0, 0
    end
    local function mfzz_has_pay21(amount)
        local tData = mfzz_get_data().T_data or {
        }
        local v = tData["pay21_" .. tostring(amount or 0)]
        return v == true or tonumber(v or 0) == 1
    end
    local function mfzz_get_reward_list(cfg)
        local ret = {
        }
        local function appendReward(src)
            if type(src) ~= "table" then
                return
            end
            if type(src[1]) == "table" then
                for _, item in ipairs(src) do
                    local itemName = tostring(item[1] or "")
                    local itemCount = tonumber(item[2] or 1) or 1
                    if itemName ~= "" then
                        ret[#ret + 1] = {
                            itemName,
                            itemCount,
                        }
                    end
                end
            elseif type(src[1]) == "string" then
                local itemName = tostring(src[1] or "")
                local itemCount = tonumber(src[2] or 1) or 1
                if itemName ~= "" then
                    ret[#ret + 1] = {
                        itemName,
                        itemCount,
                    }
                end
            end
        end
        local titleName = tostring((cfg or {
        }).ch or "")
        if titleName ~= "" then
            ret[#ret + 1] = {
                titleName .. "[称号]",
                1,
            }
        end
        for _, extraTitle in ipairs((cfg or {}).extra_titles or {}) do
            extraTitle = tostring(extraTitle or "")
            if extraTitle ~= "" then
                ret[#ret + 1] = {
                    extraTitle .. "[称号]",
                    1,
                }
            end
        end
        appendReward(cfg and cfg.jl)
        return ret
    end
    local function mfzz_get_condition_info(cfg)
        cfg = cfg or {
        }
        local needCz502, needCz502Idx = mfzz_get_cz502_requirement(cfg)
        local needPay21 = tonumber(cfg.need_pay21 or 0) or 0
        local needMoney23 = tonumber(cfg.need_money23 or 0) or 0
        local needRealCharge = tonumber(cfg.need_real_charge or 0) or 0
        local needCharge = tonumber(cfg.need_charge or cfg.sgsl or 0) or 0
        local autoPay = tonumber(cfg.auto_pay or 0) or 0
        local curData = mfzz_get_data()
        local totalCharge = tonumber(curData.charge or curData.sgsl or 0) or 0
        local realCharge = tonumber(curData.real_charge or 0) or 0
        local charge23 = tonumber(curData.money23 or 0) or 0
        if needCz502 > 0 then
            if needCz502Idx > 0 then
                return string.format("需要：领取第%s档在线充值礼包", tostring(needCz502Idx)), mfzz_is_cz502_claimed(needCz502), true
            end
            return string.format("需要：领取%s档在线充值礼包", tostring(needCz502)), mfzz_is_cz502_claimed(needCz502), true
        end
        if needPay21 > 0 then
            local ok = mfzz_has_pay21(needPay21)
            if ok then
                return string.format("已购买", tostring(needPay21)), true, false
            end
            return string.format("%s元礼包", tostring(autoPay > 0 and autoPay or needPay21)), false, false
        end
        if autoPay > 0 and needMoney23 <= 0 and needRealCharge <= 0 and needCharge <= 0 then
            return string.format("%s元礼包", tostring(autoPay)), false, false
        end
        if needMoney23 > 0 then
            return string.format("充值%s元", tostring(needMoney23)), charge23 >= needMoney23, false
        end
        if needRealCharge > 0 then
            return string.format("真实充值%s元", tostring(needRealCharge)), realCharge >= needRealCharge, false
        end
        if needCharge > 0 then
            return string.format("充值%s元", tostring(needCharge)), totalCharge >= needCharge, false
        end
        return "免费领取", true, false
    end
    local function mfzz_can_claim(idx, cfg)
        if not cfg or mfzz_is_claimed(idx) then
            return false
        end
        if idx > 1 and not mfzz_is_claimed(idx - 1) then
            return false
        end
        local _, ok = mfzz_get_condition_info(cfg)
        return ok
    end
    local function mfzz_try_start_mainline_guide(button, guideParent, idx)
        if tonumber(idx or 0) ~= 1 then
            return false
        end
        return NPC_UI_HELPER.tryStartMainlineUpgradeGuide(npc, button, guideParent, 516, idx, {
            dir = 5,
            taskMap = {
                [516] = 4,
            },
            desc = "点击领取",
            isForce = true,
            hideMask = false,
            keyPrefix = "mainline_free_sponsor",
        })
    end
    local function mfzz_render_item(parent, itemName, itemCount, posX, posY, key)
        local slot = GUI:Image_Create(parent, "slot_" .. tostring(key), posX, posY, "dev/res/wy/public/40-42.png")
        _add_reward_item_effect(slot, "reward_eff", 20, 21, 0.85, REWARD_ITEM_EFFECT_14193)
        GUI:setAnchorPoint(slot, 0.5, 0.5)
        local itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", itemName)) or 0
        if itemIndex <= 0 and not string.find(tostring(itemName), "%[称号%]") then
            itemIndex = tonumber(SL:GetMetaValue("ITEM_INDEX_BY_NAME", tostring(itemName) .. "[称号]")) or 0
        end
        local itemLayer = _get_reward_item_layer(slot) or slot
        if itemIndex > 0 then
            local itemShow = GUI:ItemShow_Create(itemLayer, "item", 20, 21, {
                index = itemIndex,
                look = true,
            })
            GUI:setAnchorPoint(itemShow, 0.5, 0.5)
            _raise_reward_item_icon(slot)
            
        end
        if tonumber(itemCount or 0) > 1 then
            local countText = GUI:Text_Create(itemLayer, "count", 20, 3, 13, "#FFFFFF", SL:GetSimpleNumber(itemCount, 0))
            GUI:setAnchorPoint(countText, 0.5, 0)
            GUI:Text_enableOutline(countText, "#000000", 1)
            _raise_reward_count_text(countText)
        end
    end
    local function mfzz_render_card(node, idx, cfg)
        local posList = {
            [1] = {
                x = 107 + 25,
                y = 64 + 30,
            },
            [2] = {
                x = 362,
                y = 64 + 30,
            },
            [3] = {
                x = 616 - 24,
                y = 64 + 30,
            },
        }
        local cardPos = posList[idx] or posList[1]
        local card = GUI:Layout_Create(node, "card_" .. idx, cardPos.x, cardPos.y, 165, 320)
        GUI:setAnchorPoint(card, 0, 0)
        local rewardList = mfzz_get_reward_list(cfg)
        local function getRewardGridPos(index, total)
            local maxPerRow = 3
            local gap = 55
            local centerX = 84
            local startY = 118
            local rowGap = 42
            local row = math.floor((index - 1) / maxPerRow)
            local col = (index - 1) % maxPerRow
            local rowStart = row * maxPerRow + 1
            local rowCount = math.min(maxPerRow, total - rowStart + 1)
            local rowWidth = (rowCount - 1) * gap
            return centerX - rowWidth / 2 + col * gap, startY - row * rowGap
        end
        local showCount = math.min(#rewardList, 6)
        for j = 1, showCount do
            local itemX, itemY = getRewardGridPos(j, showCount)
            mfzz_render_item(card, rewardList[j][1], rewardList[j][2], itemX, itemY, idx .. "_" .. j)
        end
        -- local detailDesc = tostring(cfg and cfg.desc or "")
        -- if detailDesc ~= "" then
        --     local descRich = GUI:RichText_Create(card, "detail_desc", 84, 182, string.format("<font color='#ffefbf'>%s</font>", detailDesc), 150, 14, "#f7f7de", 0, nil, nil, {
        --         outlineSize = 1,
        --         outlineColor = "#000000",
        --     })
        --     GUI:setAnchorPoint(descRich, 0.5, 1)
        -- end
        local conditionText, conditionOk, needQuestion = mfzz_get_condition_info(cfg)
        local conditionColor = conditionOk and "#57ff8d" or "#ff4636"
        local conditionRich = nil
        if idx == 2 then
            conditionRich = GUI:RichText_Create(card, "condition", 95 + 13, 70, string.format("<font color='%s'>%s</font>", conditionColor, conditionText), 150, 16, "#f7f7de", 0, nil, nil, {
                outlineSize = 1,
                outlineColor = "#000000",
            })
            GUI:setAnchorPoint(conditionRich, 0.5, 0.5)
        end
        if needQuestion then
            local question = GUI:Button_Create(card, "question", 140, 58, "res/custom/mfzz/question.png")
            GUI:setAnchorPoint(question, 0.5, 0.5)
            GUI:addOnClickEvent(question, function()
                SL:SendLuaNetMsg(101, 502, 0, 0, "")
            end)
        end
        if mfzz_is_claimed(idx) then
            local stateImg = GUI:Image_Create(card, "Button", 84, 6, "res/wy/public/9.png")
            GUI:setAnchorPoint(stateImg, 0.5, 0)
        else
            local button = GUI:Button_Create(card, "Button", 84, 2, "res/custom/mfzz/claim.png")
            GUI:setAnchorPoint(button, 0.5, 0)
            GUI:addOnClickEvent(button, function()
                SL:SendLuaNetMsg(101, 516, 1, idx, "")
            end)
            mfzz_try_start_mainline_guide(button, node, idx)
            if mfzz_can_claim(idx, cfg) then
                NPC_UI_HELPER.redpoint_create(button, {
                    x = 148,
                    y = 35,
                })
            end
        end
    end
    local function UI_updata(node)
        if not node then
            return
        end
        GUI:removeAllChildren(node)
        local curData = mfzz_get_data()
        local totalCharge = tonumber(curData.charge or curData.sgsl or 0) or 0
        local charge23 = tonumber(curData.money23 or 0) or 0
        for idx, cfg in ipairs(mfzz_get_details()) do
            mfzz_render_card(node, idx, cfg)
        end
    end
    if p2 == 0 then
        npc.data_516 = mfzz_decode(Data)
        npc.data_516.T_data = npc.data_516.T_data or {
        }
        local win = ensureWindow("freeSponsor", 516, {
            titleText = "至尊赞助",
        })
        npc.node_516 = win.node
        UI_updata(npc.node_516)
    elseif p2 == 1 then
        local newData = mfzz_decode(Data)
        if next(newData or {
        }) then
            npc.data_516 = newData
        else
            npc.data_516 = mfzz_get_data()
            npc.data_516.T_data["zzlb_" .. tostring(p3 or 0)] = 1
        end
        npc.data_516.T_data = npc.data_516.T_data or {
        }
        if npc.node_516 then
            UI_updata(npc.node_516)
        end
    end
end
-- 顶部按钮聚宝盆入口：独立功能界面，NPC 106 只保留主线修复任务界面。
npc[517] = function(p2, p3, Data)
    npc._anniu_517_mod = npc._anniu_517_mod or package.loaded["GUILayout/npc/anniu_517"] or SL:Require("GUILayout/npc/anniu_517.lua", true)
    local mod = npc._anniu_517_mod
    if mod and type(mod.main) == "function" then
        mod.main(517, p2, p3, Data)
    end
end
local xlxl = {
    {
        "金币",
        "元宝",
        "绑定金币",
        "绑定元宝",
        "灵石",
        "绑定灵石",
        "累计充值",
        "礼包积分",
        "一合充值",
        "二合充值",
        "三合后充值",
    },
    {
        "充值10",
        "充值30",
        "充值68",
        "充值128",
        "充值198",
        "充值328",
        "充值648",
        "充值998",
    },
    {
        {
            "个人变量",
            105,
            178,
        },
        {
            "个人标识",
            225,
            178,
        },
        {
            "个人Buff",
            105,
            144,
        },
        {
            "全局变量",
            225,
            144,
        },
    },
    {
        "超级特权",
        "前三天首充",
        "三天后首充",
        "18礼包",
    },
}
npc[998] = function(p2, p3, Data)
    local parent = GUI:GetWindow(nil, "npc_hhhh")
    npc.data_998 = not Data and {
    } or SL:JsonDecode(Data, false)
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_hhhh", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, true, true, 0, 1)
    end
    npc.bg = GUI:Image_Create(parent, "img_bj", 0.0, 0.0, "res/wy/public/jiaozhu_0.png")
    GUI:setAnchorPoint(npc.bg, 0.5, 0.5)
    GUI:setTouchEnabled(npc.bg, true)
    GUI:Timeline_Window3(npc.bg)
    local close = GUI:Button_Create(npc.bg, 'close', 970, 550, 'res/wy/public/close_red_big.png')
    GUI:addOnClickEvent(close, function()
        GUI:Win_Close(parent)
    end)
    local ImageView = GUI:Image_Create(npc.bg, "ImageView", 118.0, 495.0, "res/wy/public/input.png")
    local mingzi_sr = GUI:TextInput_Create(ImageView, "mingzi_sr", 0.0, 0.0, 155.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(mingzi_sr, "玩家名字")
    GUI:setTouchEnabled(mingzi_sr, true)
    local an_mz = GUI:Button_Create(npc.bg, "an_mz", 293.0, 493.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_mz, "是否在线")
    GUI:Button_setTitleColor(an_mz, "#28ef01")
    GUI:Button_setTitleFontSize(an_mz, 14)
    GUI:Button_titleEnableOutline(an_mz, "#000000", 1)
    local an_txx, han_zb = {
    }, {
        {
            493,
            "踢下线",
        },
        {
            440,
            "加入列表",
        },
        {
            383,
            "去除列表",
        },
        {
            323,
            "显示列表",
        },
    }
    for i, v in ipairs(han_zb) do
        an_txx[i] = GUI:Button_Create(npc.bg, "an_txx" .. i, 410.0, v[1], "res/public/1900000660.png")
        GUI:Button_setTitleText(an_txx[i], v[2])
        GUI:Button_setTitleColor(an_txx[i], "#ff0500")
        GUI:Button_setTitleFontSize(an_txx[i], 14)
        GUI:Button_titleEnableOutline(an_txx[i], "#000000", 1)
    end
    local an_huobi = GUI:Image_Create(npc.bg, "an_huobi", 120.0, 445.0, "res/wy/public/input.png")
    local Text_huobi = GUI:Text_Create(an_huobi, "Text_huobi", 71.0, 14.0, 16, "#ffffff", [[货币种类]])
    GUI:setAnchorPoint(Text_huobi, 0.5, 0.5)
    GUI:Text_enableOutline(Text_huobi, "#000000", 1)
    GUI:setTouchEnabled(an_huobi, true)
    GUI:addOnClickEvent(an_huobi, function()
        local zb = GUI:getWorldPosition(an_huobi)
        SL:OpenSelectListUI(xlxl[1], {
            x = zb.x,
            y = zb.y,
        }, 156, 30, function(iiid)
            GUI:Text_setString(Text_huobi, xlxl[1][iiid])
        end)
    end)
    local ImageView_1 = GUI:Image_Create(npc.bg, "ImageView_1", 118.0, 355.0, "res/wy/public/input.png")
    local huobi_sr = GUI:TextInput_Create(ImageView_1, "huobi_sr", 0.0, 0.0, 155.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(huobi_sr, "修改数值")
    GUI:setTouchEnabled(huobi_sr, true)
    local an_huobicha = GUI:Button_Create(npc.bg, "an_huobicha", 293.0, 440.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_huobicha, "货币查询")
    GUI:Button_setTitleColor(an_huobicha, "#28ef01")
    GUI:Button_setTitleFontSize(an_huobicha, 14)
    GUI:Button_titleEnableOutline(an_huobicha, "#000000", 1)
    GUI:setTouchEnabled(an_huobicha, true)
    local an_huobigai = GUI:Button_Create(npc.bg, "an_huobigai", 293.0, 383.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_huobigai, "货币修改")
    GUI:Button_setTitleColor(an_huobigai, "#28ef01")
    GUI:Button_setTitleFontSize(an_huobigai, 14)
    GUI:Button_titleEnableOutline(an_huobigai, "#000000", 1)
    GUI:setTouchEnabled(an_huobigai, true)
    local an_hbzj = GUI:Button_Create(npc.bg, "an_hbzj", 293.0, 323.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_hbzj, "货币增加")
    GUI:Button_setTitleColor(an_hbzj, "#28ef01")
    GUI:Button_setTitleFontSize(an_hbzj, 14)
    GUI:Button_titleEnableOutline(an_hbzj, "#000000", 1)
    GUI:setTouchEnabled(an_hbzj, true)
    local an_libao = GUI:Image_Create(npc.bg, "an_libao", 550.0, 495.0, "res/wy/public/input.png")
    local Text_libao = GUI:Text_Create(an_libao, "Text_libao", 75.0, 15.0, 16, "#ffffff", [[礼包种类]])
    GUI:setAnchorPoint(Text_libao, 0.5, 0.5)
    GUI:Text_enableOutline(Text_libao, "#000000", 1)
    GUI:setTouchEnabled(an_libao, true)
    GUI:addOnClickEvent(an_libao, function()
        local zb = GUI:getWorldPosition(an_libao)
        SL:OpenSelectListUI(xlxl[2], {
            x = zb.x,
            y = zb.y,
        }, 156, 30, function(iiid)
            GUI:Text_setString(Text_libao, xlxl[2][iiid])
        end)
    end)
    local an_lb = GUI:Button_Create(npc.bg, "an_lb", 724.0, 491.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb, "增加礼包")
    GUI:Button_setTitleColor(an_lb, "#00ffff")
    GUI:Button_setTitleFontSize(an_lb, 14)
    GUI:Button_titleEnableOutline(an_lb, "#000000", 1)
    GUI:setTouchEnabled(an_lb, true)
    local function showErrorTip(msg)
        SL:ShowSystemTips(string.format("<outline color='#000000' size='1'><font color='#FF0000'>%s</font></outline>", msg))
    end
    local function requirePlayerName()
        local name = GUI:TextInput_getString(mingzi_sr)
        if name == "" then
            showErrorTip("请正确输入玩家名字")
            return nil
        end
        return name
    end
    local function requireSelection(labelWidget, placeholder, tip)
        local text = GUI:Text_getString(labelWidget)
        if text == placeholder or text == "" then
            showErrorTip(tip)
            return nil
        end
        return text
    end
    local function requireNumber(inputWidget, tip)
        local value = tonumber(GUI:TextInput_getString(inputWidget))
        if not value then
            showErrorTip(tip or "请输入数字")
            return nil
        end
        return value
    end
    local function findIndexByLabel(list, label)
        for index, text in ipairs(list) do
            if text == label then
                return index
            end
        end
        return nil
    end
    local function handleCurrencyOp(opCode)
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local amount = requireNumber(huobi_sr, "请输入数量")
        if not amount then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101, 998, 1, opCode, string.format('{"mz":"%s","hb":%d,"sl":%d}', name, currencyId, amount))
    end
    local function handleGiftAdd()
        local name = requirePlayerName()
        if not name then
            return
        end
        local giftName = requireSelection(Text_libao, "礼包种类", "请正确选择礼包种类")
        if not giftName then
            return
        end
        local giftId = findIndexByLabel(xlxl[2], giftName)
        SL:release_print(giftId)
        SL:release_print(giftName)
        if not giftId then
            showErrorTip("未知礼包类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101, 998, 1, 4, string.format('{"mz":"%s","hb":%d}', name, giftId))
    end
    GUI:addOnClickEvent(an_mz, function()
        local name = requirePlayerName()
        if name then
            SL:SendLuaNetMsg(101, 998, 1, 0, name)
        end
    end)
    for i, btn in ipairs(an_txx) do
        GUI:addOnClickEvent(btn, function()
            if i == 4 then
                SL:SendLuaNetMsg(101, 998, 4, i, "")
                return
            end
            local name = requirePlayerName()
            if not name then
                return
            end
            SL:SendLuaNetMsg(101, 998, 4, i, name)
        end)
    end
    GUI:addOnClickEvent(an_huobicha, function()
        local name = requirePlayerName()
        if not name then
            return
        end
        local currencyName = requireSelection(Text_huobi, "货币种类", "请正确选择货币名字")
        if not currencyName then
            return
        end
        local currencyId = findIndexByLabel(xlxl[1], currencyName)
        if not currencyId then
            showErrorTip("未知货币类型，请重新选择")
            return
        end
        SL:SendLuaNetMsg(101, 998, 1, 1, string.format('{"mz":"%s","hb":%d}', name, currencyId))
    end)
    GUI:addOnClickEvent(an_huobigai, function()
        handleCurrencyOp(2)
    end)
    GUI:addOnClickEvent(an_hbzj, function()
        handleCurrencyOp(3)
    end)
    GUI:addOnClickEvent(an_lb, function()
        handleGiftAdd()
    end)
    local an_libao_ts = GUI:Image_Create(npc.bg, "an_libao_ts", 550.0, 455.0, "res/wy/public/input.png")
    local Text_libao_ts = GUI:Text_Create(an_libao_ts, "Text_libao_ts", 75.0, 15.0, 16, "#ffffff", [[礼包种类]])
    GUI:setAnchorPoint(Text_libao_ts, 0.5, 0.5)
    GUI:Text_enableOutline(Text_libao_ts, "#000000", 1)
    GUI:setTouchEnabled(an_libao_ts, true)
    GUI:addOnClickEvent(an_libao_ts, function()
        local zb = GUI:getWorldPosition(an_libao_ts)
        SL:OpenSelectListUI(xlxl[4], {
            x = zb.x,
            y = zb.y,
        }, 156, 30, function(iiid)
            GUI:Text_setString(Text_libao_ts, xlxl[4][iiid])
        end)
    end)
    local huobi_sr_je = GUI:TextInput_Create(npc.bg, "huobi_sr_je", 550.0, 411.0, 115, 30.0, 16)
    GUI:TextInput_setPlaceHolder(huobi_sr_je, "金额")
    GUI:setTouchEnabled(huobi_sr_je, true)
    local an_lb_ts_je = GUI:Button_Create(npc.bg, "an_lb_ts_je", 724.0, 411.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts_je, "金额充值")
    GUI:addOnClickEvent(an_lb_ts_je, function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 5, 0, '{"mz":"' .. mz .. '","hb":' .. GUI:TextInput_getString(huobi_sr_je) .. '}')
        end
    end)
    local an_lb_ts = GUI:Button_Create(npc.bg, "an_lb_ts", 724.0, 451.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_lb_ts, "增加礼包(特殊)")
    GUI:Button_setTitleColor(an_lb_ts, "#00ffff")
    GUI:Button_setTitleFontSize(an_lb_ts, 14)
    GUI:Button_titleEnableOutline(an_lb_ts, "#000000", 1)
    GUI:setTouchEnabled(an_lb_ts, true)
    GUI:addOnClickEvent(an_lb_ts, function()
        local mz = GUI:TextInput_getString(mingzi_sr)
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        else
            local hb = GUI:Text_getString(Text_libao_ts)
            if hb == "礼包种类" or hb == "" then
                SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确选择礼包种类</font></outline>")
            else
                local id = 0
                for k, v in pairs(xlxl[4]) do
                    if v == hb then
                        id = k
                    end
                end
                SL:SendLuaNetMsg(101, 998, 1, 5, '{"mz":"' .. mz .. '","hb":' .. id .. '}')
            end
        end
    end)
    local ImageView_2_1 = GUI:Image_Create(npc.bg, "ImageView_2_1", 91.0, 261.0, "res/wy/public/input.png")
    local wpmz_sr = GUI:TextInput_Create(ImageView_2_1, "wpmz_sr", 0.0, 0.0, 155.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(wpmz_sr, "物品名称")
    local ImageView_2_1_1 = GUI:Image_Create(npc.bg, "ImageView_2_1_1", 258.0, 261.0, "res/wy/public/input.png")
    GUI:setContentSize(ImageView_2_1_1, 50, 31)
    local wpsl_sr = GUI:TextInput_Create(ImageView_2_1_1, "wpsl_sr", 0.0, 0.0, 50.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(wpsl_sr, "数量")
    local CheckBox_wp = GUI:CheckBox_Create(ImageView_2_1_1, "CheckBox_wp", 76.0, 4.0, "res/public/1900000550.png", "res/public/1900000551.png")
    GUI:CheckBox_setSelected(CheckBox_wp, false)
    GUI:setTouchEnabled(CheckBox_wp, true)
    local Text = GUI:Text_Create(CheckBox_wp, "Text", 33.0, 3.0, 16, "#ffffff", [[勾选后绑定]])
    GUI:Text_enableOutline(Text, "#000000", 1)
    local an_wpk = GUI:Button_Create(npc.bg, "an_wpk", 95.0, 210.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpk, "增加")
    GUI:Button_setTitleColor(an_wpk, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpk, 14)
    GUI:Button_titleEnableOutline(an_wpk, "#000000", 1)
    GUI:addOnClickEvent(an_wpk, function()
        local mz, wp, sl = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(wpmz_sr), tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            local zt = 0
            if GUI:CheckBox_isSelected(CheckBox_wp) then
                zt = 1
            else
                zt = 0
            end
            SL:SendLuaNetMsg(101, 998, 2, 1, '{"mz":"' .. mz .. '","wp":"' .. wp .. '","sl":' .. sl .. ',"lx":' .. zt .. '}')
        end
    end)
    local an_wpj = GUI:Button_Create(npc.bg, "an_wpj", 232.0, 210.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "扣除")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj, function()
        local mz, wp, sl = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(wpmz_sr), tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 2, 2, '{"mz":"' .. mz .. '","wp":"' .. wp .. '","sl":' .. sl .. '}')
        end
    end)
    local an_wpj = GUI:Button_Create(npc.bg, "an_wpfs", 369.0, 210.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_wpj, "发射")
    GUI:Button_setTitleColor(an_wpj, "#00ffff")
    GUI:Button_setTitleFontSize(an_wpj, 14)
    GUI:Button_titleEnableOutline(an_wpj, "#000000", 1)
    GUI:addOnClickEvent(an_wpj, function()
        local mz, wp, sl = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(wpmz_sr), tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入物品名字</font></outline>")
        elseif not sl then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入数量</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 2, 3, '{"mz":"' .. mz .. '","wp":"' .. wp .. '","sl":' .. sl .. '}')
        end
    end)
    local an_ch = GUI:Button_Create(npc.bg, "an_chfs", 500.0, 210.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_ch, "发送或者收回称号")
    GUI:Button_setTitleColor(an_ch, "#00ffff")
    GUI:Button_setTitleFontSize(an_ch, 14)
    GUI:Button_titleEnableOutline(an_ch, "#000000", 1)
    GUI:addOnClickEvent(an_ch, function()
        local mz, wp, sl = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(wpmz_sr), tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif wp == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入称号名字</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 2, 4, '{"mz":"' .. mz .. '","ch":"' .. wp .. '"}')
        end
    end)
    local an_sbk = GUI:Button_Create(npc.bg, "an_sbk", 630.0, 210.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_sbk, "设置沙巴克归属,名字处填入行会名")
    GUI:Button_setTitleColor(an_sbk, "#00ffff")
    GUI:Button_setTitleFontSize(an_sbk, 14)
    GUI:Button_titleEnableOutline(an_sbk, "#000000", 1)
    GUI:addOnClickEvent(an_sbk, function()
        local mz, wp, sl = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(wpmz_sr), tonumber(GUI:Text_getString(wpsl_sr))
        if mz == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入行会名</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 2, 5, '{"mz":"' .. mz .. '","wp":"' .. wp .. '"}')
        end
    end)
    local bl_fxk = {
    }
    for i, v in ipairs(xlxl[3]) do
        bl_fxk[i] = GUI:CheckBox_Create(npc.bg, "bl_fxk_" .. i, v[2], v[3], "res/public/1900000550.png", "res/public/1900000551.png")
        GUI:CheckBox_setSelected(bl_fxk[i], false)
        GUI:setTouchEnabled(bl_fxk[i], true)
        local Text = GUI:Text_Create(bl_fxk[i], "Text", 33.0, 3.0, 16, "#ffffff", v[1])
        GUI:Text_enableOutline(Text, "#000000", 1)
        GUI:CheckBox_addOnEvent(bl_fxk[i], function(self)
            GUI:CheckBox_setSelected(bl_fxk[1], i == 1)
            GUI:CheckBox_setSelected(bl_fxk[2], i == 2)
            GUI:CheckBox_setSelected(bl_fxk[3], i == 3)
            GUI:CheckBox_setSelected(bl_fxk[4], i == 4)
        end)
    end
    GUI:CheckBox_setSelected(bl_fxk[1], true)
    local blmz = GUI:Image_Create(npc.bg, "blmz", 99.0, 98.0, "res/wy/public/input.png")
    GUI:setContentSize(blmz, 100, 31)
    local bianliang_sr = GUI:TextInput_Create(blmz, "bianliang_sr", 0.0, 0.0, 100.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(bianliang_sr, "变量名")
    local bl_xg = GUI:Image_Create(npc.bg, "bl_xg", 236.0, 98.0, "res/wy/public/input.png")
    GUI:setContentSize(bl_xg, 100, 31)
    local bianliang_xg = GUI:TextInput_Create(bl_xg, "bianliang_xg", 0.0, 0.0, 100.0, 30.0, 16)
    GUI:TextInput_setPlaceHolder(bianliang_xg, "修改值")
    local an_blc = GUI:Button_Create(npc.bg, "an_blc", 95.0, 44.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_blc, "查询")
    GUI:Button_setTitleColor(an_blc, "#00ffff")
    GUI:Button_setTitleFontSize(an_blc, 14)
    GUI:Button_titleEnableOutline(an_blc, "#000000", 1)
    GUI:addOnClickEvent(an_blc, function()
        local mz, bl, lx = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(bianliang_sr), 0
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 3, 1, '{"mz":"' .. mz .. '","bl":"' .. bl .. '","lx":' .. lx .. '}')
        end
    end)
    local an_blg = GUI:Button_Create(npc.bg, "an_blg", 232.0, 44.0, "res/public/1900000660.png")
    GUI:Button_setTitleText(an_blg, "修改")
    GUI:Button_setTitleColor(an_blg, "#00ffff")
    GUI:Button_setTitleFontSize(an_blg, 14)
    GUI:Button_titleEnableOutline(an_blg, "#000000", 1)
    GUI:addOnClickEvent(an_blg, function()
        local mz, bl, lx, zhi = GUI:TextInput_getString(mingzi_sr), GUI:Text_getString(bianliang_sr), 0, GUI:Text_getString(bianliang_xg)
        for i = 1, 4, 1 do
            if GUI:CheckBox_isSelected(bl_fxk[i]) then
                lx = i
                break
            end
        end
        if mz == "" and lx ~= 4 then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入玩家名字</font></outline>")
        elseif bl == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入变量名字</font></outline>")
        elseif zhi == "" then
            SL:ShowSystemTips("<outline color='#000000' size='1'><font color='#FF0000'>请正确输入修改值</font></outline>")
        else
            SL:SendLuaNetMsg(101, 998, 3, 2, '{"mz":"' .. mz .. '","bl":"' .. bl .. '","lx":' .. lx .. ',"zhi":' .. zhi .. '}')
        end
    end)
end
npc[1000] = function(p2, p3, Data)
end
npc[1002] = function(p2, p3, msgData)
    local parent = GUI:GetWindow(nil, "npc_qhdt")
    if parent then
        GUI:removeAllChildren(parent)
        GUI:setPosition(parent, cogin.w / 2, cogin.h / 2)
    else
        parent = GUI:Win_Create("npc_qhdt", cogin.w / 2, cogin.h / 2, 0, 0, false, false, true, false, true, 0, 1)
    end
    local bjt = GUI:Image_Create(parent, "bjt", 0, 0, "res/public/1900000651_1.png")
    GUI:setAnchorPoint(bjt, 0.5, 0.5)
    GUI:setContentSize(bjt, cogin.w + 100, cogin.h + 100)
    local bg = GUI:Image_Create(bjt, "bg", cogin.w - 200, cogin.h / 2 + 50, "res/wy/public/dtxs/" .. msgData .. ".png")
    GUI:setAnchorPoint(bg, 0.5, 0.5)
    GUI:Timeline_FadeOut(bjt, 1)
    GUI:Timeline_FadeOut(bg, 2)
end
npc[1004] = function(p2, p3, msgData)
    cogin.onther_shuju = SL:JsonDecode(msgData, false)
    cogin.onther_zdl = cogin.onther_shuju.zdl
    SL:RequestLookPlayer("" .. cogin.onther_shuju.userid, true)
end
npc[1005] = function(p2, p3, msgData)
    UiTools.playSucAnimation(msgData)
end
npc[9999] = function(p2, p3, msgData)
    local parent = GUI:GetWindow(nil, msgData)
    if parent then
        GUI:Win_Close(parent)
    end
end
return npc





