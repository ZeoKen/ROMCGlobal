PlayerGuidTip = class("PlayerGuidTip", BaseTip)

function PlayerGuidTip:Init()
  self:FindObj()
end

function PlayerGuidTip:FindObj()
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.copyIDBtn = self:FindGO("CopyIDBtn")
  self.id = self:FindGO("ID"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  self:AddClickEvent(self.confirmBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.copyIDBtn, function()
    local result = ApplicationInfo.CopyToSystemClipboard(self.data.id)
    if result then
      MsgManager.ShowMsgByID(40200)
    end
  end)
end

function PlayerGuidTip:SetData(data)
  self.data = data
  local showID = data.id
  self.id.text = showID
  self.nameLabel.text = string.format(ZhString.PlayerTip_PlayerID, data.name)
end

function PlayerGuidTip:CloseSelf()
  if self.callback then
    self.callback(self.callbackParam)
  end
  TipsView.Me():HideCurrent()
end

function PlayerGuidTip:DestroySelf()
  if not Slua.IsNull(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end
