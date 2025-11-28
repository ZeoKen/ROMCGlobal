HomeInfoPage = class("HomeInfoPage", SubView)
HomeInfoPage.texName_homeFrame = "home_information_frame"
HomeInfoPage.texName_homeScene = "home_information_framebg"
HomeInfoPage.texName_roMark = "home_information_icon_ro"
HomeInfoPage.sprName_PopularityIcon = "poring_fight"
local color_effectGray = LuaColor(0.4980392156862745, 0.4980392156862745, 0.4980392156862745, 1)
local color_effectActive = LuaColor(0.6235294117647059, 0.30980392156862746, 0.03529411764705882, 1)

function HomeInfoPage:Init()
  self.redTipOffset = {0, 0}
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeInfoPage:InitUI()
  self.gameObject = self:FindGO("HomeInfoPage")
  self.inputHomeName = self:FindComponent("InputHomeName", UIInput)
  self.inputSignInfo = self:FindComponent("SignInfoInput", UIInput)
  self.objHouseIcon = self:FindGO("sprHouseIcon")
  self.objHouseIconRedTipRoot = self:FindGO("redTipParent", self.objHouseIcon)
  self.sprHouseIcon = self.objHouseIcon:GetComponent(UISprite)
  self.inputHomeName.characterLimit = GameConfig.System.homename_max * 3
  self.inputSignInfo.characterLimit = GameConfig.System.homename_max * 5
  local l_objHomeInfoTable = self:FindGO("HomeInfoTable")
  self.tableHomeInfo = l_objHomeInfoTable:GetComponent(UITable)
  self.labHomeLv = self:FindComponent("labHomeLv", UILabel, l_objHomeInfoTable)
  self.labHomeScore = self:FindComponent("labHomeScore", UILabel, l_objHomeInfoTable)
  self.sliderHomeScore = self:FindComponent("sliderHomeScore", UISlider, l_objHomeInfoTable)
  local l_objPopularityInfo = self:FindGO("HomePopularity", l_objHomeInfoTable)
  self.sprPopularityIcon = self:FindComponent("HeadIcon", UISprite, l_objPopularityInfo)
  self.labVisitCount = self:FindComponent("labVisitCount", UILabel, l_objPopularityInfo)
  local l_objTypeInfo = self:FindGO("HomeType", l_objHomeInfoTable)
  self.labHomeType = self:FindComponent("labHomeType", UILabel, l_objTypeInfo)
  self.objBtnTypeDesc = self:FindGO("BtnDesc", l_objTypeInfo)
  self.objTypeNormalBG = self:FindGO("BgNormal", l_objTypeInfo)
  self.objTypeUpdateContent = self:FindGO("UpdateContent", l_objTypeInfo)
  self.objBtnGotoUpdate = self:FindGO("BtnGoto", l_objTypeInfo)
  local l_tsfGridUpdateMat = self:FindGO("gridMaterials", l_objTypeInfo).transform
  self.gridUpdateMat = l_tsfGridUpdateMat:GetComponent(UIGrid)
  self.updateMaterials = {}
  for i = 0, l_tsfGridUpdateMat.childCount - 1 do
    local tsfSingleMat = l_tsfGridUpdateMat:Find("Material" .. i)
    if not tsfSingleMat then
      redlog("Cannot Find Material" .. i)
    else
      local objSingleMat = tsfSingleMat.gameObject
      self.updateMaterials[#self.updateMaterials + 1] = {
        gameObject = objSingleMat,
        sprIcon = self:FindComponent("sprIcon", UISprite, objSingleMat),
        labProgress = self:FindComponent("labProgress", UILabel, objSingleMat),
        sliderProgress = self:FindComponent("sliderProgress", UISlider, objSingleMat)
      }
    end
  end
  self.objBtnEditHomeName = self:FindGO("BtnEditHomeName")
  self.sprBtnEditHomeName = self.objBtnEditHomeName:GetComponent(UISprite)
  
  function self.inputHomeName.label.onChange()
    if self.sprBtnEditHomeName then
      self.sprBtnEditHomeName:ResetAndUpdateAnchors()
    end
  end
  
  self.objBtnEnterArea = self:FindGO("EnterAreaButton")
  self.labBtnEnterArea = self:FindComponent("Label", UILabel, self.objBtnEnterArea)
  self.sprBtnEnterArea = self:FindComponent("BG", UISprite, self.objBtnEnterArea)
  self.colBtnEnterArea = self.objBtnEnterArea:GetComponent(BoxCollider)
  self.giftTip = self:FindGO("GiftTip", self.enterAreaButton)
  self.noneTip = self:FindGO("NoneTip")
  if FunctionPerformanceSetting.CheckInputForbidden() then
    self.objBtnEditHomeName:SetActive(false)
  end
end

function HomeInfoPage:AddEvts()
  self:AddClickEvent(self:FindGO("BtnHomeScoreDetail"), function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HomeScoreLvPopUp
    })
  end)
  self:AddClickEvent(self.objBtnEnterArea, function(go)
    if Game.Myself:IsDead() then
      MsgManager.ShowMsgByIDTable(2500)
      return
    end
    ServiceHomeCmdProxy.Instance:CallEnterHomeCmd(FunctionLogin.Me():getLoginData().accid, Game.Myself.data.id)
    self.container:CloseSelf()
  end)
  self:AddClickEvent(self:FindGO("BtnHelp"), function(go)
    self:ClickHelp()
  end)
  self:AddClickEvent(self.objBtnEditHomeName, function(go)
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_HOME) then
      return
    end
    self.inputHomeName.isSelected = not self.inputHomeName.isSelected
  end)
  local signObj = self:FindGO("SignInfoOption")
  if signObj and FunctionPerformanceSetting.CheckInputForbidden() then
    signObj:SetActive(false)
  end
  self:AddClickEvent(self:FindGO("SignInfoOption"), function(go)
    if FunctionUnLockFunc.Me():ForbidInput(ProtoCommon_pb.EFUNCPARAM_RENAME_HOME) then
      return
    end
    self.inputSignInfo.isSelected = not self.inputSignInfo.isSelected
  end)
  self:AddSelectEvent(self.inputHomeName, function(go, state)
    if state then
      return
    end
    if self.myHouseData and self.myHouseData.name ~= self.inputHomeName.value then
      self:TrySetHomeName()
    end
  end)
  self:AddSelectEvent(self.inputSignInfo, function(go, state)
    if state then
      return
    end
    if self.myHouseData and self.myHouseData.sign ~= self.inputSignInfo.value then
      self:TrySetHomeSign()
    end
  end)
  self:AddClickEvent(self.objBtnGotoUpdate, function()
    if self.curUpdateShortcutID then
      FuncShortCutFunc.Me():CallByID(self.curUpdateShortcutID)
    end
  end)
  self:AddClickEvent(self.objBtnTypeDesc, function()
    local helpData = self.curTypeHelpID and Table_Help[self.curTypeHelpID]
    if helpData then
      self:OpenHelpView(helpData)
    end
  end)
  self:AddClickEvent(self.objHouseIcon, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HouseChooseView
    })
  end)
end

function HomeInfoPage:TrySetHomeName()
  local name = self.inputHomeName.value
  if name == "" then
    MsgManager.ShowMsgByIDTable(1006)
    self.inputHomeName.value = self.myHouseData and self.myHouseData.name or ""
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.homename_min then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homename_max
    })
    self.inputHomeName.label.color = ColorUtil.NGUILabelRed
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(2604)
    self.inputHomeName.label.color = ColorUtil.NGUILabelRed
    return
  end
  if length > GameConfig.System.homename_max then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homename_max
    })
    name = StringUtil.getTextByIndex(name, 1, GameConfig.System.homename_max)
    self.inputHomeName.value = name
  end
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.Name, nil, nil, name)
end

function HomeInfoPage:TrySetHomeSign()
  local name = self.inputSignInfo.value
  if name == "" then
    MsgManager.ShowMsgByIDTable(38021)
    self.inputSignInfo.value = self.myHouseData and self.myHouseData.sign or ""
    return
  end
  local length = StringUtil.Utf8len(name)
  if length < GameConfig.System.homesign_min then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homesign_max
    })
    self.inputSignInfo.label.color = ColorUtil.NGUILabelRed
    return
  end
  if FunctionMaskWord.Me():CheckMaskWord(name, GameConfig.MaskWord.HomeName) then
    MsgManager.ShowMsgByIDTable(38022)
    self.inputSignInfo.label.color = ColorUtil.NGUILabelRed
    return
  end
  if length > GameConfig.System.homesign_max then
    MsgManager.ShowMsgByIDTable(38023, {
      GameConfig.System.homesign_max
    })
    name = StringUtil.getTextByIndex(name, 1, GameConfig.System.homesign_max)
    self.inputSignInfo.value = name
  end
  ServiceHomeCmdProxy.Instance:CallOptUpdateHomeCmd(nil, HouseData.HouseOptType.Sign, nil, nil, name)
end

function HomeInfoPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdQueryHouseDataHomeCmd, self.UpdateHomeInfo)
  self:AddListenEvt(ServiceEvent.HomeCmdOptUpdateHomeCmd, self.UpdateHouseIcon)
  self:AddListenEvt(HomeEvent.EnterHome, self.RefreshEnterAreaBtn)
  self:AddListenEvt(HomeEvent.ExitHome, self.RefreshEnterAreaBtn)
end

function HomeInfoPage:ClickHelp()
  local helpData = Table_Help[PanelConfig.HomeInfoPage.id]
  self:OpenHelpView(helpData)
end

function HomeInfoPage:UpdateHomeInfo()
  self.myHouseData = HomeProxy.Instance:GetMyHouseData()
  if self.myHouseData then
    self.inputHomeName.value = self.myHouseData.name
    self.inputSignInfo.value = self.myHouseData.sign
    self.sprBtnEditHomeName:ResetAndUpdateAnchors()
    self.labVisitCount.text = self.myHouseData:GetVisitCount()
    self.labHomeLv.text = string.format(ZhString.Home_Lv, self.myHouseData.lv or 0)
    if self.myHouseData:IsMaxLv() then
      self.labHomeScore.text = "max"
      self.sliderHomeScore.value = 1
    else
      local curExp, needExp = self.myHouseData:GetCurLvScore(), self.myHouseData:GetCurLvNeedScore()
      self.labHomeScore.text = string.format("%s/%s", self.myHouseData.score, self.myHouseData:GetCurLvNeedTotalScore())
      self.sliderHomeScore.value = 0 < needExp and curExp / needExp or 0
    end
  else
    self.labHomeLv.text = string.format(ZhString.Home_Lv, 0)
    self.labHomeScore.text = "0/100"
    self.sliderHomeScore.value = 0
  end
  self:UpdateHouseIcon()
  self:RefreshHouseTypeInfo()
  self:RefreshEnterAreaBtn()
  self.tableHomeInfo:Reposition()
  self:UpdateGiftTip()
end

function HomeInfoPage:UpdateHouseIcon()
  if not self.myHouseData then
    self.myHouseData = HomeProxy.Instance:GetMyHouseData()
  end
  local newGardenHouseID = self.myHouseData and self.myHouseData:GetGardenHouseID() or 1
  local staticData = Table_GardenHouseType and Table_GardenHouseType[newGardenHouseID]
  if staticData then
    IconManager:SetHomeBuildingIcon(staticData.Icon, self.sprHouseIcon)
  end
end

function HomeInfoPage:RefreshHouseTypeInfo()
  self.myHouseData = HomeProxy.Instance:GetMyHouseData()
  if not self.myHouseData then
    self.objTypeNormalBG:SetActive(true)
    self.objTypeUpdateContent:SetActive(false)
    return
  end
  local houseConfig = self.myHouseData.houseConfig
  if not houseConfig then
    redlog("Error! Cannot find cur house map data in GameConfig.")
    return
  end
  self.labHomeType.text = houseConfig.Name
  self.curUpdateShortcutID = houseConfig.UpdateShortcutPowerID
  self.curTypeHelpID = houseConfig.HelpID
  self.objBtnTypeDesc:SetActive(self.curTypeHelpID ~= nil)
  local isUpdating = houseConfig.UpdateStartMenuID and FunctionUnLockFunc.Me():CheckCanOpen(houseConfig.UpdateStartMenuID)
  self.objTypeNormalBG:SetActive(not isUpdating)
  self.objTypeUpdateContent:SetActive(isUpdating == true)
  if not isUpdating then
    return
  end
  local singleMaterial, subQuestData, questData, itemSData, process, totalNum, isSubmit
  for i = 1, #self.updateMaterials do
    singleMaterial = self.updateMaterials[i]
    subQuestData = houseConfig.SubUpdateQuestDatas[i]
    questData = subQuestData and QuestProxy.Instance:getQuestDataByIdAndType(subQuestData.id, SceneQuest_pb.EQUESTLIST_ACCEPT)
    isSubmit = subQuestData and not questData and QuestProxy.Instance:getQuestDataByIdAndType(subQuestData.id, SceneQuest_pb.EQUESTLIST_SUBMIT)
    itemSData = Table_Item[questData and questData.itemId or subQuestData.itemID]
    if itemSData then
      IconManager:SetItemIcon(itemSData.Icon, singleMaterial.sprIcon)
    end
    totalNum = questData and questData.totalNum and questData.totalNum > 0 and questData.totalNum or subQuestData.needNum
    process = isSubmit and totalNum or questData and questData.process and questData.process or 0
    singleMaterial.labProgress.text = process .. "/" .. totalNum
    singleMaterial.sliderProgress.value = process / totalNum
  end
  self.gridUpdateMat:Reposition()
end

function HomeInfoPage:RefreshEnterAreaBtn()
  local isAtHome = HomeManager.Me():IsAtMyselfHome()
  self.colBtnEnterArea.enabled = not isAtHome
  if isAtHome then
    self:SetTextureGrey(self.sprBtnEnterArea)
    self.labBtnEnterArea.effectColor = color_effectGray
  else
    self:SetTextureWhite(self.sprBtnEnterArea)
    self.labBtnEnterArea.effectColor = color_effectActive
  end
end

function HomeInfoPage:OnSwitch(isOpen)
  self:UpdateHomeInfo()
end

function HomeInfoPage:UpdateGiftTip()
  local isNew = RedTipProxy.Instance:InRedTip(10758)
  self.giftTip:SetActive(isNew)
end

function HomeInfoPage:OnEnter()
  HomeInfoPage.super.OnEnter(self)
  PictureManager.Instance:SetHome(HomeInfoPage.texName_homeFrame, self:FindComponent("texBgFrame", UITexture))
  PictureManager.Instance:SetHome(HomeInfoPage.texName_homeScene, self:FindComponent("texBgScene", UITexture))
  PictureManager.Instance:SetHome(HomeInfoPage.texName_roMark, self:FindComponent("texROMark", UITexture))
  IconManager:SetUIIcon(HomeInfoPage.sprName_PopularityIcon, self.sprPopularityIcon)
  RedTipProxy.Instance:RegisterUI(GameConfig.Home.GardenHouseRedTip, self.objHouseIconRedTipRoot, self.sprHouseIcon.depth + 5, self.redTipOffset, NGUIUtil.AnchorSide.Center)
end

function HomeInfoPage:OnExit()
  RedTipProxy.Instance:UnRegisterUI(GameConfig.Home.GardenHouseRedTip, self.objHouseIconRedTipRoot)
  HomeInfoPage.super.OnExit(self)
end
