GuildOpenRaidDialog = class("GuildOpenRaidDialog", ContainerView)
GuildOpenRaidDialog.ViewType = UIViewType.DialogLayer
autoImport("NpcMenuBtnCell")
autoImport("DialogCell")
autoImport("Dialog_MenuData")
GuildOpenRaidFuncTag = {OpenRaid = 1, GoReady = 2}
local curSerTime = ServerTime.CurServerTime

function GuildOpenRaidDialog:Init()
  self:InitView()
  self:MapEvent()
end

function GuildOpenRaidDialog:InitView()
  self.menu = self:FindGO("Menu")
  self.menuSprite = self.menu:GetComponent(UISprite)
  self.menuSprite.enabled = true
  local bottom = self:FindGO("Anchor_bottom")
  local obj = self:LoadPreferb("cell/DialogCell", bottom)
  obj.transform.localPosition = LuaVector3.Zero()
  self.dialogCtl = DialogCell.new(obj)
  self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickDialogEvent, self)
  local grid = self:FindChild("MenuGrid", self.menu):GetComponent(UIGrid)
  self.menuCtl = UIGridListCtrl.new(grid, NpcMenuBtnCell, "NpcMenuBtnCell")
  self.menuCtl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self)
end

function GuildOpenRaidDialog:ClickDialogEvent(cellCtl)
  self:CloseSelf()
end

function GuildOpenRaidDialog:ClickMenuEvent(cellCtl)
  local cellData = cellCtl.data
  if not cellData then
    return
  end
  local menuType = cellData.menuType
  local npcinfo = self:GetCurNpc()
  if menuType == Dialog_MenuData_Type.NpcFunc then
    local stay = FunctionNpcFunc.Me():DoNpcFunc(cellData.npcFuncData, npcinfo, cellData.param)
    if not stay then
      self:CloseSelf(self)
    end
  end
end

function GuildOpenRaidDialog:UpdateDialog()
  if not self.dialogData then
    self.dialogData = {}
  else
    TableUtility.TableClear(self.dialogData)
  end
  local npc = self:GetCurNpc()
  local npcid = next(GameConfig.GuildRaid)
  self.dialogData.Speaker = npc.data.staticData.id
  self.dialogData.NoSpeak = true
  local guildGateInfo = GuildProxy.Instance:GetGuildGateInfoByNpcId(npcid)
  if guildGateInfo then
    self.dialogData.Text = ZhString.GuildOpenRaidDialog_OpenFuben_Dialog
  else
    self.dialogData.Text = ""
  end
  self.dialogCtl:SetData(self.dialogData)
end

function GuildOpenRaidDialog:UpdateMenuData()
  if not self.menuData then
    self.menuData = {}
  else
    TableUtility.TableClear(self.menuData)
  end
  local npc = self:GetCurNpc()
  local npcfunc = npc.data.staticData.NpcFunction
  for i = 1, #npcfunc do
    local typeid, param, name = npcfunc[i].type, npcfunc[i].param, npcfunc[i].name
    local npcFuncData = typeid and Table_NpcFunction[typeid]
    if npcFuncData then
      local isImplemented = FunctionNpcFunc.Me():getFunc(typeid)
      if isImplemented and FunctionUnLockFunc.Me():CheckCanOpenByPanelId(typeid) then
        local npcinfo = self:GetCurNpc()
        local state, othername = FunctionNpcFunc.Me():CheckFuncState(npcFuncData.NameEn, npcinfo, param)
        local canShow = self:CheckOpenNpcFuncState(npcFuncData)
        if canShow and state == NpcFuncState.Active or state == NpcFuncState.Grey then
          local temp = {}
          temp.state = state
          temp.menuType = Dialog_MenuData_Type.NpcFunc
          temp.name = othername or name or npcFuncData.NameZh
          temp.npcFuncData = npcFuncData
          temp.param = param
          table.insert(self.menuData, temp)
        end
      end
    end
  end
  if #self.menuData > 0 then
    self.menu:SetActive(true)
    self.menuCtl:ResetDatas(self.menuData)
    self.menuSprite.height = 60 + #self.menuData * 70
  else
    self.menu:SetActive(false)
  end
end

function GuildOpenRaidDialog:CheckOpenNpcFuncState(npcFuncData)
  if npcFuncData.Type == "Common_GuildRaid" then
    local _, config = next(GameConfig.GuildRaid)
    local limitedLv = config.GuildLevel
    return npcFuncData.NameEn == "OpenGuildGate" and GuildProxy.Instance.myGuildData.level >= config.GuildLevel
  end
  return true
end

function GuildOpenRaidDialog:MapEvent()
end

function GuildOpenRaidDialog:OnEnter()
  GuildOpenRaidDialog.super.OnEnter(self)
  local npcinfo = self.viewdata.viewdata.npcInfo
  if npcinfo ~= nil then
    self.npcguid = npcinfo.data.id
    local viewPort = CameraConfig.NPC_Dialog_ViewPort
    local duration = CameraConfig.NPC_Dialog_DURATION
    local npcTrans = npcinfo.assetRole.completeTransform
    self:CameraFocusOnNpc(npcTrans, viewPort, duration)
  end
  self:UpdateDialog()
  self:UpdateMenuData()
end

function GuildOpenRaidDialog:GetCurNpc()
  if self.npcguid then
    return NSceneNpcProxy.Instance:Find(self.npcguid)
  end
  return nil
end

function GuildOpenRaidDialog:OnExit()
  GuildOpenRaidDialog.super.OnExit(self)
  self:CameraReset()
end
