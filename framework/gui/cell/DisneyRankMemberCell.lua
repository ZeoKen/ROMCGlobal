autoImport("PlayerFaceCell")
local BaseCell = autoImport("BaseCell")
DisneyRankMemberCell = class("DisneyRankMemberCell", BaseCell)
local _RankPrefix = "Disney_bg_No"

function DisneyRankMemberCell:Init()
  local portrait = self:FindGO("Portrait")
  self.portraitCell = PlayerFaceCell.new(portrait)
  self.portraitCell:SetMinDepth(4)
  local userGender = self:FindGO("UserGender")
  self.nameLab = self:FindComponent("NameLab", UILabel, userGender)
  self.gender_female = self:FindGO("Gender_female", userGender)
  self.gender_male = self:FindGO("Gender_male", userGender)
  self.pointLab = self:FindComponent("PointLab", UILabel)
  self.rankLab = self:FindComponent("RankLab", UILabel)
  self.rankSpBg = self:FindComponent("RankNo", UISprite, self.rankLab.gameObject)
  self:SetEvent(self.portraitCell.headIconCell.clickObj.gameObject, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function DisneyRankMemberCell:SetData(data)
  self.data = data
  if not data then
    self.gameObject:SetActive(false)
    return
  end
  self.gameObject:SetActive(true)
  self.nameLab.text = data.name
  local ismale = data.gender == ProtoCommon_pb.EGENDER_MALE
  self.gender_male:SetActive(ismale)
  self.gender_female:SetActive(not ismale)
  self.pointLab.text = data.point
  self.rankLab.text = data.rank
  if data.rank <= 3 then
    self.rankSpBg.gameObject:SetActive(true)
    self.rankSpBg.spriteName = _RankPrefix .. data.rank
  else
    self.rankSpBg.gameObject:SetActive(false)
  end
  local headData = HeadImageData.new()
  headData:TransByDisneyRankMemberData(data)
  self.portraitCell:SetData(headData)
end

function DisneyRankMemberCell:AddIconEvent()
  if self.portraitCell then
    self.portraitCell:AddIconEvent()
  end
end

function DisneyRankMemberCell:RemoveIconEvent()
  if self.portraitCell then
    self.portraitCell:RemoveIconEvent()
  end
end

function DisneyRankMemberCell:OnRemove()
  self:RemoveIconEvent()
end
