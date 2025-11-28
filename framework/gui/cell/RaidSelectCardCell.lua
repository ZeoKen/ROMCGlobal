RaidSelectCardCell = class("RaidSelectCardCell", CoreView)
local qualityBgTexMap = {
  [1] = "GVG_rift_bg_card1",
  [2] = "GVG_rift_bg_card3",
  [3] = "GVG_rift_bg_card2",
  [4] = "GVG_rift_bg_card4",
  [5] = "GVG_rift_bg_card5"
}
local pictureManager, dungeonIns

function RaidSelectCardCell:ctor(obj)
  if not pictureManager then
    pictureManager = PictureManager.Instance
    dungeonIns = DungeonProxy.Instance
  end
  RaidSelectCardCell.super.ctor(self, obj)
  self:Init()
end

function RaidSelectCardCell:Init()
  self.tween = self.gameObject:GetComponent(TweenScale)
  local clickEvent = function()
    self:OnClickCell()
  end
  local bg = self:FindGO("CardBg")
  self:AddClickEvent(bg, clickEvent)
  self.bgTex = bg:GetComponent(UITexture)
  self.recommended = self:FindGO("Recommended")
  self.icon = self:FindComponent("Icon", UISprite)
  self.qualityGOs, self.titles, self.features, self.descs, self.descPanels = {}, {}, {}, {}, {}
  local go
  for i, _ in pairs(qualityBgTexMap) do
    go = self:FindGO(tostring(i))
    if go then
      self.qualityGOs[i] = go
      self.titles[i] = self:FindComponent("Title", UILabel, go)
      self.features[i] = self:FindComponent("Feature", UILabel, go)
      self.descs[i] = self:FindComponent("Desc", UILabel, go)
      self:AddClickEvent(self.descs[i].gameObject, clickEvent)
      self.descPanels[i] = self:FindComponent("DescScrollView", UIPanel, go)
    end
  end
end

function RaidSelectCardCell:SetData(id)
  self.data = id and Table_SelectCardEffect[id]
  local flag = self.data ~= nil
  self.gameObject:SetActive(flag)
  if flag then
    self:OnCellDestroy()
    local q = self.data.Quality
    self.bgTexName = qualityBgTexMap[q]
    pictureManager:SetUI(self.bgTexName, self.bgTex)
    for i, go in pairs(self.qualityGOs) do
      go:SetActive(i == q)
    end
    self.titles[q].text = self.data.Title
    self.features[q].text = self.data.Type
    self.descs[q].text = self:GetDesc()
    self.recommended:SetActive(dungeonIns:IsRecommendedSelectCard(self.data.id))
    DungeonProxy.UpdateRaidSelectCardItem(self, self.data, self.LoadPreferb, self)
  end
end

function RaidSelectCardCell:GetDesc()
  if not self.data then
    return ""
  end
  local isSkillCard, skillId = DungeonProxy.IsRaidSelectSkillCard(self.data.id)
  if isSkillCard then
    local descData = Table_Skill[skillId].Desc
    descData = descData and descData[1]
    if descData then
      local format = Table_SkillDesc[descData.id]
      format = format and format.Desc
      if format then
        return string.format(format, unpack(descData.params))
      end
    end
  end
  return self.data.Desc
end

function RaidSelectCardCell:SetDescDepth(depth)
  for _, panel in pairs(self.descPanels) do
    panel.depth = depth
  end
end

function RaidSelectCardCell:PlayTween(isForward)
  if isForward == nil then
    isForward = true
  end
  if isForward then
    self.tween:PlayForward()
  else
    self.tween:PlayReverse()
  end
end

function RaidSelectCardCell:OnClickCell()
  self:PassEvent(MouseEvent.MouseClick, self)
end

function RaidSelectCardCell:OnCellDestroy()
  if self.bgTexName then
    pictureManager:UnLoadUI(self.bgTexName, self.bgTex)
    self.bgTexName = nil
  end
end
