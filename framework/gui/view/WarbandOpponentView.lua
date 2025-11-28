autoImport("WarbandOpponentGroupTab")
autoImport("WarbandOpponentCell")
autoImport("WarbandListCombineCell")
WarbandOpponentView = class("WarbandOpponentView", SubView)
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local BTN_SP = {
  "com_btn_3s",
  "com_btn_13s"
}
local PVP_LINE_TEXTURE_NAME = "pvp_bg_01"
local view_Path = ResourcePathHelper.UIView("WarbandOpponentView")
local warbandProxy
local _cellName = "CupModeForbiddenPro"
local _cellSize = 0.4

function WarbandOpponentView:Init()
  self:_loadSelf()
  warbandProxy = WarbandProxy.Instance
  self:InitUI()
  self:AddUIEvt()
  self:AddEvts()
end

function WarbandOpponentView:_loadSelf()
  self.objRoot = self:FindGO("WarbandOpponentView")
  local obj = self:LoadPreferb_ByFullPath(view_Path, self.objRoot, true)
  obj.name = "OpponentSubView"
end

function WarbandOpponentView:InitUI()
  local texRoot = self:FindGO("TextureRoot", self.objRoot)
  self.tex1 = self:FindComponent("Texture1", UITexture, texRoot)
  self.tex2 = self:FindComponent("Texture2", UITexture, texRoot)
  self.tex3 = self:FindComponent("Texture3", UITexture, texRoot)
  PictureManager.Instance:SetPVP(PVP_LINE_TEXTURE_NAME, self.tex1)
  PictureManager.Instance:SetPVP(PVP_LINE_TEXTURE_NAME, self.tex2)
  self.groupRoot = self:FindGO("GroupRoot", self.objRoot)
  local bandGridLeft = self:FindComponent("BandGridLeft", UIGrid, self.groupRoot)
  self.groupBandLeftCtl = UIGridListCtrl.new(bandGridLeft, WarbandOpponentCell, "WarbandOpponentCell")
  self.groupBandLeftCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickOpponentCell, self)
  local bandGridRight = self:FindComponent("BandGridRight", UIGrid, self.groupRoot)
  self.groupBandRightCtl = UIGridListCtrl.new(bandGridRight, WarbandOpponentCell, "WarbandOpponentCell")
  self.groupBandRightCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickOpponentCell, self)
  self.groupLineRoot = self:FindGO("LineRoot", self.groupRoot)
  self.curTabIndex = 1
  self.tabGrid = self:FindComponent("TabGrid", UIGrid, self.objRoot)
  self.tabCtl = UIGridListCtrl.new(self.tabGrid, WarbandOpponentGroupTab, "WarbandOpponentGroupTab")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickGroupTab, self)
  self.opponentRoot = self:FindGO("OpponentRoot", self.objRoot)
  self.tabScrollView = self:FindComponent("TabScrollView", UIScrollView, self.opponentRoot)
  self.signupRoot = self:FindGO("SignupRoot", self.objRoot)
  self.signupScrollView = self:FindComponent("ListScrollView", UIScrollView, self.signupRoot)
  self.signupPanel = self:FindComponent("ListScrollView", UIPanel, self.signupRoot)
  local container = self:FindGO("Wrap", self.objRoot)
  local config = {
    wrapObj = container,
    pfbNum = 5,
    cellName = "WarbandListCombineCell",
    control = WarbandListCombineCell
  }
  self.signupEmpty = self:FindComponent("SignupEmpty", UILabel, self.objRoot)
  self.signupEmpty.text = ZhString.Warband_NoSignupData
  self.bandListCtl = WrapCellHelper.new(config)
  self.bandListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBandTeamCell, self)
  self.scheduleLab = self:FindComponent("ScheduleLabOpp", UILabel, self.objRoot)
  self.teamNumLab = self:FindComponent("NumLab", UILabel, self.objRoot)
  self.seasonRewardBtn = self:FindGO("SeasonRewardBtn", self.objRoot)
  self.seasonRankBtn = self:FindGO("SeasonRankBtn", self.objRoot)
  self.signupBtn = self:FindGO("SignupBtn", self.signupRoot)
  self.signupBtnLab = self:FindComponent("Label", UILabel, self.signupBtn)
  self.signupBtnLab.text = ZhString.Auction_Register
  self.myWarbandBtn = self:FindGO("WarbandInfoBtn", self.objRoot)
  self.matchBtn = self:FindComponent("MatchBtn", UISprite, self.opponentRoot)
  self.matchLab = self:FindComponent("Label", UILabel, self.matchBtn.gameObject)
  local proPrefab = self:_loadForbiddenProPfb()
  self.cupModeForbiddenPro = CupModeForbiddenPro.new(proPrefab)
  self.curTab = 2
end

function WarbandOpponentView:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.objRoot.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function WarbandOpponentView:FirstClickTab()
  local myGroup = 0
  if self.curTab == 1 then
    myGroup = warbandProxy:CheckInPreParticipants()
  elseif self.curTab == 2 then
    myGroup = warbandProxy:CheckInParticipants()
  elseif self.curTab == 3 then
    myGroup = warbandProxy:CheckInFinal()
  end
  local myBandGroup
  local tabCells = self.tabCtl:GetCells()
  for i = 1, #tabCells do
    if i == myGroup then
      self:OnClickGroupTab(tabCells[i])
      tabCells[i]:SetTog(true)
      myBandGroup = tabCells[i]
    end
    tabCells[i]:SetAttend(i == myGroup)
  end
  if not myBandGroup then
    self:OnClickGroupTab(tabCells[1])
    tabCells[1]:SetTog(true)
  else
    self.tabScrollView:ResetPosition()
    local panel = self.tabScrollView.panel
    local bound = NGUIMath.CalculateRelativeWidgetBounds(panel.cachedTransform, myBandGroup.gameObject.transform)
    local offset = panel:CalculateConstrainOffset(bound.min, bound.max)
    offset = Vector3(0, offset.y, 0)
    self.tabScrollView:MoveRelative(offset)
  end
end

function WarbandOpponentView:ClickBandTeamCell(cellctl)
  local data = cellctl and cellctl.data
  if data then
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(0, data.id)
  end
end

function WarbandOpponentView:InitLine()
  if nil ~= self.firstRoundLine then
    return
  end
  self.firstRoundLine = {}
  self.secondLine = {}
  for group = 1, 4 do
    for i = 1, 0, -1 do
      local id = group * 2 - i
      local sp1 = self:FindComponent("Round_1_ID_" .. group * 2 - i, UISprite, self.groupLineRoot)
      local sp1_1 = self:FindComponent("SubLine", UISprite, sp1.gameObject)
      self.firstRoundLine[id] = {sp1, sp1_1}
    end
    local sp2 = self:FindComponent("Round_2_" .. group, UISprite, self.groupLineRoot)
    local sp2_2 = self:FindComponent("SubLine", UISprite, sp2.gameObject)
    self.secondLine[group] = {sp2, sp2_2}
  end
end

function WarbandOpponentView:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function WarbandOpponentView:OnClickGroupTab(cell)
  local data = cell.data
  if not data then
    return
  end
  self.curTabData = data
  self:UpdateBattleLine(true)
end

function WarbandOpponentView:OnClickOpponentCell(ctl)
  local data = ctl and ctl.data
  if data and data.id then
    self.tipStick = ctl.bg
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(0, data.id)
  end
end

function WarbandOpponentView:HandleQueryMember()
  local mdata = warbandProxy.memberinfoData
  TipManager.Instance:ShowWarbandMemberTip(mdata)
end

function WarbandOpponentView:UpdateMatchBtn()
  local haveWarband = warbandProxy:IHaveWarband()
  local matchTimeValid = warbandProxy:CheckMatchTimeValid()
  self.matchBtn.gameObject:SetActive(haveWarband)
  if haveWarband then
    self.matchBtn.spriteName = matchTimeValid and BTN_SP[1] or BTN_SP[2]
    self.matchLab.effectColor = matchTimeValid and ColorUtil.ButtonLabelGreen or GRAY_LABEL_COLOR
  end
end

function WarbandOpponentView:UpdateBattleView()
  local bandcount = 0
  if self.curTab and self.curTab == 1 then
    bandcount = warbandProxy:GetPreRoundOpponentCount()
    self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(bandcount))
  elseif self.curTab and self.curTab == 3 then
    local curStage = warbandProxy:GetCurStage()
    if curStage and curStage == 3 then
      self.teamNumLab.text = ZhString.Warband_FinalIsReady
    elseif curStage and curStage < 3 then
      self.teamNumLab.text = ZhString.Warband_StageReady
    else
      self.teamNumLab.text = ZhString.Warband_StageFinish
    end
  else
    bandcount = warbandProxy:GetOpponentCount()
    self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(bandcount))
  end
  self:UpdateMatchBtn()
  self:UpdateFightingTime()
  local invalidData = warbandProxy.forbiddenPro
  self.cupModeForbiddenPro:SetData(invalidData)
  if invalidData and 0 < #invalidData then
    self:ResizeSignUpListScrollView(2)
  else
    self:ResizeSignUpListScrollView(1)
  end
end

local signUpSVParam = {
  [1] = {offsetY = -12, height = 374},
  [2] = {offsetY = 10, height = 330}
}

function WarbandOpponentView:ResizeSignUpListScrollView(type)
  local param = signUpSVParam[type]
  if not param then
    return
  end
  local clip = self.signupPanel.baseClipRegion
  local pos = self.signupPanel.gameObject.transform.localPosition
  local targetOffsetY = param.offsetY - pos.y
  self.signupPanel.clipOffset = LuaGeometry.GetTempVector2(self.signupPanel.clipOffset.x, targetOffsetY)
  self.signupPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, param.height)
end

function WarbandOpponentView:UpdateFightingTime()
  local curStage = warbandProxy:GetCurStage()
  if curStage < self.curTab then
    self.scheduleLab.text = ZhString.Warband_StageReady
  elseif curStage > self.curTab then
    self.scheduleLab.text = ZhString.Warband_StageFinish
  else
    self.scheduleLab.text = warbandProxy:GetFightCDTime()
  end
end

function WarbandOpponentView:UpdateBtnByMyband()
  local hasSignup = warbandProxy:CheckHasSignup()
  self.signupBtn:SetActive(not hasSignup)
  self.myWarbandBtn:SetActive(warbandProxy:IHaveWarband())
  self:UpdateMatchBtn()
end

local colorArray = {
  Color(0.7725490196078432, 0.7725490196078432, 0.7725490196078432, 1),
  Color(1.0, 1.0, 1.0, 1)
}
local spriteName = {
  "com_bg_line",
  "12pvp_CupMatch_Bright-line"
}

function WarbandOpponentView:UpdateBattleLine(noResetTab)
  if not self.curTabData then
    redlog("未同步对战图数据")
    return
  end
  if self.firstRoundLine == nil then
    return
  end
  local opponentData
  if self.curTab == 1 then
    opponentData = warbandProxy:GetPreRoundOpponentData(self.curTabData)
  elseif self.curTab == 2 then
    opponentData = warbandProxy:GetOpponentData(self.curTabData)
  elseif self.curTab == 3 then
    opponentData = warbandProxy:GetFinalRoundOpponentData(self.curTabData)
  end
  local leftData, rightData = {}, {}
  for index = 1, 8 do
    if index < 5 then
      leftData[#leftData + 1] = opponentData[index]
    else
      rightData[#rightData + 1] = opponentData[index]
    end
  end
  self.groupBandLeftCtl:ResetDatas(leftData)
  self.groupBandRightCtl:ResetDatas(rightData)
  for j = 1, 7, 2 do
    for i = 1, 2 do
      self.firstRoundLine[j][i].color = opponentData[j].wintimes > opponentData[j + 1].wintimes and colorArray[2] or colorArray[1]
      self.firstRoundLine[j][i].spriteName = opponentData[j].wintimes > opponentData[j + 1].wintimes and spriteName[2] or spriteName[1]
      self.firstRoundLine[j][i].height = opponentData[j].wintimes > opponentData[j + 1].wintimes and 6 or 2
      self.firstRoundLine[j + 1][i].color = opponentData[j + 1].wintimes > opponentData[j].wintimes and colorArray[2] or colorArray[1]
      self.firstRoundLine[j + 1][i].spriteName = opponentData[j + 1].wintimes > opponentData[j].wintimes and spriteName[2] or spriteName[1]
      self.firstRoundLine[j + 1][i].height = opponentData[j + 1].wintimes > opponentData[j].wintimes and 6 or 2
    end
  end
  local winnerIndex_left, maxWintime_left, stars_left = 0, 0, 0
  for i = 1, 4 do
    if maxWintime_left < opponentData[i].wintimes then
      maxWintime_left = opponentData[i].wintimes
      winnerIndex_left = i
    end
  end
  winnerIndex_left = maxWintime_left < 2 and 0 or winnerIndex_left
  self:UpdateSecondRoundLine(1, winnerIndex_left)
  self:UpdateSecondRoundLine(2, winnerIndex_left)
  local winnerIndex_right, maxWintime_right, stars_right = 0, 0, 0
  for i = 5, 8 do
    if maxWintime_right < opponentData[i].wintimes then
      maxWintime_right = opponentData[i].wintimes
      winnerIndex_right = i
    end
  end
  winnerIndex_right = maxWintime_right < 2 and 0 or winnerIndex_right
  self:UpdateSecondRoundLine(3, winnerIndex_right)
  self:UpdateSecondRoundLine(4, winnerIndex_right)
  local curStage = warbandProxy:GetCurStage()
  local isStageFinish = curStage > self.curTab
  local leftCells = self.groupBandLeftCtl:GetCells()
  local rightCells = self.groupBandRightCtl:GetCells()
  for i = 1, #leftCells do
    if self.curTab == 1 or self.curTab == 2 then
      leftCells[i]:SetPromotionSymbol(isStageFinish and leftCells[i].data.wintimes == maxWintime_left or false)
    else
      leftCells[i]:SetPromotionSymbol(false)
    end
  end
  for i = 1, #rightCells do
    if self.curTab == 1 or self.curTab == 2 then
      rightCells[i]:SetPromotionSymbol(isStageFinish and rightCells[i].data.wintimes == maxWintime_right or false)
    else
      rightCells[i]:SetPromotionSymbol(false)
    end
  end
end

function WarbandOpponentView:UpdateSecondRoundLine(group, winnerIndex)
  local sp_tab = self.secondLine[group]
  local win
  if group == 1 then
    win = winnerIndex ~= 0 and winnerIndex <= 2
  elseif group == 2 then
    win = winnerIndex ~= 0 and 2 < winnerIndex
  elseif group == 3 then
    win = winnerIndex ~= 0 and winnerIndex < 7
  elseif group == 4 then
    win = winnerIndex ~= 0 and 6 < winnerIndex
  end
  for i = 1, #sp_tab do
    sp_tab[i].color = win and colorArray[2] or colorArray[1]
    sp_tab[i].spriteName = win and spriteName[2] or spriteName[1]
    sp_tab[i].height = win and 6 or 2
  end
end

function WarbandOpponentView:UpdateSignupTeamList()
  local data = warbandProxy:GetSignupWarbandList()
  self.bandListCtl:ResetDatas(self:ReUnitData(data, 2))
  self.signupEmpty.gameObject:SetActive(#data < 1)
  self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(#data))
  self.scheduleLab.text = ZhString.Warband_IsInSignup
  local invalidData = warbandProxy.forbiddenPro
  self.cupModeForbiddenPro:SetData(invalidData)
  if invalidData and 0 < #invalidData then
    self:ResizeSignUpListScrollView(2)
  else
    self:ResizeSignUpListScrollView(1)
  end
end

function WarbandOpponentView:SwitchSignup(isSignup)
  self.signupRoot:SetActive(isSignup)
  self.opponentRoot:SetActive(not isSignup)
  self:UpdateBtnByMyband()
  warbandProxy:SetOpponentStatus(not isSignup)
  if isSignup then
    self:UpdateSignupTeamList()
    ServiceMatchCCmdProxy.Instance:CallTwelveWarbandTeamListMatchCCmd()
  else
    self:UpdateBattleView()
  end
end

function WarbandOpponentView:AddUIEvt()
  self:AddClickEvent(self.seasonRewardBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WarbandRewardPopUp
    })
  end)
  self:AddClickEvent(self.seasonRankBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WarbandSeasonRankPopUp
    })
  end)
  self:AddClickEvent(self.signupBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WarbandSignupPopUp
    })
  end)
  self:AddClickEvent(self.myWarbandBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WarbandSignupPopUp
    })
  end)
  self:AddClickEvent(self.matchBtn.gameObject, function(go)
    local match = warbandProxy:DoMatch()
    if match then
      self.container:CloseSelf()
    end
  end)
end

function WarbandOpponentView:HandleQueryOpponent()
  local preRoundData = warbandProxy:GetPreRoundGroupTabData()
  local hasPreRound = preRoundData and 0 < #preRoundData and true or false
  local finalRoundData = warbandProxy:GetFinalRoundGroupTabData()
  local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
  if not self.curTab then
    if hasFinalRound then
      self.curTab = 3
    elseif hasPreRound then
      self.curTab = 1
    else
      self.curTab = 2
    end
  end
  self:UpdateBattleInfo()
end

function WarbandOpponentView:UpdateBattleInfo()
  local tabData
  xdlog("当前类型选项", self.curTab)
  if self.curTab == 1 then
    tabData = warbandProxy:GetPreRoundGroupTabData()
  elseif self.curTab == 2 then
    tabData = warbandProxy:GetGroupTabData()
  elseif self.curTab == 3 then
    tabData = warbandProxy:GetFinalRoundGroupTabData()
  end
  if #tabData < 1 then
    redlog("[cup] 服务器推送对战图数据为空")
    return
  end
  self.tabCtl:ResetDatas(tabData)
  self:FirstClickTab()
  self:UpdateBattleLine()
  self:UpdateBattleView()
  self:UpdateBtnByMyband()
end

function WarbandOpponentView:AddEvts()
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandTreeMatchCCmd, self.HandleQueryOpponent)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandTeamListMatchCCmd, self.UpdateSignupTeamList)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandInfoMatchCCmd, self.UpdateBtnByMyband)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandLeaveMatchCCmd, self.UpdateBtnByMyband)
  self:AddListenEvt(ServiceEvent.MatchCCmdTwelveWarbandQueryMatchCCmd, self.HandleQueryMember)
end

function WarbandOpponentView:OnEnter()
  WarbandOpponentView.super.OnEnter(self)
  self:InitLine()
end

function WarbandOpponentView:OnExit()
  PictureManager.Instance:UnLoadPVP(PVP_LINE_TEXTURE_NAME, self.tex1)
  PictureManager.Instance:UnLoadPVP(PVP_LINE_TEXTURE_NAME, self.tex2)
  warbandProxy:SetOpponentStatus(false)
  WarbandOpponentView.super.OnExit(self)
end

function WarbandOpponentView:UpdateStepChoose(tab)
  if not tab then
    return
  end
  xdlog("UpdateStepChoose", tab)
  self.curTab = tab
  self:UpdateBattleInfo()
end
