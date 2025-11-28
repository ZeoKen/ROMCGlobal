autoImport("BaseTip")
autoImport("ItemTipModelCell")
autoImport("AdvTipRewardCell")
ItemScoreTip = class("ItemScoreTip", BaseView)

function ItemScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("ItemScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.transform = self.gameObject.transform
  self:Init()
end

function ItemScoreTip:Init()
  self:initLockBord()
  self.cell = ItemTipModelCell.new(self.gameObject)
  self.transform.localPosition = LuaGeometry.Const_V3_zero
end

function ItemScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = (startDepth or 1) + upPanel.depth
  for i = 1, #panels do
    panels[i].depth = panels[i].depth - minDepth + startDepth
  end
end

function ItemScoreTip:initLockBord()
  local l_tsfLockBordHolder = self.transform:Find("BeforePanel/LockBordHolder")
  self.lockBord = l_tsfLockBordHolder.gameObject
  local l_tsfLockBord = l_tsfLockBordHolder:Find("LockBord")
  local objLockBord
  if l_tsfLockBord then
    objLockBord = l_tsfLockBord.gameObject
  else
    objLockBord = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    objLockBord.name = "LockBord"
    l_tsfLockBord = objLockBord.transform
    l_tsfLockBord.localPosition = LuaGeometry.Const_V3_zero
    l_tsfLockBord.localScale = LuaGeometry.Const_V3_one
  end
  self.sprLock = l_tsfLockBord:Find("BottomCt/Sprite (1)"):GetComponent(UISprite)
  self.sprLock.gameObject:SetActive(false)
  l_tsfLockBord:Find("BottomCt/LockTipLabel"):GetComponent(UILabel).onChange = function()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  local l_tsfScrollView = self.transform:Find("MainPanel/Center/ScrollView")
  self.scrollView = l_tsfScrollView:GetComponent(UIScrollView)
  local grid = l_tsfScrollView:Find("CenterTable/UnlockReward/LockInfoGrid"):GetComponent(UIGrid)
  self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell")
  self.bottomCt = l_tsfLockBord:Find("BottomCt").gameObject
  self.tsfFixAttrCtrl = l_tsfScrollView:Find("CenterTable/UnlockReward/FixAttrCt")
  self.modelBottombg = self.transform:Find("MainPanel/Top/PlayerModelContainer/modelBottombg").gameObject
end

function ItemScoreTip:SetData(data, chooseState)
  self.data = data
  self:initData(chooseState)
  self:SetLockState()
  self:adjustLockRewardPos()
  self:adjustPanelDepth(4)
  self.cell:updateWidgetColor()
end

function ItemScoreTip:initData(chooseState)
  if self.data then
    self.cell:SetData(self.data, chooseState)
    self:UpdateAdvReward()
  end
end

function ItemScoreTip:adjustLockRewardPos()
end

function ItemScoreTip:SetLockState()
  self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
  local isUnlockorStore = (self.isUnlock or self.data.store) == true
  self.bottomCt:SetActive(not isUnlockorStore)
  self.modelBottombg:SetActive(isUnlockorStore)
  if isUnlockorStore and self.sprLock then
    self.sprLock:ResetAndUpdateAnchors()
  end
  self.cell.isUnlock = self.isUnlock
  return self.isUnlock
end

function ItemScoreTip:UpdateAdvReward()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    temp.showName = true
    temp.type = "AdventureValue"
    temp.value = self.data.staticData.AdventureValue
    table.insert(advRDatas, temp)
  end
  if type(advReward) == "table" then
    if advReward.AdvPoints then
      local temp = {}
      temp.type = "AdvPoints"
      temp.value = advReward.AdvPoints
      table.insert(advRDatas, temp)
    end
    if advReward.item then
      for i = 1, #advReward.item do
        local temp = {}
        temp.type = "item"
        temp.value = advReward.item[i]
        table.insert(advRDatas, temp)
      end
    end
  end
  local _, y = LuaGameObject.GetLocalPosition(self.tsfFixAttrCtrl)
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.tsfFixAttrCtrl)
  y = y - bound.size.y - 20
  local transform = self.advRewardCtl.layoutCtrl.transform
  local x, _, z = LuaGameObject.GetLocalPosition(transform)
  transform.localPosition = LuaGeometry.GetTempVector3(x, y, z)
  self.advRewardCtl:ResetDatas(advRDatas)
end

function ItemScoreTip:OnExit()
  local chooseState
  self.advRewardCtl:ResetDatas()
  if self.cell then
    chooseState = self.cell:OnExit()
  end
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  ItemScoreTip.super.OnExit(self)
  return chooseState
end

function ItemScoreTip:ItemUpdate()
  self.cell:ItemUpdate()
end
