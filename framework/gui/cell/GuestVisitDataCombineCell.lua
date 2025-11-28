autoImport("BaseCell")
GuestVisitDataCombineCell = class("GuestVisitDataCombineCell", BaseCell)
local GuestEvent = {
  [1] = ZhString.MessageBoardView_TraceEvent1,
  [2] = ZhString.MessageBoardView_TraceEvent2,
  [3] = ZhString.MessageBoardView_TraceEvent3,
  [4] = ZhString.MessageBoardView_TraceEvent4
}

function GuestVisitDataCombineCell:Init()
  self.isActive = true
  self.isTag = true
  self:FindObjs()
  self:AddEvents()
end

function GuestVisitDataCombineCell:FindObjs()
  self.objTag = self:FindGO("Tag")
  self.objBtnSwitchFold = self:FindGO("BtnFoldTag", self.objTag)
  self.sprBtnSwitchFold = self.objBtnSwitchFold:GetComponent(UISprite)
  self.visitDate = self:FindComponent("VisitDate", UILabel, self.objTag)
  self.objCellsRoot = self:FindGO("GuestVisitInfo")
  self.visitTime = self:FindGO("VisitTime"):GetComponent(UILabel)
  self.visitInfo = self:FindGO("VisitInfo"):GetComponent(UILabel)
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.5)
  self.headIcon:SetMinDepth(2)
  self.serverGO = self:FindGO("Server")
  self.serverLabel = self.serverGO:GetComponent(UILabel)
end

function GuestVisitDataCombineCell:AddEvents()
  self:AddClickEvent(self.objBtnSwitchFold, function()
    self:OnClickBtnSwitchFold()
  end)
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(MessageBoardTracePage.SelectHead, self)
  end)
end

function GuestVisitDataCombineCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  if self.isTag ~= data.isTag then
    self.isTag = data.isTag
    self.objCellsRoot:SetActive(not data.isTag)
    self.objTag:SetActive(data.isTag == true)
  end
  if data.isTag then
    self.id = data.id
    self.sprBtnSwitchFold.spriteName = data.isTagOpen and "com_btn_cuts" or "com_btn_add"
    self.sprBtnSwitchFold:MakePixelPerfect()
    self.visitDate.text = data.time or ""
  else
    self:SetGuestData(data)
  end
end

function GuestVisitDataCombineCell:SetGuestData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if haveData then
    self.headData = HeadImageData.new()
    self.headData:TransByGuestVisitData(data.user)
    self.headIcon:SetData(self.headData.iconData)
    local tempTime = os.date("%H:%M", data.time)
    self.visitTime.text = tempTime
    local user = data.user
    local eventid = data.eventid or 1
    local furnitureID
    if data.furnid == 0 then
      furnitureID = 30000
    else
      furnitureID = data.furnid
    end
    local tempStr = string.format(Table_VisitorLogs[eventid].Event, data.user.name, Table_HomeFurniture[furnitureID].NameZh)
    self.visitInfo.text = tempStr
    if user.serverid and user.serverid ~= 0 and user.serverid ~= MyselfProxy.Instance:GetServerId() then
      self.serverGO:SetActive(true)
      self.serverLabel.text = user.serverid
    else
      self.serverGO:SetActive(false)
    end
  end
end

function GuestVisitDataCombineCell:OnClickBtnSwitchFold()
  if self.isTag then
    self:PassEvent(WrapTagListCtrl.ClickFoldTag, self.data)
  end
end
