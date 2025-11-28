autoImport("SocialBaseCell")
local baseCell = autoImport("BaseCell")
BattlePassRankCell = class("BattlePassRankCell", SocialBaseCell)

function BattlePassRankCell:Init()
  self.super.Init(self)
  self:FindObjs()
end

function BattlePassRankCell:FindObjs()
  self.super.FindObjs(self)
  self.cellgo = self:FindGO("cell")
  self.chooseFlag = self:FindGO("Choosed")
  self.guildIcon = self:FindGO("GuildIcon"):GetComponent(UISprite)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.emptyGuild = self:FindGO("EmptyGuild")
  self.rankSp = self:FindGO("Ranksp"):GetComponent(UISprite)
  self.rankTxt = self:FindGO("Ranktxt"):GetComponent(UILabel)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function BattlePassRankCell:SetData(data)
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
  self.level.text = "Lv." .. data.bplevel
  if data.rank then
    local spname = "Guild_icon_NO" .. data.rank
    if self.rankSp.atlas:GetSprite(spname) then
      self.rankTxt.text = ""
      self.rankSp.spriteName = spname
      self.rankSp.gameObject:SetActive(true)
    else
      self.rankTxt.text = data.rank
      self.rankSp.gameObject:SetActive(false)
    end
  else
    self.rankTxt.text = ZhString.BattlePassRankView_norank
    self.rankSp.gameObject:SetActive(false)
  end
  self:AddClickEvent(self.headIcon.gameObject, function()
    self:PassEvent(BattlePassEvent.RankViewSelectHead, self)
  end)
end
