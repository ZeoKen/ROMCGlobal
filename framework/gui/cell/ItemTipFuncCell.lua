local BaseCell = autoImport("BaseCell")
ItemTipFuncCell = class("ItemTipFuncCell", BaseCell)
local backgroundSprite = {
  [1] = "new-com_btn_c",
  [2] = "new-com_btn_a"
}
local outlineColor = {
  [1] = Color(0.7686274509803922, 0.5254901960784314, 0, 1),
  [2] = Color(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
}

function ItemTipFuncCell:Init()
  self.label = self:FindChild("Label"):GetComponent(UILabel)
  self.label_effect_oriColor = self.label.effectColor
  self.label_effect_blueColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
  self.originalPos = {}
  self.originalPos.x, self.originalPos.y, self.originalPos.z = LuaGameObject.GetLocalPositionGO(self.gameObject)
  self.bg = self:FindChild("Background"):GetComponent(UISprite)
  self.collider = self.gameObject:GetComponent(BoxCollider)
  self.funcTip = self:FindComponent("FuncTipLab", UILabel)
  self:AddCellClickEvent()
end

function ItemTipFuncCell:SetData(data)
  self.data = data
  if data then
    self.gameObject:SetActive(true)
    LuaGameObject.SetLocalPositionGO(self.gameObject, self.originalPos.x, self.originalPos.y, self.originalPos.z)
    self.bg.width = 180
    if self.funcTip then
      self:Hide(self.funcTip)
    end
    self.bg.spriteName = backgroundSprite[data.btnStyle or 1]
    self.label.effectColor = outlineColor[data.btnStyle or 1]
    if data.type == "Active" then
      if data.itemData and data.itemData.isactive then
        self.label.text = ZhString.ItemTipFuncCell_Down
      else
        self.label.text = data.name
      end
    elseif data.type == "GetTask" then
      if not data.itemData or not data.itemData.staticData then
        return
      end
      local questID = Table_UseItem[data.itemData.staticData.id].UseEffect.questid
      if questID then
        local bContain, enum = QuestProxy.Instance:checkQuestHasAccept(questID)
        if bContain and enum and enum == 1 then
          self.label.text = ZhString.AdventureRewardPanel_HasGetAward
          self:SetTextureGrey(self.gameObject)
        else
          self.label.text = data.name
        end
      end
    elseif data.type == "BeVIP" then
      LuaGameObject.SetLocalPositionGO(self.gameObject, self.originalPos.x, -30, self.originalPos.z)
      self.bg.width = 220
      self.label.text = data.name
      if self.funcTip then
        self:Show(self.funcTip)
        self.funcTip.text = ZhString.Lottery_VipFuncTip
      end
    elseif data.type == "UseAnonymousItem" then
      local isAnonymous = Game.Myself.data:IsAnonymous()
      self.label.text = isAnonymous and ZhString.ItemTip_TakeOff or ZhString.ItemTip_PutOn
    elseif data.itemData and data.itemData.isactive then
      self.label.text = ZhString.FunctionNpcFunc_Cancel
    else
      self.label.text = data.name
    end
    if data.inactive == true then
      self.collider.enabled = false
      self.bg.color = ColorUtil.NGUIShaderGray
      self.label.effectColor = ColorUtil.NGUIGray
    else
      self.collider.enabled = true
      self.bg.color = ColorUtil.NGUIWhite
      self.label.effectColor = outlineColor[data.btnStyle or 1]
    end
  else
    self.gameObject:SetActive(false)
  end
  self:UpdateGuideTarget()
end

function ItemTipFuncCell:AddQuestCallback(note)
  if not self.data or self.data.type ~= "GetTask" then
    return
  end
  local result = false
  local useItemID = self.data.itemData.staticData.id
  local itemQuestID = Table_UseItem[useItemID].UseEffect.id
  if itemQuestID then
    for k, v in pairs(note.data) do
      if v == itemQuestID then
        result = true
        break
      end
    end
  end
  if result then
    local taskID = itemQuestID
    local name = MsgParserProxy.Instance:GetQuestName(taskID)
    if name then
    end
  end
end

function ItemTipFuncCell:UpdateGuideTarget()
  if self.data and self.data.type == "Apply" then
    self.guideTarget = ClientGuide.TargetType.itemtip_applybutton
    self:RegisterGuideTarget(ClientGuide.TargetType.itemtip_applybutton, self.gameObject)
  elseif self.data and self.data.type == "EmbedGem" then
    self.guideTarget = ClientGuide.TargetType.itemtip_embedgembutton
    self:RegisterGuideTarget(ClientGuide.TargetType.itemtip_embedgembutton, self.gameObject)
  end
end

function ItemTipFuncCell:OnCellDestroy()
  ItemTipFuncCell.super.OnCellDestroy(self)
  if self.guideTarget then
    self:UnRegisterGuideTarget(self.guideTarget)
    self.guideTarget = nil
  end
end
