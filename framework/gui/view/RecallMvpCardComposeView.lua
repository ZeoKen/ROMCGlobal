autoImport("MvpCardComposeNewPage")
autoImport("RecallCardMakeRateUpCell")
autoImport("RecallMvpCardComposeMaterialCell")
RecallMvpCardComposeView = class("RecallMvpCardComposeView", MvpCardComposeNewPage)
local Prefab_Path = ResourcePathHelper.UIView("RecallMvpCardComposeView")
local DecoName = "mall_bg_key"
local ChooseBoardBgName = "mall_bg_bottom_10"

function RecallMvpCardComposeView:Init(initParam)
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.composeNum = 1
  self.makeType = CardMakeProxy.MakeType.MvpCardCompose
  self:LoadPrefab()
  self:FindObjs()
  self:AddViewEvts()
  self:InitFilter()
  self:InitMaterial()
  self:UpdateComposeNum()
  self:InitCardList()
end

function RecallMvpCardComposeView:LoadPrefab()
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, self.container, true)
  obj.name = "RecallMvpCardComposeView"
  self.gameObject = obj
end

function RecallMvpCardComposeView:FindObjs()
  MvpCardComposeNewPage.super.FindObjs(self)
  local rateUpCardGO = self:FindGO("CardMakeRateUpCell")
  self.rateUpCardCell = RecallCardMakeRateUpCell.new(rateUpCardGO)
  self.rateUpCardCell:AddEventListener(MouseEvent.LongPress, self.OnSelectLongPress, self)
  self.rateUpCardCell:AddEventListener(MouseEvent.MouseClick, self.OnRateUpCardClick, self)
  self.upTipLabel = self:FindComponent("UpTip", UILabel)
  local materialGrid = self:FindComponent("MaterialGrid", UIGrid)
  self.materialCtl = UIGridListCtrl.new(materialGrid, RecallMvpCardComposeMaterialCell, "CardMakeMaterialCell")
  self.materialCtl:AddEventListener(MouseEvent.MouseClick, self.HandleMaterialTip, self)
  self.decoTex = self:FindComponent("Deco", UITexture)
  self.chooseBoardBgTex = self:FindComponent("ChooseBoardBg", UITexture)
  self.activityIndexLabel = self:FindComponent("ActivityIndex", UILabel)
end

function RecallMvpCardComposeView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardQueryInfoRecallCmd, self.HandleMvpCardQueryInfoRecallCmd)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardSetUpCardRecallCmd, self.HandleMvpCardSetUpCardRecallCmd)
  self:AddListenEvt(ServiceEvent.RecallCCmdMvpCardRandCardRecallCmd, self.HandleMvpCardRandCardRecallCmd)
end

function RecallMvpCardComposeView:OnEnter()
  RecallMvpCardComposeView.super.OnEnter(self)
  PictureManager.Instance:SetUI(DecoName, self.decoTex)
  PictureManager.Instance:SetUI(ChooseBoardBgName, self.chooseBoardBgTex)
  self:UpdateUpTip()
  self:UpdateActivityIndex()
end

function RecallMvpCardComposeView:OnExit()
  RecallMvpCardComposeView.super.OnExit(self)
  PictureManager.Instance:UnLoadUI(DecoName, self.decoTex)
  PictureManager.Instance:UnLoadUI(ChooseBoardBgName, self.chooseBoardBgTex)
end

function RecallMvpCardComposeView:UpdateCardList()
  local items = RecallMvpCardProxy.Instance:FilterCardListByTypes(self.filterTipData.curCustomProps)
  local data = AdventureDataProxy.Instance:getItemsByFilterData(nil, items, self.filterTipData.curPropData, self.filterTipData.curKeys)
  if data and 0 < #data then
    self.cardListCtl:ResetDatas(data)
  end
end

function RecallMvpCardComposeView:CallExchangeCardItem()
  local selfChooseUpCard = RecallMvpCardProxy.Instance:GetSelfChooseUpCard()
  if selfChooseUpCard then
    ServiceRecallCCmdProxy.Instance:CallMvpCardRandCardRecallCmd(self.composeNum)
  else
    MsgManager.ShowMsgByID(3000008)
  end
end

function RecallMvpCardComposeView:UpdateRateUpCardList()
  if self.rateUpCardCell then
    local selfChooseUpCard = RecallMvpCardProxy.Instance:GetSelfChooseUpCard()
    self.rateUpCardCell:SetData(selfChooseUpCard)
  end
end

function RecallMvpCardComposeView:UpdateUpTip()
  local myUpTimes = RecallMvpCardProxy.Instance:GetUpTimes()
  local safety_count = GameConfig.Card and GameConfig.Card.safety_count and GameConfig.Card.safety_count or 1
  local leftCount = safety_count - myUpTimes
  if leftCount <= 1 then
    self.upTipLabel.text = ZhString.CardMake_RateUpTipThisTime
  else
    self.upTipLabel.text = string.format(ZhString.CardMake_RateUpTip, leftCount)
  end
end

function RecallMvpCardComposeView:OnRateUpCardClick(cell)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.RecallMvpCardSelfChooseView
  })
end

function RecallMvpCardComposeView:OnHelpBtnClick()
  local helpData = Table_Help[500009]
  if helpData then
    TipsView.Me():ShowGeneralHelp(helpData.Desc, helpData.Title)
  end
end

function RecallMvpCardComposeView:HandleItemUpdate()
  self:UpdateMaterial()
end

function RecallMvpCardComposeView:HandleMvpCardSetUpCardRecallCmd()
  self:UpdateRateUpCardList()
end

function RecallMvpCardComposeView:HandleMvpCardRandCardRecallCmd(note)
  local data = note.body
  if data.msg_id and data.msg_id > 0 then
    MsgManager.ShowMsgByID(data.msg_id)
    ServiceRecallCCmdProxy.Instance:CallMvpCardQueryInfoRecallCmd()
    return
  end
  self:UpdateUpTip()
end

function RecallMvpCardComposeView:HandleMvpCardQueryInfoRecallCmd()
  self:UpdateCardList()
  self:UpdateRateUpCardList()
  self:UpdateUpTip()
  self:UpdateActivityIndex()
end

function RecallMvpCardComposeView:UpdateActivityIndex()
  local activityIndex = RecallMvpCardProxy.Instance:GetCurIndex()
  local totalCount = RecallInfoProxy.Instance:GetTotalBatchCount()
  self.activityIndexLabel.text = string.format(ZhString.RecallIntegration_BatchNumber, activityIndex, totalCount)
end
