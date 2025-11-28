autoImport("CardPrayItemCell")
autoImport("TipLabelCell")
local _PagePath = "GUI/v1/part/LotteryPray"
local _LotteryProxy
local _TextureName = "Sevenroyalfamilies_bg_decoration10"
local _LabColor = LuaColor.New(0.5568627450980392, 0.42745098039215684, 0.2784313725490196, 1)
local _TxtBgColor = LuaColor.New(0.7803921568627451, 0.6666666666666666, 0.4980392156862745, 1)
local _PrayBtnEnabledEffectColor
LotteryPray = class("LotteryPray", CoreView)

function LotteryPray:ctor(parent)
  if not parent then
    return
  end
  _LotteryProxy = LotteryProxy.Instance
  self:CreateSelf(parent)
end

function LotteryPray:CreateSelf(parent)
  self.gameObject = self:LoadPreferb_ByFullPath(_PagePath, parent, true)
  self.gameObject.transform.localPosition = LuaVector3.Zero()
  self:InitBord()
end

function LotteryPray:InitBord()
  self:FindObjs()
end

function LotteryPray:FindObjs()
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:Hide()
  end)
  self.leftRoot = self:FindGO("LeftRoot")
  self.prayRuleLab = self:FindComponent("RuleTitle", UILabel, self.leftRoot)
  self.prayRuleLab.text = ZhString.Lottery_Pray_Rule
  self.table = self:FindComponent("Table", UITable)
  self.labCtl = UIGridListCtrl.new(self.table, TipLabelCell, "TipLabelCell")
  self.cardRoot = self:FindGO("CardRoot")
  self.cancelPrayBtn = self:FindGO("CancelPrayBtn", self.cardRoot)
  self:AddClickEvent(self.cancelPrayBtn, function()
    ServiceItemProxy.Instance:CallCardLotteryPrayItemCmd(self.lotteryType, 0)
  end)
  local curCardContainer = self:FindGO("CurCardContainer", self.cardRoot)
  local curCardPrefab = self:LoadPreferb("cell/CardPrayItemCell", curCardContainer)
  self.curCard = CardPrayItemCell.new(curCardPrefab)
  self.curPrayCardName = self:FindComponent("PrayCardLab", UILabel, self.cardRoot)
  self.cancelPrayBtnLab = self:FindComponent("Label", UILabel, self.cardRoot)
  self.cancelPrayBtnLab.text = ZhString.Lottery_Pray_Cancel
  self.prayingLab = self:FindComponent("PrayingLab", UILabel, self.cardRoot)
  self.prayingLab.text = ZhString.Lottery_Praying
  self.progressLab = self:FindComponent("ProgressLab", UILabel, self.cardRoot)
  self.uiTexture = self:FindComponent("Texture", UITexture, self.cardRoot)
  PictureManager.Instance:SetSevenRoyalFamiliesTexture(_TextureName, self.uiTexture)
  self.noCardRoot = self:FindGO("NoCardRoot")
  self.waittingPrayCardGrid = self:FindComponent("CardGrid", UIGrid, self.noCardRoot)
  self.cardCtrl = UIGridListCtrl.new(self.waittingPrayCardGrid, CardPrayItemCell, "CardPrayItemCell")
  self.cardCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCard, self)
  self.cardCtrl:AddEventListener(MouseEvent.LongPress, self.OnPressCard, self)
  self.noCardSelectTipLab = self:FindComponent("SelectTipLab", UILabel)
  self.noCardSelectTipLab.text = ZhString.Lottery_Pray_Select
  self.prayBtn = self:FindComponent("PrayBtn", UISprite, self.noCardRoot)
  self.prayBtnLab = self:FindComponent("Label", UILabel, self.prayBtn.gameObject)
  self.prayBtnLab.text = ZhString.Lottery_Pray
  _PrayBtnEnabledEffectColor = self.prayBtnLab.effectColor
  self:AddClickEvent(self.prayBtn.gameObject, function()
    ServiceItemProxy.Instance:CallCardLotteryPrayItemCmd(self.lotteryType, self.chooseCardId)
  end)
  self.longPressTipLab = self:FindComponent("LongPressTipLab", UILabel, self.noCardRoot)
  self.longPressTipLab.text = ZhString.Lottery_RecoverTipDesc
  self.waittingPrayLab_Pre = self:FindComponent("WaittingPrayPreLab", UILabel, self.noCardRoot)
  self.waittingPrayLab_Pre.text = ZhString.Lottery_Pray_Pre
  self.waittingPrayLab_Pray = self:FindComponent("PrayLab", UILabel, self.noCardRoot)
  self.waittingPrayLab_Pray.text = ZhString.Lottery_Pray
  self.waittingPrayLab_Card = self:FindComponent("waittingPrayLab_Card", UILabel, self.noCardRoot)
  self.tipStick = self:FindComponent("TipStick", UIWidget)
  local decorateRoot = self:FindGO("DecorateRoot")
  self.decorateLine = self:FindGO("Decorate (13)", decorateRoot)
  self.remainPrayCountLab = self:FindComponent("RemainPray", UILabel, self.noCardRoot)
end

function LotteryPray:DestroyEff()
  if self.uiEffect and self.uiEffect:Alive() then
    self.uiEffect:Destroy()
  end
  self.uiEffect = nil
end

function LotteryPray:OnClickCard(cellCtl)
  local data = cellCtl.data and cellCtl.data.staticData
  if not data then
    return
  end
  if self.chooseCardId == data.id then
    return
  end
  self.chooseCardId = data.id
  self.waittingPrayLab_Card.text = data.NameZh
  self:ChooseCard()
end

function LotteryPray:OnPressCard(param)
  local isPressing, cellCtl = param[1], param[2]
  if isPressing then
    if cellCtl and cellCtl.data then
      local data = cellCtl.data
      if data then
        local callback = function()
          self:CancelChooseCard()
        end
        local sdata = {
          itemdata = data,
          funcConfig = {},
          callback = callback,
          ignoreBounds = {
            cellCtl.gameObject
          },
          showCloseBtn = true
        }
        TipManager.Instance:ShowItemFloatTip(sdata, self.tipStick, NGUIUtil.AnchorSide.Left, {200, 0})
      end
      self.chooseCard = cellCtl
    else
      self:CancelChooseCard()
    end
  else
  end
end

function LotteryPray:CancelChooseCard()
  self.chooseCard = nil
  self:ShowItemTip()
  LuaGameObject.SetLocalPositionGO(self.gameObject, 0, 0, 0)
end

function LotteryPray:ChooseCard()
  local cells = self.cardCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(self.chooseCardId)
  end
end

function LotteryPray:SelectFirst()
  local cell = self.cardCtrl:GetCells()[1]
  if cell then
    self:OnClickCard(cell)
  end
end

function LotteryPray:UpdateByLotteryType(t)
  local checkOpen = _LotteryProxy:CheckCardLotteryPrayOpen(t)
  if not checkOpen then
    self:Hide()
    return
  end
  self:Show()
  self.lotteryType = t
  self:UpdatePray(t)
end

function LotteryPray:UpdatePray(t)
  self.data = _LotteryProxy:GetCardPrayData(t)
  self.card_id = self.data:GetPrayInfo()
  if 0 == self.card_id then
    self:Show(self.noCardRoot)
    self:Hide(self.cardRoot)
    local cardData = _LotteryProxy:GetCardUpData(self.lotteryType)
    self.cardCtrl:ResetDatas(cardData)
    self:SelectFirst()
    self:Hide(self.curCard.gameObject)
    LuaGameObject.SetLocalPositionGO(self.decorateLine, 208, -13, 0)
    local leftPrayCount = self.data:GetLeftPrayCount() or -1
    self.remainPrayCountLab.gameObject:SetActive(-1 < leftPrayCount)
    self.remainPrayCountLab.text = string.format(ZhString.CardLottery_RemainPrayCount, leftPrayCount)
    self:SetButtonEnable(self.prayBtn, leftPrayCount == -1 or 0 < leftPrayCount, _PrayBtnEnabledEffectColor)
  else
    self:Show(self.cardRoot)
    self:Hide(self.noCardRoot)
    local cur, max = self.data:GetProgress()
    self.progressLab.text = string.format(ZhString.Lottery_Pray_Progress2, cur, max)
    self.curPrayCardName.text = self.data:GetName()
    self:Show(self.curCard.gameObject)
    self.curCard:SetData(self.data.cardData)
    LuaGameObject.SetLocalPositionGO(self.decorateLine, 208, -68, 0)
  end
  self:SetRule()
end

function LotteryPray:SetRule()
  if not self.data then
    return
  end
  if self.ruleInited then
    return
  end
  self.ruleInited = true
  self.contextDatas = {}
  local _temp = {
    label = {},
    hideline = true,
    color = _LabColor,
    txtBgColor = _TxtBgColor,
    fontsize = 20
  }
  local _, max = self.data:GetProgress()
  local rule_config = string.format(GameConfig.Lottery.CardPrayRule, max)
  local strs = string.split(rule_config, "\n")
  for i = 1, #strs - 1 do
    local cell = ItemTipDefaultUiIconPrefix .. strs[i]
    table.insert(_temp.label, cell)
  end
  local newConfig = GameConfig.CardLotteryNew and GameConfig.CardLotteryNew.TypeCfg and GameConfig.CardLotteryNew.TypeCfg[self.lotteryType]
  local isInherit = newConfig and newConfig.PrayCountInherit or false
  local cell = ItemTipDefaultUiIconPrefix .. (isInherit and ZhString.CardLottery_SafetyInheritRole or strs[#strs])
  table.insert(_temp.label, cell)
  self.contextDatas[#self.contextDatas + 1] = _temp
  self.labCtl:ResetDatas(self.contextDatas)
end

function LotteryPray:OnExit()
  self:DestroyEff()
  if self.cardCtrl then
    self.cardCtrl:Destroy()
  end
  if self.labCtl then
    self.labCtl:Destroy()
  end
  if self.uiTexture then
    PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(_TextureName, self.uiTexture)
  end
  LotteryPray.super.OnExit(self)
end

function LotteryPray:HandleUpdateLotteryPray()
  self:Hide()
end
