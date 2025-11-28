autoImport("SelectFriendCell")
SkyWheelFriendCell = class("SkyWheelFriendCell", SelectFriendCell)

function SkyWheelFriendCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function SkyWheelFriendCell:FindObjs()
  SkyWheelFriendCell.super.FindObjs(self)
  self.selectBtn = self:FindGO("SelectBtn"):GetComponent(UISprite)
  self.selectLabel = self:FindGO("Label", self.selectBtn.gameObject):GetComponent(UILabel)
end

function SkyWheelFriendCell:AddButtonEvt()
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

function SkyWheelFriendCell:SetData(data)
  SkyWheelFriendCell.super.SetData(self, data)
  if data then
    if data.offlinetime == 0 then
      self.selectBtn.color = ColorUtil.NGUIWhite
      self.selectLabel.effectColor = ColorUtil.ButtonLabelBlue
    else
      self.selectBtn.color = ColorUtil.NGUIShaderGray
      self.selectLabel.effectColor = ColorUtil.NGUIGray
    end
  end
end
