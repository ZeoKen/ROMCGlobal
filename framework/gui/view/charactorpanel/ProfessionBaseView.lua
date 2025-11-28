ProfessionBaseView = class("ProfessionBaseView", SubMediatorView)
autoImport("ProfessionInfoPanelCell")
local tempVector3 = LuaVector3.Zero()
local tempTable = {}

function ProfessionBaseView:Init()
  self:initView()
  self:initData()
  self:AddCloseButtonEvent()
end

function ProfessionBaseView:initData()
  self.currentPfn = nil
  local userData = Game.Myself.data.userdata
  TableUtility.TableClear(tempTable)
  tempTable.sex = userData:Get(UDEnum.SEX)
  tempTable.hair = userData:Get(UDEnum.HAIR)
  tempTable.eye = userData:Get(UDEnum.EYE)
  tempTable.eyeColorIndex = userData:Get(UDEnum.EYECOLOR)
  tempTable.hairColorIndex = userData:Get(UDEnum.HAIRCOLOR)
  self:ResetData(tempTable)
end

function ProfessionBaseView:initSelfObj()
end

function ProfessionBaseView:initView()
  self:initSelfObj()
  local panel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    uipanels[i].depth = uipanels[i].depth + panel.depth
  end
  LuaVector3.Better_Set(tempVector3, 0, 0, 0)
  self.gameObject.transform.localPosition = tempVector3
  self.professionIcon = self:FindComponent("professionIcon", UISprite)
  self.professionSpc = self:FindComponent("professionSpc", UILabel)
  self.propGridView = self:FindComponent("propGrid", UIGrid)
  self.propGrid = UIGridListCtrl.new(self.propGridView, ProfessionInfoPanelCell, "ProfessionInfoPanelCell")
  local propDes = self:FindComponent("propDes", UILabel)
  local str = ZhString.ProfessionInfoPanel_PropDes
  if propDes then
    propDes.text = str
  end
  self.professionName = self:FindComponent("profLabel", UILabel)
  self.professionNameEn = self:FindComponent("profLabelEng", UILabel)
  if BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    self.professionName.gameObject:SetActive(false)
  end
  self.professionBg = self:FindComponent("profFlagBg", UISprite)
  self.profBg = self:FindComponent("profBg", UISprite)
  local playerModelContainer = self:FindGO("PlayerModelContainer")
  self.PlayerModel = self:FindComponent("PlayerModel", UITexture)
  if playerModelContainer then
    self:AddDragEvent(playerModelContainer, function(obj, delta)
      self:RotateRoleEvt(obj, delta)
    end)
  end
  if self:FindGO("ScrollView") then
    self.scrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
  end
end

function ProfessionBaseView:RotateRoleEvt(go, delta)
  if self.model then
    self.model:RotateDelta(-delta.x)
  end
end

function ProfessionBaseView:showRoleModel(agentData)
  if agentData == nil then
    agentData = {
      hair = self.hair,
      body = self.sex == 1 and self.currentPfn.MaleBody or self.currentPfn.FemaleBody,
      sex = self.sex,
      eye = self.eye,
      weapon = self.currentPfn.DefaultWeapon
    }
  end
  local self_race = ProfessionProxy.GetRaceByProfession(Game.Myself.data.userdata:Get(UDEnum.PROFESSION))
  local race = ProfessionProxy.GetRaceByProfession(self.currentPfn.id)
  if self_race ~= race then
    local raceSelfHair, raceSelfEye = ProfessionProxy.Instance:GetProfessionRaceFaceInfo(race)
    if raceSelfHair then
      agentData.hair = raceSelfHair
    end
    if raceSelfEye then
      agentData.eye = raceSelfEye
    end
  end
  local parts = Asset_Role.CreatePartArray()
  parts[Asset_Role.PartIndex.RightWeapon] = agentData.weapon or 0
  parts[Asset_Role.PartIndex.Body] = agentData.body or 0
  parts[Asset_Role.PartIndex.Hair] = agentData.hair or 0
  parts[Asset_Role.PartIndex.Eye] = agentData.eye or 0
  parts[Asset_Role.PartIndexEx.HairColorIndex] = agentData.hairColorIndex or Game.Myself.data.userdata:Get(UDEnum.HAIRCOLOR)
  parts[Asset_Role.PartIndexEx.EyeColorIndex] = agentData.eyeColorIndex or Game.Myself.data.userdata:Get(UDEnum.EYECOLOR)
  self.model = UIModelUtil.Instance:SetRoleModelTexture(self.PlayerModel, parts)
  if self.model then
    LuaVector3.Better_Set(tempVector3, -0.67, 0.09, 0)
    self.model:SetPosition(tempVector3)
    LuaVector3.Better_Set(tempVector3, -0.67, 13.62, 0)
    self.model:SetEulerAngleY(tempVector3)
  end
  Asset_Role.DestroyPartArray(parts)
end

function ProfessionBaseView:showInfo(data)
end

function ProfessionBaseView:AddCloseButtonEvent()
  local buttonobj = self:FindGO("CloseButton", self.parentObj)
  if buttonobj ~= nil then
    self:AddClickEvent(buttonobj, function(go)
      self:Hide(self.parentObj)
    end)
  end
end

local tempArray = {}

function ProfessionBaseView:ResetData(agentData)
  if self.currentPfn == nil then
    return
  end
  if self.currentPfn ~= nil then
    self.professionName.text = ProfessionProxy.GetProfessionName(self.currentPfn.id, MyselfProxy.Instance:GetMySex())
    self.professionNameEn.text = ProfessionProxy.GetProfessionNameEn(self.currentPfn.id, MyselfProxy.Instance:GetMySex())
    self.professionBg.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(string.format("CareerFlag%d", self.currentPfn.Type))
    self.profBg.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil(string.format("CareerFlag%d", self.currentPfn.Type))
    IconManager:SetProfessionIcon(self.currentPfn.icon, self.professionIcon)
    local job = self.currentPfn.TypeBranch
    local id = self.currentPfn.id
    local num = id - math.floor(id / 10) * 10
    local joblv = num * 40 + 10
    if 3 <= num then
      joblv = joblv + 30
    end
    local list = {}
    if self.currentPfn.Explain then
      for i = 1, #GameConfig.ClassInitialAttr do
        local single = GameConfig.ClassInitialAttr[i]
        local prop = Game.Myself.data.props:GetPropByName(single)
        local value = CommonFun.calProfessionPropValue(joblv, job, single)
        if 0 < value then
          local data = {}
          data.name = prop.propVO.displayName
          if BranchMgr.IsChina() or BranchMgr.IsTW() then
            data.name = data.name .. prop.propVO.name
          end
          data.value = value
          table.insert(list, data)
        end
      end
      self.propGrid:ResetDatas(list)
      local _, y = LuaGameObject.GetLocalPosition(self.propGridView.transform)
      local bound = NGUIMath.CalculateRelativeWidgetBounds(self.propGridView.transform, true)
      local height = bound.size.y
      local x, _, z = LuaGameObject.GetLocalPosition(self.professionSpc.transform)
      LuaVector3.Better_Set(tempVector3, x, y - height, z)
      self.professionSpc.text = string.format(ZhString.Charactor_ProfessionInfoSpc, self.currentPfn.Explain)
    end
    TableUtility.ArrayClear(tempArray)
    local skills = self.currentPfn.Skill
    if skills then
      for i = 1, #skills do
        local data = {}
        data[1] = self.currentPfn.id
        data[2] = skills[i]
        tempArray[#tempArray + 1] = data
      end
      self.gridList:ResetDatas(tempArray)
    end
    self.scrollView:ResetPosition()
  end
  self:showRoleModel(agentData)
end
