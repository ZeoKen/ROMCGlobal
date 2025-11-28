autoImport("BaseItemCell")
autoImport("PortraitFrameCell")
BagItemCell = class("BagItemCell", BaseItemCell)
BagItemEmptyType = {
  Empty = "Empty",
  Unlock = "Unlock",
  Grey = "Grey"
}

function BagItemCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  BagItemCell.super.Init(self)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.grey = self:FindGO("Grey")
  self.unlock = self:FindGO("Unlock")
  self.emptyTip = self:FindGO("EmptyTip")
  self.petAdvDot = self:FindGO("PetAdvDot")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.spMask = self:FindComponent("Mask", UISprite)
  self.gender = self:FindComponent("Gender", UISprite)
  self.get = self:FindGO("Get")
  self.checkMark = self:FindGO("CheckMark")
  self:AddCellDoubleClickEvt()
end

function BagItemCell:SetData(data)
  if self:CheckAndUpdateUnlock(data) then
    self:_UpdateData(nil)
    self.empty:SetActive(false)
    self.data = data
  else
    self:_UpdateData(data)
  end
  self:UpdateEmptyTip(data)
  self:UpdateGrey(data)
  self:UpdateChoose()
  self:CheckPetAdventureTip()
  self:UpdateEquipUpgradeTip()
  self:UpdateFavoriteTip(data)
  self:HideMask()
  self:UpdateGuideTarget()
  self:UpdateGetFlag()
  self:UpdateCheckMark()
end

function BagItemCell:UpdateGetFlag()
  if self.get then
    self.get:SetActive(self.data and self.data.get == true or false)
  end
end

function BagItemCell:UpdateCheckMark()
  if self.checkMark then
    self.checkMark:SetActive(self.data and self.data.isMark == true or false)
  end
end

function BagItemCell:_UpdateData(data)
  BagItemCell.super.SetData(self, data)
  self:UpdateMyselfInfo()
  local id = type(data) == "table" and data.id
  self:SetIconGrey(type(id) == "string" and id:find("Adventure"))
end

function BagItemCell:CheckAndUpdateUnlock(data)
  if not self.unlock or Game.GameObjectUtil:ObjectIsNULL(self.unlock) then
    return
  end
  local isUnlock = type(data) == "table" and data.id == BagItemEmptyType.Unlock
  self.unlock:SetActive(isUnlock)
  return isUnlock
end

function BagItemCell:UpdateEmptyTip(data)
  if self.emptyTip == nil then
    return
  end
  if data == BagItemEmptyType.Empty then
    if self.empty then
      self.empty:SetActive(data ~= BagItemEmptyType.Empty)
    end
    self.emptyTip:SetActive(true)
  else
    self.emptyTip:SetActive(false)
  end
end

function BagItemCell:UpdateGrey(data)
  if self.grey == nil then
    return
  end
  self.grey:SetActive(data == BagItemEmptyType.Grey)
  self:UpdateChoose()
  self:CheckRedTip()
  self:UpdateEquipUpgradeTip()
  self:UpdateFavoriteTip(data)
  self:UpdateGender()
  self:HideMask()
end

function BagItemCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function BagItemCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
    else
      self.chooseSymbol:SetActive(false)
    end
  end
end

local petItemId = 5682

function BagItemCell:CheckPetAdventureTip()
  if self.petAdvDot == nil then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == petItemId then
    local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_PET_ADVENTURE)
    return isInRed
  else
    if d and d.CanIntervalUse and d:CanIntervalUse() then
      return true
    end
    return false
  end
end

function BagItemCell:UpdateFavoriteTip(data)
  if not self.favoriteTip then
    return
  end
  self.favoriteTip:SetActive(false)
  if not BagItemCell.CheckData(data) then
    return
  end
  if type(data) == "table" and data.id == BagItemEmptyType.Unlock then
    return
  end
  if BagProxy.Instance:CheckIsFavorite(data) then
    local favoriteValid = not data:IsNew() or data:IsCard()
    if favoriteValid then
      self.favoriteTip:SetActive(true)
    end
  end
end

function BagItemCell:SetFavoriteTipActive(isActive)
  if not self.favoriteTip then
    return
  end
  isActive = isActive and true or false
  self.favoriteTip:SetActive(isActive)
end

function BagItemCell:GetFavoriteTipActive()
  if not self.favoriteTip then
    return nil
  end
  return self.favoriteTip.activeSelf
end

function BagItemCell:NegateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self:SetFavoriteTipActive(not self:GetFavoriteTipActive())
end

local questManualItemId = 5400

function BagItemCell:CheckQuestManualTip()
  if self.petAdvDot == nil then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == questManualItemId then
    local isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_QUESTPUZZLE_CANLOCK)
    if isInRed then
      return true
    end
    if not FunctionUnLockFunc.Me():CheckCanOpen(6300) then
      return false
    end
    isInRed = RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_FUNCTION_OPENING)
    return isInRed
  end
  return false
end

local signIn21ItemId = 6732

function BagItemCell:CheckSignIn21Tip()
  do return end
  if not self.petAdvDot then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == signIn21ItemId then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_NOVICE_TARGET)
  end
  return false
end

local manorBookId = 6836

function BagItemCell:CheckManorBookTip()
  if not self.petAdvDot then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == manorBookId then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_MANOR_PARTNER_STORY)
  end
  return false
end

local evidenceBook = 5683

function BagItemCell:CheckEvidenceBookTip()
  if not self.petAdvDot then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == evidenceBook then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_SECRET_ENLIGHT)
  end
  return false
end

local noviceTechTree = 6950

function BagItemCell:CheckNoviceTechTreeTip()
  if not self.petAdvDot then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == noviceTechTree then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_NEWBIETECHTREE_LEVEL_AWARD)
  end
  return false
end

function BagItemCell:CheckRedTip()
  if not self.petAdvDot then
    return
  end
  if self:CheckSignIn21Tip() or self:CheckPetAdventureTip() or self:CheckManorBookTip() or self:CheckEvidenceBookTip() or self:CheckNoviceTechTreeTip() then
    self.petAdvDot:SetActive(true)
  else
    self.petAdvDot:SetActive(false)
  end
end

function BagItemCell:UpdateGender()
  if not self.gender then
    return
  end
  self.gender.gameObject:SetActive(self.isShowGender == true and self.data ~= nil and self.data.homeOwnerId ~= nil)
  if not self.gender.gameObject.activeSelf then
    return
  end
  local lData = FunctionLogin.Me():getLoginData()
  if lData.accid == self.data.homeOwnerId then
    self:SetGender(ProfessionProxy.Instance:GetCurSex() == 1)
  else
    local partnerData = WeddingProxy.Instance:GetPartnerData()
    if partnerData and partnerData.charid == self.data.homeOwnerId and partnerData.gender then
      self:SetGender(partnerData.gender == 1)
    end
  end
end

function BagItemCell:SetShowGender(isShow)
  isShow = isShow and true or false
  self.isShowGender = isShow
  self:UpdateGender()
end

function BagItemCell:SetGender(isMale)
  if not self.gender then
    return
  end
  self.gender.spriteName = isMale and "friend_icon_man" or "friend_icon_woman"
end

function BagItemCell.CheckData(data)
  if data == nil then
    return false
  end
  if data == BagItemEmptyType.Empty then
    return false
  end
  if data == BagItemEmptyType.Grey then
    return false
  end
  return true
end

function BagItemCell:SwitchDragScrollView(scrollView)
  local dragScrollView = self.gameObject:GetComponent(UIDragScrollView)
  if dragScrollView and scrollView then
    dragScrollView.scrollView = scrollView
  end
end

function BagItemCell:ActiveGuide(b)
  self.activeGuide = b
  if b then
    self:UpdateGuideTarget()
  end
end

local GuideTargetMap = {
  [5501] = ClientGuide.TargetType.packageview_astrolabeitem,
  [5670] = ClientGuide.TargetType.packageview_gemitem,
  [42691] = ClientGuide.TargetType.packageview_commonequip,
  [42692] = ClientGuide.TargetType.packageview_shadowequip
}

function BagItemCell:UpdateGuideTarget()
  if not self.activeGuide then
    return
  end
  if self.registedTarget and self.registedTarget[self.gameObject] then
    self:UnRegisterGuideTarget(self.registedTarget[self.gameObject])
    self.registedTarget[self.gameObject] = nil
  end
  if type(self.data) == "table" then
    local sId = self.data.staticData and self.data.staticData.id
    if sId and GuideTargetMap[sId] then
      self:RegisterGuideTarget(GuideTargetMap[sId], self.gameObject)
      if not self.registedTarget then
        self.registedTarget = {}
      end
      self.registedTarget[self.gameObject] = GuideTargetMap[sId]
    end
  end
end

function BagItemCell:SetCheckMarkActive(Active)
  if self.checkMark then
    self.checkMark:SetActive(Active)
  end
end

function BagItemCell:GetCheckMarkActive()
  if self.checkMark then
    return self.checkMark.activeSelf
  end
  return false
end
