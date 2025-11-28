autoImport("RaidPuzzleInfoCell")
autoImport("RaidItemCell")
MainViewHeartLockPage = class("MainViewHeartLockPage", SubMediatorView)
local MemoryConfig = GameConfig.HeartLock.MemoryPuzzle

function MainViewHeartLockPage:InitShow()
  self.tipData = {}
  self.tipData.funcConfig = {}
  self.showItem = true
  self:UpdateView(self.showItem)
end

function MainViewHeartLockPage:ResetParent(parent)
  self.trans:SetParent(parent.transform, false)
end

function MainViewHeartLockPage:Show()
  MainViewHeartLockPage.super.Show(self)
end

function MainViewHeartLockPage:UpdateView(showItem)
  self.showItemBtn:SetActive(showItem)
  self.detailContainer:SetActive(not showItem)
  self.closeItemBtn:SetActive(not showItem)
end

function MainViewHeartLockPage:Init()
  self:ReLoadPerferb("view/MainViewHeartLockPage")
  self.myguid = Game.Myself.data.id
  self:FindObjs()
  self:InitShow()
  self:AddViewEvents()
end

function MainViewHeartLockPage:FindObjs()
  local title = self:FindGO("title"):GetComponent(UILabel)
  title.text = GameConfig.HeartLock.Title
  self.detailContainer = self:FindGO("DetailContainer")
  self.showItemBtn = self:FindGO("ItemBtn")
  self:AddClickEvent(self.showItemBtn, function()
    self.showItem = false
    self:UpdateView(self.showItem)
    self.itemTog.value = true
    self:UpdateItems(true)
    self:UpdateMemory(false)
  end)
  self.closeItemBtn = self:FindGO("CloseItemBtn")
  self:AddClickEvent(self.closeItemBtn, function()
    self.showItem = true
    self:UpdateView(self.showItem)
    self.detailContainer:SetActive(not self.showItem)
    self.closeItemBtn:SetActive(not self.showItem)
  end)
  self.itemInfo = self:FindGO("ItemTog")
  self.itemTog = self.itemInfo:GetComponent(UIToggle)
  self:AddClickEvent(self.itemInfo, function()
    self.itemTog.value = true
    self:UpdateItems(true)
    self:UpdateMemory(false)
  end)
  self.memoryInfo = self:FindGO("InfoTog")
  self.memoryTog = self.memoryInfo:GetComponent(UIToggle)
  self:AddClickEvent(self.memoryInfo, function()
    self.memoryTog.value = false
    self:UpdateItems(false)
    self:UpdateMemory(true)
    RedTipProxy.Instance:RemoveWholeTip(711)
  end)
  self.itemPanelParent = self:FindGO("ItemScrollView")
  self.itemContainer = self:FindGO("ItemContainer")
  self.itemCtrl = WrapListCtrl.new(self.itemContainer, RaidItemCell, "RaidItemCell", WrapListCtrl_Dir.Vertical, 3, 100, true)
  self.itemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.itemCells = self.itemCtrl:GetCells()
  self.normalStick = self:FindComponent("NormalStick", UISprite)
  self.InfoTable = self:FindGO("InfoTable")
  local uitable = self.InfoTable:GetComponent(UITable)
  self.infoCtl = UIGridListCtrl.new(uitable, RaidPuzzleInfoCell, "RaidPuzzleBuffCell")
  RedTipProxy.Instance:RegisterUI(711, self.showItemBtn, 4, {-5, 0})
  RedTipProxy.Instance:RegisterUI(711, self.memoryInfo, 4, {0, 0})
  local fragmentContainer = self:FindGO("FragmentContainer")
  self.fragmentSp = {}
  for i = 1, 4 do
    self.fragmentSp[i] = self:FindGO("fg" .. i, fragmentContainer)
    self.fragmentSp[i]:SetActive(false)
  end
  self.itemTip = self:FindGO("itemTip")
  local tiplable = self.itemTip:GetComponent(UILabel)
  tiplable.text = ZhString.SteathGame_ItemTip
  self.memoryTip = self:FindGO("memoryTip")
  tiplable = self.memoryTip:GetComponent(UILabel)
  tiplable.text = ZhString.SteathGame_MemoryTip
  self.itemTip:SetActive(false)
  self.memoryTip:SetActive(false)
end

local tipOffset = {-210, 0}

function MainViewHeartLockPage:OnClickCell(cell)
  self.tipData.itemdata = cell.data
  self:ShowItemTip(self.tipData, self.normalStick, NGUIUtil.AnchorSide.Left, tipOffset)
end

function MainViewHeartLockPage:AddViewEvents()
  self:AddListenEvt(SceneUserEvent.SceneAddNpcs, self.HandleAddNpc)
  self:AddListenEvt(SceneUserEvent.SceneRemoveNpcs, self.HandleRemoveNpc)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Update, self.HandleUpdateItems)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Add, self.HandleAddItems)
  self:AddDispatcherEvt(StealthGameEvent.RaidItem_Del, self.HandleUpdateItems)
  self:AddDispatcherEvt(StealthGameEvent.Update_MemoryInfo, self.HandleUpdateMemory)
end

function MainViewHeartLockPage:UpdateItems(show)
  self.itemPanelParent:SetActive(show)
  local itemdatas = SgAIManager.Me():GetPlayerItemdatas()
  if itemdatas and 0 < #itemdatas then
    self.itemCtrl:ResetDatas(itemdatas)
    self.itemTip:SetActive(false)
  else
    self.itemCtrl:ResetDatas({})
    self.itemTip:SetActive(show)
  end
end

function MainViewHeartLockPage:HandleUpdateItems(singleUpdate)
  local itemdatas = SgAIManager.Me():GetPlayerItemdatas()
  if not self.showItem and self.itemTog.value == true then
    if itemdatas and 0 < #itemdatas then
      self.itemCtrl:ResetDatas(itemdatas)
      self.itemTip:SetActive(false)
    else
      self.itemCtrl:ResetDatas({})
      self.itemTip:SetActive(true)
    end
  end
  if singleUpdate ~= true then
    local count = 0
    if itemdatas and 0 < #itemdatas then
      for itemid, index in pairs(MemoryConfig) do
        count = SgAIManager.Me():getItemById(itemid) or 0
        self.fragmentSp[index]:SetActive(0 < count)
      end
    else
      for i = 1, #self.fragmentSp do
        self.fragmentSp[i]:SetActive(false)
      end
    end
  end
end

function MainViewHeartLockPage:HandleAddItems(itemid)
  local index = itemid and MemoryConfig[itemid]
  if index and self.fragmentSp[index] then
    self.fragmentSp[index]:SetActive(true)
  end
  self:HandleUpdateItems(true)
end

function MainViewItemPage:ClearHeartLockItems()
  if self.heartLockItemCtrl then
    self.heartLockItemCtrl:RemoveAll()
  end
end

function MainViewHeartLockPage:UpdateMemory(show)
  self.InfoTable:SetActive(show)
  local mem = SgAIManager.Me():getMemory()
  if mem then
    self.infoCtl:ResetDatas(mem)
    self.memoryTip:SetActive(false)
  else
    self.memoryTip:SetActive(show)
  end
end

function MainViewHeartLockPage:HandleUpdateMemory()
  if not self.showme and self.memoryTog.value == true then
    local mem = SgAIManager.Me():getMemory()
    if mem then
      self.infoCtl:ResetDatas(mem)
      self.memoryTip:SetActive(false)
    else
      self.memoryTip:SetActive(true)
    end
  end
end

function MainViewHeartLockPage:Hide(target)
  MainViewHeartLockPage.super.Hide(self)
end

function MainViewHeartLockPage:OnExit()
  RedTipProxy.Instance:UnRegisterUI(711, self.showItemBtn)
  RedTipProxy.Instance:UnRegisterUI(711, self.self.memoryInfo)
end
