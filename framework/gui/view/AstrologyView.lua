AstrologyView = class("AstrologyView", ContainerView)
AstrologyView.ViewType = UIViewType.NormalLayer
autoImport("AstrologyCardCell")
local AstrologyConfig = GameConfig.Astrology
local AstrologyType = {
  Normal = SceneAugury_pb.EASTROLOGYTYPE_CONSTELLATION,
  Activity = SceneAugury_pb.EASTROLOGYTYPE_ACTIVITY
}
local rightendPos = LuaVector3(2000, 0, 0)
local leftendPos = LuaVector3(-2000, 0, 0)
local startPos = LuaVector3(-429, -22, 0)
local tempOne = LuaVector3(1, 1, 1)

function AstrologyView:Init()
  self:FindObj()
  self:AddEvt()
  self:AddCloseButtonEvent()
end

function AstrologyView:FindObj()
  self.fullset = self:FindGO("FullSet")
  self.bg = self:FindGO("bg", self.fullSet)
  self.bg:SetActive(true)
  self.singleset = self:FindGO("SingleSet")
  self.cardSlots = {}
  self.tweenPos = {}
  self.singletweenPos = {}
  self.singleSlot = {}
  self.fullsetObj = {}
  self.singlesetObj = {}
  local fullTitle = self:FindGO("fullTitle"):GetComponent(UILabel)
  fullTitle.text = AstrologyConfig.SignConfig.Title
  local singleTitle = self:FindGO("singleTitle"):GetComponent(UILabel)
  singleTitle.text = AstrologyConfig.ActivityConfig.Title
  for i = 1, 4 do
    local single = self:FindGO("CardSlot" .. i)
    local temp = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("AstrologyCardCell"))
    temp.transform:SetParent(single.transform, false)
    temp.transform.localScale = tempOne
    self.cardSlots[i] = AstrologyCardCell.new(temp)
    self.fullsetObj[i] = single
    local tween = single:GetComponent(TweenPosition)
    tween:ResetToBeginning()
    tween:PlayReverse()
    tween:SetOnFinished(function()
      self:HideAll()
    end)
    self.tweenPos[i] = tween
  end
  self.singleTween = self:FindGO("SingleTween"):GetComponent(TweenPosition)
  self.singleTween:SetOnFinished(function()
    for i = 1, 3 do
      self.singletweenPos[i].enabled = true
    end
  end)
  for i = 1, 3 do
    local single = self:FindGO("SingleSlot" .. i)
    local temp = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("AstrologyCardCell"))
    temp.transform:SetParent(single.transform, false)
    temp.transform.localScale = tempOne
    self.singleSlot[i] = AstrologyCardCell.new(temp)
    self.singlesetObj[i] = single
    local tween = single:GetComponent(TweenPosition)
    self.singletweenPos[i] = tween
  end
end

function AstrologyView:AddEvt()
  for k, v in pairs(self.fullsetObj) do
    self:AddClickEvent(self.fullsetObj[k], function(g)
      self:OnClickSlots(k)
    end)
  end
  for k, v in pairs(self.singlesetObj) do
    self:AddClickEvent(self.singlesetObj[k], function(g)
      self:OnClickSingle(k)
    end)
  end
end

function AstrologyView:OnEnter()
  AstrologyView.super.OnEnter(self)
  self.astrologyType = self.viewdata.viewdata and self.viewdata.viewdata.AstrologyType
  if self.astrologyType == AstrologyType.Normal then
    for i = 1, 4 do
      self.cardSlots[i]:SetData(i, self.astrologyType)
    end
    self.fullset:SetActive(true)
    self.singleTween.enabled = true
    self.singleset:SetActive(false)
  elseif self.astrologyType == AstrologyType.Activity then
    self.currentGroup = AstrologyConfig.ActivityConfig.groupid
    self.singleTween.enabled = false
    self:SetSingle()
    self.fullset:SetActive(false)
    self.singleset:SetActive(true)
  end
end

function AstrologyView:ShowSingle(index)
  self:SetSingle()
  self.singleset:SetActive(true)
  for i = 1, 3 do
    self.singletweenPos[i].enabled = false
  end
  if index then
    self.singleTween.from = self.fullsetObj[index].transform.localPosition
    self.singleTween.to = startPos
    self.singleTween:ResetToBeginning()
    self.singleTween:PlayForward()
  end
end

function AstrologyView:HideAll()
  self.fullset:SetActive(false)
end

function AstrologyView:SetAll()
end

function AstrologyView:SetSingle()
  for i = 1, 3 do
    self.singleSlot[i]:SetData(self.currentGroup, self.astrologyType)
  end
end

function AstrologyView:OnClickSlots(index)
  self.currentGroup = index
  for i = 1, 4 do
    if i ~= index then
      if i < index then
        self.tweenPos[i].to = leftendPos
      else
        self.tweenPos[i].to = rightendPos
      end
      self.tweenPos[i]:PlayForward()
    else
      self.fullsetObj[index]:SetActive(false)
    end
  end
  self.bg:SetActive(false)
  self:ShowSingle(index)
end

function AstrologyView:OnClickSingle(index)
  self.currentSingle = index
  ServiceSceneAuguryProxy.Instance:CallAuguryAstrologyDrawCard(self.astrologyType, self.currentGroup)
  self:CloseSelf()
end
