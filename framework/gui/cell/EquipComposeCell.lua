EquipComposeCell = class("EquipComposeCell", ItemNewCell)
local SCALE_SIZE = 0.8
local PACKAGE_CFG = GameConfig.PackageMaterialCheck.equipcompose
local _ParseColor = function(hexStr)
  local success, c = ColorUtil.TryParseHexString(hexStr)
  if success then
    return c
  end
end
local _redColor = {"ff6021", "495063"}

function EquipComposeCell:Init()
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.needChoose = self:FindGO("NeedChoose")
  self.replaceIcon = self:FindGO("ReplaceIcon")
  local obj = self:LoadPreferb("cell/ItemNewCell", self.gameObject)
  EquipComposeCell.super.Init(self)
  self:AddTipEvt()
  self:AddCellClickEvent()
end

function EquipComposeCell:AddTipEvt()
  self.tipData = {}
  self.tipData.funcConfig = {}
  local press = function(obj, state)
    if state and self.choosed and self.data ~= nil then
      self.tipData.itemdata = self.data
      TipManager.Instance:ShowItemFloatTip(self.tipData, self.icon, NGUIUtil.AnchorSide.Right, {210, -50})
    end
  end
  self.longPress = self.gameObject:GetComponent(UILongPress)
  self.longPress.pressEvent = press
end

function EquipComposeCell:SetData(data)
  EquipComposeCell.super.SetData(self, data)
  self.data = data
  if data and data.staticData then
    self:Show(self.gameObject)
    local equiplv = data.equipLvLimited
    if equiplv and 0 < equiplv then
      self:SetActive(self.equiplv, true)
      self.equiplv.text = StringUtil.IntToRoman(equiplv)
    end
    local curData = EquipComposeProxy.Instance:GetCurData()
    self.choosed = 0 ~= curData:GetChooseMat(data.staticData.id)
    if self.needChoose then
      self.needChoose:SetActive(not self.choosed)
    end
    if self.replaceIcon then
      self.replaceIcon:SetActive(self.choosed)
    end
    self.icon.alpha = self.choosed and 1 or 0.7
    local own = BagProxy.Instance:GetItemNumByStaticID(data.staticData.id, PACKAGE_CFG)
    if not self.numLab then
      return
    end
    if own < data.num then
      self.numLab.color = _ParseColor(_redColor[1])
      self.numLab.effectColor = _ParseColor(_redColor[2])
    else
      ColorUtil.WhiteUIWidget(self.numLab)
    end
  else
    if self.needChoose then
      self.needChoose:SetActive(false)
    end
    if self.replaceIcon then
      self.replaceIcon:SetActive(false)
    end
    if self.empty then
      local emptySP = self.empty:GetComponent(UISprite)
      if emptySP then
        emptySP.alpha = 1
      end
    end
  end
end
