local BaseCell = autoImport("BaseCell")
ExtractionSlotCell = class("BossCell", BaseCell)

function ExtractionSlotCell:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddCellClickEvent()
end

function ExtractionSlotCell:FindObjs()
  self.texture = self:FindGO("Texture"):GetComponent(UITexture)
  self.icon = self:FindGO("icon"):GetComponent(UISprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.extractionLv = self:FindGO("refineLv"):GetComponent(UILabel)
  self.refineContainer = self:FindGO("refineContainer")
  self.chooseSymbol = self:FindGO("chooseSymbol")
  self.infoContainer = self:FindGO("infoContainer")
  self.lock = self:FindGO("lock")
  self.chooseSymbol:SetActive(false)
  self.activeMask = self:FindGO("activeMask")
  self.emptyTip = self:FindGO("emptyTip"):GetComponent(UILabel)
  PictureManager.Instance:SetUI("Rune_bg_Exhibition", self.texture)
  self.sp1 = self:FindGO("sp1")
  self.sp2 = self:FindGO("sp2")
  self.deletedIcon = self:FindGO("DeletedIcon")
  if self.deletedIcon then
    self.deletedIcon:SetActive(false)
  end
end

function ExtractionSlotCell:AddEvts()
  self:AddCellClickEvent()
end

function ExtractionSlotCell:SetData(data)
  self.data = data
  if data then
    self.id = self.data.gridid
    self.extractionData = AttrExtractionProxy.Instance:GetExtractionDataByGrid(self.id)
    self:UpdataData()
  end
end

function ExtractionSlotCell:SetChoose(b)
  self.chooseSymbol:SetActive(b)
end

function ExtractionSlotCell:UpdataData()
  if not self.extractionData then
    return
  end
  self.infoContainer:SetActive(self.extractionData.got)
  self.lock:SetActive(not self.extractionData.got)
  self.activeMask:SetActive(self.extractionData.active)
  self.sp1:SetActive(false)
  self.sp2:SetActive(false)
  if self.extractionData.itemid ~= 0 then
    self.refineContainer:SetActive(true)
    self.name.gameObject:SetActive(true)
    self.name.text = self.extractionData.itemStaticData.NameZh
    self.extractionLv.text = self.extractionData.extractionLv
    IconManager:SetItemIcon(self.extractionData.itemStaticData.Icon, self.icon)
    self.icon.gameObject:SetActive(true)
    self.emptyTip.text = ""
    local config = Table_EquipExtraction[self.extractionData.itemid]
    if config then
      self.sp1:SetActive(config.AttrType == 1)
      self.sp2:SetActive(config.AttrType == 2)
    end
  else
    self.refineContainer:SetActive(false)
    self.name.gameObject:SetActive(false)
    self.icon.gameObject:SetActive(false)
    self.emptyTip.text = ZhString.MagicBox_EmptyTip
  end
end

function ExtractionSlotCell:OnCellDestroy()
  if self.texture then
    PictureManager.Instance:UnLoadUI("Rune_bg_Exhibition", self.texture)
  end
end
