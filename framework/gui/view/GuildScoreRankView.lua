autoImport("GuildScoreRankPage")
autoImport("GuildScoreMemberRankPage")
GuildScoreRankView = class("GuildScoreRankView", ContainerView)
GuildScoreRankView.ViewType = UIViewType.NormalLayer
local TEX = {
  "pvp_bg_win",
  "pvp_bg_courage_02"
}
GuildScoreRankView.TabName = {
  [1] = ZhString.GuildScoreRankView_Tab1,
  [2] = ZhString.GuildScoreRankView_Tab2
}

function GuildScoreRankView:Init()
  self:InitUI()
  self:FindObj()
  self:AddButtonEvts()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end

function GuildScoreRankView:FindObj()
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GuildScoreRankView_Title
end

function GuildScoreRankView:TabChangeHandler(key)
  local ret = GuildScoreRankView.super.TabChangeHandler(self, key)
  if PanelConfig.GuildScoreRankPage.tab == key then
    ServiceGuildCmdProxy.Instance:CallQueryBifrostRankGuildCmd()
  end
  if ret and not GameConfig.SystemForbid.TabNameTip then
    local tab = self.coreTabMap[key]
    if tab then
      if self.currentKey then
        local iconSp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[self.currentKey].go, "Icon"):GetComponent(UISprite)
        iconSp.color = ColorUtil.TabColor_White
      end
      self.currentKey = key
      local iconSp = Game.GameObjectUtil:DeepFindChild(tab.go, "Icon"):GetComponent(UISprite)
      iconSp.color = ColorUtil.TabColor_DeepBlue or ColorUtil.NGUIWhite
    end
  end
end

function GuildScoreRankView:InitUI()
  local togglesParentObj = self:FindGO("Toggles")
  local toggleList = {}
  local longPressList = {}
  for i = 1, 2 do
    local toggleName = "Toggle" .. i
    local toggleObj = self:FindGO(toggleName, togglesParentObj)
    toggleList[#toggleList + 1] = toggleObj
    local toggleLongPress = toggleObj:GetComponent(UILongPress)
    
    function toggleLongPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GuildScore, {state, i})
    end
    
    longPressList[#longPressList + 1] = toggleLongPress
  end
  self:AddEventListener(TipLongPressEvent.GuildScore, self.HandleLongPress, self)
  if not GameConfig.SystemForbid.TabNameTip then
    for k, v in pairs(toggleList) do
      local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
      icon:SetActive(true)
      local nameLabel = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(false)
    end
  else
    for k, v in pairs(toggleList) do
      local icon = Game.GameObjectUtil:DeepFindChild(v, "Icon")
      icon:SetActive(false)
      local nameLabel = Game.GameObjectUtil:DeepFindChild(v, "NameLabel")
      nameLabel:SetActive(true)
    end
  end
  self:AddSubView("GuildScoreRankPage", GuildScoreRankPage)
  self:AddSubView("GuildScoreMemberRankPage", GuildScoreMemberRankPage)
  self.viewdata.view.tab = 1
  local scoreBord = self:FindGO("ScoreBord")
  local memberScoreBord = self:FindGO("MemberScoreBord")
  self:AddTabChangeEvent(toggleList[1], scoreBord, PanelConfig.GuildScoreRankPage)
  self:AddTabChangeEvent(toggleList[2], memberScoreBord, PanelConfig.GuildScoreMemberRankPage)
end

function GuildScoreRankView:AddButtonEvts()
  self:AddClickEvent(self:FindGO("LeaveBtn"), function()
    self:CloseSelf()
  end)
end

function GuildScoreRankView:SetTextures()
  PictureManager.Instance:SetPVP(TEX[1], self:FindComponent("texWinBG", UITexture))
  PictureManager.Instance:SetPVP(TEX[2], self:FindComponent("texWinText", UITexture))
end

function GuildScoreRankView:OnEnter()
  GuildScoreRankView.super.OnEnter(self)
  self:SetTextures()
end

function GuildScoreRankView:OnExit()
  PictureManager.Instance:UnLoadPVP()
  GuildScoreRankView.super.OnExit(self)
end

function GuildScoreRankView:HandleLongPress(param)
  local isPressing, index = param[1], param[2]
  local sp = Game.GameObjectUtil:DeepFindChild(self.coreTabMap[index].go, "Background"):GetComponent(UISprite)
  TabNameTip.OnLongPress(isPressing, GuildScoreRankView.TabName[index], false, sp)
end
