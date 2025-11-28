autoImport("DisneyRankMemberCell")
autoImport("DisneySongCombineCell")
DisneyMusicView = class("DisneyMusicView", ContainerView)
DisneyMusicView.ViewType = UIViewType.NormalLayer
local _TeamProxy, _DisneyStageProxy, _HasAuthority
local _GramophoneTexName = "Disney_stage_bg_Record-player"
local _MusicPlayingSymbolTexName = "Disney_stage_Note"
local _MusicPauseStatus = {
  "Disney_stage_btn_time-out",
  "new_com_btn_arrow_03"
}
local playerTipOffset = {-40, 18}
local playerTipFunc = {
  "SendMessage",
  "AddFriend",
  "ShowDetail"
}
local playerTipFunc_Friend = {
  "SendMessage",
  "ShowDetail"
}
local rankSp = {
  "tab_icon_15",
  "tab_icon_109"
}
local _BtnSpName = {
  "new-com_btn_a_gray",
  "new-com_btn_a"
}
local _BtnLabOutlineColor = {
  Color(0.39215686274509803, 0.40784313725490196, 0.4627450980392157, 1),
  Color(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
}
local _GrayLabColor = Color(0.9372549019607843, 0.9372549019607843, 0.9372549019607843, 1)
local _WhiteLabColor = ColorUtil.NGUIWhite
local ReUniteCellData = function(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end

function DisneyMusicView:Init()
  _TeamProxy = TeamProxy.Instance
  _DisneyStageProxy = DisneyStageProxy.Instance
  _SongSelected = _DisneyStageProxy:CheckSongSelected()
  _HasAuthority = _TeamProxy:CheckIHaveLeaderAuthority()
  self.playerTipInitData = {}
  self:FindObj()
  self:AddEvent()
end

function DisneyMusicView:FindObj()
  self.songNameLab = self:FindComponent("PlayingSongLab", UILabel)
  self.startGameBtn = self:FindComponent("startGameBtn", UISprite)
  self:AddClickEvent(self.startGameBtn.gameObject, function(go)
    if not _SongSelected then
      helplog("还未选择音乐,服务器未记录当前MusicID")
      return
    end
    helplog("DisneyStage -------> CallDisneyMusicStartCmd")
    ServiceDisneyActivityProxy.Instance:CallDisneyMusicStartCmd()
  end)
  self.startGameLab = self:FindComponent("Lab", UILabel, self.startGameBtn.gameObject)
  self.startGameLab.text = ZhString.DisneyMusicalStartGame
  self.startGameTipLab = self:FindComponent("TipLab", UILabel, self.startGameBtn.gameObject)
  self.startGameTipLab.text = ZhString.DisneyMusicalStartGameTip
  self.musicBtn = self:FindComponent("MusicBtn", UISprite)
  self:AddClickEvent(self.musicBtn.gameObject, function(go)
    if not self.paused then
      self.paused = true
      self.musicBtn.spriteName = _MusicPauseStatus[2]
      _DisneyStageProxy:DoPause()
    else
      self.paused = false
      self.musicBtn.spriteName = _MusicPauseStatus[1]
      _DisneyStageProxy:DoResume()
    end
  end)
  self.texture = self:FindComponent("GramophoneTex", UITexture)
  self.musicPlayingTex = self:FindComponent("MusicPlayingSymbolTex", UITexture)
  self.rankPageRoot = self:FindGO("RankPageRoot")
  self.rankDetaiPageRoot = self:FindGO("RankDetaiPageRoot")
  self.rankDetaiPageRoot:SetActive(false)
  self.rankArrowBtn = self:FindGO("Arrow")
  self:AddClickEvent(self.rankArrowBtn, function(go)
    self.rankDetaiPageRoot:SetActive(true)
    self.rankPageRoot:SetActive(false)
    self:DisplayDetailRankList()
  end)
  self.rankDetailArrowBtn = self:FindGO("DetailArrow")
  self:AddClickEvent(self.rankDetailArrowBtn, function(go)
    self.rankDetaiPageRoot:SetActive(false)
    self.rankPageRoot:SetActive(true)
  end)
  self.songPageRoot = self:FindGO("SongPageRoot")
  self.songPageRoot:SetActive(true)
  self.rankPageRoot:SetActive(false)
  local rankWrap = self:FindGO("RankWrapContent")
  local wrapConfig
  wrapConfig = {
    wrapObj = rankWrap,
    cellName = "DisneyRankMemberCell",
    control = DisneyRankMemberCell
  }
  self.rankWraplist = WrapCellHelper.new(wrapConfig)
  self.rankWraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickRankMember, self)
  local detailRankWrap = self:FindGO("DetailRankWrapContent")
  wrapConfig = {
    wrapObj = detailRankWrap,
    cellName = "DisneyRankMemberCell",
    control = DisneyRankMemberCell
  }
  self.detailRankWraplist = WrapCellHelper.new(wrapConfig)
  self.detailRankWraplist:AddEventListener(MouseEvent.MouseClick, self.OnClickRankMember, self)
  self.optionBtn = self:FindComponent("OptionBtn", UISprite)
  self.optionBoxColider = self.optionBtn.gameObject:GetComponent(BoxCollider)
  self.optionBtnDesc = self:FindComponent("Lab", UILabel, self.optionBtn.gameObject)
  self.memberOptionDesc = self:FindComponent("MemberOptionDesc", UILabel)
  self.memberOptionDesc.text = ZhString.DisneyMusical_MemberDesc
  self.rankBtn = self:FindComponent("RankBtn", UISprite)
  self:AddClickEvent(self.rankBtn.gameObject, function(go)
    if self.rankPageRoot.activeSelf then
      self.songPageRoot:SetActive(true)
      self.rankPageRoot:SetActive(false)
      self.rankDetaiPageRoot:SetActive(false)
      IconManager:SetUIIcon(rankSp[1], self.rankBtn)
    else
      self.songPageRoot:SetActive(false)
      self.rankPageRoot:SetActive(true)
      self.rankDetaiPageRoot:SetActive(false)
      _DisneyStageProxy:QueryMusicGameRank()
      IconManager:SetUIIcon(rankSp[2], self.rankBtn)
    end
    self.rankBtn:MakePixelPerfect()
  end)
  self:AddClickEvent(self.optionBtn.gameObject, function()
    if not _DisneyStageProxy:IsNowPlayingServerSong() then
      local nowSong = DisneyStageProxy.Instance:GetNowPlayingSong()
      redlog("------DisneyStage CallDisneyMusicChooseMusicCmd: ", nowSong)
      ServiceDisneyActivityProxy.Instance:CallDisneyMusicChooseMusicCmd(nowSong)
    end
  end)
  self.emptyRankLab = self:FindComponent("EmptyRank", UILabel)
  self.emptyRankLab.text = ZhString.DisneyMusicalEmptyRankData
  local songContainer = self:FindGO("SongContainer")
  local wrapConfig = {}
  wrapConfig.wrapObj = songContainer
  wrapConfig.pfbNum = 5
  wrapConfig.cellName = "DisneySongCombineCell"
  wrapConfig.control = DisneySongCombineCell
  self.songHelper = WrapCellHelper.new(wrapConfig)
  self.songHelper:AddEventListener(MouseEvent.MouseClick, self.OnClickSongCell, self)
end

function DisneyMusicView:ChooseMusic(id)
  local cellCtls = self.songHelper:GetCellCtls()
  for i = 1, #cellCtls do
    local single = cellCtls[i]:GetCells()
    for j = 1, #single do
      single[j]:SetChooseId(id)
    end
  end
end

function DisneyMusicView:OnClickSongCell(cellCtl)
  local cellData = cellCtl and cellCtl.data
  if cellData then
    _DisneyStageProxy:SetCurplayingMusic(cellData.id)
    self:RefreshSong()
    self:ChooseMusic(cellData.id)
  end
end

function DisneyMusicView:OnClickRankMember(cellCtl)
  local data = cellCtl.data
  if cellCtl == self.curCell or data.id == Game.Myself.data.id then
    FunctionPlayerTip.Me():CloseTip()
    self.curCell = nil
    return
  end
  self.curCell = cellCtl
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(cellCtl.portraitCell.headIconCell.frameSp, NGUIUtil.AnchorSide.TopRight, playerTipOffset)
  local player = PlayerTipData.new()
  player:SetByDisneyRankMemberData(data)
  TableUtility.TableClear(self.playerTipInitData)
  self.playerTipInitData.playerData = player
  self.playerTipInitData.funckeys = FriendProxy.Instance:IsFriend(data.id) and playerTipFunc_Friend or playerTipFunc
  playerTip:SetData(self.playerTipInitData)
  playerTip:AddIgnoreBound(cellCtl.portraitCell.gameObject)
  
  function playerTip.clickcallback(funcData)
    if funcData.key == "SendMessage" then
      self:OnExit()
    end
  end
  
  function playerTip.closecallback()
    self.curCell = nil
  end
end

function DisneyMusicView:OnEnterSong()
  _DisneyStageProxy:InitSongs()
  self.songPageRoot:SetActive(true)
  self.rankPageRoot:SetActive(false)
  local songs = _DisneyStageProxy:GetSongs()
  local newSongs = ReUniteCellData(songs, 3)
  self.songHelper:UpdateInfo(newSongs)
  self:DisplayChoosenMusic()
end

function DisneyMusicView:RefreshAuthorityInfo()
  self.startGameBtn.gameObject:SetActive(_HasAuthority)
  self.memberOptionDesc.gameObject:SetActive(not _HasAuthority)
  self.optionBtn.gameObject:SetActive(_HasAuthority)
end

local selectSongBtnLabColor = {
  Color(0.7411764705882353, 0.5254901960784314, 0 / 255),
  Color(0.403921568627451, 0.40784313725490196, 0.4627450980392157)
}

function DisneyMusicView:RefreshSong()
  local nowSong = _DisneyStageProxy:GetNowPlayingSong()
  redlog("nowSong : ", nowSong)
  if not nowSong then
    self.musicBtn.gameObject:SetActive(false)
    self.songNameLab.text = _HasAuthority and ZhString.DisneyMusicalSelect or ZhString.DisneyMusicalSelect_Wait
    self:Hide(self.musicPlayingTex)
    return
  end
  if not Table_DisneySong then
    return
  end
  self.startGameTipLab.gameObject:SetActive(not _SongSelected)
  self.startGameBtn.spriteName = _SongSelected and "new-com_btn_c" or "new-com_btn_a_gray"
  self.startGameLab.effectColor = _SongSelected and selectSongBtnLabColor[1] or selectSongBtnLabColor[2]
  self.musicBtn.gameObject:SetActive(true)
  self.musicBtn.spriteName = _MusicPauseStatus[1]
  self:Show(self.musicPlayingTex)
  local isNowPlayingServerSong = _DisneyStageProxy:IsNowPlayingServerSong()
  if isNowPlayingServerSong then
    self.optionBtnDesc.text = ZhString.DisneyMusical_CurMusic
    self.optionBtnDesc.color = _GrayLabColor
    self.optionBtnDesc.effectColor = _BtnLabOutlineColor[1]
    self.optionBtn.spriteName = _BtnSpName[1]
    self.optionBoxColider.enabled = false
  else
    self.optionBtnDesc.text = ZhString.DisneyMusical_ChangeMusic
    self.optionBtnDesc.color = _WhiteLabColor
    self.optionBtnDesc.effectColor = _BtnLabOutlineColor[2]
    self.optionBtn.spriteName = _BtnSpName[2]
    self.optionBoxColider.enabled = true
  end
end

function DisneyMusicView:DisplayChoosenMusic()
  local song = _DisneyStageProxy:GetServerSong()
  self.songNameLab.text = Table_DisneySong[song] and Table_DisneySong[song].Name
  self:ChooseMusic(song)
end

function DisneyMusicView:HandleAuthorityChanged()
  local newAuthority = _TeamProxy:CheckIHaveLeaderAuthority()
  if _HasAuthority == newAuthority then
    return
  end
  _HasAuthority = newAuthority
  self:RefreshAuthorityInfo()
end

function DisneyMusicView:HandleSongChanged()
  _SongSelected = _DisneyStageProxy:CheckSongSelected()
  if _HasAuthority then
    local newid = _DisneyStageProxy.curServerSong
    _DisneyStageProxy:SetCurplayingMusic(newid)
  end
  self:RefreshSong()
  self:DisplayChoosenMusic()
end

function DisneyMusicView:DisplayRankList()
  local ranks = _DisneyStageProxy:GetRankList()
  local isRankEmpty = #ranks < 1
  local result = {}
  for i = 1, 3 do
    result[#result + 1] = ranks[i]
  end
  self.rankWraplist:ResetDatas(result)
  self.emptyRankLab.gameObject:SetActive(isRankEmpty)
  self.rankArrowBtn:SetActive(not isRankEmpty)
end

function DisneyMusicView:DisplayDetailRankList()
  local ranks = _DisneyStageProxy:GetRankList()
  self.detailRankWraplist:ResetDatas(ranks, true)
end

function DisneyMusicView:HandleRank()
  self:DisplayRankList()
  self:DisplayDetailRankList()
end

function DisneyMusicView:AddEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamExitTeam, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.SessionTeamTeamMemberUpdate, self.HandleAuthorityChanged)
  self:AddListenEvt(ServiceEvent.SessionTeamMemberDataUpdate, self.HandleAuthorityChanged)
  self:AddListenEvt(DisneyEvent.DisneyMusicIdChanged, self.HandleSongChanged)
  self:AddListenEvt(ServiceEvent.DisneyActivityDisneyMusicRankCmd, self.HandleRank)
end

function DisneyMusicView:OnEnter()
  DisneyMusicView.super.OnEnter(self)
  self.paused = false
  _DisneyStageProxy:QueryDisneyMusicOpen()
  _DisneyStageProxy:SetCurplayingMusic()
  PictureManager.Instance:SetUI(_GramophoneTexName, self.texture)
  PictureManager.Instance:SetUI(_MusicPlayingSymbolTexName, self.musicPlayingTex)
  self:RefreshAuthorityInfo()
  self:RefreshSong()
  self:OnEnterSong()
end

function DisneyMusicView:OnExit()
  DisneyMusicView.super.OnExit(self)
  self.paused = false
  FunctionBGMCmd.Me():StopUIBgm()
  PictureManager.Instance:UnLoadUI(_GramophoneTexName, self.texture)
  PictureManager.Instance:UnLoadUI(_MusicPlayingSymbolTexName, self.musicPlayingTex)
end
