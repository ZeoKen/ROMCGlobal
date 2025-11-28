local BaseCell = autoImport("BaseCell")
PushableObjLimitCell = class("PushableObjLimitCell", BaseCell)
PushableObjLimitCell.PoolSize = 2
PushableObjLimitCell.ResID = "GUI/v1/prefab/cell/PushableObjLimitCell"

function PushableObjLimitCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function PushableObjLimitCell:FindObjs()
  self.txtPushLimit = self:FindComponent("txtPushLimit", Text)
end

function PushableObjLimitCell:AddEvts()
  local clickFunc = function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end
  UGUIEventListener.Get(self.gameObject).onClick = function(go)
    self:PlayUISound(AudioMap.UI.Click)
    self:CheckHandleClickEvent(nil, clickFunc, go)
  end
end

function PushableObjLimitCell:SetData(data)
end

function PushableObjLimitCell:SetPushLimitInfo(charID, pushLimit)
  self.charID = charID
  self.txtPushLimit.text = pushLimit
end
