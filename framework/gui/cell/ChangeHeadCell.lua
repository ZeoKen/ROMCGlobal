autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
ChangeHeadCell = class("ChangeHeadCell", baseCell)
local HeadCellType = ChangeHeadData.HeadCellType
local OffIcon = "pet_equip_off"

function ChangeHeadCell:Init()
  self:InitCell()
  self:AddEvts()
end

function ChangeHeadCell:InitCell()
  self.headIcon = self:FindGO("HeadIcon"):GetComponent(UISprite)
  self.choose = self:FindGO("Choose")
  self.newtag = self:FindGO("NewTag")
  self.newtag:SetActive(false)
  self.limitTimeFlag = self:FindGO("FlagSp")
end

function ChangeHeadCell:AddEvts()
  self:SetEvent(self.gameObject, function()
    self:PassEvent(ChangeHeadEvent.Select, self)
  end)
end

function ChangeHeadCell:SetData(data)
  self.data = data
  if data then
    self.type = data.type
    local iconstr = ""
    local staticData, ERedSys
    local isNew = false
    if data.id == 0 then
      IconManager:SetUIIcon(OffIcon, self.headIcon)
    else
      if self.type == HeadCellType.Avatar then
        staticData = Table_HeadImage[data.id]
        iconstr = staticData and staticData.Picture
        IconManager:SetFaceIcon(iconstr, self.headIcon)
        ERedSys = SceneTip_pb.EREDSYS_MONSTER_IMG
      elseif self.type == HeadCellType.Portrait then
        staticData = Table_UserPortraitFrame[data.id]
        iconstr = staticData and Table_Item[staticData.ItemID].Icon
        IconManager:SetItemIcon(iconstr, self.headIcon)
        ERedSys = SceneTip_pb.EREDSYS_PORTRAIT_FRAME
      elseif self.type == HeadCellType.Frame then
        staticData = Table_UserBackground[data.id]
        iconstr = staticData and Table_Item[staticData.ItemID].Icon
        IconManager:SetItemIcon(iconstr, self.headIcon)
        ERedSys = SceneTip_pb.EREDSYS_BACKGROUND_FRAME
      elseif self.type == HeadCellType.ChatFrame then
        staticData = Table_UserChatFrame[data.id]
        iconstr = staticData and Table_Item[staticData.ItemID].Icon
        IconManager:SetItemIcon(iconstr, self.headIcon)
      end
      if ERedSys then
        isNew = RedTipProxy.Instance:IsNew(ERedSys, data.id)
      end
    end
    self.newtag:SetActive(isNew)
    if data and data.id == 0 or staticData then
      self.choose:SetActive(data.isChoose)
    else
      self.gameObject:SetActive(false)
    end
    self.limitTimeFlag:SetActive(data.endTime and 0 < data.endTime or false)
  end
end

function ChangeHeadCell:SetChoose(isChoose)
  self.choose:SetActive(isChoose)
end

function ChangeHeadCell:RegisterRedTip(key)
  RedTipProxy.Instance:RegisterUI(key, self.Bg, 10, {-2, -6})
end
