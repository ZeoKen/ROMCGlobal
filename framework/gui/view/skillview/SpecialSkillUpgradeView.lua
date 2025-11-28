autoImport("SpecialUpgradeSkillCell")
SpecialSkillUpgradeView = class("SpecialSkillUpgradeView", ContainerView)
local bgTexName = "knightskills_bg_bottom_01"

function SpecialSkillUpgradeView:Init()
  self:InitData()
  self:FindObjs()
  self:InitView()
  self:AddListener()
end

local sortFunc = function(l, r)
  local configl = Table_KnightSkill[l]
  local configr = Table_KnightSkill[r]
  return configl.SortID < configr.SortID
end

function SpecialSkillUpgradeView:InitData()
  self.mainSkillData = self.viewdata and self.viewdata.viewdata
  if not self.mainSkillData then
    return
  end
  self.subSkills = {}
  local config = Table_KnightSkill[self.mainSkillData:GetSortID()]
  if config then
    for id, v in pairs(Table_KnightSkill) do
      if v.category == config.category and v.Type == 2 then
        self.subSkills[#self.subSkills + 1] = id
      end
    end
    table.sort(self.subSkills, sortFunc)
  end
end

function SpecialSkillUpgradeView:FindObjs()
  self.bgTex = self:FindComponent("BgTex", UITexture)
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  TipsView.Me():TryShowGeneralHelpByHelpId(35283, self:FindGO("help"))
  self.myCostItemIcon = self:FindComponent("goldIcon", UISprite)
  self.myCostItemNumLabel = self:FindComponent("gold", UILabel)
  self:AddButtonEvent("PlusBtn", function()
    MsgManager.ShowMsgByID(43443)
  end)
  self.titleLabel = self:FindComponent("title", UILabel)
  self.mainSkillGO = self:FindGO("mainSkill")
  self:AddClickEvent(self.mainSkillGO, function()
    self:OnMainSkillClick()
  end)
  self.mainSkillIcon = self.mainSkillGO:GetComponent(UISprite)
  self.mainSkillSelect = self:FindGO("selected", self.mainSkillGO)
  local grid = self:FindComponent("Grid", UIGrid)
  self.subSkillListCtrl = UIGridListCtrl.new(grid, SpecialUpgradeSkillCell, "SpecialUpgradeSkillCell")
  self.subSkillListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnSkillCellClick, self)
  self.descPart = self:FindGO("descPart")
  self.nameLabel = self:FindComponent("name", UILabel, self.descPart)
  self.descLabel = self:FindComponent("desc", UILabel, self.descPart)
  self.upgradeDescPart = self:FindGO("upgradeDescPart")
  local curLevel = self:FindGO("curLevelBg")
  self.curLevelNameLabel = self:FindComponent("name", UILabel, curLevel)
  self.curLevelDescLabel = self:FindComponent("desc", UILabel, curLevel)
  local nextLevel = self:FindGO("nextLevelBg")
  self.nextLevelNameLabel = self:FindComponent("name", UILabel, nextLevel)
  self.nextLevelDescLabel = self:FindComponent("desc", UILabel, nextLevel)
  self.upgradePart = self:FindGO("upgradePart")
  self.costIcon = self:FindComponent("costIcon", UISprite)
  self.costLabel = self:FindComponent("cost", UILabel)
  self.upgradeBtn = self:FindGO("upgradeBtn")
  self:AddClickEvent(self.upgradeBtn, function()
    self:OnUpgradeBtnClick()
  end)
  self.upgradeBtnGrey = self:FindGO("upgradeBtnGrey")
  self:AddClickEvent(self.upgradeBtnGrey, function()
    MsgManager.ShowMsgByID(43444)
  end)
  self.maxLevelTip = self:FindGO("maxLevelTip")
  self.activeTipLabel = self:FindComponent("activeTip", UILabel)
end

function SpecialSkillUpgradeView:InitView()
  local staticData = self.mainSkillData.staticData
  local upgradeStaticData = Table_KnightSkill[self.mainSkillData:GetSortID()]
  IconManager:SetItemIconById(upgradeStaticData.LvUpItem, self.myCostItemIcon)
  self.titleLabel.text = staticData.NameZh
  IconManager:SetSkillIconByProfess(staticData.Icon, self.mainSkillIcon, 0)
  self:RefreshView()
end

function SpecialSkillUpgradeView:RefreshView()
  self:RefreshMyCostItem()
  self:RefreshSubSkills()
end

function SpecialSkillUpgradeView:AddListener()
  self:AddListenEvt(SkillEvent.SkillUpdate, self.HandleSkillUpdate)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.HandleItemUpdate)
end

function SpecialSkillUpgradeView:OnEnter()
  self:OnCameraEnter()
  PictureManager.Instance:SetSpecialSkillTexture(bgTexName, self.bgTex)
end

function SpecialSkillUpgradeView:OnExit()
  self:OnCameraExit()
  PictureManager.Instance:UnloadSpecialSkillTexture(bgTexName, self.bgTex)
end

function SpecialSkillUpgradeView:OnCameraEnter()
  local myTrans = Game.Myself.assetRole.completeTransform
  self:CameraFaceTo(myTrans, CameraConfig.HappyShop_ViewPort, CameraConfig.HappyShop_Rotation)
end

function SpecialSkillUpgradeView:OnCameraExit()
  self:CameraReset()
end

function SpecialSkillUpgradeView:RefreshMyCostItem()
  local myCostItemNum = Game.Myself.data.userdata:Get(UDEnum.NO_ENTER_PACK_ITEM) or 0
  self.myCostItemNumLabel.text = myCostItemNum
end

function SpecialSkillUpgradeView:RefreshSubSkills()
  local datas = ReusableTable.CreateArray()
  local professionSkill = SkillProxy.Instance:FindProfessSkill(ProfessionProxy.CommonClass)
  for i = 1, #self.subSkills do
    local id = self.subSkills[i]
    local skillData = professionSkill:FindSkillByFamilyId(id)
    if not skillData then
      id = id * 1000 + 1
      skillData = SkillItemData.new(id, nil, nil, ProfessionProxy.CommonClass)
      skillData:setLevel(0)
    end
    datas[i] = skillData
  end
  self.subSkillListCtrl:ResetDatas(datas)
  ReusableTable.DestroyArray(datas)
  local index = self.selectIndex or 1
  local cells = self.subSkillListCtrl:GetCells()
  self:OnSkillCellClick(cells[index])
end

function SpecialSkillUpgradeView:OnMainSkillClick()
  self.mainSkillSelect:SetActive(true)
  self.nameLabel.text = self.mainSkillData.staticData.NameZh
  self.descLabel.text = SkillProxy.GetDesc(self.mainSkillData.id)
  self.descPart:SetActive(true)
  self.upgradeDescPart:SetActive(false)
  self.upgradePart:SetActive(false)
  self.maxLevelTip:SetActive(true)
  self.activeTipLabel.gameObject:SetActive(false)
  local cells = self.subSkillListCtrl:GetCells()
  for i = 1, #cells do
    cells[i]:SetSelectState(false)
  end
  self.selectIndex = nil
end

function SpecialSkillUpgradeView:OnSkillCellClick(cell)
  self.selectIndex = cell.indexInList
  local curLevel = cell.data.level
  local maxLevel = cell.data.maxLevel
  self.mainSkillSelect:SetActive(false)
  self.descLabel.text = SkillProxy.GetDesc(cell.data.id)
  cell:SetSelectState(true)
  local cells = self.subSkillListCtrl:GetCells()
  for i = 1, #cells do
    if cells[i] ~= cell then
      cells[i]:SetSelectState(false)
    end
  end
  if cell:IsLocked() then
    self.descPart:SetActive(true)
    self.upgradeDescPart:SetActive(false)
    self.upgradePart:SetActive(false)
    self.maxLevelTip:SetActive(false)
    self.nameLabel.text = cell.data.staticData.NameZh .. curLevel + 1 .. "/" .. maxLevel
    self.activeTipLabel.gameObject:SetActive(true)
    self.activeTipLabel.text = cell:GetActiveDesc()
  elseif cell:IsMaxLevel() then
    self.descPart:SetActive(true)
    self.upgradeDescPart:SetActive(false)
    self.upgradePart:SetActive(false)
    self.maxLevelTip:SetActive(true)
    self.nameLabel.text = cell.data.staticData.NameZh .. curLevel .. "/" .. maxLevel
    self.activeTipLabel.gameObject:SetActive(false)
  else
    self.descPart:SetActive(false)
    self.upgradeDescPart:SetActive(true)
    self.upgradePart:SetActive(true)
    self.maxLevelTip:SetActive(false)
    self.activeTipLabel.gameObject:SetActive(false)
    self.curLevelNameLabel.text = cell.data.staticData.NameZh .. curLevel .. "/" .. maxLevel
    self.curLevelDescLabel.text = cell:GetCurSkillDesc()
    self.nextLevelNameLabel.text = cell.data.nextSkillData.NameZh .. curLevel + 1 .. "/" .. maxLevel
    self.nextLevelDescLabel.text = cell:GetNextSkillDesc()
    local costItem, cost = cell:GetUpgradeCostItem()
    IconManager:SetItemIconById(costItem, self.costIcon)
    self.costLabel.text = cost
    self:SetUpgradeBtnState()
  end
end

function SpecialSkillUpgradeView:SetUpgradeBtnState()
  local isCanUpgrade = self:IsCanUpgrade()
  self.upgradeBtn:SetActive(isCanUpgrade)
  self.upgradeBtnGrey:SetActive(not isCanUpgrade)
end

function SpecialSkillUpgradeView:OnUpgradeBtnClick()
  if self:IsCanUpgrade() then
    local cells = self.subSkillListCtrl:GetCells()
    local selectCell = cells[self.selectIndex]
    ServiceSkillProxy.Instance:CallLevelupSkill(SceneSkill_pb.ELEVELUPTYPE_KNIGHT, {
      selectCell.data:GetNextID()
    })
    Game.Myself:PlayEffect(nil, EffectMap.Maps.JobLevelUp, 2, nil, false, true)
  end
end

function SpecialSkillUpgradeView:IsCanUpgrade()
  if not self.selectIndex then
    return false
  end
  local cells = self.subSkillListCtrl:GetCells()
  local selectCell = cells[self.selectIndex]
  if selectCell:IsLocked() then
    return false
  end
  if selectCell:IsMaxLevel() then
    return false
  end
  local upgradeStaticData = Table_KnightSkill[selectCell.data:GetSortID()]
  local myCostItemNum = Game.Myself.data.userdata:Get(UDEnum.NO_ENTER_PACK_ITEM) or 0
  local cost = upgradeStaticData.LvUpCost[selectCell.data.level + 1]
  return myCostItemNum >= cost
end

function SpecialSkillUpgradeView:HandleSkillUpdate()
  self:RefreshView()
end

function SpecialSkillUpgradeView:HandleItemUpdate()
  self:RefreshView()
end
