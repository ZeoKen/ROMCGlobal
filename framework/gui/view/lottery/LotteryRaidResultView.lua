autoImport("LotteryResultCell")
LotteryRaidResultView = class("LotteryRaidResultView", ContainerView)
LotteryRaidResultView.ViewType = UIViewType.PopUpLayer
local GetLocalPosition = LuaGameObject.GetLocalPosition

function LotteryRaidResultView:Init()
  self:FindObjs()
  self:InitShow()
  local close = self:FindGO("CloseButton", pfb)
  self:AddClickEvent(close, function()
    GameFacade.Instance:sendNotification(XDEUIEvent.LotteryAnimationEnd)
    self:CloseSelf()
  end)
  local share = self:FindGO("ShareButton")
  self:AddClickEvent(share, function()
    if ApplicationInfo.IsRunOnWindowns() then
      MsgManager.ShowMsgByID(43486)
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryRaidResultShareView,
      viewdata = {
        list = self.itemList,
        safety_itemid = self.viewdata.viewdata.safety_itemid
      }
    })
  end)
end

function LotteryRaidResultView:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
end

function LotteryRaidResultView:InitShow()
  local data = self.viewdata.viewdata.list
  if data then
    self.itemList = {}
    for i = 1, #data do
      self.itemList[#self.itemList + 1] = data[i]:Clone()
    end
    local grid = self:FindGO("Grid"):GetComponent(UIGrid)
    self.itemCtl = UIGridListCtrl.new(grid, LotteryResultCell, "LotteryResultCell")
    self.itemCtl:ResetDatas(self.itemList)
    local itemCells = self.itemCtl:GetCells()
    local safetyItemId = self.viewdata.viewdata.safety_itemid
    for i = 1, #itemCells do
      local itemData = itemCells[i].data
      local isFashion = itemData ~= nil and itemData.staticData ~= nil and itemData.staticData.id == safetyItemId
      self:SetNormal(self.effectContainer, isFashion, GetLocalPosition(itemCells[i].trans))
    end
  end
  local button = self:FindGO("Button")
  local btnText = self.viewdata.viewdata.btnText
  if btnText ~= nil then
    local label = self:FindGO("Label", button)
    local sl = SpriteLabel.new(label, nil, 36, 36, true)
    sl:SetText(btnText, true)
  end
  local btnCallback = self.viewdata.viewdata.btnCallback
  if btnCallback ~= nil then
    self:AddClickEvent(button, btnCallback)
  else
    self:AddClickEvent(button, function()
      self:CloseSelf()
    end)
  end
end

local effectName

function LotteryRaidResultView:SetNormal(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.Egg10DritO or EffectMap.UI.Egg10DritB
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
end
