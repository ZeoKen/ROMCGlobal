UIListItemViewControllerVIPDescription = class("UIListItemViewControllerVIPDescription", BaseCell)

function UIListItemViewControllerVIPDescription:Init()
  self:GetGameObjects()
  self:SetEvent(self.goLab, function()
    if self.isFold then
      self:PassEvent(MouseEvent.MouseClick, self)
    end
  end)
end

function UIListItemViewControllerVIPDescription:SetData(data)
  self.gameObject:SetActive(true)
  self.depositFunctionConfID = data:GetDescriptionConfigID()
  self.headDress = data:GetHeadDress()
  self:GetModelSet()
  self:LoadView()
end

function UIListItemViewControllerVIPDescription:GetModelSet()
  self.depositFunctionConf = Table_DepositFunction[self.depositFunctionConfID]
end

function UIListItemViewControllerVIPDescription:GetGameObjects()
  self.goLab = self:FindGO("Lab", self.gameObject)
  self.goIndex = self:FindGO("Index", self.gameObject)
  self.lab = self.goLab:GetComponent(UILabel)
  self.goLabBc = self.goLab:GetComponent(BoxCollider)
  self.goLabDragScroll = self.goLab:GetComponent(UIDragScrollView)
  self.clickUrl = self.goLab:GetComponent(UILabelClickUrl)
  
  function self.clickUrl.callback(url)
    local tipData = {}
    tipData.itemdata = ItemData.new("Dress", tonumber(url))
    self:ShowItemTip(tipData, self.lab, NGUIUtil.AnchorSide.Left, {-220, 0})
  end
end

function UIListItemViewControllerVIPDescription:LoadView()
  self.desc = self:GetDepositDesc(self.depositFunctionConf)
  if self.isFold then
    self:SetFoldLab()
  else
    self.lab.text = self.desc .. "\n"
  end
  if self.hasLabelClickUrl or self.isFold then
    self.goLabBc.enabled = true
    self.goLabDragScroll.enabled = true
  else
    self.goLabBc.enabled = false
    self.goLabDragScroll.enabled = false
  end
  if self.isTitle then
    self.lab.fontSize = 22
    self.goIndex:SetActive(false)
    self.lab.transform.localPosition = LuaGeometry.GetTempVector3(-318, 12, 0)
  else
    self.lab.fontSize = 20
    self.goIndex:SetActive(true)
    self.lab.transform.localPosition = LuaGeometry.GetTempVector3(-286, 12, 0)
  end
end

function UIListItemViewControllerVIPDescription:GetDepositDesc(descConfig)
  self.hasLabelClickUrl = nil
  self.isTitle = nil
  if descConfig == nil then
    return ""
  end
  if descConfig.DescArgument == nil or #descConfig.DescArgument == 0 then
    return OverSea.LangManager.Instance():GetLangByKey(descConfig.Desc)
  end
  local tempArray = {}
  table.insert(tempArray, descConfig.Desc)
  local arg
  for i = 1, #descConfig.DescArgument do
    arg = descConfig.DescArgument[i]
    if arg == "ServerBaseSpeedUp" then
      local config = GameConfig.SpeedUp.base
      local deltaLv = config.normal.server_delta_lv - config.deposit_card.server_delta_lv
      local deltaRatio = config.deposit_card.server_add_per - config.normal.server_add_per
      local totalRatio = config.deposit_card.server_add_per
      arg = {
        deltaLv,
        deltaRatio,
        totalRatio
      }
      TableUtil.InsertArray(tempArray, arg)
    elseif arg == "ServerJobSpeedUp" then
      local config = GameConfig.SpeedUp.job
      local deltaLv = config.normal.server_delta_lv - config.deposit_card.server_delta_lv
      local deltaRatio = config.deposit_card.server_add_per - config.normal.server_add_per
      local totalRatio = config.deposit_card.server_add_per
      arg = {
        deltaLv,
        deltaRatio,
        totalRatio
      }
      TableUtil.InsertArray(tempArray, arg)
    elseif arg == "DiffJobSpeedUp" then
      local config = GameConfig.SpeedUp.job
      local deltaRatio = config.deposit_card.self_job_per - config.normal.self_job_per
      local totalRatio = config.deposit_card.self_job_per
      arg = {deltaRatio, totalRatio}
      TableUtil.InsertArray(tempArray, arg)
    else
      if arg == "HeadDress" then
        if self.headDress then
          self.hasLabelClickUrl = true
          arg = string.format("[url=%s][c][1F74BF] {%s} [-][/c][/url]", self.headDress, Table_Item[self.headDress].NameZh)
        end
      elseif arg == "Title" then
        self.isTitle = true
      elseif arg == "FoldTitle" then
        self.isTitle = true
        self.isFold = true
        self.foldState = false
      elseif arg == "Item" then
        local item_id = descConfig.DescArgument[i + 1]
        item_id = item_id and tonumber(item_id)
        if item_id then
          self.hasLabelClickUrl = true
          arg = string.format("[url=%s][c][1F74BF] {%s} [-][/c][/url]", item_id, Table_Item[item_id].NameZh)
        end
      end
      table.insert(tempArray, arg)
    end
  end
  return string.format(unpack(tempArray))
end

function UIListItemViewControllerVIPDescription:SwitchFoldState()
  self.foldState = not self.foldState
  self:SetFoldLab()
  return self.foldState
end

function UIListItemViewControllerVIPDescription:SetFoldLab()
  local suffix = self.foldState and " ▴" or " ▾"
  self.lab.text = self.desc .. suffix .. "\n"
end
