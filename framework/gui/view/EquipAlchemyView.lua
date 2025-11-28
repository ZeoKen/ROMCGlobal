EquipAlchemyView = class("EquipAlchemyView", ContainerView)
EquipAlchemyView.ViewType = UIViewType.NormalLayer
autoImport("EquipAlchemyItemCell")
autoImport("EquipAlchemyMakeCell")
autoImport("EquipAlchemyMaterialCell")
autoImport("EquipCountChooseCell")
local tickManager, picManager

function EquipAlchemyView:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
    picManager = PictureManager.Instance
  end
  self:InitView()
  self:MapEvent()
end

function EquipAlchemyView:InitView()
  local userRob = self:FindGO("Silver", self:FindGO("TopCoins"))
  self.robLabel = self:FindComponent("Label", UILabel, userRob)
  local icon = self:FindComponent("symbol", UISprite, userRob)
  local zenyIconName = Table_Item[GameConfig.MoneyId.Zeny].Icon
  IconManager:SetItemIcon(zenyIconName, icon)
  self.makeButton = self:FindGO("MakeBtn")
  self.makeCostLabel = self:FindComponent("Cost", UILabel)
  local costTip = self:FindGO("CostTip")
  self.cost = self:FindComponent("Cost", UILabel, costTip)
  icon = self:FindComponent("Symbol", UISprite, costTip)
  IconManager:SetItemIcon(zenyIconName, icon)
  self.selectCell = EquipAlchemyItemCell.new(self:LoadPreferb_ByFullPath(ResourcePathHelper.UICell("EquipAlchemyItemCell"), self:FindGO("EquipAlchemy_ItemContainer")))
  self.selectCell:SetMinDepth(50)
  self.selectCell:AddEventListener(MouseEvent.MouseClick, self.OnClickEquipAlchemyItem, self)
  self.vmSlider = self:FindComponent("VMSlider", UISlider)
  self.vmSlider_Thumb = self:FindGO("Thumb", self.vmSlider.gameObject)
  self.vmSlider_Thumb_Label = self:FindComponent("PctLabel", UILabel, self.vmSlider.gameObject)
  self.vmSlider_Foreground = self:FindComponent("Foreground", UITexture, self.vmSlider.gameObject)
  self.mmSlider = self:FindComponent("MMSlider", UISlider)
  self.mmSlider_Thumb = self:FindGO("Thumb", self.mmSlider.gameObject)
  self.mmSlider_Thumb_Label = self:FindComponent("PctLabel", UILabel, self.mmSlider.gameObject)
  self.mmSlider_Foreground = self:FindComponent("Foreground", UITexture, self.vmSlider.gameObject)
  self.mkCtl = ListCtrl.new(self:FindComponent("MKGrid", UIGrid), EquipAlchemyMakeCell, "EquipAlchemyMakeCell")
  self.mkCells = self.mkCtl:GetCells()
  self.mkCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickMKCell, self)
  self.matCtl = ListCtrl.new(self:FindComponent("MatGrid", UIGrid), EquipAlchemyMaterialCell, "EquipAlchemyMaterialCell")
  self.matCells = self.matCtl:GetCells()
  self.matCtl:AddEventListener(EquipAlchemyMaterialEvent.Remove, self.RemoveMaterial, self)
  self.makeButton = self:FindGO("MakeBtn")
  self.makeButton_Collider = self.makeButton:GetComponent(BoxCollider)
  self.makeButton_Sprite = self.makeButton:GetComponent(UISprite)
  self.makeButton_Label = self:FindComponent("Label", UILabel, self.makeButton)
  self:AddClickEvent(self.makeButton, function(go)
    self:DoMake()
  end)
  self.chosenMap, self.materialIds, self.weightMap = {}, {}, {}
  self.isMaking = false
  self.chooseBord = self:FindGO("ChooseBord")
  self.chooseGrid = self:FindComponent("ChooseGrid", UIGrid)
  self.mmToggle = self:FindComponent("MMTab", UIToggle)
  self.vmToggle = self:FindComponent("VMTab", UIToggle)
  self:AddClickEvent(self.mmToggle.gameObject, function()
    self:OnClickMMToggle()
  end)
  self:AddClickEvent(self.vmToggle.gameObject, function()
    self:OnClickVMToggle()
  end)
  self.chooseCtl = ListCtrl.new(self.chooseGrid, EquipAlchemyChooseCell, "EquipChooseCell")
  self.chooseCells = self.chooseCtl:GetCells()
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.CountChooseChange, self.OnCountChooseChange, self)
  self.chooseCtl:AddEventListener(EquipChooseCellEvent.ClickItemIcon, self.OnClickChooseItemIcon, self)
  self.effectContainer = self:FindGO("EffectContainer")
  self.normalStick = self:FindComponent("Stick", UIWidget)
  self:AddButtonEvent("ChooseBordCloseBtn", function()
    self.chooseBord:SetActive(false)
  end)
  self.autoInputBtn = self:FindGO("AutoInputBtn")
  self.autoInputBtn_Collider = self.autoInputBtn:GetComponent(BoxCollider)
  self.autoInputBtn_Sprite = self.autoInputBtn:GetComponent(UISprite)
  self.autoInputBtn_Label = self:FindComponent("Label", UILabel, self.autoInputBtn)
  self:AddClickEvent(self.autoInputBtn, function()
    self:AutoInputMat()
  end)
end

function EquipAlchemyView:MapEvent()
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateCoins)
  self:AddListenEvt(ServiceEvent.ItemHighRefineMatComposeCmd, self.HandleMakeSuccess)
  self:AddListenEvt(ServiceEvent.Error, self.HandleMakeError)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.RefreshSelectCell)
end

function EquipAlchemyView:HandleMakeSuccess(note)
  note = note and note.body
  if not note then
    return
  end
  self.isMaking = false
  self:UpdateActiveButton()
  if note.success then
    self:PlayUIEffect(EffectMap.UI.ForgingSuccess, self.effectContainer, true)
    self:RefreshSelectCell()
  end
end

function EquipAlchemyView:HandleMakeError(note)
  if self.isMaking then
    self.isMaking = false
    self:UpdateActiveButton()
  end
end

function EquipAlchemyView:OnClickMKCell(cell)
  self.chooseBord:SetActive(true)
  self:UpdateMKCell(cell)
end

function EquipAlchemyView:OnClickEquipAlchemyItem(cell)
  self:ShowItemTip(cell.itemData)
end

function EquipAlchemyView:OnCountChooseChange(cell)
  if self.chooseCellUpdating then
    return
  end
  local sid = cell.data and cell.data.staticData.id
  if sid then
    local isMain, newSid = self:IsMainMaterialId(sid)
    local exCount, unitWeight, targetCount = self.chosenMap[sid] or 0, self:GetUnitWeightById(sid), cell.chooseCount
    self.chosenMap[sid] = nil
    local exMWeight, exVWeight = self:GetChosenWeights()
    local maxMatCount = 0 < unitWeight and math.ceil((100 - (isMain and exMWeight or exVWeight)) / unitWeight - 0.01) or 0
    if targetCount > maxMatCount then
      MsgManager.ShowMsgByID(4100)
      targetCount = maxMatCount
    end
    if 0 < targetCount then
      self.chosenMap[sid] = targetCount
    end
    if exCount == 0 and self.chosenMap[sid] then
      newSid = sid
    end
    self:UpdateCountChoose(newSid)
  end
end

function EquipAlchemyView:OnClickChooseItemIcon(cell)
  self:ShowItemTip(cell.data)
end

function EquipAlchemyView:OnClickMMToggle()
  self.isChoosingMM = true
  self:UpdateChooseCells()
  self.mmToggle.value = true
end

function EquipAlchemyView:OnClickVMToggle()
  self.isChoosingMM = false
  self:UpdateChooseCells()
  self.vmToggle.value = true
end

local tipOffset = {-105, 0}

function EquipAlchemyView:ShowItemTip(data)
  if not data then
    TipManager.CloseTip()
    return
  end
  self.itemTipData = self.itemTipData or {
    funcConfig = _EmptyTable
  }
  self.itemTipData.itemdata = data
  local tip = EquipAlchemyView.super.ShowItemTip(self, self.itemTipData, self.normalStick, nil, tipOffset)
  tip:AddIgnoreBounds(self.chooseGrid)
end

function EquipAlchemyView:RemoveMaterial(cell)
  local sid = cell.data
  if sid then
    self.chosenMap[sid] = nil
    self:UpdateCountChoose()
  end
end

function EquipAlchemyView:_UpdateSlider(totalWeight, slider, slider_thumb, slider_thumb_label, dir)
  totalWeight = math.clamp(totalWeight, 0, 100)
  slider.value = totalWeight / 100
  local x, y = LuaGameObject.GetLocalPosition(slider.transform)
  local degree = 180 * totalWeight / 100 * dir + 270
  local radAngle = math.rad(degree)
  slider_thumb.transform.localPosition = LuaGeometry.GetTempVector3(x + math.cos(radAngle) * 162, y + math.sin(radAngle) * 162)
  local _weight = math.floor(totalWeight * 10) / 10
  local a, b = math.modf(_weight)
  slider_thumb_label.text = (b ~= 0 and _weight or a) .. "%"
  self:FindGO("Dq", slider.gameObject).transform:LookAt(slider.transform)
end

function EquipAlchemyView:DoMake()
  local npcInfo = self:GetCurNpc()
  if npcInfo == nil or self.selectData == nil then
    return
  end
  if self.isMaking then
    return
  end
  if MyselfProxy.Instance:GetROB() < self.selectData.Cost then
    MsgManager.ShowMsgByID(1)
    return
  end
  local mms, vms, element = ReusableTable.CreateArray(), ReusableTable.CreateArray()
  for id, count in pairs(self.chosenMap) do
    element = NetConfig.PBC and {} or SceneItem_pb.MatItemInfo()
    element.itemid = id
    element.num = count
    TableUtility.ArrayPushBack(self:IsMainMaterialId(id) and mms or vms, element)
  end
  self.isMaking = true
  self:ActiveMakeButton(false)
  ServiceItemProxy.Instance:CallHighRefineMatComposeCmd(self.selectData.id, npcInfo.data.id, mms, vms)
  ReusableTable.DestroyAndClearArray(mms)
  ReusableTable.DestroyAndClearArray(vms)
end

function EquipAlchemyView:UpdateMKCell(cell)
  local data = cell.data
  if data then
    self.selectData = data
    self.selectCell:SetData(data)
    TableUtility.TableClear(self.chosenMap)
    TableUtility.TableClear(self.materialIds)
    TableUtility.TableClear(self.weightMap)
    self:UpdateChooseCells()
    self.makeCostLabel.text = data.Cost
    for i = 1, #self.mkCells do
      self.mkCells[i]:SetChooseId(data.id)
    end
  end
  self:UpdateCoins()
end

function EquipAlchemyView:UpdateChooseCells()
  if self.selectData == nil or self.isChoosingMM == nil then
    return
  end
  self.chooseCellUpdating = true
  local candidates = self.isChoosingMM and self.selectData.MainMaterial or self.selectData.ViceMaterial
  self.chooseCtl:ResetDatas(candidates)
  self.chooseCtl:ResetPosition()
  self:UpdateCountChoose()
  self.chooseCellUpdating = nil
  self:UpdateAutoInputBtn()
end

function EquipAlchemyView:UpdateCountChoose(newMatId)
  if self.selectData == nil or self.isChoosingMM == nil then
    return
  end
  for _, cell in pairs(self.chooseCells) do
    cell:SetChooseCount(self.chosenMap[cell.data.staticData.id] or 0)
  end
  self:UpdateSliders()
  self:UpdateMaterials(newMatId)
end

local getWeightById = function(id, weightList)
  for i = 1, #weightList do
    if weightList[i][1] == id then
      return weightList[i][2] / 10
    end
  end
end

function EquipAlchemyView:GetUnitWeightById(id)
  if not self.selectData then
    return 0
  end
  if not self.weightMap[id] then
    self.weightMap[id] = getWeightById(id, self:IsMainMaterialId(id) and self.selectData.MainMaterial or self.selectData.ViceMaterial)
  end
  return self.weightMap[id]
end

function EquipAlchemyView:GetChosenWeights()
  local mWeight, vWeight, isMM = 0, 0
  if self.selectData and self.chosenMap then
    for id, count in pairs(self.chosenMap) do
      isMM = self:IsMainMaterialId(id)
      if isMM then
        mWeight = mWeight + count * self:GetUnitWeightById(id)
      elseif isMM == false then
        vWeight = vWeight + count * self:GetUnitWeightById(id)
      end
    end
  end
  return mWeight, vWeight
end

function EquipAlchemyView:UpdateSliders()
  if not self.selectData then
    return
  end
  local mWeight, vWeight = self:GetChosenWeights()
  local curMValue = self.mmSlider.value
  local curVValue = self.vmSlider.value
  local duration_m = curMValue * 100 == mWeight and 0 or 200
  local duration_v = curVValue * 100 == vWeight and 0 or 200
  tickManager:CreateTickFromTo(0, curMValue * 100, mWeight, duration_m, function(owner, deltaTime, curValue)
    self:_UpdateSlider(curValue, self.mmSlider, self.mmSlider_Thumb, self.mmSlider_Thumb_Label, 1)
    self:UpdateActiveButton()
  end, self, 1)
  tickManager:CreateTickFromTo(0, curVValue * 100, vWeight, duration_v, function(owner, deltaTime, curValue)
    self:_UpdateSlider(curValue, self.vmSlider, self.vmSlider_Thumb, self.vmSlider_Thumb_Label, -1)
    self:UpdateActiveButton()
  end, self, 2)
end

function EquipAlchemyView:UpdateMaterials(newMatId)
  if newMatId then
    TableUtility.ArrayPushFront(self.materialIds, newMatId)
  end
  local count
  for i = #self.materialIds, 1, -1 do
    count = self.chosenMap[self.materialIds[i]]
    if not count then
      table.remove(self.materialIds, i)
    end
  end
  if #self.materialIds < 5 then
    for i = 1, 5 - #self.materialIds do
      table.insert(self.materialIds, 0)
    end
  end
  self.matCtl:ResetDatas(self.materialIds)
  if newMatId then
    self.matCtl:ResetPosition()
  end
  for _, cell in pairs(self.matCells) do
    cell:SetChooseReference(self.chosenMap)
  end
end

function EquipAlchemyView:UpdateActiveButton()
  local shouldActive = not self.isMaking and self.vmSlider.value >= 1 and 1 <= self.mmSlider.value
  self:ActiveMakeButton(shouldActive)
end

function EquipAlchemyView:ActiveMakeButton(b)
  b = b and true or false
  self.makeButton_Sprite.spriteName = b and "com_btn_2" or "com_btn_13"
  self.makeButton_Collider.enabled = b
  self.makeButton_Label.effectColor = b and ColorUtil.ButtonLabelOrange or ColorUtil.NGUIGray
end

function EquipAlchemyView:UpdateAutoInputBtn()
  if self.selectData and self.chosenMap then
    local btnValid = false
    local mainMats = self.selectData.MainMaterial
    for i = 1, #mainMats do
      local matID = mainMats[i][1]
      local totalCount = BagProxy.Instance:GetItemNumByStaticID(matID, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
      if 0 < totalCount then
        btnValid = true
        break
      end
    end
    if not btnValid then
      local viceMats = self.selectData.ViceMaterial
      for i = 1, #viceMats do
        local matID = viceMats[i][1]
        local totalCount = BagProxy.Instance:GetItemNumByStaticID(matID, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
        if 0 < totalCount then
          btnValid = true
          break
        end
      end
    end
    self:ActiveAutoInputBtn(btnValid)
  end
end

function EquipAlchemyView:ActiveAutoInputBtn(b)
  b = b and true or false
  xdlog("ActiveAutoInputBtn", b)
  self.autoInputBtn_Sprite.spriteName = b and "com_btn_1" or "com_btn_13"
  self.autoInputBtn_Collider.enabled = b
  self.autoInputBtn_Label.effectColor = b and ColorUtil.ButtonLabelBlue or ColorUtil.NGUIGray
end

function EquipAlchemyView:UpdateMakeDatas(groupid)
  self.mkCtl:ResetDatas(BlackSmithProxy.Instance:GetHighRefineComposeData(groupid))
end

function EquipAlchemyView:UpdateCoins()
  local rob = MyselfProxy.Instance:GetROB()
  self.robLabel.text = StringUtil.NumThousandFormat(rob)
  self.makeCostLabel.color = self.selectData and rob < self.selectData.Cost and ColorUtil.Red or ColorUtil.NGUIDeepGray
end

function EquipAlchemyView:IsMainMaterialId(id)
  local productId = self.selectData and self.selectData.ProductId
  if not productId then
    return
  end
  if self.idMapSelectProductId ~= productId then
    self.VMIdMap = self.VMIdMap or {}
    self.MMIdMap = self.MMIdMap or {}
    TableUtility.TableClear(self.VMIdMap)
    TableUtility.TableClear(self.MMIdMap)
    for _, data in pairs(self.selectData.ViceMaterial) do
      self.VMIdMap[data[1]] = true
    end
    for _, data in pairs(self.selectData.MainMaterial) do
      self.MMIdMap[data[1]] = true
    end
    self.idMapSelectProductId = productId
  end
  if self.VMIdMap[id] then
    return false
  end
  if self.MMIdMap[id] then
    return true
  end
end

function EquipAlchemyView:RefreshSelectCell()
  self:UpdateMKCell(self.selectCell)
end

function EquipAlchemyView:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
end

function EquipAlchemyView:AutoInputMat()
  if self.selectData and self.chosenMap then
    local curWeight, curViceWeight = self:GetChosenWeights()
    local targetWeight = 100 - curWeight
    local targetViceWeight = 100 - curViceWeight
    local mainMats = self.selectData.MainMaterial
    for i = 1, #mainMats do
      if targetWeight <= 0 then
        break
      end
      local matValue = mainMats[i][2]
      local matID = mainMats[i][1]
      local exCount = self.chosenMap[mainMats[i][1]] or 0
      local totalCount = BagProxy.Instance:GetItemNumByStaticID(matID, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
      local unitWeight = self:GetUnitWeightById(matID)
      local maxMatCount = 0 < unitWeight and math.ceil(targetWeight / unitWeight - 0.01) or 0
      if 0 <= maxMatCount and 0 < totalCount then
        local curCount = self.chosenMap[matID] or 0
        if maxMatCount <= totalCount - curCount then
          if not self.chosenMap[matID] then
            self.chosenMap[matID] = maxMatCount
            TableUtility.ArrayPushFront(self.materialIds, matID)
            break
          end
          self.chosenMap[matID] = self.chosenMap[matID] + maxMatCount
          break
        elseif not self.chosenMap[matID] then
          self.chosenMap[matID] = totalCount
          TableUtility.ArrayPushFront(self.materialIds, matID)
          targetWeight = targetWeight - totalCount * unitWeight
        else
          self.chosenMap[matID] = totalCount
          targetWeight = targetWeight - (totalCount - curCount) * unitWeight
        end
      end
    end
    local viceMats = self.selectData.ViceMaterial
    for i = 1, #viceMats do
      if targetViceWeight <= 0 then
        break
      end
      local matValue = viceMats[i][2]
      local matID = viceMats[i][1]
      local exCount = self.chosenMap[matID] or 0
      local totalCount = BagProxy.Instance:GetItemNumByStaticID(matID, GameConfig.PackageMaterialCheck.EquipAlchemy_pack)
      local unitWeight = self:GetUnitWeightById(matID)
      local maxMatCount = 0 < unitWeight and math.ceil(targetViceWeight / unitWeight - 0.01) or 0
      if 0 <= maxMatCount and 0 < totalCount then
        local curCount = self.chosenMap[matID] or 0
        if maxMatCount <= totalCount - curCount then
          if not self.chosenMap[matID] then
            self.chosenMap[matID] = maxMatCount
            TableUtility.ArrayPushFront(self.materialIds, matID)
            break
          end
          self.chosenMap[matID] = self.chosenMap[matID] + maxMatCount
          break
        elseif not self.chosenMap[matID] then
          self.chosenMap[matID] = totalCount
          TableUtility.ArrayPushFront(self.materialIds, matID)
          targetViceWeight = targetViceWeight - totalCount * unitWeight
        else
          self.chosenMap[matID] = totalCount
          targetViceWeight = targetViceWeight - (totalCount - curCount) * unitWeight
        end
      end
    end
    self:UpdateCountChoose()
  end
end

function EquipAlchemyView:OnEnter()
  EquipAlchemyView.super.OnEnter(self)
  local npcInfo = self.viewdata.viewdata.npcdata
  self.npcguid = npcInfo and npcInfo.data.id
  local npcinfo = self:GetCurNpc()
  if npcinfo then
    local rootTrans = npcinfo.assetRole.completeTransform
    self:CameraFocusOnNpc(rootTrans)
  else
    self:CameraRotateToMe()
  end
  self:UpdateMakeDatas(self.viewdata.viewdata.groupid)
  self:UpdateMKCell(self.mkCells[1])
  self:OnClickMMToggle()
  picManager:SetUI("alchemy_bg_bar", self.vmSlider_Foreground)
  picManager:SetUI("alchemy_bg_bar", self.mmSlider_Foreground)
end

function EquipAlchemyView:OnExit()
  self:CameraReset()
  picManager:UnLoadUI("alchemy_bg_bar", self.vmSlider_Foreground)
  picManager:UnLoadUI("alchemy_bg_bar", self.mmSlider_Foreground)
  EquipAlchemyView.super.OnExit(self)
end
