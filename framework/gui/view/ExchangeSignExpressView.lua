autoImport("EffectShowDataWraper")
ExchangeSignExpressView = class("ExchangeSignExpressView", ContainerView)
ExchangeSignExpressView.ViewType = UIViewType.PopUpLayer

function ExchangeSignExpressView:Init()
  self:FindObj()
  self:AddBtnEvt()
  self:AddViewEvt()
  self:InitShow()
end

function ExchangeSignExpressView:FindObj()
  self.toName = self:FindGO("ToName"):GetComponent(UILabel)
  self.fromName = self:FindGO("FromName"):GetComponent(UILabel)
  self.content = self:FindGO("Content"):GetComponent(UILabel)
  self.iconContainer = self:FindGO("IconContainer")
  self.modelContainer = self:FindGO("ModelContainer")
  self.modelRoot = self:FindGO("ModelRoot")
  self.server = self:FindGO("Server"):GetComponent(UILabel)
  self.serverGO = self.server.gameObject
end

function ExchangeSignExpressView:AddBtnEvt()
  local acceptBtn = self:FindGO("AcceptBtn")
  self:AddClickEvent(acceptBtn, function()
    self:Accept()
  end)
  local refuseBtn = self:FindGO("RefuseBtn")
  self:AddClickEvent(refuseBtn, function()
    self:Refuse()
  end)
end

function ExchangeSignExpressView:AddViewEvt()
  self:AddListenEvt(ServiceEvent.MapGingerBreadNpcCmd, self.HandleMapGingerBreadNpc)
end

function ExchangeSignExpressView:InitShow()
  local data = ShopMallProxy.Instance:GetExpressData()
  if data then
    self.toName.text = Game.Myself.data:GetName()
    if not data:GetAnonymous() then
      self.fromName.text = string.format(ZhString.ShopMall_ExchangeExpressFrom, data:GetSenderName())
    end
    self.content.text = data:GetContent()
    local itemData = data:GetItemData()
    local showType = ShopMallProxy.Instance:CheckItemType(itemData)
    if showType then
      self.itemShowWraper = EffectShowDataWraper.new(itemData, nil, showType, nil)
      self:ShowItem()
    else
      self.modelRoot:SetActive(false)
      local obj = self:LoadPreferb("cell/ItemCell", self.iconContainer)
      obj.transform.localPosition = LuaGeometry.GetTempVector3()
      local itemCell = BaseItemCell.new(obj)
      itemCell:SetData(itemData)
    end
    local bgId = data:GetBg()
    local sendMoney = GameConfig.Exchange.SendMoney
    if sendMoney[bgId] then
      local uiName = sendMoney[bgId].Resourse
      local uiPrefab = self:LoadPreferb("cell/" .. uiName, self.gameObject, true)
      if uiName == "ExchangeExpressBg1" then
        local uiEffectParent = Game.GameObjectUtil:DeepFind(uiPrefab.gameObject, "lizi")
        if uiEffectParent then
          self:PlayUIEffect(EffectMap.UI.ExchangeExpressBg1, uiEffectParent.transform)
        end
      elseif uiName == "ExchangeExpressBg2" then
        local uiEffectParent1 = Game.GameObjectUtil:DeepFind(uiPrefab.gameObject, "Panel")
        if uiEffectParent1 then
          self:PlayUIEffect(EffectMap.UI.sakura_gift_ui_85, uiEffectParent1.transform)
        end
        local uiEffectParent2 = Game.GameObjectUtil:DeepFind(uiEffectParent1, "Effect1")
        if uiEffectParent2 then
          self:PlayUIEffect(EffectMap.UI.ExchangeExpressBg2, uiEffectParent2.transform)
        end
        local uiEffectParent3 = Game.GameObjectUtil:DeepFind(uiPrefab.gameObject, "Effect2")
        if uiEffectParent3 then
          self:PlayUIEffect(EffectMap.UI.sakura_gift_shine_86, uiEffectParent3.transform)
        end
      end
      local color = sendMoney[bgId].fontcolor
      local hasc, rc = ColorUtil.TryParseHexString(color)
      self.fromName.color = rc
      self.toName.color = rc
    end
    local serverId = data:GetSenderServerId()
    if serverId and serverId ~= MyselfProxy.Instance:GetServerId() then
      self.server.text = serverId
      self.serverGO:SetActive(true)
    else
      self.serverGO:SetActive(false)
    end
  end
end

function ExchangeSignExpressView:ShowItem()
  if self.itemShowWraper and self.itemShowWraper.showType == FloatAwardView.ShowType.ModelType then
    local obj = self.itemShowWraper:getModelObj(self.modelContainer)
    self:ShowItemModel(obj)
  end
end

local posVec = LuaVector3.Zero()
local rotVec = LuaVector3.Zero()
local scaleVec = LuaVector3.Zero()
local rotationQua = LuaQuaternion.Identity()

function ExchangeSignExpressView:ShowItemModel(obj)
  if self.itemShowWraper.itemData.equipInfo then
    LuaVector3.Better_Set(posVec, 0, 0, 0)
    LuaQuaternion.Better_Set(rotationQua, 0, 0, 0, 0)
    LuaVector3.Better_Set(scaleVec, 1, 1, 1)
    local itemModelName = self.itemShowWraper.itemData.equipInfo.equipData.Model
    local modelConfig = ModelShowConfig[itemModelName]
    if modelConfig then
      local position = modelConfig.localPosition
      LuaVector3.Better_Set(posVec, position[1], position[2], position[3])
      local rotation = modelConfig.localRotation
      LuaQuaternion.Better_Set(rotationQua, rotation[1], rotation[2], rotation[3], rotation[4])
      local scale = modelConfig.localScale
      LuaVector3.Better_Set(scaleVec, scale[1], scale[2], scale[3])
    end
    obj:ResetLocalPosition(posVec)
    LuaQuaternion.Better_GetEulerAngles(rotationQua, rotVec)
    obj:ResetLocalEulerAngles(rotVec)
    obj:ResetLocalScale(scaleVec)
  end
end

function ExchangeSignExpressView:Accept()
  local data = ShopMallProxy.Instance:GetExpressData()
  if data then
    local id = data:GetId()
    ServiceRecordTradeProxy.Instance:CallAcceptTradeCmd(id)
  end
  self:CloseSelf()
end

function ExchangeSignExpressView:Refuse()
  MsgManager.ConfirmMsgByID(25101, function()
    local data = ShopMallProxy.Instance:GetExpressData()
    if data then
      local id = data:GetId()
      ServiceRecordTradeProxy.Instance:CallRefuseTradeCmd(id)
    end
    self:CloseSelf()
  end)
end

function ExchangeSignExpressView:HandleMapGingerBreadNpc(note)
  local data = note.body
  if data.isadd == false and data.userid == Game.Myself.data.id then
    local expressData = ShopMallProxy.Instance:GetExpressData()
    if expressData then
      local id = expressData:GetId()
      if id == data.data.giveid then
        self:CloseSelf()
      end
    end
  end
end
