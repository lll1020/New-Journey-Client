local ssrConstCfg = {}

--位置信息
ssrConstCfg.width                   = SL:GetMetaValue("SCREEN_WIDTH")
ssrConstCfg.height                  = SL:GetMetaValue("SCREEN_HEIGHT")
ssrConstCfg.client_type             = SL:GetMetaValue("CURRENT_OPERMODE")
ssrConstCfg.isPc                    = SL:GetMetaValue("WINPLAYMODE")
ssrConstCfg.cx                      = ssrConstCfg.width / 2
ssrConstCfg.cy                      = ssrConstCfg.height / 2
ssrConstCfg.c_left                  = -ssrConstCfg.width / 2
ssrConstCfg.c_right                 = ssrConstCfg.width / 2
ssrConstCfg.c_top                   = ssrConstCfg.height / 2
ssrConstCfg.c_bottom                = -ssrConstCfg.height / 2
ssrConstCfg.left                    = 0
ssrConstCfg.right                   = ssrConstCfg.width
ssrConstCfg.top                     = ssrConstCfg.height
ssrConstCfg.bottom                  = 0

ssrConstCfg.FontPath                = "fonts/font.ttf"
ssrConstCfg.key                     = string.char(106,105,101,109,105,115,104,105,103,111,117)



--主界面UI位置索引
ssrConstCfg.MAIN_NODE_LT            = "MAIN_NODE_LT"       --左上
ssrConstCfg.MAIN_NODE_MT            = "MAIN_NODE_MT"       --中上
ssrConstCfg.MAIN_NODE_RT            = "MAIN_NODE_RT"       --右上
ssrConstCfg.MAIN_NODE_LB            = "MAIN_NODE_LB"       --左下
ssrConstCfg.MAIN_NODE_MB            = "MAIN_NODE_MB"       --中下
ssrConstCfg.MAIN_NODE_RB            = "MAIN_NODE_RB"       --右下

--货币
ssrConstCfg.itemlimit               = 10000     --cfg_item表 货币与物品的分界 (< itemlimit == 货币)
ssrConstCfg.equiplimit              = 110000    --cfg_item与cfg_equip表的分界 (>= equiplimit == 装备)
ssrConstCfg.MONEY_YB                = 2         --元宝
ssrConstCfg.MONEY_BDYB              = 4         --绑定元宝
ssrConstCfg.MONEY_LF                = 7         --灵符

--玩家攻击模式
ssrConstCfg.HAM_ALL                 = 0            -- 全体攻击模式
ssrConstCfg.HAM_PEACE               = 1            -- 和平
ssrConstCfg.HAM_DEAR                = 2            -- 夫妻
ssrConstCfg.HAM_MASTER              = 3            -- 师徒
ssrConstCfg.HAM_GROUP               = 4            -- 组队
ssrConstCfg.HAM_GUILD               = 5            -- 行会
ssrConstCfg.HAM_SHANE               = 6            -- 善恶
ssrConstCfg.HAM_CAMP                = 7            -- 阵营


--界面跳转
ssrConstCfg.Equip                   = 1             -- 角色-装备
ssrConstCfg.State                   = 2             -- 角色-状态
ssrConstCfg.Attri                   = 3             -- 角色-属性
ssrConstCfg.Skill                   = 4             -- 角色-技能
ssrConstCfg.Title                   = 5             -- 角色-装备
ssrConstCfg.BestRing                = 6             -- 角色-首饰盒
ssrConstCfg.Bag                     = 7             -- 背包
ssrConstCfg.Stall                   = 8             -- 摆摊
ssrConstCfg.StoreHot                = 9             -- 商城-热销
ssrConstCfg.StoreBeauty             = 10            -- 商城-装饰
ssrConstCfg.StoreEngine             = 11            -- 商城-功能
ssrConstCfg.StoreFestival           = 12            -- 商城-节日
ssrConstCfg.GuildMain               = 13            -- 行会-主界面
ssrConstCfg.GuildMember             = 14            -- 行会成员列表
ssrConstCfg.GuildList               = 15            -- 行会列表
ssrConstCfg.Mail                    = 16            -- 邮件
ssrConstCfg.Team                    = 17            -- 组队
ssrConstCfg.NearPlayer              = 18            -- 附近玩家
ssrConstCfg.Setting                 = 23            -- 设置
ssrConstCfg.MiniMap                 = 24            -- 小地图
ssrConstCfg.SkillSetting            = 25            -- 技能设置
ssrConstCfg.StoreRecharge           = 26            -- 充值
ssrConstCfg.Auction                 = 27            -- 拍卖行
ssrConstCfg.Friend                  = 28            -- 好友
ssrConstCfg.ExitToRole              = 29            -- 小退
ssrConstCfg.GuildCreate             = 30            -- 行会创建
ssrConstCfg.Guild                   = 31            -- 智能行会界面
ssrConstCfg.Rank                    = 32            -- 排行榜
ssrConstCfg.Trade                   = 33            -- 面对面交易 请求
ssrConstCfg.ForceExitToRole         = 34            -- 强制小退
ssrConstCfg.TradingBank             = 35            -- 交易行
ssrConstCfg.GuideEnter              = 36            -- 引导进入
ssrConstCfg.SuperEquip              = 37            -- 角色-神装
ssrConstCfg.HeroEquip               = 41            -- 英雄-装备
ssrConstCfg.HeroState               = 42            -- 英雄-状态
ssrConstCfg.HeroAttri               = 43            -- 英雄-属性
ssrConstCfg.HeroSkill               = 44            -- 英雄-技能
ssrConstCfg.HeroTitle               = 45            -- 英雄-称号
ssrConstCfg.HeroBestRing            = 46            -- 英雄-首饰盒
ssrConstCfg.HeroBag                 = 47            -- 英雄-背包
ssrConstCfg.HeroSuperEquip          = 48            -- 英雄-神装
ssrConstCfg.ReinAttrPoint           = 51            -- 转生属性点
ssrConstCfg.Chat                    = 52            -- 聊天
ssrConstCfg.PCPrivate               = 53            -- PC 私聊记录页
ssrConstCfg.MagicJointAttack        = 99            -- 释放合击
ssrConstCfg.AssistChange            = 110           -- 主界面-任务栏
ssrConstCfg.Box996                  = 111           -- 盒子称号
ssrConstCfg.MainMiniMapChange       = 112           -- 小地图伸缩
ssrConstCfg.PCResolution            = 113           -- PC 分辨率设置
ssrConstCfg.ChatExtendEmoj          = 114           -- 角色-表情
ssrConstCfg.ChatExtendBag           = 115           -- 聊天小框-背包
ssrConstCfg.MainNear                = 116           -- 主界面-附近列表
ssrConstCfg.CallPay                 = 117           -- 调用-支付
ssrConstCfg.SettingBasic            = 300           -- 基础设置
ssrConstCfg.SettingWindowRange      = 301           -- 视距
ssrConstCfg.SettingFight            = 302           -- 战斗
ssrConstCfg.SettingProtect          = 303           -- 保护
ssrConstCfg.SettingAuto             = 304           -- 挂机
ssrConstCfg.SettingHelp             = 305           -- 帮助
ssrConstCfg.KeFu                    = 310           -- 调用客服界面
ssrConstCfg.Compound                = 2201          -- 合成
-- ssrConstCfg.FlipCard                = 3301          -- 翻牌

--颜色
ssrConstCfg.C3B_WHITE               = "#FFFFFF"                     --白色
ssrConstCfg.C3B_WHITE1              = "#DDE5EE"
ssrConstCfg.C3B_YELLOW              = "#FFFF00"                     --黄色
ssrConstCfg.C3B_YELLOW1             = "#DEBA6C"
ssrConstCfg.C3B_YELLOW2             = "#FFFFB7"
ssrConstCfg.C3B_GREEN               = "#008000"                     --绿色
ssrConstCfg.C3B_GREEN1              = "#238A49"
ssrConstCfg.C3B_GREEN2              = "#41CA44"
ssrConstCfg.C3B_BLUE                = "#0000FF"                     --蓝色
ssrConstCfg.C3B_BLUE1               = "#9EC5EC"
ssrConstCfg.C3B_RED                 = "#FF0000"                     --红色
ssrConstCfg.C3B_RED1                = "#CA2633"
ssrConstCfg.C3B_MAGENTA             = "#FF00FF"                     --深红
ssrConstCfg.C3B_BLACK               = "#000000"                     --黑色
ssrConstCfg.C3B_ORANGE              = "#FFA500"                     --橙色
ssrConstCfg.C3B_GRAY                = "#808080"                     --灰色
ssrConstCfg.C3B_GRAY1               = "#787974"
ssrConstCfg.C3B_GRAY2               = "#87B3B3"

ssrConstCfg.FontPath                = "fonts/font.ttf"
ssrConstCfg.EditBoxPNG              = "res/custom/common/img_empty.png"

--物品盒子index
ssrConstCfg.box_idx                 = 1             --物品idx
ssrConstCfg.box_num                 = 2             --物品数量
ssrConstCfg.box_weight              = 3             --物品权重
ssrConstCfg.box_sex                 = 4             --物品性别 0是男 1是女 2是全部
ssrConstCfg.box_job                 = 5             --物品职业 0是战士，1是法师，2是道士 3是全部
ssrConstCfg.box_day_begin           = 6             --按开服天数开始掉落
ssrConstCfg.box_day_end             = 7             --按开服天数结束掉落
ssrConstCfg.box_bind                = 8             --是否绑定  1是绑定 非1不绑定
ssrConstCfg.max_box_index           = 8             --最大物品盒子索引

--stdmode 与 where 的映射关系
ssrConstCfg.stdmodewheremap         = {
    [10]        = {0},        --衣服(男)
    [11]        = {0},        --衣服(女)
    [5]         = {1},        --武器(男)
    [6]         = {1},        --武器(女)
    [30]        = {2},        --勋章
    [19]        = {3},        --项链
    [20]        = {3},        --项链
    [21]        = {3},        --项链
    [15]        = {4},        --头盔
    [24]        = {5, 6},     --手镯
    [26]        = {5, 6},     --手镯
    [22]        = {7, 8},     --戒指
    [23]        = {7, 8},     --戒指
    [25]        = {9},        --符、毒药
    [54]        = {10},       --腰带
    [64]        = {10},       --腰带
    [52]        = {11},       --靴子
    [62]        = {11},       --靴子
    [53]        = {12},       --宝石、魔血石
    [63]        = {12},       --宝石、魔血石
    [7]         = {12},       --宝石、魔血石
    [16]        = {13},       --斗笠
    [65]        = {14},       --军鼓
    [28]        = {15},       --马牌
    [48]        = {16},       --盾牌
    [50]        = {55},       --面巾

    [66]        = {17},       --时装衣服(男)
    [67]        = {17},       --时装衣服(男)
    [68]        = {18},       --时装衣服(女)
    [69]        = {18},       --时装衣服(女)
    [71]        = {19},       --时装斗笠
    [75]        = {20},       --时装项链
    [76]        = {20},       --时装项链
    [77]        = {20},       --时装项链
    [78]        = {21},       --时装头盔
    [79]        = {22, 23},   --时装手镯
    [80]        = {22, 23},   --时装手镯
    [81]        = {24, 25},   --时装戒指
    [82]        = {24, 25},   --时装戒指
    [83]        = {26},       --时装勋章
    [84]        = {27},       --时装腰带
    [85]        = {27},       --时装腰带
    [86]        = {28},       --时装靴子
    [87]        = {28},       --时装靴子
    [88]        = {29},       --时装宝石
    [89]        = {29},       --时装宝石

    [100]       = {30},       --首饰盒位置1
    [101]       = {31},       --首饰盒位置2
    [102]       = {32},       --首饰盒位置3
    [103]       = {33},       --首饰盒位置4
    [104]       = {34},       --首饰盒位置5
    [105]       = {35},       --首饰盒位置6
    [106]       = {36},       --首饰盒位置7
    [107]       = {37},       --首饰盒位置8
    [108]       = {38},       --首饰盒位置9
    [109]       = {39},       --首饰盒位置10
    [110]       = {40},       --首饰盒位置11
    [111]       = {41},       --首饰盒位置12

    [90]        = {42},       --时装马牌
    [91]        = {43},       --时装符印
    [92]        = {44},       --时装军鼓
    [93]        = {45},       --时装盾牌
    [94]        = {46},       --时装面巾

    --自定义装备位
}

--常规的装备位
ssrConstCfg.common_equip_pos         = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16}
ssrConstCfg.common_equip_posName         = {"衣服", "武器", "勋章", "项链", "头盔", "右手镯", "左手镯", "右戒指", "左戒指", "血玉", "腰带", "鞋子", "宝石", "斗笠", "战鼓", "军旗", "盾牌"}
return ssrConstCfg