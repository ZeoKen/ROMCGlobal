GuildFaithPage = class("GuildFaithPage", SubView)
autoImport("GFaithTypeCell")
autoImport("GAstrolabeAttriCell")
autoImport("GvGPvpAttrCell")
autoImport("GvGPvpPrayData")
autoImport("GPray4FaithTypeCell")
local eToggleType = {
  eNone = 0,
  ePray4 = 1,
  eFaith = 2,
  eAstro = 3,
  eAttribute = 4
}
GuildFaithPage.TabName = {
  faithTitle = ZhString.GuildFaithPage_FaithTabName,
  astroTitle = ZhString.GuildFaithPage_AstroTabName
}
local titleDeepColor = Color(0.2627450980392157, 0.30196078431372547, 0.5529411764705883, 1)
local titleNormalColor = Color(0.5450980392156862, 0.5450980392156862, 0.5450980392156862, 1)
local tabNameTipOffset = {133, -58}
local Pray4TextureName = "pet_bg_bg04"

function GuildFaithPage:Init()
  self:InitUI()
  self:MapEvent()
end

function GuildFaithPage:InitUI()
  self.goPrayButton = self:FindGO("GoPrayButton")
  self:AddClickEvent(self.goPrayButton, function(go)
    self:TraceNpc()
  end)
  local goAstrolabeButton = self:FindGO("GoAstrolabeButton")
  goAstrolabeButton:SetActive(false)
  self.m_uiTxtAstrolabeButtonName = self:FindGO("GoAstrolabeButton/Label"):GetComponent(UILabel)
  local faithGrid = self:FindComponent("FaithTypeGrid", UIGrid)
  self.faithAttriCtl = UIGridListCtrl.new(faithGrid, GFaithTypeCell, "GFaithTypeCell")
  local astrolabeGrid = self:FindComponent("AstrolabeGrid", UIGrid)
  self.astrolabeCtl = UIGridListCtrl.new(astrolabeGrid, GAstrolabeAttriCell, "GAstrolabeAttriCell")
  local gvgPvpAttrGrid1 = self:FindComponent("gvgPvpAttrGrid1", UIGrid)
  local gvgPvpAttrGrid2 = self:FindComponent("gvgPvpAttrGrid2", UIGrid)
  local gvgPvpAttrGrid3 = self:FindComponent("gvgPvpAttrGrid3", UIGrid)
  self.gvgPvpAttrCtl1 = UIGridListCtrl.new(gvgPvpAttrGrid1, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl2 = UIGridListCtrl.new(gvgPvpAttrGrid2, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrCtl3 = UIGridListCtrl.new(gvgPvpAttrGrid3, GvGPvpAttrCell, "GvGPvpAttrCell")
  self.gvgPvpAttrBord = self:FindGO("gvgPvpAttrBord")
  self.astrolabeBord = self:FindGO("AstrolabeBord")
  self.lockTip = self:FindGO("LockTip")
  self.gvgPvpLockTip = self:FindGO("gvgPvpLockTip")
  self.faithRoot = self:FindGO("faithRoot")
  self.m_uiTxtAstrolabeBordTitle = self:FindGO("AstrolabeBord/AstrolabeTitle/Label"):GetComponent(UILabel)
  local titleLab = self:FindGO("title1", self.faithRoot)
  titleLab = self:FindComponent("Label", UILabel, titleLab)
  titleLab.text = ZhString.GFaith_pray
  titleLab = self:FindGO("title2", self.faithRoot)
  titleLab = self:FindComponent("Label", UILabel, titleLab)
  titleLab.text = ZhString.GFaith_guildpray
  self.astroRoot = self:FindGO("astroRoot")
  local pray4Grid = self:FindComponent("Pray4TypeGrid", UIGrid)
  self.pray4Ctl = UIGridListCtrl.new(pray4Grid, GPray4FaithTypeCell, "GFaithTypeCell")
  self.pray4Root = self:FindGO("Pray4Root")
  self.pray4Texture = self:FindComponent("Texture", UITexture, self.pray4Root)
  self.pray4Title = self:FindGO("pray4Title")
  self.pray4TitleLabel = self:FindComponent("Label", UILabel, self.pray4Title)
  self.pray4TitleImg = self:FindGO("ChooseImg", self.pray4Title)
  self.pray4TitleIcon = self:FindComponent("Icon", UISprite, self.pray4Title)
  self:AddClickEvent(self.pray4Title, function()
    self:UpdatePray4Grid()
  end)
  self.pray4Title:SetActive(not GuildPrayProxy.CheckPray4Forbidden())
  self.faithTitle = self:FindGO("faithTitle")
  self.faithTitleLabel = self:FindComponent("Label", UILabel, self.faithTitle)
  self.faithTitleImg = self:FindGO("ChooseImg", self.faithTitle)
  self.faithTitleIcon = self:FindComponent("Icon", UISprite, self.faithTitle)
  self:AddClickEvent(self.faithTitle, function()
    self:UpdateFaithGrid()
  end)
  self.astroTitle = self:FindGO("astroTitle")
  self.astroTitleLabel = self:FindComponent("Label", UILabel, self.astroTitle)
  self.astroTitleImg = self:FindGO("ChooseImg", self.astroTitle)
  self.astroTitleIcon = self:FindComponent("Icon", UISprite, self.astroTitle)
  self:AddClickEvent(self.astroTitle, function()
    self:UpdateAstrolabeGrid()
  end)
  self.attributeTitle = self:FindGO("attributeTitle")
  self.attributeTitleLabel = self:FindComponent("Label", UILabel, self.attributeTitle)
  self.attributeTitleImg = self:FindGO("ChooseImg", self.attributeTitle)
  self.attributeTitleIcon = self:FindComponent("Icon", UISprite, self.attributeTitle)
  self:AddClickEvent(self.attributeTitle, function()
    self:UpdateAttributeGrid()
  end)
  self.attributeTitle:SetActive(not FunctionUnLockFunc.CheckForbiddenByFuncState("gvg_pray_forbidden") and not FunctionUnLockFunc.CheckForbiddenByFuncState("pray_forbidden", GuildCmd_pb.EPRAYTYPE_HOLYBLESS))
  self:InitFaithGrid()
  local tabList = {
    self.faithTitle,
    self.astroTitle
  }
  for i, v in ipairs(tabList) do
    local longPress = v:GetComponent(UILongPress)
    
    function longPress.pressEvent(obj, state)
      self:PassEvent(TipLongPressEvent.GuildFaithPage, {
        state,
        obj.gameObject
      })
    end
  end
  self:AddEventListener(TipLongPressEvent.GuildFaithPage, self.HandleLongPress, self)
  TabNameTip.SwitchShowTabIconOrLabel(self.pray4TitleIcon.gameObject, self.pray4TitleLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.faithTitleIcon.gameObject, self.faithTitleLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.astroTitleIcon.gameObject, self.astroTitleLabel.gameObject)
  TabNameTip.SwitchShowTabIconOrLabel(self.attributeTitleIcon.gameObject, self.attributeTitleLabel.gameObject)
end

local tempArgs = {}

function GuildFaithPage:TraceNpc()
  if Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif Game.MapManager:IsInGuildMap() then
    FuncShortCutFunc.Me():CallByID(500)
  elseif Game.Myself:IsDead() then
    MsgManager.ShowMsgByIDTable(2500)
  elseif not GuildProxy.Instance:IHaveGuild() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.GuildInfoView
    })
    return
  else
    xdlog("申请进入公会")
    ServiceGuildCmdProxy.Instance:CallEnterTerritoryGuildCmd()
    FunctionChangeScene.Me():SetSceneLoadFinishActionForOnce(function()
      FuncShortCutFunc.Me():CallByID(500)
    end)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end
end

function GuildFaithPage:_setTitleToggleState(eToggle)
  if eToggle == eToggleType.eFaith then
    self.faithTitleLabel.color = titleDeepColor
    self.astroTitleLabel.color = titleNormalColor
    self.attributeTitleLabel.color = titleNormalColor
    self.pray4TitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleDeepColor
    self.astroTitleIcon.color = titleNormalColor
    self.attributeTitleIcon.color = titleNormalColor
    self.pray4TitleIcon.color = titleNormalColor
    self:Show(self.faithTitleImg)
    self:Hide(self.astroTitleImg)
    self:Hide(self.attributeTitleImg)
    self:Hide(self.pray4TitleImg)
    self:Show(self.faithRoot)
    self:Hide(self.astroRoot)
    self:Hide(self.pray4Root)
    self.goPrayButton:SetActive(true)
  elseif eToggle == eToggleType.ePray4 then
    self.pray4TitleLabel.color = titleDeepColor
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleNormalColor
    self.attributeTitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleNormalColor
    self.attributeTitleIcon.color = titleNormalColor
    self.pray4TitleIcon.color = titleDeepColor
    self:Show(self.pray4TitleImg)
    self:Hide(self.faithTitleImg)
    self:Hide(self.astroTitleImg)
    self:Hide(self.attributeTitleImg)
    self:Hide(self.faithRoot)
    self:Hide(self.astroRoot)
    self:Show(self.pray4Root)
    self.goPrayButton:SetActive(true)
  elseif eToggle == eToggleType.eAstro then
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleDeepColor
    self.attributeTitleLabel.color = titleNormalColor
    self.pray4TitleLabel.color = titleNormalColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleDeepColor
    self.attributeTitleIcon.color = titleNormalColor
    self.pray4TitleIcon.color = titleNormalColor
    self:Hide(self.faithTitleImg)
    self:Show(self.astroTitleImg)
    self:Hide(self.attributeTitleImg)
    self:Hide(self.pray4TitleImg)
    self:Show(self.astroRoot)
    self:Hide(self.faithRoot)
    self:Hide(self.pray4Root)
    self.m_uiTxtAstrolabeButtonName.text = ZhString.GuildFailthPage_AstroBtnName
    self.m_uiTxtAstrolabeBordTitle.text = ZhString.GuildFailthPage_AstroTitle
    self.goPrayButton:SetActive(false)
  elseif eToggle == eToggleType.eAttribute then
    self.faithTitleLabel.color = titleNormalColor
    self.astroTitleLabel.color = titleNormalColor
    self.pray4TitleLabel.color = titleNormalColor
    self.attributeTitleLabel.color = titleDeepColor
    self.faithTitleIcon.color = titleNormalColor
    self.astroTitleIcon.color = titleNormalColor
    self.pray4TitleIcon.color = titleNormalColor
    self.attributeTitleIcon.color = titleDeepColor
    self:Hide(self.faithTitleImg)
    self:Hide(self.astroTitleImg)
    self:Hide(self.pray4TitleImg)
    self:Show(self.attributeTitleImg)
    self:Show(self.astroRoot)
    self:Hide(self.faithRoot)
    self:Hide(self.pray4Root)
    self.m_uiTxtAstrolabeButtonName.text = ZhString.GuildFailthPage_AttributeBtnName
    self.m_uiTxtAstrolabeBordTitle.text = ZhString.GuildFailthPage_AttributeTitle
    self.goPrayButton:SetActive(true)
  end
  self.m_curToggle = eToggle
end

function GuildFaithPage:InitFaithGrid()
  self.faithDatas = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_GODDESS)
end

function GuildFaithPage:UpdateFaithGrid()
  if not GuildProxy.Instance:IHaveGuild() then
    return
  end
  self:_setTitleToggleState(eToggleType.eFaith)
  self.faithAttriCtl:ResetDatas(self.faithDatas)
  if not GuildPrayProxy.CheckGvgPrayForbidden() then
    self:UpdateGvgPvpGrid()
    self:Hide(self.gvgPvpLockTip)
  else
    self:Show(self.gvgPvpLockTip)
  end
end

function GuildFaithPage.SortRule(a, b)
  return a[1] < b[1]
end

function GuildFaithPage:UpdateGvgPvpGrid()
  local datas = {
    [1] = {},
    [2] = {},
    [3] = {}
  }
  for i = 1, 3 do
    local typeData = GuildPrayProxy.Instance:GetPrayListByType(i)
    for j = 1, #typeData do
      local attr = typeData[j]:GetAddAttrValue()
      local cellData = {
        attr[2],
        attr[3],
        attr[7],
        attr[11]
      }
      table.insert(datas[i], cellData)
    end
  end
  self.gvgPvpAttrCtl1:ResetDatas(datas[1])
  self.gvgPvpAttrCtl2:ResetDatas(datas[2])
  self.gvgPvpAttrCtl3:ResetDatas(datas[3])
end

function GuildFaithPage:UpdateAstrolabeGrid()
  self:_setTitleToggleState(eToggleType.eAstro)
  local attriMap = AstrolabeProxy.Instance:GetEffectMap()
  local datas = {}
  for key, value in pairs(attriMap) do
    local cdata = {key, value}
    table.insert(datas, cdata)
  end
  if 0 < #datas then
    self.astrolabeBord:SetActive(true)
    self.lockTip:SetActive(false)
    self.astrolabeBord:SetActive(0 < #datas)
    table.sort(datas, GuildFaithPage.SortRule)
    self.astrolabeCtl:ResetDatas(datas)
    self.astrolabeCtl:ResetPosition()
  else
    self.astrolabeBord:SetActive(false)
    self.lockTip:SetActive(true)
  end
end

function GuildFaithPage:UpdatePray4Grid()
  if not GuildProxy.Instance.myGuildData then
    return
  end
  self:_setTitleToggleState(eToggleType.ePray4)
  local data = {}
  local typeData = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_FOUR)
  for j = 1, #typeData do
    local attr = typeData[j]:GetAddAttrValue()
    local cellData = {
      attr[12],
      attr[2],
      attr[3]
    }
    table.insert(data, cellData)
  end
  self.pray4Ctl:ResetDatas(data)
end

function GuildFaithPage:UpdateAttributeGrid()
  self:_setTitleToggleState(eToggleType.eAttribute)
  local attributes = GuildPrayProxy.Instance:GetPrayListByType(GuildCmd_pb.EPRAYTYPE_HOLYBLESS)
  local datas = {}
  for key, value in pairs(attributes) do
    local newData = {}
    newData.m_isAttribute = true
    newData.m_data = value
    table.insert(datas, newData)
  end
  local hasData = 0 < #datas
  self.astrolabeBord:SetActive(hasData)
  self.lockTip:SetActive(not hasData)
  if hasData then
    self.astrolabeCtl:ResetDatas(datas)
  end
  self.astrolabeCtl:ResetPosition()
end

function GuildFaithPage:MapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildMemberDataUpdateGuildCmd, self.HandleGuildMemberDataUpdate)
end

function GuildFaithPage:OnEnter()
  GuildFaithPage.super.OnEnter(self)
  local tab = self.viewdata.viewdata and self.viewdata.viewdata.prayTab
  if tab == 4 then
    self:UpdateAstrolabeGrid()
  elseif tab == 3 then
    self:UpdateAttributeGrid()
  elseif tab == 2 then
    self:UpdateFaithGrid()
  elseif GuildPrayProxy.CheckPray4Forbidden() then
    self:UpdateFaithGrid()
  else
    self:UpdatePray4Grid()
  end
  PictureManager.Instance:SetUI(Pray4TextureName, self.pray4Texture)
end

function GuildFaithPage:OnExit()
  PictureManager.Instance:UnLoadUI(Pray4TextureName, self.pray4Texture)
  GuildFaithPage.super.OnExit(self)
end

function GuildFaithPage:HandleLongPress(param)
  local isPressing, go = param[1], param[2]
  TabNameTip.OnLongPress(isPressing, GuildFaithPage.TabName[go.name], true, self:FindComponent("ChooseImg", UISprite, go), nil, tabNameTipOffset)
end

function GuildFaithPage:HandleGuildMemberDataUpdate()
  if self.m_curToggle == eToggleType.eFaith then
    self:UpdateFaithGrid()
  end
end
