autoImport("WarbandOpponentGroupTab")
autoImport("WarbandOpponentCell")
autoImport("WarbandListCombineCell")
autoImport("WarbandWinsCell")
CupModeScheduleSubview = class("CupModeScheduleSubview", SubView)
local GRAY_LABEL_COLOR = Color(0.5764705882352941, 0.5686274509803921, 0.5686274509803921, 1)
local BTN_SP = {
  "com_btn_3s",
  "com_btn_13s"
}
local PVP_LINE_TEXTURE_NAME = "pvp_bg_01"
local viewPath = ResourcePathHelper.UIView("CupModeScheduleSubview")
local viewName = "CupModeScheduleSubview"
local colorArray = {
  Color(0.7725490196078432, 0.7725490196078432, 0.7725490196078432, 1),
  Color(1.0, 1.0, 1.0, 1)
}
local spriteName = {
  "com_bg_line",
  "12pvp_CupMatch_Bright-line"
}
local _cellName = "CupModeForbiddenPro"
local _cellSize = 0.4

function CupModeScheduleSubview:Init()
  self.proxy = CupMode6v6Proxy.Instance
  self:LoadSubviews()
  self:FindObjs()
  self:AddBtnEvts()
  self:AddViewEvts()
  self:InitShow()
end

function CupModeScheduleSubview:LoadSubviews()
  self.rootGO = self:FindGO(viewName, self.gameObject)
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.rootGO, true)
  obj.name = viewName
end

function CupModeScheduleSubview:FindObjs()
  local texRoot = self:FindGO("TextureRoot", self.rootGO)
  self.tex1 = self:FindComponent("Texture1", UITexture, texRoot)
  self.tex2 = self:FindComponent("Texture2", UITexture, texRoot)
  self.tex3 = self:FindComponent("Texture3", UITexture, texRoot)
  self.groupRoot = self:FindGO("GroupRoot", self.rootGO)
  local bandGridLeft = self:FindComponent("BandGridLeft", UIGrid, self.groupRoot)
  self.groupBandLeftCtl = UIGridListCtrl.new(bandGridLeft, WarbandOpponentCell, "WarbandOpponentCell")
  self.groupBandLeftCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickOpponentCell, self)
  local bandGridRight = self:FindComponent("BandGridRight", UIGrid, self.groupRoot)
  self.groupBandRightCtl = UIGridListCtrl.new(bandGridRight, WarbandOpponentCell, "WarbandOpponentCell")
  self.groupBandRightCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickOpponentCell, self)
  self.groupLineRoot = self:FindGO("LineRoot", self.groupRoot)
  self.curTabIndex = 1
  self.opponentRoot = self:FindGO("OpponentRoot", self.rootGO)
  self.tabScrollView = self:FindComponent("TabScrollView", UIScrollView, self.opponentRoot)
  self.tabGrid = self:FindComponent("TabGrid", UIGrid, self.rootGO)
  self.tabCtl = UIGridListCtrl.new(self.tabGrid, WarbandOpponentGroupTab, "WarbandOpponentGroupTab")
  self.tabCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickGroupTab, self)
  self.signupRoot = self:FindGO("SignupRoot", self.rootGO)
  self.signupScrollView = self:FindComponent("ListScrollView", UIScrollView, self.signupRoot)
  self.signupPanel = self:FindComponent("ListScrollView", UIPanel, self.signupRoot)
  local container = self:FindGO("Wrap", self.rootGO)
  local config = {
    wrapObj = container,
    pfbNum = 5,
    cellName = "WarbandListCombineCell",
    control = WarbandListCombineCell,
    dir = 1,
    disableDragIfFit = true
  }
  self.signupEmpty = self:FindComponent("SignupEmpty", UILabel, self.rootGO)
  self.signupEmpty.text = ZhString.Warband_NoSignupData
  self.bandListCtl = WrapCellHelper.new(config)
  self.bandListCtl:AddEventListener(MouseEvent.MouseClick, self.ClickBandTeamCell, self)
  self.scheduleLab = self:FindComponent("ScheduleLabOpp", UILabel, self.rootGO)
  self.teamNumLab = self:FindComponent("NumLab", UILabel, self.rootGO)
  self.seasonRewardBtn = self:FindGO("SeasonRewardBtn", self.rootGO)
  self.seasonRankBtn = self:FindGO("SeasonRankBtn", self.rootGO)
  self.signupBtn = self:FindGO("SignupBtn", self.signupRoot)
  self.signupBtnLabel = self:FindComponent("Label", UILabel, self.signupBtn)
  self.myWarbandBtn = self:FindGO("WarbandInfoBtn", self.rootGO)
  self.matchBtn = self:FindComponent("MatchBtn", UISprite, self.opponentRoot)
  self.matchLab = self:FindComponent("Label", UILabel, self.matchBtn.gameObject)
  local proPrefab = self:_loadForbiddenProPfb()
  self.cupModeForbiddenPro = CupModeForbiddenPro.new(proPrefab)
end

function CupModeScheduleSubview:_loadForbiddenProPfb()
  local cellpfb = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell(_cellName))
  if nil == cellpfb then
    redlog("can not find cellpfb", _cellName)
    return
  end
  cellpfb.transform:SetParent(self.rootGO.transform, false)
  cellpfb.transform.localScale = LuaGeometry.GetTempVector3(_cellSize, _cellSize, _cellSize)
  return cellpfb
end

function CupModeScheduleSubview:AddBtnEvts()
  self:AddClickEvent(self.seasonRewardBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.TeamPwsRewardPopUp,
      viewdata = {
        proxy = self.proxy
      }
    })
  end)
  self:AddClickEvent(self.seasonRankBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CupModeRankPopup,
      viewdata = {
        proxy = self.proxy
      }
    })
  end)
  self:AddClickEvent(self.signupBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CupModeSignupPopup,
      viewdata = {
        proxy = self.proxy
      }
    })
  end)
  self:AddClickEvent(self.myWarbandBtn, function(go)
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.CupModeSignupPopup,
      viewdata = {
        proxy = self.proxy
      }
    })
  end)
  self:AddClickEvent(self.matchBtn.gameObject, function(go)
    local match = self.proxy:DoMatch()
    if match then
      self.container:CloseSelf()
    end
  end)
end

function CupModeScheduleSubview:AddViewEvts()
  self:AddListenEvt(CupModeEvent.Tree_6v6, self.HandleQueryOpponent)
  self:AddListenEvt(CupModeEvent.TeamList_6v6, self.UpdateSignupTeamList)
  self:AddListenEvt(CupModeEvent.BandInfo_6v6, self.UpdateBtnByMyband)
  self:AddListenEvt(CupModeEvent.Leave_6v6, self.UpdateBtnByMyband)
  self:AddListenEvt(CupModeEvent.QueryBand_6v6, self.HandleQueryMember)
  self:AddListenEvt(CupModeEvent.Fighting_6v6, self.UpdateFightingTime)
  self:AddListenEvt(CupModeEvent.SeasonInfo_6v6, self.UpdateBattleView)
end

function CupModeScheduleSubview:InitShow()
  PictureManager.Instance:SetPVP(PVP_LINE_TEXTURE_NAME, self.tex1)
  PictureManager.Instance:SetPVP(PVP_LINE_TEXTURE_NAME, self.tex2)
  self.curTab = -1
end

function CupModeScheduleSubview:FirstClickTab()
  local myGroup = 0
  if self.curTab == 1 then
    myGroup = self.proxy:CheckInPreParticipants()
  elseif self.curTab == 2 then
    myGroup = self.proxy:CheckInParticipants()
  elseif self.curTab == 3 then
    myGroup = self.proxy:CheckInFinal()
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

function CupModeScheduleSubview:ClickBandTeamCell(cellctl)
  local data = cellctl and cellctl.data
  if data then
    self.proxy:DoQueryBand(0, data.id)
  end
end

function CupModeScheduleSubview:InitLine()
  if nil ~= self.firstRoundLine then
    return
  end
  self.firstRoundLine = {}
  self.secondLine = {}
  self.firstRoundStars = {}
  self.secondRoundStars = {}
  for group = 1, 4 do
    local parent = self:FindGO("Group_" .. group, self.groupLineRoot)
    for i = 1, 0, -1 do
      local id = group * 2 - i
      local sp1 = self:FindComponent("Round_1_ID_" .. group * 2 - i, UISprite, parent)
      local sp1_1 = self:FindComponent("SubLine", UISprite, sp1.gameObject)
      self.firstRoundLine[id] = {sp1, sp1_1}
      local winCell = self:FindGO("starGrid", sp1.gameObject)
      self.firstRoundStars[id] = WarbandWinsCell.new(winCell)
    end
    local sp2 = self:FindComponent("Round_2_" .. group, UISprite, parent)
    local sp2_2 = self:FindComponent("SubLine", UISprite, sp2.gameObject)
    self.secondLine[group] = {sp2, sp2_2}
    local winCell = self:FindGO("starGrid", sp2.gameObject)
    self.secondRoundStars[group] = WarbandWinsCell.new(winCell)
  end
end

function CupModeScheduleSubview:ReUnitData(datas, rowNum)
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

function CupModeScheduleSubview:OnClickGroupTab(cell)
  local data = cell.data
  if not data then
    return
  end
  self.curTabData = data
  self:UpdateBattleLine(true)
end

function CupModeScheduleSubview:OnClickOpponentCell(ctl)
  local data = ctl and ctl.data
  if data and data.id then
    self.tipStick = ctl.bg
    self.proxy:DoQueryBand(0, data.id)
  end
end

function CupModeScheduleSubview:HandleQueryMember(note)
  local data = note.body
  local season = data and data.season
  if season < 10000 then
    xdlog("HandleQueryMember", self.proxy.proxyName)
    TipManager.Instance:ShowTeamMemberTip({
      memberData = self.proxy.memberinfoData,
      teamName = self.proxy.memberinfoTeamName
    })
  end
end

function CupModeScheduleSubview:UpdateMatchBtn()
  local haveWarband = self.proxy:IHaveWarband()
  local matchTimeValid = self.proxy:CheckMatchTimeValid()
  self.matchBtn.gameObject:SetActive(haveWarband)
  if haveWarband then
    local curStage = self.proxy:GetCurStage() or 0
    local hasMatchAuthority = 0
    if self.curTab == 1 then
      hasMatchAuthority = self.proxy:CheckInPreParticipants()
    elseif self.curTab == 2 then
      hasMatchAuthority = self.proxy:CheckInParticipants()
    elseif self.curTab == 3 then
      hasMatchAuthority = self.proxy:CheckInFinal()
    end
    xdlog("hasMatchAuthority", hasMatchAuthority)
    if hasMatchAuthority ~= 0 and curStage == self.curTab then
      self.matchBtn.gameObject:SetActive(true)
    else
      self.matchBtn.gameObject:SetActive(false)
    end
    self.matchBtn.spriteName = matchTimeValid and BTN_SP[1] or BTN_SP[2]
    self.matchLab.effectColor = matchTimeValid and ColorUtil.ButtonLabelGreen or GRAY_LABEL_COLOR
  end
end

function CupModeScheduleSubview:UpdateBattleView()
  local bandcount = 0
  if self.curTab and self.curTab == 1 then
    bandcount = self.proxy:GetPreRoundOpponentCount()
    self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(bandcount))
  elseif self.curTab and self.curTab == 3 then
    local curStage = self.proxy:GetCurStage()
    if curStage and curStage == 3 then
      self.teamNumLab.text = ZhString.Warband_FinalIsReady
    elseif curStage and curStage < 3 then
      self.teamNumLab.text = ZhString.Warband_StageReady
    else
      self.teamNumLab.text = ZhString.Warband_StageFinish
    end
  else
    bandcount = self.proxy:GetOpponentCount()
    self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(bandcount))
  end
  self:UpdateMatchBtn()
  self:UpdateFightingTime()
  local invalidData = self.proxy.forbiddenPro
  self.cupModeForbiddenPro:SetData(invalidData)
  if invalidData and 0 < #invalidData then
    self:ResizeSignUpListScrollView(2)
  else
    self:ResizeSignUpListScrollView(1)
  end
end

local signUpSVParam = {
  [1] = {offsetY = 0, height = 374},
  [2] = {offsetY = 20, height = 330}
}

function CupModeScheduleSubview:ResizeSignUpListScrollView(type)
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

function CupModeScheduleSubview:UpdateFightingTime()
  local curStage = self.proxy:GetCurStage()
  if curStage < self.curTab then
    self.scheduleLab.text = ZhString.Warband_StageReady
  elseif curStage > self.curTab then
    self.scheduleLab.text = ZhString.Warband_StageFinish
  else
    self.scheduleLab.text = self.proxy:GetFightCDTime()
  end
end

function CupModeScheduleSubview:UpdateBtnByMyband()
  local hasSignup = self.proxy:CheckHasSignup()
  local isCaptain = self.proxy:CheckBandAuthority()
  self.signupBtn:SetActive(isCaptain or not hasSignup)
  self.signupBtnLabel.text = hasSignup and isCaptain and ZhString.Warband_EditBand or ZhString.Warband_Register
  local curStage = self.proxy:GetCurStage()
  self.myWarbandBtn:SetActive(self.proxy:IHaveWarband() and curStage ~= 4)
  self:UpdateMatchBtn()
end

function CupModeScheduleSubview:UpdateBattleLine(noResetTab)
  if not self.curTabData then
    redlog("未同步对战图数据")
    return
  end
  if self.firstRoundLine == nil then
    return
  end
  local opponentData
  if self.curTab == 1 then
    opponentData = self.proxy:GetPreRoundOpponentData(self.curTabData)
  elseif self.curTab == 2 then
    opponentData = self.proxy:GetOpponentData(self.curTabData)
  elseif self.curTab == 3 then
    opponentData = self.proxy:GetFinalRoundOpponentData(self.curTabData)
  end
  if not opponentData then
    redlog("暂无对手数据", self.curTabData)
    return
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
    self.firstRoundStars[j]:SetData(opponentData[j].starsone)
    self.firstRoundStars[j + 1]:SetData(opponentData[j + 1].starsone)
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
  for _group, _secondStar in pairs(self.secondRoundStars) do
    _secondStar:SetData(0)
  end
  for i = 1, 8 do
    if 2 <= opponentData[i].wintimes then
      local group = (i + 1) // 2
      local star = opponentData[i] and opponentData[i].starstwo or 0
      if group and self.secondRoundStars[group] then
        self.secondRoundStars[group]:SetData(star)
      elseif self.secondRoundStars[group] then
        self.secondRoundStars[group]:SetData(0)
      end
    end
  end
  local curStage = self.proxy:GetCurStage()
  local isStageFinish = curStage > self.curTab
  local groupMaxWintime = math.max(maxWintime_left, maxWintime_right)
  local leftCells = self.groupBandLeftCtl:GetCells()
  local rightCells = self.groupBandRightCtl:GetCells()
  for i = 1, #leftCells do
    if self.curTab == 1 or self.curTab == 2 then
      leftCells[i]:SetPromotionSymbol(isStageFinish and leftCells[i].data.wintimes == groupMaxWintime or false)
    else
      leftCells[i]:SetPromotionSymbol(false)
    end
  end
  for i = 1, #rightCells do
    if self.curTab == 1 or self.curTab == 2 then
      rightCells[i]:SetPromotionSymbol(isStageFinish and rightCells[i].data.wintimes == groupMaxWintime or false)
    else
      rightCells[i]:SetPromotionSymbol(false)
    end
  end
end

function CupModeScheduleSubview:UpdateSecondRoundLine(group, winnerIndex)
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

function CupModeScheduleSubview:UpdateSignupTeamList()
  local data = self.proxy:GetSignupWarbandList()
  redlog("报名列表队伍数： ", #data)
  self.bandListCtl:ResetDatas(self:ReUnitData(data, 2))
  self.signupEmpty.gameObject:SetActive(#data < 1)
  self.teamNumLab.text = string.format(ZhString.Warband_OppenentCount, tostring(#data))
  self.scheduleLab.text = ZhString.Warband_IsInSignup
  local invalidData = self.proxy.forbiddenPro
  self.cupModeForbiddenPro:SetData(invalidData)
  if invalidData and 0 < #invalidData then
    self:ResizeSignUpListScrollView(2)
  else
    self:ResizeSignUpListScrollView(1)
  end
end

function CupModeScheduleSubview:SwitchSignup(isSignup)
  xdlog("SwitchSignup", isSignup)
  self.signupRoot:SetActive(isSignup)
  self.opponentRoot:SetActive(not isSignup)
  self:UpdateBtnByMyband()
  self.proxy:SetOpponentStatus(not isSignup)
  if isSignup then
    self:UpdateSignupTeamList()
    self.proxy:DoQueryTeamList()
  else
    self:UpdateBattleView()
  end
end

function CupModeScheduleSubview:HandleQueryOpponent()
  local preRoundData = self.proxy:GetPreRoundGroupTabData()
  local hasPreRound = preRoundData and 0 < #preRoundData and true or false
  local mainRoundData = self.proxy:GetGroupTabData()
  local hasMainRound = mainRoundData and 0 < #mainRoundData and true or false
  local finalRoundData = self.proxy:GetFinalRoundGroupTabData()
  local hasFinalRound = finalRoundData and 0 < #finalRoundData and true or false
  if not hasPreRound and not hasMainRound and not hasFinalRound then
    redlog("[cup] 服务器推送对战图数据为空")
    return
  end
  if not self.initedData then
    self.initedData = true
    local curStage = self.proxy:GetCurStage() or 0
    xdlog("curStage", curStage, self.proxy.proxyName)
    if 3 <= curStage then
      self.curTab = 3
    else
      self.curTab = curStage
    end
  end
  self:UpdateBattleInfo()
end

function CupModeScheduleSubview:UpdateBattleInfo()
  local tabData
  xdlog("当前类型选项", self.curTab)
  if self.curTab == 1 then
    tabData = self.proxy:GetPreRoundGroupTabData()
  elseif self.curTab == 2 then
    tabData = self.proxy:GetGroupTabData()
  elseif self.curTab == 3 then
    tabData = self.proxy:GetFinalRoundGroupTabData()
  end
  if not tabData or #tabData < 1 then
    redlog("[cup] 服务器推送对战图数据为空")
    return
  end
  self.tabCtl:ResetDatas(tabData)
  self:FirstClickTab()
  self:UpdateBattleLine()
  self:UpdateBattleView()
  self:UpdateBtnByMyband()
end

function CupModeScheduleSubview:OnEnter()
  CupModeScheduleSubview.super.OnEnter(self)
  self:InitLine()
end

function CupModeScheduleSubview:OnExit()
  self.proxy:SetOpponentStatus(false)
  CupModeScheduleSubview.super.OnExit(self)
  self.cupModeForbiddenPro:OnCellDestroy()
end

function CupModeScheduleSubview:OnDestroy()
  CupModeScheduleSubview.super.OnDestroy(self)
  PictureManager.Instance:UnLoadPVP(PVP_LINE_TEXTURE_NAME, self.tex1)
  PictureManager.Instance:UnLoadPVP(PVP_LINE_TEXTURE_NAME, self.tex2)
end

function CupModeScheduleSubview:UpdateStepChoose(tab)
  if not tab then
    return
  end
  xdlog("UpdateStepChoose", tab)
  self.curTab = tab
  self:UpdateBattleInfo()
end
