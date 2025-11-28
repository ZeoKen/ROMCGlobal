local BaseCell = autoImport("BaseCell")
BannerItemCell = class("BannerItemCell", BaseCell)
autoImport("ItemTipBaseCell")
autoImport("TipLabelCell")
local BGMap = {
  [1] = "mall_bg_bottom_02",
  [2] = "mall_bg_bottom_03",
  [3] = "mall_bg_bottom_04"
}
local AttriColor = LuaColor.New(0.49019607843137253, 0.4117647058823529, 0.3176470588235294)

function BannerItemCell:Init()
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.eType = self:FindGO("eType"):GetComponent(UILabel)
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.descSV = self:FindGO("descSV"):GetComponent(UIScrollView)
  self.itemmodeltexture = self:FindGO("Texture"):GetComponent(UITexture)
  self:InitAttriContext()
  self.cardGO = self:FindGO("cardContainer")
  self.cardItem = ItemCardCell.new(self.cardGO)
  self.cardBg = self:FindGO("bg", self.cardGO):GetComponent(UITexture)
  self:AddCellClickEvent()
end

function BannerItemCell:InitAttriContext()
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, TipLabelCell, "BannerTipCell")
  self.contextDatas = {}
end

function BannerItemCell:SetIndex(i)
  self.index = i
end

function BannerItemCell:SetData(data, lotterytype)
  if data then
    self.staticID = data.ItemID
    self.lotterytype = lotterytype
    self.cardInfo = Table_Card[self.staticID]
    self.desc.text = ""
    TableUtility.TableClear(self.contextDatas)
    self:SetAttriInfo()
    if self.cardInfo then
      self:SetCardCell(data)
      self.itemmodeltexture.gameObject:SetActive(false)
    else
      self.itemmodeltexture.gameObject:SetActive(true)
      self:SetItemModel(data)
    end
  end
end

function BannerItemCell:SetCardCell()
  self.cardGO:SetActive(true)
  self.data = ItemData.new("banner", self.staticID)
  self:UpdateModel()
  self.cardItem:SetData(self.data)
  local sData = self.staticID and Table_Item[self.staticID]
  self.name.text = sData.NameZh
  self.eType.text = ItemUtil.GetItemTypeName(sData, "") or ""
  PictureManager.Instance:SetUI(BGMap[self.index or 1], self.cardBg)
  self:UpdateCardAttriInfo()
end

function BannerItemCell:UpdateCardAttriInfo(data)
  if self.cardInfo then
    local special = {
      label = {}
    }
    local bufferIds = self.cardInfo.BuffEffect.buff
    if bufferIds then
      for i = 1, #bufferIds do
        local str = ItemUtil.getBufferDescById(bufferIds[i])
        local bufferStrs = string.split(str, "\n")
        for j = 1, #bufferStrs do
          table.insert(special.label, ItemTipDefaultUiIconPrefix .. bufferStrs[j])
        end
      end
    end
    self.contextDatas[ItemTipAttriType.CardInfo] = special
    self:SetAttriInfo()
  end
end

function BannerItemCell:SetAttriInfo()
  self.listDatas = self.listDatas or {}
  TableUtility.ArrayClear(self.listDatas)
  for i = 1, ItemTipAttriType.MAX_INDEX do
    if self.contextDatas[i] then
      self.contextDatas[i].hideline = true
      self.contextDatas[i].color = AttriColor
      table.insert(self.listDatas, self.contextDatas[i])
    end
  end
  self.attriCtl:ResetDatas(self.listDatas, true)
end

function BannerItemCell:SetItemModel(data)
  self.LoadShowSize = data.LoadShowSize
  self.LoadShowRotate = data.LoadShowRotate
  self.LoadShowPose = data.LoadShowPose
  self:UpdateModel()
  self.data = ItemData.new("banner", self.staticID)
  local sData = self.staticID and Table_Item[self.staticID]
  if sData then
    self.name.text = sData.NameZh
    self.eType.text = ItemUtil.GetItemTypeName(sData, "") or ""
    self.desc.text = sData.Desc
    self.attriCtl:ResetDatas("", true)
    self.desc.gameObject:SetActive(true)
    self.descSV:ResetPosition()
  else
    redlog("not in Table_Item", self.staticID)
  end
end

function BannerItemCell:UpdateModel()
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  self:SetNormalModel()
end

function BannerItemCell:SetNormalModel()
  TableUtility.TableClear(self.contextDatas)
  if self.cardInfo then
    return
  end
  local sData = self.staticID and Table_Item[self.staticID]
  if not sData then
    return
  end
  UIModelUtil.Instance:ChangeBGMeshRenderer(BGMap[self.index or 1], self.itemmodeltexture)
  if self.modelId == sData.id then
    return
  end
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  self.modelId = sData.id
  UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, sData.id, nil, function(obj, id, assetRolePart)
    self.model = assetRolePart
    local showPos = self.LoadShowPose
    if showPos and showPos[1] then
      self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
    else
      local isfashion = BagProxy.fashionType[sData.Type]
      if isfashion then
        self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(0, 0.5))
      end
    end
    self.model:ResetLocalEulerAnglesXYZ(self.LoadShowRotate and self.LoadShowRotate[1] or 0, self.LoadShowRotate and self.LoadShowRotate[2] or 0, 0)
    local size = self.LoadShowSize or 2
    self.model:ResetLocalScale(LuaGeometry.GetTempVector3(size, size, size))
  end, sData.id)
end

function BannerItemCell:UpdateEquipAttriInfo(data)
  TableUtility.TableClear(self.contextDatas)
  local equipInfo = data.equipInfo
  local propMap = Game.Config_PropName
  if equipInfo then
    if data:IsMount() or data:IsMountPet() then
      local speed = ItemTipBaseCell.GetSpeedUp()
      if 0 < speed then
        self.contextDatas[ItemTipAttriType.MountSpeedUp] = {
          label = string.format(ZhString.ItemTip_MountSpeedUp, speed * 100)
        }
      end
    else
      singleData = ItemTipBaseCell.GetEquipBaseAttriByItemData(data, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.EquipBaseAttri] = singleData
      end
      singleData = ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, nil, ItemTipEquipAttriVStrColorStr)
      if singleData then
        self.contextDatas[ItemTipAttriType.Pvp_EquipBaseAttri] = singleData
      end
      local lotterData, nextlotteryData = LotteryProxy.Instance:GetEquipLotteryShowDatas(data.staticData.id)
      if nextlotteryData then
        local nlotteryEffect = {}
        for k, v in pairs(nextlotteryData.Attr) do
          if propMap[k] then
            local vstr = propMap[k].IsPercent == 1 and v * 100 .. "%" or v
            vstr = string.format("[c][%s]+%s[-][/c]", ItemTipEquipAttriVStrColorStr, vstr)
            local templab = string.format("%s%s%s", "persona_icon_dot", propMap[k].PropName, vstr)
            table.insert(nlotteryEffect, {
              propMap[k].id,
              templab
            })
          end
        end
        if 0 < #nlotteryEffect then
          table.sort(nlotteryEffect, ItemTipBaseCell.EffectSort)
          local nextlottery = {
            label = {
              string.format(ZhString.ItemTip_EquipLotteryTip, nextlotteryData.Level[1])
            }
          }
          local sb, effStr = LuaStringBuilder.CreateAsTable()
          for i = 1, #nlotteryEffect do
            effStr = nlotteryEffect[i][2]
            if i < #nlotteryEffect then
              sb:AppendLine(effStr)
            else
              sb:Append(effStr)
            end
          end
          if 0 < sb:GetCount() then
            nextlottery.label[2] = sb:ToString()
          end
          sb:Destroy()
          self.contextDatas[ItemTipAttriType.NextEquipLotteryAttri] = nextlottery
        end
      elseif lotterData then
        self.contextDatas[ItemTipAttriType.NextEquipLotteryAttri] = {
          label = ZhString.ItemTip_LotteryMaxTip
        }
      end
    end
    singleData = ItemTipBaseCell.GetEquipStrengthRefineByItemData(data, nil, self.equipBuffUpSource)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipStrengthRefine] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipSpecial(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipSpecial] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipRandomAttri(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipRandomAttri] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipEnchant(data, self.showFullAttr, self.equipBuffUpSource)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipEnchant] = singleData
    end
    singleData = ItemTipBaseCell.GetEquipUpgrade(equipInfo)
    if singleData then
      self.contextDatas[ItemTipAttriType.EquipUpInfo] = singleData
    end
  end
  local suitInfo = data.suitInfo
  if suitInfo then
    local equipSuitDatas = suitInfo:GetEquipSuitDatas()
    if 0 < #equipSuitDatas then
      local suit, i, equipSuitData, buffIds = {
        label = {}
      }, 0
      for j = 1, #equipSuitDatas do
        equipSuitData = equipSuitDatas[j]
        buffIds = equipSuitData:GetSuitAddBuffIds()
        if next(buffIds) then
          i = i + 1
          table.insert(suit.label, string.format(ZhString.ItemTip_SuitInfo, i))
          table.insert(suit.label, string.format("[c]%s%s[-][/c]", ItemTipEquipAttriActiveColorStr, equipSuitData:GetSuitName()))
          local effectStr
          if data.equiped == 1 and equipSuitData:CheckIsActive() then
            effectStr = string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum()) .. tostring(equipSuitData:GetEffectDesc())
          else
            effectStr = string.format("[c]%s%s%s[-][/c]", ItemTipInactiveColorStr, string.format(ZhString.ItemTip_SuitInfoTip, equipSuitData:GetSuitNum()), tostring(equipSuitData:GetEffectDesc()))
          end
          table.insert(suit.label, effectStr)
        end
      end
      self.contextDatas[ItemTipAttriType.EquipSuit] = suit
    end
  end
  self.listDatas = self.listDatas or {}
  TableUtility.ArrayClear(self.listDatas)
  for i = 1, ItemTipAttriType.MAX_INDEX do
    if self.contextDatas[i] then
      self.contextDatas[i].hideline = true
      self.contextDatas[i].color = AttriColor
      table.insert(self.listDatas, self.contextDatas[i])
    end
  end
  self.attriCtl:ResetDatas(self.listDatas, true)
end

function BannerItemCell:DestroySelf()
  if self.attriCtl then
    self.attriCtl:RemoveAll()
  end
  if self.cardItem then
    self.cardItem:OnCellDestroy()
  end
  UIMultiModelUtil.Instance:RemoveModels()
  self.model = nil
  self.listDatas = nil
  self.contextDatas = nil
end
