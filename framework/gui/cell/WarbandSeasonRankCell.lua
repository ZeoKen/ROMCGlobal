autoImport("WarbandHeadCell")
WarbandSeasonRankCell = class("WarbandSeasonRankCell", BaseCell)
local fixed_TexBg = "pvp_bg_10"
local fixed_combo_txt = "txt_combo_"

function WarbandSeasonRankCell:Init()
  self:FindObj()
end

function WarbandSeasonRankCell:FindObj()
  self.root = self:FindGO("Root")
  self.fixedTex = self:FindComponent("FixedTex", UITexture)
  PictureManager.Instance:SetPVP(fixed_TexBg, self.fixedTex)
  self:InitHead()
  self.seasonS = self:FindComponent("Season_S", UISprite)
  self.season1 = self:FindComponent("Season1", UISprite)
  self.season2 = self:FindComponent("Season2", UISprite)
end

function WarbandSeasonRankCell:InitHead()
  self.champtionHeadCell = {}
  for i = 1, 4 do
    local portraitRoot = self:FindGO("Portrait" .. i)
    local obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("WarbandHeadCell"))
    obj.transform:SetParent(portraitRoot.transform)
    obj.transform.localPosition = LuaGeometry.GetTempVector3()
    obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
    obj.transform.localRotation = LuaGeometry.GetTempQuaternion()
    self.champtionHeadCell[i] = WarbandHeadCell.new(obj)
    if nil ~= self.champtionHeadCell[i].headIcon.clickObj then
      self.champtionHeadCell[i].headIcon.clickObj.gameObject:AddComponent(UIDragScrollView)
    end
    self.champtionHeadCell[i]:AddEventListener(MouseEvent.MouseClick, self.OnClickHeadCell, self)
  end
end

function WarbandSeasonRankCell:OnClickHeadCell(ctl)
  local data = ctl and ctl.data
  if data then
    if self.proxy then
      self.proxy:DoQueryBand(data.season, data.id)
    else
      ServiceMatchCCmdProxy.Instance:CallTwelveWarbandQueryMatchCCmd(data.season, data.id)
    end
  end
end

function WarbandSeasonRankCell:GetDataByRank(rank)
  local result = rank == 3 and {} or nil
  for i = 1, #self.data do
    if self.data[i].rank == rank then
      if rank == 3 then
        result[#result + 1] = self.data[i]
      else
        return self.data[i]
      end
    end
  end
  return result
end

local tempVector3 = LuaVector3.Zero()

function WarbandSeasonRankCell:SetData(data)
  self.data = data
  if not data then
    self.root:SetActive(false)
    return
  end
  if "table" == type(data) and 1 <= #data then
    self.root:SetActive(true)
    for i = 1, 2 do
      self.champtionHeadCell[i]:SetData(self:GetDataByRank(i))
    end
    local rank3Array = self:GetDataByRank(3)
    self.champtionHeadCell[3]:SetData(rank3Array[1])
    self.champtionHeadCell[4]:SetData(rank3Array[2])
    local season = data[1].season
    if season < 10 then
      self.season1.spriteName = fixed_combo_txt .. season
      self.season2.gameObject:SetActive(false)
      LuaVector3.Better_Set(tempVector3, -331, 56, 0)
    else
      season = 10000 < season and season - 10000 or season
      self.season1.spriteName = fixed_combo_txt .. math.floor(season / 10)
      self.season2.spriteName = fixed_combo_txt .. season % 10
      self.season2.gameObject:SetActive(true)
      LuaVector3.Better_Set(tempVector3, -336, 56, 0)
    end
    self.seasonS.gameObject.transform.localPosition = tempVector3
  end
end
