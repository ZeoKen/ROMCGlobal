MainViewSkadaInfoPage = class("MainViewSkadaInfoPage", MainViewDungeonInfoSubPage)

function MainViewSkadaInfoPage:Init()
  self:ReLoadPerferb("view/MainViewSkadaInfoPage")
  self:InitUI()
  self:AddViewEvents()
end

function MainViewSkadaInfoPage:InitUI()
  self.traceNewVer = false
  if not self.traceNewVer then
    self.taskBord = self:FindGO("ClassicTraceBord", self.traceInfoParent.gameObject)
  else
    self.taskBord = self:FindGO("TaskQuestBord", self.traceInfoParent.gameObject)
  end
  local text1 = self:FindComponent("text1", UILabel)
  local text2 = self:FindComponent("text2", UILabel)
  local text3 = self:FindComponent("text3", UILabel)
  local text4 = self:FindComponent("text4", UILabel)
  text1.text = ZhString.MainViewSkadaInfoPage_text1
  text2.text = ZhString.MainViewSkadaInfoPage_text2
  text3.text = ZhString.MainViewSkadaInfoPage_text3
  text4.text = ZhString.MainViewSkadaInfoPage_text4
  self.countdown = self:FindComponent("countdown", UILabel)
  self.resetbtn = self:FindGO("resetbtn")
  self:AddClickEvent(self.resetbtn, function()
    self:ResetAnalysis()
  end)
  self.dpsvalue = self:FindComponent("dpsvalue", UILabel)
  self.sumvalue = self:FindComponent("sumvalue", UILabel)
  local t1, t2, t3, t4
  t1 = self:FindGO("type1")
  t2 = self:FindGO("type2")
  t3 = self:FindGO("type3")
  t4 = self:FindGO("type4")
  self.type1Slider = self:FindComponent("slider", UISlider, t1)
  self.type2Slider = self:FindComponent("slider", UISlider, t2)
  self.type3Slider = self:FindComponent("slider", UISlider, t3)
  self.type4Slider = self:FindComponent("slider", UISlider, t4)
  self.type1Value = self:FindComponent("value", UILabel, t1)
  self.type2Value = self:FindComponent("value", UILabel, t2)
  self.type3Value = self:FindComponent("value", UILabel, t3)
  self.type4Value = self:FindComponent("value", UILabel, t4)
  t3:SetActive(false)
end

function MainViewSkadaInfoPage:OnEnter()
  MainViewSkadaInfoPage.super.OnEnter(self)
  self:HideSelf()
end

function MainViewSkadaInfoPage:ShowSelf()
  self:Show()
  self.taskBord:SetActive(false)
end

function MainViewSkadaInfoPage:HideSelf()
  self:Hide()
  self.taskBord:SetActive(true)
end

function MainViewSkadaInfoPage:AddViewEvents()
  self:AddListenEvt(MyselfEvent.SelectTargetChange, self.OnSelectTargetChange)
end

function MainViewSkadaInfoPage:OnSelectTargetChange(note)
  if self.selectSkada then
    self.selectId = nil
    self.selectFurnitureId = nil
    self:HideSelf()
    self.selectSkada:SetOnSelect(false)
  end
  local selectid = note and note.body and note.body.data and note.body.data.id
  if selectid then
    self.selectId = selectid
    self.selectSkada = HomeSkadaManager.Me():GetSkadaMonitor(self.selectId)
    if self.selectSkada then
      if self.selectSkada:IsMonitoring() then
        self:ShowSelf()
      end
      self.selectSkada:SetOnSelect(true, function(mo)
        self:ShowSelf()
      end, function(mo)
        self:UpdateView(mo)
      end, function(mo)
        self.selectId = nil
        self:HideSelf()
      end)
      self.selectFurnitureId = note.body.data:GetRelativeFurnitureID()
    end
  end
end

function MainViewSkadaInfoPage:UpdateView(mo)
  local t1p = mo.damageAllSum > 0 and mo.damagePhysicalSum / mo.damageAllSum or 0
  local t2p = mo.damageAllSum > 0 and mo.damageMagicalSum / mo.damageAllSum or 0
  local t4p = mo.damageAllSum > 0 and mo.damageOtherSum / mo.damageAllSum or 0
  self.type1Slider.value = t1p
  self.type1Value.text = string.format("%.2f%%", t1p * 100)
  self.type2Slider.value = t2p
  self.type2Value.text = string.format("%.2f%%", t2p * 100)
  self.type4Slider.value = t4p
  self.type4Value.text = string.format("%.2f%%", t4p * 100)
  self.sumvalue.text = mo.damageAllSum
  self.dpsvalue.text = string.format("%.2f", mo.dps)
  local min = (mo.monitorTime or 0) / 60
  local sec = (mo.monitorTime or 0) % 60
  if min == 0 then
    self.countdown.text = string.format("%ds", sec)
  else
    self.countdown.text = string.format("%dmin%ds", min, sec)
  end
end

function MainViewSkadaInfoPage:ResetAnalysis()
  if self.selectSkada then
    ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.WoodOver, self.selectFurnitureId)
    self.selectSkada:ResetMonitor()
  end
end
