UIToggleGroup = class("UIToggleGroup")
local disableAlpha = 0.2

function UIToggleGroup:ctor(root, toggleNames, defaultIndex, groupId)
  self:Init(root, toggleNames, defaultIndex, groupId)
end

function UIToggleGroup:Init(root, toggleNames, defaultIndex, groupId)
  self.toggles = {}
  for _, name in ipairs(toggleNames) do
    local toggleGO = Game.GameObjectUtil:DeepFind(root, name)
    if toggleGO then
      local toggle = toggleGO:GetComponent(UIToggle)
      if toggle then
        if groupId then
          toggle.group = groupId
        end
        local container = Game.GameObjectUtil:DeepFind(toggleGO, "Container")
        container = container and container:GetComponent(UIWidget)
        local collider = toggleGO:GetComponent(BoxCollider)
        table.insert(self.toggles, {
          container = container,
          collider = collider,
          toggle = toggle
        })
      end
    end
  end
  self:SelectToggle(defaultIndex or 1)
end

function UIToggleGroup:Destroy()
end

function UIToggleGroup:SelectToggle(index)
  if self.toggles then
    for i, v in ipairs(self.toggles) do
      v.toggle.value = i == index
    end
  end
end

function UIToggleGroup:GetSelectedToggleIndex()
  if self.toggles then
    for i, v in ipairs(self.toggles) do
      if v.toggle.value then
        return i
      end
    end
  end
end

function UIToggleGroup:SetEnabled(b)
  if not self.toggles then
    return
  end
  local alpha = b and 1 or disableAlpha
  for _, v in ipairs(self.toggles) do
    if v.container then
      v.container.alpha = alpha
    end
    if v.collider then
      v.collider.enabled = b
    end
  end
end
