local baseCell = autoImport("BaseCell")
ActivityHitPollyQuestCell = class("ActivityHitPollyQuestCell", baseCell)
local greyOutline = Color(0.8470588235294118, 0.8470588235294118, 0.8470588235294118)
local greyColor = Color(0.4666666666666667, 0.4666666666666667, 0.4823529411764706)
local greenOutline = Color(0.8549019607843137, 0.9725490196078431, 0.9372549019607843)
local greenColor = Color(0.19215686274509805, 0.5411764705882353, 0.043137254901960784)
local DAY_SECOND = 86400
local FIXED_ICON_SIZE = 50
local goBtnOutLineColor = {
  effectColor = {
    Color(0.06274509803921569, 0.16470588235294117, 0.5490196078431373),
    Color(0.6196078431372549, 0.33725490196078434, 0 / 255)
  },
  BtnSp = {"com_btn_1s", "com_btn_2s"}
}
ActivityHitPollyQuestCellEvent = {
  ClickGo = "ActivityHitPollyQuestCell_ClickGo"
}

function ActivityHitPollyQuestCell:Init()
  self:FindObj()
  self:AddEvt()
end

function ActivityHitPollyQuestCell:FindObj()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.name = self:FindComponent("Name", UILabel)
  self.progress = self:FindComponent("Progress", UILabel)
  self.stateLab = self:FindComponent("StateLab", UILabel)
  self.goButton = self:FindComponent("GOButton", UISprite)
  self.goButtonLab = self:FindComponent("ActionName", UILabel, self.goButton.gameObject)
  self.durationLabel = self:FindGO("Duration"):GetComponent(UILabel)
  self.questRoot = self:FindGO("QuestRoot")
  self.shopRoot = self:FindGO("ShopRoot")
  self.shopDesc = self:FindComponent("ShopDesc", UILabel, self.shopRoot)
  self.limitedLab = self:FindComponent("Limited", UILabel, self.shopRoot)
  self.shopGoodsIcon = self:FindComponent("GoodsIcon", UISprite, self.shopRoot)
  self.buyButton = self:FindComponent("BuyButton", UISprite, self.shopRoot)
  self.buyLab = self:FindComponent("Lab", UILabel, self.buyButton.gameObject)
  self.locked = self:FindGO("Lock")
  self.buyLab.text = ZhString.HappyShop_Buy
  self:AddCellClickEvent()
end

function ActivityHitPollyQuestCell:AddEvt()
  self:AddClickEvent(self.goButton.gameObject, function()
    if self.data.status == ActHitPolly_pb.EACCHITPOLLY_QUEST_ON then
      local gotoMode = self.data.staticData.GotoMode
      if nil ~= gotoMode and _EmptyTable ~= gotoMode then
        self:PassEvent(ActivityHitPollyQuestCellEvent.ClickGo, self)
        self:PassEvent(ActivityPuzzleGoEvent.MouseClick, self)
      end
    else
      ServiceActHitPollyProxy.Instance:CallActityHitPollySubmitQuest(self.data.staticData.id)
    end
  end)
  self:AddClickEvent(self.buyButton.gameObject, function()
    local _proxy = ActivityHitPollyProxy.Instance
    local rest = _proxy:GetRestBuyParam()
    if rest <= 0 then
      return
    end
    if MyselfProxy.Instance:GetROB() < self.data.price then
      MsgManager.ShowMsgByID(1)
      return
    end
    if not _proxy:IsActivityDateValid() or not _proxy:HasAllRewardLeft() then
      MsgManager.ShowMsgByID(40973)
      return
    end
    if self.shopid then
      ServiceSessionShopProxy.Instance:CallBuyShopItem(self.shopid, 1)
    end
  end)
end

local _ShopBtn = {
  "com_btn_13s",
  "com_btn_2s"
}

function ActivityHitPollyQuestCell:SetData(data)
  self:ClearTick()
  self.data = data
  if not data or not data.staticData then
    self.questRoot:SetActive(false)
    self.shopRoot:SetActive(true)
    IconManager:SetItemIcon(Table_Item[data.goodsID].Icon, self.shopGoodsIcon)
    self.shopDesc.text = string.format(ZhString.ActivityHitPolly_ShopDesc, data.price)
    self.shopid = data.id
    local rest, total = ActivityHitPollyProxy.Instance:GetRestBuyParam()
    if rest <= 0 then
      self.buyButton.spriteName = _ShopBtn[1]
      self.buyLab.effectColor = ColorUtil.NGUIGray
    else
      self.buyButton.spriteName = _ShopBtn[2]
      self.buyLab.effectColor = ColorUtil.ButtonLabelOrange
    end
    self.limitedLab.text = string.format(ZhString.MVPFightInfoBord_KillCount, total - rest, total)
    return
  end
  self.questRoot:SetActive(true)
  self.shopRoot:SetActive(false)
  local staticData = data.staticData
  self.name.text = staticData.Desc
  if staticData.Icon == "" or not IconManager:SetIconByType(staticData.Icon, self.icon, staticData.Atlas, "uiicon") then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.icon.width, self.icon.height = FIXED_ICON_SIZE, FIXED_ICON_SIZE
  if staticData.UnlockTime then
    self.progress.text = string.format(ZhString.MVPFightInfoBord_KillCount, data.process, staticData.UnlockTime)
  else
    self.progress.text = ""
  end
  if data.status == ActHitPolly_pb.EACCHITPOLLY_QUEST_ON then
    if nil == staticData.GotoMode or staticData.GotoMode == _EmptyTable then
      self.goButton.gameObject:SetActive(false)
      self.stateLab.gameObject:SetActive(true)
      self:SetStateLab(false)
    else
      self.stateLab.gameObject:SetActive(false)
      self.goButton.gameObject:SetActive(true)
      self.goButton.spriteName = goBtnOutLineColor.BtnSp[1]
      self.goButtonLab.text = ZhString.GuildActivityCell_Go
      self.goButtonLab.effectColor = goBtnOutLineColor.effectColor[1]
    end
    self.locked:SetActive(false)
    if not self.timeTick then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 1)
    end
  elseif data.status == ActHitPolly_pb.EACCHITPOLLY_QUEST_NOT_OPEN then
    self.goButton.gameObject:SetActive(false)
    self.stateLab.gameObject:SetActive(false)
    self.locked:SetActive(true)
    self.durationLabel.text = self.data.durationStr
  elseif data.status == ActHitPolly_pb.EACCHITPOLLY_QUEST_FINISH then
    self.goButton.gameObject:SetActive(false)
    self.stateLab.gameObject:SetActive(true)
    self:SetStateLab(true)
    self.locked:SetActive(false)
    self.durationLabel.text = self.data.durationStr
  else
    self.locked:SetActive(false)
    self.goButton.gameObject:SetActive(true)
    self.goButton.spriteName = goBtnOutLineColor.BtnSp[2]
    self.goButtonLab.text = ZhString.ActivityHitPolly_Submit
    self.goButtonLab.effectColor = goBtnOutLineColor.effectColor[2]
    self.stateLab.gameObject:SetActive(false)
    self.durationLabel.text = self.data.durationStr
  end
end

function ActivityHitPollyQuestCell:SetStateLab(complete)
  self.stateLab.text = complete and ZhString.ActivityPuzzle_Complete or ZhString.ActivityPuzzle_Ongoin
  self.stateLab.effectColor = complete and greyOutline or greenOutline
  self.stateLab.effectStyle = complete and UILabel.Effect.Outline or UILabel.Effect.Outline
  self.stateLab.color = complete and greyColor or greenColor
end

local day, hour, min, sec

function ActivityHitPollyQuestCell:UpdateCountDown()
  if self:ObjIsNil(self.gameObject) then
    self:ClearTick()
    return
  end
  local lefttime = self.data.endTimeStamp - ServerTime.CurServerTime() / 1000
  if 0 < lefttime then
    day, hour, min = ClientTimeUtil.FormatTimeBySec(lefttime)
    min = min ~= 0 and min or 1
    if lefttime >= DAY_SECOND then
      self.durationLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInDays, day)
    else
      self.durationLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInHours, hour, min)
    end
  else
    self:ClearTick()
    self.durationLabel.text = self.data.durationStr
  end
end

function ActivityHitPollyQuestCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.timeTick = nil
  end
end

function ActivityHitPollyQuestCell:OnCellDestroy()
  self:ClearTick()
end
