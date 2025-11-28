AstralDestinyGraphPointCell = class("AstralDestinyGraphPointCell", BaseCell)

function AstralDestinyGraphPointCell:ctor(parent, prefabName)
  local go = self:LoadPrefab(parent, prefabName)
  AstralDestinyGraphPointCell.super.ctor(self, go)
end

function AstralDestinyGraphPointCell:LoadPrefab(parent, prefabName)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("AstralDestinyGraph/" .. prefabName))
  if not go then
    error("can not find cellpfb" .. prefabName)
  end
  go.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionGO(go, 0, 0, 0)
  return go
end

function AstralDestinyGraphPointCell:Init()
  self:FindObjs()
end

function AstralDestinyGraphPointCell:FindObjs()
  self:AddCellClickEvent()
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.selectGO = self:FindGO("Select")
  self.indexSp = self:FindComponent("Index", UISprite)
  self.lock = self:FindGO("Lock")
  self.effectContainer = self:FindGO("EffectContainer")
end

function AstralDestinyGraphPointCell:SetData(data)
  self.data = data
  if data then
    local prefix
    if data.state ~= MessCCmd_pb.EGRAPH_POINT_STATE_LIGHT then
      self.bg.CurrentState = 0
      prefix = "Greatsecret_star_dim_"
    else
      self.bg.CurrentState = 1
      prefix = "Greatsecret_star_"
    end
    local scale = data:GetScale()
    LuaGameObject.SetLocalScaleGO(self.bg.gameObject, scale, scale, scale)
    if data.index < 10 then
      self.indexSp.spriteName = prefix .. "0" .. data.index
    else
      self.indexSp.spriteName = prefix .. data.index
    end
    self.indexSp:MakePixelPerfect()
    self.lock:SetActive(data.state == MessCCmd_pb.EGRAPH_POINT_STATE_LOCKED)
  end
end

function AstralDestinyGraphPointCell:SetSelect(select)
  self.selectGO:SetActive(select)
end

function AstralDestinyGraphPointCell:PlayEffect()
  self:PlayUIEffect(EffectMap.UI.AstralGraphGet, self.effectContainer, true)
end
