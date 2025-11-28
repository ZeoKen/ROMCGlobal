HomeFurniturOutLine = class("HomeFurniturOutLine", EventDispatcher)

function HomeFurniturOutLine.Me()
  if nil == HomeFurniturOutLine.me then
    HomeFurniturOutLine.me = HomeFurniturOutLine.new()
  end
  return HomeFurniturOutLine.me
end

function HomeFurniturOutLine:ctor()
  self:Init()
end

local RenderTextureWidth = 1024
local RenderTextureHeight = 1024
local OutLineStrength = 4.0
local OutLineSamplerArea = 2.0
local OutLineDefaultColor = LuaColor.White()

function HomeFurniturOutLine:Init()
  self.m_TargetObjects = {}
  self.m_Materials = {}
end

function HomeFurniturOutLine:StartRender(sceneCamera, bgCm, uibgCm)
end

function HomeFurniturOutLine:Release()
  PostprocessManager.Instance:ClearOutline()
end

local targetCache = {}

function HomeFurniturOutLine:AddTarget(objTarget, id, color)
  local renders = ReusableTable.CreateArray()
  local renderers = objTarget:GetComponentsInChildren(Renderer, true)
  local singleRenderer
  for i = 1, #renderers do
    singleRenderer = renderers[i]
    if AssetManager_Furniture.IsSceneObj(singleRenderer) then
      renders[#renders + 1] = renderers[i]
    end
  end
  PostprocessManager.Instance:SetOutline(id, color or OutLineDefaultColor, renders)
  ReusableTable.DestroyAndClearArray(renders)
end

function HomeFurniturOutLine:RemoveTarget(id)
  PostprocessManager.Instance:UnSetOutline(id)
end
