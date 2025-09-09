---@meta GUI

---@class GUIlib

GUI = {}

---打开面板
---*  filename : 面板文件名
---@param filename 	string
---@return any
function GUI:Win_Open(filename) end

---创建窗口控件
---*  ID : 控件ID
---*  PosX : 控件位置的横坐标
---*  PosY : 控件位置的纵坐标
---*  Width : 控件的宽
---*  Height : 控件的高
---*  Main : 是否隐藏主界面
---*  Last : 是否隐藏上一个界面
---*  NeedVoice : 是否点击时有音效
---*  EscClose : 是否esc关闭(客户端)
---*  isRevmsg : 是否pc鼠标经过吞噬，默认true
---*  npcID : 绑定npcid
---@param ID string
---@param PosX integer
---@param PosY integer
---@param Width integer
---@param Height integer
---@param Main? boolean
---@param Last? boolean
---@param NeedVoice? boolean
---@param EscClose? boolean
---@param isRevmsg? boolean
---@param npcID? integer
---@param param? integer
---@return any
function GUI:Win_Create(ID,PosX,PosY,Width,Height,Main,Last,NeedVoice,EscClose,isRevmsg,npcID,param) end

---关闭面板
---*  parent : 控件对象
---@param parent string
---@return any
function GUI:Win_Close(parent) end

---通过界面ID关闭界面
---*  ID : 控件ID
---@param ID string
---@return any
function GUI:Win_CloseByID(ID) end

---通过NPCID关闭界面
---*  NPCID : 绑定npcid
---@param NPCID integer
---@return any
function GUI:Win_CloseByNPCID(NPCID) end

---通过键盘的Esc键关闭界面
---*  NPCID : 绑定npcid
---*  parent : 控件对象
---*  isClose : 是否关闭

---@param parent string
---@param isClose boolean
---@return any
function GUI:Win_SetESCClose(parent,isClose) end

---获取控件对象
---*  parent : 父控件对象
---*  ID :控件ID
---@param parent userdata
---@param ID string
---@return any
function GUI:GetWindow(parent, ID) end

---设置控件自定义参数
---*  widget : 控件对象
---*  param : 	自定义参数
---@param widget userdata
---@param param integer
---@return any
function GUI:Win_SetParam(widget, param) end

---获取控件自定义参数
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Win_GetParam(widget) end

---设置界面拖动
---*  widget : 界面对象
---*  dragLayer : 点击控件对象
---@param widget userdata
---@param dragLayer userdata
---@return any
function GUI:Win_SetDrag(widget, dragLayer) end

---设置主界面隐藏
---*  widget : 界面对象
---*  value : 	是否隐藏主界面 
---@param widget userdata
---@param value boolean
---@return any
function GUI:Win_SetMainHide(widget, value) end

---设置主界面隐藏
---*  widget : 界面对象
---*  value : 	能否关闭, 普通面板生效 
---@param widget userdata
---@param value boolean
---@return any
function GUI:Win_SetESCClose(widget, value) end

---设置控件绑定npc
---*  widget : 界面对象
---*  npcID : npcid
---@param widget userdata
---@param npcID integer
---@return any
function GUI:Win_BindNPC(widget, npcID) end

---设置界面浮起
---*  widget : 界面对象
---*  zPanel : 控件对象
---@param widget userdata
---@param zPanel integer
---@return any
function GUI:Win_SetZPanel(widget, zPanel) end

---设置界面绑定事件
---*  widget : 界面对象
---*  zPanel : 控件对象
---@param widget userdata
---@param eventID integer
---@param eventTag string
---@return any
function GUI:Win_SetZPanel(widget, eventID, eventTag) end

---设置界面内鼠标右键吞噬
---*  widget : 界面对象
---*  value : 	是否吞噬
---@param widget userdata
---@param value boolean
---@return any
function GUI:Win_SetSwallowRightMouseTouch(widget, value) end

---加载 GUIExport文件
---*  widget : 控件对象
---*  filename : Ctrl+f9 界面编辑器导出的lua文件(用法参考系统界面)
---@param widget userdata
---@param filename string
---@param func? function
---@return any
function GUI:LoadExport(widget,filename,func) end

---获取父节点的快捷子控件组
---*  widget : 父节点对象
---@param widget userdata
---@return any
function GUI:ui_delegate(widget) end

---设置控件位置
---*  widget : 控件对象
---*  x : 	控件x坐标
---*  y : 	控件y坐标
---@param widget userdata
---@param x integer|table
---@param y? integer
---@return any
function GUI:setPosition( widget, x, y) end

---获取控件位置
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getPosition( widget) end

---设置控件X坐标
---*  widget : 控件对象
---*  x : 	控件x坐标
---@param widget userdata
---@param x integer
---@return any
function GUI:setPositionX( widget, x) end

---获取控件X坐标
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getPositionX( widget) end

---设置控件Y坐标
---*  widget : 控件对象
---*  y : 	控件x坐标
---@param widget userdata
---@param y integer
---@return any
function GUI:setPositionY( widget, y) end

---获取控件Y坐标
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getPositionY( widget) end

---设置控件锚点
---*  widget : 控件对象
---*  x : 	控件横向锚点
---*  y : 	控件纵向锚点
---@param widget userdata
---@param x integer
---@param y integer
---@return any
function GUI:setAnchorPoint(widget, x, y) end

---获取控件锚点
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getAnchorPoint(widget) end

---设置控件尺寸大小
---*  widget : 控件对象
---*  sizeW : 	宽度
---*  sizeH : 	长度
---@param widget userdata
---@param sizeW integer|table
---@param sizeH? integer
---@return any
function GUI:setContentSize(widget, sizeW, sizeH) end

---获取控件尺寸大小(纹理大小 不考虑缩放)
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getContentSize(widget) end

---获取控件尺寸大小(考虑缩放的真实大小)
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getBoundingBox(widget) end

---设置控件标签
---*  widget : 控件对象
---@param widget userdata
---@param tag integer
---@return any
function GUI:setTag(widget,tag) end

---获取控件标签
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getTag(widget) end

---设置控件名字
---*  widget : 控件对象
---@param widget userdata
---@param name string
---@return any
function GUI:setName(widget,name) end

---设置控件置灰
---*  widget : 控件对象
---@param widget userdata
---@param isGrey boolean
---@return any
function GUI:setGrey(widget,isGrey) end

---设置控件旋转角度
---*  widget : 控件对象
---*  value : 旋转角度（0 - 360）
---@param widget userdata
---@param value integer
---@return any
function GUI:setRotation(widget,value) end

---获取控件旋转
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getRotation(widget) end


---设置控件X轴倾斜角度
---*  widget : 控件对象
---*  value : 旋转角度（0 - 360）
---@param widget userdata
---@param value integer
---@return any
function GUI:setRotationSkewX(widget,value) end

---设置控件Y轴倾斜角度
---*  widget : 控件对象
---*  value : 旋转角度（0 - 360）
---@param widget userdata
---@param value integer
---@return any
function GUI:setRotationSkewY(widget,value) end

---设置控件是否隐藏
---*  widget : 控件对象
---*  value : 	是否隐藏
---@param widget userdata
---@param value boolean
---@return any
function GUI:setVisible(widget, value) end

---获取控件是否隐藏
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getVisible(widget) end

---设置控件不透明度
---*  widget : 控件对象
---*  value : 	不透明度(0-255), 默认255
---@param widget userdata
---@param value integer
---@return any
function GUI:setOpacity(widget, value) end

---获取控件不透明度
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getOpacity(widget) end

---设置控件不透明度
---*  widget : 控件对象
---*  value : 	不透明度(0-255), 默认255
---@param widget userdata
---@param value integer
---@return any
function GUI:setOpacity(widget, value) end

---设置控件缩放
---*  widget : 控件对象
---@param widget userdata
---@param value integer
---@return any
function GUI:setScale(widget, value) end

---设置控件X轴方向缩放
---*  widget : 控件对象
---@param widget userdata
---@param value integer
---@return any
function GUI:setScaleX(widget, value) end

---设置控件Y轴方向缩放
---*  widget : 控件对象
---@param widget userdata
---@param value integer
---@return any
function GUI:setScaleY(widget, value) end

---获取控件缩放
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getScale(widget) end

---设置控件X轴方向缩放
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getScaleX(widget) end

---设置控件Y轴方向缩放
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getScaleY(widget) end

---设置水平X轴方向翻转
---*  widget : 控件对象
---*  value : 	是否翻转
---@param widget userdata
---@param value boolean
---@return any
function GUI:setFlippedX(widget, value) end

---获取是否水平X轴方向翻转
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getFlippedX(widget) end

---设置水平Y轴方向翻转
---*  widget : 控件对象
---*  value : 	是否翻转
---@param widget userdata
---@param value boolean
---@return any
function GUI:setFlippedY(widget, value) end

---获取是否水平Y轴方向翻转
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getFlippedY(widget) end

---设置控件渲染层级
---*  widget : 控件对象
---*  value : 	渲染层级, 值越大显示越靠前
---@param widget userdata
---@param value integer
---@return any
function GUI:setLocalZOrder(widget, value) end

---设置子控件是否跟随父控件变化
---*  widget : 父控件对象
---*  value : 是否跟随
---@param widget userdata
---@param value boolean
---@return any
function GUI:setCascadeOpacityEnabled(widget, value) end

---设置控件的所有子控件是否跟随变化透明度
---*  widget : 控件对象
---*  value : 是否跟随
---@param widget userdata
---@param value boolean
---@return any
function GUI:setChildrenCascadeOpacityEnabled(widget, value) end

---获取控件触摸起始位置
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getWorldPosition(widget) end

---添加控件到父控件中
---*  widget : 父控件对象
---*  child : 子控件对象
---@param widget userdata
---@param child userdata
---@return any
function GUI:addChild(widget, child) end

---克隆控件
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:Clone(widget) end

---设置控件是否可以点击
---*  widget : 控件对象
---*  value : 是否可点击
---@param widget userdata
---@param value boolean
---@return any
function GUI:setTouchEnabled(widget, value) end

---获取控件是否可以点击
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getTouchEnabled(widget) end

---获取父控件对象
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getParent(widget) end

---获取该控件的所有子控件对象
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getChildren(widget) end

---获取控件id
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getName(widget) end

---通过控件名字获取子节点对象
---*  widget : 控件对象
---@param widget userdata
---@param name string
---@return any
function GUI:getChildByName(widget,name) end

---通过控件名字获取子节点对象
---*  widget : 控件对象
---@param widget userdata
---@param tag integer
---@return any
function GUI:getChildByTag(widget,tag) end

---移除其下所有子控件
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:removeAllChildren(widget) end

---将传入控件从父节点上移除
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:removeFromParent(widget) end

---通过名字删除子节点
---*  widget : 控件对象
---*  name : 控件名字
---@param widget userdata
---@param name string
---@return any
function GUI:removeChildByName(widget,name) end

---设置控件点击事件
---*  widget : 控件对象
---*  func : 回调函数
---@param widget userdata
---@param func function
---@return any
function GUI:addOnClickEvent(widget, func) end

---设置控件触摸事件
---*  widget : 控件对象
---*  func : 回调函数
---@param widget userdata
---@param func function
---@return any
function GUI:addOnTouchEvent(widget, func) end

---设置控件长按事件
---*  widget : 控件对象
---*  func : 回调函数 
---@param widget userdata
---@param func function
---@return any
function GUI:addOnLongTouchEvent(widget, func) end

---设置控件鼠标进入/移出事件
---*  widget : 控件对象
---*  func : 回调函数 
---@param widget userdata
---@param func table
---@return any
function GUI:addMouseMoveEvent(widget, func) end

---设置鼠标经过tips
---*  widget : 控件对象
---*  str : tips文本
---*  pos : 位置
---*  anr : 锚点
---*  param : 检查接触点是否能展示
---@param widget userdata
---@param str string|function
---@param pos? table
---@param anr? table
---@param param? table
---@return any
function GUI:addMouseOverTips(widget,str,pos,anr,param) end

---获取点击吞噬
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:getSwallowTouches(widget) end

---开启定时器
---*  widget : 控件对象
---*  func : 回调函数 
---*  delay : 时间间隔 
---@param widget userdata
---@param func function
---@return any
function GUI:schedule(widget, func, delay) end

---停止定时器
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:unSchedule(widget) end

---键盘监听事件
---*  codeKeys : 要监听的键盘键key
---*  funcA : 按下回调 
---*  funcB : 松开回调 
---@param codeKeys string|table
---@param funcA? function
---@param funcB? function
---@return any
function GUI:addKeyboardEvent(codeKeys, funcA, funcB) end

---移除键盘监听
---*  codeKeys : 要监听的键盘键key
---@param codeKeys string|table
---@return any
function GUI:removeKeyboardEvent(codeKeys) end

---创建图片控件
---*  Parent : 父控件对象
---*  ID : 控件ID
---*  PosX :控件位置的横坐标
---*  PosY : 控件位置的纵坐标
---*  nimg : 图片路径
---@param Parent userdata|integer
---@param ID string
---@param PosX integer
---@param PosY integer
---@param nimg string
---@return any
function GUI:Image_Create( Parent, ID, PosX, PosY, nimg) end

---设置图片控件图片路径
---*  widget : 图片控件对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Image_loadTexture(widget, filepath) end

---设置图片控件九宫格参数
---*  widget : 图片控件对象
---*  scale9l : 左边比例
---*  scale9r : 右边比例
---*  scale9t : 上边比例
---*  scale9b : 下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:Image_setScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---设置图片是否变灰
---*  widget : 图片控件对象
---*  isGrey : 是否变灰
---@param widget userdata
---@param isGrey boolean
---@return any
function GUI:Image_setGrey( widget, isGrey ) end

---创建按钮控件
---*  Parent : 父控件对象
---*  ID : 控件ID
---*  PosX :控件位置的横坐标
---*  PosY : 控件位置的纵坐标
---*  nimg : 图片路径
---@param Parent userdata|integer
---@param ID string
---@param PosX integer
---@param PosY integer
---@param nimg string
---@return any
function GUI:Button_Create( Parent, ID, PosX, PosY, nimg) end

---设置按钮状态图片
---*  widget : 按钮控件对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Button_loadTextures(widget, filepath) end

---设置按钮正常状态图片
---*  widget : 按钮控件对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Button_loadTextureNormal(widget, filepath) end

---设置按钮按下状态图片
---*  widget : 按钮控件对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Button_loadTexturePressed(widget, filepath) end

---设置按钮禁用状态图片
---*  widget : 按钮控件对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Button_loadTextureDisabled(widget, filepath) end

---设置按钮文字
---*  widget : 按钮控件对象
---*  value : 按钮显示文本
---@param widget userdata
---@param value string
---@return any
function GUI:Button_setTitleText(widget, value) end

---设置按钮文字颜色
---*  widget : 按钮控件对象
---*  value : 色值（#000000）
---@param widget userdata
---@param value string
---@return any
function GUI:Button_setTitleColor(widget, value) end

---设置按钮文字大小
---*  widget : 按钮控件对象
---*  value : 字体大小
---@param widget userdata
---@param value integer
---@return any
function GUI:Button_setTitleFontSize(widget, value) end

---设置按钮文字样式
---*  widget : 按钮控件对象
---*  value : 字体样式
---@param widget userdata
---@param value string
---@return any
function GUI:Button_setTitleFontName(widget, value) end

---设置按钮文本最大宽度
---*  widget : 按钮控件对象
---*  value : 文本最大宽度
---@param widget userdata
---@param value integer
---@return any
function GUI:Button_setMaxLineWidth(widget, value) end

---设置按钮文本最大宽度
---*  widget : 按钮控件对象
---*  color : 描边色值
---*  outline : 描边大小
---@param widget userdata
---@param color string
---@param outline integer
---@return any
function GUI:Button_titleEnableOutline(widget, color,outline) end

---取消按钮文本描边
---*  widget : 按钮控件对象
---@param widget userdata
---@return any
function GUI:Button_titleDisableOutLine(widget) end

---设置按钮是否禁用
---*  widget : 按钮控件对象
---*  value : 是否禁用（可触摸）
---@param widget userdata
---@param value boolean
---@return any
function GUI:Button_setBright(widget, value) end

---设置按钮是否禁用
---*  widget : 按钮控件对象
---*  value : 是否禁用（不可触摸）
---@param widget userdata
---@param value boolean
---@return any
function GUI:Button_setBrightEx(widget, value) end

---设置按钮状态
---*  widget : 按钮控件对象
---*  value : 状态（0正常 1按下）
---@param widget userdata
---@param value integer
---@return any
function GUI:Button_setBrightStyle(widget, value) end

---设置按钮是否灰态
---*  widget : 按钮控件对象
---*  value : 是否灰态
---@param widget userdata
---@param value boolean
---@return any
function GUI:Button_setGrey(widget, value) end

---设置按钮九宫格
---*  widget : 按钮控件对象
---*  scale9l : 	左边比例
---*  scale9r : 	右边比例
---*  scale9t : 	上边比例
---*  scale9b : 	下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:Button_setScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---创建文本控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  fontSize : 字体大小
---*  fontColor : 	颜色
---*  str : 文本内容
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param fontSize integer
---@param fontColor string
---@param str string
---@return any
function GUI:Text_Create(parent, ID, x, y, fontSize, fontColor, str) end

---设置文本控件的文本
---*  widget : 控件对象
---*  value : 	文本
---@param widget userdata
---@param value string|integer
---@return any
function GUI:Text_setString(widget, value) end

---获取文本控件的文本
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:Text_getString(widget) end

---设置文本控件的文本颜色
---*  widget : 控件对象
---*  value : 色值(“#000000”)
---@param widget userdata
---@param value string
---@return any
function GUI:Text_setTextColor(widget, value) end

---设置文本控件的字体大小
---*  widget : 父控件对象
---*  value : 字体大小
---@param widget userdata
---@param value integer
---@return any
function GUI:Text_setFontSize(widget, value) end

---设置字体路径
---*  widget : 父控件对象
---*  value : 字体文件路径例: 'fonts/font.ttf'
---@param widget userdata
---@param value string
---@return any
function GUI:Text_setFontName(widget, value) end

---设置文本控件的文本描边
---*  widget : 控件对象
---*  color : 色值('#000000')
---*  size : 描边大小
---@param widget userdata
---@param color string
---@param size integer
---@return any
function GUI:Text_enableOutline(widget, color, size) end

---设置文本下划线
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:Text_enableUnderline(widget) end

---设置文本最大长度
---*  widget : 控件对象
---*  width : 文本最大长度(达到最大会自动换行)
---@param widget userdata
---@param width integer
---@return any
function GUI:Text_setMaxLineWidth(widget, width) end

---设置文本垂直对齐
---*  widget : 控件对象
---*  value : 0:顶对齐 1:垂直居中 2:底对齐
---@param widget userdata
---@param value integer
---@return any
function GUI:Text_setTextVerticalAlignment(widget, value) end

---设置文本水平对齐
---*  widget : 控件对象
---*  value : 0:顶对齐 1:垂直居中 2:底对齐
---@param widget userdata
---@param value integer
---@return any
function GUI:Text_setTextHorizontalAlignment(widget, value) end

---设置文本尺寸
---*  widget : 控件对象
---*  value : {width = 0, height = 0}
---@param widget userdata
---@param value integer|table
---@param value2? integer
---@return any
function GUI:Text_setTextAreaSize(widget, value,value2) end

---将文本控件设置为倒计时
---*  widget : 控件对象
---*  time : 	倒计时时间, 单位:秒
---*  callback : 每秒触发回调, 传入参数: 剩余时间
---@param widget userdata
---@param time integer
---@param callback? function
---@return any
function GUI:Text_COUNTDOWN(widget, time, callback) end

---创建Bmp文本
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  fontColor : 	颜色
---*  str : 文本内容
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param fontColor string
---@param str string
---@return any
function GUI:BmpText_Create(parent, ID, x, y, fontColor, str) end

---创建艺术字文本
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  stringValue : 文本内容
---*  charMapFile : 艺术字路径
---*  itemWidth : 艺术字路径
---*  itemWidth : 单个字体宽度
---*  itemHeight : 单个字体高度
---*  startCharMap : 起始字符设置(“/“)
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param stringValue string
---@param charMapFile string
---@param itemWidth integer
---@param itemHeight integer
---@param startCharMap string
---@return any
function GUI:TextAtlas_Create(parent, ID, x, y, stringValue, charMapFile, itemWidth, itemHeight, startCharMap) end

---设置艺术字配置
---*  widget : 艺术字对象
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  stringValue : 文本内容
---*  charMapFile : 艺术字路径
---*  itemWidth : 艺术字路径
---*  itemWidth : 单个字体宽度
---*  itemHeight : 单个字体高度
---*  startCharMap : 起始字符设置(“/“)
---@param widget userdata
---@param stringValue string
---@param charMapFile string
---@param itemWidth integer
---@param itemHeight integer
---@param startCharMap string
---@return any
function GUI:TextAtlas_setProperty(widget,  stringValue, charMapFile, itemWidth, itemHeight, startCharMap) end

---设置艺术字文本
---*  widget : 艺术字对象
---*  stringValue : 文本内容
---@param widget userdata
---@param stringValue string
---@return any
function GUI:TextAtlas_setString(widget,  stringValue) end

---创建富文本控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  str : 文本内容
---*  width : 富文本控件宽度
---*  Size : 字体大小
---*  Color : 颜色
---*  vspace : 富文本行间距
---*  hyperlinkCB : 超链回调函数
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param str string
---@param width integer
---@param Size? integer
---@param Color? string
---@param vspace? integer
---@param hyperlinkCB? function
---@return any
function GUI:RichText_Create(parent, ID, x, y, str, width, Size, Color, vspace, hyperlinkCB) end

---创建原始富文本
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  str : 文本内容
---*  width : 富文本控件宽度
---*  Size : 字体大小
---*  Color : 颜色
---*  vspace : 富文本行间距
---*  hyperlinkCB : 超链回调函数
---*  fontPath : 字体文件路径
---*  outlineParam : 描边参数 outline: 描边大小 outlineColor: 描边颜色
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param str string
---@param width integer
---@param Size? integer
---@param Color? string
---@param vspace? integer
---@param hyperlinkCB? function
---@param fontPath? string
---@param outlineParam? table
---@return any
function GUI:RichTextFCOLOR_Create(parent, ID, x, y, str, width, Size, Color, vspace, hyperlinkCB,fontPath,outlineParam) end

---创建滚动文本控件
---*  parent : 父控件对象
---*  ID :控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  width :滚动的宽度
---*  fontSize :字体大小
---*  fontColor : 颜色
---*  str : 文本内容
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param fontSize integer
---@param fontColor string
---@param str string
---@return any
function GUI:ScrollText_Create(parent, ID, x, y, width, fontSize, fontColor, str) end

---设置滚动文本控件的文本
---*  widget : 控件对象
---*  value : 文本 
---@param widget userdata
---@param value string
---@return any
function GUI:ScrollText_setString(widget, value) end

---获取滚动文本控件的文本
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:ScrollText_getString(widget) end

---设置滚动文本描边
---*  widget : 控件对象
---*  color : 描边色值(“#000000”)
---*  size : 描边大小
---@param widget userdata
---@param color string
---@param size integer
---@return any
function GUI:ScrollText_enableOutline(widget,color,size) end

---设置滚动文本水平居中方式
---*  widget : 控件对象
---*  value : 	1:左对齐2:居中3:右对齐 
---@param widget userdata
---@param value integer
---@return any
function GUI:ScrollText_setHorizontalAlignment(widget, value) end

---设置滚动文本字体颜色
---*  widget : 控件对象
---*  color : 描边色值(“#000000”)
---@param widget userdata
---@param color string
---@return any
function GUI:ScrollText_setTextColor(widget, color) end

---创建节点控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@return any
function GUI:Node_Create(parent, ID, x, y) end

---创建Widget
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@return any
function GUI:Node_Create(parent, ID, x, y ,width ,height) end

---创建物品框控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  itemData : 道具信息
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param itemData table
---@return any
function GUI:ItemShow_Create(parent, ID, x, y, itemData) end

---设置物品框点击事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:ItemShow_addReplaceClickEvent(widget, eventCB) end

---设置物品框双击事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:ItemShow_addDoubleEvent(widget, eventCB) end

---设置物品框长按事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:ItemShow_addPressEvent(widget, eventCB) end

---设置物品框是否变灰
---*  widget : 物品框对象
---*  isGrey : 是否变灰
---@param widget userdata
---@param isGrey boolean
---@return any
function GUI:ItemShow_setIconGrey( widget, isGrey) end

---设置物品框是否勾选
---*  itemShow : 物品框对象
---*  bool : 是否勾选
---@param itemShow userdata
---@param bool boolean
---@return any
function GUI:ItemShow_setItemShowChooseState(itemShow, bool) end

---设置物品框是否拖动
---*  itemShow : 物品框对象
---*  bool : 是否拖动
---@param itemShow userdata
---@param bool boolean
---@return any
function GUI:ItemShow_setMoveEable(itemShow, bool) end

---更新物品框是内容
---*  itemShow : 物品框对象
---*  itemData : 物品数据
---@param itemShow userdata
---@param itemData table
---@return any
function GUI:ItemShow_updateItem(itemShow, itemData) end

---调用GUILayout/Item.lua中的函数
---*  itemShow : 物品框对象
---*  funcname : GUILayout/Item.lua中的函数名字
---*  … : 可变参数
---@param itemShow userdata
---@param funcname string
---@param ... any
---@return any
function GUI:ItemShow_OnRunFunc(itemShow, funcname, ...) end

---创建复选框控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  nimg : 正常图片路径
---*  pimg : 选中图片路径
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param nimg string
---@param pimg string
---@return any
function GUI:CheckBox_Create(parent, ID, x, y, nimg, pimg) end

---设置复选框背景图片
---*  widget : 控件对象
---*  value : 默认状态图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:CheckBox_loadTextureBackGround(widget, filepath) end

---设置复选框选中状态图片路径
---*  widget : 控件对象
---*  filepath : 选中状态图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:CheckBox_loadTextureFrontCross(widget, filepath) end

---设置复选框禁用状态图片路径
---*  widget : 控件对象
---*  filepath : 禁用状态图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:CheckBox_loadTextureFrontCrossDisabled(widget, filepath) end

---设置复选框是否选中
---*  widget : 控件对象
---*  value : 是否选中
---@param widget userdata
---@param value boolean
---@return any
function GUI:CheckBox_setSelected(widget, value) end

---获取复选框是否选中
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:CheckBox_isSelected(widget) end


---设置复选框点击事件
---*  widget : 控件对象
---*  eventCB : 点击事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:CheckBox_addOnEvent(widget, eventCB) end

---创建输入框控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  width : 	控件的宽
---*  height : 控件的高
---*  fontSize : 字体大小
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param fontSize integer
---@return any
function GUI:TextInput_Create(parent, ID, x, y, width, height, fontSize) end

---设置输入框控件字体
---*  widget : 控件对象
---*  value : 	字体路径
---*  value2 : 	字体(“font.ttf”)
---@param widget userdata
---@param value string
---@param value2 string
---@return any
function GUI:TextInput_setFont(widget, value, value2) end

---设置输入框控件字体颜色
---*  widget : 控件对象
---*  value : 	字体颜色
---@param widget userdata
---@param value string
---@return any
function GUI:TextInput_setFontColor(widget, value) end

---设置输入框控件字体大小
---*  widget : 控件对象
---*  value : 	字体大小
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setFontSize(widget, value) end

---设置输入框占位文本字体
---*  widget : 控件对象
---*  value : 	字体路径
---*  value2 : 	字体(“font.ttf”)
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setPlaceholderFont(widget, value, value2) end

---设置输入框占位文本字体颜色
---*  widget : 控件对象
---*  value : 	字体颜色
---@param widget userdata
---@param value string
---@return any
function GUI:TextInput_setPlaceholderFontColor(widget, value) end

---设置输入框占位文本字体大小
---*  widget : 控件对象
---*  value : 	字体大小
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setPlaceholderFontSize(widget, value) end

---设置输入框占位文本
---*  widget : 控件对象
---*  value : 	文本
---@param widget userdata
---@param value string
---@return any
function GUI:TextInput_setPlaceHolder(widget, value) end

---设置输入框控件文本
---*  widget : 控件对象
---*  value : 	文本
---@param widget userdata
---@param value string|integer
---@return any
function GUI:TextInput_setString(widget, value) end

---获取输入框控件文本
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:TextInput_getString(widget) end

---设置输入框控件输入长度
---*  widget : 控件对象
---*  value : 输入长度
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setMaxLength(widget, value) end

---设置输入框水平对齐
---*  widget : 控件对象
---*  value : 对齐方式 0 顶对齐 1 底对齐 2 水平居中
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setTextHorizontalAlignment(widget, value) end

---设置输入框文本类型
---*  widget : 控件对象
---*  value : 文本类型 0 密码形式; 1 敏感数据输入; 2 每个单词首字符大写，并有提示; 3 第一句首字符大写，并有提示; 4 自动大写;
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setInputFlag(widget, value) end

---设置输入框键盘编辑类型
---*  widget : 控件对象
---*  value : 	类型:0 开启任何文本的输入键盘(含换行); 1 开启邮箱地址输入类型键盘;2 开启数字符号输入类型键盘;3 开启电话号码输入类型键盘;4 开启URL输入类型键盘;5 开启数字输入类型键盘(含小数点);6 开启任何文本的输入键盘(不含换行)
---@param widget userdata
---@param value integer
---@return any
function GUI:TextInput_setInputMode(widget, value) end

---设置输入框监听事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:TextInput_addOnEvent(widget, eventCB) end

---创建复选框控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  barimg : 滚动条背景图片
---*  pbarimg : 滚动条图片
---*  nimg : 滚动条拖动块图片
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param barimg string
---@param pbarimg string
---@param nimg string
---@return any
function GUI:Slider_Create(parent, ID, x, y, barimg, pbarimg, nimg) end

---设置滚动条背景图
---*  widget : 滚动条对象
---*  filepath : 背景图路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Slider_loadBarTexture(widget, filepath) end

---设置滚动条图片
---*  widget : 滚动条对象
---*  filepath : 背景图路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Slider_loadProgressBarTexture(widget, filepath) end

---设置滚动条拖动块普通图片
---*  widget : 滚动条对象
---*  filepath : 背景图路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:Slider_loadSlidBallTextureNormal(widget, filepath) end

---设置滚动条进度
---*  widget : 滚动条对象
---*  value : 滚动条进度(0-100)
---@param widget userdata
---@param value integer
---@return any
function GUI:Slider_setPercent(widget, value) end

---获得滚动条进度
---*  widget : 滚动条对象
---@param widget userdata
---@return any
function GUI:Slider_setPercent(widget) end


---设置滚动条触摸事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:Slider_addOnEvent(widget, eventCB) end

---创建圆形进度条控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  img : 图片路径
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param img string
---@param w? integer
---@param h? integer
---@return any
function GUI:ProgressTimer_Create(parent, ID, x, y, img,w,h) end

---设置圆形进度条控件进度值
---*  widget : 按钮对象
---*  value : 进度值（0-100）
---@param widget userdata
---@param value integer
---@return any
function GUI:ProgressTimer_setPercentage(widget, value) end

---获取圆形进度条控件的进度值
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:ProgressTimer_getPercentage(widget) end

---设置圆形进度条控件进方向
---*  widget : 控件对象
---*  value : true:顺时针 false:逆时针 
---@param widget userdata
---@param value boolean
---@return any
function GUI:ProgressTimer_setReverseDirection(widget, value) end

---设置圆形进度条动作和回调函数
---*  widget : 控件对象
---*  time : 时间
---*  from : 开始进度(0-100)
---*  to : 结束进度(0-100)
---*  completeCB : 回调函数
---@param widget userdata
---@param time integer
---@param from integer
---@param to integer
---@param completeCB function
---@return any
function GUI:ProgressTimer_progressFromTo(widget, time, from, to, completeCB) end

---设置圆形进度条动作和回调函数2
---*  widget : 控件对象
---*  time : 时间
---*  from : 开始进度(0-100)
---*  to : 结束进度(0-100)
---*  completeCB : 回调函数
---@param widget userdata
---@param time integer
---@param to integer
---@param completeCB function
---@param tag integer
---@return any
function GUI:ProgressTimer_progressTo(widget, time, to, completeCB,tag) end

---设置圆形进度条背景图
---*  widget : 控件对象
---*  img : 图片路径
---@param widget userdata
---@param img string
---@return any
function GUI:ProgressTimer_ChangeImg(widget, img) end

---创建进度条控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  nimg : 	图片路径
---*  directtion : 方向 0:从左到右 1:从右到左
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param nimg string
---@param directtion integer
---@return any
function GUI:LoadingBar_Create(parent, ID, x, y, nimg, directtion) end

---设置进度条控件图片
---*  widget : 按钮对象
---*  filepath : 图片路径
---@param widget userdata
---@param filepath string
---@return any
function GUI:LoadingBar_loadTexture(widget, filepath) end

---设置进度条控件方向
---*  widget : 按钮对象
---*  value : 方向 0:从左到右 1:从右到左
---@param widget userdata
---@param value integer
---@return any
function GUI:LoadingBar_setDirection(widget, value) end

---设置进度条控件进度值
---*  widget : 按钮对象
---*  value : 进度值（0-100）
---@param widget userdata
---@param value integer
---@return any
function GUI:LoadingBar_setPercent(widget, value) end

---获取进度条控件的进度值
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:LoadingBar_getPercent(widget) end

---设置进度条控件颜色
---*  widget : 进度条对象
---*  value : 	颜色值(“#000000”)
---@param widget userdata
---@param value string
---@return any
function GUI:LoadingBar_setColor(widget, value) end

---获取进度条颜色
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:LoadingBar_getColor(widget) end


---创建特效控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  effecttype : 特效类型 0:特效、1:NPC、2:怪物、3:技能、4:人物、5:武器、6:翅膀、7:发型
---*  effectid : 	特效ID
---*  sex : 性别(0 男 1 女)
---*  act : 特效动作 0.待机 1.走 2.攻击 3.施法 4.死亡 5.跑步
---*  dir : 特效方向
---*  speed : 播放速度
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param effecttype integer
---@param effectid integer
---@param sex? integer
---@param act? integer
---@param dir? integer
---@param speed? integer
---@return any
function GUI:Effect_Create(parent, ID, x, y, effecttype, effectid, sex, act, dir, speed) end

---设置特效播放
---*  widget : 控件对象
---*  act : 特效动作 0.待机 1.走 2.攻击 3.施法 4.死亡 5.跑步
---*  dir : 特效方向
---*  isLoop : 是否循环
---*  speed : 播放速度
---*  isSequence : 是否暂停最后一帧
---@param widget userdata
---@param act integer
---@param dir integer
---@param isLoop boolean
---@param speed? integer
---@param isSequence? integer|boolean
---@return any
function GUI:Effect_play(widget, act, dir, isLoop, speed, isSequence) end

---设置特效停止
---*  widget : 控件对象
---*  frameIndex : 停在第几帧
---*  act : 特效动作 0.待机 1.走 2.攻击 3.施法 4.死亡 5.跑步….
---*  dir : 特效方向 
---@param widget userdata
---@param frameIndex? integer
---@param act? intege
---@param dir? integer
---@return any
function GUI:Effect_stop(widget, frameIndex, act, dir) end

---设置特效播放完成事件
---*  widget : 控件对象
---*  value : 回调函数
---@param widget userdata
---@param func function
---@return any
function GUI:Effect_addOnCompleteEvent(widget, func) end

---设置打开面板特效(小-大)1
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window1(widget) end

---设置打开面板特效(小-大)2
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window2(widget) end

---设置打开面板特效(小-大)3
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window3(widget) end

---设置打开面板特效(大-小)4
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window4(widget) end

---设置打开面板特效(大-小)5
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window5(widget) end

---设置打开面板特效(大-小)6
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_Window6(widget) end

---设置动画标记
---*  widget : 父控件对象
---@param widget userdata
---@param tag integer
---@return any
function GUI:Timeline_SetTag(widget,tag) end

---停止所有动画
---*  widget : 父控件对象
---@param widget userdata
---@return any
function GUI:Timeline_StopAll(widget) end

---通过标记停止动画
---*  widget : 父控件对象
---*  widget : 标记值
---@param widget userdata
---@param tag integer
---@return any
function GUI:Timeline_StopByTag(widget,tag) end

---设置控件淡出
---*  widget : 控件对象
---*  time : 过程耗时
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_FadeOut(widget, time, timelineCB) end

---设置控件淡入
---*  widget : 控件对象
---*  time : 过程耗时
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_FadeIn(widget, time, timelineCB) end

---修改透明度到某个值
---*  widget : 控件对象
---*  value : 透明度
---*  time : 过程耗时
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_FadeTo(widget, value, time, timelineCB) end

---设置控件缩放至一个值
---*  widget : 控件对象
---*  value : 缩放比例(0-100)
---*  time : 过程耗时
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_ScaleTo(widget, value, time, timelineCB) end

---设置控件缩放动画
---*  widget : 控件对象
---*  value : 缩放比例(0-100)
---*  time : 动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_ScaleBy(widget, value, time, timelineCB) end

---设置控件旋转至一个值
---*  widget : 控件对象
---*  value : 旋转角度
---*  time : 过程耗时
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_RotateTo(widget, value, time, timelineCB) end

---设置控件旋转动画
---*  widget : 控件对象
---*  value : 旋转角度
---*  time : 动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB function
---@return any
function GUI:Timeline_RotateBy(widget, value, time, timelineCB) end

---设置控件移动至一个值
---*  widget : 控件对象
---*  value : 移动坐标{x=int,y=int}
---*  time : 动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value table
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_MoveTo(widget, value, time, timelineCB) end

---设置控件移动动画
---*  widget : 控件对象
---*  value : 移动坐标{x=int,y=int}
---*  time : 动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value table
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_MoveBy(widget, value, time, timelineCB) end

---设置控件闪烁
---*  widget : 控件对象
---*  value : 闪烁次数
---*  time : 动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param value integer
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_Blink(widget, value, time, timelineCB) end

---设置控件抖动
---*  widget : 控件对象
---*  x : X轴抖动幅度
---*  y : Y轴抖动幅度
---*  time : 	动画时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param time integer
---@param x integer
---@param y integer
---@param timelineCB? function
---@return any
function GUI:Timeline_Shake(widget, time,x, y, timelineCB) end

---疯狂抖动动画
---*  widget : 控件对象
---*  time
---*  抖动幅度（0-360）
---@param widget userdata
---@param time integer
---@param angle integer
---@return any
function GUI:Timeline_Shake(widget, time,angle) end

---动画延迟播放
---*  widget : 控件对象
---*  time : 时间
---*  timelineCB : 完成时触发函数
---@param widget userdata
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_DelayTime(widget, time, timelineCB) end

---控件延时回调
---*  widget : 控件对象
---*  time : 	动画时间
---*  timeCB : 完成时触发函数
---@param widget userdata
---@param time integer
---@param timelineCB? function
---@return any
function GUI:Timeline_CallFunc(widget, value, time, timelineCB) end

---控件延时显示
---*  widget : 控件对象
---*  time : 	动画时间
---@param widget userdata
---@param time integer
---@return any
function GUI:Timeline_Show(widget, time) end

---控件延时隐藏
---*  widget : 控件对象
---*  time : 	动画时间
---@param widget userdata
---@param time integer
---@return any
function GUI:Timeline_Hide(widget, time) end

---创建一个角色静态模型
---*  _parent : 父控件对象
---*  _ID : 控件ID
---*  _PosX : 控件位置的横坐标
---*  _PosY : 控件位置的纵坐标
---*  sex : 性别 0 男性 1 女性
---*  feature : 模型属性
---*  scale : 缩放比例(0-100)
---@param _parent userdata|integer
---@param _ID string
---@param _PosX integer
---@param _PosY integer
---@param sex integer
---@param feature table
---@param scale? boolean
---@return any
function GUI:UIModel_Create( _parent, _ID, _PosX, _PosY, sex, feature, scale ) end

---创建容器控件
---*  Parent : 父控件对象
---*  ID : 控件ID
---*  PosX : 控件位置的横坐标
---*  PosY : 控件位置的纵坐标
---*  Width : 控件的宽
---*  Height : 控件的高
---*  isClip : 是否裁剪
---@param Parent userdata|integer
---@param ID string
---@param PosX integer
---@param PosY integer
---@param Width integer
---@param Height integer
---@param isClip? boolean
---@return any
function GUI:Layout_Create( Parent, ID, PosX, PosY, Width, Height, isClip) end

---设置容器背景颜色
---*  widget : 控件对象
---*  value : 	色值(“#000000”)
---@param widget userdata
---@param value string
---@return any
function GUI:Layout_setBackGroundColor(widget, value) end

---设置容器是否有背景颜色
---*  widget : 控件对象
---*  value : 类型(1单色，2渐变色)
---@param widget userdata
---@param value integer
---@return any
function GUI:Layout_setBackGroundColorType(widget, value) end

---设置层背景颜色不透明度
---*  widget : 控件对象
---*  value : 透明度(0-255)
---@param widget userdata
---@param value integer
---@return any
function GUI:Layout_setBackGroundColorOpacity(widget, value) end

---设置容器是否裁剪
---*  widget : 控件对象
---*  value : 是否裁剪 
---@param widget userdata
---@param value boolean
---@return any
function GUI:Layout_setClippingEnabled(widget, value) end

---设置层背景图片
---*  widget : 控件对象
---*  value : 图片路径 
---@param widget userdata
---@param value string
---@return any
function GUI:Layout_setBackGroundImage(widget, value) end

---设置层背景图片九宫格
---*  widget : 控件对象
---*  scale9l : 左边比例
---*  scale9r : 右边比例
---*  scale9t : 上边比例
---*  scale9b : 下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:Layout_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---创建列表容器
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  width : 	控件的宽
---*  height : 控件的高
---*  direction : 滑动方向1:垂直2:水平
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param direction integer
---@return any
function GUI:ListView_Create(parent, ID, x, y, width, height, direction) end

---设置列表容器对齐方式
---*  widget : 列表容器对象
---*  value : 对齐方式0:左对齐1:右对齐2:水平居中3:顶对齐4:底对齐5:垂直居中
---@param widget userdata
---@param value integer
---@return any
function GUI:ListView_setGravity(widget, value) end

---设置列表容器滑动方向
---*  widget : 列表容器对象
---*  value : 滑动方向:1:垂直2:水平
---@param widget userdata
---@param value integer
---@return any
function GUI:ListView_setDirection(widget, value) end

---设置列表容器控件间隔
---*  widget : 列表容器对象
---*  value : 间隔
---@param widget userdata
---@param value integer
---@return any
function GUI:ListView_setItemsMargin(widget, value) end

---获取列表容器控件间距
---*  widget : 列表容器对象
---@param widget userdata
---@return any
function GUI:ListView_getItemsMargin(widget) end

---设置列表容器是否回弹
---*  widget : 列表容器对象
---*  value : 是否有回弹
---@param widget userdata
---@param value boolean
---@return any
function GUI:ListView_setBounceEnabled(widget, value) end

---设置列表容器是否裁剪
---*  widget : 列表容器对象
---*  value : 是否裁剪
---@param widget userdata
---@param value boolean
---@return any
function GUI:ListView_setClippingEnabled(widget, value) end

---设置列表容器背景颜色
---*  widget : 列表容器对象
---*  value : 色值(“#000000”)
---@param widget userdata
---@param value string
---@return any
function GUI:ListView_setBackGroundColor(widget, value) end

---设置列表容器背景颜色类型
---*  widget : 列表容器对象
---*  value : 1:单色，2:渐变色
---@param widget userdata
---@param value integer
---@return any
function GUI:ListView_setBackGroundColorType(widget, value) end

---设置列表容器背景透明度
---*  widget : 列表容器对象
---*  value : 透明度(0-255)
---@param widget userdata
---@param value integer
---@return any
function GUI:ListView_setBackGroundOpacity(widget, value) end

---设置列表容器背景图片
---*  widget : 列表容器对象
---*  value : 图片路径
---@param widget userdata
---@param value string
---@return any
function GUI:ListView_setBackGroundImage(widget, value) end

---设置列表容器背景图片九宫格
---*  widget : 列表容器对象
---*  scale9l : 左边比例
---*  scale9r : 右边比例
---*  scale9t : 上边比例
---*  scale9b : 下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:ListView_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---列表容器加载子节点
---*  widget : 列表容器对象
---*  value : 子节点对象（末尾加载）
---@param widget userdata
---@param value? userdata
---@return any
function GUI:ListView_pushBackCustomItem(widget, value) end

---列表容器加载子节点
---*  widget : 列表容器对象
---*  value : 子节点对象
---*  index : 序列号位置
---@param widget userdata
---@param value userdata
---@param index integer
---@return any
function GUI:ListView_insertCustomItem(widget, value, index) end

---列表容器删除所有子节点
---*  widget : 列表容器对象
---@param widget userdata
---@return any
function GUI:ListView_removeAllItems(widget) end

---通过序列号删除列表容器子节点
---*  widget : 列表容器对象
---*  index : 序列号位置
---@param widget userdata
---@param index integer
---@return any
function GUI:ListView_removeItemByIndex(widget,index) end

---列表容器删除子节点
---*  widget : 列表容器对象
---*  value : 子节点对象
---@param widget userdata
---@param value userdata
---@return any
function GUI:ListView_removeChild(widget, value) end

---跳转到列表容器序列号节点位置
---*  widget : 列表容器对象
---*  index : 序列号位置
---@param widget userdata
---@param index integer
---@return any
function GUI:ListView_jumpToItem(widget, index) end

---某一时间内滑动到列表容器顶部
---*  widget : 列表容器对象
---*  index : 时间
---*  index : 滑动速度是否减弱
---@param widget userdata
---@param time integer
---@param boolvalue boolean
---@return any
function GUI:ListView_scrollToTop(widget, time, boolvalue) end

---某一时间内滑动到列表容器底部
---*  widget : 列表容器对象
---*  index : 时间
---*  index : 滑动速度是否减弱
---@param widget userdata
---@param time integer
---@param boolvalue boolean
---@return any
function GUI:ListView_scrollToBottom(widget, time, boolvalue) end


---获取列表容器最顶部可见范围子节点
---*  widget : 列表容器对象
---@param widget userdata
---@return any
function GUI:ListView_getTopmostItemInCurrentView(widget) end

---获取列表容器最底部部可见范围子节点
---*  widget : 列表容器对象
---@param widget userdata
---@return any
function GUI:ListView_getBottommostItemInCurrentView(widget) end

---通过子节点序列号获取子节点对象
---*  widget : 列表容器对象
---*  index : 子节点对象
---@param parent userdata
---@param index integer
---@return any
function GUI:ListView_getItemIndex(parent,index) end

---通过子节点序列号获取子节点对象
---*  widget : 列表容器对象
---*  index : 子节点序列号
---@param parent userdata
---@param index integer
---@return any
function GUI:ListView_getItemByIndex(parent,index) end

---获取列表容器所有子节点对象
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_getItems(parent) end

---获取列表容器所有子节点数量
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_getItemCount(parent) end

---获取列表容器所有子节点数量
---*  widget : 列表容器对象
---@param parent userdata
---@param eventCB function
---@return any
function GUI:ListView_addOnScrollEvent(parent ,eventCB) end

---列表容器刷新
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_doLayout(parent) end

---列表容器可见区域绘制
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_paintItems(parent) end

---列表容器可见区域自动绘制
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_autoPaintItems(parent) end

---获取列表容器滚动范围大小
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_getInnerContainerSize(parent) end

---获取列表容器滚动范围坐标
---*  widget : 列表容器对象
---@param parent userdata
---@return any
function GUI:ListView_getInnerContainerPosition(parent) end

---设置列表容器是否衰减滚动速度(垂直方向)
---*  widget : 列表容器对象
---@param parent userdata
---@param percent integer
---@param time integer
---@param bool boolean
---@return any
function GUI:ListView_scrollToPercentVertical(parent, percent, time, bool) end

---设置列表容器是否衰减滚动速度(水平方向)
---*  widget : 列表容器对象
---@param parent userdata
---@param percent integer
---@param time integer
---@param bool boolean
---@return any
function GUI:ListView_scrollToPercentHorizontal(parent, percent, time, bool) end

---创建滚动容器
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x : 控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  width : 控件的宽
---*  height : 控件的高
---*  direction : 滑动方向1:垂直2:水平
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@param direction integer
---@return any
function GUI:ScrollView_Create(parent, ID, x, y, width, height, direction) end

---设置滚动控件滚动区域大小
---*  widget : 控件对象
---*  width : 区域大小
---*  height : 区域大小
---@param widget userdata
---@param width integer|table
---@param height? integer
---@return any
function GUI:ScrollView_setInnerContainerSize(widget, width, height) end

---设置滚动控件滚动区域大小
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:ScrollView_getInnerContainerSize(widget) end

---设置滚动容器滚动方向
---*  widget : 控件对象
---*  value : 滑动方向:1:垂直2:水平
---@param widget userdata
---@param value integer
---@return any
function GUI:ScrollView_setDirection(widget, value) end

---设置滚动容器是否回弹
---*  widget : 控件对象
---*  value : 	是否回弹
---@param widget userdata
---@param value boolean
---@return any
function GUI:ScrollView_setBounceEnabled(widget, value) end

---设置滚动容器是否裁剪
---*  widget : 控件对象
---*  value : 	是否裁剪
---@param widget userdata
---@param value boolean
---@return any
function GUI:ScrollView_setClippingEnabled(widget, value) end

---设置滚动容器背景颜色
---*  widget : 控件对象
---*  value : 	色值(“#000000”)
---@param widget userdata
---@param value string
---@return any
function GUI:ScrollView_setBackGroundColor(widget, value) end

---设置滚动容器背景颜色类型
---*  widget : 控件对象
---*  value : 	1:单色，2:渐变色
---@param widget userdata
---@param value integer
---@return any
function GUI:ScrollView_setBackGroundColorType(widget, value) end

---设置滚动容器背景颜色类型
---*  widget : 控件对象
---*  value : 	1:单色，2:渐变色
---@param widget userdata
---@param value integer
---@return any
function GUI:ScrollView_setBackGroundColorType(widget, value) end

---设置滚动容器背景透明度
---*  widget : 控件对象
---*  value : 透明度(0-255)
---@param widget userdata
---@param value boolean
---@return any
function GUI:ScrollView_setBackGroundOpacity(widget, value) end

---设置滚动容器背景图片
---*  widget : 控件对象
---*  value : 图片路径
---@param widget userdata
---@param value boolean
---@return any
function GUI:ScrollView_setBackGroundImage(widget, value) end

---设置滚动器背景图片九宫格
---*  widget : 图片控件对象
---*  scale9l : 左边比例
---*  scale9r : 右边比例
---*  scale9t : 上边比例
---*  scale9b : 下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:ScrollView_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---设置滚动器背景图片九宫格
---*  widget : 图片控件对象
---*  scale9l : 左边比例
---*  scale9r : 右边比例
---*  scale9t : 上边比例
---*  scale9b : 下边比例
---@param widget userdata
---@param scale9l integer
---@param scale9r integer
---@param scale9t integer
---@param scale9b integer
---@return any
function GUI:ScrollView_setBackGroundImageScale9Slice(widget, scale9l, scale9r, scale9t, scale9b) end

---设置滚动容器滚动事件
---*  widget : 控件对象
---*  eventCB : 事件函数
---@param widget userdata
---@param eventCB function
---@return any
function GUI:ScrollView_addOnScrollEvent(widget, eventCB) end

---滚动容器加载子节点
---*  widget : 控件对象
---*  value : 子节点对象
---@param widget userdata
---@param value userdata
---@return any
function GUI:ScrollView_addChild(widget, value) end

---滚动容器删除所有子节点
---*  widget : 控件对象
---*  value : 子节点对象
---@param widget userdata
---@return any
function GUI:ScrollView_removeAllChildren(widget) end

---滚动容器刷新
---*  widget : 控件对象
---@param widget userdata
---@return any
function GUI:ScrollView_doLayout(widget) end

---创建翻页容器
---*  parent : 父控件对象
---*  ID :控件ID
---*  x :控件位置的横坐标
---*  y : 控件位置的纵坐标
---*  width :控件的宽
---*  height :控件的高
---*  direction : 0:水平滚动 1:垂直滚动
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param width integer
---@param height integer
---@return any
function GUI:PageView_Create(parent, ID, x, y, width, height, direction) end

---设置翻页容器是否有裁切
---*  widget : 控件对象
---*  value : 是否有裁切
---@param widget string
---@param value boolean
---@return any
function GUI:PageView_setClippingEnabled(widget, value) end

---设置翻页容器背景颜色
---*  widget : 控件对象
---*  value : 色值(“#000000”)
---@param widget string
---@param value boolean
---@return any
function GUI:PageView_setBackGroundColor(widget, value) end

---设置翻页容器背景颜色类型
---*  widget : 控件对象
---*  value : 1:单色 2:渐变色
---@param widget string
---@param value boolean
---@return any
function GUI:PageView_setBackGroundColorType(widget, value) end

---设置翻页容器背景透明度
---*  widget : 控件对象
---*  value : 透明度(0-255)
---@param widget string
---@param value boolean
---@return any
function GUI:PageView_setBackGroundColorOpacity(widget, value) end

---设置翻页容器翻页
---*  widget : 进度条对象
---*  index : 子页面序列号
---@param widget userdata
---@param index integer
---@return any
function GUI:PageView_scrollToItem(widget, index) end

---获取当前子页面序列号
---*  widget : 翻页容器对象
---@param widget userdata
---@return any
function GUI:PageView_getCurrentPageIndex(widget) end


---获取当前子页面序列号
---*  widget : 翻页容器对象
---@param widget userdata
---@return any
function GUI:PageView_getItems(widget) end

---获取翻页容器子页面数量
---*  widget : 翻页容器对象
---@param widget userdata
---@return any
function GUI:PageView_getItemCount(widget) end

---添加翻页容器页面
---*  parent : 翻页容器对象
---*  widget : 子页面对象
---@param parent userdata
---@param widget integer
---@return any
function GUI:PageView_addPage(parent, widget) end


---设置翻页容器监听事件
---*  widget : 进度条对象
---*  eventCB : 回调函数 
---@param widget userdata
---@param eventCB function
---@return any
function GUI:PageView_addOnEvent(widget, eventCB) end

---创建快速刷新控件
---*  parent : 父控件对象
---*  ID :控件ID
---*  x :控件位置的横坐标
---*  y :控件位置的纵坐标
---*  w :宽
---*  h :高
---*  createCB : 函数
---*  activeCB : 函数
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param createCB? function
---@param activeCB? function
---@param config? table
---@return any
function GUI:QuickCell_Create(parent, ID, x, y, w, h, createCB,activeCB,config) end

---播放动作
---*  widget : 控件对象
---*  value : 动作内容 
---@param widget userdata
---@param value userdata
---@return any
function GUI:runAction(widget, value) end

---通过标记获取动作内容
---*  widget : 翻页容器对象
---*  tag : 动作标记
---@param widget userdata
---@param tag integer
---@return any
function GUI:getActionByTag(widget, tag) end

---停止所有动作
---*  widget : 翻页容器对象
---@param widget userdata
---@return any
function GUI:stopAllActions(widget) end

---停止所有动作
---*  widget : 翻页容器对象
---@param widget userdata
---@param tag integer
---@return any
function GUI:stopActionByTag(widget, tag) end

---移动到B点:以世界坐标系为原点(0,0)
---*  time : 时间
---*  x : 位置 横坐标
---*  y : 位置 纵坐标
---@param time integer
---@param x integer
---@param y integer
---@return any
function GUI:ActionMoveTo(time, x, y) end

---A点移动到B点 移动相对位置:以A点为原点(0,0)
---*  time : 时间
---*  x : 位置 横坐标
---*  y : 位置 纵坐标
---@param time integer
---@param x integer
---@param y integer
---@return any
function GUI:ActionMoveBy(time, x, y) end

---放大或缩小到某一比例
---*  time : 时间
---*  ratio : 缩放比例（百分比）
---@param time integer
---@param ratio integer
---@return any
function GUI:ActionScaleTo(time, ratio) end

---放大或缩小到原来的某一比例
---*  time : 时间
---*  ratio : 缩放比例（百分比）
---@param time integer
---@param ratio integer
---@return any
function GUI:ActionScaleBy(time, ratio) end


---旋转到多少角度
---*  time : 时间
---*  angle : 旋转角度
---@param time integer
---@param angle integer
---@return any
function GUI:ActionRotateTo(time, angle) end

---旋转到原来的多少角度
---*  time : 时间
---*  angle : 旋转角度
---@param time integer
---@param angle integer
---@return any
function GUI:ActionRotateBy(time, angle) end

---淡入
---*  time : 时间
---@param time integer
---@return any
function GUI:ActionFadeIn(time) end

---淡出
---*  time : 时间
---@param time integer
---@return any
function GUI:ActionFadeOut(time) end

---闪烁
---*  time : 时间
---*  num : 闪烁次数
---@param time integer
---@param num integer
---@return any
function GUI:ActionBlink(time, num) end

---动画回调函数
---*  timeCB : 回调函数
---@param callback function
---@return any
function GUI:CallFunc( callback) end

---延迟
---*  timeCB : 延迟时间
---@param time 	integer
---@return any
function GUI:DelayTime( time) end

---创建动画控件
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :位置 横坐标
---*  y : 位置 纵坐标
---*  prefix : 前缀
---*  suffix : 后缀
---*  beginframe : 起始帧, 默认1
---*  finishframe : 结束帧
---*  ext : 附加参数, {speed = 播放速度(毫秒), count = 图片数量, loop = 播放次数(-1: 循环), finishhide = 播放结束是否隐藏(1: 隐藏)}
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param prefix string
---@param suffix string
---@param beginframe integer
---@param finishframe integer
---@param ext table
---@return any
function GUI:Frames_Create(parent, ID, x, y, prefix, suffix, beginframe, finishframe, ext) end

---创建粒子特效
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :位置 横坐标
---*  y : 位置 纵坐标
---*  res : 粒子特效资源路径 plist文件
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param res string
---@return any
function GUI:ParticleEffect_Create(parent, ID, x, y, res) end

---设置持续时间
---*  widget : 粒子特效
---*  time : 持续时间, 单位: 秒 -1 表示永久
---@param widget integer
---@param time integer
---@return any
function GUI:ActionRotateTo(widget, time) end

---设置总粒子数量
---*  widget : 粒子特效
---*  time : 数量
---@param widget integer
---@param value integer
---@return any
function GUI:ParticleEffect_setTotalParticles(widget, value) end

---创建Spine动画
---*  parent : 父控件对象
---*  ID : 控件ID
---*  x :位置 横坐标
---*  y : 位置 纵坐标
---*  jsonPath : json文件路径
---*  atlasPath : atlas文件路径
---*  trackIndex : 索引值
---*  name : 动画名
---*  loop : 动画是否循环
---@param parent userdata|integer
---@param ID string
---@param x integer
---@param y integer
---@param jsonPath string
---@param atlasPath string
---@param trackIndex integer
---@param name string
---@param loop boolean
---@return any
function GUI:SpineAnim_Create(parent, ID, x, y, jsonPath, atlasPath, trackIndex, name, loop) end

---创建拖拽容器
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  width: 宽
---*  height: 高
---*  from: 控件来自(界面位置)  官方默认的可参照元变量 ITEMFROMUI_ENUM
---*  ext: 额外参数 beginMoveCB : 开始移动回调, endMoveCB : 结束移动回调, cancelMoveCB : 取消移动回调, equipPos: 放置装备的装备位置
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param width number
---@param height number
---@param from number
---@param ext table
---@return any
function GUI:MoveWidget_Create(parent, ID, x, y, width, height, from, ext) end

---新增拖拽类型和拖拽事件
---*  fromType: 控件来自位置类型名
---*  toType: 控件到达位置类型名
---*  fromToEvent: function -- 从fromType类型控件 拖拽到 toType类型控件 触发的函数
---*  toFromEvent: function -- 从toType类型控件 拖拽到 fromType类型控件 触发的函数
---@param fromType string
---@param toType string
---@param fromToEvent function
---@param toFromEvent function
---@return any
function GUI:AddMoveWidgetTypeEvent(fromType, toType, fromToEvent, toFromEvent) end

---创建刮图
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  showImg: 展示图片资源
---*  maskImg: 遮罩图片资源
---*  clearHei: 刮除高度, 默认16
---*  moveTime: 刮除时间, 单位: 秒
---*  beginTime: 开始点击到结束触发间隔, 单位: 秒
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param showImg string
---@param maskImg string
---@param clearHei number
---@param moveTime number
---@param beginTime number
---@param callback function
---@return any
function GUI:ScrapePic_Create(parent, ID, x, y, showImg, maskImg, clearHei, moveTime, beginTime, callback) end

---创建列表容器[优化加载]
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  width: 容器宽度
---*  height: 容器高度
---*  direction: 1：垂直; 2：水平
---*  cellWid: 单个cell 宽
---*  cellHei: 单个cell 高
---*  num: 需创建cell个数
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param width number
---@param height number
---@param direction number
---@param cellWid number
---@param cellHei number
---@param num number
---@return any
function GUI:TableView_Create(parent, ID, x, y, width, height, direction, cellWid, cellHei, num) end

---设置子cell创建方法
---*  widget: tableView对象
---*  func: 创建函数 传入参数(cell父节点, cell下标)
---@param widget userdata
---@param func function
---@return any
function GUI:TableView_setCellCreateEvent(widget, func) end

---设置滚动方向
---*  widget: tableView对象
---*  value: 滚动方向 1：垂直; 2：水平
---@param widget userdata
---@param value number
---@return any
function GUI:TableView_setDirection(widget, value) end

---设置背景颜色
---*  widget: tableView对象
---*  value: 十六进制颜色值 例: "#FFFFFF"
---@param widget userdata
---@param value string
---@return any
function GUI:TableView_setBackGroundColor(widget, value) end

---设置内部区域偏移位置
---*  widget: tableView对象
---*  x: 偏移坐标X
---*  y: 偏移坐标Y
---@param widget userdata
---@param x number
---@param y number
---@return any
function GUI:TableView_setContentOffset(widget, x, y) end

---获取内部区域偏移位置
---*  widget: tableView对象
---@param widget userdata
---@return any
function GUI:TableView_getContentOffset(widget) end

---添加点击cell事件
---*  widget: tableView对象
---*  func: 点击cell触发回调
---@param widget userdata
---@param func function
---@return any
function GUI:TableView_addOnTouchedCellEvent(widget, func) end

---滚动到某cell位置
---*  widget: tableView对象
---*  index: 对应cell下标
---@param widget userdata
---@param index number
---@return any
function GUI:TableView_scrollToCell(widget, index) end

---添加容器滚动回调
---*  widget: tableView对象
---*  func: 容器滚动回调函数 param1: TableView控件
---@param widget userdata
---@param func function
---@return any
function GUI:TableView_addOnScrollEvent(widget, func) end

---设置容器cell个数
---*  widget: tableView对象
---*  func: cell总个数(int)/返回cell总个数的函数(func)
---@param widget userdata
---@param func function|integer
---@return any
function GUI:TableView_setTableViewCellsNumHandler(widget, func) end

---加载容器所有列表数据
---*  widget: tableView对象
---@param widget userdata
---@return any
function GUI:TableView_reloadData(widget) end

---添加容器鼠标滚动事件
---*  widget: tableView对象
---*  func: 鼠标滚动回调函数传参{widget = widget, x = 滚动坐标X, y = 滚动坐标Y} [不填采用官方默认添加滚动]
---@param widget userdata
---@param func? function
---@return any
function GUI:TableView_addMouseScrollEvent(widget, func) end

---获取容器cell的下标/序列号
---*  widget: tableViewCell对象
---@param widget userdata
---@return any
function GUI:TableViewCell_getIdx(widget) end

---创建旋转容器
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  width: 宽度
---*  height: 高度
---*  scrollGap: 滑动间隙, 默认100
---*  param: 子节点参数, 参考如下
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param width number
---@param height number
---@param scrollGap number
---@param param table
---@return any
function GUI:RotateView_Create(parent, ID, x, y, width, height, scrollGap, param) end

---添加子节点到旋转容器对应下标item
---*  widget: 旋转容器对象
---*  value: 控件对象
---*  index: 对应下标
---@param widget userdata
---@param value userdata
---@param index number
---@return any
function GUI:RotateView_addChild(widget, value, index) end

---获取对应下标item添加的子节点
---*  widget: 旋转容器对象
---*  index: 对应下标
---@param widget userdata
---@param index number
---@return any
function GUI:RotateView_getChildByIndex(widget, index) end

---获取对应下标item
---*  widget: 旋转容器对象
---*  index: 对应下标
---@param widget userdata
---@param index number
---@return any
function GUI:RotateView_getItemByIndex(widget, index) end

---创建装备框
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  pos: 装备装戴位置
---*  isHero: 是否英雄装备
---*  data: 额外参数
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param pos number
---@param isHero boolean
---@param data table
---@return any
function GUI:EquipShow_Create(parent, ID, x, y, pos, isHero, data) end

---设置装备框显示自动刷新
---*  widget: 装备框对象
---@param widget userdata
---@return any
function GUI:EquipShow_setAutoUpdate(widget) end

---判断对象是否为空
---*  widget: 对象
---@param widget userdata
---@return any
function GUI:Win_IsNull(widget) end

---判断对象是否不为空
---*  widget: 对象
---@param widget userdata
---@return any
function GUI:Win_IsNotNull(widget) end

---获取当前打开界面挂接点
---@return any
function GUI:Attach_Parent() end

---获取主界面左上挂接点
---@return any
function GUI:Attach_LeftTop() end

---获取主界面右上挂接点
---@return any
function GUI:Attach_RightTop() end

---获取主界面左下挂接点
---@return any
function GUI:Attach_LeftBottom() end

---获取主界面右下挂接点
---@return any
function GUI:Attach_RightBottom() end

---获取最上层UI挂接点
---@return any
function GUI:Attach_UITop() end

---获取上层场景挂接点
---@return any
function GUI:Attach_SceneF() end

---获取下层场景挂接点
---@return any
function GUI:Attach_SceneB() end

---获取主界面最底层左上挂接点
---@return any
function GUI:Attach_LeftTop_B() end

---获取主界面最底层右上挂接点
---@return any
function GUI:Attach_RightTop_B() end

---获取主界面最底层左下挂接点
---@return any
function GUI:Attach_LeftBottom_B() end

---获取主界面最底层右下挂接点
---@return any
function GUI:Attach_RightBottom_B() end

---获取主界面最顶层左上挂接点
---@return any
function GUI:Attach_LeftTop_T() end

---获取主界面最顶层右上挂接点
---@return any
function GUI:Attach_RightTop_T() end

---获取主界面最顶层左下挂接点
---@return any
function GUI:Attach_LeftBottom_T() end

---获取主界面最顶层右下挂接点
---@return any
function GUI:Attach_RightBottom_T() end

---获取自带父节点
---*  ID: 挂接点ID: 101-111
---@param ID number
---@return any
function GUI:Win_FindParent(ID) end

---显示文本Tips
---*  tips: 显示文本
---*  worldPos: 世界坐标
---*  anchorPoint: 锚点
---@param tips string
---@param worldPos table
---@param anchorPoint table
---@return any
function GUI:ShowWorldTips(tips, worldPos, anchorPoint) end

---关闭文本Tips
---@return any
function GUI:HideWorldTips() end

---自适应布局
---*  pNode: 控件对象
---*  param: 布局参数
---@param pNode userdata
---@param param table
---@return any
function GUI:UserUILayout(pNode, param) end

---获取按钮文字
---*  widget: 按钮对象
---@param widget userdata
---@return any
function GUI:Button_getTitleText(widget) end

---创建自定义组合富文本
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  width: 富文本控件最大宽度
---*  vspace: 富文本行间距
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param width number
---@param vspace? number
---@return any
function GUI:RichTextCombine_Create(parent, ID, x, y, width, vspace) end

---添加自定义富文本cell
---*  widget: 控件对象
---*  elements: [RichTextCombineCell] 单个元素控件对象 或 控件对象table
---@param widget userdata
---@param elements userdata|table
---@return any
function GUI:RichTextCombine_pushBackElements(widget, elements) end

---添加cell完毕格式化富文本
---*  widget: 控件对象
---@param widget userdata
---@return any
function GUI:RichTextCombine_format(widget) end

---创建自定义组合富文本cell
---*  parent: 父节点对象 [RichTextCombine]
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  type: cell类型 文本类型：1或TEXT 节点类型：2或NODE 换行类型：3 或 NEWLINE[3.40.4新增]
---*  param: 额外参数, 参考如下:
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param type any
---@param param table
---@return any
function GUI:RichTextCombineCell_Create(parent, ID, x, y, type, param) end

---设置富文本背景颜色
---*  widget: 控件对象
---*  color: 颜色值, 例: "#000000"
---@param widget userdata
---@param color string
---@return any
function GUI:RichText_setBackgroundColor(widget, color) end

---添加富文本url点击触发事件
---*  widget: 控件对象
---*  handle: 触发函数 (param1: 富文本控件, param2: string 文本传递内容)
---@param widget userdata
---@param handle function
---@return any
function GUI:RichText_setOpenUrlEvent(widget, handle) end

---创建物品放入框
---*  parent: 父节点对象
---*  ID: 唯一ID
---*  x: 位置 横坐标
---*  y: 位置 纵坐标
---*  img: 放置框底图资源路径
---*  boxindex: 放置框 唯一ID
---*  stdmode: 允许传入的StdMode ("*": 所有 、单个用number 、多个用table)
---@param parent userdata|integer
---@param ID string
---@param x number
---@param y number
---@param img string
---@param boxindex number
---@param stdmode any
---@return any
function GUI:ItemBox_Create(parent, ID, x, y, img, boxindex, stdmode) end

---获取对应ID放置框的物品数据
---*  widget: 物品放入框控件对象
---*  boxindex: 放置框 唯一ID
---@param widget userdata
---@param boxindex number
---@return any
function GUI:ItemBox_GetItemData(widget, boxindex) end

---清空对应ID放置框的传入数据
---*  widget: 物品放入框控件对象
---*  boxindex: 放置框 唯一ID
---@param widget userdata
---@param boxindex number
---@return any
function GUI:ItemBox_RemoveBoxData(widget, boxindex) end

---更新对应ID放置框的物品数据
---*  widget: 物品放入框控件对象
---*  boxindex: 放置框 唯一ID
---@param widget userdata
---@param boxindex number
---@return any
function GUI:ItemBox_UpdateBoxData(widget, boxindex) end

---设置滚动条最大进度值
---*  widget: 滚动条对象
---*  value: 滚动条最大进度值
---@param widget userdata
---@param value number
---@return any
function GUI:Slider_setMaxPercent(widget, value) end


return GUI