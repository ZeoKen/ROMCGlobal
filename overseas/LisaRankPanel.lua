LisaRankPanel = class("LisaRankPanel", ContainerView)
LisaRankPanel.ViewType = UIViewType.PopUpLayer
autoImport("LisaRankCell")

function LisaRankPanel:Init()
  helplog("LisaRankPanel:Init")
  self.roleTexture = self:FindComponent("RoleTexture", UITexture)
  local roleDetail = self:FindGO("RoleDetail")
  self.winnerNameLabel = self:FindGO("Name", roleDetail):GetComponent(UILabel)
  self.ranksInfo = {}
  self.clickCell = nil
  self.winnerCharId = 0
  self.winnerName = ""
  self.myranking = ""
  self.curPageIndex = -1
  self.pageCount = 9999999
  self:AddListenEvt(ServiceEvent.OverseasTaiwanCmdTaiwanRankLisaCmd, self.HandleReceLisaRanks)
  self:AddListenEvt(ServiceEvent.ChatCmdQueryUserShowInfoCmd, self.HandleQueryUserShowInfoCmd)
  self:AddListenEvt(ServiceEvent.SessionSocialityFindUser, self.UpdateSearchList)
  self:GetMoreRankInfos()
  self.gettingMore = false
  self.HelpButton = self:FindGO("InfoButton", self:FindGO("Header"))
  self:AddClickEvent(self.HelpButton, function()
    local helpData = Table_Help[20007]
    TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
    if helpData then
    end
  end)
  if self.HelpButton then
  end
end

function LisaRankPanel:GetMoreRankInfos()
  if not self.gettingMore then
    if self.curPageIndex < self.pageCount - 1 then
      local getPageIndex = self.curPageIndex + 1
      helplog("LisaRankPanel:GetMoreRankInfos", getPageIndex)
      self.gettingMore = true
      ServiceOverseasTaiwanCmdProxy.Instance:CallTaiwanRankLisaCmd(getPageIndex)
    else
      helplog("no more page")
    end
  end
end

function LisaRankPanel:HandleReceLisaRanks(data)
  helplog("HandleReceLisaRanks")
  helplog(data.body)
  self.curPageIndex = data.body.pageindex
  self.pageCount = data.body.pagecount
  self.myranking = data.body.myranking
  self.mycount = data.body.mycount
  for i = 1, #data.body.list do
    local v = data.body.list[i]
    if v and v.rank then
      table.insert(self.ranksInfo, {
        charid = v.charid,
        mouth = v.mouth,
        rank = v.rank,
        hair = v.hair,
        profession = v.profession,
        body = v.body,
        count = v.count,
        head = v.head,
        blink = v.blink,
        eye = v.eye,
        name = v.name,
        face = v.face,
        gender = v.gender,
        charid = v.charid,
        portrait = v.portrait,
        haircolor = v.haircolor
      })
      if v.rank == 1 then
        self.winnerCharId = v.charid
        self.winnerName = v.name
      end
    end
  end
  table.sort(self.ranksInfo, function(a, b)
    return a.rank < b.rank
  end)
  self:RefreshData(self.ranksInfo)
  self:RefreshWinnerInfo()
  self.gettingMore = false
end

function LisaRankPanel:HandleQueryUserShowInfoCmd(note)
  if not note or not note.body then
    return
  end
  local serverdata = note.body.info.datas
  if serverdata then
    self.mvpUserData = UserData.CreateAsTable()
    local sdata
    for i = 1, #serverdata do
      sdata = serverdata[i]
      if sdata then
        self.mvpUserData:SetByID(sdata.type, sdata.value, sdata.data)
      end
    end
  end
  local userdata = self.mvpUserData
  if not userdata then
    return
  end
  self.winnerNameLabel.text = self.winnerName
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndex.Body] = userdata:Get(UDEnum.BODY) or 0
  parts[partIndex.Hair] = userdata:Get(UDEnum.HAIR) or 0
  parts[partIndex.LeftWeapon] = userdata:Get(UDEnum.LEFTHAND) or 0
  parts[partIndex.RightWeapon] = userdata:Get(UDEnum.RIGHTHAND) or 0
  parts[partIndex.Head] = userdata:Get(UDEnum.HEAD) or 0
  parts[partIndex.Wing] = userdata:Get(UDEnum.BACK) or 0
  parts[partIndex.Face] = userdata:Get(UDEnum.FACE) or 0
  parts[partIndex.Tail] = userdata:Get(UDEnum.TAIL) or 0
  parts[partIndex.Eye] = userdata:Get(UDEnum.EYE) or 0
  parts[partIndex.Mount] = 0
  parts[partIndex.Mouth] = userdata:Get(UDEnum.MOUTH) or 0
  parts[partIndexEx.Gender] = userdata:Get(UDEnum.SEX) or 0
  parts[partIndexEx.HairColorIndex] = userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.EyeColorIndex] = userdata:Get(UDEnum.EYECOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = userdata:Get(UDEnum.CLOTHCOLOR) or 0
  self.model = Asset_Role.Create(parts)
  self.model:SetLayer(5)
  self.model:SetParent(self:FindGO("Role").transform, false)
  self.model:SetPosition(Vector3(456, -290, -150))
  self.model:SetEulerAngles(Vector3(5, 180, 0))
  self.model:SetScale(310)
  Asset_Role.DestroyPartArray(parts)
  TimeTickManager.Me():CreateOnceDelayTick(1000, function(owner, deltaTime)
    self.model:PlayAction_SimpleLoop(GameConfig.teamPVP.Victoryanimation, Asset_Role.ActionName.Idle, 1)
  end, self)
end

function LisaRankPanel:RefreshWinnerInfo()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
  ServiceChatCmdProxy.Instance:CallQueryUserShowInfoCmd(self.winnerCharId)
end

function LisaRankPanel:HandleClickRank(cellctr)
  if self.clickCell == nil then
    self.clickCell = cellctr
    ServiceSessionSocialityProxy.Instance:CallFindUser(cellctr.data.name, nil)
  end
end

function LisaRankPanel:UpdateSearchList()
  local datas = FriendProxy.Instance:GetSearchData()
  local userData
  for k, v in pairs(datas) do
    if v.name == self.clickCell.data.name then
      userData = v
      break
    end
  end
  self.clickCell:ShowPlayerTip(userData, function()
    self.clickCell = nil
  end)
end

function LisaRankPanel:RefreshData(listData)
  if self.ranks == nil then
    local scrollViewObj = self:FindGO("ScrollView")
    self.scrollView = scrollViewObj:GetComponent(UIScrollView)
    local ranksGrid = self:FindGO("Grid", scrollViewObj):GetComponent(UIGrid)
    self.ranks = UIGridListCtrl.new(ranksGrid, LisaRankCell, "LisaRankCell")
    self.ranks:AddEventListener(MouseEvent.MouseClick, self.HandleClickRank, self)
    
    function self.scrollView.onDragFinished()
      local offset = self.scrollView.panel:CalculateConstrainOffset(self.scrollView.bounds.min, self.scrollView.bounds.min)
      if offset.y < 200 then
        self:GetMoreRankInfos()
      end
    end
  end
  self.ranks:ResetDatas(listData)
  if self.curPageIndex == 0 then
    self.scrollView:ResetPosition()
  end
  self.selfCell = self:FindGO("UserLisaRankCell")
  local cellCtrl = LisaRankCell.new(self.selfCell)
  if self.ProfessionIcon == nil then
    self.ProfessionIcon = self:FindGO("ProfessIcon", self.selfCell):GetComponent(UISprite)
    self.professIconBG = self:FindGO("CareerBg", self.selfCell):GetComponent(UISprite)
  end
  local profession = Game.Myself.data.userdata:Get(UDEnum.PROFESSION)
  local config = Table_Class[profession]
  if config then
    IconManager:SetProfessionIcon(config.icon, self.ProfessionIcon)
    local iconColor = ColorUtil["CareerIconBg" .. config.Type]
    if iconColor == nil then
      iconColor = ColorUtil.CareerIconBg0
    end
    self.professIconBG.color = iconColor
  end
  cellCtrl:SetData({
    mine = true,
    count = self.mycount,
    rank = self.myranking
  })
end

function LisaRankPanel:OnEnter()
  self.super.OnEnter(self)
  helplog("LisaRankPanel:OnEnter")
end

function LisaRankPanel:OnExit()
  self.super.OnExit(self)
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
  self.scrollView.onDragFinished = nil
end
