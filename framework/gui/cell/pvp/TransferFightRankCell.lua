TransferFightRankCell = class("TransferFightRankCell", BaseCell)

function TransferFightRankCell:Init()
  self:FindObjs()
end

function TransferFightRankCell:FindObjs()
  self.objLine = self:FindGO("objLine")
  self.sprBG = self:FindComponent("Bg", UISprite)
  self.sprBGMyself = self:FindComponent("BgAdd", UISprite)
  self.labName = self:FindComponent("labName", UILabel)
  self.labScore = self:FindComponent("labScore", UILabel)
  local objRank = self:FindGO("labRank", myScore)
  local objIcon = self:FindGO("sprRankBG", objRank)
  self.myRank = {
    gameObject = objRank,
    label = objRank:GetComponent(UILabel),
    objBG = objIcon,
    sprBG = objIcon:GetComponent(UISprite)
  }
end

function TransferFightRankCell:SetData(data)
  self.data = data
  self.labName.text = data.name
  self.labScore.text = data.score
  if data.rank and data.rank < 4 then
    self.myRank.label.enabled = false
    self.myRank.sprBG.enabled = true
    self.myRank.sprBG.spriteName = "Guild_icon_NO" .. data.rank
  else
    self.myRank.label.enabled = true
    self.myRank.sprBG.enabled = false
    self.myRank.label.text = data.rank
  end
end

function TransferFightRankCell:SetLineActive(isActive)
  self.objLine:SetActive(isActive)
end
