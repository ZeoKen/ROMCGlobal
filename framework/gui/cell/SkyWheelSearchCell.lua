autoImport("AddFriendCell")
SkyWheelSearchCell = class("SkyWheelSearchCell", AddFriendCell)

function SkyWheelSearchCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function SkyWheelSearchCell:FindObjs()
  SkyWheelSearchCell.super.FindObjs(self)
  self.selectBtn = self:FindGO("SelectBtn"):GetComponent(UISprite)
  self.selectLabel = self:FindGO("Label", self.selectBtn.gameObject):GetComponent(UILabel)
end

function SkyWheelSearchCell:AddButtonEvt()
  self:SetEvent(self.selectBtn.gameObject, function()
    if self.data.offlinetime ~= 0 then
      MsgManager.ShowMsgByID(864)
      return
    end
    if self.data.serverid ~= MyselfProxy.Instance:GetServerId() then
      MsgManager.ShowMsgByID(3085)
      return
    end
    self:PassEvent(SkyWheel.Select, self)
  end)
end

function SkyWheelSearchCell:SetData(data)
  SkyWheelSearchCell.super.SetData(self, data)
end
