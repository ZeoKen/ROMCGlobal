local BaseCell = autoImport("BaseCell")
RaidPuzzleChooseBuffItemCell = class("RaidPuzzleChooseBuffItemCell", BaseCell)
local BG_TX = "activity_bg"

function RaidPuzzleChooseBuffItemCell:Init()
  self:FindObjs()
  self:AddEvents()
  self:InitViwe()
end

local tempVector3 = LuaVector3.Zero()

function RaidPuzzleChooseBuffItemCell:FindObjs()
  self.selectbg = self:FindGO("selectbg")
  self.gainLable = self:FindComponent("gainLable", UILabel)
  self.gainIcon = self:FindComponent("gainIcon", UISprite)
  self.buffName = self:FindComponent("buffName", UILabel)
  self.iconBg = self:FindComponent("iconBg", UITexture)
  self.transform = self.gameObject.transform
end

function RaidPuzzleChooseBuffItemCell:AddEvents()
  self:AddCellClickEvent()
end

function RaidPuzzleChooseBuffItemCell:InitViwe()
  PictureManager.Instance:SetHitPolly(BG_TX, self.iconBg)
  self:PlayUIEffect(EffectMap.UI.Eff_RaidPuzzleChooseBuffItemCell, self.selectbg)
  self:HideSelectBg()
end

function RaidPuzzleChooseBuffItemCell:SetData(_buffId)
  self.buffId = _buffId
  if self.buffId then
    local statedata = Table_RaidPuzzleBuff[self.buffId]
    if statedata then
      if statedata.BuffName and statedata.BuffName ~= "" then
        self.buffName.text = OverSea.LangManager.Instance():GetLangByKey(statedata.BuffName)
      else
        self:Hide(self.buffName.gameObject)
      end
      self.gainLable.text = OverSea.LangManager.Instance():GetLangByKey(statedata.BuffDesc)
      IconManager:SetSkillIcon(statedata.Icon, self.gainIcon)
    else
      redlog("Table_RaidPuzzleBuff  have no id :", self.buffId)
    end
  end
end

function RaidPuzzleChooseBuffItemCell:SelectSelf()
  self:Show(self.selectbg)
  LuaVector3.Better_Set(tempVector3, 1, 1, 1)
  self.transform.localScale = tempVector3
end

function RaidPuzzleChooseBuffItemCell:HideSelectBg()
  self:Hide(self.selectbg)
  LuaVector3.Better_Set(tempVector3, 0.9, 0.9, 0.9)
  self.transform.localScale = tempVector3
end

function RaidPuzzleChooseBuffItemCell:OnCellDestroy()
  PictureManager.Instance:UnLoadHitPolly(BG_TX, self.iconBg)
  RaidPuzzleChooseBuffItemCell.super.OnCellDestroy(self)
end

return RaidPuzzleChooseBuffItemCell
