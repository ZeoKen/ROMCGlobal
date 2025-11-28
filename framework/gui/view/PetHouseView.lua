autoImport("PetHousePetCell")
autoImport("PetHouseCell")
PetHouseView = class("PetHouseView", ContainerView)
PetHouseView.ViewType = UIViewType.NormalLayer
local FIXED_HOUSE_BG_TEX = "PetRoom_bg1"
local FIXED_HOUSE_TEX = "PetRoom_House"
local MODELPOS = {
  pos = {
    -0.3,
    0.1,
    0
  },
  rotation = {
    0,
    -125,
    0
  },
  scale = 0.3
}

function PetHouseView:Init()
  self.petHouseStaticData = GameConfig.Home.PetFurniture
  self.furniture = self.viewdata and self.viewdata.viewdata
  if self.furniture and self.furniture.staticID then
    self.houseID = self.furniture.staticID
    self.homeStaticData = Table_HomeFurniture[self.houseID]
  end
  self.pethouseData = HomeProxy.Instance:GetCurHouseData()
  if not self.pethouseData then
    self:CloseSelf()
    return
  end
  self.petEggs = self.pethouseData:GetAllPetEggs()
  self:FindObjs()
  self:AddUIEvts()
  self:MapListenEvt()
  self:InitUIView()
  self:InitFilter()
end

function PetHouseView:FindObjs()
  self.petHouseTexture = self:FindComponent("PetHouseTexture", UITexture)
  self.houseTexture = self:FindComponent("HouseTexture", UITexture)
  self.houseInfoLab = self:FindComponent("HouseInfoLab", UILabel)
  self.houseInfoLab.text = ZhString.PetHouseView_HouseInfoLab
  self.petInfoLab = self:FindComponent("PetInfoLab", UILabel)
  self.petInfoLab.text = ZhString.PetHouseView_PetInfoLab
  self.lvValue = self:FindComponent("LvValue", UILabel)
  self.friendlyValue = self:FindComponent("FriendlyValue", UILabel)
  self.petHouseName = self:FindComponent("HouseName", UILabel)
  self.container = self:FindGO("Content")
  self.petContainer = self:FindGO("PetContent")
  self.popupList = self:FindComponent("PopupList", UIPopupList)
  self.modelRoot = self:FindGO("ModelRoot")
  self.emptyPet = self:FindComponent("EmptyPet", UILabel)
  self.emptyPet.text = ZhString.PetHouseView_EmptyPet
end

function PetHouseView:AddUIEvts()
  EventDelegate.Add(self.popupList.onChange, function()
    if self.sortRule ~= self.popupList.data then
      self.sortRule = self.popupList.data
      self.curFilterValue = self.popupList.value
      self.petEggs = self.pethouseData:GetAllPetEggs()
      self:UpdataPets(true)
    end
  end)
end

local FILTER_CFG = {
  [1] = "按好感度排序",
  [2] = "按等级排序"
}

function PetHouseView:InitFilter()
  for i = 1, #FILTER_CFG do
    self.popupList:AddItem(FILTER_CFG[i], i)
  end
  self.popupList.value = FILTER_CFG[1]
end

function PetHouseView:MapListenEvt()
  self:AddListenEvt(ServiceEvent.HomeCmdHouseDataUpdateHomeCmd, self.RecvDataUpdata)
  self:AddListenEvt(ItemEvent.PetUpdate, self.HandlePetUpdate)
end

function PetHouseView:HandlePetUpdate()
  local feedingPets = self.pethouseData:GetFeedingPets()
  self.petEggs = self.pethouseData:GetAllPetEggs()
  for j = 1, #self.petEggs do
    local feedFlag = false
    for i = 1, #feedingPets do
      if feedingPets[i].guid == self.petEggs[j].guid then
        feedFlag = true
      end
    end
    self.petEggs[j].isEat = feedFlag and 1 or 0
  end
  self:UpdataPets(true)
end

function PetHouseView:RecvDataUpdata()
  self:UpdateHouseData()
  self:HandlePetUpdate()
end

function PetHouseView:InitUIView()
  self:SetInfo()
  if self.wrapHelper == nil then
    local wrapConfig = {
      wrapObj = self.container,
      pfbNum = 4,
      cellName = "PetHouseCell",
      control = PetHouseCell,
      dir = 2
    }
    self.wrapHelper = WrapCellHelper.new(wrapConfig)
  end
  if self.petItemCtrl == nil then
    local wrapConfig = {
      wrapObj = self.petContainer,
      pfbNum = 11,
      cellName = "PetHousePetCell",
      control = PetHousePetCell,
      dir = 2
    }
    self.petItemCtrl = WrapCellHelper.new(wrapConfig)
    self.petItemCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickPetCell, self)
  end
  self:UpdateHouseData()
end

local friendlvSrtFormat = "%s/%smin"

function PetHouseView:SetInfo()
  self.petHouseName.text = self.homeStaticData.NameZh
  self.lvValue.text = self.petHouseStaticData.ExtraExp .. "%"
  self.friendlyValue.text = string.format(friendlvSrtFormat, self.petHouseStaticData.ExtraFriendlyExp, math.modf(self.petHouseStaticData.Interval / 60))
end

function PetHouseView:UpdataPets(var)
  if var then
    table.sort(self.petEggs, function(l, r)
      if 1 == self.sortRule then
        if l.isEat == r.isEat then
          if l.friendlv == r.friendlv then
            return l.petid > r.petid
          else
            return l.friendlv < r.friendlv
          end
        else
          return l.isEat < r.isEat
        end
      elseif l.isEat == r.isEat then
        if l.lv == r.lv then
          return l.petid > r.petid
        else
          return l.lv < r.lv
        end
      else
        return l.isEat < r.isEat
      end
    end)
  end
  self.petItemCtrl:ResetDatas(self.petEggs, nil, var == true)
  self.emptyPet.gameObject:SetActive(#self.petEggs <= 0)
end

function PetHouseView:UpdateHouseData()
  if self.pethouseData then
    local data = self.pethouseData:GetPetHouse()
    self.wrapHelper:ResetDatas(data)
  end
end

function PetHouseView:OnClickPetCell(cellctl)
  local petGuid = cellctl and cellctl.data and cellctl.data.guid
  if petGuid then
    if cellctl.data.isEat == 1 then
      MsgManager.ShowMsgByID(38001)
      return
    end
    local result = self.pethouseData:FindPriorityPetPos()
    if nil == result then
      MsgManager.ShowMsgByID(38000)
      return
    end
    if 0 == result then
      MsgManager.ShowMsgByID(38013)
      return
    end
    ServiceHomeCmdProxy.Instance:CallPetFurnitureActionhomeCmd(HomeCmd_pb.EPETFURNITUREACTION_PETON, result, petGuid)
  end
end

function PetHouseView:InitModel()
  self.modelContainer = GameObject("ModelContainer")
  self.modelContainer.transform.parent = self.modelRoot.transform
  self.modelContainer.transform.localPosition = LuaGeometry.GetTempVector3()
  self.modelContainer.transform.localEulerAngles = LuaGeometry.GetTempVector3()
  self.modelContainer.layer = self.modelRoot.layer
end

local tempV3, tempRot = LuaVector3(), LuaQuaternion()

function PetHouseView:LoadHouse()
  Game.AssetManager_Furniture:CreatePetHouse(self.modelContainer.transform, function(obj)
    if obj then
      self.houseModel = obj
      self.houseModel.layer = self.modelContainer.layer
      local cfg = GameConfig.Home.PetHouseUIPos or MODELPOS
      LuaVector3.Better_Set(tempV3, cfg.pos[1], cfg.pos[2], cfg.pos[3])
      self.houseModel.transform.localPosition = tempV3
      LuaVector3.Better_Set(tempV3, cfg.rotation[1], cfg.rotation[2], cfg.rotation[3])
      LuaQuaternion.Better_SetEulerAngles(tempRot, tempV3)
      self.houseModel.transform.localRotation = tempRot
      LuaVector3.Better_Set(tempV3, cfg.scale, cfg.scale, cfg.scale)
      self.houseModel.transform.localScale = tempV3
    end
  end)
end

function PetHouseView:UnloadHouse()
  if self.houseModel then
    Game.AssetManager_Furniture:DestroyFurniture(self.houseModel)
    self.houseModel = nil
  end
end

function PetHouseView:OnEnter()
  ServiceHomeCmdProxy.Instance:CallPetFurnitureActionhomeCmd(HomeCmd_pb.EPETFURNITUREACTION_QUERYPETINFO, 0, self.pethouseData.id)
  PictureManager.Instance:SetUI(FIXED_HOUSE_BG_TEX, self.petHouseTexture)
  PictureManager.Instance:SetUI(FIXED_HOUSE_TEX, self.houseTexture)
  PetHouseView.super.OnEnter(self)
end

function PetHouseView:OnExit()
  self.wrapHelper:Destroy()
  self.petEggs = nil
  PictureManager.Instance:UnLoadUI(FIXED_HOUSE_BG_TEX, self.petHouseTexture)
  PictureManager.Instance:UnLoadUI(FIXED_HOUSE_TEX, self.houseTexture)
  PetHouseView.super.OnExit(self)
end
