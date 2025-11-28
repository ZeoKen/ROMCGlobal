LotteryBaseView = class("LotteryBaseView", ContainerView)
LotteryBaseView.ViewType = UIViewType.NormalLayer

function LotteryBaseView:OnEnter()
  LotteryBaseView.super.OnEnter(self)
  self:CameraFaceToNpc(CameraConfig.Lottery_ViewPort, CameraConfig.Lottery_Rotation)
  LotteryProxy.Instance:SetIsOpenView(true)
  self:sendNotification(LotteryEvent.LotteryViewEnter)
end

function LotteryBaseView:OnExit()
  LotteryProxy.Instance:SetIsOpenView(false)
  self:CameraReset()
  LotteryBaseView.super.OnExit(self)
end

function LotteryBaseView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function LotteryBaseView:AddEvts()
end

function LotteryBaseView:FindObjs()
  self.closeBtn = self:FindGO("CloseButton")
  self.lotteryBtnGO = self:FindGO("LotteryBtn")
  self.costBtnIcon = self:FindGO("LotteryIcon", self.lotteryBtnGO):GetComponent(UISprite)
  self.costBtnLabel = self:FindGO("Cost", self.lotteryBtnGO):GetComponent(UILabel)
  self.soldoutBtnGO = self:FindGO("SoldoutBtn")
end

function LotteryBaseView:AddViewEvts()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
end

function LotteryBaseView:InitShow()
end

function LotteryBaseView:OnEffectStart()
  self:CameraReset()
  self:CameraFaceToNpc(CameraConfig.Lottery_Effect_ViewPort, CameraConfig.Lottery_Rotation)
end

function LotteryBaseView:OnEffectEnd()
  self:CameraReset()
  self:CameraFaceToNpc(CameraConfig.Lottery_ViewPort, CameraConfig.Lottery_Rotation)
end

function LotteryBaseView:CameraFaceToNpc(viewPort, rotation)
  local npcdata = self:GetNpcDataFromViewData()
  if npcdata then
    self:CameraFaceTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end

function LotteryBaseView:GetNpcDataFromViewData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  if not viewdata or type(viewdata) ~= "table" then
    return nil
  end
  return viewdata.npcdata
end

function LotteryBaseView:PlayAnimation(delay, animName, idleAnimName)
  self:OnEffectStart()
  local npcData = self:GetNpcDataFromViewData()
  if npcData and npcData.data then
    local npcRole = SceneCreatureProxy.FindCreature(npcData.data.id)
    if npcRole then
      if animName ~= nil then
        npcRole:Client_PlayAction(animName, nil, false)
      end
      self.closeBtn:SetActive(false)
      self.lotteryBtnGO:SetActive(false)
      TimeTickManager.Me():CreateOnceDelayTick(delay, function(owner, deltaTime)
        if idleAnimName ~= nil then
          npcRole:Client_PlayAction(idleAnimName, nil, false)
        end
        self.closeBtn:SetActive(true)
        self.lotteryBtnGO:SetActive(true)
        self:OnEffectEnd()
        self:SendPurchaseMessage()
      end, self)
      return
    end
  end
  self:OnEffectEnd()
  self:SendPurchaseMessage()
end

function LotteryBaseView:ShowAward(itemId)
  local sdata = ItemData.new("LotteryItem", itemId)
  local args = ReusableTable.CreateTable()
  args.disableMsg = true
  args.leftBtnText = ZhString.FloatAwardView_IntoPackage
  args.hideEquipBtn = true
  FloatAwardView.addItemDatasToShow({sdata}, args)
  ReusableTable.DestroyAndClearTable(args)
end

function LotteryBaseView:SendPurchaseMessage()
end
