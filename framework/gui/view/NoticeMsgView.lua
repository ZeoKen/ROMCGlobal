NoticeMsgView = class("NoticeMsgView", ContainerView)
NoticeMsgView.ViewType = UIViewType.BoardLayer

function NoticeMsgView:Init()
  self:FindObjs()
  self:AddEvts()
  self.noticeMsgList = {}
  self.noticeMsg:SetOnFinished(function()
    if self.isPlayingForward then
      self.isPlayingForward = nil
      TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ShowNotice.duration * 1000, function(owner, deltaTime)
        local perHeight = self.noticeMsgLabel.fontSize + self.noticeMsgLabel.spacingY
        local line = self.noticeMsgLabel.printedSize.y / perHeight
        if 1 < line then
          self.noticeMsgLabelTween:PlayForward()
        else
          self:PlayReverseNoticeMsg()
        end
      end, self)
    elseif self.isPlayingForward == false then
      self.isPlayingForward = nil
      self.noticeMsgLabelTween:ResetToBeginning()
      table.remove(self.noticeMsgList, 1)
      self:PlayNoticeMsg()
    end
  end)
  self.noticeMsgLabelTween:SetOnFinished(function()
    TimeTickManager.Me():CreateOnceDelayTick(GameConfig.ShowNotice.duration * 1000, function(owner, deltaTime)
      self:PlayReverseNoticeMsg()
    end, self)
  end)
end

function NoticeMsgView:FindObjs()
  self.noticeMsg = self:FindGO("NoticeMsg"):GetComponent(TweenPosition)
  self.noticeMsgLabel = self:FindGO("NoticeMsgLabel"):GetComponent(UILabel)
  self.noticeMsgLabelTween = self.noticeMsgLabel.gameObject:GetComponent(TweenPosition)
end

function NoticeMsgView:AddEvts()
  self:AddListenEvt(SystemMsgEvent.NoticeMsg, self.HandleNoticeMsg)
  self:AddListenEvt(SystemMsgEvent.NoticeMsgHide, self.OnNoticeMsgHide, self)
end

function NoticeMsgView:OnNoticeMsgHide(isActive)
  self.noticeMsg.gameObject:SetActive(isActive.body)
end

function NoticeMsgView:HandleNoticeMsg(note)
  local data = note.body
  table.insert(self.noticeMsgList, data)
  if #self.noticeMsgList == 1 then
    self:PlayNoticeMsg()
  end
end

function NoticeMsgView:PlayNoticeMsg()
  if #self.noticeMsgList > 0 then
    local msg = self.noticeMsgList[1]
    local text = msg.param and MsgParserProxy.Instance:TryParse(msg.text, unpack(msg.param)) or msg.text
    self:PlayForwardNoticeMsg(text)
  end
end

function NoticeMsgView:PlayForwardNoticeMsg(text)
  self.isPlayingForward = true
  self.noticeMsgLabel.text = text
  self.noticeMsg:PlayForward()
end

function NoticeMsgView:PlayReverseNoticeMsg()
  self.isPlayingForward = false
  self.noticeMsg:PlayReverse()
end
