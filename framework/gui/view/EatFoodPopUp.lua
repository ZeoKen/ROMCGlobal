EatFoodPopUp = class("EatFoodPopUp", BaseView)
autoImport("GainWayTip")
autoImport("ItemTipComCell")
EatFoodPopUp.ViewType = UIViewType.PopUpLayer

function EatFoodPopUp:Init()
  self:InitView()
  self:MapEvent()
end

function EatFoodPopUp:InitView()
  self.root = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIRoot)
  self.itemGO = self:FindGO("ItemTipComCell")
  self.foodCell = ItemTipComCell.new(self.itemGO)
  self.foodCell:AddEventListener(ItemTipEvent.ClickTipFuncEvent, self.HandleClickTip, self)
  self.foodCell:AddEventListener(ItemTipEvent.ShowGetPath, self.ShowGetPath, self)
  self.eatingTip = self:FindComponent("EatingTip", UILabel)
  self.gpContainer = self:FindGO("GetPathContainer")
  self.closecomp = self.itemGO:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self.editPowerBord = self:FindGO("EditorPowerBord")
  local public_EditButton = self:FindGO("ItemFuncButtonCell1")
  self:AddClickEvent(public_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_ALL)
  end)
  local team_EditButton = self:FindGO("ItemFuncButtonCell2")
  self:AddClickEvent(team_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_TEAM)
  end)
  local self_EditButton = self:FindGO("ItemFuncButtonCell3")
  self:AddClickEvent(self_EditButton, function(go)
    self:EditEatPower(SceneFood_pb.EEATPOWR_SELF)
  end)
  self.editPowerButton = self:FindGO("EditPowerButton")
  self:AddClickEvent(self.editPowerButton, function(go)
    self:CloseGetPath()
    self.editPowerBord:SetActive(true)
  end)
  self.foodCell.itemcell:ShowNum()
  self.foodCell.dontUpdateCellCount = true
  self.editPowerButton:SetActive(false)
  self.itemGO:SetActive(false)
end

function EatFoodPopUp:ShowGetPath(cell)
  if cell and cell.gameObject then
    self.editPowerBord:SetActive(false)
    if not self.bdt then
      self.gpContainer.transform.localScale = LuaGeometry.Const_V3_one
      local x = LuaGameObject.InverseTransformPointByTransform(self.root.transform, cell.gameObject.transform, Space.World)
      self.gpContainer.transform.position = cell.gameObject.transform.position
      local lx, ly = LuaGameObject.GetLocalPosition(self.gpContainer.transform)
      local tempV3 = LuaGeometry.GetTempVector3()
      if 0 < x then
        tempV3:Set(lx - 210, ly + 271, 0)
      else
        tempV3:Set(lx + 210, ly + 271, 0)
      end
      self.gpContainer.transform.localPosition = tempV3
      local data = cell.data
      if data and data.staticData then
        self.bdt = GainWayTip.new(self.gpContainer)
        self.bdt:SetAnchorPos(x <= 0)
        self.bdt:SetData(data.staticData.id)
        self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
          self:CloseSelf()
        end, self)
        self.bdt:AddIgnoreBounds(self.gameObject)
        self:AddIgnoreBounds(self.bdt.gameObject)
        self.bdt:AddEventListener(GainWayTip.CloseGainWay, self.GetPathCloseCall, self)
      end
    else
      self.bdt:OnExit()
    end
  end
end

function EatFoodPopUp:CloseGetPath()
  if self.bdt then
    self.bdt:OnExit()
    self.bdt = nil
  end
end

function EatFoodPopUp:GetPathCloseCall()
  if self.closecomp then
    self.closecomp:ReCalculateBound()
  end
  self.bdt = nil
end

function EatFoodPopUp:EditEatPower(power)
  ServiceSceneFoodProxy.Instance:CallEditFoodPower(self.npcguid, power)
end

function EatFoodPopUp:HandleClickTip()
  self:CloseSelf()
end

function EatFoodPopUp:MapEvent()
  self:AddListenEvt(ServiceEvent.SceneFoodQueryFoodNpcInfo, self.HandleUpdateFoodInfo)
end

function EatFoodPopUp:HandleUpdateFoodInfo(note)
  local server_data = note.body
  if server_data and server_data.npcguid == self.npcguid then
    if server_data.itemid and server_data.itemid ~= 0 and 0 < server_data.itemnum then
      local itemData = ItemData.new("Food", server_data.itemid)
      self.foodItemId = server_data.itemid
      itemData:SetItemNum(server_data.itemnum)
      self.foodCell:SetData(itemData)
      self.foodCell:UpdateNoneItemTipCountChooseBord(server_data.itemnum)
      self.foodCell:ActiveGetPath(true)
      local limitEatMap = GameConfig.Food.LimitEat
      if limitEatMap and limitEatMap[server_data.itemid] then
        self.foodCell:UpdateCountChooseBord(limitEatMap[server_data.itemid])
      end
    end
    self.foodCell:SetReplaceInfo(string.format(ZhString.EatFoodPopUp_EatTip, server_data.eating_people))
    self.editPowerButton:SetActive(server_data.ownerid == Game.Myself.data.id)
    self.itemGO:SetActive(true)
  end
  if not self.initFunc then
    self.initFunc = true
    self.foodCell:AddTipFunc(ZhString.EatFoodPopUp_EatSelf, EatFoodPopUp.EatSelf, self)
    local myPetInfo = PetProxy.Instance:GetMyPetInfoData()
    if myPetInfo ~= nil then
      self.foodCell:AddTipFunc(ZhString.EatFoodPopUp_PetEat, EatFoodPopUp.PetEat, self)
    end
  end
end

function EatFoodPopUp:EatSelf(count)
  local foodList = FoodProxy.Instance:GetEatFoods()
  local currentEatFoodCount = #foodList
  local overrideNotice = LocalSaveProxy.Instance:GetFoodBuffOverrideNoticeShow()
  local level = Game.Myself.data.userdata:Get(UDEnum.TASTER_LV)
  local tasteLvInfo = Table_TasterLevel[level]
  local foodMaxCount = 3
  if tasteLvInfo then
    foodMaxCount = tasteLvInfo.AddBuffs
  end
  if overrideNotice and foodMaxCount < currentEatFoodCount + count and self.foodItemId ~= 551019 then
    GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
      viewname = "FoodOverridePopView",
      foodNpcId = self.npcguid,
      foodItemId = self.foodItemId,
      foodCount = count
    })
  else
    ServiceSceneFoodProxy.Instance:CallStartEat(self.npcguid, false, count)
  end
end

function EatFoodPopUp:PetEat(count)
  if count == 1 then
    ServiceSceneFoodProxy.Instance:CallStartEat(self.npcguid, true, count)
  else
    MsgManager.ShowMsgByID(25429)
  end
end

function EatFoodPopUp:UpdateFoodInfo()
end

function EatFoodPopUp:AddIgnoreBounds(obj)
  if self.closecomp then
    self.closecomp:AddTarget(obj.transform)
  end
end

function EatFoodPopUp:OnEnter()
  EatFoodPopUp.super.OnEnter(self)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcguid = viewdata.npcguid
    if self.npcguid then
      ServiceSceneFoodProxy.Instance:CallQueryFoodNpcInfo(self.npcguid)
    end
  end
end

function EatFoodPopUp:OnExit()
  if self.foodCell then
    self.foodCell:OnDestroy()
  end
  EatFoodPopUp.super.OnExit(self)
  self.editPowerBord:SetActive(false)
end
