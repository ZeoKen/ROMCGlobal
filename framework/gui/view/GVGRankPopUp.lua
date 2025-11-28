local _MainTogColor = {
  Choosen = Color(0.14901960784313725, 0.28627450980392155, 0.615686274509804, 1),
  UnChoosen = Color(0.5450980392156862, 0.7294117647058823, 0.8980392156862745, 1)
}
local _PageHelp = {
  [1] = 35212,
  [2] = 35264
}
autoImport("GVGRankPopUp_Gvg")
autoImport("GVGRankPopUp_SuperGvg")
GVGRankPopUp = class("GVGRankPopUp", ContainerView)
GVGRankPopUp.ViewType = UIViewType.PopUpLayer

function GVGRankPopUp:Init()
  self:FindObjs()
  self:AddUIEvt()
  self:InitUI()
  self:AddServerEvt()
  self:InitTabChange()
end

function GVGRankPopUp:AddServerEvt()
  self:AddListenEvt(ServiceEvent.GuildCmdQueryGvgGuildInfoGuildCmd, self.HanleQueryGvgGuildInfo)
  self:AddListenEvt(ServiceEvent.GuildCmdQuerySuperGvgDataGuildCmd, self.HandleQuerySuperGvgRank)
end

function GVGRankPopUp:HandleQuerySuperGvgRank()
  if self.superGvgPage then
    self.superGvgPage:HandleQueryFunc()
  end
end

function GVGRankPopUp:InitTabChange()
  if self.viewdata.view and self.viewdata.view.tab then
    self:TabChangeHandler(self.viewdata.view.tab)
  end
end

function GVGRankPopUp:FindObjs()
  self.helpBtn = self:FindGO("HelpBtn")
  local mainTog = self:FindGO("MainTog")
  self.mainTogs = {}
  self.mainTogs[1] = self:FindComponent("GVG_Tog", UISprite, mainTog)
  self.mainTogs[2] = self:FindComponent("GVGSuper_Tog", UISprite, mainTog)
  self.mainTogLab = {}
  self.mainTogLab[1] = self:FindComponent("Label", UILabel, self.mainTogs[1].gameObject)
  self.mainTogLab[1].text = ZhString.NewGvg_MainTog_GVG
  self.mainTogLab[2] = self:FindComponent("Label", UILabel, self.mainTogs[2].gameObject)
  self.mainTogLab[2].text = ZhString.NewGvg_MainTog_SuperGVG
  self.mainTogSp = {}
  self.mainTogSp[1] = self:FindComponent("Sprite", UISprite, self.mainTogs[1].gameObject)
  self.mainTogSp[2] = self:FindComponent("Sprite", UISprite, self.mainTogs[2].gameObject)
  self.targetGO = {}
  self.targetGO[1] = self:FindGO("GvgRoot")
  self.targetGO[2] = self:FindGO("SuperGvgRoot")
  self.emptyRoot = self:FindGO("EmptyRoot")
  self.queryGuildInfoRoot = self:FindGO("QueryGuildInfoRoot")
  local title = self:FindComponent("Title", UILabel, self.queryGuildInfoRoot)
  title.text = ZhString.NewGVG_QueryGuildTitle
  local tipGrid = self:FindGO("Grid", self.queryGuildInfoRoot)
  local tip1 = self:FindComponent("Tip1", UILabel, tipGrid)
  tip1.text = ZhString.GvgRankingGuildMeeage
  local tip2 = self:FindComponent("Tip2", UILabel, tipGrid)
  tip2.text = ZhString.GvgRankingGuildLevel
  local tip3 = self:FindComponent("Tip3", UILabel, tipGrid)
  tip3.text = ZhString.GvgRankingGuildMember
  local tip4 = self:FindComponent("Tip4", UILabel, tipGrid)
  tip4.text = ZhString.GvgRankingGuildLeader
  self.closeQueryGuildBtn = self:FindGO("CloseQueryGuildBtn", self.queryGuildInfoRoot)
  self.guidNameLab = self:FindComponent("GuildName", UILabel, tip1.gameObject)
  self.guidLevelLab = self:FindComponent("GuildLevel", UILabel, tip2.gameObject)
  self.guidMemberCountLab = self:FindComponent("GuildMemberCount", UILabel, tip3.gameObject)
  self.chairManNameLab = self:FindComponent("ChairManName", UILabel, tip4.gameObject)
  local GuildFlagRoot = self:FindGO("GuildFlag", self.queryGuildInfoRoot)
  self.lvLable = self:FindComponent("LvLable", UILabel, GuildFlagRoot)
  self.guildIcon = self:FindComponent("GuildIcon", UISprite, GuildFlagRoot)
  self.customPic = self:FindComponent("CustomIcon", UITexture, GuildFlagRoot)
  self.gvgReportBtnGO = self:FindGO("ReportBtn", self.targetGO[1])
  self:AddClickEvent(self.gvgReportBtnGO, function()
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GVGStatView
    })
  end)
end

function GVGRankPopUp:AddUIEvt()
  self:AddClickEvent(self.closeQueryGuildBtn, function(obj)
    self:Hide(self.queryGuildInfoRoot)
  end)
end

function GVGRankPopUp:InitUI()
  self:AddTabChangeEvent(self.mainTogs[1].gameObject, self.targetGO[1], PanelConfig.GVGRankPopUp_Gvg)
  self:AddTabChangeEvent(self.mainTogs[2].gameObject, self.targetGO[2], PanelConfig.GVGRankPopUp_SuperGvg)
  self.viewdata.view.tab = 1
end

function GVGRankPopUp:HanleQueryGvgGuildInfo()
  local gd = GvgProxy.Instance:GetQueryGuildInfo()
  if gd then
    self:Show(self.queryGuildInfoRoot)
    self.queryGuildID = gd.id
    self.guidNameLab.text = gd.guildName
    self.guidLevelLab.text = gd.lv
    self.guidMemberCountLab.text = gd.memberCount
    self.chairManNameLab.text = gd.leaderName
    self.lvLable.text = gd:Lv2String()
    self:SetGuildIcon()
  end
end

function GVGRankPopUp:OnEnter()
  GvgProxy.Instance:DoQueryGvgRank(0)
  GVGRankPopUp.super.OnEnter(self)
  self:SetViewInfo()
end

function GVGRankPopUp:OnExit()
  GVGRankPopUp.super.OnExit(self)
  self.gvgPage:Unload()
end

function GVGRankPopUp:SetViewInfo()
end

function GVGRankPopUp:TabChangeHandler(key)
  if self.curKey and self.curKey == key then
    return
  end
  self.curKey = key
  TipsView.Me():TryShowGeneralHelpByHelpId(_PageHelp[self.curKey], self.helpBtn)
  GVGRankPopUp.super.TabChangeHandler(self, key)
  if PanelConfig.GVGRankPopUp_Gvg.tab == key then
    if not self.gvgPage then
      self.gvgPage = self:AddSubView("GVGRankPopUp_Gvg", GVGRankPopUp_Gvg)
    end
    self.gvgPage:OnTabView()
  elseif PanelConfig.GVGRankPopUp_SuperGvg.tab == key then
    if not self.superGvgPage then
      self.superGvgPage = self:AddSubView("GVGRankPopUp_SuperGvg", GVGRankPopUp_SuperGvg)
    end
    self.superGvgPage:OnTabView()
  end
  for i = 1, #self.mainTogs do
    self.mainTogs[i].color = key == i and _MainTogColor.Choosen or _MainTogColor.UnChoosen
    self.mainTogLab[i].color = key == i and _MainTogColor.Choosen or _MainTogColor.UnChoosen
    self.mainTogSp[i].gameObject:SetActive(key == i)
  end
end

function GVGRankPopUp:SetGuildIcon()
  local headId = GuildProxy.Instance:GetGuildRankQueryPortrait()
  local guildHeadData = GuildHeadData.new()
  guildHeadData:SetBy_InfoId(headId)
  guildHeadData:SetGuildId(self.queryGuildID)
  self.index = guildHeadData.index
  if guildHeadData.type == GuildHeadData_Type.Config then
    local sdata = guildHeadData.staticData
    if sdata then
      self.guildIcon.gameObject:SetActive(true)
      self.customPic.gameObject:SetActive(false)
      IconManager:SetGuildIcon(sdata.Icon, self.guildIcon)
      self.guildIcon.width = 55
      self.guildIcon.height = 55
    end
  else
    if guildHeadData.type == GuildHeadData_Type.Custom and self.customPic then
      self.guildIcon.gameObject:SetActive(false)
      self.customPic.gameObject:SetActive(true)
      local pic = FunctionGuild.Me():GetCustomPicCache(guildHeadData.guildid, guildHeadData.index)
      if pic then
        local time_name = pic.name
        if tonumber(time_name) == guildHeadData.time then
          self.customPic.mainTexture = pic
        else
          self:SetCustomPic(guildHeadData, self.customPic)
        end
      else
        self:SetCustomPic(guildHeadData, self.customPic)
      end
    else
    end
  end
  self.guildHeadData = nil
end

function GVGRankPopUp:SetCustomPic(data)
  if data == nil or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(50, 50, TextureFormat.RGB24, false)
    pic.name = data.time
    local bRet = ImageConversion.LoadImage(pic, bytes)
    FunctionGuild.Me():SetCustomPicCache(data.guildid, data.index, pic)
    if self.index == data.index and self.customPic then
      self.customPic.mainTexture = pic
    end
  end
  local pic_type = data.pic_type
  if pic_type == nil or pic_type == "" then
    pic_type = PhotoFileInfo.PictureFormat.JPG
  end
  UnionLogo.Ins():SetUnionID(data.guildid)
  UnionLogo.Ins():GetOriginImage(UnionLogo.CallerIndex.LogoEditor, data.index, data.time, pic_type, nil, success_callback, error_callback, is_keep_previous_callback, is_through_personalphotocallback)
end
