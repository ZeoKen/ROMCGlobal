autoImport("FriendBaseCell")
local baseCell = autoImport("BaseCell")
AddFriendCell = class("AddFriendCell", FriendBaseCell)

function AddFriendCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function AddFriendCell:FindObjs()
  AddFriendCell.super.FindObjs(self)
  self.ID = self:FindGO("ID"):GetComponent(UILabel)
end

function AddFriendCell:AddButtonEvt()
  AddFriendCell.super.InitShow(self)
  local addFriendBtn = self:FindGO("AddFriendBtn")
  self:AddClickEvent(addFriendBtn, function(g)
    self:AddFriend(g)
  end)
end

function AddFriendCell:AddFriend()
  FunctionPlayerTip.CallAddFriend(self.data.guid, self.data.name)
end

function AddFriendCell:SetData(data)
  AddFriendCell.super.SetData(self, data)
  if data ~= nil then
    self.ID.text = "ID " .. data.guid
    if data.offlinetime == 0 then
      self.headIcon:SetActive(true, true)
    else
      self.headIcon:SetActive(false, true)
    end
    if self.zoneGO.activeSelf or self.serverGO.activeSelf then
      self.level.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(104, 12, 0)
    else
      self.level.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(104, -4, 0)
    end
  end
end
