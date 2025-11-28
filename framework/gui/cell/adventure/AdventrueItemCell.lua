autoImport("ItemCell")
AdventrueItemCell = class("AdventrueItemCell", BaseItemCell)

function AdventrueItemCell:Init()
  self.mvpMonster = self.trans:Find("mvpMonster"):GetComponent(UISprite)
  self.unlockClient = self.trans:Find("unlockClient"):GetComponent(UISprite)
  self.BagChooseSymbol = self.trans:Find("BagChooseSymbol").gameObject
  self.starIcon = self.trans:Find("starIcon"):GetComponent(UISprite)
  self.effectContainer = self.trans:Find("EffectContainer").gameObject
  self.packageStoreState = self.trans:Find("packageStoreState"):GetComponent(UISprite)
  self.canMakeDress = self.trans:Find("canMakeDress").gameObject
  self.objPhoto = self.trans:Find("sprPhoto").gameObject
  self.objPurikura = self.trans:Find("sprPurikura").gameObject
  self.itemObj = self:LoadPreferb("cell/AdventureSimpleItemCell", self.gameObject)
  self.itemObj.transform.localPosition = LuaGeometry.GetTempVector3()
  AdventrueItemCell.super.Init(self)
  self:GetBgSprite()
end

function AdventrueItemCell:setIsSelected(isSelected)
  if self.isSelected ~= isSelected then
    self.isSelected = isSelected
    if isSelected then
      self.BagChooseSymbol:SetActive(true)
    else
      self.BagChooseSymbol:SetActive(false)
    end
  end
end

function AdventrueItemCell:SetEvent(evtObj, event, hideSound)
  local hideType = {hideClickSound = true, hideClickEffect = true}
  self:AddClickEvent(evtObj, event, hideType)
end

local tempColor = LuaColor.White()
local redTipEvent = {}

function AdventrueItemCell:SetData(data)
  self.data = data
  local mvpActive = false
  self:AddOrRemoveGuideId(self.itemObj)
  if data and data.type == SceneManual_pb.EMANUALTYPE_MONSTER then
    if data.staticId == 10001 then
      self:AddOrRemoveGuideId(self.itemObj, 542)
    end
  elseif data and data.type == SceneManual_pb.EMANUALTYPE_CARD and data.staticId == 20001 then
    self:AddOrRemoveGuideId(self.itemObj, 543)
  end
  if data and data.type == SceneManual_pb.EMANUALTYPE_NPC then
    self.itemObj:SetActive(false)
    self:initHeadImage()
  else
    self:removeHeadImage()
    self.itemObj:SetActive(true)
    AdventrueItemCell.super.SetData(self, data)
  end
  self:SetActive(self.invalid, false)
  self.isUnlockShow = false
  if not data then
    self:setIsSelected(false)
    self.canMakeDress:SetActive(false)
    self.starIcon.gameObject:SetActive(false)
    self.packageStoreState.gameObject:SetActive(false)
    self.unlockClient.gameObject:SetActive(false)
    self.objPhoto:SetActive(false)
    self.objPurikura:SetActive(false)
    self.mvpMonster.gameObject:SetActive(mvpActive)
    return
  end
  self:setIsSelected(data.isSelected or false)
  self:setItemIsLock(data)
  self:setPackageStoreState()
  self:setFashionMakeState()
  if data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    self.unlockClient.spriteName = "com_icon_add2"
    self.isUnlockShow = true
  elseif data:canBeClick() then
    self.unlockClient.spriteName = "com_icon_add3"
    self.isUnlockShow = true
  end
  if data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    if data.type == SceneManual_pb.EMANUALTYPE_NPC then
      if self.targetCell then
        self.targetCell.frameSp.spriteName = "com_bg_head"
      end
    else
      self.bg.spriteName = "com_icon_bottom3"
    end
  elseif data.type == SceneManual_pb.EMANUALTYPE_NPC then
    if self.targetCell then
      self.targetCell.frameSp.spriteName = "com_icon_bottom6"
    end
  else
    self.bg.spriteName = "com_icon_bottom6"
  end
  if data.type == SceneManual_pb.EMANUALTYPE_MONSTER or data.type == SceneManual_pb.EMANUALTYPE_PET then
    if data.staticData.Icon and data.staticData.Icon ~= "" then
      self.icon.gameObject:SetActive(true)
      local sus = IconManager:SetFaceIcon(data.staticData.Icon, self.icon)
      if not sus then
        IconManager:SetFaceIcon("boli", self.icon)
      end
      if data.staticData.Type == "MVP" then
        local bossData = Table_Boss[self.data.staticId]
        mvpActive = true
        if bossData and bossData.Type == 3 then
          IconManager:SetMapIcon("ui_mvp_dead11_JM", self.mvpMonster)
        else
          IconManager:SetUIIcon("ui_HP_1", self.mvpMonster)
        end
      elseif data.staticData.Type == "MINI" then
        mvpActive = true
        IconManager:SetUIIcon("ui_HP_2", self.mvpMonster)
      end
      if data.staticData.IsStar and data.staticData.IsStar == 1 then
        self.starIcon.gameObject:SetActive(true)
        IconManager:SetUIIcon("icon_40", self.starIcon)
      else
        self.starIcon.gameObject:SetActive(false)
      end
      self.icon:MakePixelPerfect()
    else
      self.icon.gameObject:SetActive(false)
    end
  else
    self.starIcon.gameObject:SetActive(false)
    local type = data.staticData.Type
    if type and AdventureDataProxy.Instance:isCard(type) then
      if data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
      else
        self.cardItem:SetCardGrey(true)
      end
    elseif type and type == 1210 then
      self.bg.gameObject:SetActive(false)
      if data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
        self:SetTextureColor(self.frameItem, Color(1, 1, 1, 1), true)
      else
        self:SetTextureColor(self.frameItem, Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569), true)
      end
    elseif data.type == SceneManual_pb.EMANUALTYPE_COLLECTION then
      local atlas = RO.AtlasMap.GetAtlas("NewCom")
      if atlas and data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY then
        self.icon.atlas = atlas
        self.icon.spriteName = "Adventure_icon_03"
        self.icon:MakePixelPerfect()
      end
    end
  end
  local RedTipCell = self:FindGO("RedTipCell")
  if self.data:isCollectionGroup() then
    if self.data:isTotalComplete() then
      self.bg.spriteName = "com_icon_bottom3"
      if self.data:isRewardAvailable() then
        redTipEvent.ctrl = self
        redTipEvent.ret = true
        self:PassEvent(AdventureNormalList.UpdateCellRedTip, redTipEvent)
        if RedTipCell then
          RedTipCell:SetActive(true)
        end
      else
        redTipEvent.ctrl = self
        redTipEvent.ret = false
        self:PassEvent(AdventureNormalList.UpdateCellRedTip, redTipEvent)
        if RedTipCell then
          RedTipCell:SetActive(false)
        end
      end
    elseif self.data:isTotalUnComplete() then
      local atlas = RO.AtlasMap.GetAtlas("NewCom")
      self.icon.atlas = atlas
      self.icon.spriteName = "Adventure_icon_03"
      self.icon:MakePixelPerfect()
      self.bg.spriteName = "com_icon_bottom6"
      redTipEvent.ctrl = self
      redTipEvent.ret = false
      self:PassEvent(AdventureNormalList.UpdateCellRedTip, redTipEvent)
      if RedTipCell then
        RedTipCell:SetActive(false)
      end
    else
      LuaColor.Better_Set(tempColor, 0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
      self.icon.color = tempColor
      self.unlockClient.spriteName = "Adventure_icon_03"
      self.isUnlockShow = true
      redTipEvent.ctrl = self
      redTipEvent.ret = false
      self:PassEvent(AdventureNormalList.UpdateCellRedTip, redTipEvent)
      if RedTipCell then
        RedTipCell:SetActive(false)
      end
    end
  else
    redTipEvent.ctrl = self
    redTipEvent.ret = false
    self:PassEvent(AdventureNormalList.UpdateCellRedTip, redTipEvent)
    if RedTipCell then
      RedTipCell:SetActive(false)
    end
  end
  self.unlockClient:MakePixelPerfect()
  self.unlockClient.gameObject:SetActive(self.isUnlockShow == true)
  if data.type == SceneManual_pb.EMANUALTYPE_MOUNT and data:IsPetMount() then
    IconManager:SetPetMountIcon(data, self.icon)
  end
  self.mvpMonster.gameObject:SetActive(mvpActive)
  self:setPhotoState()
  self:setPurikuraState()
end

function AdventrueItemCell:setItemIsLock(data)
  if data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY and data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    LuaColor.Better_Set(tempColor, 1, 1, 1, 1)
    self.mvpMonster.color = tempColor
    self.icon.color = tempColor
    self.starIcon.color = tempColor
    if self.targetCell then
      self.targetCell:SetActive(true, nil, true)
    end
  else
    LuaColor.Better_Set(tempColor, 0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    if self.targetCell then
      self.targetCell:SetActive(false, nil, true)
    end
    self.mvpMonster.color = tempColor
    self.icon.color = tempColor
    self.starIcon.color = tempColor
  end
end

function AdventrueItemCell:removeHeadImage()
  if self.targetCell then
    GameObject.Destroy(self.targetCell.gameObject)
    self.targetCell = nil
  end
end

function AdventrueItemCell:setFashionMakeState()
  if self.data.type ~= SceneManual_pb.EMANUALTYPE_FASHION and self.data.type ~= SceneManual_pb.EMANUALTYPE_FURNITURE then
    self.canMakeDress:SetActive(false)
    return
  end
  local islock = not self.data.store and self.data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY
  local canMake = false
  if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
    canMake = self.data.staticData and BagProxy.Instance:CheckItemCanMakeByComposeID(self.data.staticData.ComposeID, BagProxy.MaterialCheckBag_Type.Furniture)
  else
    canMake = AdventureDataProxy.Instance:CheckFashionCanMake(self.data.staticId)
  end
  if canMake and islock then
    self.canMakeDress:SetActive(true)
  else
    self.canMakeDress:SetActive(false)
  end
end

function AdventrueItemCell:setPackageStoreState()
  if self.data.type ~= SceneManual_pb.EMANUALTYPE_CARD and self.data.type ~= SceneManual_pb.EMANUALTYPE_FASHION and self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY and self.data.type ~= SceneManual_pb.EMANUALTYPE_EQUIP and self.data.type ~= SceneManual_pb.EMANUALTYPE_MOUNT then
    self.packageStoreState.gameObject:SetActive(false)
    return
  end
  if self.data and self.data.store then
    self.packageStoreState.gameObject:SetActive(true)
    self.packageStoreState.spriteName = "Adventure_icon_02"
  elseif self.data and AdventureDataProxy.Instance:checkFashionCanStore(self.data) then
    self.packageStoreState.gameObject:SetActive(true)
    self.packageStoreState.spriteName = "Adventure_icon_01"
  else
    self.packageStoreState.gameObject:SetActive(false)
  end
end

function AdventrueItemCell:setPhotoState()
  if (self.data.attrUnlock and not self.isUnlockShow) == true then
    self.objPhoto:SetActive(true)
    local MonsterNameString = PetAdventureProxy.Instance:GetIllustratedRewardNameData()
    if MonsterNameString ~= nil and MonsterNameString == self.data.staticData.NameZh then
      self:LoadSpecialEffects()
      self.tiemtick = TimeTickManager.Me():CreateTick(3000, 1000, self.CloseSpecialEffect, self, 1)
      PetAdventureProxy.Instance:SetIllustratedRewardNameData(nil)
    end
  else
    self.objPhoto:SetActive(false)
  end
end

function AdventrueItemCell:LoadSpecialEffects()
  local parent = self.objPhoto.transform
  local effectPath = ResourcePathHelper.EffectUI("Photoready")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
end

function AdventrueItemCell:CloseSpecialEffect()
  self.effectlocal = self:FindGO("Photoready")
  if self.effectlocal then
    self.effectlocal:SetActive(false)
  end
  if self.tiemtick then
    TimeTickManager.Me():ClearTick(self, 1)
  end
end

function AdventrueItemCell:setPurikuraState()
  local havePurikura = self.data.staticData.Purikura ~= nil and self.data.staticData.Purikura ~= ""
  local havePurikuraBG = self.data.staticData.PurikuraBG ~= nil and self.data.staticData.PurikuraBG ~= ""
  self.objPurikura:SetActive((havePurikura and havePurikuraBG and self.data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK and not self.isUnlockShow) == true)
end

function AdventrueItemCell:UpdateEquipInfo(data)
  if not data.savedItemDatas then
    return
  end
  local realEquipInfo
  for _k, v in pairs(data.savedItemDatas) do
    if v.staticData.id == self.data.staticId then
      realEquipInfo = v.equipInfo
      break
    end
  end
  AdventrueItemCell.super.UpdateEquipInfo(self, data, realEquipInfo)
end

function AdventrueItemCell:initHeadImage()
  if not self.targetCell then
    self.targetCell = HeadIconCell.new()
    self.targetCell:CreateSelf(self.gameObject)
    self.targetCell:SetScale(0.65)
    self.targetCell:SetMinDepth(3)
  end
  local npcdata = self.data.staticData
  local data = ReusableTable.CreateTable()
  if npcdata.Icon == "" then
    data.bodyID = npcdata.Body or 0
    data.hairID = npcdata.Hair or 0
    data.haircolor = npcdata.HeadDefaultColor or 0
    data.gender = npcdata.Gender or -1
    data.eyeID = npcdata.Eye or 0
    data.headID = npcdata.Head or 0
    self.targetCell:SetData(data)
  else
    self.targetCell:SetSimpleIcon(npcdata.Icon)
  end
  ReusableTable.DestroyTable(data)
end

function AdventrueItemCell:PlayUnlockEffect()
  self:PlayUIEffect(EffectMap.UI.Activation, self.effectContainer, true)
end

function AdventrueItemCell:GetCD()
  local data, cdTime = self.data
  if data and data.type == SceneManual_pb.EMANUALTYPE_TOY then
    cdTime = data:GetCdTimeOfAnySavedItem()
  end
  return cdTime or 0
end

function AdventrueItemCell:GetMaxCD()
  local data = self.data
  if data and data.type == SceneManual_pb.EMANUALTYPE_TOY then
    local item = data.savedItemDatas[1]
    if item then
      return item:GetCdConfigTime()
    end
  end
  return 0
end

function AdventrueItemCell:RefreshCD(f)
  local data, cdTime = self.data, 1
  if data and data.type == SceneManual_pb.EMANUALTYPE_TOY then
    self.coldDown.fillAmount = f
    cdTime = data:GetCdTimeOfAnySavedItem()
  end
  if cdTime <= 0 then
    return true
  end
end

function AdventrueItemCell:SetActiveSymbol(active)
end

function AdventrueItemCell:SetQuestIcon(itemType)
end

function AdventrueItemCell:SetShopCorner(itemType)
end

function AdventrueItemCell:SetPetFlag(itemType)
end

function AdventrueItemCell:SetUseItemInvalid(data)
end

function AdventrueItemCell:SetInvalid(b)
end

function AdventrueItemCell:SetLimitTimeCorner(data)
end

function AdventrueItemCell:UpdateNumLabel(scount, x, y, z)
end

function AdventrueItemCell:SetItemQualityBG(quality)
end
