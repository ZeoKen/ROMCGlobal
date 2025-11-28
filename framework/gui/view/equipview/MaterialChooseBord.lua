autoImport("MaterialChooseCell")
MaterialChooseBord = class("MaterialChooseBord", CoreView)
MaterialChooseBord.PfbPath = "part/MaterialChooseBord"
MaterialChooseBord.ChooseItem = "MaterialChooseBord_ChooseItem"

function MaterialChooseBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.chooseIds = {}
  self.gameObject = self:LoadPreferb(MaterialChooseBord.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(80)
  self:InitDepth()
  self.getDataFunc = getDataFunc
  self.title = self:FindComponent("Title", UILabel)
  self.chooseCtl = WrapListCtrl.new(self:FindGO("ChooseGrid"), MaterialChooseCell, "MaterialItemNewCell", WrapListCtrl_Dir.Vertical, 4, 92, true)
  self.chooseCtl:AddEventListener(MouseEvent.MouseClick, self.ClickEvent, self)
  self.chooseCtl:AddEventListener(MouseEvent.LongPress, self.LongPressEvent, self)
  self.chooseCtl:ResetPosition()
  self:AddButtonEvent("ConfirmBtn", function()
    local chooseDatas = {}
    for i = 1, #self.chooseIds do
      local data = BagProxy.Instance:GetItemByGuid(self.chooseIds[i])
      table.insert(chooseDatas, data)
    end
    if self.chooseCall then
      self.chooseCall(self.chooseCallParam, chooseDatas)
    end
  end)
  self:AddButtonEvent("CancelBtn", function()
    self:Hide()
  end)
end

function MaterialChooseBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

local tipOffset = {200, -200}

function MaterialChooseBord:LongPressEvent(cellctl)
  local data = cellctl and cellctl.data
  local go = cellctl and cellctl.chooseSymbol
  local newClickId = data and data.id or 0
  if self.clickId ~= newClickId then
    self.clickId = newClickId
    if not self.tipData then
      self.tipData = {
        funcConfig = _EmptyTable,
        hideGetPath = true,
        callback = function()
          self.clickId = 0
        end,
        ignoreBounds = {
          self.chooseCtl.container
        }
      }
    end
    self.tipData.itemdata = data
    self:ShowItemTip(self.tipData, go:GetComponent(UIWidget), nil, tipOffset)
  else
    self:ShowItemTip()
    self.clickId = 0
  end
end

function MaterialChooseBord:ClickEvent(cellctl)
  if cellctl and cellctl.data then
    if BagProxy.Instance:CheckIfFavoriteCanBeMaterial(cellctl.data) == false then
      return
    end
    local id = cellctl.data.id
    local find = false
    for i = 1, #self.chooseIds do
      if id == self.chooseIds[i] then
        table.remove(self.chooseIds, i)
        find = true
        break
      end
    end
    if not find then
      if not self.totalNum then
        TableUtility.ArrayClear(self.chooseIds)
        table.insert(self.chooseIds, id)
      elseif self.totalNum <= #self.chooseIds then
        MsgManager.ShowMsgByIDTable(244)
        return
      elseif self.checkFunc and not self.checkFunc(self.checkFuncParam, cellctl.data) then
        MsgManager.FloatMsg(nil, self.checkTip)
        return
      else
        table.insert(self.chooseIds, id)
      end
    end
    self:UpdateChooseUI()
  end
end

function MaterialChooseBord:CheckHasRfLvOrEc(data)
  local refinelv = data.equipInfo.refinelv or 0
  local hasEc = false
  if data.enchantInfo then
    local attrs = data.enchantInfo:GetEnchantAttrs()
    if 0 < #attrs then
      hasEc = true
    end
  end
  return 0 < refinelv or hasEc
end

function MaterialChooseBord:SetTotalNum(num)
  self.totalNum = num
end

function MaterialChooseBord:UpdateChooseUI()
  local cells = self.chooseCtl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChooseIds(self.chooseIds)
  end
  self:SetBordTitle()
end

function MaterialChooseBord:SetChoose(datas)
  TableUtility.ArrayClear(self.chooseIds)
  if datas then
    for i = 1, #datas do
      table.insert(self.chooseIds, datas[i])
    end
  end
  self:UpdateChooseUI()
end

function MaterialChooseBord:ResetDatas(datas, resetPos)
  self.datas = datas
  if resetPos then
    self.chooseCtl:ResetPosition()
  end
  self.chooseCtl:ResetDatas(datas)
end

function MaterialChooseBord:UpdateChooseInfo(datas)
  if not datas and self.getDataFunc then
    datas = self.getDataFunc()
  end
  datas = datas or {}
  self:ResetDatas(datas)
end

function MaterialChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
  if updateInfo then
    self:UpdateChooseUI()
  end
  self.gameObject:SetActive(true)
  self:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function MaterialChooseBord:Hide()
  TipManager.Instance:CloseTip()
  self.gameObject:SetActive(false)
  self.chooseCall = nil
  self.chooseCallParam = nil
  self.checkFunc = nil
  self.checkTip = nil
end

function MaterialChooseBord:ActiveSelf()
  return self.gameObject.activeSelf
end

function MaterialChooseBord:SetBordTitle()
  if self.totalNum then
    local curNum = #self.chooseIds .. "/" .. self.totalNum
    local text = string.format(ZhString.EquipRefinePage_ChooseMaterialTip, curNum)
    self.title.text = text
  end
end

function MaterialChooseBord:Set_CheckValidFunc(checkFunc, checkFuncParam, checkTip)
  self.checkFunc = checkFunc
  self.checkFuncParam = checkFuncParam
  self.checkTip = checkTip
end
