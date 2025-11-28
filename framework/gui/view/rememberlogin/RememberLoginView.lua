RememberLoginView = class("RememberLoginView", BaseView)
autoImport("RememberLoginUtil")
RememberLoginView.ViewType = UIViewType.NormalLayer

function RememberLoginView:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function RememberLoginView:OnEnter()
  self.super.OnEnter(self)
  self:RegisterEvents()
  self:InitDatas()
  self:AddCtrlEvt()
end

function RememberLoginView:OnExit()
  self:RemoveEvents()
  self:RemoveConfig()
  self.super.OnExit(self)
end

function RememberLoginView:OnDestroy()
  self:RemoveConfig()
  self:RemoveCtrls()
  self:RemoveAllCtrlItems()
  self:RemoveAllRLSpecailInfoCells()
  self.super.OnDestroy(self)
end

function RememberLoginView:FindObjs()
  self:RemoveCtrls()
  self:RemoveAllCtrlItems()
  self.ctrlItems = ReusableTable.CreateArray()
  local cellParents = self:FindGO("CellParents")
  local ctrls = ReusableTable.CreateArray()
  local ctrl, obj, ctrlItem
  local count = RememberLoginUtil.SignInDays
  for i = 1, count do
    obj = self:FindGO("CellParent_" .. i, cellParents)
    ctrl = UIGridListCtrl.new(self:FindComponent("Grid", UIGrid, obj), BaseItemCell, "RememberLoginCell")
    ctrls[#ctrls + 1] = ctrl
    ctrlItem = self:GetCtrlItem(i, obj)
    ctrlItem:Init()
    self.ctrlItems[i] = ctrlItem
  end
  self.listCtrls_Right = ctrls
  self.label_OpenTime = self:FindComponent("Label_OpenTime", UILabel)
  self.panel_SpecailInfo = self:FindGO("Panel_SpecailInfo")
  self.label_SpecailInfo = self:FindComponent("Label_SpecailInfo", UILabel)
  self.label_SpecailDes = self:FindComponent("Label_SpecailDes", UILabel)
  self.label_Time_Ontime = self:FindComponent("Label_Time_Ontime", UILabel)
  self.mRLSpecailInfoCellParent = self:FindComponent("RLSpecailInfoCellParent", UIGrid)
  self.cellParent_SpecialInfo = self:FindGO("CellParent_SpecialInfo")
  self.button_SpecialShare = self:FindGO("Button_SpecialShare")
  self.icon_Time_Ontime = self:FindGO("Icon_Time_Ontime")
  self.icon_Time_Ontime2 = self:FindGO("Icon_Time_Ontime2")
end

function RememberLoginView:RegisterEvents()
  EventManager.Me():AddEventListener(ServiceEvent.ActivityCmdFestivalSigninInfo, self.RefreshDatas, self)
end

function RememberLoginView:RemoveEvents()
  EventManager.Me():RemoveEventListener(ServiceEvent.ActivityCmdFestivalSigninInfo, self.RefreshDatas, self)
end

function RememberLoginView:AddButtonEvt()
  self:AddClickEvent(self:FindGO("Button_Ok_SpecialInfo"), function()
    self:ShowSpecialInfo(false)
  end)
  self:AddClickEvent(self.button_SpecialShare, function()
    self:Button_SpecialShare()
  end)
end

function RememberLoginView:AddCtrlEvt()
  for i = 1, #self.listCtrls_Right do
    self.listCtrls_Right[i]:AddEventListener(MouseEvent.MouseClick, self.ClickCtrlCell, self)
  end
end

function RememberLoginView:RefreshDatas()
  self:InitDatas()
end

function RememberLoginView:InitDatas()
  self:InitConfig()
  self:RemoveAllRLSpecailInfoCells()
  local startTime = RememberLoginProxy.Instance.startTime
  local endTime = RememberLoginProxy.Instance.endTime
  self.label_OpenTime.text = RememberLoginUtil:GetTimeDate(startTime, endTime, ZhString.RememberLoginView_OpenTime)
  self.label_SpecailInfo.text = ZhString.RememberLoginView_SpecailTitle
  self.label_SpecailDes.text = string.format(ZhString.RememberLoginView_SpecailDes, RememberLoginUtil:GetCurServerDate("Point"), RememberLoginUtil.SignInDays)
  local cells
  for i = 1, #self.listCtrls_Right do
    self.listCtrls_Right[i]:ResetDatas(self.itemDatas[i])
    cells = self.listCtrls_Right[i]:GetCells()
    if not cells or #cells == 0 then
      LogUtility.Error(string.format("[%s] InitDatas() Error : cells == nil or cells.count == 0! i = %d", self.__cname, i))
    else
      for k = 1, #cells do
        cells[k].parentIndex = i
      end
    end
  end
  self:RefreshReward_Ontime()
  local obj = self:LoadPreferb("cell/RememberLoginCell", self:FindGO("CellParent_Special"))
  self.reward_Special = BaseItemCell.new(obj)
  self.reward_Special:SetData(self.itemData_Special)
  self.reward_Special:AddEventListener(MouseEvent.MouseClick, self.ClickCtrlCell, self)
  obj = self:LoadPreferb("cell/RememberLoginCell", self.cellParent_SpecialInfo.gameObject)
  self.reward_SpecialInfo = BaseItemCell.new(obj)
  self.reward_SpecialInfo:SetData(self.itemData_Special)
  self.reward_SpecialInfo:AddEventListener(MouseEvent.MouseClick, self.ClickCtrlCell, self)
  self.mRLSpecailInfoCells = ReusableTable.CreateArray()
  local day = RememberLoginUtil.SignInDays
  local cell
  for i = 1, day do
    cell = self:GetRLSpecailInfoCell(i)
    cell:Init()
    self.mRLSpecailInfoCells[i] = cell
  end
  self:RefreshAwardedDatas()
  self.button_SpecialShare:SetActive(RememberLoginProxy.Instance.specialawarded)
  self:RefreshOntimeRewardTime()
end

function RememberLoginView:InitConfig()
  self:RemoveConfig()
  local configData = GameConfig.FestivalSignin[RememberLoginUtil.ConfigID]
  if not configData then
    LogUtility.Error(string.format("[%s] InitConfig() Error : GameConfig.FestivalSignin[%d] == nil!", self.__cname, RememberLoginUtil.ConfigID))
    return nil
  end
  self.m_helpId = configData.HelpID
  local itemDatas = ReusableTable.CreateArray()
  local configs = RememberLoginProxy.Instance:GetSignInRewardDatas()
  local config, list, data, id, num
  for i = 1, #configs do
    list = itemDatas[i]
    if not list then
      itemDatas[i] = ReusableTable.CreateArray()
      list = itemDatas[i]
    end
    config = configs[i]
    for index = 1, #config do
      id = config[index][1]
      num = config[index][2]
      data = ItemData.new("RememberLoginReward", id)
      data:SetItemNum(num)
      data.index = index
      list[#list + 1] = data
    end
    itemDatas[i] = list
  end
  self.itemDatas = itemDatas
  self:RefreshRewardData_Ontime()
  self:RefreshRewardData_Special()
end

function RememberLoginView:RemoveConfig()
  if self.itemDatas then
    for i = 1, #self.itemDatas do
      ReusableTable.DestroyAndClearArray(self.itemDatas[i])
    end
    ReusableTable.DestroyAndClearArray(self.itemDatas)
    self.itemDatas = nil
  end
end

function RememberLoginView:RemoveCtrls()
  if self.listCtrls_Right then
    for i = 1, #self.listCtrls_Right do
      self.listCtrls_Right[i]:Destroy()
    end
    ReusableTable.DestroyAndClearArray(self.listCtrls_Right)
    self.listCtrls_Right = nil
  end
end

function RememberLoginView:RefreshRewardData_Ontime(ontimeDayNum)
  local config_Ontime = RememberLoginProxy.Instance:GetOntimeRewardData(ontimeDayNum)
  local id = config_Ontime[1]
  local num = config_Ontime[2]
  local data = ItemData.new("RememberLoginReward", id)
  data:SetItemNum(num)
  self.itemData_Ontime = data
end

function RememberLoginView:RefreshRewardData_Special()
  local config_Special = RememberLoginProxy.Instance:GetSpecialRewardData()
  local id = config_Special[1]
  local num = config_Special[2]
  local data = ItemData.new("RememberLoginReward", id)
  data:SetItemNum(num)
  self.itemData_Special = data
end

function RememberLoginView:RefreshReward_Ontime()
  if not self.reward_Ontime then
    local obj = self:LoadPreferb("cell/RememberLoginCell", self:FindGO("CellParent_Left"))
    self.reward_Ontime = BaseItemCell.new(obj)
    self.reward_Ontime:AddEventListener(MouseEvent.MouseClick, self.ClickCtrlCell, self)
  end
  self.reward_Ontime:SetData(self.itemData_Ontime)
end

function RememberLoginView:RefreshAwardedDatas()
  local awardedDays = RememberLoginProxy.Instance.awardedDays
  local awardedNum = #awardedDays
  local index
  for i = 1, awardedNum do
    index = awardedDays[i]
    self.mRLSpecailInfoCells[index]:Select(true)
    self.ctrlItems[index]:SetState("close")
  end
  local loginDayNum = RememberLoginProxy.Instance.loginDayNum
  loginDayNum = math.min(loginDayNum, RememberLoginUtil.SignInDays)
  local canGetDays = math.max(loginDayNum - awardedNum, 0)
  local num = 0
  local count = #self.ctrlItems
  for i = 1, count do
    if self.ctrlItems[i].state == "none" then
      self.ctrlItems[i]:SetState("open")
      num = num + 1
      if canGetDays <= num then
        break
      end
    end
  end
end

function RememberLoginView:RefreshOntimeRewardTime()
  self.isRefreshOntimeRewardTime = false
  local state = RememberLoginProxy.Instance:CheckoutOntimeRewardState()
  if state == 1 then
    self.isRefreshOntimeRewardTime = true
    self.label_Time_Ontime.gameObject:SetActive(true)
    self.icon_Time_Ontime:SetActive(true)
    self.icon_Time_Ontime2:SetActive(false)
  elseif state == 2 then
    self.label_Time_Ontime.gameObject:SetActive(true)
    self.icon_Time_Ontime:SetActive(false)
    self.icon_Time_Ontime2:SetActive(true)
    if RememberLoginProxy.Instance.onlineawarded then
      self.label_Time_Ontime.text = ZhString.RememberLoginView_OntimeNo
    else
      self.label_Time_Ontime.text = ZhString.RememberLoginView_OntimeOn
    end
  elseif state == 3 then
    self.label_Time_Ontime.gameObject:SetActive(true)
    self.icon_Time_Ontime:SetActive(true)
    self.icon_Time_Ontime2:SetActive(false)
    self.label_Time_Ontime.text = ZhString.RememberLoginView_OntimeEnd
  else
    LogUtility.Error(string.format("[%s] RefreshOntimeRewardTime() Error : state = %s is not case!", self.__cname, state))
  end
end

function RememberLoginView:UpdateBySecond()
  if self.isRefreshOntimeRewardTime and self.label_Time_Ontime then
    self.tempTime = RememberLoginProxy.Instance.startTime_Ontime - RememberLoginUtil:GetServerTime()
    if self.tempTime >= 0 then
      self.label_Time_Ontime.text = RememberLoginUtil:GetTimeByHHMMSS(self.tempTime, 2)
    else
      self:RefreshOntimeRewardTime()
    end
  end
end

function RememberLoginView:ClickCtrlCell(cellCtl)
  if cellCtl == self.reward_Special then
    if RememberLoginProxy.Instance.specialawarded or RememberLoginProxy.Instance.specialawardactive then
    else
      self:ShowSpecialInfo(true)
    end
  elseif cellCtl == self.reward_SpecialInfo then
    self:_ClickCtrlCell(cellCtl)
  elseif cellCtl == self.reward_Ontime then
    if RememberLoginProxy.Instance.onlineawarded then
      self:_ClickCtrlCell(cellCtl)
    elseif RememberLoginProxy.Instance:CheckoutOntimeRewardIsOpen() then
    else
      self:_ClickCtrlCell(cellCtl)
    end
  else
    self:_ClickCtrlCell(cellCtl)
  end
end

function RememberLoginView:_ClickCtrlCell(cellCtl)
  if cellCtl and cellCtl ~= self.chooseItem then
    local data = cellCtl.data
    local stick = cellCtl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellCtl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-280, 0})
    end
    self.chooseItem = cellCtl
  else
    self:CancelChoose()
  end
end

function RememberLoginView:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end

function RememberLoginView:SelectCtrlItem(id)
  local item = self.ctrlItems[id]
  if not item then
    LogUtility.Error(string.format("[%s] InitCSelectCtrlItemonfig() Error : id = %s is not exist in self.ctrlItems!", self.__cname, tostring(id)))
    return nil
  end
  LogUtility.Info("[RememberLoginView] SelectCtrlItem() id = " .. id)
end

function RememberLoginView:ShowSpecialInfo(isShow)
  self.panel_SpecailInfo:SetActive(isShow)
end

function RememberLoginView:Button_SpecialShare()
  LogUtility.Info("[RememberLoginView] Button_SpecialShare()")
end

function RememberLoginView:GetCtrlItem(id, obj)
  local ctrlItem = ReusableTable.CreateTable()
  ctrlItem.id = id
  ctrlItem.obj = obj
  ctrlItem.bg_Close = self:FindGO("BG_Close", obj)
  ctrlItem.button_Click = self:FindGO("Button_Click", obj)
  
  function ctrlItem.Init(ctrlItem)
    ctrlItem:SetState()
  end
  
  function ctrlItem.SetState(ctrlItem, state)
    ctrlItem.state = state or "none"
    if not state or state == "none" then
      ctrlItem.bg_Close:SetActive(false)
      ctrlItem.button_Click:SetActive(false)
    elseif state == "open" then
      ctrlItem.bg_Close:SetActive(false)
      ctrlItem.button_Click:SetActive(true)
    elseif state == "close" then
      ctrlItem.bg_Close:SetActive(true)
      ctrlItem.button_Click:SetActive(false)
    else
      LogUtility.Error(string.format("[%s] GetCtrlItem().SetState() Error : state = %s is not case!", self.__cname, state))
    end
  end
  
  self:AddClickEvent(ctrlItem.button_Click, function()
    self:SelectCtrlItem(id)
  end)
  return ctrlItem
end

function RememberLoginView:RemoveAllCtrlItems()
  if self.ctrlItems then
    for i = 1, #self.ctrlItems do
      ReusableTable.DestroyAndClearTable(self.ctrlItems[i])
    end
    ReusableTable.DestroyAndClearArray(self.ctrlItems)
    self.ctrlItems = nil
  end
end

function RememberLoginView:GetRLSpecailInfoCell(id)
  local obj = self:LoadPreferb("cell/RLSpecailInfoCell", self.mRLSpecailInfoCellParent.gameObject)
  local item = ReusableTable.CreateTable()
  item.id = id
  item.obj = obj
  item.select = self:FindGO("Select", obj)
  item.line = self:FindGO("Line", obj)
  
  function item.Init(item)
    item:Select(false)
    item.line:SetActive(item.id ~= 1 or false)
  end
  
  function item.Select(item, isSelect)
    item.select:SetActive(isSelect)
  end
  
  return item
end

function RememberLoginView:RemoveAllRLSpecailInfoCells()
  if self.mRLSpecailInfoCells then
    for i = 1, #self.mRLSpecailInfoCells do
      ReusableTable.DestroyAndClearTable(self.mRLSpecailInfoCells[i])
    end
    ReusableTable.DestroyAndClearArray(self.mRLSpecailInfoCells)
    self.mRLSpecailInfoCells = nil
  end
end
