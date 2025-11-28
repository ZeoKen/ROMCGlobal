autoImport("BaseTip")
PetScoreTip = class("PetScoreTip", BaseView)
autoImport("TipLabelCell")
autoImport("ProfessionSkillCell")

function PetScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("PetScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end

function PetScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function PetScoreTip:Init()
  self.monstername = self:FindComponent("MonsterName", UILabel)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  local bottomGO = self:FindGO("Bottom")
  self.bottomGrid = bottomGO:GetComponent(UIGrid)
  self.chatacterBtn = self:FindGO("ChatacterBtn", bottomGO)
  local btnText = self:FindComponent("Label", UILabel, self.chatacterBtn)
  btnText.text = ZhString.ItemTip_BuyGetItem
  self:AddClickEvent(self.chatacterBtn, function(go)
    if self.data and self.data.staticData then
      self:OnCatchItemGetWayClicked()
    end
  end)
  self:Hide(self.chatacterBtn)
  self:initLockBord()
  self.gotoCatchBtn = self:FindGO("GotoBtn")
  self.gotoLabel = self:FindComponent("Label", UILabel, self.gotoCatchBtn)
  self.gotoLabel.text = ZhString.ItemTip_GotoCatchPet
  self:AddClickEvent(self.gotoCatchBtn, function()
    self:GotoCatchPet()
  end)
  self:Hide(self.gotoCatchBtn)
  self.getWayBtn = self:FindGO("GetWayBtn")
  self.getWayLabel = self:FindComponent("Label", UILabel, self.getWayBtn)
  self:AddClickEvent(self.getWayBtn, function()
    self:OnEggGetWayClicked()
  end)
  self:Hide(self.getWayBtn)
  local skillGrid = self:FindComponent("PetSkillTable", UITable)
  self.gridList = UIGridListCtrl.new(skillGrid, ProfessionSkillCell, "ProfessionSkillCell")
  self.gridList:AddEventListener(MouseEvent.MouseClick, self.clickHandler, self)
  self.MonstPro = self:FindComponent("MonstPro", UISprite)
  self.MonstRace = self:FindComponent("MonstRace", UISprite)
end

function PetScoreTip:GotoCatchPet()
  local sData = self.data.staticData
  if not sData then
    return
  end
  local catchData = PetProxy.Instance:GetCaptureDataByPetID(sData.id)
  local npcId = catchData and catchData.id
  if not npcId then
    return
  end
  local oriMonster = Table_MonsterOrigin[npcId]
  if not oriMonster then
    return
  end
  local toMapId, toPos
  local searchedMaps = {}
  for _, v in ipairs(oriMonster) do
    local mapId = v.mapID
    if not searchedMaps[mapId] then
      if MapTeleportUtil.CanTargetTransferTo(mapId) then
        toMapId = mapId
        toPos = v.pos
        break
      end
      searchedMaps[mapId] = 1
    end
  end
  if not toMapId then
    MsgManager.ShowMsgByID(98)
    return
  end
  FuncShortCutFunc.Me():MoveToPos({
    Event = {mapid = toMapId, pos = toPos}
  })
  GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
end

function PetScoreTip:initLockBord()
  local obj = self:FindGO("LockBord")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    obj.name = "LockBord"
  end
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.sprLock = self:FindComponent("Sprite (1)", UISprite, obj)
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  
  function self.lockTipLabel.onChange()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  
  local LockTitle = self:FindComponent("LockTitle", UILabel)
  LockTitle.text = ZhString.MonsterTip_LockTitle
  self.modelBottombg = self:FindGO("modelBottombg")
  self.getPathBtn = self:FindGO("getPathBtn")
  self.BottomCt = self:FindGO("BottomCt")
  self:Show(self.getPathBtn)
  self.dropContainer = self:FindGO("DropContainer")
  self:AddClickEvent(self.getPathBtn, function(go)
    self:OnEggGetWayClicked()
  end)
end

function PetScoreTip:ShouldShowGetWayBtn()
  local petId = self.data and self.data.staticData and self.data.staticData.id
  if petId then
    local egg = Table_Pet[petId]
    local eggId = egg and egg.EggID
    if eggId then
      local getWayData = GainWayTipProxy.Instance:GetDataByStaticID(eggId)
      if getWayData and #getWayData.datas > 0 then
        return true
      end
    end
  end
  return false
end

function PetScoreTip:ShouldShowCatchItemBtn()
  local petId = self.data and self.data.staticData and self.data.staticData.id
  if petId then
    local catchItemData = PetProxy.Instance:GetCaptureDataByPetID(petId)
    local itemId = catchItemData and catchItemData.GiftItemID
    if itemId then
      return true
    end
  end
  return false
end

function PetScoreTip:OnCatchItemGetWayClicked()
  local petId = self.data and self.data.staticData and self.data.staticData.id
  if petId then
    local catchItemData = PetProxy.Instance:GetCaptureDataByPetID(petId)
    local itemId = catchItemData and catchItemData.GiftItemID
    if itemId then
      self:ShowGainWayTip(itemId)
    end
  end
end

function PetScoreTip:OnEggGetWayClicked()
  if self.data and self.data.staticData then
    local egg = Table_Pet[self.data.staticData.id]
    local eggId = 0
    if egg then
      eggId = egg.EggID
    end
    self:ShowGainWayTip(eggId)
  end
end

function PetScoreTip:CloseGainWayTip()
  if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
end

function PetScoreTip:ShowGainWayTip(itemId)
  if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  else
    self.gainwayCtl = GainWayTip.new(self.dropContainer)
    self.gainwayCtl:SetData(itemId)
  end
end

function PetScoreTip:clickHandler(target)
  local skillId = target.data
  local skillItem = SkillItemData.new(skillId)
  local tip = TipManager.Instance:ShowPetSkillTip(skillItem)
  if tip then
    tip.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(175, 0)
  end
end

function PetScoreTip:SetData(monsterData)
  self.data = monsterData
  self:initData()
  self:SetLockState()
  self:adjustPanelDepth(4)
  self:UpdatePetSkill()
  self:Show3DModel()
  self:UpdateAttriContext()
  self.bottomGrid:Reposition()
end

function PetScoreTip:initData()
  local sdata = self.data.staticData
  if sdata then
    if sdata.Nature then
      local result = IconManager:SetUIIcon(sdata.Nature, self.MonstPro)
      if not result then
        self:Hide(self.MonstPro.gameObject)
      else
        self:Show(self.MonstPro.gameObject)
      end
    else
      self:Hide(self.MonstPro.gameObject)
    end
    self:Hide(self.MonstRace.gameObject)
  end
  if self:ShouldShowCatchItemBtn() then
    self:Show(self.chatacterBtn)
    self:Hide(self.gotoCatchBtn)
    self:Hide(self.getWayBtn)
  else
    self:Hide(self.chatacterBtn)
    self:Hide(self.gotoCatchBtn)
    self:Hide(self.getWayBtn)
  end
end

function PetScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    self.lockTipLabel.text = self.data.staticData.NameZh
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
    local sdata = self.data and self.data.staticData
    if sdata then
      self.monstername.text = sdata.NameZh
    end
  end
  if self.isUnlock then
    self:Show(self.modelBottombg)
    self:Hide(self.BottomCt)
  else
    self:Show(self.BottomCt)
    self:Hide(self.modelBottombg)
  end
end

function PetScoreTip:Show3DModel()
  local data = self.data
  local monsterData = data and data.staticData
  if monsterData then
    UIModelUtil.Instance:ResetTexture(self.modeltexture)
    UIModelUtil.Instance:SetMonsterModelTexture(self.modeltexture, monsterData.id, nil, nil, function(obj)
      self.model = obj
      local showPos = monsterData.LoadShowPose
      if showPos and #showPos == 3 then
        self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
      end
      self.model:SetEulerAngleY(monsterData.LoadShowRotate or 0)
      local size = monsterData.LoadShowSize or 1
      self.model:SetScale(size)
    end)
  end
  return false
end

function PetScoreTip:UpdatePetSkill()
  local contextData = {}
  local data = self.data
  local sdata = self.data.staticData
  if data and sdata then
    local sdata = self.data.staticData
    local petData = Table_Pet[sdata.id]
    if petData then
      local profession = Game.Myself.data:GetCurOcc().profession
      local id = 1
      local idStr = string.format("Skill_%d", id)
      local skillTb = petData[idStr]
      local skillId = skillTb and skillTb[1] or nil
      while skillTb and skillId do
        local data = {}
        data[1] = nil
        data[2] = skillId
        contextData[#contextData + 1] = data
        id = id + 1
        idStr = string.format("Skill_%d", id)
        skillTb = petData[idStr]
        skillId = skillTb and skillTb[1] or nil
      end
    end
  end
  self.gridList:ResetDatas(contextData)
end

function PetScoreTip:UpdateAttriContext()
  self.attriCtl:ResetDatas()
  local transform = self.gridList.layoutCtrl.transform
  local bound = NGUIMath.CalculateRelativeWidgetBounds(transform, false)
  local pos = transform.localPosition
  local y = pos.y - bound.size.y - 50
  if bound.size.y == 0 then
    y = pos.y - bound.size.y
  end
  self.attriCtl.layoutCtrl.transform.localPosition = LuaGeometry.GetTempVector3(0, y)
  local contextDatas = {}
  local detailProp = self:GetItemDetail()
  if detailProp then
    table.insert(contextDatas, detailProp)
  end
  self.attriCtl:ResetDatas(contextDatas)
end

function PetScoreTip:GetItemUnlock()
  local data = self.data
  local sdata = self.data.staticData
  if not data or not sdata then
    return
  end
  local transform = self.gridList.layoutCtrl.transform
  local bound = NGUIMath.CalculateRelativeWidgetBounds(transform, false)
  local pos = transform.localPosition
  local y = pos.y - bound.size.y - 50
  if bound.size.y == 0 then
    y = pos.y - bound.size.y
  end
  self.attriCtl.layoutCtrl.transform.localPosition = LuaGeometry.GetTempVector3(0, y)
  if sdata.AdventureValue and 0 < sdata.AdventureValue then
    local temp = {}
    if not self.isUnlock then
      temp.label = string.format("[c][808080ff]%s%s{uiicon=Adventure_icon_05} %sx%s[-][/c]", AdventureDataProxy.getUnlockCondition(self.data, true), ZhString.FunctionDialogEvent_And, ZhString.AdventureRewardPanel_AdventureExp, self.data.staticData.AdventureValue)
      temp.tiplabel = "[c][808080ff]" .. ZhString.MonsterTip_LockReward .. "[-][/c]"
    else
      temp.label = string.format("%s%s{uiicon=Adventure_icon_05} %sx%s", AdventureDataProxy.getUnlockCondition(self.data, true), ZhString.FunctionDialogEvent_And, ZhString.AdventureRewardPanel_AdventureExp, self.data.staticData.AdventureValue)
      temp.tiplabel = ZhString.MonsterTip_LockReward
    end
    temp.hideline = true
    return temp
  end
end

function PetScoreTip:GetItemDetail()
  local temp = {}
  temp.label = {}
  temp.hideline = true
  temp.tiplabel = ZhString.MonsterTip_LockProperyReward
  temp.labelType = AdventureDataProxy.LabelType.Status
  local sdata = self.data.staticData
  if sdata.AdventureValue and sdata.AdventureValue > 0 then
    local singleLabel = {
      text = string.format("%s%s{uiicon=Adventure_icon_05} %sx%s", AdventureDataProxy.getUnlockCondition(self.data, true), ZhString.FunctionDialogEvent_And, ZhString.AdventureRewardPanel_AdventureExp, self.data.staticData.AdventureValue),
      unlock = self.isUnlock or false
    }
    table.insert(temp.label, singleLabel)
  end
  local sData = Table_Monster[self.data.staticId]
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data, true)
  local intoPackageRewardStr = AdventureDataProxy.Instance:getUnlockRewardStr(sData)
  local propertyUnlock = string.format(ZhString.ItemTip_CombineRewardTip, self.data:GetName())
  if intoPackageRewardStr and intoPackageRewardStr ~= "" then
    propertyUnlock = propertyUnlock .. ZhString.FunctionDialogEvent_And .. intoPackageRewardStr
    local singleLabel = {
      text = propertyUnlock,
      unlock = self.isUnlock or false
    }
    table.insert(temp.label, singleLabel)
  end
  return temp
end

function PetScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.gridList:ResetDatas()
  self:CloseGainWayTip()
  UIModelUtil.Instance:ResetTexture(self.modeltexture)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  PetScoreTip.super.OnExit(self)
end
