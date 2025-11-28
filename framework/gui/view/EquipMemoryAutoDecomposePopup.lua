EquipMemoryAutoDecomposePopup = class("EquipMemoryAutoDecomposePopup", BaseView)
EquipMemoryAutoDecomposePopup.ViewType = UIViewType.Lv4PopUpLayer

function EquipMemoryAutoDecomposePopup:Init()
  self:InitView()
  self:InitData()
  self:InitShow()
end

function EquipMemoryAutoDecomposePopup:InitView()
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.togGrid = self:FindGO("TogGrid"):GetComponent(UIGrid)
  self.togs = {}
  for i = 1, 3 do
    local go = self:FindGO("Tog" .. i)
    local label = self:FindGO("Label", go):GetComponent(UILabel)
    local toggle = go:GetComponent(UIToggle)
    self.togs[i] = {
      go = go,
      label = label,
      toggle = toggle
    }
  end
  self:AddClickEvent(self.confirmBtn, function()
    self:CallOption()
    self:CloseSelf()
  end)
end

function EquipMemoryAutoDecomposePopup:InitData()
  self.validQuality = GameConfig.EquipMemory.AutoDecomposeValid or {
    2,
    3,
    4
  }
end

function EquipMemoryAutoDecomposePopup:InitShow()
  local options = BagProxy.Instance:GetMemoryAutoDecomposeOption() or {}
  for i = 1, 3 do
    if self.validQuality[i] then
      local quality = self.validQuality[i]
      self.togs[i].go:SetActive(true)
      self.togs[i].quality = quality
      local qualityStr = GameConfig.EquipMemory.Quality[quality] or "???"
      self.togs[i].label.text = string.format(ZhString.EquipMemory_AutoDecompose, qualityStr)
      self.togs[i].toggle.value = TableUtility.ArrayFindIndex(options, quality) > 0
    else
      self.togs[i].go:SetActive(false)
    end
  end
end

function EquipMemoryAutoDecomposePopup:CallOption()
  local result = {}
  for i = 1, 3 do
    if self.togs[i].toggle.value then
      xdlog("自动分解", self.togs[i].quality)
      table.insert(result, self.togs[i].quality)
    end
  end
  ServiceItemProxy.Instance:CallMemoryAutoDecomposeOptionItemCmd(result)
end
