local BaseCell = autoImport("BaseCell")
InteractMountKickBtnCell = class("InteractMountKickBtnCell", BaseCell)
InteractMountKickBtnCell.PoolSize = 10
InteractMountKickBtnCell.ResID = "GUI/v1/prefab/cell/InteractMountKickBtnCell"

function InteractMountKickBtnCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function InteractMountKickBtnCell:FindObjs()
end

function InteractMountKickBtnCell:AddEvts()
  local clickFunc = function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end
  UGUIEventListener.Get(self.gameObject).onClick = function(go)
    self:PlayUISound(AudioMap.UI.Click)
    self:CheckHandleClickEvent(nil, clickFunc, go)
  end
end

function InteractMountKickBtnCell:SetData(data)
end

function InteractMountKickBtnCell:SetMountInfo(cpID, charID)
  self.cpID = cpID
  self.charID = charID
end
