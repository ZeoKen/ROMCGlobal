autoImport("GainWayTip")
BFBuildingDonateConfirmCell = class("BFBuildingDonateConfirmCell", ShopItemInfoCell)
local fdata = {
  pos = {},
  items = {},
  elements = {},
  weather = {},
  block = {},
  timer = {
    datas = {
      pos = {}
    }
  }
}

function BFBuildingDonateConfirmCell:Exit()
  self.countInput.value = 1
  BFBuildingDonateConfirmCell.super.Exit(self)
end

function BFBuildingDonateConfirmCell:FindObjs()
  BFBuildingDonateConfirmCell.super.FindObjs(self)
  self.ownInfo = self:FindGO("OwnInfo"):GetComponent(UILabel)
  self.limitCount = self:FindGO("LimitCount"):GetComponent(UILabel)
  self.fullPrompt = self:FindGO("FullPrompt")
  IconManager:SetArtFontIcon("Rewardtask_txt_1", self.fullPrompt:GetComponent(UISprite))
  self.bg = self:FindGO("Bgg"):GetComponent(UISprite)
  self:AddClickEvent(self:FindGO("Close"), function()
    self:Cancel()
  end)
  self.getPathButton = self:FindGO("GetPathButton")
  self:AddClickEvent(self.getPathButton, function()
    self:ShowGainWayTip()
  end)
  self.gpContainer = self:FindGO("GetPathContainer")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  self.confirmBC = self.confirmButton:GetComponent(BoxCollider)
end

function BFBuildingDonateConfirmCell:SetCountInput(count)
  self.countInput.value = count
end

function BFBuildingDonateConfirmCell:SetData(data)
  self.bid = data.bid
  self.needNum = data.needNum
  self.data = data.itemData
  self.maxcount = math.min(self:UpdateOwnInfo() or 0, self.needNum)
  local curInputValue = self.countInput.value
  BFBuildingDonateConfirmCell.super.SetData(self, self.data)
  self.limitCount.text = ZhString.BFBuilding_xuqiu .. self.needNum
  self.fullPrompt.gameObject:SetActive(self.needNum <= 0)
  self.bg.height = self.needNum <= 0 and 310 or 464
  self.countInput.gameObject:SetActive(self.needNum > 0)
  self.confirmButton.gameObject:SetActive(self.needNum > 0)
  self.getPathButton.gameObject:SetActive(self.needNum > 0)
  self:CloseGetPath()
  self:UpdateTotalPrice(math.min(self.maxcount, tonumber(curInputValue) or 0))
end

function BFBuildingDonateConfirmCell:UpdateOwnInfo()
  local shopdata = self.data
  if shopdata then
    if shopdata.source == HappyShopProxy.SourceType.UserGuild then
      local guildOwn = GuildProxy.Instance:GetGuildPackItemNumByItemid(shopdata.goodsID)
      self.ownInfo.text = string.format(ZhString.HappyShop_OwnGuild, guildOwn)
      return
    end
    local own = BagProxy.Instance:GetItemNumByStaticID(shopdata.staticData.id, GameConfig.PackageMaterialCheck.default)
    if own then
      if shopdata.source == HappyShopProxy.SourceType.Guild then
        self.ownInfo.text = string.format(ZhString.HappyShop_OwnGuild, own)
      else
        self.ownInfo.text = string.format(ZhString.HappyShop_OwnInfo, own)
      end
    else
      self.ownInfo.text = 0
    end
    return own
  end
end

function BFBuildingDonateConfirmCell:UpdateTotalPrice(count)
  self.count = count
  if self.countInput.value ~= tostring(count) then
    self.countInput.value = count
  end
  if self.count > 0 then
    self.confirmBC.enabled = true
    self:SetTextureWhite(self.confirmButton, ColorUtil.ButtonLabelOrange)
  else
    self.confirmBC.enabled = false
    self:SetTextureGrey(self.confirmButton)
  end
end

local clienttest = false

function BFBuildingDonateConfirmCell:AddConfirmClickEvent()
  self:AddClickEvent(self.confirmButton.gameObject, function()
    self:Confirm()
    if clienttest then
      MsgManager.FloatMsg("", "捐献 " .. self.data.staticData.id .. " * " .. self.count)
      return
    end
    if self.count > 0 and self.data then
      ServiceNUserProxy.Instance:CallBuildContributeUserCmd({
        id = self.data.staticData.id,
        count = self.count
      }, fdata)
    end
  end)
end

function BFBuildingDonateConfirmCell:ShowGainWayTip()
  if not self.bdt then
    self.bdt = GainWayTip.new(self.gpContainer)
    self.bdt:SetAnchorPos(true)
    self.bdt:SetData(self.data.staticData.id)
    self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
      self.parentPanel:CloseSelf()
    end, self)
    self.bdt:AddIgnoreBounds(self.gameObject)
    self:AddIgnoreBounds(self.bdt.gameObject)
    self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
  else
    self.bdt:OnExit()
  end
end

function BFBuildingDonateConfirmCell:AddIgnoreBounds(obj)
  if self.gameObject and self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function BFBuildingDonateConfirmCell:GetPathCloseCall()
  if self.closecomp then
    self.closecomp:ReCalculateBound()
  end
  self.bdt = nil
end

function BFBuildingDonateConfirmCell:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end
