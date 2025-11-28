local BaseCell = autoImport("BaseCell")
CardNCell = class("CardNCell", BaseCell)
autoImport("TipLabelCell")
local LoadingName = "card_loading"

function CardNCell:Init()
  self.iconContainer = self:FindGO("IconContainer")
  self.infoBord = self:FindGO("Info")
  self.icon = self:FindComponent("Icon", UISprite, self.iconContainer)
  self.iconPic = self:FindComponent("IconTex", UITexture)
  self.loading = self:FindGO("Loading")
  self.useSymbol = self:FindGO("UseSymbol")
  self.cardName = self:FindComponent("CardName", UILabel)
  self.cardNum = self:FindComponent("CardNum", UILabel)
  self.scrollView = self:FindComponent("Scroll View", UIScrollView)
  local cellObj = self:FindGO("TipLabelCell")
  self.tiplabelCell = TipLabelCell.new(cellObj)
  self:AddClickEvent(self.gameObject, function(go)
    self:SetChooseState(not self.use)
  end)
  self.useButton = self:FindComponent("UseButton", UIButton)
  self:AddClickEvent(self.useButton.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  if upPanel then
    local startDepth = upPanel.depth + 1
    for i = 1, #panels do
      panels[i].depth = panels[i].depth - minDepth + startDepth
    end
  end
end

function CardNCell:SetData(data, chooseState)
  self.data = data
  if data and data.cardInfo then
    self.gameObject:SetActive(true)
    local cardInfo = data.cardInfo
    if self.cardInfoName ~= nil and self.cardInfoName ~= cardInfo.Picture then
      PictureManager.Instance:UnLoadCard(self.cardInfoName, self.iconPic)
      self.cardInfoName = nil
    end
    local cardName = cardInfo.Name
    self.cardName.text = data.cardLv and data.cardLv > 0 and string.format("+%s %s", data.cardLv, cardName) or cardName
    self.cardNum.text = data.num > 1 and data.num or ""
    local contextlabel = {
      label = {},
      hideline = true,
      color = ColorUtil.NGUIWhite
    }
    local cardAttrs = data:GetCardAttrs()
    if not cardAttrs then
      cardAttrs = {}
      local bufferIds = cardInfo.BuffEffect.buff
      if bufferIds then
        for i = 1, #bufferIds do
          local str = ItemUtil.getBufferDescById(bufferIds[i])
          local bufferStrs = string.split(str, "\n")
          for j = 1, #bufferStrs do
            table.insert(cardAttrs, bufferStrs[j])
          end
        end
      end
    end
    contextlabel.label = cardAttrs
    self.tiplabelCell:SetData(contextlabel)
    self:SetUse(data.used == true)
    self.use = nil
    if chooseState ~= nil then
      self:SetChooseState(chooseState)
    else
      self:SetChooseState(true)
    end
  else
    self.tiplabelCell:SetData()
    self.gameObject:SetActive(false)
  end
  if self.scrollView then
    if self.scrollView.enabled == false then
      self.scrollView.enabled = true
      self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
      self.scrollView:ResetPosition()
      self.scrollView.enabled = false
    else
      self.scrollView.currentMomentum = LuaGeometry.Const_V3_zero
      self.scrollView:ResetPosition()
    end
  end
end

function CardNCell:SetUse(b)
  self.useButton.isEnabled = not b
  self.useSymbol:SetActive(b)
end

function CardNCell:SetChooseState(use)
  if self.use == use then
    return
  end
  if self:ObjIsNil(self.infoBord) then
    return
  end
  self.infoBord:SetActive(use)
  self.iconContainer:SetActive(not use)
  self.use = use
  if not use then
    local data = self.data
    if data ~= nil then
      local cardInfo = data.cardInfo
      if cardInfo ~= nil then
        local _AssetLoadEventDispatcher = Game.AssetLoadEventDispatcher
        local assetname = _AssetLoadEventDispatcher:AddRequestUrl(ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. cardInfo.Picture))
        if self.assetname ~= nil and self.assetname ~= assetname then
          _AssetLoadEventDispatcher:RemoveEventListener(self.assetname, CardNCell.LoadPicComplete, self)
        end
        self.assetname = assetname
        if assetname ~= nil then
          _AssetLoadEventDispatcher:AddEventListener(assetname, CardNCell.LoadPicComplete, self)
          self:SetCard(LoadingName)
        else
          self:SetPic()
        end
        self.loading:SetActive(assetname ~= nil)
      end
    end
  end
end

function CardNCell:SetCard(name)
  if self.cardInfoName == name then
    return true
  end
  self:UnLoadCard()
  self.cardInfoName = name
  return PictureManager.Instance:SetCard(name, self.iconPic)
end

function CardNCell:UnLoadCard()
  if self.cardInfoName ~= nil then
    PictureManager.Instance:UnLoadCard(self.cardInfoName, self.iconPic)
    self.cardInfoName = nil
  end
end

function CardNCell:SetPic()
  local data = self.data
  if data == nil then
    return
  end
  local cardInfo = data.cardInfo
  if cardInfo == nil then
    return
  end
  if not self:SetCard(cardInfo.Picture) then
    self:SetCard("card_10001")
  end
end

function CardNCell:LoadPicComplete(args)
  if args.success then
    self.loading:SetActive(false)
    self:SetPic()
  end
end

function CardNCell:OnCellDestroy()
  if self.assetname ~= nil then
    Game.AssetLoadEventDispatcher:RemoveEventListener(self.assetname, CardNCell.LoadPicComplete, self)
    self.assetname = nil
  end
  self:UnLoadCard()
end
