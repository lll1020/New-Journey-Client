local ssrEventCfg = {}

-----------------------------------引擎事件-----------------------------------
ssrEventCfg.onDisconnect                    = "onDisconnect"                    --断线
ssrEventCfg.onReconnect                     = "onReconnect"                     --重连
ssrEventCfg.onMapInfoChange                 = "onMapInfoChange"                 --地图改变 不同地图 {mapID = mapID lastMapID = lastMapID}
ssrEventCfg.onChangeScene                   = "onChangeScene"                  --切换场景 同地图或不同地图 {mapID = mapID lastMapID = lastMapID}
ssrEventCfg.onPlayerPropertyInited          = "onPlayerPropertyInited"          --角色属性初始化完毕，通常在这里认为已正常进入游戏，可以执行其他逻辑
ssrEventCfg.onPlayerLevelChange             = "onPlayerLevelChange"             --角色等级发生改变 {currlevel = currlevel lastlevel = lastlevel}
ssrEventCfg.onPlayerPropertyChange          = "onPlayerPropertyChange"          --角色属性发生改变
ssrEventCfg.onPlayerManaChange              = "onPlayerManaChange"              --角色hp/mp发生改变 {curHP = curHP maxHP = maxHP curMP = curMP maxMP = maxMP roleName = roleName}
ssrEventCfg.OnTargetChange                  = "OnTargetChange"                  --选中目标改变 {actorID = actorID, actorName = actorName, curHP = curHP, maxHP = maxHP, level = level, type = type} type: 类型 1玩家 2怪
ssrEventCfg.OnRefreshTargetHP               = "OnRefreshTargetHP"               --已选中的目标血量变化 {actorID = actorID curHP = curHP maxHP = maxHP}
ssrEventCfg.onLeaveWorld                    = "onLeaveWorld"                    --离开游戏世界 小退触发
ssrEventCfg.onRestartGame                   = "onRestartGame"                   --重启游戏触发
ssrEventCfg.onGameSuspend                   = "onGameSuspend"                   --游戏暂停
ssrEventCfg.onGameResumed                   = "onGameResumed"                   --游戏恢复
ssrEventCfg.OnChangePKStateSuccess          = "OnChangePKStateSuccess"          --切换模式成功
ssrEventCfg.OnPlayerNameInited              = "OnPlayerNameInited"              --角色名初始化/改变 {roleName = roleName}
ssrEventCfg.OnTakeOnEquip                   = "OnTakeOnEquip"                   --穿戴装备 {isSuccess = isSuccess} isSuccess: boolean 成功/失败
ssrEventCfg.OnTakeOffEquip                  = "OnTakeOffEquip"                  --脱掉装备 {isSuccess = isSuccess} isSuccess: boolean 成功/失败
ssrEventCfg.OnBatteryValueChange            = "OnBatteryValueChange "           --电量改变 value — 电量百分比值
ssrEventCfg.OnPlayerExpChange               = "OnPlayerExpChange "              --玩家经验值改变 {changed = changed} — 变动的数值
ssrEventCfg.OnNetStateChange                = "OnNetStateChange"                --网络状态改变 {type = type} type: -1:未知 0:wifi 1:2G 2:3G 3:4G
ssrEventCfg.OnPlayerMoneyChange             = "OnPlayerMoneyChange"             --角色货币数据改变 {id = id, count = count} — 发生改变的货币id和数量
ssrEventCfg.OnBagOperData                   = "OnBagOperData"                   --背包数据操作 {opera = opera, operID = operID} — opera类型: 0:初始化 1:增加 2:删除 3:改变 operID 物品数据: table
ssrEventCfg.OnActionBegin                   = "OnActionBegin"                   --走路/跑步动作触发 type — 1走路 2跑步 [主玩家]
ssrEventCfg.OnPetActionBegin                = "OnPetActionBegin"                --主玩家的宠物/宝宝动作触发 — 1走路 2跑步
ssrEventCfg.OnSkillAdd                      = "OnSkillAdd"                      --新增技能 技能数据: table
ssrEventCfg.OnSkillDel                      = "OnSkillDel"                      --删除技能 技能数据: table
ssrEventCfg.OnSkillUpdate                   = "OnSkillUpdate"                   --技能更新 技能数据: table
ssrEventCfg.OnLookPlayerDataUpdate          = "OnLookPlayerDataUpdate"          --查看他人数据更新 table —此时table内Items为服务端未解析过的装备信息数据
ssrEventCfg.OnAutoFightBegin                = "OnAutoFightBegin"                --自动战斗开始
ssrEventCfg.OnAutoFightEnd                  = "OnAutoFightEnd"                  --自动战斗结束
ssrEventCfg.OnPlayerEquipInit               = "OnPlayerEquipInit"               --角色装备数据初始化

-----------------------------------游戏事件-----------------------------------
ssrEventCfg.GoClickNpc                      = "GoClickNpc"                      --点击某npc params：npcid
ssrEventCfg.GoClickMainBlank                = "GoClickMainBlank"                --点击主界面空白区域
ssrEventCfg.ShouChongSClibao                = "ShouChongSClibao"                --首充礼包事件
ssrEventCfg.GoFuhuoTimer                    = "GoFuhuoTimer"                    --复活倒计时
ssrEventCfg.GoVIPLevel                      = "GoVIPLevel"                      --VIP等级发生变化
ssrEventCfg.GoRecharge                      = "GoRecharge"                      --充值变化
ssrEventCfg.GoGMLevel                       = "GoGMLevel"                       --获取到GM权限等级
ssrEventCfg.GoOpenLayerQuickAccess          = "GoOpenLayerQuickAccess"          --打开快速获取界面

-----------------------------------红点事件-----------------------------------
ssrEventCfg.RpPagingGemstone                = "RpPagingGemstone"                --模块 PagingGemstone 红点显示事件
ssrEventCfg.RpGemInlay                      = "RpGemInlay"                      --模块 GemInlay 红点显示事件
ssrEventCfg.RpGemFuse                       = "RpGemFuse"                       --模块 GemFuse 红点显示事件
ssrEventCfg.ShangYeHuoDong1                 = "ShangYeHuoDong1"                 --模块 每日充值 红点显示事件
ssrEventCfg.ShangYeHuoDong2                 = "ShangYeHuoDong2"                 --模块 限时直购 红点显示事件
ssrEventCfg.ShangYeHuoDong3                 = "ShangYeHuoDong3"                 --模块 累计充值 红点显示事件
ssrEventCfg.ShangYeHuoDong4                 = "ShangYeHuoDong4"                 --模块 行会竞技 红点显示事件
ssrEventCfg.RpActivity                      = "RpActivity"                      --模块 活动 红点显示事件

-----------------------------------任务事件-----------------------------------
ssrEventCfg.OnTaskRefresh                   = "OnTaskRefresh"                   --刷新任务
-----------------------------------其他事件-----------------------------------
ssrEventCfg.OnZjdqShowMap                   = "OnZjdqShowMap"                   --斩将夺旗小地图显示

return ssrEventCfg