QuestManualView = class("QuestManualView", ContainerView)
QuestManualView.ViewType = UIViewType.NormalLayer
autoImport("MainQuestPage")
autoImport("BranchQuestPage")
autoImport("PoemStoryPage")
autoImport("QuestManualVersionCell")
autoImport("MenuUnlockTracePage")
autoImport("PlotVoicePage")
QuestManualView.ColorTheme = {
  [1] = {
    color = LuaColor.New(1, 1, 1, 1)
  },
  [2] = {
    color = LuaColor.New(0.6588235294117647, 0.6588235294117647, 0.6588235294117647, 1)
  },
  [3] = {
    color = LuaColor.New(0, 0, 0, 1)
  },
  [4] = {
    color = LuaColor.New(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
  },
  [5] = {
    color = LuaColor.New(0.2549019607843137, 0.34901960784313724, 0.6666666666666666, 1)
  },
  [6] = {
    color = LuaColor.New(1, 0.8745098039215686, 0.36470588235294116, 1)
  },
  [7] = {
    color = LuaColor.New(0.3764705882352941, 0.4196078431372549, 0.5490196078431373, 1)
  },
  [8] = {
    color = LuaColor.New(0.8745098039215686, 0.8823529411764706, 0.9607843137254902, 1)
  },
  [9] = {
    color = LuaColor.New(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1)
  }
}
QuestManualView.PuzzleBlockPicPos = {
  [1] = {
    pos = LuaVector3(31.2, -30.4, 0),
    plusPos = LuaVector3(-14, 13, 0),
    plusPicName = "taskmanual_add_01"
  },
  [2] = {
    pos = LuaVector3(-2, -48.4, 0),
    plusPos = LuaVector3(0, -12.7, 0),
    plusPicName = "taskmanual_add_02"
  },
  [3] = {
    pos = LuaVector3(-11, -23.2, 0),
    plusPos = LuaVector3(0, 24.22, 0),
    plusPicName = "taskmanual_add_03"
  },
  [4] = {
    pos = LuaVector3(-23.7, -37.1, 0),
    plusPos = LuaVector3(18.12, 8.5, 0),
    plusPicName = "taskmanual_add_04"
  },
  [5] = {
    pos = LuaVector3(18.23, -12.5, 0),
    plusPos = LuaVector3(-24, -2.76, 0),
    plusPicName = "taskmanual_add_05"
  },
  [6] = {
    pos = LuaVector3(-3.18, -7.4, 0),
    plusPos = LuaVector3(26.2, -7.4, 0),
    plusPicName = "taskmanual_add_06"
  },
  [7] = {
    pos = LuaVector3(-9.6, 5.2, 0),
    plusPos = LuaVector3(0, 8.2, 0),
    plusPicName = "taskmanual_add_07"
  },
  [8] = {
    pos = LuaVector3(-36.1, 0.2, 0),
    plusPos = LuaVector3(34.68, -7.6, 0),
    plusPicName = "taskmanual_add_08"
  },
  [9] = {
    pos = LuaVector3(32, 6.2, 0),
    plusPos = LuaVector3(-1.8, -12.53, 0),
    plusPicName = "taskmanual_add_09"
  },
  [10] = {
    pos = LuaVector3(0.24, 5.93, 0),
    plusPos = LuaVector3(0, 30.48, 0),
    plusPicName = "taskmanual_add_10"
  },
  [11] = {
    pos = LuaVector3(-10.58, 7.19, 0),
    plusPos = LuaVector3(-10.71, 3.42, 0),
    plusPicName = "taskmanual_add_11"
  },
  [12] = {
    pos = LuaVector3(-23.9, 13.1, 0),
    plusPos = LuaVector3(15.15, -6.36, 0),
    plusPicName = "taskmanual_add_12"
  },
  [13] = {
    pos = LuaVector3(18.82, 36.7, 0),
    plusPos = LuaVector3(-16.71, -13.59, 0),
    plusPicName = "taskmanual_add_13"
  },
  [14] = {
    pos = LuaVector3(6, 28.9, 0),
    plusPos = LuaVector3(-3, -24, 0),
    plusPicName = "taskmanual_add_14"
  },
  [15] = {
    pos = LuaVector3(-13.3, 43.2, 0),
    plusPos = LuaVector3(9, -4, 0),
    plusPicName = "taskmanual_add_15"
  },
  [16] = {
    pos = LuaVector3(-36.8, 23.6, 0),
    plusPos = LuaVector3(17, -18, 0),
    plusPicName = "taskmanual_add_16"
  }
}
reusableArray = {}
showArray = {}
local originalTabSp = "taskmanual_btn_3"
local extendTabSp = "taskmanual_btn_1"
local originalTabMask = "taskmanual_btn_3b"
local extendTabMask = "taskmanual_btn_2"
local bgTextureName = "new_taskmanual_bg_bottom"
local versionCellHeight = 108
local manualViewType = {
  [1] = {
    type = "ProcessPage",
    name = ZhString.QuestManual_ProcessPage
  },
  [2] = {
    type = "MainPage",
    name = ZhString.QuestManual_MainQuestPage
  },
  [3] = {
    type = "PoemPage",
    name = ZhString.QuestManual_AnecdotePage
  },
  [4] = {
    type = "GuidePage",
    name = ZhString.QuestManual_GuidePage
  }
}

function QuestManualView:Init()
  QuestManualView.super.Init(self)
  self:GetGameObjects()
  self:InitView()
  self:addViewEventListener()
  self:addListEventListener()
  if self.tabIndex then
    self.defaultQuestType = self:FindGO("QuestType" .. self.tabIndex)
  end
  if self.defaultQuestType then
    self:QuestTypeChangeHandler(self.defaultQuestType)
  end
  self:InitData()
  if self.defaultVersion then
    QuestManualView.super.TabChangeHandler(self, self.defaultVersion)
    self.currentVersionCell = self.defaultVersion
    self:handleCategoryClick(self.defaultVersion)
  end
end

function QuestManualView:OnEnter()
  QuestManualView.super.OnEnter(self)
  ResourceManager.Instance:GC()
  ServiceQuestProxy.Instance:CallManualFunctionQuestCmd()
  PictureManager.Instance:SetUI(bgTextureName, self.bgTexture)
end

function QuestManualView:OnExit()
  EventManager.Me():RemoveEventListener(QuestManualEvent.GoClick, self.OnGoClick, self)
  QuestManualProxy.Instance:InitProxyData()
  PictureManager.Instance:UnLoadUI(bgTextureName, self.bgTexture)
  ResourceManager.Instance:GC()
  QuestManualView.super.OnExit(self)
  self.tabObj = nil
end

function QuestManualView:InitData()
  self.curTab = QuestManualProxy.Instance.lastGenTab
  self.validVersion = {}
  self:InitQuestVersionValid()
  self:HandleClickVersion(self.curTab)
  self:UpdateVersionTab()
end

function QuestManualView:GetGameObjects()
  self.versionGrid = self:FindGO("versionGrid", self.gameObject)
  self.tab = self:FindGO("questTypes")
  self.QuestTypeMaskList = {}
  self.tabObj = {}
  local unlockList = GameConfig.QuestManualUnlock or {}
  local activeTabNum = 0
  for i = 1, #manualViewType do
    local btnName = "QuestType" .. i
    local questTypeGo = self:FindGO(btnName)
    local togLabel = self:FindGO("Label", questTypeGo):GetComponent(UILabel)
    togLabel.text = manualViewType[i].name
    self.tabObj[i] = questTypeGo
    self.QuestTypeMaskList[btnName] = self:FindGO("QuestTypeMask" .. i)
    local questMarkLabel = self:FindGO("Label (1)", self.QuestTypeMaskList[btnName]):GetComponent(UILabel)
    questMarkLabel.text = manualViewType[i].name
    self:AddButtonEvent(btnName, function()
      QuestManualProxy.Instance.lastTab = i
      self:QuestTypeChangeHandler(questTypeGo)
    end)
    if not unlockList[i] or FunctionUnLockFunc.Me():CheckCanOpen(unlockList[i]) then
      self.tabObj[i]:SetActive(true)
      activeTabNum = activeTabNum + 1
    else
      self.tabObj[i]:SetActive(false)
    end
  end
  self.dotLine = self:FindGO("DotLine"):GetComponent(UISprite)
  self.dotLine.height = activeTabNum * 170
  if not QuestManualProxy.Instance.setEnd then
    if not FunctionUnLockFunc.Me():CheckCanOpen(unlockList[1]) then
      QuestManualProxy.Instance.lastTab = 2
      if GameConfig.TaskManualDefaultVersion then
        QuestManualProxy.Instance.lastVersion = GameConfig.TaskManualDefaultVersion[2]
      else
        QuestManualProxy.Instance.lastVersion = 1
      end
    else
      QuestManualProxy.Instance.lastTab = 1
      QuestManualProxy.Instance.lastVersion = GameConfig.TaskManualDefaultVersion and GameConfig.TaskManualDefaultVersion[1]
    end
    if QuestManualProxy.Instance.lastVersion > 12 then
      QuestManualProxy.Instance.lastGenTab = 2
    else
      QuestManualProxy.Instance.lastGenTab = 1
    end
    QuestManualProxy.Instance.setEnd = true
  end
  local sname = "QuestType" .. (PlotAudioProxy.Instance.needCenterOn and PlotAudioProxy.Instance.audioTab or FunctionUnLockFunc.Me():CheckCanOpen(unlockList[QuestManualProxy.Instance.lastTab]) and QuestManualProxy.Instance.lastTab or 2)
  self.defaultQuestType = self:FindGO(sname)
  self.versionListMask = self:FindGO("versionListMask"):GetComponent(UITexture)
  self.versionList = self:FindGO("versionList")
  if self.tabObj[4] then
    self:RegisterRedTipCheck(SceneTip_pb.EREDSYS_FUNCTION_OPENING, self.tabObj[4], 10, {-27, -19})
  end
  if self.tabObj[1] then
    RedTipProxy.Instance:RegisterUI(SceneTip_pb.EREDSYS_MANUAL_GOAL, self.tabObj[1], 10, {-27, -19})
  end
  self.versionSwitch = self:FindGO("versionSwitch")
  self.versionGen1 = self:FindGO("1.0", self.versionSwitch)
  self.versionGen1Widget = self.versionGen1:GetComponent(UIWidget)
  self.versionGen1Icon = self:FindGO("Icon", self.versionGen1):GetComponent(GradientUISprite)
  self.versionGen1IconMask = self:FindGO("Mask", self.versionGen1)
  self.versionGen1RedTip = self:FindGO("RedTipCell", self.versionGen1)
  self.versionGen1NameGo = self:FindGO("Sprite", self.versionGen1)
  self.versionGen2 = self:FindGO("2.0", self.versionSwitch)
  self.versionGen2Widget = self.versionGen2:GetComponent(UIWidget)
  self.versionGen2Icon = self:FindGO("Icon", self.versionGen2):GetComponent(GradientUISprite)
  self.versionGen2IconMask = self:FindGO("Mask", self.versionGen2)
  self.versionGen2RedTip = self:FindGO("RedTipCell", self.versionGen2)
  self.versionGen2NameGo = self:FindGO("Sprite", self.versionGen2)
  if self.tabObj[2] then
    self.tab2RedTip = self:FindGO("RedTip", self.tabObj[2])
  end
  if not GameConfig.TaskManualDefaultVersion then
    self.versionSwitch:SetActive(false)
  end
end

function QuestManualView:InitView()
  self.uiGridOfVersions = self.versionGrid:GetComponent(UIGrid)
  if self.listControllerOfVersions == nil then
    self.listControllerOfVersions = UIGridListCtrl.new(self.uiGridOfVersions, QuestManualVersionCell, "QuestManualVersionCell")
  end
  self.mainQuestPage = self:AddSubView("MainQuestPage", MainQuestPage)
  self.branchQuestPage = self:AddSubView("BranchQuestPage", BranchQuestPage)
  self.poemStoryPage = self:AddSubView("PoemStoryPage", PoemStoryPage)
  self.menuUnlockTracePage = self:AddSubView("MenuUnlockTracePage", MenuUnlockTracePage)
  self.plotVoicePage = self:AddSubView("PlotVoicePage", PlotVoicePage)
  self.bgList = {}
  self.versionScrollView = self:FindGO("versionScrollView"):GetComponent(UIScrollView)
  local bgCt = self:FindGO("bgCt")
  self.bgTexture = self:FindGO("Texture", bgCt):GetComponent(UITexture)
end

function QuestManualView:addViewEventListener()
  self:AddButtonEvent("CloseButton", function()
    PictureManager.Instance:UnLoadUI()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.versionGen1, function()
    if not self.validVersion[1] then
      MsgManager.ShowMsgByID(43251)
      return
    end
    self.curTab = 1
    QuestManualProxy.Instance.lastGenTab = self.curTab
    self:UpdateVersionTab()
    self:UpdateVersionSwitchRedTip()
    self:HandleClickVersion(1)
    if self.defaultVersion then
      QuestManualView.super.TabChangeHandler(self, self.defaultVersion)
      self.currentVersionCell = self.defaultVersion
      self:handleCategoryClick(self.defaultVersion)
    end
  end)
  self:AddClickEvent(self.versionGen2, function()
    if not self.validVersion[2] then
      MsgManager.ShowMsgByID(43251)
      return
    end
    self.curTab = 2
    QuestManualProxy.Instance.lastGenTab = self.curTab
    self:UpdateVersionTab()
    self:UpdateVersionSwitchRedTip()
    self:HandleClickVersion(2)
    if self.defaultVersion then
      QuestManualView.super.TabChangeHandler(self, self.defaultVersion)
      self.currentVersionCell = self.defaultVersion
      self:handleCategoryClick(self.defaultVersion)
    end
  end)
end

function QuestManualView:addListEventListener()
  self:AddListenEvt(ServiceEvent.QuestQueryManualQuestCmd, self.updateManualContent)
  EventManager.Me():AddEventListener(QuestManualEvent.GoClick, self.OnGoClick, self)
  self:AddListenEvt(RedTipProxy.RemoveRedTipEvent, self.UpdateVersionSwitchRedTip)
  self:AddListenEvt(RedTipProxy.UpdateParamEvent, self.HandleUpdateQuestPuzzleRedTips)
end

function QuestManualView:QuestTypeChangeHandler(go)
  if self.currentQuestType ~= go then
    if self.currentQuestType then
      self.QuestTypeMaskList[self.currentQuestType.name]:SetActive(false)
    end
    self.currentQuestType = go
    local typeName = go.name
    self.QuestTypeMaskList[typeName]:SetActive(true)
    self:LoadQuestTypeContent(typeName)
    self:UpdateVersionRedtips(typeName)
    self:UpdateVersionSwitchRedTip()
  end
end

function QuestManualView:LoadQuestTypeContent(typeName)
  if typeName == "QuestType1" then
    self.mainQuestPage:Hide()
    self.poemStoryPage:Hide()
    self.menuUnlockTracePage:Hide()
  elseif typeName == "QuestType2" then
    self.mainQuestPage:Show()
    self.poemStoryPage:Hide()
    self.menuUnlockTracePage:Hide()
  elseif typeName == "QuestType3" then
    self.mainQuestPage:Hide()
    self.poemStoryPage:Show()
    self.menuUnlockTracePage:Hide()
  elseif typeName == "QuestType4" then
    self.mainQuestPage:Hide()
    self.poemStoryPage:Hide()
    self.menuUnlockTracePage:Show()
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_FUNCTION_OPENING)
  end
  self:updateManualContent()
end

function QuestManualView:UpdateVersionRedtips(typeName)
  if typeName == "QuestType1" then
    self.redtipType = 1
  elseif typeName == "QuestType2" then
    self.redtipType = 2
  else
    self.redtipType = 3
  end
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    singleCell:UpdateRedtips(self.redtipType)
  end
end

function QuestManualView:TabChangeHandler(cell)
  if self.currentVersionCell ~= cell then
    QuestManualView.super.TabChangeHandler(self, cell)
    self.currentVersionCell = cell
    self:handleCategoryClick(cell)
  end
end

function QuestManualView:handleCategoryClick(cell)
  helplog("handleCategoryClick")
  self:handleCategorySelect(cell.data)
  local cells = self.listControllerOfVersions:GetCells()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local myRace = Table_Class[myPro].Race
  local curVersionRace = cell.data.Race or 1
  if myRace == 1 and myRace ~= curVersionRace then
    MsgManager.ShowMsgByID(43314)
  end
  for i = 1, #cells do
    local single = cells[i]
    if single == cell then
      single:setIsSelected(true)
      if self.curTab == 2 then
        QuestManualProxy.Instance.lastVersion = i + 12
      else
        QuestManualProxy.Instance.lastVersion = i
      end
    else
      single:setIsSelected(false)
    end
  end
end

function QuestManualView:handleCategorySelect(data)
  local versionData = QuestManualProxy.Instance:GetManualQuestDatas(data.version)
  if versionData then
    self:updateManualContent()
  else
    ServiceQuestProxy.Instance:CallQueryManualQuestCmd(data.version)
  end
end

function QuestManualView:updateManualContent()
  if self.currentVersionCell then
    local currentVersion = self.currentVersionCell.data.version
    local currentTypeName = self.currentQuestType.name
    self:updateVersionSwitchTab(currentTypeName, currentVersion)
    self.versionList:SetActive(currentTypeName ~= "QuestType4")
    if currentTypeName == "QuestType1" then
    elseif currentTypeName == "QuestType2" then
      self.mainQuestPage:SetData(currentVersion)
    elseif currentTypeName == "QuestType3" then
      self.poemStoryPage:SetData(currentVersion)
    elseif currentTypeName == "QuestType4" then
      self.menuUnlockTracePage:SetData()
    end
  end
end

function QuestManualView:updateVersionSwitchTab(currentTypeName, currentVersion)
  currentTypeName = currentTypeName or self.currentQuestType.name
  IconManager:SetUIIcon("tab_icon_adventure", self.versionGen1Icon)
  IconManager:SetUIIcon("tab_icon_heroic-hymn", self.versionGen2Icon)
  self.versionGen1NameGo:SetActive(false)
  self.versionGen2NameGo:SetActive(false)
  goto lbl_42
  IconManager:SetUIIcon("tab_icon_47", self.versionGen1Icon)
  IconManager:SetUIIcon("tab_icon_88", self.versionGen2Icon)
  self.versionGen1NameGo:SetActive(true)
  self.versionGen2NameGo:SetActive(true)
  ::lbl_42::
end

function QuestManualView:OnGoClick(cell)
  self:CloseSelf()
end

function QuestManualView:InitQuestVersionValid()
  for k, v in pairs(Table_QuestVersion) do
    if not v.Tab or v.Tab == 1 then
      if not self.validVersion[1] then
        self.validVersion[1] = 1
      end
    elseif v.Tab == 2 then
      self.validVersion[2] = 1
    end
  end
end

function QuestManualView:UpdateVersionTab()
  local questversion = ReusableTable.CreateArray()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local myRace = Table_Class[myPro].Race
  local hasDoram = ProfessionProxy.Instance:HasDoramProf()
  local switchRedTip = false
  for k, v in pairs(Table_QuestVersion) do
    local funcState
    if v.FuncState and not FunctionUnLockFunc.checkFuncStateValid(v.FuncState) then
      funcState = false
    else
      funcState = true
    end
    local copy = {}
    if funcState then
      if self.curTab == 1 then
        if (not v.Tab or v.Tab == 1) and (not v.Race or v.Race == myRace or hasDoram) then
          TableUtility.TableShallowCopy(copy, v)
          TableUtility.ArrayPushBack(questversion, copy)
        end
      elseif self.curTab == 2 and v.Tab and v.Tab == 2 and (not v.Race or v.Race == myRace or hasDoram) then
        TableUtility.TableShallowCopy(copy, v)
        TableUtility.ArrayPushBack(questversion, copy)
      end
    end
  end
  table.sort(questversion, function(l, r)
    if l.sortid == r.sortid then
      return l.id < r.id
    else
      return l.sortid < r.sortid
    end
  end)
  self.listControllerOfVersions:ResetDatas(questversion)
  self.versionScrollView:ResetPosition()
  ReusableTable.DestroyAndClearArray(questversion)
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    self:AddTabChangeEvent(singleCell.gameObject, nil, singleCell)
    singleCell:UpdateRedtips(self.redtipType)
  end
  local cellindex = PlotAudioProxy.Instance.needCenterOn and PlotAudioProxy.Instance.audioVersion or QuestManualProxy.Instance.lastVersion
  helplog("cellindex", cellindex, self.curTab)
  local config = Table_QuestVersion[cellindex]
  local targetTab = config and config.Tab or 1
  if self.curTab ~= targetTab then
    self.defaultVersion = cells[1]
  else
    if 12 < cellindex then
      cellindex = cellindex - 12
    end
    self.defaultVersion = cells[cellindex]
  end
end

function QuestManualView:UpdateVersionSwitchRedTip()
  local myPro = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local myRace = Table_Class[myPro].Race
  local currentTypeName = self.currentQuestType.name
  local tab2RedTip = false
  local versionGen1RedTip = false
  local versionGen2RedTip = false
  for k, v in pairs(Table_QuestVersion) do
    if not v.Race or v.Race == myRace then
      if v.Tab and v.Tab == 2 then
        local redTipEnum
        if currentTypeName == "QuestType2" then
          redTipEnum = SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK
        elseif currentTypeName == "QuestType1" then
          redTipEnum = SceneTip_pb.EREDSYS_MANUAL_GOAL
        end
        if RedTipProxy.Instance:IsNew(redTipEnum, tonumber(v.version) * 1000) then
          versionGen2RedTip = true
        end
        if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, tonumber(v.version) * 1000) then
          tab2RedTip = true
        end
      elseif not v.Tab or v.Tab == 1 then
        local redTipEnum
        if currentTypeName == "QuestType2" then
          redTipEnum = SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK
        elseif currentTypeName == "QuestType1" then
          redTipEnum = SceneTip_pb.EREDSYS_MANUAL_GOAL
        end
        if RedTipProxy.Instance:IsNew(redTipEnum, tonumber(v.version) * 1000) then
          versionGen1RedTip = true
        end
        if RedTipProxy.Instance:IsNew(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK, tonumber(v.version) * 1000) then
          tab2RedTip = true
        end
      end
    end
  end
  self.versionGen1RedTip:SetActive(versionGen1RedTip)
  self.versionGen2RedTip:SetActive(versionGen2RedTip)
  if self.tab2RedTip then
    self.tab2RedTip:SetActive(tab2RedTip)
  end
end

local colorWhite = LuaColor.White()

function QuestManualView:HandleClickVersion(version)
  if version == 1 then
    self.versionGen1Icon.gradientTop = LuaColor.New(1, 0.9333333333333333, 0.41568627450980394, 1)
    self.versionGen1Icon.gradientBottom = colorWhite
    self.versionGen1IconMask:SetActive(true)
    self.versionGen1Widget.alpha = 1
    self.versionGen2Icon.gradientTop = LuaColor.New(1, 1, 1, 0.6)
    self.versionGen2Icon.gradientBottom = LuaColor.New(1, 1, 1, 0.6)
    self.versionGen2IconMask:SetActive(false)
    self.versionGen2Widget.alpha = 0.6
  elseif version == 2 then
    self.versionGen2Icon.gradientTop = LuaColor.New(1, 0.9333333333333333, 0.41568627450980394, 1)
    self.versionGen2Icon.gradientBottom = colorWhite
    self.versionGen2IconMask:SetActive(true)
    self.versionGen2Widget.alpha = 1
    self.versionGen1Icon.gradientTop = LuaColor.New(1, 1, 1, 0.6)
    self.versionGen1Icon.gradientBottom = LuaColor.New(1, 1, 1, 0.6)
    self.versionGen1IconMask:SetActive(false)
    self.versionGen1Widget.alpha = 0.6
  end
end

function QuestManualView:HandleUpdateQuestPuzzleRedTips()
  local cells = self.listControllerOfVersions:GetCells()
  for i = 1, #cells do
    local singleCell = cells[i]
    singleCell:UpdateRedtips(self.redtipType)
  end
  self:UpdateVersionSwitchRedTip()
end
