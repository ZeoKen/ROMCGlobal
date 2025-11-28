autoImport("BaseItemNewCell")
BagItemNewCell = class("BagItemNewCell", BaseItemNewCell)

function BagItemNewCell:Init()
  local itemCell = self:FindGO("Common_ItemNewCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemNewCell", self.gameObject)
    go.name = "Common_ItemNewCell"
  end
  BagItemNewCell.super.Init(self)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.grey = self:FindGO("Grey")
  self.unlock = self:FindGO("Unlock")
  self.emptyTip = self:FindGO("EmptyTip")
  self.petAdvDot = self:FindGO("PetAdvDot")
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.spMask = self:FindComponent("Mask", UISprite)
  self.gender = self:FindComponent("Gender", UISprite)
  self.cancelTip = self:FindGO("CancelTip")
  self:AddCellDoubleClickEvt()
end

function BagItemNewCell:SetData(data)
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
  self:CheckRedTip()
  self:CheckPetAdventureTip()
  self:UpdateEquipUpgradeTip()
  self:UpdateFavoriteTip(data)
  self:HideMask()
  self:UpdateCancelTip()
end

function BagItemNewCell:_UpdateData(data)
  BagItemNewCell.super.SetData(self, data)
  self:UpdateMyselfInfo()
  local id = type(data) == "table" and data.id
  self:SetIconGrey(type(id) == "string" and id:find("Adventure"))
end

function BagItemNewCell:CheckAndUpdateUnlock(data)
  if self.unlock == nil then
    return
  end
  local isUnlock = type(data) == "table" and data.id == BagItemEmptyType.Unlock
  self.unlock:SetActive(isUnlock)
  return isUnlock
end

function BagItemNewCell:UpdateEmptyTip(data)
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

function BagItemNewCell:UpdateGrey(data)
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

function BagItemNewCell:SetChooseId(chooseId)
  self.chooseId = chooseId
  self:UpdateChoose()
end

function BagItemNewCell:UpdateChoose()
  if self.chooseSymbol then
    if self.chooseId and self.data and self.data.id == self.chooseId then
      self.chooseSymbol:SetActive(true)
    else
      self.chooseSymbol:SetActive(false)
    end
  end
end

local petItemId = 5682

function BagItemNewCell:CheckPetAdventureTip()
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

function BagItemNewCell:UpdateFavoriteTip(data)
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
    self.favoriteTip:SetActive(true)
  end
end

function BagItemNewCell:SetFavoriteTipActive(isActive)
  if not self.favoriteTip then
    return
  end
  isActive = isActive and true or false
  self.favoriteTip:SetActive(isActive)
end

function BagItemNewCell:GetFavoriteTipActive()
  if not self.favoriteTip then
    return nil
  end
  return self.favoriteTip.activeSelf
end

function BagItemNewCell:NegateFavoriteTip()
  if not self.favoriteTip then
    return
  end
  self:SetFavoriteTipActive(not self:GetFavoriteTipActive())
end

local questManualItemId = 5400

function BagItemNewCell:CheckQuestManualTip()
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

function BagItemNewCell:CheckSignIn21Tip()
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

function BagItemNewCell:CheckManorBookTip()
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

function BagItemNewCell:CheckEvidenceBookTip()
  if not self.petAdvDot then
    return
  end
  local d = self.data
  if d and d.staticData and d.staticData.id == evidenceBook then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_SECRET_ENLIGHT)
  end
  return false
end

function BagItemNewCell:CheckRedTip()
  if not self.petAdvDot then
    return
  end
  if self:CheckSignIn21Tip() or self:CheckPetAdventureTip() or self:CheckManorBookTip() or self:CheckEvidenceBookTip() then
    self.petAdvDot:SetActive(true)
  else
    self.petAdvDot:SetActive(false)
  end
end

function BagItemNewCell:UpdateGender()
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

function BagItemNewCell:SetShowGender(isShow)
  isShow = isShow and true or false
  self.isShowGender = isShow
  self:UpdateGender()
end

function BagItemNewCell:SetGender(isMale)
  if not self.gender then
    return
  end
  self.gender.spriteName = isMale and "friend_icon_man" or "friend_icon_woman"
end

function BagItemNewCell:SetCancelTip(bool)
  self.showCancelTip = bool
  self:UpdateCancelTip()
end

function BagItemNewCell:UpdateCancelTip()
  if not self.cancelTip then
    return
  end
  self.cancelTip:SetActive(self.showCancelTip == true and self.data ~= nil)
end
