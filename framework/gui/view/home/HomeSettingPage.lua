autoImport("HomeCustomizeSettingCell")
autoImport("UIGridListCtrl")
HomeSettingPage = class("HomeSettingPage", SubView)

function HomeSettingPage:Init()
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeSettingPage:InitUI()
  self.gameObject = self:FindGO("HomeSettingPage")
  local l_objScrollSettings = self:FindGO("ScrollView")
  local l_objSettingContainer = self:FindGO("containerSetting", l_objScrollSettings)
  self.scrollSettings = l_objScrollSettings:GetComponent(UIScrollView)
  self.uiTableSettings = l_objSettingContainer:GetComponent(UITable)
  self.togHomePublic = self:FindComponent("SetPublic", UIToggle, l_objSettingContainer)
  self.togHomeFriendsOnly = self:FindComponent("SetFriendsOnly", UIToggle, l_objSettingContainer)
  self.togFurniturePublic = self:FindComponent("SetFurniturePublic", UIToggle, l_objSettingContainer)
  self.togFurniturePrivate = self:FindComponent("SetFurniturePrivate", UIToggle, l_objSettingContainer)
  local l_objFurnitureCostomize = self:FindGO("SetFurnitureCustomize", l_objSettingContainer)
  self.togFurnitureCostomize = l_objFurnitureCostomize:GetComponent(UIToggle)
  self.objBtnFoldFurnitureCostomize = self:FindGO("BtnFoldCostumize", l_objFurnitureCostomize)
  self.tsfBtnFoldFurnitureCostomize = self.objBtnFoldFurnitureCostomize.transform
  self.btnFoldFurnitureCostomize = self.objBtnFoldFurnitureCostomize:GetComponent(UIButton)
  self.objSetFurnitureUseCostomize = self:FindGO("FurnitureUseCostomize")
  self.listFurnitureUseCostomize = UIGridListCtrl.new(self:FindComponent("gridFurnitureUse", UIGrid, self.objSetFurnitureUseCostomize), HomeCustomizeSettingCell, "SimpleToggleCell")
  self.widgetFurnitureCostomizeSize = self:FindComponent("SizeWidget", UIWidget, self.objSetFurnitureUseCostomize)
  self.togShowName = self:FindComponent("SetShowName", UIToggle)
  self.togFunctionAllOpen = self:FindComponent("SetFunctionAllOpen", UIToggle, l_objSettingContainer)
  self.togFunctionAllClose = self:FindComponent("SetFunctionAllClose", UIToggle, l_objSettingContainer)
  local l_objFunctionCostomize = self:FindGO("SetFunctionCustomize", l_objSettingContainer)
  self.togFunctionCostomize = l_objFunctionCostomize:GetComponent(UIToggle)
  self.objBtnFoldFunctionCostomize = self:FindGO("BtnFoldCostumize", l_objFunctionCostomize)
  self.tsfBtnFoldFunctionCostomize = self.objBtnFoldFunctionCostomize.transform
  self.btnFoldFunctionCostomize = self.objBtnFoldFunctionCostomize:GetComponent(UIButton)
  self.objSetFunctionUseCostomize = self:FindGO("FunctionUseCostomize")
  self.listFunctionUseCostomize = UIGridListCtrl.new(self:FindComponent("gridFunctionUse", UIGrid, self.objSetFunctionUseCostomize), HomeCustomizeSettingCell, "SimpleToggleCell")
  self.widgetFunctionCostomizeSize = self:FindComponent("SizeWidget", UIWidget, self.objSetFunctionUseCostomize)
  local l_objMessageBoardSettingContainer = self:FindGO("MessageBoardOpen")
  self.messageBoardPublic = self:FindComponent("SetPublicValid", UIToggle, l_objMessageBoardSettingContainer)
  self.messageBoardFriendsOnly = self:FindComponent("SetFriendsValidOnly", UIToggle, l_objMessageBoardSettingContainer)
  self.messageBoardInvalid = self:FindComponent("SetInvalidAll", UIToggle, l_objMessageBoardSettingContainer)
  self.noneTip = self:FindGO("NoneTip")
end

function HomeSettingPage:AddEvts()
  self:AddClickEvent(self:FindGO("BtnSave"), function()
    self:SaveSettings()
  end)
  self:AddClickEvent(self:FindGO("BtnDefault"), function()
    self:LoadDefaultSettings()
  end)
  self:AddClickEvent(self:FindGO("BtnHelp"), function(go)
    self:ClickHelp()
  end)
  self:AddClickEvent(self.objBtnFoldFurnitureCostomize, function()
    self:SwitchFurnitureCustomizeShow()
  end)
  self:AddClickEvent(self.objBtnFoldFunctionCostomize, function()
    self:SwitchFunctionCustomizeShow()
  end)
  EventDelegate.Add(self.togFurnitureCostomize.onChange, function()
    self:UpdateFurnitureCustomizeEnable()
  end)
  EventDelegate.Add(self.togFunctionCostomize.onChange, function()
    self:UpdateFunctionCustomizeEnable()
  end)
end

function HomeSettingPage:AddViewEvts()
end

function HomeSettingPage:LoadHomeSettings()
  local allForbidTypes = GameConfig.Home.can_forbid_furn_other
  if allForbidTypes then
    self.listFurnitureUseCostomize:ResetDatas(allForbidTypes)
  end
  local allShieldTypes = GameConfig.Home.can_forbid_furn_self
  if allShieldTypes then
    self.listFunctionUseCostomize:ResetDatas(allShieldTypes)
  end
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if not myHouseData then
    redlog("Cannot Find My House Data!")
    self:LoadDefaultSettings()
    return
  end
  if myHouseData:GetOpenType() == HouseData.HouseOpenType.Friend then
    self.togHomeFriendsOnly.value = true
  else
    self.togHomePublic.value = true
  end
  local forbidList = myHouseData:GetVisitorForbidTypes()
  if not forbidList or #forbidList < 1 then
    self.togFurniturePublic.value = true
  elseif allForbidTypes and #forbidList >= #allForbidTypes then
    self.togFurniturePrivate.value = true
  else
    self.togFurnitureCostomize.value = true
    self:UpdateFurnitureCustomizeEnable()
    self:SwitchFurnitureCustomizeShow(true)
  end
  if forbidList then
    local cells = self.listFurnitureUseCostomize:GetCells()
    for i = 1, #cells do
      cells[i]:RefreshStatus(1 > TableUtility.ArrayFindIndex(forbidList, cells[i].id))
    end
  end
  self.togShowName.value = myHouseData:IsShowFurnitureName()
  forbidList = myHouseData:GetMasterShieldTypes()
  if not forbidList or #forbidList < 1 then
    self.togFunctionAllOpen.value = true
  elseif allShieldTypes and #forbidList >= #allShieldTypes then
    self.togFunctionAllClose.value = true
  else
    self.togFunctionCostomize.value = true
    self:UpdateFunctionCustomizeEnable()
    self:SwitchFunctionCustomizeShow(true)
  end
  if forbidList then
    local cells = self.listFunctionUseCostomize:GetCells()
    for i = 1, #cells do
      cells[i]:RefreshStatus(1 > TableUtility.ArrayFindIndex(forbidList, cells[i].id))
    end
  end
  if myHouseData:GetMessageBoardStatue() == HouseData.MessageBoardOpenType.Friend then
    self.messageBoardFriendsOnly.value = true
  elseif myHouseData:GetMessageBoardStatue() == HouseData.MessageBoardOpenType.Close then
    self.messageBoardInvalid.value = true
  else
    self.messageBoardPublic.value = true
  end
  self.uiTableSettings:Reposition()
end

function HomeSettingPage:LoadDefaultSettings()
  self.togHomePublic.value = true
  self.togFurniturePublic.value = true
  self.togShowName.value = true
  self.togFunctionAllOpen.value = true
  self.messageBoardPublic.value = true
end

function HomeSettingPage:UpdateFurnitureCustomizeEnable()
  self.isFurnitureCustomizeEnable = self.togFurnitureCostomize.value
  self.btnFoldFurnitureCostomize.isEnabled = self.isFurnitureCustomizeEnable
  if not self.isFurnitureCustomizeEnable then
    self:SwitchFurnitureCustomizeShow(false)
  end
end

function HomeSettingPage:UpdateFunctionCustomizeEnable()
  self.isFunctionCustomizeEnable = self.togFunctionCostomize.value
  self.btnFoldFunctionCostomize.isEnabled = self.isFunctionCustomizeEnable
  if not self.isFunctionCustomizeEnable then
    self:SwitchFunctionCustomizeShow(false)
  end
end

function HomeSettingPage:SwitchFurnitureCustomizeShow(isShow)
  if not self.isFurnitureCustomizeEnable then
    isShow = false
  end
  if isShow ~= nil then
    if self.isFurnitureCustomizeShow == isShow then
      return
    end
    self.isFurnitureCustomizeShow = isShow
  else
    self.isFurnitureCustomizeShow = not self.isFurnitureCustomizeShow
  end
  self.objSetFurnitureUseCostomize:SetActive(self.isFurnitureCustomizeShow)
  self.tsfBtnFoldFurnitureCostomize.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, self.isFurnitureCustomizeShow and 180 or 0)
  self.uiTableSettings:Reposition()
end

function HomeSettingPage:SwitchFunctionCustomizeShow(isShow)
  if not self.isFunctionCustomizeEnable then
    isShow = false
  end
  if isShow ~= nil then
    if self.isFunctionCustomizeShow == isShow then
      return
    end
    self.isFunctionCustomizeShow = isShow
  else
    self.isFunctionCustomizeShow = not self.isFunctionCustomizeShow
  end
  self.objSetFunctionUseCostomize:SetActive(self.isFunctionCustomizeShow)
  self.tsfBtnFoldFunctionCostomize.localEulerAngles = LuaGeometry.GetTempVector3(0, 0, self.isFunctionCustomizeShow and 180 or 0)
  self.uiTableSettings:Reposition()
end

function HomeSettingPage:SaveSettings()
  if self.forbidSave then
    MsgManager.ShowMsgByID(49)
    return
  end
  self.forbidSave = true
  self.ltForbidSave = TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.forbidSave = false
    self.ltForbidSave = nil
  end, self)
  local openType = self.togHomeFriendsOnly.value and HouseData.HouseOpenType.Friend or HouseData.HouseOpenType.All
  local isFurnitureNameShow = self.togShowName.value
  local customizeTypes = GameConfig.Home.can_forbid_furn_other
  local forbidList = ReusableTable.CreateArray()
  local messageBoardType
  if self.messageBoardFriendsOnly.value then
    messageBoardType = 2
  elseif self.messageBoardInvalid.value then
    messageBoardType = 3
  else
    messageBoardType = 1
  end
  if self.togFurniturePrivate.value then
    if customizeTypes then
      for i = 1, #customizeTypes do
        forbidList[i] = customizeTypes[i]
      end
    end
  elseif self.togFurnitureCostomize.value then
    local cells = self.listFurnitureUseCostomize:GetCells()
    for i = 1, #cells do
      if cells[i].id and not cells[i].toggle.value then
        forbidList[#forbidList + 1] = cells[i].id
      end
    end
  end
  customizeTypes = GameConfig.Home.can_forbid_furn_self
  local shieldList = ReusableTable.CreateArray()
  if self.togFunctionAllClose.value then
    if customizeTypes then
      for i = 1, #customizeTypes do
        shieldList[i] = customizeTypes[i]
      end
    end
  elseif self.togFunctionCostomize.value then
    local cells = self.listFunctionUseCostomize:GetCells()
    for i = 1, #cells do
      if cells[i].id and not cells[i].toggle.value then
        shieldList[#shieldList + 1] = cells[i].id
      end
    end
  end
  local myHouseData = HomeProxy.Instance:GetMyHouseData()
  if not myHouseData or openType ~= myHouseData:GetOpenType() then
    ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.OpenType, openType)
  end
  if not myHouseData or isFurnitureNameShow ~= myHouseData:IsShowFurnitureName() then
    ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.ShowFurnitureName, isFurnitureNameShow and 1 or 0)
  end
  if myHouseData then
    local curList = myHouseData:GetVisitorForbidTypes()
    local dirty = #curList ~= #forbidList
    if not dirty then
      for i = 1, #forbidList do
        if 1 > TableUtility.ArrayFindIndex(curList, forbidList[i]) then
          dirty = true
          break
        end
      end
    end
    if dirty then
      ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.VisitorForbidType, nil, forbidList)
    end
  else
    ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.VisitorForbidType, nil, forbidList)
  end
  if myHouseData then
    local curList = myHouseData:GetMasterShieldTypes()
    local dirty = #curList ~= #shieldList
    if not dirty then
      for i = 1, #shieldList do
        if 1 > TableUtility.ArrayFindIndex(curList, shieldList[i]) then
          dirty = true
          break
        end
      end
    end
    if dirty then
      ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.MasterShieldType, nil, shieldList)
    end
  else
    ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.MasterShieldType, nil, shieldList)
  end
  if messageBoardType ~= myHouseData:GetMessageBoardStatue() then
    ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.BoardOpen, messageBoardType)
  end
  ReusableTable.DestroyAndClearArray(forbidList)
  ReusableTable.DestroyAndClearArray(shieldList)
end

function HomeSettingPage:ClickHelp()
  local helpData = Table_Help[PanelConfig.HomeSettingPage.id]
  self:OpenHelpView(helpData)
end

function HomeSettingPage:OnSwitch(isOpen)
  self:LoadHomeSettings()
end

function HomeSettingPage:ClearLTSave()
  if self.ltForbidSave then
    self.ltForbidSave:Destroy()
    self.ltForbidSave = nil
    self.forbidSave = false
  end
end

function HomeSettingPage:OnEnter()
  HomeSettingPage.super.OnEnter(self)
end

function HomeSettingPage:OnExit()
  self:ClearLTSave()
  HomeSettingPage.super.OnExit(self)
end
