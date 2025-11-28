autoImport("BaseTip")
MultiGeneralHelp = class("MultiGeneralHelp", BaseTip)
autoImport("SettingViewToggleCell")

function MultiGeneralHelp:Init()
  self:InitTip()
  local closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(closeBtn, function()
    TipsView.Me():HideCurrent()
    EventManager.Me():DispatchEvent(UICloseEvent.GeneralHelpClose)
  end)
end

function MultiGeneralHelp:InitTip()
  self.content = self:FindComponent("Content", UIRichLabel)
  self.contentLabel = SpriteLabel.new(self.content)
  local toggleGrid = self:FindComponent("ToggleGrid", UIGrid)
  self.toggleCtrl = UIGridListCtrl.new(toggleGrid, SettingViewToggleCell, "SettingViewToggleCell")
  self.toggleCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickToggle, self)
  self.contentScrollView = self:FindComponent("ContentScrollView", UIScrollView)
end

function MultiGeneralHelp:ClickToggle(cell)
  self:SetToggle(cell.indexInList)
end

function MultiGeneralHelp:SetToggle(index)
  self.toggleIndex = index
  local cells = self.toggleCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetActive(self.toggleIndex == i)
  end
  self.contentLabel:SetText(self.datas[index].Desc)
  self.contentScrollView:ResetPosition()
end

function MultiGeneralHelp:SetData(datas)
  if not datas then
    return
  end
  self.datas = datas
  self.toggleCtrl:ResetDatas(datas)
  self:SetToggle(1)
end

function MultiGeneralHelp:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
