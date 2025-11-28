autoImport("QuickUsePopupFuncCell")
MainUseEquipPopup = class("MainUseEquipPopup", SubView)

function MainUseEquipPopup:Init()
  if not self.quickPopUp then
    local rightBottomHide = self:FindChild("RightBottomHide")
    local path = ResourcePathHelper.UIPopup("QuickUsePopup")
    local popup = Game.AssetManager_UI:CreateAsset(path, rightBottomHide)
    popup.transform.localPosition = LuaGeometry.GetTempVector3()
    self.quickPopUp = QuickUsePopupFuncCell.new(popup)
  end
  self.quickPopUp:Hide()
  self:AddViewListener()
  self:InitShow()
end

function MainUseEquipPopup:AddViewListener()
  self.quickPopUp:AddEventListener(UIEvent.CloseUI, self.QuickPopupCloseHandler, self)
  self:AddListenEvt(TriggerEvent.AddTrigger, self.TriggerEnterAreaHandler)
  self:AddListenEvt(TriggerEvent.RemoveTrigger, self.TriggerExitAreaHandler)
  self:AddListenEvt(QuestEvent.QuestEnterArea, self.QuestEnterAreaHandler)
  self:AddListenEvt(QuestEvent.QuestExitArea, self.QuestExitAreaHandler)
  self:AddListenEvt(ItemEvent.BetterEquipAdd, self.BetterEquipAddHandler)
  self:AddListenEvt(QuickUseProxy.CommonUseEvent, self.CommonAddHandler)
  self:AddListenEvt(SkillEvent.SkillWithUseTimesChanged, self.SkillUseChange)
  self:AddListenEvt(ItemEvent.ItemUseTip, self.HandleItemUseTip)
  self:AddListenEvt(PetEvent.AddCatchPetBord, self.HandleAddCatchPetBord)
  self:AddListenEvt(PetEvent.RemoveCatchPetBord, self.HandleRemoveCatchPetBord)
  self:AddListenEvt(ItemEvent.ItemUpdate, self.HandleItemUpdate)
  self:AddListenEvt(TriggerEvent.Enter_TwelvePVPShopTrigger, self.EnterTwelvePVPShop)
  self:AddListenEvt(TriggerEvent.Remove_TwelvePVPShopTrigger, self.ExitTwelvePVPShop)
  self:AddListenEvt(StealthGameEvent.Item_UseTip, self.onShowUseTipInStealthGame)
  self:AddListenEvt(PVEEvent.DemoRaid_Launch, self.HandleDemoRaidLaunch)
  self:AddListenEvt(PVEEvent.DemoRaidRaid_Shutdown, self.HandleDemoRaidShutDown)
end

function MainUseEquipPopup:InitShow()
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:QuickPopupCloseHandler(evt)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:CommonAddHandler(evt)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:BetterEquipAddHandler(note)
  local data = QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1]
  if HomeManager.Me():IsInEditMode() and data and data.data and data.type == QuickUseProxy.Type.Item and type(data.data) == "table" and Table_HomeFurnitureMaterial[data.data.staticData.id] then
    return
  end
  self.quickPopUp:SetData(data)
end

function MainUseEquipPopup:QuestEnterAreaHandler(note)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:QuestExitAreaHandler(note)
  if note.body == self.quickPopUp.data then
    self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
  end
end

function MainUseEquipPopup:TriggerEnterAreaHandler(note)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:TriggerExitAreaHandler(note)
  if note.body == self.quickPopUp.data then
    self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
  end
end

function MainUseEquipPopup:SkillUseChange(note)
  local data = self.quickPopUp.data
  if data and type(data) == "table" then
    local skilldata = data and data.data or nil
    if data and skilldata and skilldata.id and skilldata.id == note.body then
      self.quickPopUp:Refresh()
    end
  end
end

function MainUseEquipPopup:HandleItemUseTip(note)
  self.quickPopUp:SetData(note.body)
end

function MainUseEquipPopup:HandleAddCatchPetBord(note)
  local data = QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1]
  self.quickPopUp:SetData(data)
end

function MainUseEquipPopup:HandleRemoveCatchPetBord(note)
  local npcguid = note.body
  local data = self.quickPopUp.data
  if npcguid ~= nil and data ~= nil and npcguid == data[1] then
    self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
  end
end

function MainUseEquipPopup:HandleItemUpdate()
  self.quickPopUp:RefreshNum()
end

function MainUseEquipPopup:EnterTwelvePVPShop(note)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end

function MainUseEquipPopup:ExitTwelvePVPShop(note)
  if note.body == self.quickPopUp.data then
    self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
  end
end

function MainUseEquipPopup:onShowUseTipInStealthGame(value)
  self.quickPopUp:SetStealthGameData(value.body.data, value.body.type)
end

function MainUseEquipPopup:HandleDemoRaidLaunch(note)
  self.quickPopUp:Hide()
end

function MainUseEquipPopup:HandleDemoRaidShutDown(note)
  self.quickPopUp:SetData(QuickUseProxy.Instance:GetFirstNotEmptyQueue()[1])
end
