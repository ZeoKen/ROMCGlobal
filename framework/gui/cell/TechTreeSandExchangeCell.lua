TechTreeSandExchangeCell = class("TechTreeSandExchangeCell", ItemCell)
TechTreeSandExchangeCell.InputChange = "TechTreeSandExchangeCell_InputChange"
TechTreeSandExchangeCell.InputSubmit = "TechTreeSandExchangeCell_InputSubmit"
local limitCharacter, subtractLongPressTickId, plusLongPressTickId = 3, 78, 79
local tickManager

function TechTreeSandExchangeCell:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self:InitItem()
  TechTreeSandExchangeCell.super.Init(self)
  self:InitCountCtrl()
  self.maxCellInputAmount = 999
  self.step = 1
end

function TechTreeSandExchangeCell:InitItem()
  local itemCellObjName = "Common_MaterialItemCell"
  local materialContainer = self:FindGO("MaterialContainer")
  local materialCell = self:FindGO(itemCellObjName)
  if not materialCell then
    local go = self:LoadPreferb("cell/MaterialItemCell", materialContainer)
    go.name = itemCellObjName
    self:AddClickEvent(go, function()
      self:PassEvent(MouseEvent.MouseClick, self)
    end)
  end
end

function TechTreeSandExchangeCell:InitCountCtrl()
  local countCtrl = self:FindGO("CountCtrl")
  self.countInput = countCtrl:GetComponent(UIInput)
  EventDelegate.Set(self.countInput.onChange, function()
    self:PassEvent(self:GetInputChangeEvtStr(), self)
  end)
  local onSubmit = function()
    self:PassEvent(self:GetInputSubmitEvtStr(), self)
  end
  EventDelegate.Set(self.countInput.onSubmit, onSubmit)
  self:AddSelectEvent(self.countInput, onSubmit)
  UIUtil.LimitInputCharacter(self.countInput, limitCharacter)
  local countSubtract = self:FindGO("CountSubtract", countCtrl)
  local countPlus = self:FindGO("CountPlus", countCtrl)
  self:AddClickEvent(countSubtract, function()
    self:OnClickCountSubtract()
  end)
  self:AddClickEvent(countPlus, function()
    self:OnClickCountPlus()
  end)
  self.countSubtractBg = countSubtract:GetComponent(UISprite)
  self.countSubtractSp = self:FindComponent("Subtract", UISprite, countSubtract)
  self.countPlusBg = countPlus:GetComponent(UISprite)
  self.countPlusSp = self:FindComponent("Plus", UISprite, countPlus)
  local longPress = countSubtract:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      self:OnLongPressCountSubtract(state)
    end
  end
  longPress = countPlus:GetComponent(UILongPress)
  if longPress then
    function longPress.pressEvent(obj, state)
      self:OnLongPressCountPlus(state)
    end
  end
end

function TechTreeSandExchangeCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  self.step = GameConfig.Item.progressive_to_sand[data.staticData.id]
  self.maxCellInputAmount = math.pow(10, limitCharacter) - self.step
  self.empty:SetActive(false)
  local ret = IconManager:SetItemIcon(data.staticData.Icon, self.icon)
  if ret then
    self.icon:MakePixelPerfect()
  end
  self:UpdateItemNum()
  self:SetCardInfo(data)
end

function TechTreeSandExchangeCell:OnClickCountSubtract()
  self.countInput.value = self:GetCurSelectCount() - (self.step or 1)
end

function TechTreeSandExchangeCell:OnClickCountPlus()
  self.countInput.value = self:GetCurSelectCount() + (self.step or 1)
end

function TechTreeSandExchangeCell:OnLongPressCountSubtract(state)
  if state then
    tickManager:CreateTick(0, 100, self.OnClickCountSubtract, self, subtractLongPressTickId)
  else
    tickManager:ClearTick(self, subtractLongPressTickId)
  end
end

function TechTreeSandExchangeCell:OnLongPressCountPlus(state)
  if state then
    tickManager:CreateTick(0, 100, self.OnClickCountPlus, self, plusLongPressTickId)
  else
    tickManager:ClearTick(self, plusLongPressTickId)
  end
end

function TechTreeSandExchangeCell:UpdateItemNum()
  self:UpdateNumLabel(0)
  if not self.data then
    return
  end
  self.countInput.value = self.data.num
  local colorStr = self.data.num >= self.data.neednum and "" or "[c][50C82F]"
  self:UpdateNumLabel(string.format("%s%s[-][/c]/%s", colorStr, self.data.num, self.data.neednum))
end

function TechTreeSandExchangeCell:UpdateInputByRestCount(restCount)
  local count = self:GetCurSelectCount()
  if not count then
    return
  end
  restCount = restCount or 0
  if count < 0 then
    self.countInput.value = 0
  elseif restCount < 0 then
    self.countInput.value = math.floor((count + restCount) / self.step) * self.step
  end
  count = self:GetCurSelectCount()
  if not count then
    return
  end
  self:SetCountSubtract(count <= 0 and 0.5 or 1)
  self:SetCountPlus((restCount < self.step or self.maxCellInputAmount - count < self.step) and 0.5 or 1)
end

function TechTreeSandExchangeCell:SetCountSubtract(alpha)
  if self.countSubtractBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countSubtractBg, alpha)
    self:SetSpriteAlpha(self.countSubtractSp, alpha)
  end
end

function TechTreeSandExchangeCell:SetCountPlus(alpha)
  if self.countPlusBg.color.a ~= alpha then
    self:SetSpriteAlpha(self.countPlusBg, alpha)
    self:SetSpriteAlpha(self.countPlusSp, alpha)
  end
end

function TechTreeSandExchangeCell:SetSpriteAlpha(sprite, alpha)
  sprite.color = LuaGeometry.GetTempColor(sprite.color.r, sprite.color.g, sprite.color.b, alpha)
end

function TechTreeSandExchangeCell:GetCurSelectCount()
  return math.floor(math.clamp(tonumber(self.countInput.value) or 0, 0, self.maxCellInputAmount))
end

function TechTreeSandExchangeCell:GetInputChangeEvtStr()
  return TechTreeSandExchangeCell.InputChange
end

function TechTreeSandExchangeCell:GetInputSubmitEvtStr()
  return TechTreeSandExchangeCell.InputSubmit
end
