local _TypeFlagConfig = {
  [PveDropItemData.Type.E_First] = {
    spriteName = "Novicecopy_bg_10",
    text = ZhString.Pve_FirstCompleteReward
  },
  [PveDropItemData.Type.E_Pve] = {
    spriteName = "Novicecopy_bg_10",
    text = ZhString.Pve_WeekFirstCompleteReward
  },
  [PveDropItemData.Type.E_Probability] = {
    spriteName = "Novicecopy_bg_11",
    text = ZhString.Pve_ProbabilisticReward
  },
  [PveDropItemData.Type.E_HeadWear] = {
    spriteName = "Novicecopy_bg_11",
    text = ZhString.Pve_HearWearReward
  },
  [PveDropItemData.Type.E_Pve_Sweep] = {
    spriteName = "Novicecopy_bg_11",
    text = ZhString.Pve_SweepReward
  },
  [PveDropItemData.Type.E_Pve_ThreeStars] = {
    spriteName = "Novicecopy_bg_10",
    text = ZhString.Pve_ThreeStarsReward
  },
  [PveDropItemData.Type.E_WeekFirstPass] = {
    spriteName = "Novicecopy_bg_10",
    text = ZhString.Pve_WeekFirstCompleteReward
  }
}
PveDropItemCell = class("PveDropItemCell", ItemCell)
PveDropItemCell.Empty = "DropEmpty"

function PveDropItemCell:Init()
  self.dropEmptyBg = self:FindGO("EmptyBg")
  self.itemContainer = self:FindComponent("ItemContainer", UIWidget)
  self.itemobj = self:LoadPreferb("cell/ItemCell", self.itemContainer.gameObject)
  self.itemobj.transform.localPosition = LuaGeometry.GetTempVector3()
  PveDropItemCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function PveDropItemCell:FindObjs()
  self.flagSp = self:FindComponent("FlagSp", UISprite)
  self.flagName = self:FindComponent("Label", UILabel, self.flagSp.gameObject)
  self.mask = self:FindGO("Mask")
  self.extra = self:FindGO("Extra")
  self.received = self:FindGO("Received")
end

local _checkId = {
  [300] = 1,
  [400] = 1
}

function PveDropItemCell:SetData(data)
  local isEmpty = data == PveDropItemCell.Empty
  self.itemobj:SetActive(not isEmpty)
  self.dropEmptyBg:SetActive(isEmpty)
  if isEmpty then
    self:Hide(self.mask)
    self:Hide(self.flagSp)
    self:Hide(self.extra)
    self:SetReceived(false)
    self.data = data
    return
  end
  PveDropItemCell.super.SetData(self, data)
  local staticId = self.data.staticData.id
  if _checkId[staticId] then
    local union_num = ItemUtil.CalcUnionNum(data.num)
    self:UpdateNumLabel(union_num)
  elseif data.GetNumDesc then
    self:UpdateNumLabel(data:GetNumDesc())
  end
  self:SetFlag()
  self.mask:SetActive(self.data.dropType == PveDropItemData.Type.E_Pve_Card and nil ~= data.IsPickup and not data:IsPickup())
  self:SetSpecialBg()
  self:SetReceived(data.received)
end

function PveDropItemCell:SetSpecialBg()
  local name = self.data and self.data.specialBgName
  if StringUtil.IsEmpty(name) then
    return
  end
  local bg = self:GetBgSprite()
  if not bg then
    return
  end
  if bg.spriteName == name then
    return
  end
  local atlas = RO.AtlasMap.GetAtlas("NewUI10")
  bg.atlas = atlas
  bg.spriteName = name
  bg:MakePixelPerfect()
end

function PveDropItemCell:SetFlag()
  local type = self.data.dropType
  if type == PveDropItemData.Type.E_Extra then
    self:Show(self.extra)
    self:Hide(self.flagSp)
    return
  end
  self:Hide(self.extra)
  if nil ~= _TypeFlagConfig[type] then
    self:Show(self.flagSp)
    self.flagSp.spriteName = _TypeFlagConfig[type].spriteName
    self.flagName.text = _TypeFlagConfig[type].text
  else
    self:Hide(self.flagSp)
  end
end

function PveDropItemCell:SetReturnExtra(multiply)
  if not self.flagSp.gameObject.activeSelf then
    self:Show(self.flagSp)
    self.flagSp.spriteName = "Novicecopy_bg_10"
    self.flagName.text = ZhString.PveView_ReturnExtra
  end
  local num = self.data.num * multiply
  local union_num = ItemUtil.CalcUnionNum(num)
  self:UpdateNumLabel(union_num)
end

function PveDropItemCell:SetReceived(received)
  self.received:SetActive(received or false)
  self.itemContainer.alpha = received and 0.5 or 1
end
