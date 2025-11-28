SpaceDragonIntroView = class("SpaceDragonIntroView", BaseView)
SpaceDragonIntroView.ViewType = UIViewType.NormalLayer

function SpaceDragonIntroView:Init()
  self.helpPanel = self:FindGO("GeneralHelp")
  self.helpPanelText = self:FindComponent("IntroduceLabel", UIRichLabel)
  self.portalDesc = self:FindComponent("PortalDesc", UILabel)
  self.icon = self:FindComponent("Icon", UITexture)
  local helpbtnLabel = self:FindComponent("HelpButtonLabel", UILabel)
  helpbtnLabel.text = ZhString.SpaceDragonIntroView_HelpButton
  local gotoLabel = self:FindComponent("GotoLabel", UILabel)
  gotoLabel.text = ZhString.SpaceDragonIntroView_Goto
  PictureManager.Instance:SetAbyssTexture("equip_drawings_icon_AbyssDragon", self.icon)
  self:addViewEventListener()
  self:addEventListener()
  self:InitData()
end

function SpaceDragonIntroView:addViewEventListener()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self:AddButtonEvent("CloseButtonHelp", function()
    self.helpPanel:SetActive(false)
  end)
  self:AddButtonEvent("Goto", function()
    self:Goto()
  end)
end

function SpaceDragonIntroView:Goto(note)
  if not self.gainWayTip then
    local parentPanel = self.gameObject:GetComponent(UIPanel)
    self.gainWayTip = GainWayTip.new(self.gameObject, parentPanel.depth + 2)
    if not self.gainWayTipDatas then
      self.gainWayTipDatas = {}
      local raidInfo = GameConfig.AbyssDragon and GameConfig.AbyssDragon.RaidInfo
      if raidInfo then
        for id, info in pairs(raidInfo) do
          local data = GainWayItemCellData.new(id)
          data:ParseSingleNormalGainWay(info.AddwayID)
          TableUtility.InsertSort(self.gainWayTipDatas, data, function(a, b)
            return a.staticID > b.staticID
          end)
        end
      end
    end
    self.gainWayTip:SetTitle(ZhString.SpaceDragonIntroView_Title)
    self.gainWayTip:SetPivotOffset(0, 278)
    self.gainWayTip:SetListDatas(self.gainWayTipDatas)
    self.gainWayTip:AddEventListener(ItemEvent.GoTraceItem, function()
      self:CloseSelf()
    end, self)
    self.gainWayTip:AddEventListener(GainWayTip.CloseGainWay, function()
      self.gainWayTip = nil
    end, self)
  end
end

function SpaceDragonIntroView:InitData()
  self.portalDesc.text = GameConfig.AbyssDragon.EntranceDesc or ""
end

function SpaceDragonIntroView:addEventListener()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.SceneLoadFinishHandler)
  self:AddListenEvt(ServiceEvent.RaidCmdAbyssDragonOnOffRaidCmd, self.SetView)
end

function SpaceDragonIntroView:AddHelpButtonEvent()
  local go = self:FindGO("HelpButton")
  if go then
    self:AddClickEvent(go, function(g)
      self.helpPanel:SetActive(true)
      self:FillTextByHelpId(32638, self.helpPanelText)
    end)
  end
end

function SpaceDragonIntroView:SetView(note)
  local data = AbyssFakeDragonProxy.Instance:GetDragonInfos()
  if not data then
    self:CloseSelf()
  end
end

function SpaceDragonIntroView:SceneLoadFinishHandler(note)
  self:CloseSelf()
end

function SpaceDragonIntroView:OnExit()
  PictureManager.Instance:UnloadAbyssTexture("equip_drawings_icon_AbyssDragon", self.icon)
  if self.gainWayTip then
    self.gainWayTip:OnExit()
    self.gainWayTip = nil
  end
end
