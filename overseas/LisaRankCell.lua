autoImport("BaseCell")
LisaRankCell = class("LisaRankCell", BaseCell)

function LisaRankCell:Init()
  LisaRankCell.super.Init(self)
  self.Profession = self:FindGO("ProfessIcon"):GetComponent(UISprite)
  self.professIconBG = self:FindGO("CareerBg"):GetComponent(UISprite)
  self.rank = self:FindGO("Rank")
  self.rankLabel = self:FindGO("rankNum", self.rank)
  self.nameLabel = self:FindGO("Name"):GetComponent(UILabel)
  self.countLabel = self:FindGO("Num"):GetComponent(UILabel)
  self:TryInitHeadIcon()
end

function LisaRankCell:TryInitHeadIcon()
  if self.headIcon ~= nil then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self:AddCellClickEvent()
end

function LisaRankCell:ShowPlayerTip(data, callback)
  if data.guid == Game.Myself.data.id then
    return
  end
  local hc = self:FindGO("HeadIconCell"):GetComponent(UIWidget)
  local playerData = PlayerTipData.new()
  playerData:SetByFriendData(data)
  local playerTip = FunctionPlayerTip.Me():GetPlayerTip(hc, NGUIUtil.AnchorSide.Right)
  local tipData = {}
  tipData.playerData = playerData
  tipData.funckeys = {"ShowDetail"}
  playerTip:SetData(tipData)
  playerTip.closecallback = callback
end

function LisaRankCell:SetData(data)
  LisaRankCell.super.SetData(self, data)
  self.data = data
  self.charid = data.charid
  self.nameLabel.text = data.name
  self.countLabel.text = data.count
  local config = Table_Class[data.profession]
  if config then
    IconManager:SetProfessionIcon(config.icon, self.Profession)
    local iconColor = ColorUtil["CareerIconBg" .. config.Type]
    if iconColor == nil then
      iconColor = ColorUtil.CareerIconBg0
    end
    self.professIconBG.color = iconColor
  end
  local headImageData = HeadImageData.new()
  if data.mine then
    headImageData:TransByMyself()
    self.nameLabel.text = Game.Myself.data.name
  else
    local iconData = {
      type = HeadImageIconType.Avatar,
      bodyID = data.body,
      hairID = data.hair,
      haircolor = data.haircolor,
      gender = data.gender,
      blink = data.blink,
      headID = data.head,
      faceID = data.face,
      mouthID = data.mouth,
      eyeID = data.eye,
      portrait = data.portrait
    }
    headImageData.iconData = iconData
  end
  local headIconData = headImageData.iconData
  local headData = Table_HeadImage[headIconData.portrait]
  if headIconData.portrait and headIconData.portrait ~= 0 and headData and headData.Picture then
    self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
  else
    self.headIcon:SetData(headIconData)
  end
  self.headIcon:SetScale(0.35)
  self.headIcon:SetMinDepth(1)
  self.headIcon:ResetBaseFace()
  local rankObj = self:FindGO(data.rank, self.rank)
  if rankObj then
    self.rankLabel:SetActive(false)
    rankObj:SetActive(true)
  else
    self.rankLabel:SetActive(true)
    self.rankLabel:GetComponent(UILabel).text = data.rank < 1000 and data.rank or "999+"
  end
  if tonumber(data.rank) == 0 then
    self.rankLabel:GetComponent(UILabel).text = "-"
  end
end
