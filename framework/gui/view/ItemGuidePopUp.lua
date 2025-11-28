ItemGuidePopUp = class("ItemGuidePopUp", BaseView)
ItemGuidePopUp.ViewType = UIViewType.PopUpLayer

function ItemGuidePopUp:Init()
  local viewData = self.viewdata.viewdata
  self.itemId = viewData and viewData.ID
  self:FindObjs()
  self:AddEvts()
  self:InitShow()
end

function ItemGuidePopUp:FindObjs()
  self.contentLabel = self:FindGO("ContentLabel"):GetComponent(UILabel)
  self.comfirmBtn = self:FindGO("ConfirmBtn")
  self.confirmBtnIcon = self.comfirmBtn:GetComponent(UISprite)
  self.confirmBtnLabel = self:FindGO("ConfirmLabel", self.comfirmBtn):GetComponent(UILabel)
end

function ItemGuidePopUp:AddEvts()
  self:AddClickEvent(self.comfirmBtn, function()
    self:HandleClickConfirmBtn()
  end)
end

function ItemGuidePopUp:InitShow()
  self.data = Table_ItemRef[self.itemId]
  if not self.data then
    redlog("ItemRef表缺少道具id", self.itemId)
    return
  end
  self.lockType = self.data.LockType
  if self.lockType == 1 then
    self.contentLabel.text = self.data.LockDesc
    self.confirmBtnIcon.spriteName = "new-com_btn_a"
    self.confirmBtnLabel.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1)
    self.confirmBtnLabel.text = ZhString.FloatAwardView_Confirm
  elseif self.lockType == 2 then
    self.confirmBtnIcon.spriteName = "new-com_btn_c"
    self.confirmBtnLabel.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1)
    self.confirmBtnLabel.text = ZhString.WorldMapMenuPopUp_MoveTo
    local t, questData = ReusableTable.CreateArray()
    local params = self.data.Params
    local targetQuestId = params.questid
    if targetQuestId then
      local servantQuestStepList = Table_ServantQuestfinishStep[targetQuestId]
      if servantQuestStepList then
        local stepList = servantQuestStepList.QuestStep
        if stepList and 0 < #stepList then
          for i = 1, #stepList do
            questData = QuestProxy.Instance:GetQuestDataBySameQuestID(stepList[i])
            if questData then
              TableUtility.ArrayPushBack(t, questData)
            end
          end
        end
      end
    end
    if t[1] then
      local questName = t[1].traceTitle or t[1].traceInfo or ""
      local questMap = t[1].map
      local mapData = questMap and Table_Map[questMap]
      local toMap = "/"
      if mapData then
        toMap = mapData.CallZh
      end
      self.contentLabel.text = string.format(ZhString.FunctionItemFunc_QuestTypeGuide, questName, toMap)
      self.questData = t[1]
    else
      self.contentLabel.text = self.data.LockDesc
    end
    ReusableTable.DestroyAndClearArray(t)
  end
end

function ItemGuidePopUp:HandleClickConfirmBtn()
  if not self.data then
    return
  end
  if self.lockType == 1 then
    self:CloseSelf()
  elseif self.lockType == 2 then
    if self.questData then
      FuncShortCutFunc.Me():CallByQuestFinishID(nil, nil, self.questData)
    else
      local params = self.data.Params
      local shortCutPowerId = params and params.shortcutpower
      if shortCutPowerId then
        FuncShortCutFunc.Me():CallByID(shortCutPowerId)
      end
    end
    self:CloseSelf()
  end
end
