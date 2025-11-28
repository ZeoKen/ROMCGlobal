local BaseCell = autoImport("BaseCell")
OricalCardDetailInfo = class("OricalCardDetailInfo", BaseCell)
local BG_Texture = "shenyu_ka_icon_bg"
local Frame2Bg_Texture = {
  "shenyu_ka_icon_mowu_bg",
  "shenyu_ka_icon_gongneng_bg"
}
local Frame_ColorMap = {"9595FA", "FBA4B7"}
local Lab_Effect_Color = {"5468CF", "F26789"}
local MonsterType = {
  "shenyu_ka_icon_mvp",
  "shenyu_ka_icon_mini"
}
local LoadingName = "card_loading"
local LoadFailed_CardName = "card_10001"

function OricalCardDetailInfo:Init()
  self.bg = self:FindComponent("Bg", UITexture)
  self.bg2 = self:FindComponent("Bg2", UITexture)
  self.frame = self:FindComponent("Frame", UISprite)
  self.frame2Bg = self:FindComponent("Frame2Bg", UITexture)
  self.desc = self:FindComponent("Desc", UILabel)
  self.instructions = self:FindComponent("Instructions", UILabel)
  self.icon = self:FindComponent("Icon", UITexture)
  self.loading = self:FindGO("Loading")
  self.monsterFlag = self:FindComponent("MonsterFlag", UISprite)
  self.nameLab = self:FindComponent("NameLab", UILabel)
  self.collider = self:FindGO("Collider")
  if self.collider then
    self:AddClickEvent(self.collider, function(go)
      self:Hide()
    end)
  end
end

local str = "%sx%d"

function OricalCardDetailInfo:SetData(data, num)
  self.num = num or 1
  self.data = data
  if not data then
    return
  end
  local isMonsterCard = FunctionPve.IsMonsterCard(data.Type)
  self.frameBgTextureName = isMonsterCard and Frame2Bg_Texture[1] or Frame2Bg_Texture[2]
  local lab_c = isMonsterCard and Lab_Effect_Color[1] or Lab_Effect_Color[2]
  local _, lab_rc = ColorUtil.TryParseHexString(lab_c)
  self.nameLab.effectColor = lab_rc
  self.nameLab.text = string.format(str, data.Name, self.num)
  PictureManager.Instance:SetUI(self.frameBgTextureName, self.frame2Bg)
  PictureManager.Instance:SetUI(BG_Texture, self.bg)
  PictureManager.Instance:SetUI(BG_Texture, self.bg2)
  local frame_c = isMonsterCard and Frame_ColorMap[1] or Frame_ColorMap[2]
  local _, frame_rc = ColorUtil.TryParseHexString(frame_c)
  self.frame.color = frame_rc
  self.desc.text = string.format(ZhString.Pve_PveCard_desc, data.Message)
  FunctionMonster.Me():SetMonsterFlag(self.monsterFlag, data.MonsterID)
  self.instructions.text = data.Instructions or ""
  self:SetCard2D(data.Resource)
end

function OricalCardDetailInfo:unloadFrameBgTexture()
  if self.frameBgTextureName then
    PictureManager.Instance:UnLoadUI(self.frameBgTextureName, self.frame2Bg)
  end
  PictureManager.Instance:UnLoadUI(BG_Texture, self.bg)
  PictureManager.Instance:UnLoadUI(BG_Texture, self.bg2)
end

function OricalCardDetailInfo:SetCard2D(resource)
  if StringUtil.IsEmpty(resource) then
    return
  end
  local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
  local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. resource))
  if self.assetname ~= nil and self.assetname ~= assetname then
    _AssetLoadEventDispatcher:RemoveEventListener(self.assetname, OricalCardDetailInfo.LoadPicComplete, self)
  end
  self.assetname = assetname
  if assetname ~= nil then
    _AssetLoadEventDispatcher:AddEventListener(assetname, OricalCardDetailInfo.LoadPicComplete, self)
    self:SetCard(LoadingName)
  else
    self:SetPic()
  end
  self.loading:SetActive(assetname ~= nil)
end

function OricalCardDetailInfo:SetCard(name)
  if self.cardInfoName == name then
    return true
  end
  self:UnLoadCard()
  self.cardInfoName = name
  return PictureManager.Instance:SetCard(name, self.icon)
end

function OricalCardDetailInfo:UnLoadCard()
  if self.cardInfoName ~= nil then
    PictureManager.Instance:UnLoadCard(self.cardInfoName, self.icon)
    self.cardInfoName = nil
  end
end

function OricalCardDetailInfo:SetPic()
  local resource = self.data and self.data.Resource
  if StringUtil.IsEmpty(resource) then
    return
  end
  if not self:SetCard(resource) then
    self:SetCard(LoadFailed_CardName)
  end
end

function OricalCardDetailInfo:LoadPicComplete(args)
  if args.success then
    self.loading:SetActive(false)
    self:SetPic()
  end
end

function OricalCardDetailInfo:Destroy()
  if self.assetname ~= nil then
    Game.AssetLoadEventDispatcher:RemoveEventListener(self.assetname, OricalCardDetailInfo.LoadPicComplete, self)
    self.assetname = nil
  end
  self:UnLoadCard()
  self:unloadFrameBgTexture()
end
