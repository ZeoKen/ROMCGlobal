GOManager_Furniture = class("GOManager_Furniture")

function GOManager_Furniture:ctor()
end

function GOManager_Furniture:RegisterGameObject(obj)
  return true
end

function GOManager_Furniture:UnregisterGameObject(obj)
  return true
end

function GOManager_Furniture:OnClick(objScript)
  HomeManager.Me():ClickFurniture(objScript.name)
end
