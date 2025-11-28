local BaseCell = autoImport("BaseCell")
ProfessionNewHeroTaskCell = class("ProfessionNewHeroTaskCell", BaseCell)
local NormalColor = Color(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
local FinishedColor = Color(0.3686274509803922, 0.7176470588235294, 0.1450980392156863, 1)
local FinishAlpha = 0.5

function ProfessionNewHeroTaskCell:ctor(obj)
  ProfessionNewHeroTaskCell.super.ctor(self, obj)
  self:FindObjs()
end

function ProfessionNewHeroTaskCell:FindObjs()
  local container = self:FindGO("Container")
  self.inoutTween = container:GetComponent(TweenPosition)
  self.normalGroupGO = self:FindGO("NormalGroup")
  self.goBtnGO = self:FindGO("GoBtn", self.normalGroupGO)
  self:AddClickEvent(self.goBtnGO, function()
    self:OnGotoClicked()
  end)
  self.progressGO = self:FindGO("ProgressLab", self.normalGroupGO)
  self.progressLab = self.progressGO:GetComponent(UILabel)
  self.rewardBtnGO = self:FindGO("RewardBtn", self.normalGroupGO)
  self:AddClickEvent(self.rewardBtnGO, function()
    self:OnRewardClicked()
  end)
  self.finishGroupGO = self:FindGO("FinishGroup")
  local contentGroupGO = self:FindGO("ContentGroup")
  self.contentGroup = contentGroupGO:GetComponent(UIWidget)
  self.descLabel = self:FindComponent("Desc", UIRichLabel, contentGroupGO)
  self.descSpriteLabel = SpriteLabel.new(self.descLabel, nil, 20, 20)
  self.itemGO = self:FindGO("Item", container)
  self:AddClickEvent(self.itemGO, function()
    self:OnItemClicked()
  end)
  self.item = self.itemGO:GetComponent(UIWidget)
  self.itemCount = self:FindComponent("ItemCount", UILabel, self.itemGO)
  self.itemIcon = self:FindComponent("ItemIcon", UISprite, self.itemGO)
  self.selectedGO = self:FindGO("Selected", self.itemGO)
  self.selectedGO:SetActive(false)
end

function ProfessionNewHeroTaskCell:SetData(data)
  self.data = data
  if data then
    local iconName = data:GetRewardItemIcon()
    if iconName then
      IconManager:SetItemIcon(iconName, self.itemIcon)
    end
    local itemCount = data:GetRewardItemNum()
    self.itemCount.text = itemCount and 1 < itemCount and itemCount or ""
    local exUseLua = SpriteLabel.useLuaVersion
    SpriteLabel.useLuaVersion = true
    self.descSpriteLabel:SetText(data:GetTraceInfo())
    SpriteLabel.useLuaVersion = exUseLua
    if data:IsRewarded() then
      self.finishGroupGO:SetActive(true)
      self.normalGroupGO:SetActive(false)
      self.goBtnGO:SetActive(false)
      self.contentGroup.alpha = FinishAlpha
      self.item.alpha = FinishAlpha
    else
      self.finishGroupGO:SetActive(false)
      self.normalGroupGO:SetActive(true)
      self.contentGroup.alpha = 1
      self.item.alpha = 1
      if data:IsCompleted() then
        self.rewardBtnGO:SetActive(true)
        self.progressGO:SetActive(false)
        self.goBtnGO:SetActive(false)
      else
        self.rewardBtnGO:SetActive(false)
        local gt = data:GetGoto()
        if gt ~= nil then
          self.goBtnGO:SetActive(true)
          self.progressGO:SetActive(false)
        else
          self.goBtnGO:SetActive(false)
          self.progressGO:SetActive(true)
          self.progressLab.text = data:GetProgressStr()
        end
      end
    end
  end
end

function ProfessionNewHeroTaskCell:SetChoose(b)
  self.selectedGO:SetActive(not not b)
end

function ProfessionNewHeroTaskCell:OnGotoClicked()
  local gotoId = self.data and self.data:GetGoto()
  if gotoId then
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, MultiProfessionNewView.ViewType)
    FuncShortCutFunc.Me():CallByID(gotoId)
  end
end

function ProfessionNewHeroTaskCell:OnRewardClicked()
  if self.data and self.data:IsCompleted() and not self.data:IsRewarded() then
    HeroProfessionProxy.Instance:TakeHeroQuestReward(self.data.id, nil, nil, SceneUser3_pb.HEROQUESTREWARDTYPE_GROWTH)
  end
end

local tipOffset = {-220, -188}

function ProfessionNewHeroTaskCell:OnItemClicked()
  local itemId = self.data and self.data:GetRewardItemId()
  if itemId then
    local itemData = ItemData.new(nil, itemId)
    local tab = ReusableTable.CreateTable()
    tab.itemdata = itemData
    self:ShowItemTip(tab, self.item, NGUIUtil.AnchorSide.TopLeft, tipOffset)
    ReusableTable.DestroyAndClearTable(tab)
  end
end
