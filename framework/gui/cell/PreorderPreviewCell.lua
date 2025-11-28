PreorderPreviewCell = class("PreorderPreviewCell", ItemCell)

function PreorderPreviewCell:Init()
  PreorderPreviewCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:AddCellClickEvent()
end

function PreorderPreviewCell:FindObjs()
  self.lock = self:FindGO("Lock")
  self.preview = self:FindGO("Preview")
  self.name = self:FindGO("Name", self.preview):GetComponent(UILabel)
  self.money = self:FindGO("Money", self.preview):GetComponent(UILabel)
  self.moneyIcon = self:FindGO("MoneyIcon"):GetComponent(UISprite)
  IconManager:SetItemIcon(Table_Item[100].Icon, self.moneyIcon)
  self.stateBg = self:FindGO("stateBg", self.preview):GetComponent(UISprite)
  self.state = self:FindGO("state", self.preview):GetComponent(UILabel)
  self.countdown = self:FindGO("Countdown", self.preview):GetComponent(UILabel)
  self.empty = self:FindGO("Empty")
  self.numLab = self:FindGO("NumLabel"):GetComponent(UILabel)
end

function PreorderPreviewCell:AddEvts()
end

function PreorderPreviewCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  self:OnDestroy()
  if data then
    if data.itemid then
      local item = Table_Item[data.itemid]
      if item ~= nil then
        self.name.text = item.NameZh
        UIUtil.WrapLabel(self.name)
      end
      PreorderPreviewCell.super.SetData(self, data:GetItemData())
    end
    self.data = data
    local count = data.count or 1
    count = 0 < count and count or 1
    if data.price then
      local leftmoney = data.price - (data.buyprice or 0)
      self.money.text = StringUtil.NumThousandFormat(leftmoney)
    end
    if self.choose then
      self.choose:SetActive(false)
    end
    if 1 < count then
      self.numLab.text = tostring(count)
    else
      self.numLab.text = ""
    end
    if data.status == PreorderStatus.Null then
      if ShopMallPreorderProxy.Instance:IsFunctionUnlocked() then
        self.lock:SetActive(false)
        self.empty:SetActive(true)
      else
        self.lock:SetActive(true)
        self.empty:SetActive(false)
      end
      self.preview:SetActive(false)
    else
      self.lock:SetActive(false)
      self.empty:SetActive(false)
      self.preview:SetActive(true)
      if data.status == PreorderStatus.Preordering then
        self.stateBg.gameObject:SetActive(false)
        if data.expiretime and 0 >= data.expiretime then
          self.countdown.gameObject:SetActive(false)
        else
          if self.timeTick == nil then
            self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountdown, self)
          end
          self:UpdateCountdown()
          self.countdown.gameObject:SetActive(true)
        end
      elseif data.status == PreorderStatus.Finished then
        self.stateBg.gameObject:SetActive(true)
        self.countdown.gameObject:SetActive(false)
        if self.data.buycount == self.data.count then
          self.stateBg.spriteName = "exchange_list_jiaobiao_bg2"
          self.state.text = ZhString.ShopMallPreorderState_Closed
        else
          self.stateBg.spriteName = "exchange_list_jiaobiao_bg1"
          self.state.text = ZhString.ShopMallPreorderState_Finished
        end
      elseif data.status == PreorderStatus.Closed then
        self.stateBg.gameObject:SetActive(false)
        self.countdown.gameObject:SetActive(false)
      end
    end
  end
end

function PreorderPreviewCell:SetChoose(isChoose)
  if isChoose then
    self.choose:SetActive(true)
  else
    self.choose:SetActive(false)
  end
end

function PreorderPreviewCell:ClickCell()
  if self.data.status == PreorderStatus.Null then
    if ShopMallPreorderProxy.Instance:IsFunctionUnlocked() then
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ShopMallExchangeSearchView,
        viewdata = {isPreording = true}
      })
    else
      MsgManager.ShowMsgByID(43383)
      return
    end
  elseif self.data.status == PreorderStatus.Preordering then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopMallPreorderInfoView,
      viewdata = {
        orderid = self.data.id
      }
    })
  elseif self.data.status == PreorderStatus.Finished then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopMallPreorderInfoView,
      viewdata = {
        orderid = self.data.id
      }
    })
  elseif self.data.status == PreorderStatus.Closed then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.ShopMallPreorderInfoView,
      viewdata = {
        orderid = self.data.id
      }
    })
  end
end

function PreorderPreviewCell:UpdateCountdown()
  if self.data then
    local time = (self.data.expiretime or 0) - ServerTime.CurServerTime() / 1000
    local min, sec
    if 0 < time then
      min, sec = ClientTimeUtil.GetFormatSecTimeStr(time)
    else
      min = 0
      sec = 0
    end
    self.countdown.text = string.format("%02d:%02d", min, sec)
    if min == 0 and sec == 0 then
      self:OnDestroy()
    end
  end
end

function PreorderPreviewCell:SetItemQualityBG(quality)
  local spName = self.DefaultBg_spriteName or "com_icon_bottom3"
  if self.bg.spriteName ~= spName then
    self.bg.atlas = self.DefaultBg_atlas or RO.AtlasMap.GetAtlas("NewCom")
    self.bg.spriteName = spName
  end
end

function PreorderPreviewCell:OnDestroy()
  self.timeTick = nil
  TimeTickManager.Me():ClearTick(self)
end

function PreorderPreviewCell:OnRemove()
  self:OnDestroy()
end
