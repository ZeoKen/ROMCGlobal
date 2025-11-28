autoImport("BaseView")
SgPutDownItemView = class("SgPutDownItemView", BaseView)
SgPutDownItemView.ViewType = UIViewType.NormalLayer

function SgPutDownItemView:Init()
  self.m_uiTxtLeftCount = self:FindGO("uiImgItemIcon/uiTxtCount"):GetComponent(UILabel)
  self.m_uiImgBg = self:FindGO("uiImgBg"):GetComponent(UITexture)
  self.m_uiImgBg1 = self:FindGO("uiImgBg1"):GetComponent(UITexture)
  self.m_uiImgIcon = self:FindGO("uiImgItemIcon"):GetComponent(UISprite)
  self.m_uiImgPutDownBg = self:FindGO("uiImgBtnPutDown/Background"):GetComponent(UISprite)
  self.m_uiImgBtnMask = self:FindGO("uiBtnMask")
  self.m_uiImgBtnPutDown = self:FindGO("uiImgBtnPutDown"):GetComponent(UIButton)
  self.m_uiImgBtnTakeOut = self:FindGO("uiImgBtnTakeOut")
  self.m_triggerId = self.viewdata.viewdata.triggerId
  self:AddClickEvent(self.m_uiImgBtnMask, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.m_uiImgBtnPutDown.gameObject, function()
    self:onClickBtnPutDown()
  end)
  self:AddClickEvent(self.m_uiImgBtnTakeOut, function()
    self:onClickTakeOut()
  end)
  PictureManager.Instance:SetUI("qws_bg_qc", self.m_uiImgBg)
  PictureManager.Instance:SetUI("qws_bg_qc", self.m_uiImgBg1)
  self.m_curTrigger = SgAIManager.Me():findTrigger(self.m_triggerId)
  if self.m_curTrigger ~= nil then
    local id = self.m_curTrigger:getItemId()
    local data = Table_Item[id]
    if data ~= nil then
      IconManager:SetItemIcon(data.Icon, self.m_uiImgIcon)
    end
    self.m_uiTxtLeftCount.text = string.format(Table_Sysmsg[42125].Text, self.m_curTrigger:getLeftCount())
    if self.m_curTrigger:isPutDown() then
      self.m_uiImgBtnPutDown.gameObject:SetActive(false)
      self.m_uiImgBtnTakeOut.gameObject:SetActive(true)
      self.m_uiImgBg.gameObject:SetActive(false)
      self.m_uiImgBg1.gameObject:SetActive(true)
    else
      self.m_uiImgBtnPutDown.gameObject:SetActive(true)
      self.m_uiImgBtnTakeOut.gameObject:SetActive(false)
      self.m_uiImgBg.gameObject:SetActive(true)
      self.m_uiImgBg1.gameObject:SetActive(false)
      if self.m_curTrigger:hasItem() then
        self.m_uiImgBtnPutDown.isEnabled = true
        self.m_canPutDown = true
      else
        self.m_uiImgBtnPutDown.isEnabled = false
        self.m_canPutDown = false
      end
    end
    self.m_curTrigger:setUICallBack(self.CloseSelf, self)
  else
    redlog("not found trigger ï¼Œtrigger is " .. self.m_triggerId)
  end
end

function SgPutDownItemView:onClickBtnPutDown()
  if self.m_tickTime ~= nil then
    return
  end
  if self.m_canPutDown then
    self.m_curTrigger:putDownItem()
    self.m_uiImgBg.gameObject:SetActive(false)
    self.m_uiImgBg1.gameObject:SetActive(true)
    self.m_uiTxtLeftCount.text = string.format(Table_Sysmsg[42125].Text, self.m_curTrigger:getLeftCount())
    if self.m_uiEffect == nil then
      self.m_uiEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgPutDownOrTakeOutViewEffect, self.m_uiImgBg.transform.parent)
    end
    self.m_uiImgBtnPutDown.gameObject:SetActive(false)
    self.m_uiImgBtnTakeOut.gameObject:SetActive(true)
    self.m_uiImgBg.gameObject:SetActive(false)
    self.m_uiImgBg1.gameObject:SetActive(true)
    self:dealyClose()
  else
    self:CloseSelf()
  end
end

function SgPutDownItemView:dealyClose()
  if self.m_tickTime == nil then
    self.m_tickTime = TimeTickManager.Me():CreateTick(1500, 0, self.CloseSelf, self, 777)
  end
end

function SgPutDownItemView:onClickTakeOut()
  if self.m_tickTime ~= nil then
    return
  end
  self.m_curTrigger:takeOutItem()
  self.m_uiImgBtnPutDown.gameObject:SetActive(true)
  self.m_uiImgBtnTakeOut.gameObject:SetActive(false)
  self.m_uiImgBg.gameObject:SetActive(true)
  self.m_uiImgBg1.gameObject:SetActive(false)
  self.m_uiTxtLeftCount.text = string.format(Table_Sysmsg[42125].Text, self.m_curTrigger:getLeftCount())
  self:dealyClose()
end

function SgPutDownItemView:CloseSelf()
  if self.m_uiEffect ~= nil then
    ReusableObject.Destroy(self.m_uiEffect)
    self.m_uiEffect = nil
  end
  if self.m_tickTime ~= nil then
    TimeTickManager.Me():ClearTick(self, 777)
    self.m_tickTime = nil
  end
  SgPutDownItemView.super.CloseSelf(self)
end
