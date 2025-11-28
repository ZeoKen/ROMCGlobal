autoImport("MaterialChooseBord1")
SafeRefineChooseBord = class("SafeRefineChooseBord", MaterialChooseBord1)
SafeRefineChooseBord.PrefabPath = "part/SafeRefineChooseBord"

function SafeRefineChooseBord:InitBord()
  SafeRefineChooseBord.super.InitBord(self)
  self:InitAutoFillButton()
end

function SafeRefineChooseBord:InitAutoFillButton(evt)
  if not self.autoFillButton then
    self.autoFillButton = self:FindGO("AutoFillButton")
    self:AddClickEvent(self.autoFillButton, function()
      self:ClickAutoFillButton()
    end)
  end
end

function SafeRefineChooseBord:ClickAutoFillButton()
  if self.autoFillEvent then
    self.autoFillEvent(self.autoFillEventParam, self)
  end
end

function SafeRefineChooseBord:SetAutoFillEvent(evt, evtParam)
  self.autoFillEvent = evt
  self.autoFillEventParam = evtParam
end

SafeRefineChooseBord_CombineSize = class("SafeRefineChooseBord_CombineSize", SafeRefineChooseBord)
SafeRefineChooseBord_CombineSize.PrefabPath = "part/SafeRefineChooseBord_CombineSize"
