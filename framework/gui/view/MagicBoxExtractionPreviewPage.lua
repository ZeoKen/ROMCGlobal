autoImport("MagicBoxExtractionPage")
autoImport("ExtractionPreviewSlotCell")
MagicBoxExtractionPreviewPage = class("MagicBoxExtractionPreviewPage", MagicBoxExtractionPage)
local BagProxy = BagProxy.Instance
local EquipExtractionConfig = GameConfig.EquipExtraction
local ExtractionCostItem = EquipExtractionConfig.ExtractionCostItem
local ExtraCost = EquipExtractionConfig.ExtraCost
local RefreshCost = EquipExtractionConfig.RefreshCost
local grey = LuaColor.New(0.4470588235294118, 0.4470588235294118, 0.4470588235294118)
local mine = 0
local discount = 1
local gridid, itemid

function MagicBoxExtractionPreviewPage:Init(initParams)
  MagicBoxExtractionPreviewPage.super.Init(self, initParams)
  self.slotDatas = initParams and initParams.slotdatas or {}
end

function MagicBoxExtractionPreviewPage:InitUI()
  MagicBoxExtractionPreviewPage.super.InitUI(self)
  self.slotGridCtrl = UIGridListCtrl.new(self.slotGrid, ExtractionPreviewSlotCell, "ExtractionSlotCell")
  self.slotGridCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickSlotCell, self)
  self.emptyBtn = self:FindGO("EmptyBtn")
  local emptyBtnCollider = self.emptyBtn:GetComponent(BoxCollider)
  if emptyBtnCollider then
    emptyBtnCollider.enabled = false
  end
  local emptyBtnIcon = self.emptyBtn:GetComponent(UISprite)
  emptyBtnIcon.spriteName = "com_btn_13s"
  local emptyBtnLab = self:FindComponent("Label", UILabel, self.emptyBtn)
  emptyBtnLab.effectColor = grey
  local activeBtnCollider = self.activeBtn:GetComponent(BoxCollider)
  if activeBtnCollider then
    activeBtnCollider.enabled = false
  end
  local activeBtnIcon = self.activeBtn:GetComponent(UISprite)
  activeBtnIcon.spriteName = "com_btn_13s"
  local activeBtnLab = self:FindComponent("Label", UILabel, self.activeBtn)
  activeBtnLab.effectColor = grey
  self.addBtn = self:FindGO("AddBtn")
  local addBtnCollider = self.addBtn:GetComponent(BoxCollider)
  if addBtnCollider then
    addBtnCollider.enabled = false
  end
  self.extractBtn = self:FindGO("ExtractBtn")
  self.extractButton = self.extractBtn:GetComponent(UIButton)
  self.extractButton.isEnabled = false
  self.extractBtnLabel = self:FindComponent("Label", UILabel, self.extractBtn)
  self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
  self.extractBtnLabel.effectColor = grey
end

function MagicBoxExtractionPreviewPage:AddViewEvent()
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(penelID, helpBtn)
  self:AddClickEvent(self:FindGO("CloseButton"), function(go)
    self:sendNotification(MagicBoxEvent.CloseContainerview)
  end)
end

function MagicBoxExtractionPreviewPage:AddListener()
  self:AddListenEvt(ServiceEvent.NUserExtractionQueryUserCmd, self.UpdateView)
end

function MagicBoxExtractionPreviewPage:InitView()
  if self.currentCell then
    self:ClickSlotCell(self.currentCell)
  else
    local cells = self.slotGridCtrl and self.slotGridCtrl:GetCells()
    self:ClickSlotCell(cells and cells[1])
  end
end

function MagicBoxExtractionPreviewPage:ClickSlotCell(cell)
  if not cell then
    return
  end
  if not cell.data.got then
    return
  end
  self.currentCell = cell
  local cells = self.slotGridCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetChoose(cells[i].data.gridid == cell.data.gridid)
  end
  self.equipName.text = ""
  self.hideContainer:SetActive(true)
  self.currentContainer:SetActive(false)
  self:UpdateInfoContainer()
  self:UpdateButton()
end

function MagicBoxExtractionPreviewPage:UpdateInfoContainer()
  local single = self.currentCell and self.currentCell.data
  if not single or single.itemid == 0 then
    self.hideContainer:SetActive(true)
    self.currentContainer:SetActive(false)
    self.noRefreshTip:SetActive(false)
    self.extractBtnLabel.text = ZhString.MagicBox_Extract
    self.extractBtn:SetActive(true)
    self.equipName.text = ""
    self.chooseItemIcon.gameObject:SetActive(false)
    self.discount:SetActive(false)
    local iconsp = Table_Item[ExtractionCostItem].Icon
    IconManager:SetItemIcon(iconsp, self.costIcon)
    self.costNum.text = "0"
  else
    self.hideContainer:SetActive(false)
    self.currentContainer:SetActive(true)
    self.equipName.text = single.itemStaticData.NameZh
    self:UpdateBuffInfo(single.itemid)
    if single.itemStaticData then
      IconManager:SetItemIcon(single.itemStaticData.Icon, self.chooseItemIcon)
      self.equipName.text = single.itemStaticData.NameZh
      self.chooseItemIcon.gameObject:SetActive(true)
    end
    self:SetUpRefresh()
  end
end

function MagicBoxExtractionPreviewPage:UpdateButton()
  MagicBoxExtractionPreviewPage.super.UpdateButton(self)
end

local contextlabel

function MagicBoxExtractionPreviewPage:UpdateBuffInfo(equipID)
  self.costContainer:SetActive(false)
  if contextlabel then
    TableUtility.ArrayClear(contextlabel)
  else
    contextlabel = {}
  end
  local str = Table_EquipExtraction[equipID].Dsc
  local bufferStrs = string.split(str, "\n")
  for j = 1, #bufferStrs do
    table.insert(contextlabel, bufferStrs[j])
  end
  self.infoTableCtrl:ResetDatas(contextlabel)
end

function MagicBoxExtractionPreviewPage:ShowEquipBord()
end

local equipID = 0
local refreshType = 0

function MagicBoxExtractionPreviewPage:SetUpRefresh()
  MagicBoxExtractionPreviewPage.super.SetUpRefresh(self)
end

function MagicBoxExtractionPreviewPage:SetTargetItem(data)
  self.itemdata = data
end

function MagicBoxExtractionPreviewPage:GetNowItemData()
  return self.itemdata
end

function MagicBoxExtractionPreviewPage:ChooseItem(itemdata)
end

function MagicBoxExtractionPreviewPage:UpdateCurrentCost(setRefresh)
  MagicBoxExtractionPreviewPage.super.UpdateCurrentCost(self, setRefresh)
  self.extractButton.isEnabled = false
  self.extractBtnLabel.effectStyle = UILabel.Effect.Outline
  self.extractBtnLabel.effectColor = grey
end

function MagicBoxExtractionPreviewPage:HandleUpdateCurrentCost()
end

local _isEquipClean

function MagicBoxExtractionPreviewPage:GetValidEquips()
end

function MagicBoxExtractionPreviewPage:CheckEquipValid(item)
  return false
end

function MagicBoxExtractionPreviewPage:UpdateView(note)
  if note and note.body then
    self:UpdateSlotList()
  end
  self:InitView()
end

function MagicBoxExtractionPreviewPage:UpdateSlotList()
  self.slotGridCtrl:ResetDatas(self.slotDatas)
end

function MagicBoxExtractionPreviewPage:OnEnter()
  MagicBoxExtractionPreviewPage.super.OnEnter(self)
end

function MagicBoxExtractionPreviewPage:OnExit()
  MagicBoxExtractionPreviewPage.super.OnExit(self)
end

function MagicBoxExtractionPreviewPage:CallExtract()
end

function MagicBoxExtractionPreviewPage:CallActive()
end

function MagicBoxExtractionPreviewPage:CallEmpty()
end

function MagicBoxExtractionPreviewPage:CallRefresh()
end

function MagicBoxExtractionPreviewPage:OperateResult(note)
end

function MagicBoxExtractionPreviewPage:CheckShare()
end

function MagicBoxExtractionPreviewPage:ActiveResult(note)
end

function MagicBoxExtractionPreviewPage:RemoveResult(note)
end

function MagicBoxExtractionPreviewPage:PurchaseResult(note)
end

function MagicBoxExtractionPreviewPage:RefreshResult(note)
end
