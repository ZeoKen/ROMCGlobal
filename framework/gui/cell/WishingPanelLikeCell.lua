local baseCell = autoImport("BaseCell")
WishingPanelLikeCell = class("WishingPanelLikeCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function WishingPanelLikeCell:Init()
  WishingPanelLikeCell.super.Init(self)
  self:FindObjs()
  self:InitData()
  self:AddCellClickEvent()
end

function WishingPanelLikeCell:FindObjs()
  self.likeLabel = self:FindGO("LikeLabel"):GetComponent(UILabel)
  self.likeLabelGO = self.likeLabel.gameObject
  local panel = self:FindComponent("LabelScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and panel then
    panel.depth = upPanel.depth + 1
  end
  self.likeLabel_TweenPos = self.likeLabelGO:GetComponent(TweenPosition)
  self.likeLabel_TweenPos.enabled = false
  self.timeLabel = self:FindGO("TimeLabel"):GetComponent(UILabel)
  self.clickUrl = self.likeLabel.gameObject:GetComponent(UILabelClickUrl)
  
  function self.clickUrl.callback(url)
    if url ~= nil and self.id ~= nil then
      xdlog("申请玩家数据", self.charid)
      self:sendNotification(UICellEvent.OnCellClicked)
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.charid)
    end
  end
end

function WishingPanelLikeCell:InitData()
end

function WishingPanelLikeCell:SetData(data)
  self.id = data.recordid
  self.charid = data.charid
  local charname = data.charname
  self.likeLabel.text = string.format("[u][url=%s]%s[/url][/u]", self.charid, charname)
  local time = data.time
  self.timeLabel.text = ClientTimeUtil.GetFormatTimeStr(time)
  self:StartLabelTween()
end

function WishingPanelLikeCell:StartLabelTween()
  if self.likeLabel.printedSize.x < 160 then
    return
  end
  LuaVector3.Better_Set(tempVector3, LuaGameObject.GetLocalPosition(self.likeLabel.transform))
  self.likeLabel_TweenPos.duration = 8
  self.likeLabel_TweenPos.style = 1
  self.likeLabel_TweenPos.from = tempVector3
  LuaGeometry.GetTempVector3(tempVector3.x - self.likeLabel.printedSize.x / 2, tempVector3.y, tempVector3.z)
  self.likeLabel_TweenPos.to = LuaGeometry.GetTempVector3(tempVector3.x - self.likeLabel.printedSize.x / 2, tempVector3.y, tempVector3.z)
  self.likeLabel_TweenPos.enabled = true
  self.likeLabel_TweenPos:ResetToBeginning()
  self.likeLabel_TweenPos:PlayForward()
end
