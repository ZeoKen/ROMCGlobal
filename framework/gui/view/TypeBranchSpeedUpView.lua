autoImport("JobBranchLineCell")
TypeBranchSpeedUpView = class("TypeBranchSpeedUpView", ContainerView)
local NormalTopCol = "75a0d1"
local NormalBottomCol = "1a67ab"
local SelectTopCol = "fb8f26"
local SelectBottomCol = "af6c30"
local NormalTexName = "bag_bg_bottom_05"
local SelectTexName = "bag_bg_bottom_04"

function TypeBranchSpeedUpView:Init()
  self.typeBranches = {}
  self:FindObjs()
  self:InitView()
end

function TypeBranchSpeedUpView:FindObjs()
  self:AddButtonEvent("CloseButton", function()
    self:CloseSelf()
  end)
  self.texBranch1 = self:FindComponent("TypeBranch1", UITexture)
  self.texBranch2 = self:FindComponent("TypeBranch2", UITexture)
  self:AddClickEvent(self.texBranch1.gameObject, function()
    self:OnBranchSelect(1)
  end)
  self:AddClickEvent(self.texBranch2.gameObject, function()
    self:OnBranchSelect(2)
  end)
  self.branchName1 = self:FindComponent("Name", UILabel, self.texBranch1.gameObject)
  self.branchName2 = self:FindComponent("Name", UILabel, self.texBranch2.gameObject)
  self.branchIcon1 = self:FindComponent("Icon", UISprite, self.texBranch1.gameObject)
  self.branchIcon2 = self:FindComponent("Icon", UISprite, self.texBranch2.gameObject)
  self.check1 = self:FindGO("Check", self.texBranch1.gameObject)
  self.check2 = self:FindGO("Check", self.texBranch2.gameObject)
  self.tipLabel = self:FindComponent("Tip", UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self:AddClickEvent(self.confirmBtn, function()
    ServiceItemProxy.Instance:CallItemUse(self.itemData, nil, 1, self.selectBranch)
    self:CloseSelf()
  end)
  self.confirmDisableBtn = self:FindGO("ConfirmBtnDisable")
  local jobTree = self:FindGO("JobTree")
  self.topJobNode = self:FindGO("TopJobNode")
  local jobTable = self:FindComponent("Table", UITable, jobTree)
  self.branchLineList = UIGridListCtrl.new(jobTable, JobBranchLineCell, "JobBranchLineCell")
end

function TypeBranchSpeedUpView:InitView()
  self.pro = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.pro
  self.itemData = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.item
  local config = Table_Class[self.pro]
  local typeBranchNameIdMap = GameConfig.NewClassEquip.typeBranchNameIdMap
  if config then
    local advanceClass = config.AdvanceClass
    if advanceClass then
      local datas = ReusableTable.CreateArray()
      for i = 1, #advanceClass do
        local classId = advanceClass[i]
        local sdata = Table_Class[classId]
        if sdata then
          self.typeBranches[i] = sdata.TypeBranch
          datas[#datas + 1] = classId
        end
      end
      for i = 1, #self.typeBranches do
        local branch = self.typeBranches[i]
        local classId = typeBranchNameIdMap[branch]
        if classId then
          local className = ProfessionProxy.GetProfessionName(classId, MyselfProxy.Instance:GetMySex())
          self["branchName" .. i].text = className .. ZhString.ItemTip_ProSeriesPrefix
          local sdata = Table_Class[classId]
          IconManager:SetNewProfessionIcon(sdata.icon, self["branchIcon" .. i])
        end
      end
      self.branchLineList:ResetDatas(datas)
      ReusableTable.DestroyArray(datas)
    end
    self.topJobProfessionIconCell = ProfessionIconCell.CreateNew(self.pro, self.topJobNode)
    self.topJobProfessionIconCell:SetShowType(3)
  end
  self.confirmBtn:SetActive(false)
  self.confirmDisableBtn:SetActive(true)
end

function TypeBranchSpeedUpView:OnEnter()
  PictureManager.Instance:SetSpeedUpTexture(NormalTexName, self.texBranch1)
  PictureManager.Instance:SetSpeedUpTexture(NormalTexName, self.texBranch2)
end

function TypeBranchSpeedUpView:OnExit()
  PictureManager.Instance:UnloadSpeedUpTexture(NormalTexName, self.texBranch1)
  PictureManager.Instance:UnloadSpeedUpTexture(NormalTexName, self.texBranch2)
  PictureManager.Instance:UnloadSpeedUpTexture(SelectTexName, self.texBranch1)
  PictureManager.Instance:UnloadSpeedUpTexture(SelectTexName, self.texBranch2)
end

function TypeBranchSpeedUpView:OnBranchSelect(index)
  PictureManager.Instance:SetSpeedUpTexture(SelectTexName, self["texBranch" .. index])
  PictureManager.Instance:SetSpeedUpTexture(NormalTexName, self["texBranch" .. 3 - index])
  self["check" .. index]:SetActive(true)
  self["check" .. 3 - index]:SetActive(false)
  self:SetBranchNameColor(index)
  self.confirmBtn:SetActive(true)
  self.confirmDisableBtn:SetActive(false)
  local baseLv = MyselfProxy.Instance:RoleLevel()
  local maxBaseLv = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL_MAX)
  local proName = MyselfProxy.Instance:GetMyProfessionName()
  local branchName = ""
  local typeBranchNameIdMap = GameConfig.NewClassEquip.typeBranchNameIdMap
  local typeBranch = self.typeBranches[index]
  self.selectBranch = typeBranch
  local classId = typeBranchNameIdMap[typeBranch]
  if classId then
    local className = ProfessionProxy.GetProfessionName(classId, MyselfProxy.Instance:GetMySex())
    branchName = className .. ZhString.ItemTip_ProSeriesPrefix
  end
  local tip
  local params = {}
  if baseLv < maxBaseLv then
    tip = ZhString.TypeBranchSpeedUp_Base
    params[1] = GameConfig.SpeedUp.base.buy_item_per .. "%"
    params[2] = MyselfProxy.Instance:IsItemBaseSpeedUpWorked() and ZhString.TypeBranchSpeedUP_Worked or ""
    params[3] = proName
    params[4] = branchName
    params[5] = GameConfig.SpeedUp.job.buy_item_per .. "%"
  else
    tip = ZhString.TypeBranchSpeedUp_BaseMax
    params[1] = proName
    params[2] = branchName
    params[3] = GameConfig.SpeedUp.job.buy_item_per .. "%"
  end
  self.tipLabel.text = string.format(tip, unpack(params))
  local cells = self.branchLineList:GetCells()
  for i = 1, #cells do
    local cell = cells[i]
    cell:SetBranchLineSelectState(i == index)
  end
end

function TypeBranchSpeedUpView:SetBranchNameColor(index)
  local _, c = ColorUtil.TryParseHexString(SelectTopCol)
  self["branchName" .. index].gradientTop = c
  _, c = ColorUtil.TryParseHexString(SelectBottomCol)
  self["branchName" .. index].gradientBottom = c
  _, c = ColorUtil.TryParseHexString(NormalTopCol)
  self["branchName" .. 3 - index].gradientTop = c
  _, c = ColorUtil.TryParseHexString(NormalBottomCol)
  self["branchName" .. 3 - index].gradientBottom = c
end
