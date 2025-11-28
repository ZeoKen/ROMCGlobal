autoImport("RoleEquipItemCell")
autoImport("MyselfEquipItemCell")
autoImport("UserEquipRecommendAttrCell")
EquipRecommendNewUserView = class("EquipRecommendNewUserView", ContainerView)
EquipRecommendNewUserView.ViewType = UIViewType.PopUpLayer
local _EquipCell_Prefab = "cell/RoleEquipItemCell"
local ProfessionBgName = "Novicecopy_bg_banner"
local DecalTexName = "calendar_bg1_picture2"
local ModelBgTexName = "Bg_EquipRecommend"

function EquipRecommendNewUserView:Init()
  self:InitData()
  self:FindObjs()
end

function EquipRecommendNewUserView:InitData()
  self.curUserIndex = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.userIndex or 1
  local branch = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.branch
  self.passUserInfos = DungeonProxy.Instance:GetPassUserInfos(branch)
  if not self.passUserInfos then
    self:CloseSelf()
  end
end

function EquipRecommendNewUserView:FindObjs()
  self:AddCloseButtonEvent()
  self.titleLabel = self:FindComponent("Title", UILabel)
  self.decalTex = self:FindComponent("Bg4", UITexture)
  self.professionBg = self:FindComponent("Profession", UITexture)
  self.professionIcon = self:FindComponent("icon", UISprite, self.professionBg.gameObject)
  self.professionName = self:FindComponent("name", UILabel, self.professionBg.gameObject)
  local equipGrid = self:FindComponent("PlayerEquipGrid", UIGrid)
  self.equipGrid = self:TransEquipGrid(equipGrid, 143.8)
  self.equipList = {}
  for i = 1, 14 do
    local go = self:LoadPreferb(_EquipCell_Prefab, self.equipGrid)
    go.name = "RoleEquipItemCell" .. i
    self.equipList[i] = RoleEquipItemCell.new(go, i)
    self.equipList[i]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
  end
  self:InitViceEquipSwitch()
  self.viceEquipList = {}
  local viceEquipGrid = self:FindComponent("ViceEquipGrid", UIGrid)
  self.viceEquipGrid = self:TransEquipGrid(viceEquipGrid, 143.8)
  for _, site in pairs(BagProxy.ViceFoldedEquipConfig) do
    local obj = self:LoadPreferb(_EquipCell_Prefab, self.viceEquipGrid)
    obj.name = "ViewRoleEquipItemCell" .. site
    self.viceEquipList[site] = MyselfEquipItemCell.new(obj, site, nil, true, true)
    self.viceEquipList[site]:AddEventListener(MouseEvent.MouseClick, self.ClickEquip, self)
  end
  self.roleTex = self:FindComponent("RoleTexture", UITexture)
  local attrGrid = self:FindComponent("AttrGrid", UIGrid)
  self.attrListCtrl = UIGridListCtrl.new(attrGrid, UserEquipRecommendAttrCell, "UserEquipRecommendAttrCell")
  self.previousBtn = self:FindGO("PreviousBtn")
  self:AddClickEvent(self.previousBtn, function()
    self.curUserIndex = self.curUserIndex - 1 == 0 and #self.passUserInfos or self.curUserIndex - 1
    self:RefreshView()
  end)
  self.nextBtn = self:FindGO("NextBtn")
  self:AddClickEvent(self.nextBtn, function()
    self.curUserIndex = self.curUserIndex + 1 > #self.passUserInfos and 1 or self.curUserIndex + 1
    self:RefreshView()
  end)
  self:OnEquipTabChange()
end

function EquipRecommendNewUserView:InitViceEquipSwitch()
  self.switchRoot = self:FindGO("ViceEquipSwitch")
  self:AddClickEvent(self.switchRoot, function()
    self.isViceEquip = not self.isViceEquip
    self:OnEquipTabChange()
  end)
  self.tog1 = self:FindGO("Tog1", self.switchRoot)
  self.tog1Unselected = self:FindGO("Tog1 (1)")
  self.tog2 = self:FindGO("Tog2", self.switchRoot)
  self.tog2Unselected = self:FindGO("Tog2 (1)")
end

function EquipRecommendNewUserView:TransEquipGrid(grid, width)
  local equipGrid = {}
  equipGrid.grid = grid
  equipGrid.transform = grid.transform
  equipGrid.gameObject = grid.gameObject
  
  function equipGrid.Reposition(equipGrid_self)
    equipGrid_self.grid:Reposition()
    equipGrid_self.grid.enabled = false
    local childCount = equipGrid_self.transform.childCount
    if childCount == 13 then
      local cell13 = equipGrid_self.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(216, -488)
      end
    elseif childCount == 14 then
      local cell13 = equipGrid_self.transform:GetChild(12)
      if cell13 then
        cell13.transform.localPosition = LuaGeometry.GetTempVector3(width, -488)
      end
      local cell14 = equipGrid_self.transform:GetChild(13)
      if cell14 then
        cell14.transform.localPosition = LuaGeometry.GetTempVector3(width * 2, -488)
      end
    end
  end
  
  return equipGrid
end

function EquipRecommendNewUserView:OnEnter()
  PictureManager.Instance:SetEquipRecommendTexture(ProfessionBgName, self.professionBg)
  PictureManager.Instance:SetUI(DecalTexName, self.decalTex)
  self:RefreshView()
end

function EquipRecommendNewUserView:OnExit()
  PictureManager.Instance:UnloadEquipRecommendTexture(ProfessionBgName, self.professionBg)
  PictureManager.Instance:UnLoadUI(DecalTexName, self.decalTex)
end

function EquipRecommendNewUserView:RefreshView()
  self:SetProfessionInfo()
  self:SetEquips()
  self:TrySetPlayerModelTex()
  self:SetRoleAttrs()
end

function EquipRecommendNewUserView:SetProfessionInfo()
  local passUserData = self.passUserInfos[self.curUserIndex]
  local profession = passUserData:GetProfession()
  local config = Table_Class[profession]
  if config then
    IconManager:SetNewProfessionIcon(config.icon, self.professionIcon)
    self.professionName.text = config.NameZh
  end
  local source = passUserData:GetSource()
  local mapInfo = Table_Map[source]
  if mapInfo then
    self.titleLabel.text = string.format(ZhString.EquipRecommend_PassUserSource, mapInfo.CallZh)
  end
end

function EquipRecommendNewUserView:ClickEquip(cell)
  if not cell.data then
    return
  end
  local offsetX
  if cell.index <= 6 or cell.index == 13 then
    offsetX = 190
  elseif cell.index > 6 then
    offsetX = -190
  end
  local sdata = {
    itemdata = cell.data,
    ignoreBounds = {
      cell.gameObject
    },
    equipBuffUpSource = self.passUserInfos[self.curUserIndex] and self.passUserInfos[self.curUserIndex].id
  }
  self:ShowItemTip(sdata, cell.icon, NGUIUtil.AnchorSide.Left, {offsetX, 0})
end

function EquipRecommendNewUserView:OnEquipTabChange()
  if self.isViceEquip then
    self:Show(self.viceEquipGrid)
    self.viceEquipGrid:Reposition()
    self:Hide(self.equipGrid)
    self:Hide(self.tog1)
    self:Hide(self.tog2Unselected)
    self:Show(self.tog2)
    self:Show(self.tog1Unselected)
  else
    self:Show(self.equipGrid)
    self:Hide(self.viceEquipGrid)
    self.equipGrid:Reposition()
    self:Show(self.tog1)
    self:Hide(self.tog1Unselected)
    self:Hide(self.tog2)
    self:Show(self.tog2Unselected)
  end
end

local _Extra_Off = 101
local _Extra_Def = 102

function EquipRecommendNewUserView:SetEquips()
  local passUserData = self.passUserInfos[self.curUserIndex]
  local equips = passUserData and passUserData:GetEquips()
  for i = 1, #self.equipList do
    local equipCell = self.equipList[i]
    equipCell:SetData(equips[i])
  end
  local shadows = passUserData and passUserData:GetShadows()
  local extractions = passUserData and passUserData:GetExtractions()
  for site, cell in pairs(self.viceEquipList) do
    if site <= 6 then
      cell:SetData(shadows[site])
    elseif BagProxy.ActifactSite[site] then
      cell:SetData(equips[site])
    elseif site == _Extra_Off or site == _Extra_Def then
      cell:SetData(extractions[site])
    end
  end
end

function EquipRecommendNewUserView:TrySetPlayerModelTex()
  local passUserData = self.passUserInfos[self.curUserIndex]
  if passUserData then
    local parts = Asset_Role.CreatePartArray()
    local profession = passUserData:GetProfession()
    local staticData = Table_Class[profession]
    local sex = MyselfProxy.Instance:GetMySex()
    local myUserData = Game.Myself.data.userdata
    local partIndex = Asset_Role.PartIndex
    local partIndexEx = Asset_Role.PartIndexEx
    local classBody = sex == ProtoCommon_pb.EGENDER_MALE and staticData.MaleBody or staticData.FemaleBody
    parts[partIndex.Body] = classBody
    local self_race = ProfessionProxy.GetRaceByProfession(myUserData:Get(UDEnum.PROFESSION))
    local classRace = ProfessionProxy.GetRaceByProfession(profession)
    if self_race ~= classRace then
      local hair = ProfessionProxy.Instance:GetProfessionRaceFaceInfo(classRace)
      parts[partIndex.Hair] = hair
    else
      parts[partIndex.Hair] = myUserData:Get(UDEnum.HAIR)
    end
    local eye = sex == ProtoCommon_pb.EGENDER_MALE and staticData.MaleEye or staticData.FemaleEye
    if eye then
      parts[partIndex.Eye] = eye
    end
    if ProfessionProxy.IsHero(profession) and staticData.Head then
      parts[partIndex.Head] = staticData.Head
    end
    local weapon = staticData.DefaultWeapon
    parts[partIndex.RightWeapon] = weapon or 0
    parts[partIndexEx.Gender] = sex
    parts[partIndexEx.HairColorIndex] = myUserData:Get(UDEnum.HAIRCOLOR) or 0
    parts[partIndexEx.EyeColorIndex] = myUserData:Get(UDEnum.EYECOLOR) or 0
    UIModelUtil.Instance:SetRoleModelTexture(self.roleTex, parts, UIModelCameraTrans.EquipRecommendNew, nil, nil, nil, nil, nil, nil, nil, true)
    UIModelUtil.Instance:ChangeBGMeshRenderer(ModelBgTexName, self.roleTex)
    UIModelUtil.Instance:SetCellCameraBgColor(self.roleTex, ColorUtil.NGUIWhite)
    Asset_Role.DestroyPartArray(parts)
  end
end

function EquipRecommendNewUserView:SetRoleAttrs()
  local passUserData = self.passUserInfos[self.curUserIndex]
  local playerData = passUserData and passUserData.playerData
  if playerData then
    local props = playerData.props
    local attrs = GameConfig.PassUserInfo.show_attr
    if attrs then
      local datas = {}
      for i = 1, #attrs do
        local name = attrs[i]
        local value = 0
        local prop = props:GetPropByName(name)
        local per = props:GetPropByName(name .. "Per")
        per = per and per:GetValue() or 0
        if CommonFun.checkIsNoNeedPercent(name) then
          value = prop:GetValue()
        else
          value = prop:GetValue() * (1 + per)
        end
        datas[#datas + 1] = {prop = prop, value = value}
      end
      self.attrListCtrl:ResetDatas(datas)
    end
  end
end
