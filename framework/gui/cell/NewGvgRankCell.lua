local _GuildRankIconPrefix = "Guild_icon_NO"
local _BaseCell = autoImport("BaseCell")
NewGvgRankCell = class("NewGvgRankCell", _BaseCell)

function NewGvgRankCell:Init()
  self:FindObj()
end

function NewGvgRankCell:UseText()
  self.useText = true
end

function NewGvgRankCell:FindObj()
  self.root = self:FindGO("Root")
  self.iconBg = self:FindGO("IconBg")
  self.icon = self:FindComponent("Icon", UISprite, self.iconBg)
  self.customPic = self:FindComponent("CustomPic", UITexture, self.iconBg)
  self.bg = self:FindGO("Bg")
  self:SetEvent(self.bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self.guildNameLab = self:FindComponent("GuildNameLab", UILabel)
  self.leaderNameLab = self:FindComponent("LeaderNameLab", UILabel)
  self.totalPointLab = self:FindComponent("TotalPointLab", UILabel)
  self.rankSp = self:FindComponent("RankSp", UISprite)
  self.rankLab = self:FindComponent("RankLab", UILabel)
  self.zoneObj = self:FindGO("ZoneLab")
  if self.zoneObj then
    self.zoneLab = self.zoneObj:GetComponent(UILabel)
  end
  self.serverIDLab = self:FindComponent("ServerId", UILabel)
  self.hasRewardSp = self:FindComponent("HasRewardSp", UISprite)
  self.serverGrid = self:FindComponent("ServerGrid", UIGrid)
end

function NewGvgRankCell:SetData(data)
  self.data = data
  if not data then
    self:Hide(self.root)
    return
  end
  self:Show(self.root)
  if self.guildNameLab then
    self.guildNameLab.text = data:GetGuildName()
  end
  if self.zoneLab then
    self.zoneLab.text = tostring(data:GetZoneId())
  end
  if self.serverIDLab and data.GetServerId and data:GetServerId() ~= 0 then
    if GvgProxy.Instance:CheckDiffServerValid() then
      self:Show(self.serverIDLab)
      self.serverIDLab.text = data:GetServerId()
    else
      self:Hide(self.serverIDLab)
    end
  end
  if self.serverGrid then
    self.serverGrid:Reposition()
  end
  self:SetGuildIcon()
  if self.leaderNameLab then
    self.leaderNameLab.text = data:GetLeaderName()
  end
  if self.totalPointLab then
    self.totalPointLab.text = data.totalScore
  end
  if not self.rankSp then
    return
  end
  if "number" ~= type(data.rank) then
    return
  end
  if data:IsTop3() and not self.useText then
    self:Show(self.rankSp)
    self:Hide(self.rankLab)
    self.rankSp.spriteName = _GuildRankIconPrefix .. tostring(data.rank)
  else
    self:Hide(self.rankSp)
    self:Show(self.rankLab)
    self.rankLab.text = data:NoRank() and ZhString.NewGVG_NoRank or tostring(data.rank)
  end
  self.hasReward = data:HasReward()
  if self.hasReward then
    self:Show(self.hasRewardSp)
  else
    self:Hide(self.hasRewardSp)
  end
end

function NewGvgRankCell:OnCellDestroy()
  NewGvgRankCell.super.OnCellDestroy(self)
end

function NewGvgRankCell:SetGuildIcon()
  local headId = self.data.portrait or 1
  local guildHeadData = GuildHeadData.new()
  guildHeadData:SetBy_InfoId(headId)
  guildHeadData:SetGuildId(self.data.id)
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

function NewGvgRankCell:SetCustomPic(data)
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
