ProfessionChooseCell = class("ProfessionChooseCell", BaseCell)
local scaleRatio, scaleRatio2
local IconColor = {
  UnChoose = LuaColor.New(0.48627450980392156, 0.5294117647058824, 0.6, 1),
  Choose = LuaColor.White(0.48627450980392156, 0.5294117647058824, 0.6, 1)
}
local HaloColor = {
  UnChoose = LuaColor.New(0.3215686274509804, 0.4980392156862745, 0.596078431372549, 0),
  Choose = LuaColor.New(0.34509803921568627, 0.8352941176470589, 0.8549019607843137, 1),
  Invalid = LuaColor.New(0.14901960784313725, 0.2, 0.29411764705882354, 0)
}

function ProfessionChooseCell:ctor(obj)
  ProfessionChooseCell.super.ctor(self, obj)
  self:FindObjs()
  self:AddClickEvent(self.gameObject, function()
    if self.data == nil then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end, {hideClickSound = true})
end

function ProfessionChooseCell:FindObjs()
  self.sp = self:FindComponent("Icon", UISprite)
  self.choosen = self:FindGO("Choosen")
  self.haloBG = self:FindGO("Halo"):GetComponent(UISprite)
end

function ProfessionChooseCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(self.data ~= nil)
  self.type = self.data and self.data.Type
  local branchList = self.data and self.data.branchList
  if not branchList or #branchList == 0 then
    return
  end
  local branchId = branchList and branchList[1].branch
  if branchId == 0 then
    if branchList[1].id == ProfessionProxy.humanNovice or branchList[1].id == ProfessionProxy.doramNovice then
      IconManager:SetProfessionIcon(Table_Class[branchList[1].id].icon, self.sp)
      self.id = branchList[1].id
    end
  else
    local branchInfo = Table_Branch[branchId]
    self.id = branchInfo and branchInfo.base_id
    IconManager:SetProfessionIcon(Table_Class[self.id].icon, self.sp)
  end
  local isUnlock = false
  for i = 1, #branchList do
    if branchList[i].isUnlock then
      isUnlock = true
      break
    end
  end
  self.isUnlock = isUnlock
  self:UpdateChoose()
  local _RedTipProxy = RedTipProxy.Instance
  local ERedSys = SceneTip_pb.EREDSYS_PROFESSION_BRANCH
  local canUpgrade = false
  for i = 1, #branchList do
    local branchId = branchList[i].branch
    local classid = branchList[i].id
    if branchId == 0 then
      branchId = ProfessionProxy.NoviceC2S[classid]
    end
    local isNew = _RedTipProxy:IsNew(ERedSys, branchId)
    if isNew then
      canUpgrade = true
      break
    end
  end
  _RedTipProxy:UnRegisterUI(ERedSys, self.sp)
  if canUpgrade then
    _RedTipProxy:RegisterUI(ERedSys, self.sp, 10, {-10, -10})
  end
  _RedTipProxy:UnRegisterUI(SceneTip_pb.EREDSYS_HERO_GROWTH_QUEST, self.sp)
  if ProfessionProxy.IsHero(self.id) then
    _RedTipProxy:RegisterUI(SceneTip_pb.EREDSYS_HERO_GROWTH_QUEST, self.sp, self.sp.depth + 5, {-4, -6}, nil, self.id)
  end
end

function ProfessionChooseCell:SetChoose(type)
  self.chooseType = type
  self:UpdateChoose()
end

function ProfessionChooseCell:UpdateChoose()
  local choosen = self.type and self.chooseType == self.type
  if choosen then
    self.choosen:SetActive(true)
    ColorUtil.WhiteUIWidget(self.sp)
    self.sp.alpha = 1
    self.haloBG.color = HaloColor.Choose
    scaleRatio = 1
    scaleRatio2 = 1
  else
    local isUnlock = self.isUnlock or false
    self.choosen:SetActive(false)
    self.sp.alpha = isUnlock and 1 or 0.5
    self.haloBG.color = isUnlock and HaloColor.UnChoose or HaloColor.Invalid
    scaleRatio = isUnlock and 0.9 or 0.8
    scaleRatio2 = 0.9
  end
  LuaGameObject.SetLocalScaleGO(self.sp.gameObject, scaleRatio, scaleRatio, scaleRatio)
  LuaGameObject.SetLocalScaleGO(self.haloBG.gameObject, scaleRatio2, scaleRatio2, scaleRatio2)
end

function ProfessionChooseCell:SetState(state)
  self.stats = state
end

function ProfessionChooseCell:OnCellDestroy()
  local redtipProxy = RedTipProxy.Instance
  redtipProxy:UnRegisterUI(SceneTip_pb.EREDSYS_HERO_GROWTH_QUEST, self.sp)
  ProfessionChooseCell.super.OnCellDestroy(self)
end
