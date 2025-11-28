autoImport("BaseView")
SgMachineView = class("SgMachineView", BaseView)
SgMachineView.ViewType = UIViewType.NormalLayer

function SgMachineView:Init()
  self.m_uiImgMainView = self:FindGO("uiImgBg"):GetComponent(UISprite)
  self.m_uiImgLock1Disable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock1/uiImgLock"):GetComponent(UISprite)
  self.m_uiImgLock1Enable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock1/uiImgUnLock"):GetComponent(UISprite)
  self.m_uiImgLock1ON = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock1/uiImgBtn/uiImgON"):GetComponent(UISprite)
  self.m_uiImgLock1OFF = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock1/uiImgBtn/uiImgOFF"):GetComponent(UISprite)
  self.m_uiImgLock2Disable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock2/uiImgLock"):GetComponent(UISprite)
  self.m_uiImgLock2Enable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock2/uiImgUnLock"):GetComponent(UISprite)
  self.m_uiImgLock2ON = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock2/uiImgBtn/uiImgON"):GetComponent(UISprite)
  self.m_uiImgLock2OFF = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock2/uiImgBtn/uiImgOFF"):GetComponent(UISprite)
  self.m_uiImgLock3Disable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock3/uiImgLock"):GetComponent(UISprite)
  self.m_uiImgLock3Enable = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock3/uiImgUnLock"):GetComponent(UISprite)
  self.m_uiImgLock3ON = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock3/uiImgBtn/uiImgON"):GetComponent(UISprite)
  self.m_uiImgLock3OFF = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock3/uiImgBtn/uiImgOFF"):GetComponent(UISprite)
  self.m_uiTxtTitle = self:FindGO("uiImgBg/uiImgTitle/uiTxtName"):GetComponent(UILabel)
  self.m_uiTxtTips = self:FindGO("uiImgBg/uiImgTips/uiTxtContent"):GetComponent(UILabel)
  self.m_uiImgBtnClose = self:FindGO("uiImgBg/uiImgBtnClose")
  self.m_uiImgBtnOK = self:FindGO("uiImgBg/uiImgBtnOK")
  self.m_uiImgBtnLock1 = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock1/uiImgBtn")
  self.m_uiImgBtnLock2 = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock2/uiImgBtn")
  self.m_uiImgBtnLock3 = self:FindGO("uiImgBg/uiImgMiddle/uiImgLock3/uiImgBtn")
  self:AddClickEvent(self.m_uiImgBtnClose, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.m_uiImgBtnOK, function()
    self:onClickBtnOK()
  end)
  self:AddClickEvent(self.m_uiImgBtnLock1, function()
    self:onClickBtnLock1()
  end)
  self:AddClickEvent(self.m_uiImgBtnLock2, function()
    self:onClickBtnLock2()
  end)
  self:AddClickEvent(self.m_uiImgBtnLock3, function()
    self:onClickBtnLock3()
  end)
  local keys = self.viewdata.viewdata.keys
  self.m_lock1State = keys[1] == 1
  self.m_lock2State = keys[2] == 1
  self.m_lock3State = keys[3] == 1
  self:changleLockState()
  self.m_curTrigger = self.viewdata.viewdata.trigger
  self.m_uiTxtTips.transform.parent.gameObject:SetActive(false)
  self.m_redEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgMachineTriggerRedEffect, self.m_uiImgLock1Enable.transform)
  self.m_blueEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgMachineTriggerBlueEffect, self.m_uiImgLock2Enable.transform)
  self.m_yellowEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgMachineTriggerYellowEffect, self.m_uiImgLock3Enable.transform)
end

function SgMachineView:onTimeTickFinished()
  self.m_uiTxtTips.transform.parent.gameObject:SetActive(false)
  self:CloseSelf()
end

function SgMachineView:onClickBtnOK()
  local r = self.m_lock1State and 1 or 0
  local b = self.m_lock2State and 1 or 0
  local y = self.m_lock3State and 1 or 0
  self.m_curTrigger:SetKey(r, b, y)
  SgAIManager.Me():recordHistoryData(nil)
  self:CloseSelf()
end

function SgMachineView:onClickBtnLock1()
  self.m_lock1State = not self.m_lock1State
  self:changleLockState()
end

function SgMachineView:onClickBtnLock2()
  self.m_lock2State = not self.m_lock2State
  self:changleLockState()
end

function SgMachineView:onClickBtnLock3()
  self.m_lock3State = not self.m_lock3State
  self:changleLockState()
end

function SgMachineView:changleLockState()
  self.m_uiImgLock1Disable.gameObject:SetActive(not self.m_lock1State)
  self.m_uiImgLock1Enable.gameObject:SetActive(self.m_lock1State)
  self.m_uiImgLock1OFF.gameObject:SetActive(not self.m_lock1State)
  self.m_uiImgLock1ON.gameObject:SetActive(self.m_lock1State)
  self.m_uiImgLock2Disable.gameObject:SetActive(not self.m_lock2State)
  self.m_uiImgLock2Enable.gameObject:SetActive(self.m_lock2State)
  self.m_uiImgLock2OFF.gameObject:SetActive(not self.m_lock2State)
  self.m_uiImgLock2ON.gameObject:SetActive(self.m_lock2State)
  self.m_uiImgLock3Disable.gameObject:SetActive(not self.m_lock3State)
  self.m_uiImgLock3Enable.gameObject:SetActive(self.m_lock3State)
  self.m_uiImgLock3OFF.gameObject:SetActive(not self.m_lock3State)
  self.m_uiImgLock3ON.gameObject:SetActive(self.m_lock3State)
  self:PlayUISound(AudioMap.StealthGame.OperationMachine)
end

function SgMachineView:CloseSelf()
  if self.m_redEffect ~= nil then
    ReusableObject.Destroy(self.m_redEffect)
    self.m_redEffect = nil
  end
  if self.m_blueEffect ~= nil then
    ReusableObject.Destroy(self.m_blueEffect)
    self.m_blueEffect = nil
  end
  if self.m_yellowEffect ~= nil then
    ReusableObject.Destroy(self.m_yellowEffect)
    self.m_yellowEffect = nil
  end
  SgMachineView.super.CloseSelf(self)
end
