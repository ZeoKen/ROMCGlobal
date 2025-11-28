TeamPwsRankCell = class("TeamPwsRankCell", BaseCell)

function TeamPwsRankCell:Init()
  self:FindObjs()
  self:InitHead()
  self:AddEvents()
end

function TeamPwsRankCell:FindObjs()
  self:FindHeadObjs()
  self.labName = self:FindComponent("labName", UILabel)
  self.labRank = self:FindComponent("labRank", UILabel)
  self.sprRankBG = self:FindComponent("sprRankBG", UISprite)
  self.sprLevel = self:FindComponent("sprLevel", UISprite)
  self.labScore = self:FindComponent("labScore", UILabel)
  self.labGrade = self:FindComponent("labGrade", UILabel)
end

function TeamPwsRankCell:FindHeadObjs()
  self.headContainer = self:FindGO("headContainer")
  self.objDefaultHead = self:FindGO("DefaultHead")
  self.objProfession = self:FindGO("profession")
end

function TeamPwsRankCell:InitHead()
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(1)
  self.headData = HeadImageData.new()
end

function TeamPwsRankCell:AddEvents()
  self:AddClickEvent(self.headIcon.gameObject, function()
    self:ClickHead()
  end)
end

function TeamPwsRankCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:UpdateHead()
  self:UpdateRank()
  self:UpdateLevel()
  self:UpdateName()
  self:UpdateScore()
  self:UpdateGrade()
end

function TeamPwsRankCell:UpdateHead(data)
  self:_UpdateHead(data or self.data, self.objProfession, self.headIcon, self.objDefaultHead)
end

function TeamPwsRankCell:_UpdateHead(data, professionObj, headIcon, defaultHead)
  local proData = data and data.profession and Table_Class[data.profession]
  local professionSp = self:FindComponent("Icon", UISprite, professionObj)
  professionObj:SetActive(proData and IconManager:SetNewProfessionIcon(proData.icon, professionSp) or false)
  if proData then
    local professionBg = self:FindComponent("Color", UISprite, professionObj)
    professionBg.color = ColorUtil[string.format("CareerIconBg%s", proData.Type)] or ColorUtil.CareerIconBg0
  end
  self:ResetHeadData(data)
  local iconData = self.headData.iconData
  headIcon.gameObject:SetActive(data ~= nil and next(iconData) ~= nil)
  defaultHead:SetActive(data ~= nil and next(iconData) == nil)
  if headIcon.gameObject.activeSelf then
    if iconData.type == HeadImageIconType.Avatar then
      headIcon:SetData(iconData)
    elseif iconData.type == HeadImageIconType.Simple then
      headIcon:SetSimpleIcon(iconData.icon, iconData.frameType)
      headIcon:SetPortraitFrame(iconData.portraitframe)
    end
  end
end

function TeamPwsRankCell:UpdateRank()
  if not self.labRank or not self.sprRankBG then
    return
  end
  self.labRank.text = self.data.rank
  if self.data.rank < 4 then
    self.sprRankBG.gameObject:SetActive(true)
    self.labRank.color = LuaGeometry.GetTempColor()
    IconManager:SetUIIcon(string.format("Adventure_icon_%s", self.data.rank), self.sprRankBG)
  else
    self.sprRankBG.gameObject:SetActive(false)
    self.labRank.color = LuaGeometry.GetTempColor(0, 0, 0, 1)
  end
end

function TeamPwsRankCell:UpdateLevel()
  if not self.sprLevel then
    return
  end
  local hasERank = self.data.erank ~= MatchCCmd_pb.ETEAMPWSRANK_NONE
  self.sprLevel.gameObject:SetActive(hasERank)
  if hasERank then
    IconManager:SetUIIcon(string.format("ui_teampvp_lv%s", self.data.erank), self.sprLevel)
  end
end

function TeamPwsRankCell:UpdateName()
  if not self.labName then
    return
  end
  self.labName.text = self.data.name
end

function TeamPwsRankCell:UpdateScore()
  if not self.labScore then
    return
  end
  self.labScore.text = self.data.score
end

function TeamPwsRankCell:UpdateGrade()
  if not self.labGrade then
    return
  end
  self.labGrade.gameObject:SetActive(false)
end

function TeamPwsRankCell:ResetHeadData(data)
  self.headData:Reset()
  if not data then
    return
  end
  self.headData:TransByTeamPwsRankData(data)
end

function TeamPwsRankCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function TeamPwsRankCell:OnCellDestroy()
  if self.headIcon then
    self.headIcon:OnRemove()
    self.headIcon = nil
  end
end
