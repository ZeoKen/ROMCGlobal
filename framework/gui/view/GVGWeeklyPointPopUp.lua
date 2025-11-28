local _FixedTitleList
autoImport("GvgWeeklyPointCell")
GVGWeeklyPointPopUp = class("GVGWeeklyPointPopUp", ContainerView)
GVGWeeklyPointPopUp.ViewType = UIViewType.PopUpLayer
GVGWeeklyPointPopUp.BrotherView = GVGRankPopUp

function GVGWeeklyPointPopUp:InitFixedContext()
  if not _FixedTitleList then
    _FixedTitleList = {
      ZhString.GvgWeeklyPoint_Index,
      ZhString.GvgWeeklyPoint_Defense,
      ZhString.GvgWeeklyPoint_Attack,
      ZhString.GvgWeeklyPoint_PerfectDefense,
      ZhString.GvgWeeklyPoint_Occupied,
      ZhString.GvgWeeklyPoint_StepByStepOccupied,
      ZhString.GvgWeeklyPoint_PointScore,
      ZhString.GvgWeeklyPoint_Result
    }
    if GameConfig.GvgNewConfig.kill_mvp_score then
      _FixedTitleList[7] = ZhString.GvgWeeklyPoint_MVP
    end
  end
  self.fixedTitleLabs = {}
  local length = #_FixedTitleList
  for i = 1, length do
    self.fixedTitleLabs[i] = self:FindComponent("FixedTitle" .. i, UILabel)
    self.fixedTitleLabs[i].text = _FixedTitleList[i]
  end
end

function GVGWeeklyPointPopUp:InitGuildInfo()
  local guildInfoRoot = self:FindGO("GuildInfo")
  self.rankLab = self:FindComponent("RankLab", UILabel, guildInfoRoot)
  self.guildName = self:FindComponent("GuildNameLab", UILabel, guildInfoRoot)
  self.playerNameLab = self:FindComponent("PlayerNameLab", UILabel, guildInfoRoot)
  self.scoreLab = self:FindComponent("ScoreLab", UILabel, guildInfoRoot)
  local guildIconRoot = self:FindGO("GuildIconRoot", guildInfoRoot)
  self.icon = self:FindComponent("Icon", UISprite, guildIconRoot)
  self.customPic = self:FindComponent("CustomPic", UITexture, guildIconRoot)
end

function GVGWeeklyPointPopUp:SetGuildInfo()
  self.rankLab.text = string.format(ZhString.GvgWeeklyPoint_Rank, self.rankData.rank)
  self.guildName.text = self.rankData:GetGuildName()
  self.playerNameLab.text = self.rankData:GetLeaderName()
  self.scoreLab.text = string.format(ZhString.GvgWeeklyPoint_Score, self.rankData.totalScore)
  self:SetGuildIcon()
end

function GVGWeeklyPointPopUp:Init()
  self:FindObj()
  self:AddEvent()
end

function GVGWeeklyPointPopUp:FindObj()
  self:InitFixedContext()
  self:InitGuildInfo()
  self.pointListCtl = WrapListCtrl.new(self:FindGO("WrapContent"), GvgWeeklyPointCell, "GvgWeeklyPointCell")
end

function GVGWeeklyPointPopUp:AddEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function GVGWeeklyPointPopUp:UpdateView()
  self.rankData = self.viewdata.viewdata.rankData
  self.pointListCtl:ResetDatas(self.rankData:GetDetailDatas())
  self:SetGuildInfo()
end

function GVGWeeklyPointPopUp:OnEnter()
  GVGWeeklyPointPopUp.super.OnEnter(self)
  self:UpdateView()
end

function GVGWeeklyPointPopUp:SetGuildIcon()
  local headId = self.rankData.portrait or 1
  local guildHeadData = GuildHeadData.new()
  guildHeadData:SetBy_InfoId(headId)
  guildHeadData:SetGuildId(self.rankData.id)
  self.index = guildHeadData.index
  if guildHeadData.type == GuildHeadData_Type.Config then
    local sdata = guildHeadData.staticData
    if sdata then
      self.icon.gameObject:SetActive(true)
      self.customPic.gameObject:SetActive(false)
      IconManager:SetGuildIcon(sdata.Icon, self.icon)
      self.icon.width = 32
      self.icon.height = 32
    end
  elseif guildHeadData.type == GuildHeadData_Type.Custom then
    if not self.customPic then
      return
    end
    self.icon.gameObject:SetActive(false)
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
  end
  self.guildHeadData = nil
end

function GVGWeeklyPointPopUp:SetCustomPic(data)
  if not data or data.type ~= GuildHeadData_Type.Custom then
    return
  end
  local success_callback = function(bytes, localTimestamp)
    local pic = Texture2D(128, 128, TextureFormat.RGB24, false)
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
