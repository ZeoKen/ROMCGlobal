PetDropItemCell = class("PetDropItemCell", ItemCell)

function PetDropItemCell:Init()
  local itemCell = self:FindGO("Common_ItemCell")
  if not itemCell then
    local go = self:LoadPreferb("cell/ItemCell", self.gameObject)
    go.name = "Common_ItemCell"
  end
  PetDropItemCell.super.Init(self)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.rare = self:FindGO("rare")
  self.conditionLab = self:FindGO("condition")
  self:AddCellClickEvent()
end

function PetDropItemCell:SetData(data)
  self.data = data
  PetDropItemCell.super.SetData(self, data)
  if data then
    self.rare:SetActive(data.Rare)
    if data.Locked then
      self:SetTextureGrey(self.gameObject)
      self:Hide(self.numLab)
      self.conditionLab:SetActive(true)
    else
      self:SetTextureWhite(self.gameObject)
      self:Show(self.numLab)
      self.conditionLab:SetActive(false)
    end
    local chooseData = PetAdventureProxy.Instance:GetChooseQuestData()
    if not data.Locked then
      if data.rewardCount <= 1 then
        if 0 == PetAdventureProxy.Instance:GetMatchNum() then
          self:UpdateNumLabel("")
        elseif not data.Rare and chooseData.status == PetAdventureProxy.QuestPhase.MATCH then
          self:UpdateNumLabel("0-?")
        else
          local t = data.rewardCount == 1 and "" or data.rewardCount
          self:UpdateNumLabel(t)
        end
      else
        self:UpdateNumLabel(data.rewardCount)
      end
    end
    self.gameObject:SetActive(true)
  else
    self.gameObject:SetActive(false)
  end
end
