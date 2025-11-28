local baseCell = autoImport("BaseCell")
DMTabCell = class("DMCell", baseCell)

function DMTabCell:Init()
  self:FindObjs()
end

function DMTabCell:FindObjs()
  self.lable = self:FindGO("Label"):GetComponent("UILabel")
  local longPress = self.lable.gameObject:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(TipLongPressEvent.DMTabCell, {state})
  end
  
  self:AddEventListener(TipLongPressEvent.DMTabCell, self.HandleLongPress, self)
end

function DMTabCell:SetData(data)
  if data then
    self.data = data
    self.lable.text = data.desc
    if data.width then
      self.lable.width = data.width
    end
    if data.height then
      self.lable.height = data.height
    end
  end
end

function DMTabCell:HandleLongPress(param)
  local isPressing = param[1]
  if not self.data then
    return
  end
  if isPressing then
    local prefab = self.data.prefabName or "TabNameTipVertical"
    TipManager.Instance:TryShowAllDirComodoBuildingSendNameTip(self.data.tabName, self.lable, self.data.side, self.data.offset, prefab)
  else
    TipManager.Instance:CloseTabNameTipWithFadeOut()
  end
end
