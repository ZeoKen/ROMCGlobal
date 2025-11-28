local btnSp = {
  "com_btn_13s",
  "com_btn_3"
}
local labelColor = {"505050", "166C01"}
autoImport("WrapCellHelper")
autoImport("DialogCell")
BaseGuildPrayDialog = class("BaseGuildPrayDialog", ContainerView)

function BaseGuildPrayDialog:Init()
  local npc = self.viewdata.viewdata.npcdata
  self.npcguid = npc.data.id
  self:InitUI()
  self:AddMapEvent()
end

function BaseGuildPrayDialog:AddMapEvent()
  self:AddListenEvt(ServiceEvent.GuildCmdGuildPrayNtfGuildCmd, self.HandleNtfGuildCmd)
  self:AddListenEvt(ItemEvent.ItemUpdate, self._updateCoins)
  self:AddListenEvt(MyselfEvent.MyDataChange, self._updateCoins)
  self:AddListenEvt(SceneGlobalEvent.Map2DChanged, self.CloseSelf)
end

function BaseGuildPrayDialog:GetCurNpc()
  if not self.nnpc and self.npcguid then
    self.nnpc = NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return self.nnpc
end

function BaseGuildPrayDialog:GetNpcID()
  if not self.npcid then
    local npc = self:GetCurNpc()
    if npc then
      self.npcid = npc and npc.data and npc.data.staticData and npc.data.staticData.id
    end
  end
  return self.npcid
end

function BaseGuildPrayDialog:SetPrayBtnInvalid(var)
  self.invalid = var
  local sp = var and btnSp[1] or btnSp[2]
  self.prayButton.spriteName = sp
  local c = var and labelColor[1] or labelColor[2]
  local _, rc = ColorUtil.TryParseHexString(c)
  if _ then
    self.prayButtonLab.effectColor = rc
  end
end

function BaseGuildPrayDialog:UpdateMaxToggleCenter(center)
  if center then
    self.prayButton.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(470, 100, 0)
  else
    self.prayButton.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(470, 72, 0)
  end
  if self.maxPrayTog then
    self.maxPrayTog.gameObject:SetActive(not center)
  end
end

function BaseGuildPrayDialog:InitUI()
  self.mask = self:FindGO("Mask")
  self.prayButton = self:FindComponent("PrayButton", UISprite)
  self.prayButtonLab = self:FindComponent("Label", UILabel, self.prayButton.gameObject)
  self:AddClickEvent(self.prayButton.gameObject, function(go)
    self:OnClickPray()
  end)
  self.prayDialog = self:FindGO("PrayDialog")
  self.prayDialog = DialogCell.new(self.prayDialog)
  self:ActiveLock(false)
end

function BaseGuildPrayDialog:ActiveLock(b)
  self.mask:SetActive(b)
  self.lockState = b
end

function BaseGuildPrayDialog:OnClickPray()
end

function BaseGuildPrayDialog:InitPray()
end

function BaseGuildPrayDialog:_updatePrayGrid()
end

function BaseGuildPrayDialog:_updateCoins()
end

function BaseGuildPrayDialog:_updateDialogContent()
end

function BaseGuildPrayDialog:HandleNtfGuildCmd(note)
  self:_updatePrayGrid()
  self:_updateCoins()
  self:_updateDialogContent()
end

function BaseGuildPrayDialog:OnEnter()
  BaseGuildPrayDialog.super.OnEnter(self)
  local npcInfo = self:GetCurNpc()
  if not npcInfo then
    return
  end
  local viewPort = CameraConfig.Guild_Pray_ViewPort
  local rotation = CameraConfig.Guild_Pray_Rotation
  local npcRootTrans = npcInfo.assetRole.completeTransform
  self:CameraFocusAndRotateTo(npcRootTrans, viewPort, rotation)
end

function BaseGuildPrayDialog:OnExit()
  BaseGuildPrayDialog.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
  self:CameraReset()
end
