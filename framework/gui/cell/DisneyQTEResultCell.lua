autoImport("SocialBaseCell")
DisneyQTEResultCell = class("DisneyQTEResultCell", SocialBaseCell)

function DisneyQTEResultCell:Init()
  self.super.Init(self)
  self:FindObjs()
end

function DisneyQTEResultCell:FindObjs()
  self.super.FindObjs(self)
  self.rankTxt = self:FindGO("Ranktxt"):GetComponent(UILabel)
  self.score1Num = self:FindGO("Score1"):GetComponent(UILabel)
  self.score2Num = self:FindGO("Score2"):GetComponent(UILabel)
  self.rankSp = self:FindGO("Ranksp"):GetComponent(UISprite)
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.emptyGuild = self:FindGO("EmptyGuild")
end

function DisneyQTEResultCell:SetData(data)
  self.super.SetData(self, data)
  self.rankTxt.text = self.data.rank
  self.score1Num.text = string.format(ZhString.DisneyMusical_Score, self.data.score)
  self.score2Num.text = string.format(ZhString.DisneyMusical_Combo, self.data.combo)
  if data.rank then
    local spname = "Disney_bg_No" .. data.rank
    if self.rankSp.atlas:GetSprite(spname) then
      self.rankTxt.text = data.rank
      self.rankTxt.effectStyle = 3
      self.rankTxt.color = LuaColor.white
      self.rankSp.spriteName = spname
      self.rankSp.gameObject:SetActive(true)
    else
      self.rankTxt.text = data.rank
      self.rankTxt.effectStyle = 0
      self.rankTxt.color = LuaColor(0.39215686274509803, 0.3843137254901961, 0.5411764705882353)
      self.rankSp.gameObject:SetActive(false)
    end
  else
    self.rankTxt.text = ZhString.BattlePassRankView_norank
    self.rankTxt.effectStyle = 0
    self.rankTxt.color = LuaColor(0.39215686274509803, 0.3843137254901961, 0.5411764705882353)
    self.rankSp.gameObject:SetActive(false)
  end
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
end
