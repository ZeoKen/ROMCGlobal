autoImport("HeadIconCell")
WarbandListCell = class("WarbandListCell", BaseCell)

function WarbandListCell:Init()
  self:FindObj()
end

function WarbandListCell:FindObj()
  self.bandName = self:FindComponent("BandName", UILabel)
  self.score = self:FindComponent("Score", UILabel)
  self.rank = self:FindComponent("Rank", UILabel)
  self.headContainer = self:FindGO("HeadContainer")
  self.bg = self:FindComponent("Bg", UISprite)
  self:SetEvent(self.bg.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:InitHead()
end

function WarbandListCell:InitHead()
  self.HeadCell = HeadIconCell.new()
  self.HeadCell:CreateSelf(self.headContainer)
  self.HeadCell:SetScale(0.55)
end

function WarbandListCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    self.bandName.text = data.name
    self.rank.text = data.rank
    self.score.text = string.format(ZhString.Warband_Signup_Score, data.score)
    self.HeadCell:SetData(data)
    local proxy = data.proxy or WarbandProxy.Instance
    local ismyBand = data.id == proxy:GetMyWarbandID()
    self.bg.atlas = ismyBand and RO.AtlasMap.GetAtlas("NewUI5") or RO.AtlasMap.GetAtlas("NewCom")
    self.bg.spriteName = ismyBand and "12pvp_CupMatch_bg" or "com_bg_bottom5"
  else
    self.gameObject:SetActive(false)
  end
end
