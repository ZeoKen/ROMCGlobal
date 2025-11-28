autoImport("AstralPrayProCell")
autoImport("AstralPrayBuffEffectCell")
autoImport("AstralPrayTeamBuffCell")
AstralPrayPopUp = class("AstralPrayPopUp", ContainerView)
AstralPrayPopUp.ViewType = UIViewType.PopUpLayer
local BuffBgName = "ui_DMJ_Bg8"

function AstralPrayPopUp:Init()
  self:InitData()
  self:FindObjs()
  if RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_ASTRAL_NEW_SEASON_PRAY) then
    RedTipProxy.Instance:SeenNew(SceneTip_pb.EREDSYS_ASTRAL_NEW_SEASON_PRAY)
  end
end

function AstralPrayPopUp:InitData()
  local groupId = self.viewdata and self.viewdata.viewdata
  if groupId then
    local diffs = PveEntranceProxy.Instance:GetDifficultyData(groupId)
    if diffs then
      local pvePassInfo = diffs[1]
      self.raidName = pvePassInfo.staticEntranceData.name
      self.prayProGroupId = pvePassInfo.astral_pray_group
      self.teamPrayId = pvePassInfo.astral_pray_id
    end
  else
    local raidId = Game.MapManager:GetRaidID()
    local mapRaidConf = Table_MapRaid[raidId]
    self.raidName = mapRaidConf and mapRaidConf.NameZh or ""
    self.teamPrayId = AstralProxy.Instance:GetTeamPrayId()
    self.prayProGroupId = AstralProxy.Instance:GetPrayGroup()
  end
end

function AstralPrayPopUp:FindObjs()
  self.titleLabel = self:FindComponent("Title", UILabel)
  local helpBtn = self:FindGO("HelpBtn")
  self:RegistShowGeneralHelpByHelpID(32621, helpBtn)
  local grid = self:FindComponent("ProGrid", UIGrid)
  self.proListCtrl = UIGridListCtrl.new(grid, AstralPrayProCell, "AstralPrayProCell")
  self.teamBuffBg = self:FindComponent("TeamBuffBg", UITexture)
  self.teamBuffIcon = self:FindComponent("BuffIcon", UISprite)
  self.teamBuffName = self:FindComponent("BuffName", UILabel)
  grid = self:FindComponent("BuffEffectGrid", UIGrid)
  self.buffEffectListCtrl = UIGridListCtrl.new(grid, AstralPrayBuffEffectCell, "AstralPrayBuffEffectCell")
  self.levelBuffGrid = self:FindComponent("LevelBuffGrid", UIGrid)
  self.levelBuffListCtrl = UIGridListCtrl.new(self.levelBuffGrid, AstralPrayTeamBuffCell, "AstralPrayTeamBuffCell")
end

function AstralPrayPopUp:OnEnter()
  PictureManager.Instance:SetAstralTexture(BuffBgName, self.teamBuffBg)
  self.titleLabel.text = self.raidName
  local curSeason = AstralProxy.Instance:GetSeason()
  local config = Table_AstralSeason[curSeason]
  if config then
    local proGroup = AstralProxy.Instance:GetPrayedBranches(self.prayProGroupId)
    if proGroup then
      local pros = ReusableTable.CreateArray()
      for i = 1, #proGroup do
        local branchId = proGroup[i]
        pros[#pros + 1] = branchId
      end
      local myPro = MyselfProxy.Instance:GetMyProfession()
      local myBranch = Table_Class[myPro] and Table_Class[myPro].TypeBranch
      local depth = ProfessionProxy.GetJobDepth(myPro)
      table.sort(pros, function(l, r)
        if 1 < depth and (l == myBranch or r == myBranch) then
          return l == myBranch
        end
        return l < r
      end)
      self.proListCtrl:ResetDatas(pros)
      ReusableTable.DestroyArray(pros)
    end
    local buffs = config.ProfessionPrayBuff
    if buffs then
      self.buffEffectListCtrl:ResetDatas(buffs)
    end
    local prayConfig = Table_AstralPray[self.teamPrayId]
    if prayConfig then
      self.teamBuffIcon.spriteName = prayConfig.BuffIcon
      local buffDesc = prayConfig.BuffDesc
      local buffId = buffDesc and buffDesc[1]
      local buffConfig = Table_Buffer[buffId]
      if buffConfig then
        self.teamBuffName.text = buffConfig.BuffName
      end
      if prayConfig.BuffDesc then
        local datas = ReusableTable.CreateArray()
        local myTeamMembers = TeamProxy.Instance:GetMyTeamMemberList()
        local prayedNum = 0
        if myTeamMembers then
          local checkedBranch = {}
          for i = 1, #myTeamMembers do
            local member = myTeamMembers[i]
            local pro = member.profession
            local branch = ProfessionProxy.GetTypeBranchFromProf(pro)
            if not checkedBranch[branch] and AstralProxy.Instance:IsProAstralPrayed(pro, self.prayProGroupId) then
              prayedNum = prayedNum + 1
              checkedBranch[branch] = 1
            end
          end
        end
        for i = 1, #prayConfig.BuffDesc do
          local data = {}
          local buffId = prayConfig.BuffDesc[i]
          data.buffId = buffId
          data.prayedNum = prayedNum
          datas[#datas + 1] = data
        end
        self.levelBuffListCtrl:ResetDatas(datas)
        self.levelBuffGrid.enabled = false
        ReusableTable.DestroyArray(datas)
        local cells = self.levelBuffListCtrl:GetCells()
        local offset = 0
        for i = 1, #cells do
          local cell = cells[i]
          local x, y, z = LuaGameObject.GetLocalPositionGO(cell.gameObject)
          LuaGameObject.SetLocalPositionGO(cell.gameObject, x, y - offset, z)
          local line = cell.lineCount
          if 1 < line then
            offset = offset + (line - 1) * self.levelBuffGrid.cellHeight
          end
        end
      end
    end
  end
end

function AstralPrayPopUp:OnExit()
  PictureManager.Instance:UnloadAstralTexture(BuffBgName, self.teamBuffBg)
end
