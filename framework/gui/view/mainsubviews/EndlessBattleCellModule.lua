local LoadPrefab = function(prefabName, parent)
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(prefabName))
  if not cellpfb then
    error("can not find pfb" .. tostring(prefabName))
    return
  end
  cellpfb.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionObj(cellpfb, 0, 0, 0)
  return cellpfb
end
EBFEventProgressTypeCell = class("EBFEventProgressTypeCell", BaseCell)

function EBFEventProgressTypeCell:ctor(prefabName, parent)
  local go = LoadPrefab(prefabName, parent)
  EBFEventProgressTypeCell.super.ctor(self, go)
end

function EBFEventProgressTypeCell:Init()
  self.simpleHumanScoreText = nil
  self.simpleVampireScoreText = nil
  self:InitData()
  self:FindObjs()
end

function EBFEventProgressTypeCell:InitData()
end

function EBFEventProgressTypeCell:FindObjs()
  self.humanIcon = self:FindComponent("Human", UISprite)
  self.vampireIcon = self:FindComponent("Vampire", UISprite)
  self.humanProgressLabel = self:FindComponent("HumanProgress", UILabel, self.humanIcon.gameObject)
  self.vampireProgressLabel = self:FindComponent("VampireProgress", UILabel, self.vampireIcon.gameObject)
end

function EBFEventProgressTypeCell:FindProgressBar()
  self.humanProgressBar = self:FindComponent("HumanProgressBar", UIProgressBar, self.humanIcon.gameObject)
  self.vampireProgressBar = self:FindComponent("VampireProgressBar", UIProgressBar, self.vampireIcon.gameObject)
end

function EBFEventProgressTypeCell:SetData(data)
  self:SetCampIcon(data)
  self:SetProgress(data)
  self:SetState(not data.isEnd)
  self:ShowScore(data)
end

function EBFEventProgressTypeCell:ShowScore(data)
  local staticData = data and data.staticData
  if not staticData then
    return
  end
  local showScore = staticData.ShowScore
  if showScore and showScore == 1 then
    self:Show(self.humanProgressLabel)
    self:Show(self.vampireProgressLabel)
  else
    self:Hide(self.humanProgressLabel)
    self:Hide(self.vampireProgressLabel)
  end
end

function EBFEventProgressTypeCell:SetCampIcon(data)
end

function EBFEventProgressTypeCell:SetProgress(data)
end

function EBFEventProgressTypeCell:SetState(state)
end

EBFProgressKillBossTypeCell = class("EBFProgressKillBossTypeCell", EBFEventProgressTypeCell)

function EBFProgressKillBossTypeCell:FindObjs()
  EBFProgressKillBossTypeCell.super.FindObjs(self)
  self:FindProgressBar()
end

function EBFProgressKillBossTypeCell:SetProgress(data)
  if data then
    local total = data.humanScore + data.vampireScore
    local humanRatio = 0 < total and data.humanScore / total or 0.5
    self.simpleHumanScoreText = string.format("%d%%", humanRatio * 100)
    self.humanProgressLabel.text = self.simpleHumanScoreText
    local vampireRatio = 0 < total and data.vampireScore / total or 0.5
    self.simpleVampireScoreText = string.format("%d%%", vampireRatio * 100)
    self.vampireProgressLabel.text = self.simpleVampireScoreText
    self.humanProgressBar.value = humanRatio
    self.vampireProgressBar.value = vampireRatio
  end
end

EBFProgressEscortTypeCell = class("EBFProgressEscortTypeCell", EBFEventProgressTypeCell)

function EBFProgressEscortTypeCell:InitData()
  self.cargoOriPosX, self.cargoOriPosY = 0, 0
end

function EBFProgressEscortTypeCell:FindObjs()
  EBFProgressEscortTypeCell.super.FindObjs(self)
  self.cargo = self:FindGO("Cargo")
  self.cargoOriPosX, self.cargoOriPosY = LuaGameObject.GetLocalPositionGO(self.cargo)
  self:FindProgressBar()
  self.humanProgressBar.value = 0.5
  self.vampireProgressBar.value = 0.5
  self.simpleHumanScoreText = "0%"
  self.simpleVampireScoreText = "0%"
  self.humanProgressLabel.text = self.simpleHumanScoreText
  self.vampireProgressLabel.text = self.simpleVampireScoreText
  local bg = self:FindComponent("Bg", UISprite, self.humanProgressBar.gameObject)
  self.cargoTotalDis = bg.width * 0.5
end

local positive_flag = "+"
local negative_flag = "-"

function EBFProgressEscortTypeCell:SetProgress(data)
  if data then
    local total = (data.humanScore + data.vampireScore) * 0.5
    if 0 == total then
    end
    local humanRatio = 0 < total and (total - data.humanScore) / total or 0
    if 0 < total then
      local human_lead = data.humanScore < data.vampireScore
      local human_flag = human_lead and positive_flag or negative_flag
      local vampire_flag = human_lead and negative_flag or positive_flag
      self.simpleHumanScoreText = string.format(human_flag .. "%.0f%%", math.abs(humanRatio * 100))
      self.simpleVampireScoreText = string.format(vampire_flag .. "%.0f%%", math.abs(humanRatio * 100))
      self.humanProgressLabel.text = self.simpleHumanScoreText
      self.vampireProgressLabel.text = self.simpleVampireScoreText
    end
    local cargoDis = humanRatio * self.cargoTotalDis
    LuaGameObject.SetLocalPositionGO(self.cargo, self.cargoOriPosX - cargoDis, self.cargoOriPosY, 0)
  end
end

local _PointColor_human = Color(0.5686274509803921, 0.6509803921568628, 1.0, 1)
local _PointColor_vampire = Color(0.9529411764705882, 0.403921568627451, 0.34509803921568627, 1)
local _PointColor_none = Color(0.41568627450980394, 0.4627450980392157, 0.5372549019607843, 1)
EBFProgressOccupyTypeCell = class("EBFProgressOccupyTypeCell", EBFEventProgressTypeCell)

function EBFProgressOccupyTypeCell:InitData()
  self.points = {}
end

function EBFProgressOccupyTypeCell:FindObjs()
  EBFProgressOccupyTypeCell.super.FindObjs(self)
  local pointGrid = self:FindGO("PointGrid")
  for i = 1, 5 do
    self.points[i] = self:FindComponent("Point" .. tostring(i), UISprite, pointGrid)
  end
end

function EBFProgressOccupyTypeCell:SetProgress(data)
  if data and data.staticData then
    local total = Game.AltarCnt and Game.AltarCnt[data.staticData.id]
    if not total then
      return
    end
    self.simpleHumanScoreText = string.format("%s/%s", data.humanScore, total)
    self.simpleVampireScoreText = string.format("%s/%s", data.vampireScore, total)
    self.humanProgressLabel.text = self.simpleHumanScoreText
    self.vampireProgressLabel.text = self.simpleVampireScoreText
    for i = 1, total do
      self.points[i].color = i <= data.humanScore and _PointColor_human or total - i < data.vampireScore and _PointColor_vampire or _PointColor_none
    end
  end
end

EBFProgressCoinTypeCell = class("EBFProgressCoinTypeCell", EBFEventProgressTypeCell)

function EBFProgressCoinTypeCell:FindObjs()
  EBFProgressCoinTypeCell.super.FindObjs(self)
  self:FindProgressBar()
end

function EBFProgressCoinTypeCell:SetProgress(data)
  if data then
    local total = data.staticData.Misc and data.staticData.Misc.win_num and data.staticData.Misc.win_num or 0
    self.simpleHumanScoreText = string.format("%s/%s", data.humanScore, total)
    self.simpleVampireScoreText = string.format("%s/%s", data.vampireScore, total)
    self.humanProgressLabel.text = self.simpleHumanScoreText
    self.vampireProgressLabel.text = self.simpleVampireScoreText
    self.humanProgressBar.value = data.humanScore / total * 0.5
    self.vampireProgressBar.value = data.vampireScore / total * 0.5
  end
end

EBFProgressKillMonsterTypeCell = class("EBFProgressKillMonsterTypeCell", EBFEventProgressTypeCell)

function EBFProgressKillMonsterTypeCell:FindObjs()
  EBFProgressKillMonsterTypeCell.super.FindObjs(self)
  self:FindProgressBar()
end

function EBFProgressKillMonsterTypeCell:SetProgress(data)
  if data then
    local total = data.staticData.Misc and data.staticData.Misc.win_num and data.staticData.Misc.win_num or 0
    self.simpleHumanScoreText = string.format("%s/%s", data.humanScore, total)
    self.simpleVampireScoreText = string.format("%s/%s", data.vampireScore, total)
    self.humanProgressLabel.text = self.simpleHumanScoreText
    self.vampireProgressLabel.text = self.simpleVampireScoreText
    self.humanProgressBar.value = data.humanScore / total * 0.5
    self.vampireProgressBar.value = data.vampireScore / total * 0.5
  end
end

EBFProgressStatueTypeCell = class("EBFProgressStatueTypeCell", EBFEventProgressTypeCell)

function EBFProgressStatueTypeCell:FindObjs()
  EBFProgressStatueTypeCell.super.FindObjs(self)
  self:FindProgressBar()
end

function EBFProgressStatueTypeCell:SetProgress(data)
  if data then
    local humRatio = EndlessBattleGameProxy.Instance:GetStatueValue(Camp_Human)
    local vampireRatio = EndlessBattleGameProxy.Instance:GetStatueValue(Camp_Vampire)
    humRatio = humRatio / 1000
    vampireRatio = vampireRatio / 1000
    self.simpleHumanScoreText = string.format(ZhString.Finance_Ratio, humRatio * 100)
    self.simpleVampireScoreText = string.format(ZhString.Finance_Ratio, vampireRatio * 100)
    self.humanProgressLabel.text = self.simpleHumanScoreText
    self.vampireProgressLabel.text = self.simpleVampireScoreText
    self.humanProgressBar.value = humRatio * 0.5
    self.vampireProgressBar.value = vampireRatio * 0.5
  end
end

MainViewEB_Statue = class("MainViewEB_Statue", BaseCell)

function MainViewEB_Statue:ctor(parent)
  local go = LoadPrefab("MainViewEndlessBattleEvent_StatueCell", parent)
  MainViewEB_Statue.super.ctor(self, go)
end

function MainViewEB_Statue:Init()
  autoImport("EndlessBattleStatueCell")
  self.statueGrid = self.gameObject:GetComponent(UIGrid)
  self.statueCtl = UIGridListCtrl.new(self.statueGrid, EndlessBattleStatueCell, "EndlessBattleStatueCell")
end

function MainViewEB_Statue:SetData()
  local data = EndlessBattleGameProxy.Instance:GetStatueData()
  self.statueCtl:ResetDatas(data)
end

function MainViewEB_Statue:Destroy()
  self.statueCtl:Destroy()
end
