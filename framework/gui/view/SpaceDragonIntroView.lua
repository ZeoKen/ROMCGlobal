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
    self:CloseSelf()
  end)
end

function SpaceDragonIntroView:Goto(note)
  local curMapId = Game.MapManager:GetMapID()
  if curMapId ~= 154 then
    FuncShortCutFunc.Me():MoveToPos({
      Event = {mapid = 154}
    })
    return
  end
  local data = AbyssFakeDragonProxy.Instance:GetDragonInfos()
  if not data then
    self:CloseSelf()
    return
  end
  local targetMap, targetPos = AbyssFakeDragonProxy.Instance:GetTracePos()
  targetPos = targetPos and LuaVector3.New(targetPos.x, targetPos.y, targetPos.z)
  if targetMap and targetPos then
    FuncShortCutFunc.Me():MoveToPos({
      Event = {mapid = targetMap, pos = targetPos}
    })
  end
end

function SpaceDragonIntroView:InitData()
  self.portalDesc.text = GameConfig.AbyssDragon.EntranceDesc or ""
end

function SpaceDragonIntroView:addEventListener()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.SceneLoadFinishHandler)
  self:AddListenEvt(ServiceEvent.QuestAbyssDragonOnOffQuestCmd, self.SetView)
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
end
