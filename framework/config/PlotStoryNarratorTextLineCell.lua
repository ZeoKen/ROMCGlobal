local BaseCell = autoImport("BaseCell")
PlotStoryNarratorTextLineCell = class("PlotStoryNarratorTextLineCell", BaseCell)

function PlotStoryNarratorTextLineCell:Init()
  self.textLb = self.gameObject:GetComponent(UILabel)
  self.alphaTween = self.gameObject:GetComponent(TweenAlpha)
end

function PlotStoryNarratorTextLineCell:SetData(data)
  self.textLb.text = MsgParserProxy.Instance:TryParse(data)
  self.alphaTween:Sample(0, true)
  self.alphaTween.enabled = false
end

function PlotStoryNarratorTextLineCell:ResetAlphaPlay(alphaDuration, alphaDelay)
  self.alphaTween.duration = alphaDuration
  self.alphaTween.delay = alphaDelay
  self.alphaTween:Sample(0, true)
  self.alphaTween.enabled = true
  self.alphaTween:PlayForward()
end

function PlotStoryNarratorTextLineCell:SetLabelStyle(fontSize)
  self.textLb.fontSize = fontSize
end
