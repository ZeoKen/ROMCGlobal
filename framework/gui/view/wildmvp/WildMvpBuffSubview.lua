autoImport("CollapseTreeCell")
autoImport("WildMvpBuffCell")
WildMvpBuffSubview = class("WildMvpBuffSubview", SubView)

function WildMvpBuffSubview:Init()
  self:ReLoadPerferb("view/WildMvp/WildMvpBuffSubview")
  self:FindObjs()
  self:AddListenEvents()
  self:UpdateView()
end

function WildMvpBuffSubview:FindObjs()
  local helpBtnGO = self:FindGO("HelpBtn")
  local helpID = PanelConfig.WildMvpBuffSubview.id
  self:TryOpenHelpViewById(helpID, nil, helpBtnGO)
  local midGO = self:FindGO("Mid")
  self.buffScrollGO = self:FindGO("BuffScroll", midGO)
  self.buffListCtrl = ListCtrl.new(self:FindComponent("Container", UITable, self.buffScrollGO), CollapseTreeCell, "WildMvp/WildMvpBuffGroupCell")
  self.emptyGO = self:FindGO("EmptyLab")
  self.emptyLab = self.emptyGO:GetComponent(UILabel)
  self.emptyLab.text = ZhString.WildMvpNoBuff
end

function WildMvpBuffSubview:OnEnter()
  WildMvpBuffSubview.super.OnEnter(self)
  WildMvpProxy.Instance:QueryBuffs()
  self:AddListenEvents()
end

function WildMvpBuffSubview:OnExit()
  self:RemoveListenEvents()
  WildMvpProxy.Instance:ClearBuffChangedStatus()
  WildMvpBuffSubview.super.OnExit(self)
end

function WildMvpBuffSubview:OnShow()
  self:UpdateView()
end

function WildMvpBuffSubview:OnHide()
end

function WildMvpBuffSubview:AddListenEvents()
  EventManager.Me():AddEventListener(WildMvpEvent.OnBuffUpdated, self.UpdateView, self)
end

function WildMvpBuffSubview:RemoveListenEvents()
  EventManager.Me():RemoveEventListener(WildMvpEvent.OnBuffUpdated, self.UpdateView, self)
end

function WildMvpBuffSubview:UpdateView()
  local proxy = WildMvpProxy.Instance
  local datas = proxy:GetBuffDatas()
  if datas and 0 < #datas then
    self.emptyGO:SetActive(false)
  else
    self.emptyGO:SetActive(true)
  end
  for _, v in ipairs(datas) do
    v.cellPrefab = "WildMvp/WildMvpBuffCell"
    v.cellCtrl = WildMvpBuffCell
  end
  self.buffListCtrl:ResetDatas(datas)
end
