local baseCell = autoImport("BaseCell")
GainWayTipCell = class("GainWayTipCell", baseCell)
GainWayTipCell.AddItemTrace = "GainWayTipCell_AddItemTrace"
GainWayTipCell.CloseGainWay = "GainWayTipCell_CloseGainWay"

function GainWayTipCell:Init()
  GainWayTipCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function GainWayTipCell:FindObjs()
  self.empty = self:FindGO("Empty")
  self.item = self:FindGO("Item")
  self.notOpen = self:FindGO("notOpen")
  self.itemName = self:FindGO("itemName"):GetComponent(UILabel)
  self.getWay = self:FindGO("getWay"):GetComponent(UILabel)
  self.signSprite = self:FindGO("signSprite"):GetComponent(UISprite)
  self.Icon_Sprite = self:FindGO("Icon_Sprite"):GetComponent(UISprite)
  self.bossLevel = self:FindGO("bossLevel"):GetComponent(UILabel)
  self.gotoBtn = self:FindGO("GoToButton")
  self:AddClickEvent(self.gotoBtn, function(go)
    self:PassEvent(ItemEvent.GoTraceItem, self.data)
  end)
  self.traceBtn = self:FindGO("TraceButton")
  if self.traceBtn then
    self.traceBtn:SetActive(false)
  end
end

function GainWayTipCell:SetData(data)
  self.data = data
  if data then
    self:SetActive(self.item, true)
    self:SetActive(self.empty, false)
    self.signSprite.gameObject:SetActive(false)
    self.itemName.text = data.name
    UIUtil.WrapLabel(self.itemName)
    self.getWay.text = data:GetDesc()
    if data.type == GainWayItemCellType.Monster then
      IconManager:SetFaceIcon(data.icon, self.Icon_Sprite)
      self.bossLevel.gameObject:SetActive(true)
      self.bossLevel.text = "Lv." .. data.level
      if data.monsterType == "MINI" then
        IconManager:SetUIIcon("ui_HP_2", self.signSprite)
        self.signSprite.gameObject:SetActive(true)
      elseif data.monsterType == "MVP" then
        IconManager:SetUIIcon("ui_HP_1", self.signSprite)
        self.signSprite.gameObject:SetActive(true)
      elseif data.monsterType == "Deadboss" then
        IconManager:SetMapIcon("ui_mvp_dead11_JM", self.signSprite)
        self.signSprite.gameObject:SetActive(true)
      end
    elseif data.type == GainWayItemCellType.Item then
      IconManager:SetItemIcon(data.icon, self.Icon_Sprite)
      self.bossLevel.gameObject:SetActive(false)
    else
      self.bossLevel.gameObject:SetActive(false)
      if data.icon ~= "" then
        local succ = IconManager:SetUIIcon(data.icon, self.Icon_Sprite)
        succ = succ or IconManager:SetItemIcon(data.icon, self.Icon_Sprite)
        if not succ then
          succ = IconManager:SetFaceIcon(data.icon, self.Icon_Sprite)
        end
      else
        IconManager:SetFaceIcon(data.npcFace, self.Icon_Sprite)
      end
    end
    self.notOpen:SetActive(not data.isOpen)
    local id = self.data.addWayID
    local gotoMode = Table_AddWay[id] and Table_AddWay[id].GotoMode
    local canTraceMonster = self.data:CheckMonsterCanBeTraced()
    local noGotoMode = gotoMode == nil or gotoMode[1] == nil
    if data.ShouldGotoUnlock and data:ShouldGotoUnlock() then
      self.gotoBtn:SetActive(true)
    elseif noGotoMode and not canTraceMonster then
      self.gotoBtn:SetActive(false)
    elseif not noGotoMode and not FuncShortCutFunc.Me():CanExecShortCutPower(gotoMode[1]) then
      self.gotoBtn:SetActive(false)
    else
      self.gotoBtn:SetActive(true)
    end
  else
    self:SetActive(self.item, false)
    self:SetActive(self.empty, true)
  end
end
