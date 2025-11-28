autoImport("BaseCombineCell")
HeadWearRaidBatchCombineCell = class("HeadWearRaidBatchCombineCell", BaseCombineCell)
autoImport("HeadWearRaidMonsterInfoCombineCell")

function HeadWearRaidBatchCombineCell:Init()
  self:FindObjs()
  self:InitShow()
end

function HeadWearRaidBatchCombineCell:FindObjs()
  self.bossIcon = self:FindComponent("HeadIcon", UISprite)
  self.bossSymbol = self:FindComponent("Symbol", UISprite)
  self.bossName = self:FindComponent("BOSS_name", UILabel)
  self.batchNum = self:FindComponent("BatchNum", UILabel)
  self.grid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.monsterInfoCtrl = UIGridListCtrl.new(self.grid, HeadWearRaidMonsterInfoCombineCell, "HeadWearRaidMonsterInfoCombineCell")
end

function HeadWearRaidBatchCombineCell:InitShow()
end

function HeadWearRaidBatchCombineCell:SetData(data)
  self.data = data
  self:UpdateInfo()
end

function HeadWearRaidBatchCombineCell:UpdateInfo()
  local bossData = self.data[5]
  local bossBatch = bossData.round
  local staticData = Table_Monster[bossData.first]
  self.bossName.text = staticData.NameZh
  local tempStr = string.format(ZhString.HeadWearRaidMonsterInfo_BatchNum, bossBatch - 4, bossBatch)
  self.batchNum.text = tempStr
  if staticData and staticData.Icon then
    IconManager:SetFaceIcon(staticData.Icon, self.bossIcon)
    if staticData.Type == "Monster" then
      self:Hide(self.bossSymbol)
    else
      self:Show(self.bossSymbol)
      if staticData.Type == "MVP" then
        self.bossSymbol.spriteName = "ui_HP_1"
      elseif staticData.Type == "MINI" then
        self.bossSymbol.spriteName = "ui_HP_2"
      end
    end
  else
    redlog("怪物ID" .. bossData.first .. "在Table_Monster中不存在或没有Icon，请检查")
  end
  self.data[5] = nil
  self.monsterInfoCtrl:ResetDatas(self.data)
end
