local BaseCell = autoImport("BaseCell")
GuildCell = class("GuildCell", BaseCell)
autoImport("GuildHeadCell")

function GuildCell:Init()
  local guildHeadCellGO = self:FindGO("GuildHeadCell")
  self.headCell = GuildHeadCell.new(guildHeadCellGO)
  self.headCell:SetCallIndex(UnionLogo.CallerIndex.UnionList)
  self.lv = self:FindComponent("Lv", UILabel)
  self.lvname = self:FindComponent("LvName", UILabel)
  self.zoneid = self:FindComponent("ZoneId", UILabel)
  self.memberNum = self:FindComponent("MemberNum", UILabel)
  self.recruitInfo = self:FindComponent("RecruitInfo", UILabel)
  self.chooseFlag = self:FindGO("Choosed")
  self.cityIcon = self:FindComponent("CityScaleIcon", UISprite)
  self.noCityLab = self:FindComponent("NoCity", UILabel)
  self.noCityLab.text = ZhString.GvgLandInfoPopUp_None
  self.mercenaryNum = self:FindComponent("MercenaryNum", UILabel)
  self.mercenaryGO = self:FindGO("MercenaryBg")
  self:SetEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GuildCell:GetMyGuildHeadData()
  if self.myGuildHeadData == nil then
    self.myGuildHeadData = GuildHeadData.new()
  end
  if self.data ~= nil then
    self.myGuildHeadData:SetBy_InfoId(self.data.portrait)
    self.myGuildHeadData:SetGuildId(self.data.id)
  end
  return self.myGuildHeadData
end

function GuildCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.lvname.text = data.guildname
    self.zoneid.text = string.format(ZhString.NewGVG_Group, data:GetClientGvgGroup())
    self.memberNum.text = string.format("%s/%s", tostring(data.curmember), tostring(data.maxmember))
    self.recruitInfo.text = data.recruitinfo or ""
    self.headCell:SetData(self:GetMyGuildHeadData())
    self:UpdateChoose()
    self.mercenaryNum.text = string.format("%s/%s", tostring(data.curmercenary or 0), tostring(GameConfig.Guild.MaxMercenaryMemberCount or 0))
    self.mercenaryGO:SetActive(GuildProxy.Instance:IsMyMercenaryGuild(data.id))
    local cityConfig = data:GetOccupiedCityConfig()
    if cityConfig then
      self.cityIcon.gameObject:SetActive(true)
      self.noCityLab.gameObject:SetActive(false)
      if cityConfig.Icon then
        IconManager:SetUIIcon(cityConfig.Icon, self.cityIcon)
      end
      if cityConfig.IconColor then
        local hasC, resultC = ColorUtil.TryParseHexString(cityConfig.IconColor)
        self.cityIcon.color = resultC
      end
    else
      self.cityIcon.gameObject:SetActive(false)
      self.noCityLab.gameObject:SetActive(true)
    end
  else
    self.gameObject:SetActive(false)
  end
end

function GuildCell:SetChoose(id)
  self.chooseId = id
  self:UpdateChoose()
end

function GuildCell:UpdateChoose()
  if self.data and self.chooseId and self.data.guid == self.chooseId then
    self.chooseFlag:SetActive(true)
  else
    self.chooseFlag:SetActive(false)
  end
end
