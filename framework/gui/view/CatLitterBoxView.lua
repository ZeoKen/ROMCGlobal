autoImport("CatLitterBoxCell")
CatLitterBoxView = class("CatLitterBoxView", ContainerView)
CatLitterBoxView.ViewType = UIViewType.NormalLayer
local _ActionId = 506
local _IdleActionId = 504
local _Pos = LuaVector3()
local _GuildBuildType = GuildBuildingProxy.Type.EGUILDBUILDING_CAT_LITTER_BOX
local _CostItemID = GameConfig.GuildBuilding.cat_litter_box_itemid
local _CostItemCount = GameConfig.GuildBuilding.cat_litter_box_itemcount
local _MaskReason = PUIVisibleReason.CatLitterBox
local _SkipType = SKIPTYPE.LotteryCatLitter

function CatLitterBoxView:OnEnter()
  CatLitterBoxView.super.OnEnter(self)
  self:NormalCameraFaceTo()
  local _FunctionPlayerUI = FunctionPlayerUI.Me()
  local roles = NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    _FunctionPlayerUI:MaskTopFrame(v, _MaskReason, false)
    _FunctionPlayerUI:MaskNameHonorFactionType(v, _MaskReason, false)
  end
end

function CatLitterBoxView:OnExit()
  self:CameraReset()
  local _FunctionPlayerUI = FunctionPlayerUI.Me()
  local roles = NSceneNpcProxy.Instance:GetAll()
  for k, v in pairs(roles) do
    _FunctionPlayerUI:UnMaskTopFrame(v, _MaskReason, false)
    _FunctionPlayerUI:UnMaskNameHonorFactionType(v, _MaskReason, false)
  end
  CatLitterBoxView.super.OnExit(self)
end

function CatLitterBoxView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function CatLitterBoxView:FindObjs()
  self.btnRoot = self:FindGO("BtnRoot").transform
  self.ticket = self:FindGO("Ticket"):GetComponent(UILabel)
  self.ticketCost = self:FindGO("TicketCost"):GetComponent(UILabel)
  self.detailTween = self:FindGO("DetailRoot"):GetComponent(TweenPosition)
  self.tweenDetailBtn = self:FindGO("TweenDetailBtn")
  self.skipBtn = self:FindGO("SkipBtn"):GetComponent(UISprite)
end

function CatLitterBoxView:AddEvts()
  local ticketBtn = self:FindGO("TicketBtn")
  self:AddClickEvent(ticketBtn, function()
    self:Ticket()
  end)
  local ticketAllBtn = self:FindGO("TicketAllBtn")
  self:AddClickEvent(ticketAllBtn, function()
    self:TicketAll()
  end)
  self:AddClickEvent(self.tweenDetailBtn, function()
    self.detailTween:PlayForward()
    self.tweenDetailBtn:SetActive(false)
    LuaVector3.Better_Set(_Pos, LuaGameObject.GetPosition(self.btnRoot))
    _Pos[1] = -200
    self.btnRoot.localPosition = _Pos
  end)
  local closeDetailBtn = self:FindGO("CloseDetailBtn")
  self:AddClickEvent(closeDetailBtn, function()
    self.detailTween:PlayReverse()
    self.tweenDetailBtn:SetActive(true)
    LuaVector3.Better_Set(_Pos, LuaGameObject.GetPosition(self.btnRoot))
    _Pos[1] = 0
    self.btnRoot.localPosition = _Pos
  end)
  self:AddClickEvent(self.skipBtn.gameObject, function()
    self:Skip()
  end)
end

function CatLitterBoxView:AddViewEvts()
  self:AddListenEvt(ItemEvent.ItemUpdate, self.UpdateTicket)
  self:AddListenEvt(ServiceEvent.ItemRollCatLitterBoxItemCmd, self.HandleResult)
end

function CatLitterBoxView:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.rewardList = {}
  local detailGrid = self:FindGO("DetailGrid"):GetComponent(UIGrid)
  self.detailCtl = UIGridListCtrl.new(detailGrid, CatLitterBoxCell, "CatLitterBoxCell")
  self.detailCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDetail, self)
  local ticketIcon = self:FindGO("TicketIcon"):GetComponent(UISprite)
  local ticketCostIcon = self:FindGO("TicketCostIcon"):GetComponent(UISprite)
  local ticket = Table_Item[_CostItemID]
  if ticket then
    IconManager:SetItemIcon(ticket.Icon, ticketIcon)
    IconManager:SetItemIcon(ticket.Icon, ticketCostIcon)
    self.ticketName = ticket.NameZh
  end
  self:UpdateTicket()
  self:UpdateTicketCost()
  self:UpdateView()
end

function CatLitterBoxView:NormalCameraFaceTo()
  local npcdata = self.viewdata.viewdata.npcdata
  if npcdata then
    local viewPort = CameraConfig.Lottery_Effect_ViewPort
    local rotation = CameraConfig.Lottery_CatLitterBox_Rotation
    self:CameraFocusAndRotateTo(npcdata.assetRole.completeTransform, viewPort, rotation)
  end
end

function CatLitterBoxView:Ticket()
  self:CallTicket(1)
end

function CatLitterBoxView:TicketAll()
  local count = BagProxy.Instance:GetItemNumByStaticID(_CostItemID)
  self:CallTicket(math.floor(count / _CostItemCount))
end

function CatLitterBoxView:CallTicket(times)
  if times < 1 or BagProxy.Instance:GetItemNumByStaticID(_CostItemID) < _CostItemCount * times then
    MsgManager.ShowMsgByID(3554, self.ticketName)
    return
  end
  ServiceItemProxy.Instance:CallRollCatLitterBoxItemCmd(times)
end

function CatLitterBoxView:Skip()
  TipManager.Instance:ShowSkipAnimationTip(_SkipType, self.skipBtn, NGUIUtil.AnchorSide.Right, {184, 0})
end

function CatLitterBoxView:ClickDetail(cell)
  local data = cell.data
  if data then
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, cell.icon, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function CatLitterBoxView:UpdateTicket()
  self.ticket.text = StringUtil.NumThousandFormat(BagProxy.Instance:GetItemNumByStaticID(_CostItemID))
end

function CatLitterBoxView:UpdateTicketCost()
  self.ticketCost.text = StringUtil.NumThousandFormat(_CostItemCount)
end

function CatLitterBoxView:UpdateView()
  local _GuildBuildingProxy = GuildBuildingProxy.Instance
  local level = _GuildBuildingProxy:GetBuildingLevelByType(_GuildBuildType)
  if level then
    local config = _GuildBuildingProxy:CfgData(_GuildBuildType, level)
    if config then
      local rewardid = config.UnlockParam.rewardid
      if rewardid then
        local data = ItemUtil.GetRewardItemIdsByTeamId(rewardid)
        self.detailCtl:ResetDatas(data)
      end
    end
  end
end

function CatLitterBoxView:HandleResult(note)
  local data = note.body
  if data then
    self:ProcessRewards(data.rewards)
    local skip = LocalSaveProxy.Instance:GetSkipAnimation(_SkipType)
    if skip then
      self:ShowReward()
    else
      local npc = self.viewdata.viewdata.npcdata
      if npc then
        self:PlayAction(npc, _ActionId)
        self.gameObject:SetActive(false)
        TimeTickManager.Me():CreateOnceDelayTick(GameConfig.Delay.lottery, function(owner, deltaTime)
          self:PlayAction(npc, _IdleActionId)
          self:ShowReward()
          self.gameObject:SetActive(true)
        end, self)
      else
        self:ShowReward()
      end
    end
  end
end

function CatLitterBoxView:ProcessRewards(rewards)
  TableUtility.ArrayClear(self.rewardList)
  local itemdata
  for i = 1, #rewards do
    itemdata = rewards[i]
    local data = ItemData.new(itemdata.guid, itemdata.id)
    data.num = itemdata.count
    self.rewardList[#self.rewardList + 1] = data
  end
end

function CatLitterBoxView:PlayAction(npc, actionId)
  if npc ~= nil and actionId ~= nil then
    local actionName
    local config = Table_ActionAnime[actionId]
    if config ~= nil then
      actionName = config.Name
    end
    if actionName ~= nil then
      npc:Client_PlayAction(actionName, nil, false)
    end
  end
end

function CatLitterBoxView:ShowReward()
  self:sendNotification(UIEvent.ShowUI, {
    viewname = "PopUp10View"
  })
  self:sendNotification(SystemMsgEvent.MenuItemPop, self.rewardList)
end
