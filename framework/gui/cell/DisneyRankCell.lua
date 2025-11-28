autoImport("SocialBaseCell")
local baseCell = autoImport("BaseCell")
DisneyRankCell = class("DisneyRankCell", SocialBaseCell)

function DisneyRankCell:Init()
  self.super.Init(self)
  self:FindObjs()
end

function DisneyRankCell:FindObjs()
  self.super.FindObjs(self)
  self.cellgo = self:FindGO("cell")
  self.chooseFlag = self:FindGO("Choosed")
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.emptyGuild = self:FindGO("EmptyGuild")
  self.rankSp = self:FindGO("Ranksp"):GetComponent(UISprite)
  self.rankTxt = self:FindGO("Ranktxt"):GetComponent(UILabel)
  self.score = self:FindGO("Score"):GetComponent(UILabel)
  self.backGround = self:FindGO("Background")
  self.chooseSymbol = self:FindGO("Choosed")
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DisneyRankCell:SetData(data)
  self.chooseSymbol:SetActive(false)
  if not data then
    self.cellgo:SetActive(false)
    return
  end
  self.cellgo:SetActive(true)
  self.super.SetData(self, data)
  if data.guildname and data.guildname ~= "" then
    self.guildName.gameObject:SetActive(true)
    self.guildName.text = data.guildname
    self.emptyGuild:SetActive(false)
  else
    self.guildName.gameObject:SetActive(false)
    self.emptyGuild:SetActive(true)
  end
  local guildportrait = tonumber(data.guildportrait) or 1
  guildportrait = Table_Guild_Icon[guildportrait] and Table_Guild_Icon[guildportrait].Icon or ""
  IconManager:SetGuildIcon(guildportrait, self.guildIcon)
  self.rank = data.rank
  if data.rank then
    local spname = "Disney_bg_No" .. data.rank
    if self.rankSp.atlas:GetSprite(spname) then
      self.rankTxt.text = data.rank
      self.rankTxt.effectStyle = 3
      self.rankTxt.color = LuaGeometry.GetTempColor(1, 1, 1, 1)
      self.rankSp.spriteName = spname
      self.rankSp.gameObject:SetActive(true)
    else
      self.rankTxt.text = data.rank
      self.rankTxt.effectStyle = 0
      self.rankTxt.color = LuaGeometry.GetTempColor(0.39215686274509803, 0.3843137254901961, 0.5411764705882353)
      self.rankSp.gameObject:SetActive(false)
    end
  else
    self.rankTxt.text = ZhString.BattlePassRankView_norank
    self.rankTxt.effectStyle = 0
    self.rankTxt.color = LuaGeometry.GetTempColor(0.39215686274509803, 0.3843137254901961, 0.5411764705882353)
    self.rankSp.gameObject:SetActive(false)
  end
  if data.score then
    self.score.text = data.score
  end
  self:AddClickEvent(self.headIcon.gameObject, function()
    self:PassEvent(DisneyEvent.RankViewSelectHead, self)
  end)
end

function DisneyRankCell:HideBackground()
  self.backGround:SetActive(false)
end

function DisneyRankCell:SetChoose(bool)
  self.chooseSymbol:SetActive(bool)
end
