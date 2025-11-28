MiniGameRankCell = class("MiniGameRankCell", BaseCell)
local DATA_FORMAT = "%Y/%m/%d %H:%M:%S"

function MiniGameRankCell:Init()
  self:FindObjs()
  self:InitHead()
  self:AddEvents()
end

function MiniGameRankCell:FindObjs()
  self.rankContainer = self:FindGO("rankContainer")
  self.rankSp = self:FindGO("Sprite", self.rankContainer):GetComponent(UISprite)
  self.rankLv = self:FindGO("Label", self.rankContainer):GetComponent(UILabel)
  self.headContainer = self:FindGO("headContainer")
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.record = self:FindGO("record"):GetComponent(UILabel)
  self.recordTime = self:FindGO("recordTime"):GetComponent(UILabel)
  self.objProfession = self:FindGO("profession")
end

function MiniGameRankCell:InitHead()
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self.headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(1)
  self.headIcon:SetMinDepth(1)
  self.headData = HeadImageData.new()
end

function MiniGameRankCell:AddEvents()
end

function MiniGameRankCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self:UpdateHead(data)
  self:UpdateRank()
  self.rankLv.text = self.data.rank
  self.name.text = self.data.name
  self.record.text = self.data.record
  self.recordTime.text = os.date(DATA_FORMAT, self.data.recordtime)
end

function MiniGameRankCell:UpdateHead(data)
  self:_UpdateHead(data or self.data, self.objProfession, self.headIcon, self.objDefaultHead)
end

function MiniGameRankCell:_UpdateHead(data, professionObj, headIcon, defaultHead)
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
  if headIcon.gameObject.activeSelf then
    if iconData.type == HeadImageIconType.Avatar then
      headIcon:SetData(iconData)
    elseif iconData.type == HeadImageIconType.Simple then
      headIcon:SetSimpleIcon(iconData.icon, iconData.frameType)
      headIcon:SetPortraitFrame(iconData.portraitframe)
    end
    headIcon:SetScale(0.4)
  end
end

function MiniGameRankCell:UpdateRank()
  if not self.rankLv or not self.rankSp then
    return
  end
  if self.data.rank > 10 then
    self.rankLv.text = "10+"
  end
  self.rankLv.text = self.data.rank
  if self.data.rank < 4 then
    self.rankSp.gameObject:SetActive(true)
    self.rankLv.color = LuaGeometry.GetTempColor()
    self.rankSp.spriteName = string.format("Adventure_icon_%s", self.data.rank)
  else
    self.rankSp.gameObject:SetActive(false)
    self.rankLv.color = LuaGeometry.GetTempColor(0, 0, 0, 1)
  end
end

function MiniGameRankCell:ResetHeadData(data)
  self.headData:Reset()
  if not data then
    return
  end
  self.headData:TransByMiniGameRankData(data)
end

function MiniGameRankCell:ClickHead()
  self:PassEvent(MouseEvent.MouseClick, self)
end
