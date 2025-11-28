autoImport("WrapCellHelper")
autoImport("DisneyQTEResultCell")
DisneyQTEResultView = class("DisneyQTEResultView", BaseView)
DisneyQTEResultView.ViewType = UIViewType.CheckLayer

function DisneyQTEResultView:Init()
  self:InitData()
  self:FindObjs()
  self:AddEvts()
  self:InitView()
  self:AddListenEvts()
  self:InitShow()
end

local _viewdata = {
  is_win = true,
  rankInfo = {}
}

function DisneyQTEResultView:InitData()
  self.tickMg = TimeTickManager.Me()
  self.leftTime = 14
  local viewdata = self.viewdata and self.viewdata.viewdata or _viewdata
  self.pending = viewdata and viewdata.pending
  self.isWin = viewdata and viewdata.is_win
  self.rankInfo = viewdata and viewdata.rankInfo
end

function DisneyQTEResultView:FindObjs()
  self.uiTop = self:FindGO("UITop")
  self.title = self:FindGO("Title")
  self.title_TweenScale = self.title:GetComponent(TweenScale)
  self.title_TweenAlpha = self.title:GetComponent(TweenAlpha)
  self.title_TweenScale:ResetToBeginning()
  self.title_TweenAlpha:ResetToBeginning()
  self.resultLabel = self:FindGO("Label", self.title):GetComponent(UILabel)
  self.resultLabel_EN = self:FindGO("Label_EN", self.title):GetComponent(UILabel)
  self.titleTexture1 = self:FindGO("Texture1", self.title):GetComponent(UITexture)
  self.titleTexture2 = self:FindGO("Texture2", self.title):GetComponent(UITexture)
  self.rankGrid = self:FindComponent("RankGrid", UIGrid)
  self.rankListCells = UIGridListCtrl.new(self.rankGrid, DisneyQTEResultCell, "DisneyQTEResultCell")
  self.closeBtn = self:FindGO("CloseButton")
  self.closeBtnLabel = self:FindGO("Label", self.closeBtn):GetComponent(UILabel)
end

function DisneyQTEResultView:AddEvts()
end

function DisneyQTEResultView:InitView()
end

function DisneyQTEResultView:AddListenEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.handlePlayerMapChange)
end

function DisneyQTEResultView:InitShow()
  if self.pending then
    self.uiTop:SetActive(false)
    return
  else
    self.uiTop:SetActive(true)
  end
  self:UpdateResultInfo()
  self.closeBtn:SetActive(false)
  self.closeBtnLabel.text = string.format(ZhString.DisneyMusical_LeaveFuben, self.leftTime)
  self.tickMg:ClearTick(self)
  TimeTickManager.Me():CreateOnceDelayTick(4000, function(owner, deltaTime)
    self.closeBtn:SetActive(true)
  end, self)
  self.tickMg:CreateTick(0, 1000, self.updateCountDownTime, self)
end

function DisneyQTEResultView:AddCloseButtonEvent()
  self:AddButtonEvent("CloseButton", function()
    self:FakeHideUI()
  end)
end

function DisneyQTEResultView:UpdateResultInfo()
  self.rankListCells:ResetDatas(self.rankInfo)
  if self.isWin == true then
    self.resultLabel.text = ZhString.CookMaster_Win
    self.resultLabel.gradientTop = LuaColor.white
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(1, 0.5764705882352941, 0.49411764705882355, 1)
    self.resultLabel_EN.text = "V  I  C  T  O  R  Y"
    self.resultLabel_EN.gradientTop = LuaColor.white
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.9607843137254902, 0.6823529411764706, 0.3764705882352941, 1)
  else
    if self.isWin == 0 then
      self.resultLabel.text = ZhString.CookMaster_Draw
      self.resultLabel_EN.text = "D  R  A  W"
    else
      self.resultLabel.text = ZhString.CookMaster_Lose
      self.resultLabel_EN.text = "F  A  I  L  U  R  E"
    end
    self.resultLabel.gradientTop = LuaColor.white
    self.resultLabel.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
    self.titleTexture1.color = LuaGeometry.GetTempVector4(0.6392156862745098, 0.7450980392156863, 0.9647058823529412, 1)
    self.resultLabel_EN.gradientTop = LuaColor.white
    self.resultLabel_EN.gradientBottom = LuaGeometry.GetTempVector4(0.6627450980392157, 0.6784313725490196, 0.9254901960784314, 1)
  end
end

function DisneyQTEResultView:updateCountDownTime()
  self.leftTime = self.leftTime - 1
  if self.leftTime < 0 then
    self:FakeHideUI()
    return
  end
  self.closeBtnLabel.text = string.format(ZhString.CookMaster_CountDown, self.leftTime)
end

function DisneyQTEResultView:FakeHideUI()
  self.tickMg:ClearTick(self)
  ServiceFuBenCmdProxy.Instance:CallExitMapFubenCmd()
  self.uiTop:SetActive(false)
end

function DisneyQTEResultView:OnEnter()
  DisneyQTEResultView.super.OnEnter(self)
  PictureManager.Instance:SetUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:SetUI("Japanesecopy_bg_light", self.titleTexture2)
end

function DisneyQTEResultView:OnExit()
  self.tickMg:ClearTick(self)
  DisneyQTEResultView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_bottom", self.titleTexture1)
  PictureManager.Instance:UnLoadUI("Japanesecopy_bg_light", self.titleTexture2)
end

function DisneyQTEResultView:handlePlayerMapChange(note)
  self:CloseSelf()
end
