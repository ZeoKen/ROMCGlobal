GuildScoreRankCell = class("GuildScoreRankCell", BaseCell)

function GuildScoreRankCell:Init()
  self:FindObjs()
  self.isActive = true
end

function GuildScoreRankCell:FindObjs()
  self.objLine = self:FindGO("objLine")
  self.rankLab = self:FindComponent("labRank", UILabel)
  self.rankSpr = self:FindComponent("sprRankBG", UISprite)
  self.labGuild = self:FindComponent("labGuild", UILabel)
  self.labChairman = self:FindComponent("labChairman", UILabel)
  self.labGuildRank = self:FindComponent("labGuildRank", UILabel)
  self.labScore = self:FindComponent("labScore", UILabel)
  self.root = self:FindGO("Root")
end

local color = Color(0.20392156862745098, 0.5137254901960784, 1.0, 1)

function GuildScoreRankCell:SetData(data)
  self.data = data
  if data then
    self.root:SetActive(true)
    self.id = data.guildid
    self.labChairman.text = data.chairmanname
    self.labScore.text = data.score
    self.labGuild.text = data.guildname
    self.labGuildRank.text = data.rank
    if data.rank < 4 then
      local uiAtlas = RO.AtlasMap.GetAtlas("NewUI5")
      if uiAtlas then
        local spname = "Guild_icon_NO" .. tostring(data.rank)
        self.rankSpr.atlas = uiAtlas
        self.rankSpr.spriteName = spname
        self.rankLab.text = ""
        self.rankLab.gameObject:SetActive(false)
        self.rankSpr.gameObject:SetActive(true)
      end
    elseif data.rank < 10 then
      local uiAtlas = RO.AtlasMap.GetAtlas("NewUI1")
      if uiAtlas then
        self.rankSpr.spriteName = "Adventure_icon_4-10"
        self.rankLab.text = data.rank
        self.rankLab.gameObject:SetActive(true)
        self.rankSpr.gameObject:SetActive(true)
        ColorUtil.WhiteUIWidget(self.rankLab)
      end
    else
      self.rankSpr.gameObject:SetActive(false)
      self.rankLab.text = data.rank
      self.rankLab.gameObject:SetActive(true)
      self.rankLab.color = color
    end
  else
    self.root:SetActive(false)
  end
end

function GuildScoreRankCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
