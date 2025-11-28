local baseCell = autoImport("BaseCell")
AchievementQuestCell = class("AchievementQuestCell", baseCell)
local tempVector3 = LuaVector3.zero
local getlocalPos = LuaGameObject.GetLocalPosition
local calSize = NGUIMath.CalculateRelativeWidgetBounds
local isNil = LuaGameObject.ObjectIsNull

function AchievementQuestCell:Init()
  self:initView()
end

function AchievementQuestCell:initView()
  self.more = self:FindGO("more")
  self.descScrollView = self:FindGO("DescScrollView"):GetComponent(UIScrollView)
  local descScrollPanel = self:FindGO("DescScrollView"):GetComponent(UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and descScrollPanel then
    descScrollPanel.depth = upPanel.depth + 1
  end
  self.achieveDesc = self:FindComponent("achieveDesc", UILabel)
  self.descTween = self.achieveDesc.gameObject:GetComponent(TweenPosition)
  if not self.descTween then
    self.descTween = self.achieveDesc.gameObject:AddComponent(TweenPosition)
    self.descTween.enabled = false
  end
  self.descMaxWidth = 262
  self:AddCellClickEvent()
  self.preQuestCt = self:FindGO("preQuestCt")
  self.questStatus = self:FindComponent("questStatus", UILabel)
  self.finishSymbol = self:FindGO("finishSymbol")
  self.statusBtn = self:FindGO("statusBtn")
  self.statusBtnSp = self:FindComponent("statusBtn", UISprite)
  self:Hide(self.preQuestCt)
  self:AddClickEvent(self.statusBtn, function(...)
    TipManager.Instance:ShowPreQuestTip(self.data.preQuestS, self.statusBtnSp, NGUIUtil.AnchorSide.Right, {270, 0})
  end)
  local grid = self:FindComponent("grid", UIGrid)
  self.preQuestGrid = UIGridListCtrl.new(grid, AchievementPreQuestCell, "AchievementPreQuestCell")
end

function AchievementQuestCell:SetData(data)
  self.data = data
  local type = data.type
  local content = data.content
  local questListType = data.questListType
  self:Hide(self.preQuestCt)
  self:Hide(self.finishSymbol)
  if type == AchievementDescriptionCell.SubAchieve.Achieve then
    self:Show(self.more)
    self:Hide(self.questStatus.gameObject)
    self:Hide(self.statusBtn)
    if data.contentReplaceS then
      self.achieveDesc.text = string.format(ZhString.AchievementQuestCell_MH, data.contentReplaceS, content)
    else
      self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubAchieveText, content)
    end
  elseif AchievementDescriptionCell.SubAchieve.Quest then
    self:Hide(self.more)
    self:Show(self.questStatus.gameObject)
    if data.contentReplaceS then
      self.achieveDesc.text = string.format(ZhString.AchievementQuestCell_MH, data.contentReplaceS, content)
    else
      self.achieveDesc.text = string.format(ZhString.AdventureAchievePage_SubQuestText, content)
    end
    if questListType == SceneQuest_pb.EQUESTLIST_SUBMIT then
      self:Hide(self.statusBtn)
      self:Hide(self.questStatus.gameObject)
      self:Show(self.finishSymbol)
    elseif data.statusReplaceS then
      self.questStatus.text = data.statusReplaceS
      self:Hide(self.statusBtn)
    elseif questListType == SceneQuest_pb.EQUESTLIST_ACCEPT then
      self.questStatus.text = ZhString.AdventureAchievePage_Accept
      self:Hide(self.statusBtn)
    else
      self.questStatus.text = ZhString.AdventureAchievePage_UnAccept
      if data.preQuestS and #data.preQuestS > 0 then
        self:Show(self.statusBtn)
        return
      else
        self:Hide(self.statusBtn)
      end
    end
  end
  self:TweenDescLabel()
end

function AchievementQuestCell:TweenDescLabel()
  local tempText = self.achieveDesc.text
  self.achieveDesc.text = ""
  self.achieveDesc.pivot = UIWidget.Pivot.Left
  self.achieveDesc.overflowMethod = 2
  self.achieveDesc.text = tempText
  LuaVector3.Better_Set(tempVector3, getlocalPos(self.achieveDesc.gameObject.transform))
  self.descScrollView:ResetPosition()
  self:StartTweenLable(self.achieveDesc, self.descMaxWidth, self.descTween, tempVector3, 7, 1)
end

function AchievementQuestCell:StartTweenLable(lable, _maxWidth, tweenPosition, from, duration, style)
  if lable == nil or _maxWidth == nil or _maxWidth >= lable.width then
    self.descTween.enabled = false
    return
  end
  tweenPosition.duration = duration
  tweenPosition.style = style
  tweenPosition.from = from
  tweenPosition.to = LuaGeometry.GetTempVector3(from.x - lable.width / 2, from.y, from.z)
  tweenPosition.enabled = true
  tweenPosition:ResetToBeginning()
  tweenPosition:PlayForward()
end
