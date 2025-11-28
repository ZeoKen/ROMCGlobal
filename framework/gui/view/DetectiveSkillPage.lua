DetectiveSkillPage = class("DetectiveSkillPage", SubView)
DetectiveSkillPage.ViewType = UIViewType.NormalLayer
autoImport("DetectiveSkillCell")
local viewPath = ResourcePathHelper.UIView("DetectiveSkillPage")
local tempScale = LuaVector3.One()
local decorateTextureNameMap = {
  Decorate21 = "Sevenroyalfamilies_bg_decoration21"
}
local decorateCommonMap = {
  DecorateBG4 = "calendar_bg1_picture2"
}
local picIns = PictureManager.Instance

function DetectiveSkillPage:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddMapEvts()
  self:InitDatas()
  self:InitShow()
end

function DetectiveSkillPage:LoadSubView()
  local obj = self:LoadPreferb_ByFullPath(viewPath, self.container.skillPageObj, true)
  obj.name = "DetectiveSkillPage"
end

function DetectiveSkillPage:FindObjs()
  self:LoadSubView()
  self.gameObject = self:FindGO("DetectiveSkillPage")
  self.skillMainPart = self:FindGO("SkillMainPart")
  self.pointIcon = self:FindGO("PointIcon"):GetComponent(UISprite)
  self.pointLabel = self:FindGO("PointLabel"):GetComponent(UILabel)
  self.skillGrid = self:FindGO("SkillGrid"):GetComponent(UIGrid)
  self.skillGridCtrl = UIGridListCtrl.new(self.skillGrid, DetectiveSkillCell, "DetectiveSkillCell")
  self.skillGridCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickSkill, self)
  self.skillUpgradePart = self:FindGO("SkillUpgradePart")
  self.skillIcon = self:FindGO("SkillIcon"):GetComponent(UISprite)
  self.skillName = self:FindGO("SkillName"):GetComponent(UILabel)
  self.skillLock = self:FindGO("SkillLock")
  self.lockStatus = self:FindGO("LockStatus", self.skillUpgradePart)
  self.lockScrollView = self:FindGO("LockScrollView"):GetComponent(UIScrollView)
  self.lockDesc = self:FindGO("LockDesc"):GetComponent(UILabel)
  self.Level1Desc = self:FindGO("Level1Desc", self.lockStatus):GetComponent(UILabel)
  self.unlockStatus = self:FindGO("UnlockStatus", self.skillUpgradePart)
  self.unlockScrollView = self:FindGO("UnlockScrollView"):GetComponent(UIScrollView)
  self.unlockTable = self:FindGO("UnlockTable"):GetComponent(UITable)
  self.skillShortDesc = self:FindGO("SkillShortDesc"):GetComponent(UILabel)
  self.level1Icon = self:FindGO("Level1Icon"):GetComponent(UISprite)
  self.level1Label = self:FindGO("LabelLevel1"):GetComponent(UILabel)
  self.level2Icon = self:FindGO("Level2Icon"):GetComponent(UISprite)
  self.level2Label = self:FindGO("LabelLevel2"):GetComponent(UILabel)
  self.level3Icon = self:FindGO("Level3Icon"):GetComponent(UISprite)
  self.level3Label = self:FindGO("LabelLevel3"):GetComponent(UILabel)
  self.upgradeBtn = self:FindGO("UpgradeBtn")
  self.upgradeBtnLabel = self:FindGO("Label", self.upgradeBtn):GetComponent(UILabel)
  self.cost = self:FindGO("Cost", self.skillUpgradePart)
  self.costIcon = self:FindGO("CostIcon", self.cost):GetComponent(UISprite)
  self.costLabel = self:FindGO("CostLabel", self.cost):GetComponent(UILabel)
  self.lockLabel = self:FindGO("LockLabel"):GetComponent(UILabel)
  self.lockLabelGO = self.lockLabel.gameObject
  for objName, _ in pairs(decorateTextureNameMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  for objName, _ in pairs(decorateCommonMap) do
    self[objName] = self:FindComponent(objName, UITexture)
  end
  local itemid = 13600
  local itemConfig = Table_Item[itemid]
  IconManager:SetItemIcon(itemConfig and itemConfig.Icon, self.pointIcon)
  IconManager:SetItemIcon(itemConfig and itemConfig.Icon, self.costIcon)
end

function DetectiveSkillPage:AddEvts()
  self:AddClickEvent(self.upgradeBtn, function()
    xdlog("申请升级技能", self.curSkillCell.skillId)
    if not self.upgradeValid then
      MsgManager.ShowMsgByID(42070)
      return
    end
    ServiceSkillProxy.Instance:CallSkillPerceptAbilityLvUpCmd(self.curSkillCell.skillId, 1)
  end)
  local helpBtn = self:FindGO("HelpBtn", self.gameObject)
  self:RegistShowGeneralHelpByHelpID(35093, helpBtn)
end

function DetectiveSkillPage:AddMapEvts()
  xdlog("AddMapEvts")
  self:AddListenEvt(ServiceEvent.SkillSkillPerceptAbilityNtf, self.RefreshSkillPage)
  self:AddListenEvt(ServiceEvent.SkillSkillPerceptAbilityLvUpCmd, self.RefreshSkillPage)
  self:AddListenEvt(MyselfEvent.MyDataChange, self.UpdateMoney)
end

function DetectiveSkillPage:InitDatas()
  self.skillStaticDatas = SevenRoyalFamiliesProxy.Instance.skillStaticDatas
end

function DetectiveSkillPage:InitShow()
  self:RefreshSkillPage()
end

function DetectiveSkillPage:RefreshSkillPage()
  self.skillInfo = SevenRoyalFamiliesProxy.Instance.skillInfos
  local result = {}
  for k, v in pairs(self.skillStaticDatas) do
    local data = {}
    if self.skillInfo[k] then
      local level = self.skillInfo[k].lv
      data = {
        skillId = k,
        staticData = v,
        level = level,
        state = self.skillInfo[k].state
      }
    else
      data = {
        skillId = k,
        staticData = v,
        level = 0
      }
    end
    table.insert(result, data)
  end
  table.sort(result, function(l, r)
    return l.skillId < r.skillId
  end)
  if result and 0 < #result then
    self.skillGridCtrl:ResetDatas(result)
    if self.curSkillCell then
      self:HandleClickSkill(self.curSkillCell)
    else
      local cells = self.skillGridCtrl:GetCells()
      self:HandleClickSkill(cells[1])
    end
  end
  self:UpdateMoney()
end

function DetectiveSkillPage:UpdateMoney()
  local count = Game.Myself.data.userdata:Get(UDEnum.PERCEPT_ABILITY) or 0
  self.pointLabel.text = count
  if tonumber(self.pointLabel.text) < tonumber(self.costLabel.text) then
    xdlog("钱不够")
    self.upgradeValid = false
    self.costLabel.color = LuaColor.Red()
  else
    xdlog("钱管够")
    self.upgradeValid = true
    self.costLabel.color = LuaGeometry.GetTempVector4(0.2196078431372549, 0.2196078431372549, 0.2196078431372549, 1)
  end
end

function DetectiveSkillPage:HandleClickSkill(cellCtrl)
  if self.curSkillCell ~= cellCtrl then
    if self.curSkillCell then
      self.curSkillCell:SetChoose(false)
    end
    self.curSkillCell = cellCtrl
    self.curSkillCell:SetChoose(true)
  end
  local data = cellCtrl.data
  local staticData = cellCtrl.staticData
  local id = cellCtrl.skillId
  local level = cellCtrl.level or 0
  local lock = cellCtrl.lock or 0
  self.skillName.text = staticData.Name or "???"
  if not IconManager:SetUIIcon(staticData.Icon, self.skillIcon) then
    IconManager:SetSkillIcon(staticData.Icon, self.skillIcon)
  end
  self.skillIcon:SetMaskPath(UIMaskConfig.SkillMask)
  self.skillIcon.OpenMask = true
  self.skillIcon.OpenCompress = true
  self.skillShortDesc.text = staticData.FullDesc
  local config = self.skillStaticDatas[id]
  if level == 0 then
    self:SetTextureGrey(self.skillIcon)
    self.lockStatus:SetActive(true)
    self.unlockStatus:SetActive(false)
    self.upgradeBtn:SetActive(lock ~= 0)
    self.lockLabelGO:SetActive(lock == 0)
    self.cost:SetActive(lock ~= 0)
    self.skillLock:SetActive(lock == 0)
    self.lockLabel.text = staticData.LockDesc
    local zeroConfig = self.skillStaticDatas[id][1]
    self.lockDesc.text = zeroConfig and zeroConfig.FullDesc
    self.lockScrollView:ResetPosition()
    local level1Config = self.skillStaticDatas[id][1]
    self.Level1Desc.text = level1Config and level1Config.Desc
    self.costLabel.text = level1Config.Cost
  else
    self:SetTextureWhite(self.skillIcon)
    self.lockStatus:SetActive(false)
    self.unlockStatus:SetActive(true)
    self.skillLock:SetActive(false)
    for i = 1, 3 do
      if config[i] then
        self["level" .. i .. "Icon"].gameObject:SetActive(true)
        self["level" .. i .. "Label"].text = config[i].Desc
      else
        self["level" .. i .. "Icon"].gameObject:SetActive(false)
      end
      if level >= i then
        self["level" .. i .. "Icon"].spriteName = "Sevenroyalfamilies_bg_point1"
        self["level" .. i .. "Label"].color = LuaGeometry.GetTempColor(0.12156862745098039, 0.4549019607843137, 0.7490196078431373, 1)
      else
        self["level" .. i .. "Icon"].spriteName = "Sevenroyalfamilies_bg_point2"
        self["level" .. i .. "Label"].color = LuaGeometry.GetTempColor(0.4549019607843137, 0.4549019607843137, 0.43609022556390975, 1)
      end
    end
    if not config[level + 1] then
      self.upgradeBtn:SetActive(false)
      self.lockLabelGO:SetActive(true)
      self.cost:SetActive(false)
      self.lockLabel.text = ZhString.DetectiveSkillPage_LvMax
    else
      self.cost:SetActive(true)
      self.upgradeBtn:SetActive(true)
      self.lockLabelGO:SetActive(false)
    end
    self.unlockTable:Reposition()
    self.unlockScrollView:ResetPosition()
  end
  local count = Game.Myself.data.userdata:Get(UDEnum.PERCEPT_ABILITY) or 0
  local cost = config and config[level + 1] and config[level + 1].Cost or 0
  self.costLabel.text = cost
  self.upgradeValid = count >= cost
  if not self.upgradeValid then
    self.costLabel.color = LuaColor.Red()
  else
    self.costLabel.color = LuaGeometry.GetTempVector4(0.2196078431372549, 0.2196078431372549, 0.2196078431372549, 1)
  end
end

function DetectiveSkillPage:OnEnter()
  DetectiveSkillPage.super.OnEnter(self)
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:SetSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:SetUI(texName, self[objName])
  end
end

function DetectiveSkillPage:OnExit()
  for objName, texName in pairs(decorateTextureNameMap) do
    picIns:UnloadSevenRoyalFamiliesTexture(texName, self[objName])
  end
  for objName, texName in pairs(decorateCommonMap) do
    picIns:UnLoadUI(texName, self[objName])
  end
  DetectiveSkillPage.super.OnExit(self)
end
