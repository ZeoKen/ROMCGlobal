ManorPartnerGiftPopUp = class("ManorPartnerGiftPopUp", SubMediatorView)
autoImport("ManorPartnerGiftCell")

function ManorPartnerGiftPopUp:Init()
  self:FindObjs()
  self:InitData()
  self:AddEvts()
end

local pressEvtHideType = {hideClickEffect = true}

function ManorPartnerGiftPopUp:FindObjs()
  self.gameObject = self:LoadPreferb("view/ManorPartnerGiftPopUp", nil, true)
  self.cancelBtn = self:FindGO("CancelBtn")
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.giftGrid = self:FindGO("Grid"):GetComponent(UIGrid)
  self.giftListCtrl = UIGridListCtrl.new(self.giftGrid, ManorPartnerGiftCell, "RewardGridCell")
  self.giftListCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickGiftCell, self)
  self.countRoot = self:FindGO("AddOrReduce")
  self.countNum = self:FindGO("Count"):GetComponent(UILabel)
  self.countPlusBg = self:FindGO("addBg"):GetComponent(UISprite)
  self.countPlus = self:FindGO("addIcon"):GetComponent(UISprite)
  self.countSubtractBg = self:FindGO("reduceBg"):GetComponent(UISprite)
  self.countSubtract = self:FindGO("reduceIcon"):GetComponent(UISprite)
  self.btnReduce = self:FindGO("BtnReduce")
  self.btnAdd = self:FindGO("BtnAdd")
end

function ManorPartnerGiftPopUp:AddEvts()
  self:AddClickEvent(self.cancelBtn, function()
    if self.target then
      GameFacade.Instance:sendNotification(VisitNpcEvent.AccessNpcEnd, self.target)
      EventManager.Me():DispatchEvent(VisitNpcEvent.AccessNpcEnd, self.target)
    end
    self.container:CloseSelf()
  end)
  self:AddClickEvent(self.confirmBtn, function()
    if not self.npcId or not self.targetItem then
      return
    end
    local isSpare = self:CheckFavor()
    if not isSpare then
      MsgManager.ConfirmMsgByID(41503, function()
        self:CallGift()
      end)
    else
      self:CallGift()
    end
  end)
  self:AddPressEvent(self.btnAdd, function(g, b)
    self:PlusPressCount(b)
  end, pressEvtHideType)
  self:AddPressEvent(self.btnReduce, function(g, b)
    self:SubtractPressCount(b)
  end, pressEvtHideType)
end

function ManorPartnerGiftPopUp:InitData()
  self.count = 1
  self.timeLimit = 0
  self.countNum.text = 1
  self:InputOnChange()
end

function ManorPartnerGiftPopUp:InitShow()
  if not self.npcId then
    return
  end
  local itemFavor = ComodoBuildingProxy.Instance.partnerFavoredItemsMap[self.npcId]
  if itemFavor then
    local list = ReusableTable.CreateArray()
    for i = 1, #itemFavor do
      table.insert(list, itemFavor[i][1])
    end
    self.giftListCtrl:ResetDatas(list)
    ReusableTable.DestroyAndClearArray(list)
  end
end

function ManorPartnerGiftPopUp:HandleClickGiftCell(cell)
  self.targetItem = cell.data
  if self.curCell ~= cell then
    if self.curCell then
      self.curCell:SetChoose(false)
    end
    self.curCell = cell
    self.curCell:SetChoose(true)
  else
    self.curCell = cell
  end
  self.timeLimit = tonumber(cell.count.text)
  self.countNum.text = 1
  self:InputOnChange()
end

function ManorPartnerGiftPopUp:PlusPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(1)
    end, self, 2)
  else
    TimeTickManager.Me():ClearTick(self, 2)
  end
end

function ManorPartnerGiftPopUp:SubtractPressCount(isPressed)
  if isPressed then
    self.countChangeRate = 1
    TimeTickManager.Me():CreateTick(0, 150, function(owner, deltaTime)
      self:UpdateCount(-1)
    end, self, 3)
  else
    TimeTickManager.Me():ClearTick(self, 3)
  end
end

function ManorPartnerGiftPopUp:UpdateCount(change)
  local count = tonumber(self.countNum.text) + self.countChangeRate * change
  if count < 1 then
    self.countChangeRate = 1
    return
  elseif count > self.timeLimit then
    self.countChangeRate = 1
    return
  end
  self.count = count
  self.countNum.text = self.count
  if self.countChangeRate <= 3 then
    self.countChangeRate = self.countChangeRate + 1
  end
  self:InputOnChange()
end

function ManorPartnerGiftPopUp:InputOnChange()
  local count = tonumber(self.countNum.text)
  if count == nil then
    return
  end
  if self.timeLimit == 0 then
    count = 0
    self:SetCountPlus(0.5)
    self:SetCountSubtract(0.5)
  elseif count <= 1 then
    count = 1
    self:SetCountPlus(self.timeLimit == 1 and 0.5 or 1)
    self:SetCountSubtract(0.5)
  elseif count >= self.timeLimit then
    count = self.timeLimit
    self:SetCountPlus(0.5)
    self:SetCountSubtract(1)
  else
    self:SetCountPlus(1)
    self:SetCountSubtract(1)
  end
end

function ManorPartnerGiftPopUp:SetCountPlus(alpha)
  if self.countPlus.color.a ~= alpha then
    self:SetSpritAlpha(self.countPlusBg, alpha)
    self:SetSpritAlpha(self.countPlus, alpha)
  end
end

function ManorPartnerGiftPopUp:SetCountSubtract(alpha)
  if self.countSubtract.color.a ~= alpha then
    self:SetSpritAlpha(self.countSubtract, alpha)
    self:SetSpritAlpha(self.countSubtractBg, alpha)
  end
end

function ManorPartnerGiftPopUp:SetSpritAlpha(sprit, alpha)
  sprit.color = Color(sprit.color.r, sprit.color.g, sprit.color.b, alpha)
end

function ManorPartnerGiftPopUp:CheckFavor()
  local partnerInfo = ManorPartnerProxy.Instance:GetPartnerInfo(self.npcId)
  if not partnerInfo then
    return false
  end
  local itemFavor = 2
  local curMaxfavor = partnerInfo.maxFavor
  local curFavor = partnerInfo.favor
  if curMaxfavor < curFavor + self.count * itemFavor then
    return false
  end
  return true
end

function ManorPartnerGiftPopUp:CallGift()
  xdlog("申请送礼物", self.npcId, self.targetItem, self.count)
  ServiceSceneManorProxy.Instance:CallPartnerGiveManorCmd(self.npcId, self.targetItem, self.count)
  local dialogId = 782572
  local dialogData = DialogUtil.GetDialogData(dialogId)
  local viewdata = {
    viewname = "DialogView",
    dialoglist = {
      dialogData.Text
    },
    npcinfo = self.target
  }
  self:sendNotification(UIEvent.ShowUI, viewdata)
  FunctionVisitNpc.Me().targetId = self.npcId
  if self.target then
    local actionName = "functional_action7"
    self.target:Server_PlayActionCmd(actionName, nil, false)
    self.target.assetRole:PlayEffectOneShotOn("Common/eff_ycyd_happy", 1)
  end
end

function ManorPartnerGiftPopUp:OnEnter(subviewId, dialogView)
  ManorPartnerGiftPopUp.super.OnEnter(self)
  if dialogView then
    local npcdata = dialogView.npcdata
    self.npcId = npcdata and npcdata.id
    self.target = dialogView:GetCurNpc()
    if self.target then
      TimeTickManager.Me():CreateOnceDelayTick(10, function(owner, deltaTime)
        GameFacade.Instance:sendNotification(VisitNpcEvent.AccessNpc, self.target)
        EventManager.Me():DispatchEvent(VisitNpcEvent.AccessNpc, self.target)
      end, self)
    end
  end
  self:InitShow()
end

function ManorPartnerGiftPopUp:OnExit()
  ManorPartnerGiftPopUp.super.OnExit(self)
end
