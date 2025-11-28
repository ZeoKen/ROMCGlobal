autoImport("PvePhaseCell")
PveSkillPage = class("PveSkillPage", SubView)

function PveSkillPage:Init(parent)
  self:InitView()
end

function PveSkillPage:InitView()
  self.table = self:FindComponent("SkillPhaseTable", UITable)
  self.skillPhaseCtl = UIGridListCtrl.new(self.table, PvePhaseCell, "PvePhaseCell")
end

function PveSkillPage:OnEnter()
  PveSkillPage.super.OnEnter(self)
  self:Reset()
end

function PveSkillPage:Reset()
  local previewData = self.container.previewData
  if not previewData or not next(previewData.SkillContent) then
    redlog("Table_PveMonsterPreview SkillContent 配置为空")
    return
  end
  self.skillPhaseCtl:ResetDatas(previewData.SkillContent)
end

function PveSkillPage:OnExit()
  TipsView.Me():HideCurrent()
  PveSkillPage.super.OnExit(self)
end
