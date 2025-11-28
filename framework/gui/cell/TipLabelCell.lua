autoImport("GeneralHelp")
local BaseCell = autoImport("BaseCell")
autoImport("TipLabelNameValuePair")
autoImport("TipLabelNameValuePair_Memory")
TipLabelCell = class("TipLabelCell", BaseCell)
local Line_default_width = {340, 170}
local defaultLineColor, dottedLineColor = LuaColor.New(0.9019607843137255, 0.9137254901960784, 0.9647058823529412, 1), LuaColor.New(0.5411764705882353, 0.6, 0.7254901960784313, 1)
local defaultLabelColor, defaultTipLabelColor = LuaColor.New(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1), LuaColor.New(0.2901960784313726, 0.35294117647058826, 0.49019607843137253, 1)
local defaultLabelFontSize, defaultTipLabelFontSize = 18, 20

function TipLabelCell:Init()
  self.labelMap, self.nvPairMap = {}, {}
  self.tiplabel = self:FindComponent("A_TipLabel", UILabel)
  self.tiplabelinlinebutton = self:FindComponent("A_TipLabel_InlineButton", UISprite)
  self.labelPfb = self:FindGO("Label")
  self.line = self:FindGO("Z_Line")
  self.lineTrans = self.line and self.line.transform
  self.table = self.gameObject:GetComponent(UITable)
  self.sliderCell = self:FindGO("TipLabelSliderCell")
  self.singleBtnGO = self:FindGO("SingleButton")
  if self.singleBtnGO then
    self.singleBtnIcon = self:FindComponent("BtnIcon", UISprite, self.singleBtnGO)
    self.singleBtnLab = self:FindComponent("BtnText", UILabel, self.singleBtnGO)
    self:AddClickEvent(self.singleBtnGO, function()
      if self.onSingleButtonClicked then
        self.onSingleButtonClicked(self)
      end
    end)
  end
end

function TipLabelCell.SetDefaultLabWidth(width)
  TipLabelCell.defaultLabwidth = width
  if width then
    Line_default_width[1] = width
  end
end

function TipLabelCell:SetData(data)
  self.data = data
  if data then
    if Slua.IsNull(self.gameObject) then
      return
    end
    local labels
    if type(data.label) == "string" then
      labels = {
        data.label
      }
    elseif type(data.label) == "table" then
      labels = data.label
    end
    if not self:ObjIsNil(self.tiplabel) then
      if not StringUtil.IsEmpty(data.tiplabel) then
        self.tiplabel.gameObject:SetActive(true)
        self.tiplabel.text = data.tiplabel
        self:SetLabelColor(self.tiplabel, data.tipcolor or data.color or defaultTipLabelColor)
        self.tiplabel.fontSize = data.tipfontsize or data.fontsize or defaultTipLabelFontSize
        if self.tiplabelinlinebutton then
          if data.aTipInlineButton then
            if data.aTipInlineButton.sprite then
              IconManager:SetUIIcon(data.aTipInlineButton.sprite, self.tiplabelinlinebutton)
              self.tiplabelinlinebutton:MakePixelPerfect()
              if data.aTipInlineButton.spriteScale then
                self.tiplabelinlinebutton.width = self.tiplabelinlinebutton.width * data.aTipInlineButton.spriteScale[1]
                self.tiplabelinlinebutton.height = self.tiplabelinlinebutton.height * data.aTipInlineButton.spriteScale[2]
              end
              if data.aTipInlineButton.color then
                self.tiplabelinlinebutton.color = data.aTipInlineButton.color
              end
            end
            if data.aTipInlineButton.showSubMark then
              local m = self:FindGO("go", self.tiplabelinlinebutton.gameObject)
              if m then
                m:SetActive(true)
              end
            end
            local pos = self.tiplabelinlinebutton.transform.localPosition
            pos.x = self.tiplabel.width - self.tiplabelinlinebutton.width / 2 - (self.tiplabelinlinebutton.height - self.tiplabelinlinebutton.width)
            pos.y = -(self.tiplabel.fontSize + self.tiplabel.spacingY) / 2 - self.tiplabelinlinebutton.height / 2
            self.tiplabelinlinebutton.transform.localPosition = pos
            if data.aTipInlineButton.action then
              self:SetEvent(self.tiplabelinlinebutton.gameObject, function()
                data.aTipInlineButton.action()
              end)
            end
            if data.aTipInlineButton.init_action then
              data.aTipInlineButton.init_action(self.tiplabelinlinebutton)
            end
            self.tiplabelinlinebutton.gameObject:SetActive(true)
          else
            self.tiplabelinlinebutton.gameObject:SetActive(false)
          end
        end
      else
        self.tiplabel.gameObject:SetActive(false)
      end
    end
    self:SetLabels(labels, data.labelConfig)
    if data.locked then
      self:SetLocked(data)
    elseif data.namevaluepair then
      self:SetNameValuePair(data.namevaluepair)
    elseif #self.nvPairMap > 0 then
      local go
      for i = 1, #self.nvPairMap do
        go = self.nvPairMap[i].gameObject
        if not Slua.IsNull(go) then
          GameObject.DestroyImmediate(go)
        end
      end
      TableUtility.TableClear(self.nvPairMap)
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
    if GemProxy.CheckIsGemAttrData(data) then
      self:SetSlider(data.exp, data:GetExpForNextLevel(), data.lv)
      self.line:SetActive(false)
      self:RePosition()
      return
    elseif GemProxy.CheckIsSecretLandData(data) then
      local value = data.lvUpConfig == nil and 1 or data.exp / data.lvUpConfig.NeedExp
      self:SetSlider(nil, nil, data.lv, nil, value)
      self.line:SetActive(false)
      self:RePosition()
      return
    elseif self.sliderCell then
      GameObject.DestroyImmediate(self.sliderCell)
      self.sliderCell = nil
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
    if not self:ObjIsNil(self.singleBtnGO) then
      if data.singleButton then
        self.singleBtnGO:SetActive(true)
        self.singleBtnLab.text = data.singleButton.text or ""
        local iconName = data.singleButton.iconName
        if iconName then
          IconManager:SetUIIcon(iconName, self.singleBtnIcon)
        end
        self.onSingleButtonClicked = data.singleButton.onClicked
      else
        self.onSingleButtonClicked = nil
        self.singleBtnGO:SetActive(false)
      end
    end
  else
    self:SetLabels()
  end
  self:RePosition()
end

function TipLabelCell:SetLabels(labels, labelConfig)
  local num = labels and #labels or 0
  local width, labwidth, iconwidth, iconheight
  if labelConfig then
    width, labwidth, iconwidth, iconheight = labelConfig.width, labelConfig.labwidth, labelConfig.iconwidth, labelConfig.iconheight
    if width and width <= 0 then
      width = Line_default_width[1] + width
    end
  end
  if self.sliderCell2 and not Slua.IsNull(self.sliderCell2) then
    GameObject.Destroy(self.sliderCell2)
    self.sliderCell2 = nil
  end
  self:HideExtraDesc()
  for i = 1, num do
    local text = labels[i] or ""
    if text:sub(1, 7) == "slider:" then
      if self.labelMap[i] then
        self.labelMap[i].needDestroy = true
      end
      local goName = self.labelMap[i - 1] and self.labelMap[i - 1].richLabelTrans.name
      goName = goName and goName .. "1"
      local vals = string.split(text:sub(8, #text), ",")
      if vals and #vals == 2 then
        self:SetSlider2(tonumber(vals[1]) or 1, tonumber(vals[2]) or 1, goName)
      end
    elseif text:sub(1, 10) == "ExtraDesc:" then
      if self.labelMap[i] then
        self.labelMap[i].needDestroy = true
      end
      local goName = self.labelMap[i - 1] and self.labelMap[i - 1].richLabelTrans.name
      goName = goName and goName .. "1"
      local vals = string.split(text:sub(10, #text), ",")
      if vals and #vals == 2 then
        self:SetSlider2(tonumber(vals[1]) or 1, tonumber(vals[2]) or 1, goName)
      end
      local mainText = text:sub(11, #text)
      if mainText then
        local suffix = "[ExtraHp]"
        if string.match(mainText, suffix) then
          self:SetExtraDesc(mainText:sub(1, #mainText - #suffix), true)
        else
          self:SetExtraDesc(mainText)
        end
      end
    else
      local lab = self.labelMap[i]
      if not lab then
        lab = self:MakeSpriteLabel(width, labwidth, iconwidth, iconheight, i)
        self.labelMap[i] = lab
      else
        lab:ResetLineWidth(width)
        lab:Reset()
      end
      lab:SetText(text)
      lab:SetLabelColor(self.data.color or defaultLabelColor)
      if self.data.txtBgColor then
        local sprites = lab.richLabel.gameObject:GetComponentsInChildren(UISprite)
        if sprites ~= nil then
          for i = 1, #sprites do
            sprites[i].color = self.data.txtBgColor
          end
        end
        local lbs = lab.richLabel.gameObject:GetComponentsInChildren(UILabel)
        if lbs ~= nil then
          for i = 1, #lbs do
            lbs[i].color = self.data.color
          end
        end
      end
      self:TryHandleClickUrl(lab.richLabel, labels[i])
      self:TryHandleInlineButton(lab)
    end
  end
  local cacheNum = #self.labelMap
  for i = cacheNum, 1, -1 do
    if self.labelMap[i] and self.labelMap[i].richLabel and (num < i or self.labelMap[i].needDestroy) then
      local richLabel = self.labelMap[i].richLabel
      self.labelMap[i]:Destroy()
      if not Slua.IsNull(richLabel) then
        GameObject.DestroyImmediate(richLabel.gameObject)
      end
      self.labelMap[i] = nil
    end
  end
end

function TipLabelCell:SetLocked(data)
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

function TipLabelCell:SetNameValuePair(pairList)
  local num, go, pair, pairData = pairList and #pairList or 0
  for i = 1, num do
    pair, pairData = self.nvPairMap[i], pairList[i]
    if not pair then
      pair = self:MakeNameValuePair("NameValuePair" .. i, pairData)
      self.nvPairMap[i] = pair
    end
    if pairData and not pairData.color then
      if not pairData.nameColor then
        pairData.nameColor = defaultLabelColor
      end
      if not pairData.valueColor then
        pairData.valueColor = defaultLabelColor
      end
    end
    pair:SetData(pairData)
  end
  for i = #self.nvPairMap, num + 1, -1 do
    go = self.nvPairMap[i].gameObject
    if not Slua.IsNull(go) then
      GameObject.DestroyImmediate(go)
    end
    table.remove(self.nvPairMap, i)
  end
  local sIndex = 3
  for i = 1, #self.nvPairMap do
    self.nvPairMap[i].gameObject.transform:SetSiblingIndex(sIndex)
    sIndex = sIndex + 1
  end
  for i = 1, #self.labelMap do
    self.labelMap[i].richLabel.gameObject.transform:SetSiblingIndex(sIndex)
    sIndex = sIndex + 1
  end
end

function TipLabelCell:SetSlider(val, maxVal, text, textColor, value)
  self.sliderCell = self.sliderCell or self:LoadPreferb("cell/TipLabelSliderCell", self.gameObject)
  local slider = self:FindComponent("Slider", UISlider, self.sliderCell)
  local lvLabel = self:FindComponent("LvLabel", UILabel, self.sliderCell)
  if not slider then
    return
  end
  if nil ~= value then
    slider.value = value
  else
    slider.value = maxVal ~= 0 and math.clamp(val / maxVal, 0, 1) or 1
  end
  lvLabel.text = string.format(ZhString.Gem_UpgradeLvLabelFormat, text or "")
  self:SetLabelColor(lvLabel, textColor)
end

function TipLabelCell:SetSlider2(val, maxVal, goName)
  self.sliderCell2 = self.sliderCell2 or self:LoadPreferb("cell/TipLabelSliderCell2", self.gameObject)
  local slider = self.sliderCell2:GetComponent(UISlider)
  local lvLabel = self:FindComponent("RefineValLabel", UILabel, self.sliderCell2)
  if not slider then
    return
  end
  self.sliderCell2.name = goName
  slider.value = maxVal ~= 0 and math.clamp(val / maxVal, 0, 1) or 0
  lvLabel.text = string.format("%s/%s", val, maxVal == EquipInfo.MaxRefineVal and "-" or maxVal)
end

function TipLabelCell:SetExtraDesc(text, addHelp)
  self.extraDescCell = self.extraDescCell or self:LoadPreferb("cell/TipLabelExtraDescCell", self.gameObject)
  self.extraDescLab = self.extraDescCell:GetComponent(UILabel)
  self.extraDescLab.text = text
  self:Show(self.extraDescCell)
  if nil == addHelp then
    self:_HideExtraDescHelpButton()
  elseif addHelp then
    if nil == self.extraDescHelpButton then
      self:_InitExtraDescHelpBtn()
    end
    self:Show(self.extraDescHelpButton)
  else
    self:_HideExtraDescHelpButton()
  end
  self:RePosition()
end

function TipLabelCell:_HideExtraDescHelpButton()
  if not self.extraDescHelpButton then
    return
  end
  self:Hide(self.extraDescHelpButton)
  self:_DestroyHelpTip()
end

function TipLabelCell:HideExtraDesc()
  if not self.extraDescCell then
    return
  end
  self:Hide(self.extraDescCell)
  self:_DestroyHelpTip()
  self:RePosition()
end

function TipLabelCell:OnCellDestroy()
  self:_DeInitExtraDescHelpBtn()
  self:_DeInitExtraDesc()
  self:_DestroyHelpTip()
end

function TipLabelCell:_DestroyHelpTip()
  if self.helpTip then
    self.helpTip:DestroySelf()
    self.helpTip = nil
  end
end

function TipLabelCell:_InitExtraDescHelpBtn()
  self.extraDescHelpButton = self:LoadPreferb("cell/HelpButtonCell", self.extraDescCell)
  self.extraDescHelpButton.transform.localPosition = LuaGeometry.GetTempVector3(155, 0, 0)
  self.extraDescHelpButton.transform.localScale = LuaGeometry.Const_V3_one
  self.extraHelpButton = self:FindComponent("HelpButton", UISprite, self.extraDescHelpButton)
  self.extraHelpButton.depth = self.extraDescLab.depth + 2
  self:Preprocess_HelpColiderObj(35277, self.extraHelpButton.gameObject)
  self:AddClickEvent(self.extraHelpButton.gameObject, function(go)
    if self.helpTip then
      return
    end
    local staticData = Table_Help[35277]
    if not staticData then
      return
    end
    self.helpTip = GeneralHelp.new("GeneralHelp", TipsView.Me().gameObject, true, self._DestroyHelpTip, self)
    self.helpTip:SetData(staticData.Desc)
    self.helpTip:SetTitle(staticData.Title)
  end)
end

function TipLabelCell:_DeInitExtraDescHelpBtn()
  if self.extraDescHelpButton and not Slua.IsNull(self.extraDescHelpButton) then
    GameObject.Destroy(self.extraDescHelpButton)
    self.extraDescHelpButton = nil
    self.extraHelpButton = nil
  end
end

function TipLabelCell:_DeInitExtraDesc()
  if self.extraDescCell and not Slua.IsNull(self.extraDescCell) then
    GameObject.Destroy(self.extraDescCell)
    self.extraDescCell = nil
    self.extraDescLab = nil
  end
end

function TipLabelCell:RePosition()
  if self.gameObject.activeInHierarchy then
    self.table:Reposition()
  else
    self.table.repositionNow = true
  end
end

function TipLabelCell:TryHandleClickUrl(label, text)
  local labObj, hasUrl = label.gameObject, string.match(text, "%[url=")
  if hasUrl then
    UIUtil.TryAddClickUrlCompToGameObject(labObj, self.data.clickurlcallback)
  else
    UIUtil.TryRemoveClickUrlCompFromGameObject(labObj)
  end
end

function TipLabelCell:TryHandleInlineButton(spriteLabel)
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

function TipLabelCell:MakeSpriteLabel(width, labwidth, iconwidth, iconheight, number)
  local labObj, labComp = self:CopyGameObject(self.labelPfb)
  labObj:SetActive(true)
  labObj.name = string.format("Label%02d", number or 0)
  labComp = labObj:GetComponent(UILabel)
  if TipLabelCell.defaultLabwidth then
    labComp.width = TipLabelCell.defaultLabwidth
  end
  if labwidth then
    labComp.width = labwidth
  end
  labComp.fontSize = self.data.fontsize or defaultLabelFontSize
  return SpriteLabel.new(labObj, width, iconwidth, iconheight, true)
end

function TipLabelCell:MakeNameValuePair(name, data)
  local p
  if data and data.isMemory then
    p = TipLabelNameValuePair_Memory.new(self:LoadPreferb("cell/TipLabelNameValuePair_Memory", self.gameObject))
  else
    p = TipLabelNameValuePair.new(self:LoadPreferb("cell/TipLabelNameValuePair", self.gameObject))
  end
  if p then
    p.gameObject.name = name
    p:SetData(data)
  end
  return p
end

function TipLabelCell:SetLabelColor(label, color)
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

function TipLabelCell:CheckIsNameValuePair(element)
  return type(element) == "table" and element.name ~= nil and element.value ~= nil
end
