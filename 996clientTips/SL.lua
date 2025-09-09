---@meta SL

---@class SLlib

SL = {}

---日志打印
---*  ... 
---@param ... any
---@return any
function SL:release_print(...) end

---DEBUG下日志打印
---*  ... 
---@param ... any
---@return any
function SL:Print(...) end

---DEBUG下日志打印
---*  ... 
---@param ... any
---@return any
function SL:PrintEx(...) end


---DEBUG下日志打印堆栈信息
---@return any
function SL:PrintTraceback() end

---DEBUG下日志打印表信息
---*  data : 需要打印的表
---*  desciption : 打印表描述
---*  nesting : 表
---@param data table
---@param desciption? string
---@param nesting? integer
---@return any
function SL:dump(data, desciption, nesting) end

---json字符串解密
---*  jsonStr : json字符
---*  isfilter : 是否过滤违禁词 默认为true
---@param jsonStr string
---@param isfilter? boolean
---@return any
function SL:JsonDecode(jsonStr,isfilter) end

---json字符串加密
---*  jsonData : 表
---*  isfilter : 是否过滤违禁词 默认为true
---@param jsonData table
---@param isfilter? boolean
---@return any
function SL:JsonEncode(jsonData, isfilter) end

---颜色转换函数,从16进制字符转为{r, g, b}
---*  hexStr : 颜色值(“#000000”)
---@param hexStr string
---@return any
function SL:ConvertColorFromHexString(hexStr) end

---文件路径是否存在
---*  path : 文件路径
---@param path string
---@return any
function SL:IsFileExist(path) end

---复制数据(深拷贝)
---*  data : 目标数据
---@param data table
---@return any
function SL:CopyData(data) end

---分割字符串
---*  string : 目标字符串
---*  delimiter : 分隔符
---@param string string
---@param delimiter string
---@return any
function SL:Split(string, delimiter) end

---文本提示
---*  string : 提示文本
---@param string string
---@return any
function SL:ShowSystemTips(string) end

---哈希表转成按数组
---*  hashTab : 提示文本
---@param hashTab table
---@param sortFunc function
---@return any
function SL:HashToSortArray(hashTab,sortFunc) end

---显示提示文本框
---*  str : 显示文本
---*  width : 显示宽度, 默认: 1136
---*  pos : 坐标, 默认: {x = 0, y = 0}
---*  anchorPoint : 锚点, 默认: {x = 0, y = 1}
---@param str string
---@param width integer
---@param pos table
---@param anchorPoint table
---@return any
function SL:SHOW_DESCTIP(str, width, pos, anchorPoint) end

---加载文件
---*  file : 文件名
---*  reload : 是否重新加载文件(填true时,会先释放文件再加载)
---@param file string
---@param reload boolean
---@return any
function SL:Require(file,reload) end

---将数字 num 转换成 xx万、xx亿
---*  num : 数字
---*  places : 显示小数点后几位数 [3.40.3版本]
---@param num integer
---@param places? integer
---@return any
function SL:GetSimpleNumber(num,places) end

---血量单位显示[将血量数值转换有单位显示 过十亿(单位:E) 10w-99999w(单位:W)]
---*  hp : 血量数值
---*  pointBit : 显示小数点后几位, 默认保留后两位
---@param hp integer
---@param pointBit? integer
---@return any
function SL:HPUnit(hp, pointBit) end

---中文转换成竖着显示
---*  str : 文本
---@param str string
---@return any
function SL:ChineseToVertical(str) end

---阿拉伯数字转中文大写
---*  num : 数字
---@param str string
---@return any
function SL:NumberToChinese(str) end

---获取字符串的byte长度
---*  num : 数字
---@param str string
---@return any
function SL:GetUTF8ByteLen(str) end

---时间格式化成字符串显示
---*  num : 数字
---@param time integer
---@return any
function SL:TimeFormatToStr(time) end

---lua table转成config配置表
---*  tab : 需要转换的table
---*  name : 转出文件名
---*  destPath : 文件保存的路径, 默认目录:dev/scripts/game_config/
---*  sortFunc : 外层排序函数
---@param tab table
---@param name string
---@param destPath string
---@param sortFunc function
---@return any
function SL:SaveTableToConfig(tab, name, destPath, sortFunc) end

---十六进制转十进制
---*  hexStr : 16进制数
---@param hexStr string
---@return any
function SL:HexToInt(hexStr) end

---十六进制转十进制
---*  string : 字符
---@param string string
---@return any
function SL:GetStrMD5(string) end

---跳转到某个超链
---*  id : 对应界面的跳转id
---@param id integer
---@return any
function SL:JumpTo(id) end

---小退, 有弹窗提示
---@return any
function SL:ExitToRoleUI() end

---强制小退, 无弹窗提示
---@return any
function SL:ForceExitToRoleUI() end

---退出到登录界面
---@return any
function SL:ExitToLoginUI() end

---发送GM命令
---*  msg : gm命令
---@param msg string
---@return any
function SL:SendGMMsgToChat(msg) end

---创建一个红点到节点
---*  targetNode : 目标控件
---*  offset : 偏移位置 例: {x = 5, y = 5}
---@param targetNode userdata
---@param offset? table
---@return any
function SL:CreateRedPoint(targetNode,offset) end

---设置文本样式(按钮、文本)
---*  widget :按钮或者文本对象
---*  colorID  :0 - 255 色值ID
---@param widget  userdata
---@param colorID  table
---@return any
function SL:SetColorStyle(widget ,colorID ) end

---获取对应色值ID的配置
---*  colorID :按钮或者文本对象
---@return any
function SL:GetColorCfg(colorID) end

---检查是否满足条件
---*  conditionStr : 元变量条件判断, 格式: $(原变量ID)
---@param conditionStr  string
---@return any
function SL:CheckCondition(conditionStr) end

---显示气泡提醒
---*  id :气泡ID
---*  path:气泡图片资源路径
---*  callback:气泡点击回调
---@param id userdata
---@param path string
---@param callback function
---@return any
function SL:AddBubbleTips(id, path, callback) end

---显示气泡提醒
---*  id :气泡ID
---@param id userdata
---@return any
function SL:DelBubbleTips(id) end

---重新加载地图
---@return any
function SL:ReloadMap() end

---请求HTTPGet
---*  url : 链接地址
---*  httpCB : 回调函数
---@param url string
---@param httpCB function
---@return any
function SL:HTTPRequestGet(url,httpCB) end

---请求HTTPPost
---*  url : 链接地址
---*  httpCB : 回调函数
---*  suffix : 请求信息
---*  head : 请求头
---@param url string
---@param httpCB function
---@param suffix string
---@param head table
---@return any
function SL:HTTPRequestPost(url,httpCB,suffix,head) end

---注册窗体控件事件
---*  widget : 控件对象
---*  msg : 描述
---*  msgtype : 窗体事件id
---*  callback : 回调函数
---@param widget userdata
---@param msg string
---@param msgtype integer
---@param callback function
---@return any
function SL:RegisterWndEvent(widget, msg, msgtype, callback) end

---注销窗体控件事件
---*  widget : 控件对象
---*  msg : 描述
---*  msgtype : 窗体事件id
---@param widget userdata
---@param msg string
---@param msgtype integer
---@return any
function SL:UnRegisterWndEvent(widget, msg, msgtype) end

---添加窗体控件自定义属性
---*  widget : 控件对象
---*  desc : 描述
---*  key : 属性名称
---*  value : 属性值
---@param widget userdata
---@param desc string
---@param key string
---@param value any
---@return any
function SL:AddWndProperty(widget, desc, key, value) end

---删除窗体控件自定义属性
---*  widget : 控件对象
---*  desc : 描述
---*  key : 属性名称
---*  value : 属性值
---@param widget userdata
---@param desc string
---@param key string
---@param value any
---@return any
function SL:DelWndProperty(widget, desc, key, value) end

---获取窗体控件自定义属性
---*  widget : 控件对象
---*  desc : 描述
---*  key : 属性名称
---@param widget userdata
---@param desc string
---@param key string
---@return any
function SL:GetWndProperty(widget, desc, key) end

---开启一个定时器
---*  callback : 函数回调
---*  interval : 时间
---@param callback function
---@param interval integer
---@return any
function SL:Schedule(callback, interval) end

---停止一个定时器
---*  scheduleID : 定时器ID
---@param scheduleID integer
---@return any
function SL:UnSchedule(scheduleID) end

---开启一个单次定时器
---*  callback : 函数回调
---*  time : 时间
---@param callback function
---@param time integer
---@return any
function SL:ScheduleOnce(callback, time) end

---开启一个定时器, 绑定node节点
---*  node : 节点对象
---*  callback : 函数回调
---*  time : 时间
---@param node userdata
---@param callback function
---@param time integer
---@return any
function SL:schedule(node, callback, time) end

---开启一个定时器, 绑定node节点
---*  node : 节点对象
---*  callback : 函数回调
---*  time : 时间
---@param node userdata
---@param callback function
---@param time integer
---@return any
function SL:scheduleOnce(node, callback, time) end

---打开引导
---*  data : 引导数据（参考示例）
---@param data table
---@return any
function SL:StartGuide(data) end

---关闭引导
---@return any
function SL:CloseGuide() end

---存储数据到本地,存储的文件名为:”GUIStorage”+玩家ID
---*  key : 字段名
---*  data : 存储数据到本地,存储的文件名为:”GUIStorage” + 角色ID
---@param key any
---@param data table|integer|string
---@return any
function SL:SetLocalString(key, data) end

---本地取数据
---*  key : 存储时的字段
---@param key any
---@return any
function SL:GetLocalString(key) end

---检测人物是否可使用
---*  itemData : 装备数据
---@param itemData table
---@return any
function SL:CheckItemUseNeed(itemData) end

---检测英雄是否可使用
---*  itemData : 装备数据
---@param itemData table
---@return any
function SL:CheckItemUseNeed_Hero(itemData) end

---获得需要比较的装备
---*  itemData : 装备数据
---*  isHero : 是否对比英雄
---@param itemData table
---@param isHero string
---@return any
function SL:CheckItemUseNeed_Hero(itemData,isHero) end

---对比传入装备和自身穿戴的装备
---*  itemData : 装备数据
---*  from : 物品来自(界面位置), 可参照元变量”ITEMFROMUI_ENUM”
---@param itemData table
---@param from string
---@return any
function SL:CheckEquipPowerThanSelf(itemData,from) end

---通过 cfg_menulayer 表中的界面ID检测该界面的条件配置,是否满足显示
---*  layerID : cfg_menulayer 表中的界面ID
---@param layerID integer
---@return any
function SL:CheckMenuLayerConditionByID(layerID) end

---通过 cfg_menulayer 表中的界面ID打开该界面
---*  layerID : cfg_menulayer 表中的界面ID
---*  layerID : 挂接点
---*  layerID : 可选参数
---@param layerID integer
---@param parent userdata
---@param extent? integer
---@return any
function SL:OpenMenuLayerByID(layerID,parent, extent) end

---通过 cfg_menulayer 表中的界面ID关闭该界面
---*  layerID : cfg_menulayer 表中的界面ID
---@param layerID integer
---@return any
function SL:CloseMenuLayerByID(layerID,parent, extent) end

---打开设置界面
---*  pageID : 页签ID 不填默认基础设置 1 : 基础设置 2 : 视距 3 : 战斗 4 : 保护 5 : 挂机 6 : 帮助
---@return any
function SL:OpenSettingUI(pageID) end

---关闭设置界面
---@return any
function SL:CloseSettingUI() end

---打开行会指定页签界面
---*  page : 行会界面(不填默认行会主界面) 1 : 主页 2 : 成员 3 : 列表
---@param page integer
---@return any
function SL:OpenGuildMainUI(page) end

---关闭行会界面
---@return any
function SL:CloseGuildMainUI() end

---打开行会申请界面
---@return any
function SL:OpenGuildApplyListUI() end

---关闭行会申请界面
---@return any
function SL:CloseGuildApplyListUI() end

---打开行会创建界面
---@return any
function SL:OpenGuildCreateUI() end

---关闭行会创建界面
---@return any
function SL:CloseGuildCreateUI() end

---打开行会申请界面
---@return any
function SL:OpenGuildAllyApplyUI() end

---关闭行会申请界面
---@return any
function SL:CloseGuildAllyApplyUI() end

---行会宣战/结盟界面 [关闭]
---@return any
function SL:CloseGuildWarSponsorUI() end

---打开背包界面
---*  data : {pos : 背包打开位置 bag_page : 背包打开页签ID}
---@param data table
---@return any
function SL:OpenBagUI(data) end

---关闭背包界面
---@return any
function SL:CloseBagUI() end

---打开英雄背包界面
---@return any
function SL:OpenHeroBagUI() end

---关闭英雄背包界面
---@return any
function SL:CloseHeroBagUI() end

---打开拍卖行
---@return any
function SL:OpenAuctionUI() end

---关闭拍卖行
---@return any
function SL:CloseAuctionUI() end

---打开摆摊界面
---@return any
function SL:OpenStallLayerUI() end

---关闭摆摊界面
---@return any
function SL:CloseStallLayerUI() end

---打开玩家交易界面
---@return any
function SL:OpenTradeUI() end

---关闭玩家交易界面
---@return any
function SL:CloseTradeUI() end

---打开玩家排行榜
---*  type : 打开 指定页签ID
---@param type integer
---@return any
function SL:OpenRankUI(type) end

---关闭玩家排行榜
---@return any
function SL:CloseRankUI() end

---打开聊天界面(手机端)
---@return any
function SL:OpenChatUI() end

---关闭聊天界面(手机端)
---@return any
function SL:CloseChatUI() end

---打开聊天扩展框
---*  index : 1 : 快捷命令 2 : 表情 3 : 背包
---@param index integer
---@return any
function SL:OpenChatExtendUI(index) end

---关闭聊天扩展框
---@return any
function SL:CloseChatUI() end

---打开交易行
---@return any
function SL:OpenTradingBankUI() end

---关闭交易行
---@return any
function SL:CloseTradingBankUI() end

---打开商城
---*  page : 打开 商城对应分页
---@param index integer
---@return any
function SL:OpenChatExtendUI(index) end

---关闭商城
---@return any
function SL:CloseStoreUI() end

---打开商城商品购买框
---*  storeIndex : 商品index cfg_store商城表配置的id
---*  limitStr : 超出限制购买的提示
---@param storeIndex integer
---@param limitStr? string
---@return any
function SL:OpenStoreDetailUI(storeIndex, limitStr) end

---关闭商城商品购买框
---@return any
function SL:CloseStoreDetailUI() end

---打开技能配置界面
---*  data : 对应技能数据 打开技能快捷键配置页
---@param data? table
---@return any
function SL:OpenSkillSettingUI(data) end

---关闭技能配置界面
---@return any
function SL:CloseSkillSettingUI() end

---打开仓库界面
---@return any
function SL:OpenStorageUI() end

---关闭仓库界面
---@return any
function SL:CloseStorageUI() end

---打开社交界面
---@return any
function SL:OpenSocialUI() end

---关闭社交界面
---@return any
function SL:CloseSocialUI() end

---打开分辨率修改界面
---@return any
function SL:OpenResolutionSetUI() end

---关闭分辨率修改界面
---@return any
function SL:CloseResolutionSetUI() end

---打开玩家角色界面
---*  data : {extent: 子页id1装备、2状态、3属性、4技能、6称号、11时装 , isFast: boolen 是否快捷键打开}
---@param data table
---@return any
function SL:OpenMyPlayerUI(data) end

---关闭玩家角色界面
---@return any
function SL:CloseMyPlayerUI() end

---关闭玩家角色界面
---*  data : 移除对应子页id内容
---@param data table
---@return any
function SL:CloseMyPlayerPageUI(data) end

---打开查看他人角色界面
---*  data : {extent: 子页id 1装备、2状态、3属性、4技能、6称号、11时装}
---@param data table
---@return any
function SL:OpenOtherPlayerUI(data) end

---关闭查看他人角色界面
---@return any
function SL:CloseOtherPlayerUI() end

---关闭查看他人角色界面
---*  data : 移除对应子页id内容
---@param data table
---@return any
function SL:CloseOtherPlayerPageUI(data) end

---打开首饰盒界面
---*  param : 1: 自己人物 2:自己英雄 11:其他玩家人物 12:其他玩家英雄 21:交易行人物 22:交易行英雄
---@param param integer
---@param param2? any
---@return any
function SL:OpenBestRingBoxUI(param,param2) end

---关闭首饰盒界面
---*  param : 1: 自己人物 2:自己英雄 11:其他玩家人物 12:其他玩家英雄 21:交易行人物 22:交易行英雄
---@param param integer
---@return any
function SL:CloseBestRingBoxUI(param) end

---打开邀请组队界面
---@return any
function SL:OpenTeamInvite() end

---关闭邀请组队界面
---@return any
function SL:CloseTeamInvite() end

---打开入队申请列表页
---@return any
function SL:OpenTeamApply() end

---关闭入队申请列表页
---@return any
function SL:CloseTeamApply() end

---打开小地图界面
---@return any
function SL:OpenMiniMap() end

---关闭小地图界面
---@return any
function SL:CloseMiniMap() end

---打开主界面技能按钮区域切换显示
---@return any
function SL:OpenGuideEnter() end

---关闭主界面技能按钮区域切换显示
---@return any
function SL:CloseGuideEnter() end

---打开转生点分配界面
---@return any
function SL:OpenReinAttrUI() end

---关闭转生点分配界面
---@return any
function SL:CloseReinAttrUI() end

---打开任务栏
---@return any
function SL:OpenAssistUI() end

---关闭任务栏
---@return any
function SL:CloseAssistUI() end

---打开主界面小地图收缩切换[手机端]
---@return any
function SL:OpenMiniMapChangeUI() end

---关闭主界面小地图收缩切换[手机端]
---@return any
function SL:CloseMiniMapChangeUI() end

---打开附近展示页
---@return any
function SL:OpenMainNearUI() end

---关闭附近展示页
---@return any
function SL:CloseMainNearUI() end

---直接调用支付
---@return any
function SL:OpenCallPayUI() end

---打开客服UI
---@return any
function SL:OpenKefuUI() end

---打开PC端私聊界面
---@return any
function SL:OpenPCPrivateUI() end

---关闭PC端私聊界面
---@return any
function SL:ClosePCPrivateUI() end

---PC端小地图变换
---@return any
function SL:OpenPCMiniMapUI() end

---打开添加好友界面
---@return any
function SL:OpenAddFriendUI() end

---关闭添加好友界面
---@return any
function SL:CloseAddFriendUI() end

---打开添加黑名单界面
---@return any
function SL:OpenAddBlackListUI() end

---关闭添加黑名单界面
---@return any
function SL:CloseAddBlackListUI() end

---打开好友添加申请页
---@return any
function SL:OpenFriendApplyUI() end

---关闭好友添加申请页
---@return any
function SL:CloseFriendApplyUI() end

---打开 拍卖行-世界拍卖/行会拍卖
---*  parent : 挂接父节点
---*  source : 类别 0: 世界拍卖 1: 行会拍卖
---@param parent userdata
---@param source integer
---@return any
function SL:OpenAuctionWorldUI(parent, source) end

---关闭 拍卖行-世界拍卖/行会拍卖
---@return any
function SL:CloseAuctionWorldUI() end

---打开 拍卖行-我的竞拍
---*  parent : 挂接父节点
---@param parent userdata
---@return any
function SL:OpenAuctionBiddingUI(parent) end

---关闭 拍卖行-我的竞拍
---@return any
function SL:CloseAuctionBiddingUI() end

---打开 拍卖行-我的上架
---*  parent : 挂接父节点
---@param parent userdata
---@return any
function SL:OpenAuctionPutListUI(parent) end

---关闭 拍卖行-我的上架
---@return any
function SL:CloseAuctionPutListUI() end

---打开 拍卖行-上架界面
---*  itemData : 背包物品数据
---@param itemData table
---@return any
function SL:OpenAuctionPutinUI(itemData) end

---关闭 拍卖行-上架界面
---@return any
function SL:CloseAuctionPutinUI() end

---打开 拍卖行-下架界面
---*  itemData : 背包物品数据
---@param itemData table
---@return any
function SL:OpenAuctionPutoutUI(itemData) end

---关闭 拍卖行-下架界面
---@return any
function SL:CloseAuctionPutoutUI() end

---打开 拍卖行-竞拍界面
---*  item : 拍卖行上架的物品数据
---@param item table
---@return any
function SL:OpenAuctionBidUI(item) end

---关闭 拍卖行-竞拍界面
---@return any
function SL:CloseAuctionBidUI() end

---打开 拍卖行-一口价界面
---*  item : 拍卖行上架的物品数据
---@param item table
---@return any
function SL:OpenAuctionBuyUI(item) end

---关闭 拍卖行-一口价界面
---@return any
function SL:CloseAuctionBuyUI() end

---打开 拍卖行-超时界面
---*  item : 拍卖行上架的物品数据
---@param item table
---@return any
function SL:OpenAuctionTimeoutUI(item) end

---关闭 拍卖行-超时界面
---@return any
function SL:CloseAuctionTimeoutUI() end

---打开 合成界面
---@return any
function SL:OpenCompoundItemsUI() end

---关闭 合成界面
---@return any
function SL:CloseCompoundItemsUI() end

---打开 怪物提示列表-设置界面
---@return any
function SL:OpenBossTipsUI() end

---关闭 怪物提示列表-设置界面
---@return any
function SL:CloseBossTipsUI() end

---打开 拾取列表-设置界面
---@return any
function SL:OpenPickSettingUI() end

---关闭 拾取列表-设置界面
---@return any
function SL:ClosePickSettingUI() end

---打开 保护配置-设置界面
---*  data : cfg_setup对应保护配置
---@param data table
---@return any
function SL:OpenProtectSettingUI(data) end

---关闭 保护配置-设置界面
---@return any
function SL:CloseProtectSettingUI() end

---打开 增加怪物名字-设置界面
---*  data : {ignoreName: boolean 是否是挂机忽略名字}
---@param data? table
---@return any
function SL:OpenAddNameUI(data) end

---关闭 增加怪物名字-设置界面
---@return any
function SL:CloseAddNameUI() end

---打开 增加BOSS类型-设置界面
---@return any
function SL:OpenAddBossTypeUI() end

---关闭 增加BOSS类型-设置界面
---@return any
function SL:CloseAddBossTypeUI() end

---打开 增加BOSS类型-设置界面
---*  data : cfg_setup对应保护配置
---@param data table
---@return any
function SL:OpenSkillRankPanelUI(data) end

---关闭 增加BOSS类型-设置界面
---@return any
function SL:CloseSkillRankPanelUI() end

---打开 新增技能-设置界面
---@return any
function SL:OpenSkillPanelUI() end

---关闭 新增技能-设置界面
---@return any
function SL:CloseSkillPanelUI() end

---打开 选择下拉框
---*  list : 下拉要显示的内容
---*  position : 初始位置
---*  cellwidth : 单条cell的宽
---*  cellheight : 单条cell的高
---*  func : 回调 选中的编号1~n 0是关闭
---@param list table
---@param position table
---@param cellwidth integer
---@param cellheight integer
---@param func function
---@param param1? table
---@return any
function SL:OpenSelectListUI(list, position, cellwidth, cellheight, func,param1) end

---关闭 选择下拉框
---@return any
function SL:CloseSelectListUI() end

---打开 996盒子界面
---@return any
function SL:OpenBox996UI() end

---关闭 996盒子界面
---@return any
function SL:CloseBox996UI() end

---打开 英雄状态选择界面
---@return any
function SL:OpenHeroStateSelectUI(data) end

---关闭 英雄状态选择界面
---@return any
function SL:CloseHeroStateSelectUI(data) end

---打开 通用描述Tips
---*  data : 见说明书
---@param data table
---@return any
function SL:OpenCommonDescTipsPop(data) end

---关闭 通用描述Tips
---@return any
function SL:CloseCommonDescTipsPop() end

---打开 通用弹窗
---*  data : 见说明书
---@param data table
---@return any
function SL:OpenCommonTipsPop(data) end

---关闭 通用弹窗
---@return any
function SL:CloseCommonTipsPop() end

---打开 道具装备Tips
---*  data : {itemData: 物品数据,pos: 提示位置,from: 来源}
---@param data table
---@return any
function SL:OpenItemTips(data) end

---关闭 道具装备Tips
---@return any
function SL:CloseItemTips() end

---打开 道具拆分弹窗
---*  itemData : 物品数据
---@param itemData table
---@return any
function SL:OpenItemSplitPop(itemData) end

---关闭 道具拆分弹窗
---@return any
function SL:CloseItemSplitPop() end

---通用功能选择提示
---@return any
function SL:OpenFuncDockTips(data) end

---播放按钮点击音效
---@return any
function SL:PlayBtnClickAudio() end

---播放音效
---*  id : cfg_sound表对应id
---*  isLoop : 是否循环
---@param id integer
---@param isLoop? boolean
---@return any
function SL:PlaySound(id, isLoop) end

---停止音效
---*  id : cfg_sound表对应id
---@param id integer
---@return any
function SL:StopSound(id) end

---停止所有音效
---@return any
function SL:StopAllAudio() end

---发送文本显示到聊天页输入框
---*  msg : 	文本内容
---@param msg string
---@return any
function SL:SendInputMsgToChat(msg) end

---发送[装备]到聊天
---*  itemData : 	文本内容
---@param itemData table
---@return any
function SL:SendEquipMsgToChat(itemData) end

---发送[位置]到聊天
---*  itemData : 	设置频道
---@param channel? integer
---@return any
function SL:SendPosMsgToChat(channel) end

---发送[表情]到聊天
---*  itemData : 	表情配置
---@param itemData table
---@return any
function SL:SendInputMsgToChat(itemData) end

---私聊目标
---*  targetID : 	目标玩家ID
---*  targetName : 		目标玩家名字
---@param targetID string|integer
---@param targetName string
---@return any
function SL:PrivateChatWithTarget(targetID, targetName) end

---资源下载
---*  path : 	保存的文件路径
---*  url : 		下载的资源路径
---*  downloadCB : 		回调函数
---@param path table
---@param url table
---@param downloadCB function
---@return any
function SL:DownLoadRes(path, url,downloadCB) end

---快速选择目标
---*  data : 	{type: 0: 玩家;50: 怪物;400: 英雄 ,imgNotice: 没有目标时是否创建范围圈,systemTips: 没有目标时是否弹提示}
---@param data table
---@return any
function SL:QuickSelectTarget(data) end


---获取视野内的玩家
---*  noMainPlayer : 	true: 不包含自己 ;false: 包含自己
---@param noMainPlayer? boolean
---@return any
function SL:FindPlayerInCurrViewField(noMainPlayer) end

---获取视野内的怪物
---*  noPetOfMainPlayer : 	true: 不包含自己的宠物 ;false: 包含自己的宠物
---*  noPetOfNetPlayer : 	true: 不包含别人的宠物 ;false: 包含别人的宠物
---@param noPetOfMainPlayer table
---@param noPetOfNetPlayer table
---@return any
function SL:FindMonsterInCurrViewField(noPetOfMainPlayer, noPetOfNetPlayer) end

---控件加入到元变量自动刷新的组件
---*  metaValue : 	传入已配置元变量的字符串
---*  widget : 	文本控件或按钮控件
---@param metaValue table
---@param widget userdata
---@return any
function SL:CustomAttrWidgetAdd(metaValue, widget) end

---添加提升按钮 等同TXT脚本命令addbutshow
---*  id : 	按钮id 必须唯一!!!! (同脚本命令加的id也不能重复)
---*  name : 	按钮展示文本
---*  func : 	点击按钮跳转函数
---@param id integer
---@param name string
---@param func function
---@return any
function SL:AddUpgradeBtn(id, name,func) end


--- 检测控件是否可视 (用于检测在列表/滚动容器内控件)
--- * node: 控件
--- * touchPos: 当前接触坐标
---@param node object
---@param touchPos table
---@return any
function SL:CheckNodeCanCallBack(node, touchPos) end

--- 添加提升按钮
--- * id: 按钮id（必须唯一，同脚本命令加的id也不能重复）
--- * name: 按钮展示文本
--- * func: 点击按钮跳转函数
---@param id int
---@param name string
---@param func function
---@return any
function SL:AddUpgradeBtn(id, name, func) end

--- 删除提升按钮
--- * id: 按钮id（必须唯一，同脚本命令加的id也不能重复）
---@param id int
---@return any
function SL:RemoveUpgradeBtn(id) end

--- 模拟左键点击事件
--- * widget: 控件对象
---@param widget object
---@return any
function SL:WinClick(widget) end


--- 世界坐标转化为地图坐标
--- * worldX: 世界坐标X
--- * worldY: 世界坐标Y
---@param worldX number
---@param worldY number
---@return any
function SL:ConvertWorldPos2MapPos(worldX, worldY) end


---地图坐标转化为世界坐标
---*  mapX: 地图坐标X
---*  mapY: 地图坐标Y
---*  centerOfGrid: 是否在地图格中心
---@param mapX number
---@param mapY number
---@param centerOfGrid? boolean
---@return any
function SL:ConvertMapPos2WorldPos(mapX, mapY, centerOfGrid) end

---世界坐标转化为屏幕坐标
---*  worldX: 世界坐标X
---*  worldY: 世界坐标Y
---@param worldX number
---@param worldY number
---@return any
function SL:ConvertWorldPos2Screen(worldX, worldY) end

---屏幕坐标转化为世界坐标
---*  screenX: 屏幕坐标X
---*  screenY: 屏幕坐标Y
---@param screenX number
---@param screenY number
---@return any
function SL:ConvertScreen2WorldPos(screenX, screenY) end


---打开QQ
---@return any
function SL:OpenQQ() end

---加QQ
---*  id: QQ号
---@param id string
---@return any
function SL:JoinQQ(id) end

---加QQ群
---*  key: QQ群key
---@param key string
---@return any
function SL:JoinQQGroup(key) end

---打开微信
---@return any
function SL:OpenWX() end

---加微信公众号
---*  id: 公众号
---@param id string
---@return any
function SL:JoinWXGroup(id) end

---添加地图特效
---*  ID: 该地图特效标识 必须唯一!!!!
---*  mapID: 添加到的地图ID
---*  sfxId: 特效ID
---*  x: 地图坐标X
---*  y: 地图坐标Y
---*  loop: 是否循环播放特效, 不填默认循环播放
---@param ID number
---@param mapID string
---@param sfxId number
---@param x number
---@param y number
---@param loop boolean
---@return any
function SL:AddMapSpecialEffect(ID, mapID, sfxId, x, y, loop) end

---删除地图特效
---*  ID: 该地图特效标识 必须唯一!!!!
---*  mapID: 添加到的地图ID
---@param ID number
---@param mapID string
---@return any
function SL:RmvMapSpecialEffect(ID, mapID) end

---添加Actor特效
---*  actorID: 玩家id
---*  sfxID: 特效ID
---*  isFront: 是否在模型前  默认在前面
---*  offX: x偏移
---*  offY: y偏移
---@param actorID number
---@param sfxID number
---@param isFront boolean
---@param offX number
---@param offY number
---@return any
function SL:AddActorEffect(actorID, sfxID, isFront, offX, offY) end

---删除Actor特效
---*  actorID: 玩家id
---*  sfxID: 特效ID
---@param actorID number
---@param sfxID number
---@return any
function SL:RmvActorEffect(actorID, sfxID) end

---拉起充值
---*  payWay: 1 支付宝 2 花呗 3 微信 -1不选择(手机端接入SDK不选择支付渠道)
---*  currencyID: 货币ID
---*  price: 支付金额
---*  productIndex: 商品索引/商品ID
---@param payWay number
---@param currencyID number
---@param price number
---@param productIndex? number
---@return any
function SL:RequestPay(payWay, currencyID, price, productIndex) end

---兑换激活码
---*  cdk: 激活码
---@param cdk string
---@return any
function SL:RequestCDK(cdk) end

---请求改变PK模式
---*  pkmode: pk模式
---@param pkmode number
---@return any
function SL:RequestChangePKMode(pkmode) end

---请求改变宠物战斗模式
---*  pkmode: 宝宝模式
---@param pkmode number
---@return any
function SL:RequestChangePetPKMode(pkmode) end

---请求从仓库取出道具
---*  data: 道具数据
---@param data table
---@return any
function SL:RequestPutOutStorageData(data) end

---请求道具放入仓库
---*  data: 道具数据
---@param data table
---@return any
function SL:RequestSaveItemToNpcStorage(data) end

---请求使用道具
---*  itemData: 道具数据
---@param itemData table
---@return any
function SL:RequestUseItem(itemData) end

---请求使用英雄道具
---*  itemData: 道具数据
---@param itemData table
---@return any
function SL:RequestUseHeroItem(itemData) end

---拆分道具
---*  data: 道具数据
---*  num: 数量
---@param data table
---@param num number
---@return any
function SL:RequestSplitItem(data, num) end

---拆分道具(英雄)
---*  data: 道具数据
---*  num: 数量
---@param data table
---@param num number
---@return any
function SL:RequestSplitHeroItem(data, num) end

---请求购买商品
---*  index: 商品Index
---*  count: 购买数量
---@param index number
---@param count number
---@return any
function SL:RequestStoreBuy(index, count) end

---召唤英雄或收回
---@return any
function SL:RequestCallOrOutHero() end

---请求玩家首饰盒状态
---@return any
function SL:RequestOpenPlayerBestRings() end

---请求英雄首饰盒状态
---@return any
function SL:RequestOpenHeroBestRings() end

---请求宠物锁定
---*  targetID: 目标宠物ID
---@param targetID number
---@return any
function SL:RequestLockPetID(targetID) end

---请求取消宠物锁定
---*  targetID: 目标宠物ID
---@param targetID number
---@return any
function SL:RequestUnLockPetID(targetID) end

---释放技能
---*  skillID: 技能ID
---@param skillID number
---@return any
function SL:RequestLaunchSkill(skillID) end

---请求施法合击
---@return any
function SL:RequestMagicJointAttack() end

---查看目标玩家信息
---*  targetID: 目标ID
---*  notForbid: 是否不判断地图禁止查看
---@param targetID number
---@param notForbid? boolean
---@return any
function SL:RequestLookPlayer(targetID, notForbid) end

---请求行会申请列表
---@return any
function SL:RequestGuildAllyApplyList() end

---行会同盟申请操作
---*  guildID: 行会ID
---*  param: 操作编号 1同意 2拒绝
---@param guildID number
---@param param number
---@return any
function SL:RequestAllyOperate(guildID, param) end

---请求行会成员列表
---@return any
function SL:RequestGuildMemberList() end

---请求世界行会列表
---*  page: 分页id
---@param page number
---@return any
function SL:RequestWorldGuildList(page) end

---邀请玩家入会
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestGuildInviteOther(uid) end

---踢出行会
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestSubGuildMember(uid) end

---任命行会职位
---*  uid: 玩家id
---*  rank: 职位id 1-5
---@param uid number
---@param rank number
---@return any
function SL:RequestAppointGuildRank(uid, rank) end

---请求创建队伍
---@return any
function SL:RequestCreateTeam() end

---邀请玩家入队
---*  uid: 玩家id
---*  name: 玩家昵称
---@param uid number
---@param name? string
---@return any
function SL:RequestInviteJoinTeam(uid, name) end

---拒绝组队邀请
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestRefuseTeamInvite(uid) end

---同意组队邀请
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestAgreeTeamInvite(uid) end

---同意申请入队
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestApplyAgree(uid) end

---请求入队申请列表
---@return any
function SL:RequestApplyData() end

---请求附近队伍
---@return any
function SL:RequestNearTeam() end

---请求加入队伍
---*  uid: 队长id
---@param uid number
---@return any
function SL:RequestApplyJoinTeam(uid) end

---召集队友
---@return any
function SL:RequestCallTeamMember() end

---离开队伍
---@return any
function SL:RequestLeaveTeam() end

---保存允许组队状态
---*  status: 1允许 0不允许
---@param status number
---@return any
function SL:RequestSetTeamPermitStatus(status) end

---踢出队伍
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestSubTeamMember(uid) end

---移交队长
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestTransferTeamLeader(uid) end

---请求进行交易
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestTrade(uid) end

---请求好友列表
---@return any
function SL:RequestFriendList() end

---请求添加好友
---*  uname: 玩家昵称
---@param uname string
---@return any
function SL:RequestAddFriend(uname) end

---删除好友
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestDelFriend(uid) end

---好友加到黑名单
---*  uname: 玩家昵称
---@param uname string
---@return any
function SL:RequestAddBlacklistByName(uname) end

---移出黑名单
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestOutBlacklist(uid) end

---同意好友申请
---*  uname: 玩家昵称
---@param uname string
---@return any
function SL:RequestAgreeFriendApply(uname) end

---删除好友申请数据
---*  uname: 玩家昵称
---@param uname string
---@return any
function SL:RequestDelFriendApplyData(uname) end

---清空好友申请列表
---@return any
function SL:RequestClearFriendApplyList() end

---请求获取邮件列表 一次十条
---@return any
function SL:RequestMailList() end

---删除已读邮件
---@return any
function SL:RequestDelReadMail() end

---读邮件
---*  mailId: 邮件ID
---@param mailId number
---@return any
function SL:RequestReadMail(mailId) end

---删除邮件
---*  mailId: 邮件ID
---@param mailId number
---@return any
function SL:RequestDelMail(mailId) end

---邮件全部提取
---@return any
function SL:RequestGetAllMailItems() end

---邮件提取
---*  mailId: 邮件ID
---@param mailId number
---@return any
function SL:RequestGetMailItems(mailId) end

---请求拍卖行上架列表
---*  listType: 1: 表示查询自己上架的物品，2: 表示查询参与过的
---@param listType number
---@return any
function SL:RequestAuctionPutList(listType) end

---拍卖行请求上架
---*  makeindex: 物品唯一ID
---*  count: 数量
---*  bidPrice: 竞拍价格
---*  buyPrice: 一口价
---*  currencyID: 货币ID
---*  rebate: 折扣
---@param makeindex number
---@param count number
---@param bidPrice number
---@param buyPrice number
---@param currencyID number
---@param rebate number
---@return any
function SL:RequestAuctionPutin(makeindex, count, bidPrice, buyPrice, currencyID, rebate) end

---拍卖行请求下架
---*  makeindex: 物品唯一ID
---@param makeindex number
---@return any
function SL:RequestAuctionPutout(makeindex) end

---拍卖行请求重新上架
---*  makeindex: 物品唯一ID
---*  count: 数量
---*  bidPrice: 竞拍价格
---*  buyPrice: 一口价
---*  currencyID: 货币ID
---*  rebate: 折扣
---@param makeindex number
---@param count number
---@param bidPrice number
---@param buyPrice number
---@param currencyID number
---@param rebate number
---@return any
function SL:RequestAuctionRePutin(makeindex, count, bidPrice, buyPrice, currencyID, rebate) end

---拍卖行请求竞价
---*  makeindex: 物品唯一ID
---*  price: 竞拍价
---@param makeindex number
---@param price number
---@return any
function SL:RequestAuctionBid(makeindex, price) end

---拍卖行请求领取竞拍成功物品
---*  makeindex: 物品唯一ID
---@param makeindex number
---@return any
function SL:RequestAcquireBidItem(makeindex) end

---请求排行榜数据
---*  type: 类别ID
---@param type number
---@return any
function SL:RequestRankData(type) end

---请求玩家排行榜数据
---*  userID: 玩家ID
---*  type: 玩家/英雄 1玩家 2英雄
---@param userID number
---@param type number
---@return any
function SL:RequestPlayerRankData(userID, type) end

---提交任务
---*  missionID: 任务ID
---@param missionID number
---@return any
function SL:RequestSubmitMission(missionID) end

---请求玩家称号数据
---@return any
function SL:ResquestTitleList() end

---请求取下称号
---@return any
function SL:ResquestDisboardTitle() end

---请求激活称号
---*  titleId: 称号ID
---@param titleId number
---@return any
function SL:ResquestActivateTitle(titleId) end


---通知服务端 时装显示开关
---*  type: int -- 2 : 设置显示神魔, 1 : 设置时装显示
---@param type number
---@return any
function SL:SendSuperEquipSetting(type) end

---切换英雄状态
---*  type: 状态值
---@param type number
---@return any
function SL:RequestChangeHeroMode(type) end

---请求英雄称号数据
---@return any
function SL:ResquestTitleList_Hero() end

---英雄请求取下称号
---@return any
function SL:ResquestDisboardTitle_Hero() end

---英雄请求激活称号
---*  titleId: 称号id
---@param titleId number
---@return any
function SL:ResquestActivateTitle_Hero(titleId) end

---通知服务端 英雄时装显示开关
---*  type: int -- 2 : 设置显示神魔, 1 : 设置时装显示
---@param type number
---@return any
function SL:SendSuperEquipSetting_Hero(type) end

---请求合成
---@return any
function SL:ResquestCompoundItem() end

---请求敏感词检测
---*  str: 需要检测的文本
---*  type: 文本类型 int -- 1 : 昵称类, 2 : 聊天类, 3 : 行会公告
---*  callback: function -- 检测完毕的回调事件, 事件传入参数: param1: boolean 能否通过 param2: 文本
---@param str string
---@param type number
---@param callback function
---@return any
function SL:RequestCheckSensitiveWord(str, type, callback) end

---邀请上马
---*  uid: 玩家id
---@param uid number
---@return any
function SL:RequestInviteInHorse(uid) end

---请求地图组队成员数据
---@return any
function SL:RequestMiniMapTeam() end

---请求地图怪物数据
---@return any
function SL:RequestMiniMapMonsters() end

---请求内功技能数据
---*  isHero: boolean -- 是否请求英雄
---@param isHero? boolean
---@return any
function SL:RequestInternalSkillData(isHero) end

---请求经络穴位激活
---*  typeID: 经络ID
---*  aucPointID: 穴位ID
---*  isHero: boolean -- 是否请求英雄
---@param typeID number
---@param aucPointID number
---@param isHero? boolean
---@return any
function SL:RequestAucPointOpen(typeID, aucPointID, isHero) end

---修炼经络
---*  typeID: 经络ID
---*  isHero: boolean -- 是否请求英雄
---@param typeID number
---@param isHero? boolean
---@return any
function SL:RequestMeridianLevelUp(typeID, isHero) end

---设置连击技能
---*  key: int -- 键位 (1, 2, 3, 4)
---*  skillID: 技能ID
---*  isHero: boolean -- 是否请求英雄
---@param key number
---@param skillID? number
---@param isHero? boolean
---@return any
function SL:RequestSetComboSkill(key, skillID, isHero) end

---请求获取宝箱物品奖励
---@return any
function SL:RequestGetGoldBoxReward() end

---请求再开启宝箱
---@return any
function SL:RequestOpenGoldBox() end

---请求确认加属性点 [新版属性加点]
---*  data: table -- 加点数据table {"Bonus":[{"id":1,"value":1}, ...]}
---*  m_nBonusPoint: int -- 剩余加点数
---@param data table
---@param m_nBonusPoint number
---@return any
function SL:RequestAddReinAttr_N(data, m_nBonusPoint) end

---请求求购数据
---*  data: table -- 请求参数
---@return any
function SL:RequestPurchaseItemList(data) end

---请求求购出售物品
---*  data: table -- 请求参数 {guid = 求购列表标识id, qty = 出售数量}
---@param data table
---@return any
function SL:RequestPurchaseSell(data) end

---请求上架求购物品
---*  data: table -- 请求参数
---@param data table
---@return any
function SL:RequestPurchasePutIn(data) end


---设置连击技能
---*  key: int -- 键位 (1, 2, 3, 4)
---*  skillID: 技能ID
---*  isHero: boolean -- 是否请求英雄
---@param key number
---@param skillID number
---@param isHero? boolean
---@return any
function SL:RequestSetComboSkill(key, skillID, isHero) end

---请求获取宝箱物品奖励
---@return any
function SL:RequestGetGoldBoxReward() end

---请求再开启宝箱
---@return any
function SL:RequestOpenGoldBox() end

---请求确认加属性点 [新版属性加点]
---*  data: table -- 加点数据table {"Bonus":[{"id":1,"value":1}, ...]}
---*  m_nBonusPoint: int -- 剩余加点数
---@param data table
---@param m_nBonusPoint number
---@return any
function SL:RequestAddReinAttr_N(data, m_nBonusPoint) end

---请求求购数据
---*  data: table -- 请求参数
---@param data table
---@return any
function SL:RequestPurchaseItemList(data) end

---请求求购出售物品
---*  data: table -- 请求参数 {guid = 求购列表标识id, qty = 出售数量}
---@param data table
---@return any
function SL:RequestPurchaseSell(data) end

---请求上架求购物品
---*  data: table -- 请求参数
---@param data table
---@return any
function SL:RequestPurchasePutIn(data) end

---请求下架求购物品
---*  guid: 求购列表标识id, 不填则全部下架
---@param guid? number
---@return any
function SL:RequestPurchasePutOut(guid) end

---设置连击技能
---*  key: int -- 键位 (1, 2, 3, 4)
---*  skillID: 技能ID
---*  isHero: boolean -- 是否请求英雄
---@param key number
---@param skillID number
---@param isHero? boolean
---@return any
function SL:RequestSetComboSkill(key, skillID, isHero) end

---请求获取宝箱物品奖励
---@return any
function SL:RequestGetGoldBoxReward() end

---请求再开启宝箱
---@return any
function SL:RequestOpenGoldBox() end

---请求确认加属性点 [新版属性加点]
---*  data: table -- 加点数据table {"Bonus":[{"id":1,"value":1}, ...]}
---*  m_nBonusPoint: int -- 剩余加点数
---@param data table
---@param m_nBonusPoint number
---@return any
function SL:RequestAddReinAttr_N(data, m_nBonusPoint) end

---请求求购数据
---*  data: table -- 请求参数
---@param data table
---@return any
function SL:RequestPurchaseItemList(data) end

---请求求购出售物品
---*  data: table -- 请求参数 {guid = 求购列表标识id, qty = 出售数量}
---@param data table
---@return any
function SL:RequestPurchaseSell(data) end

---请求上架求购物品
---*  data: table -- 请求参数
---@param data table
---@return any
function SL:RequestPurchasePutIn(data) end

---请求下架求购物品
---*  guid: 求购列表标识id, 不填则全部下架
---@param guid number
---@return any
function SL:RequestPurchasePutOut(guid) end

--元变量"
SW_KEY_AUCTION                          = "服务器开关 拍卖"
SW_KEY_ALL_FIGHTPAGES                   = "服务器开关 显示所有战斗页"
SW_KEY_MISSTION                         = "服务器开关 任务"
SW_KEY_SNDAITEMBOX                      = "服务器开关 是否显示首饰盒"
SW_KEY_TRADE_DEAL                       = "服务器开关 面对面交易 true/需要面对面"
SW_KEY_AUTO_DRESS                       = "服务器开关 自动穿戴"
SW_KEY_OPEN_F_EQUIP                     = "服务器开关 时装是否开启首饰"
SW_KEY_BIND_GOLD                        = "服务器开关 开启元宝替换绑元"
SW_KEY_NPC_BUTTON                       = "服务器开关 显示npc按钮"
SW_KEY_NPC_NAME                         = "服务器开关 显示npc名字 1:不显示"
SW_KEY_DROP_TIPS                        = "服务器开关 显示绑定丢弃提示 0:显示"
SW_KEY_EXP_IN_CHAT                      = "服务器开关 经验信息是否显示在聊天框 0:显示在聊天框"
SW_KEY_SHOW_STALL_NAME                  = "服务器开关 是否显示默认摊位名字  0:显示"
SW_KEY_PLAYER_BLUE_BLOOD                = "服务器开关  是否显示蓝条HUD_SPRITE_MP   0: 显示"
SW_KEY_ITEMTIPS_TOUBAO_SHOW             = "服务器开关  是否显示itemtips的投保描述   1= 开启 0 = 关闭"
SW_KEY_BAN_DOUBLE_FIREHIT               = "服务器开关  是否禁止双烈火    1:禁止"
SW_KEY_ALL_TEAM_EXP                     = "服务器开关 是否开启全队经验 true/false"
SW_KEY_EQUIP_EXTRA_POS                  = "服务器开关，是否有额外的装备位置  1= 开启 0 = 关闭"

--游戏事件
LUA_EVENT_ROLE_PROPERTY_INITED          =   "玩家角色属性初始化完毕"
LUA_EVENT_ROLE_PROPERTY_CHANGE          =   "玩家属性变化时"
LUA_EVENT_LEVELCHANGE                   =   "等级改变"
LUA_EVENT_REINLEVELCHANGE		        =   "转生等级改变"
LUA_EVENT_HPMPCHANGE                    =   "HP/MP改变"
LUA_EVENT_EXPCHANGE                     =   "EXP改变"
LUA_EVENT_BATTERYCHANGE                 =   "电池电量改变"
LUA_EVENT_NETCHANGE                     =   "网络状态改变"
LUA_EVENT_WEIGHTCHANGE			        =   "负重改变"
LUA_EVENT_PKMODECHANGE                  =   "pk模式改变"
LUA_EVENT_AFKBEGIN                      =   "自动挂机开始"
LUA_EVENT_AFKEND                        =   "自动挂机结束"
LUA_EVENT_AUTOMOVEBEGIN                 =   "自动寻路开始"
LUA_EVENT_AUTOMOVEEND                   =   "自动寻路结束"
LUA_EVENT_AUTOPICKBEGIN                 =   "自动捡物开始"
LUA_EVENT_AUTOPICKEND                   =   "自动捡物结束"
LUA_EVENT_MAINBUFFUPDATE                =   "主玩家buff刷新"
LUA_EVENT_BUFFUPDATE                    =   "通用buff刷新"
LUA_EVENT_TALKTONPC                     =   "与NPC对话"
LUA_EVENT_CHANGESCENE                   =   "切换地图(包含同地图)"
LUA_EVENT_MAPINFOCHANGE                 =   "切换地图(不同地图)"
LUA_EVENT_MAPINFOINIT			        =   "地图初始化"
LUA_EVENT_MAP_STATE_CHANGE              =   "地图状态改变"
LUA_EVENT_MAP_SIEGEAREA_CHANGE          =   "地图攻城区域状态改变"
LUA_EVENT_CLOSEWIN                      =   "关闭界面"
LUA_EVENT_WINDOW_CHANGE                 =   "窗体尺寸改变"
LUA_EVENT_DEVICE_ROTATION_CHANGED       =   "设备方向改变"
LUA_EVENT_MONEYCHANGE                   =   "货币变化"
LUA_EVENT_GUILD_MAIN_INFO               =   "行会信息刷新"
LUA_EVENT_GUILD_CREATE                  =   "行会创建消耗"
LUA_EVENT_GUILD_WORLDLIST               =   "世界行会列表刷新"
LUA_EVENT_GUILD_APPLYLIST               =   "入会申请列表刷新"
LUA_EVENT_GUILDE_ALLY_APPLY_UPDATE      =   "结盟申请列表刷新"
LUA_EVENT_TRADE_MONEY_CHANGE            =   "对方交易货币改变"
LUA_EVENT_TRADE_MY_MONEY_CHANGE         =   "自己交易货币改变"
LUA_EVENT_TRADE_STATUS_CHANGE           =   "对方交易状态改变"
LUA_EVENT_TRADE_MY_STATUS_CHANGE        =   "自己交易状态改变"
LUA_EVENT_ADDFIREND                     =   "添加好友"
LUA_EVENT_REMFIREND                     =   "删除好友"
LUA_EVENT_JOINTEAM                      =   "加入队伍"
LUA_EVENT_LEAVETEAM                     =   "离开队伍"
LUA_EVENT_REF_ITEM_LIST                 =   "刷新背包道具列表"
LUA_EVENT_PLAYER_EQUIP_CHANGE           =   "角色装备数据操作"
LUA_EVENT_BAG_ITEM_CHANGE               =   "背包数据变化"
LUA_EVENT_REF_HERO_ITEM_LIST            =   "刷新英雄背包道具列表"
LUA_EVENT_HERO_EQUIP_CHANGE             =   "英雄装备变化"
LUA_EVENT_HERO_BAG_ITEM_CAHNGE          =   "英雄背包数据变化"
LUA_EVENT_DISCONNECT                    =   "断线"
LUA_EVENT_RECONNECT                     =   "重连"
LUA_EVENT_TAKE_ON_EQUIP                 =   "玩家穿戴装备"
LUA_EVENT_TAKE_OFF_EQUIP                =   "玩家脱掉装备"
LUA_EVENT_HERO_TAKE_ON_EQUIP            =   "英雄穿戴装备"
LUA_EVENT_HERO_TAKE_OFF_EQUIP           =   "英雄脱掉装备"
LUA_EVENT_SETTING_CAHNGE                =   "设置项改变"
LUA_EVENT_BESTRINGBOX_STATE             =   "首饰盒状态改变"
LUA_EVENT_ACTOR_IN_OF_VIEW              =   "玩家/怪物/NPC进视野"
LUA_EVENT_ACTOR_OUT_OF_VIEW             =   "玩家/怪物/NPC出视野"
LUA_EVENT_DROPITEM_IN_OF_VIEW           =   "掉落物进视野"
LUA_EVENT_DROPITEM_OUT_OF_VIEW          =   "掉落物出视野"
LUA_EVENT_TARGET_HP_CHANGE              =   "目标血量变化"
LUA_EVENT_TARGET_CAHNGE                 =   "目标改变"
LUA_EVENT_ACTOR_OWNER_CHANGE            =   "目标归属改变"
LUA_EVENT_HERO_ANGER_CAHNGE             =   "英雄怒气改变"
LUA_EVENT_PLAYER_BEHAVIOR_STATE_CAHNGE  =   "玩家行为状态改变（站立、走、跑等）"
LUA_EVENT_PLAYER_ACTION_BEGIN           =   "主玩家行为动作开始（站立、走、跑等）"
LUA_EVENT_PLAYER_ACTION_COMPLETE        =   "主玩家行为动作结束（站立、走、跑等）"
LUA_EVENT_NET_PLAYER_ACTION_BEGIN       =   "网络玩家行为动作开始（站立、走、跑等）"
LUA_EVENT_NET_PLAYER_ACTION_COMPLETE    =   "网络玩家行为动作结束（站立、走、跑等）"
LUA_EVENT_MONSTER_ACTION_BEGIN          =   "怪物行为动作开始（站立、走、跑等）"
LUA_EVENT_MONSTER_ACTION_COMPLETE       =   "怪物行为动作结束（站立、走、跑等）"
LUA_EVENT_ACTOR_GMDATA_UPDATE           =   "玩家/怪物 GM自定义数据改变"
LUA_EVENT_SKILL_INIT                    =   "初始化技能"
LUA_EVENT_SKILL_ADD                     =   "新增技能"
LUA_EVENT_SKILL_DEL                     =   "删除技能"
LUA_EVENT_SKILL_UPDATE                  =   "技能更新"
LUA_EVENT_SUMMON_MODE_CHANGE            =   "召唤物-状态改变"
LUA_EVENT_SUMMON_ALIVE_CHANGE           =   "召唤物-存活状态改变"
LUA_EVENT_BUBBLETIPS_STATUS_CHANGE      =   "气泡状态改变"
LUA_EVENT_PLAY_MAGICBALL_EFFECT         =   "脚本魔血球动画"
LUA_EVENT_AUTOFIGHT_TIPS_SHOW           =   "自动战斗提示显示与否"
LUA_EVENT_AUTOMOVE_TIPS_SHOW            =   "自动寻路提示显示与否"
LUA_EVENT_AUTOPICK_TIPS_SHOW            =   "自动捡物提示显示与否"
LUA_EVENT_HERO_LOGIN_OROUT              =   "英雄登录/登出"
LUA_EVENT_REIN_ATTR_CHANGE              =   "转生点数据变化"
LUA_EVENT_ASSIST_MISSION_TOP            =   "主界面-辅助-任务置顶"
LUA_EVENT_ASSIST_MISSION_ADD            =   "主界面-辅助-任务增加"
LUA_EVENT_ASSIST_MISSION_CHANGE         =   "主界面-辅助-任务改变"
LUA_EVENT_ASSIST_MISSION_REMOVE         =   "主界面-辅助-任务移除"
LUA_EVENT_ASSIST_MISSION_SHOW           =   "主界面-辅助-任务显示和隐藏"
LUA_EVENT_TEAM_MEMBER_UPDATE            =   "主界面-辅助-队伍刷新"
LUA_EVENT_TEAM_NEAR_UPDATE              =   "附近队伍刷新"
LUA_EVENT_TEAM_APPLY_UPDATE             =   "申请入队列表刷新"
LUA_EVENT_RANK_PLAYER_UPDATE            =   "排行榜个人数据刷新"
LUA_EVENT_RANK_DATA_UPDATE              =   "排行榜分类数据刷新"
LUA_EVENT_BIND_MAINPLAYER               =   "绑定主玩家"
LUA_EVENT_PLAYER_MAPPOS_CHANGE          =   "主玩家位置改变"
LUA_EVENT_FRIEND_LIST_UPDATE            =   "好友列表刷新"
LUA_EVENT_FRIEND_APPLY                  =   "收到好友申请"
LUA_EVENT_MAIL_UPDATE                   =   "邮件列表刷新"
LUA_EVENT_ITEMTIPS_MOUSE_SCROLL         =   "ITEMTIPS鼠标滚轮滚动"
LUA_EVENT_PCMINIMAP_STATUS_CHANGE       =   "PC 主界面小地图展示状态改变"
LUA_EVENT_DARK_STATE_CHANGE             =   "黑夜状态改变"
LUA_EVENT_MONSTER_IGNORELIST_ADD        =   "设置-怪物忽略列表增加"
LUA_EVENT_BOSSTIPSLIST_ADD              =   "设置-boss提示-增加"
LUA_EVENT_MONSTER_NAME_RM               =   "设置-怪物类型删除"
LUA_EVENT_SKILL_RANKDATA_ADD            =   "设置-技能数据添加"
LUA_EVENT_SKILLBUTTON_DISTANCE_CHANGE   =   "技能边距调整"
LUA_EVENT_PLAYER_FRAME_PAGE_ADD         =   "角色框增加子页"
LUA_EVENT_PLAYER_FRAME_NAME_RRFRESH     =   "角色外框角色名刷新"
LUA_EVENT_PLAYER_LOOK_FRAME_PAGE_ADD    =   "查看他人角色框增加子页"
LUA_EVENT_PLAYER_GUILD_INFO_CHANGE      =   "玩家行会信息改变"
LUA_EVENT_HERO_FRAME_PAGE_ADD           =   "英雄框增加子页"
LUA_EVENT_HERO_FRAME_NAME_RRFRESH       =   "英雄框名字刷新"
LUA_EVENT_HERO_LOOK_FRAME_PAGE_ADD      =   "查看他人英雄框增加子页"
LUA_EVENT_SERVER_VALUE_CHANGE           =   "服务器下发的变量改变"
LUA_EVENT_MAIN_PLAYER_REVIVE            =   "主玩家复活"
LUA_EVENT_NET_PLAYER_REVIVE             =   "网络玩家复活"
LUA_EVENT_MONSTER_REVIVE                =   "怪物复活"
LUA_EVENT_MAIN_PLAYER_DIE               =   "主玩家死亡"
LUA_EVENT_NET_PLAYER_DIE                =   "网络玩家死亡"
LUA_EVENT_MONSTER_DIE                   =   "怪物死亡"
LUA_EVENT_NPCLAYER_OPENSTATUS           =   "NPC界面打开/关闭状态刷新"
LUA_EVENT_NPC_TALK                      =   "NPC对话"
LUA_EVENT_MINIMAP_FIND_PATH             =   "寻路路径"
LUA_EVENT_MINIMAP_MONSTER               =   "小地图怪物数据刷新"
LUA_EVENT_MINIMAP_PLAYER                =   "小地图人物坐标刷新"
LUA_EVENT_MINIMAP_TEAM                  =   "小地图组队成员数据刷新"
LUA_EVENT_MINIMAP_RELEASE               =   "小地图释放内存"
LUA_EVENT_TRAD_PLAYER_LOOK_FRAME_PAGE_ADD="交易行查看他人玩家框增加子页"
LUA_EVENT_TRAD_HERO_LOOK_FRAME_PAGE_ADD="交易行查看他人英雄框增加子页"
LUA_EVENT_PLAYER_INTERNAL_FORCE_CHANGE="人物内力值改变"
LUA_EVENT_PLAYER_INTERNAL_EXP_CHANGE="人物内功经验值改变"
LUA_EVENT_PLAYER_INTERNAL_LEVEL_CHANGE="人物内功等级改变"
LUA_EVENT_INTERNAL_SKILL_ADD="人物内功技能增加"
LUA_EVENT_INTERNAL_SKILL_DEL="人物内功技能删除"
LUA_EVENT_INTERNAL_SKILL_UPDATE="人物内功技能刷新"
LUA_EVENT_PLAYER_LEARNED_INTERNAL="人物学习内功"
LUA_EVENT_MERIDIAN_DATA_REFRESH="人物内功经络数据刷新"
LUA_EVENT_PLAYER_INTERNAL_DZVALUE_CHANGE="人物内功斗转值改变/恢复"
LUA_EVENT_PLAYER_COMBO_SKILL_ADD="人物连击技能增加"
LUA_EVENT_PLAYER_COMBO_SKILL_DEL="人物连击技能删除"
LUA_EVENT_PLAYER_COMBO_SKILL_UPDATE="人物连击技能刷新"
LUA_EVENT_PLAYER_SET_COMBO_REFRESH="人物设置的连击技能刷新"
LUA_EVENT_PLAYER_COMBO_SKILLCD_STATE="人物连击技能CD状态"
LUA_EVENT_PLAYER_OPEN_COMBO_NUM="人物开启连击格子数"
LUA_EVENT_HERO_INTERNAL_FORCE_CHANGE="英雄内力值改变"
LUA_EVENT_HERO_INTERNAL_EXP_CHANGE="英雄内功经验值改变"
LUA_EVENT_HERO_INTERNAL_LEVEL_CHANGE="英雄内功等级改变"
LUA_EVENT_HERO_INTERNAL_SKILL_ADD="英雄内功技能增加"
LUA_EVENT_HERO_INTERNAL_SKILL_DEL="英雄内功技能删除"
LUA_EVENT_HERO_INTERNAL_SKILL_UPDATE="英雄内功技能刷新"
LUA_EVENT_HERO_LEARNED_INTERNAL="英雄学习内功"
LUA_EVENT_HERO_MERIDIAN_DATA_REFRESH="英雄内功经络数据刷新"
LUA_EVENT_HERO_INTERNAL_DZVALUE_CHANGE="英雄内功斗转值改变/恢复"
LUA_EVENT_HERO_COMBO_SKILL_ADD="英雄连击技能增加"
LUA_EVENT_HERO_COMBO_SKILL_DEL="英雄连击技能删除"
LUA_EVENT_HERO_COMBO_SKILL_UPDATE="英雄连击技能刷新"
LUA_EVENT_HERO_SET_COMBO_REFRESH="英雄设置连击技能刷新"
LUA_EVENT_HERO_OPEN_COMBO_NUM="英雄开启连击格子数"
LUA_EVENT_HERO_PROPERTY_CHANGE="英雄属性变化"
LUA_EVENT_NOTICE_SERVER="顶部跑马灯 全服公告"
LUA_EVENT_NOTICE_SERVER_EVENT="屏幕跑马灯 系统公告"
LUA_EVENT_NOTICE_SYSYTEM="屏幕跑马灯公告 可控制Y轴"
LUA_EVENT_NOTICE_SYSYTEM_SCALE="系统公告缩放 "
LUA_EVENT_NOTICE_SYSYTEM_XY="跑马灯公告 可控制XY轴"
LUA_EVENT_NOTICE_SYSYTEM_TIPS="系统 提示弹窗"
LUA_EVENT_NOTICE_TIMER="聊天上方倒计时公告"
LUA_EVENT_NOTICE_DELETE_TIMER="移除倒计时公告"
LUA_EVENT_NOTICE_ITEM_TIPS="飘字 物品获取/消耗提示"
LUA_EVENT_NOTICE_ATTRIBUTE="飘字 属性变化"
LUA_EVENT_NOTICE_EXP="飘字 经验变化"
LUA_EVENT_NOTICE_DROP="公告 掉落物品提示"
LUA_EVENT_RICHTEXT_OPEN_URL="富文本超链(href)点击触发"
LUA_EVENT_KF_STATUS_CHANGE="跨服状态改变"
LUA_EVENT_QUICKUSE_DATA_OPER="快捷栏道具数据变动触发"
LUA_EVENT_ENTER_WORLD="进入游戏世界 主界面已经初始化"
LUA_EVENT_LEAVE_WORLD="离开游戏世界 小退触发"
LUA_EVENT_PLAYER_IN_SAFEZONE_CHANGE="主玩家安全区状态改变"
LUA_EVENT_NET_PLAYER_IN_SAFEZONE_CHANGE="网络玩家安全区状态改变"
LUA_EVENT_PLAYER_STALL_STATUS_CHANGE="主玩家摆摊状态改变"
LUA_EVENT_NET_PLAYER_STALL_STATUS_CHANGE="网络玩家摆摊状态改变"
LUA_EVENT_PLAYER_HUSHEN_STATUS_CHANGE="主玩家护身状态改变"
LUA_EVENT_NET_PLAYER_HUSHEN_STATUS_CHANGE="网络玩家护身状态改变"
LUA_EVENT_PLAYER_TEAM_STATUS_CHANGE="主玩家组队状态改变"
LUA_EVENT_NET_PLAYER_TEAM_STATUS_CHANGE="网络玩家组队状态改变"
LUA_EVENT_PURCHASE_ITEM_LIST_PULL="求购列表数据返回"
LUA_EVENT_PURCHASE_ITEM_LIST_COMPLETE="求购列表加载完成"
LUA_EVENT_PURCHASE_SEARCH_ITEM_UPDATE="求购搜索参数刷新"
LUA_EVENT_PURCHASE_MYITEM_UPDATE="我的求购数据刷新"
LUA_EVENT_PURCHASE_WORLDITEM_UPDATE="世界求购数据刷新"
LUA_EVENT_RED_POINT_ADD="红点增 (按红点表cfg_redpoint配置)"
LUA_EVENT_RED_POINT_DEL="红点删 (按红点表cfg_redpoint配置)"
LUA_EVENT_FLYIN_BTN_ITEM_COMPLETE="道具飞入指定按钮完成"
LUA_EVENT_COMPOUND_RED_POINT="红点"

--窗口事件 RegisterWndEvent
WND_EVENT_MOUSE_LB_DOWN             = "鼠标左键按下事件"
WND_EVENT_MOUSE_LB_UP               = "鼠标左键弹起事件"
WND_EVENT_MOUSE_LB_CLICK            = "鼠标左键点击事件"
WND_EVENT_MOUSE_LB_DBCLICK          = "鼠标左键双击事件"
WND_EVENT_MOUSE_RB_DOWN             = "鼠标右键按下事件"
WND_EVENT_MOUSE_RB_UP               = "鼠标右键弹起事件"
WND_EVENT_MOUSE_RB_CLICK            = "鼠标右键点击事件"
WND_EVENT_MOUSE_RB_DBCLICK          = "鼠标右键双击事件"
WND_EVENT_MOUSE_MOVE                = "鼠标移动事件"
WND_EVENT_MOUSE_WHEEL               = "鼠标滚轮滚动事件"
WND_EVENT_MOUSE_IN                  = "鼠标进入控件事件"
WND_EVENT_MOUSE_OUT                 = "鼠标离开控件事件"
WND_EVENT_WND_VISIBLE               = "可见状态发生变化事件"
WND_EVENT_WND_POS_CHANGE            = "控件位置发生变化事件"
WND_EVENT_WND_SIZECHANGE            = "窗口大小发生变化事件"
WND_EVENT_WND_DESTROY               = "窗体被销毁事件"

return SL