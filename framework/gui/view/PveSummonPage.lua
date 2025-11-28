autoImport("PveMonsterCell")
autoImport("PveSkillCell")
PveSummonPage = class("PveSummonPage", SubView)

function PveSummonPage:Init()
  self:InitView()
end

function PveSummonPage:InitView()
  local monsterGrid = self:FindComponent("MonsterGrid", UIGrid)
  self.monsterCtl = UIGridListCtrl.new(monsterGrid, PveMonsterCell, "PveMonsterCell")
  self.monsterCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMonster, self)
  self.table = self:FindComponent("MonsterSkillTable", UITable)
  self.introductionDesc = self:FindComponent("IntroductionLab", UILabel, self.table.gameObject)
  local skillTable = self:FindComponent("SkillTable", UITable, self.table.gameObject)
  self.skillCtl = UIGridListCtrl.new(skillTable, PveSkillCell, "PveSkillCell")
end

function PveSummonPage:OnEnter()
  PveSummonPage.super.OnEnter(self)
  self:Reset()
end

function PveSummonPage:Reset()
  local previewData = self.container.previewData
  if not previewData or not next(previewData.Summon) then
    redlog("Table_PveMonsterPreview Summon 配置为空")
    return
  end
  self.summonData = previewData.Summon
  local summonMonsters = {}
  for k, v in pairs(self.summonData) do
    summonMonsters[#summonMonsters + 1] = k
  end
  self.monsterCtl:ResetDatas(summonMonsters)
  self:FirstClickMonster()
end

function PveSummonPage:SetChoose(id)
  local single = self.monsterCtl:GetCells()
  for i = 1, #single do
    single[i]:SetChoosen(id)
  end
end

function PveSummonPage:OnClickMonster(cellctl)
  if cellctl and cellctl.data then
    local table = self.summonData[cellctl.data]
    if table then
      self:SetChoose(cellctl.data)
      self.skillCtl:ResetDatas(table.skills or _EmptyTable, nil, true)
      local content = table.introduction and Table_PveMonsterIntroduction[table.introduction] and Table_PveMonsterIntroduction[table.introduction].Content or nil
      if content then
        self:Show(self.introductionDesc)
        self.introductionDesc.text = content
      else
        self:Hide(self.introductionDesc)
      end
      self.table:Reposition()
    end
  end
end

function PveSummonPage:ResetSkillPosition()
  self.skillCtl:Layout()
  self.table:Reposition()
end

function PveSummonPage:FirstClickMonster()
  local firstCell = self.monsterCtl:GetCells()[1]
  if firstCell then
    self:OnClickMonster(firstCell)
  end
end

function PveSummonPage:OnExit()
  TipsView.Me():HideCurrent()
  PveSummonPage.super.OnExit(self)
end
