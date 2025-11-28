local BaseCell = autoImport("BaseCell")
autoImport("TipLabelNameValuePair")
AdventureTipLabelCell = class("AdventureTipLabelCell", BaseCell)
local Line_default_width = {340, 170}
local defaultLineColor, dottedLineColor = LuaColor.New(0.9019607843137255, 0.9137254901960784, 0.9647058823529412, 1), LuaColor.New(0.5411764705882353, 0.6, 0.7254901960784313, 1)
local defaultLabelColor, defaultTipLabelColor = LuaColor.Black(), LuaColor.New(1.0, 0.4235294117647059, 0.10980392156862745, 1)
local defaultLabelFontSize, defaultTipLabelFontSize = 20, 20
local labelTypeMap = {
  Common = 1,
  Status = 2,
  Count = 3
}

function AdventureTipLabelCell:Init()
  self.labelMap, self.nvPairMap = {}, {}
  self.tiplabel = self:FindComponent("A_TipLabel", UILabel)
  self.commonLabelPfb = self:FindGO("CommonLabel")
  self.statusLabelPfb = self:FindGO("StatusLabel")
  self.materialLabelPfb = self:FindGO("MaterialCount")
  self.line = self:FindGO("Z_Line")
  self.lineTrans = self.line and self.line.transform
  self.table = self.gameObject:GetComponent(UITable)
end

function AdventureTipLabelCell:SetData(data)
  self.data = data
  if data then
    if Slua.IsNull(self.gameObject) then
      return
    end
    local labels = {}
    if type(data.label) == "string" then
      table.insert(labels, {
        text = data.label
      })
    elseif type(data.label) == "table" then
      local tempList = {}
      for i = 1, #data.label do
        local singleLabel = data.label[i]
        if type(singleLabel) == "string" then
          table.insert(tempList, {text = singleLabel})
        elseif type(singleLabel) == "table" then
          table.insert(tempList, singleLabel)
        end
      end
      labels = tempList
    end
    if not self:ObjIsNil(self.tiplabel) then
      if not StringUtil.IsEmpty(data.tiplabel) then
        self.tiplabel.gameObject:SetActive(true)
        self.tiplabel.text = data.tiplabel
        self:SetLabelColor(self.tiplabel, data.tipcolor or data.color or defaultTipLabelColor)
        self.tiplabel.fontSize = data.tipfontsize or data.fontsize or defaultTipLabelFontSize
      else
        self.tiplabel.gameObject:SetActive(false)
      end
    end
    self:SetLabels(labels, data)
    if data.locked then
      redlog("locked")
    end
    local hideline, usestripline, lineTab = data.hideline, data.usestripline, data.lineTab or Line_default_width
    if self.line then
      self.line:SetActive(not hideline)
      if not hideline then
        local lineImg = self.line:GetComponent("UISprite")
        lineImg.type = usestripline and E_UIBasicSprite_Type.Sliced or E_UIBasicSprite_Type.Tiled
        lineImg.spriteName = usestripline and "com_bg_line" or "calendar_bg_dotted-line"
        lineImg.color = usestripline and defaultLineColor or dottedLineColor
        lineImg.width = lineTab[1]
        local tempVector3 = LuaGeometry.GetTempVector3(LuaGameObject.GetLocalPosition(self.lineTrans))
        tempVector3.x = lineTab[2]
        self.lineTrans.localPosition = tempVector3
        if data.dotLineColor ~= nil then
          lineImg.color = data.dotLineColor
        end
      end
    end
    if BranchMgr.IsJapan() then
      local itemId = data.helpInfoItemId
      if itemId then
        local Label01 = self:FindGO("Label01")
        if Label01 ~= nil and self.helpButton == nil then
          self.helpButton = self:LoadPreferb("cell/HelpButtonCell", Label01)
          self.helpButton.transform.localPosition = LuaGeometry.GetTempVector3(316, -10, 0)
          self.helpButton.transform.localScale = LuaGeometry.GetTempVector3(0.8, 0.8, 1)
          self:AddClickEvent(self:FindGO("HelpButton", self.helpButton), function(go)
            OverseaHostHelper:ShowGiftProbability(itemId)
          end)
          helplog(self.helpButton)
        end
      elseif self.helpButton then
        GameObject.Destroy(self.helpButton)
        self.helpButton = nil
      end
    end
  else
    self:SetLabels()
  end
  self:RePosition()
end

function AdventureTipLabelCell:CreateLabelObject(type, width, labwidth, iconwidth, iconheight, number)
  local labObj, labComp
  local lab = {}
  if type == AdventureDataProxy.LabelType.Common then
    labObj = self:CopyGameObject(self.commonLabelPfb)
    labObj:SetActive(true)
    lab.go = labObj
    labComp = labObj:GetComponent(UILabel)
    labComp.fontSize = self.data.fontsize or defaultLabelFontSize
    if labwidth then
      labComp.width = labwidth
    end
    lab.label = SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
  elseif type == AdventureDataProxy.LabelType.Status then
    labObj = self:CopyGameObject(self.statusLabelPfb)
    labObj:SetActive(true)
    lab.go = labObj
    lab.lockedTip = self:FindGO("LockedTip", labObj)
    lab.finishSymbol = self:FindGO("FinishSymbol", labObj)
    labComp = labObj:GetComponent(UILabel)
    labComp.fontSize = self.data.fontsize or defaultLabelFontSize
    if labwidth then
      labComp.width = labwidth
    end
    lab.label = SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
  elseif type == AdventureDataProxy.LabelType.Count then
    labObj = self:CopyGameObject(self.materialLabelPfb)
    labObj:SetActive(true)
    lab.go = labObj
    lab.countLabel = self:FindGO("CountLabel", labObj):GetComponent(UILabel)
    lab.dotLine = self:FindGO("DotLine", labObj):GetComponent(UISprite)
    labComp = labObj:GetComponent(UILabel)
    labComp.fontSize = self.data.fontsize or defaultLabelFontSize
    if labwidth then
      labComp.width = labwidth
    end
    lab.label = SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
  end
  lab.labelType = type
  return lab
end

function AdventureTipLabelCell:SetSingleLabel(labCell, labelType, textInfo, color)
  local text = textInfo.text
  if labelType == AdventureDataProxy.LabelType.Common then
    labCell.label:SetText(text)
    labCell.label:SetLabelColor(color)
  elseif labelType == AdventureDataProxy.LabelType.Status then
    labCell.label:SetText(text)
    local isUnlock = textInfo.unlock or false
    labCell.label:SetLabelColor(isUnlock and LuaColor.Black() or LuaGeometry.GetTempVector4(0.592156862745098, 0.592156862745098, 0.592156862745098, 1))
    labCell.lockedTip:SetActive(not isUnlock)
    labCell.finishSymbol:SetActive(isUnlock)
  elseif labelType == AdventureDataProxy.LabelType.Count then
    labCell.label:SetText(text)
    local exist, need = textInfo.exist or 0, textInfo.need or 0
    labCell.label:SetLabelColor(exist >= need and LuaColor.Black() or LuaGeometry.GetTempVector4(0.592156862745098, 0.592156862745098, 0.592156862745098, 1))
    labCell.countLabel.color = exist >= need and LuaColor.Black() or LuaGeometry.GetTempVector4(0.592156862745098, 0.592156862745098, 0.592156862745098, 1)
    labCell.countLabel.text = exist .. "/" .. need
    local nameWidth = labCell.label.richLabel.printedSize.x
    labCell.dotLine.width = 240 - nameWidth
  end
end

function AdventureTipLabelCell:SetLabels(labels, labelData)
  local num = labels and #labels or 0
  local width, labwidth, iconwidth, iconheight
  local labelConfig = labelData.labelConfig
  if labelConfig then
    width, labwidth, iconwidth, iconheight = labelConfig.width, labelConfig.labwidth, labelConfig.iconwidth, labelConfig.iconheight
    if width and width <= 0 then
      width = Line_default_width[1] + width
    end
  end
  for i = 1, num do
    local labelInfo = labels[i] or ""
    local labelType = labelInfo.labelType or labelData.labelType or labelTypeMap.Common
    local lab = self.labelMap[i]
    if lab and lab.labelType ~= labelType then
      GameObject.DestroyImmediate(lab.go)
      self.labelMap[i] = nil
    end
    lab = self.labelMap[i]
    if not (lab and lab.go) or not lab.label then
      lab = self:CreateLabelObject(labelType, width, labwidth, iconwidth, iconheight, i)
      self:SetSingleLabel(lab, labelType, labelInfo, self.data.color or defaultLabelColor)
      self.labelMap[i] = lab
    else
      lab.label:ResetLineWidth(width)
      lab.label:Reset()
      self:SetSingleLabel(lab, labelType, labelInfo, self.data.color or defaultLabelColor)
    end
    if self.data.txtBgColor then
      local sprites = lab.label.richLabel.gameObject:GetComponentsInChildren(UISprite)
      if sprites ~= nil then
        for i = 1, #sprites do
          sprites[i].color = self.data.txtBgColor
        end
      end
      local lbs = lab.label.richLabel.gameObject:GetComponentsInChildren(UILabel)
      if lbs ~= nil then
        for i = 1, #lbs do
          lbs[i].color = self.data.color
        end
      end
    end
    if lab.label then
      self:TryHandleClickUrl(lab.label.richLabel, labels[i].text)
      self:TryHandleInlineButton(lab)
    end
  end
  for i = #self.labelMap, num + 1, -1 do
    GameObject.DestroyImmediate(self.labelMap[i].go)
    table.remove(self.labelMap, i)
  end
end

function AdventureTipLabelCell:SetLocked(data)
  local go
  for _, pair in pairs(self.nvPairMap) do
    go = pair.gameObject
    if not Slua.IsNull(go) then
      GameObject.DestroyImmediate(go)
    end
  end
  TableUtility.TableClear(self.nvPairMap)
  self.nvPairMap[1] = self:MakeNameValuePair("Locked")
  self.nvPairMap[1]:SetData(data)
end

function AdventureTipLabelCell:RePosition()
  if self.gameObject.activeInHierarchy then
    self.table:Reposition()
  else
    self.table.repositionNow = true
  end
end

function AdventureTipLabelCell:SetLabelColor(label, color)
  if not label then
    LogUtility.Warning("SetLabelColor: ArgumentNilException")
    return
  end
  color = color or defaultLabelColor
  local tColor = type(color)
  if tColor == "table" then
    label.color = color
  elseif tColor == "string" then
    local succ, pColor = ColorUtil.TryParseHexString(color)
    if succ then
      label.color = pColor
    end
  end
end

function AdventureTipLabelCell:TryHandleClickUrl(label, text)
  local labObj, hasUrl = label.gameObject, string.match(text, "%[url=")
  if hasUrl then
    local dragScrollView = labObj:GetComponent(UIDragScrollView)
    if not dragScrollView then
      labObj:AddComponent(UIDragScrollView)
    end
    UIUtil.TryAddClickUrlCompToGameObject(labObj, self.data.clickurlcallback)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(labObj)
  end
end

function AdventureTipLabelCell:TryHandleInlineButton(spriteLabel)
  if not spriteLabel.inlineBtns then
    return
  end
  local pendingrm = {}
  for k, v in pairs(spriteLabel.inlineBtns) do
    if Slua.IsNull(v) then
      pendingrm[#pendingrm + 1] = k
    else
      self:SetEvent(v.gameObject, function()
        self.data.inlineBtnCb(k)
      end)
      if self.data.inlineBtnExtraOffset then
        local pos = v.transform.localPosition
        pos.x = spriteLabel.richLabel.width - v.width / 2 + self.data.inlineBtnExtraOffset[1]
        pos.y = -(spriteLabel.richLabel.fontSize + spriteLabel.richLabel.spacingY) / 2 - v.height / 2 + self.data.inlineBtnExtraOffset[2]
        v.transform.localPosition = pos
      end
    end
  end
  for i = 1, #pendingrm do
    spriteLabel.inlineBtns[pendingrm[i]] = nil
  end
end
