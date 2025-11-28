local baseCell = autoImport("BaseCell")
UITeleportAreaCell = class("UITeleportAreaCell", baseCell)

function UITeleportAreaCell:Init()
  self.labName = self:FindGO("Name"):GetComponent(UILabel)
  self.goCurrency = self:FindGO("Currency")
  self.choose = self:FindGO("Choose")
  self.lv = self:FindGO("Lv"):GetComponent(UILabel)
  self.newObj = self:FindGO("New")
  self:AddCellClickEvent()
end

function UITeleportAreaCell:SetNewFlag()
  if not self.newObj then
    return
  end
  if self.data.sortId == 0 then
    self:Show(self.newObj)
  else
    self:Hide(self.newObj)
  end
end

function UITeleportAreaCell:SetData(data)
  self.choose:SetActive(false)
  self.data = data
  self.labName.text = data.name
  if AppBundleConfig.GetSDKLang() == "pt" then
    self.labName.text = self.labName.text:gsub("Área", ""):gsub(" ", "")
  end
  local lvRange = data.LvRange
  if lvRange then
    local minLevel, maxLevel
    for k, v in pairs(lvRange) do
      if not minLevel or k < minLevel then
        minLevel = k
      end
      if not maxLevel or k > maxLevel then
        maxLevel = k
      end
    end
    local formatStr = "Lv%s~%s"
    self.lv.text = string.format(formatStr, minLevel, maxLevel)
    self.labName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, -24.4, 0)
  else
    self.lv.text = ""
    self.labName.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(0, -36, 0)
  end
  self:SetNewFlag()
  self:SetChoose(false)
end

function UITeleportAreaCell:SetChoose(bool)
  if bool then
    self.choose.gameObject:SetActive(true)
    self.labName.effectStyle = UILabel.Effect.Outline8
    self.lv.effectStyle = UILabel.Effect.Outline8
  else
    self.choose.gameObject:SetActive(false)
    self.labName.effectStyle = UILabel.Effect.None
    self.lv.effectStyle = UILabel.Effect.None
  end
end
