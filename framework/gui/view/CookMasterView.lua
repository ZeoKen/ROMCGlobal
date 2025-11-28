CookMasterView = class("CookMasterView", ContainerView)
CookMasterView.ViewType = UIViewType.NormalLayer
autoImport("CookMasterMaterialCell")
autoImport("CookMasterTipCell")
autoImport("CharactorPlayerHeadCell")

function CookMasterView:Init()
  self:FindObjs()
  self:AddViewEvts()
  self:AddEvts()
  self:InitData()
end

function CookMasterView:FindObjs()
  self.mainTitle = self:FindGO("Title"):GetComponent(UILabel)
  self.helpBtn = self:FindGO("HelpBtn")
  self.closeBtn = self:FindGO("CloseBtn")
  self.materialGrid = self:FindGO("MaterialGrid"):GetComponent(UIGrid)
  self.materialGridCtrl = UIGridListCtrl.new(self.materialGrid, CookMasterMaterialCell, "CookMasterMaterialCell")
  self.materialGridCtrl:AddEventListener(MouseEvent.MouseClick, self.chooseMaterial, self)
  self.showTipBtn = self:FindGO("ShowTipBtn")
  self.showTipBtn_Forbid = self:FindGO("Forbid", self.showTipBtn)
  self.startCookBtn = self:FindGO("StartCookBtn")
  self.statrCookBtn_BoxCollider = self.startCookBtn:GetComponent(BoxCollider)
  self.startCookBtn_Grey = self:FindGO("StartCookBtn_Grey")
  self.gameStatusTip = self:FindGO("GameStatusTip")
  self.gameStatusTipLabel = self:FindGO("Label", self.gameStatusTip):GetComponent(UILabel)
  local playerPanel = self:FindGO("PlayerPanel")
  local headContainer = self:FindGO("HeadContainer", playerPanel)
  self.targetCell = CharactorPlayerHeadCell.new(headContainer)
  self.targetCell:HideHpMp()
  self.targetCell:HideLevel()
  local headData = HeadImageData.new()
  headData:TransByMyself()
  headData.frame = nil
  headData.job = nil
  self.targetCell:SetData(headData)
  self.playerReadyToCook = self:FindGO("ReadyToCook", playerPanel)
  self.playerChooseStyleBtn = self:FindGO("ChooseStyleBtn", playerPanel)
  self.playerChooseStyleBtn_SwitchSymbol = self:FindGO("SwitchSymbol", self.playerChooseStyleBtn)
  self.playerChooseStyleBtn_BoxCollider = self.playerChooseStyleBtn:GetComponent(BoxCollider)
  self.playerChooseStyleBtn_Icon = self:FindGO("Icon", self.playerChooseStyleBtn):GetComponent(UISprite)
  self.playerChooseStyleBtn_ClickTip = self:FindGO("ClickTip", self.playerChooseStyleBtn)
  self.playerMaterialList = self:FindGO("MaterialList", playerPanel)
  self.playerMaterialCells = {}
  for i = 1, 5 do
    self.playerMaterialCells[i] = {}
    local go = self:FindGO("MaterialCell" .. i, self.playerMaterialList)
    self.playerMaterialCells[i].icon = self:FindGO("Icon", go):GetComponent(UISprite)
    self.playerMaterialCells[i].add = self:FindGO("Add", go)
    self.playerMaterialCells[i].chooseSymbol = self:FindGO("ChooseSymbol", go)
  end
  local enemyPanel = self:FindGO("EnemyPanel")
  self.enemyHeadIcon = self:FindGO("EnemyHeadIcon", enemyPanel):GetComponent(UISprite)
  self.enemyReadyToCook = self:FindGO("ReadyToCook", enemyPanel)
  self.enemyReadyToCook_Icon = self:FindGO("Icon", self.enemyReadyToCook):GetComponent(UISprite)
  self.enemyChooseStyleBtn = self:FindGO("ChooseStyleBtn", enemyPanel)
  self.enemyChooseStyleBtn_SwitchSymbol = self:FindGO("SwitchSymbol", self.enemyChooseStyleBtn)
  self.enemyChooseStyleBtn_BoxCollider = self.enemyChooseStyleBtn:GetComponent(BoxCollider)
  self.enemyChooseStyleBtn_Icon = self:FindGO("Icon", self.enemyChooseStyleBtn):GetComponent(UISprite)
  self.enemyChooseStyleBtn_ClickTip = self:FindGO("ClickTip", self.enemyChooseStyleBtn)
  self.enemyMaterialList = self:FindGO("MaterialList", enemyPanel)
  self.enemyMaterialCells = {}
  for i = 1, 5 do
    self.enemyMaterialCells[i] = {}
    local go = self:FindGO("MaterialCell" .. i, self.enemyMaterialList)
    self.enemyMaterialCells[i].icon = self:FindGO("Icon", go):GetComponent(UISprite)
    self.enemyMaterialCells[i].add = self:FindGO("Add", go)
    self.enemyMaterialCells[i].chooseSymbol = self:FindGO("ChooseSymbol", go)
  end
  self.clickCollider = self:FindGO("ClickBoxCollider"):GetComponent(BoxCollider)
  self.clickCollider.enabled = false
  self.movementTip = self:FindGO("MovementTip")
  self.movementTip_Icon = self.movementTip:GetComponent(UISprite)
  self.movementTip_TweenPos = self.movementTip:GetComponent(TweenPosition)
  self.movementTip_TweenPos:SetOnFinished(function()
    self.movementTip:SetActive(false)
    self:UpdatePage()
    self.clickCollider.enabled = not CookMasterManager.Me():GetCurTurn()
  end)
  self.chooseCookStylePanel = self:FindGO("ChooseCookStylePanel")
  self.cookStyleGrid = self:FindGO("StyleGrid"):GetComponent(UIGrid)
  self.cookStyleBtns = {}
  self.styleBtn1 = self:FindGO("Btn1")
  self.styleBtn2 = self:FindGO("Btn2")
  self.styleBtn3 = self:FindGO("Btn3")
  self.styleBtn4 = self:FindGO("Btn4")
  self.cookTipsPanel = self:FindGO("CookTipsPanel")
  self.cookTipsCloseBtn = self:FindGO("Close", self.cookTipsPanel)
  self.cookTipTitle = self:FindGO("TipLabel", self.cookTipsPanel)
  self.cookTipScrollView = self:FindGO("TipsScrollView"):GetComponent(UIScrollView)
  self.cookTipGrid = self:FindGO("TipGrid"):GetComponent(UIGrid)
  self.cookTipListCtrl = UIGridListCtrl.new(self.cookTipGrid, CookMasterTipCell, "CookMasterTipCell")
  self.showTipBtnGuide = self:FindGO("ShowTipBtnGuide")
end

function CookMasterView:AddViewEvts()
  self:TryOpenHelpViewById(35056, nil, self.helpBtn)
  self:AddClickEvent(self.closeBtn, function(go)
    CookMasterManager.Me():CheckGuideQuest(false)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.showTipBtn, function(go)
    if self.tipsValid then
      self.cookTipsPanel:SetActive(true)
      if self.inMode7 then
        self.showTipBtnGuide:SetActive(false)
      end
    else
      MsgManager.ShowMsgByID(28096)
    end
  end)
  self:AddClickEvent(self.cookTipsCloseBtn, function(go)
    self.cookTipsPanel:SetActive(false)
  end)
  self:AddClickEvent(self.startCookBtn, function(go)
    CookMasterManager.Me():GetResult()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.playerChooseStyleBtn, function(go)
    self.chooseCookStylePanel:SetActive(true)
  end)
  self:AddClickEvent(self.enemyChooseStyleBtn, function(go)
    self.chooseCookStylePanel:SetActive(true)
  end)
  for i = 1, 4 do
    self:AddClickEvent(self["styleBtn" .. i], function(go)
      xdlog("点选料理烹饪方式", i)
      self.chooseCookStylePanel:SetActive(false)
      self:ChooseCookStyle(i)
    end)
  end
end

function CookMasterView:AddEvts()
  self:AddListenEvt("CookMasterEnemyTurnEnd", self.enemyTurnEnd)
  self:AddListenEvt("CookMasterPlayerTurnEnd", self.playerTurnEnd)
  self:AddListenEvt("CookMasterEnemyCookStyleChooseEnd", self.HandleEnemyChooseCookStyle)
end

function CookMasterView:InitData()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local param = viewdata and viewdata.params or 0
  self.questData = viewdata and viewdata.questData
  if self.questData then
    self.enemyid = self.questData.params.npc or 817407
    self.enemyData = Table_Npc[self.enemyid]
  else
    self.enemyid = 817407
    self.enemyData = Table_Npc[self.enemyid]
  end
  IconManager:SetNpcMonsterIconByID(self.enemyid, self.enemyHeadIcon)
  self.inMode7 = param == 7
  if self.inMode7 then
    CookMasterManager.Me():GameStart7(self.questData)
    CookMasterManager.Me():RefreshAvailableFoodRecipe7()
    CookMasterManager.Me():SetGameRule7(param)
  else
    CookMasterManager.Me():GameStart()
    CookMasterManager.Me():RefreshAvailableFoodRecipe()
    CookMasterManager.Me():SetGameRule(param)
  end
  CookMasterManager.Me():SetEnemyID(self.enemyid)
  self:UpdatePage()
  self:InitTipPage()
  self.tipsValid = self.inMode7 or FunctionUnLockFunc.Me():CheckCanOpen(11033)
  self.showTipBtn_Forbid:SetActive(not self.tipsValid)
  self.showTipBtnGuide:SetActive(self.inMode7)
end

function CookMasterView:UpdatePage()
  local playerName = Game.Myself.data:GetName()
  local enemyName = self.enemyData.NameZh
  local playerSelect = CookMasterManager.Me():GetPlayerMaterialList()
  local gameRule = CookMasterManager.Me():GetExtraRule()
  local gameRound = CookMasterManager.Me():GetGameRound()
  local myTurn = CookMasterManager.Me():GetCurTurn()
  local _, extra = math.modf(gameRound / 2)
  if playerSelect then
    for i = 1, 5 do
      if i <= #playerSelect then
        self.playerMaterialCells[i].add:SetActive(false)
        self.playerMaterialCells[i].chooseSymbol:SetActive(false)
        if playerSelect[i] then
          local single = playerSelect[i].itemId
          local item = Table_Item[single]
          local icon = item.Icon
          IconManager:SetItemIcon(icon, self.playerMaterialCells[i].icon)
          self.playerMaterialCells[i].icon:MakePixelPerfect()
          self.playerMaterialCells[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
        end
      elseif i == #playerSelect + 1 then
        self.playerMaterialCells[i].add:SetActive(true)
        if myTurn then
          if gameRule == 1 and extra ~= 0 then
            self.playerMaterialCells[i].chooseSymbol:SetActive(false)
          else
            self.playerMaterialCells[i].chooseSymbol:SetActive(true)
          end
        elseif gameRule == 1 and extra ~= 0 then
          self.playerMaterialCells[i].chooseSymbol:SetActive(true)
        else
          self.playerMaterialCells[i].chooseSymbol:SetActive(false)
        end
      else
        self.playerMaterialCells[i].chooseSymbol:SetActive(false)
      end
    end
  end
  local enemySelect = CookMasterManager.Me():GetEnemyMaterialList()
  if enemySelect then
    for i = 1, 5 do
      if i <= #enemySelect then
        self.enemyMaterialCells[i].add:SetActive(false)
        self.enemyMaterialCells[i].chooseSymbol:SetActive(false)
        if enemySelect[i] then
          local single = enemySelect[i].itemId
          local item = Table_Item[single]
          local icon = item.Icon
          IconManager:SetItemIcon(icon, self.enemyMaterialCells[i].icon)
          self.enemyMaterialCells[i].icon:MakePixelPerfect()
          self.enemyMaterialCells[i].icon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
        end
      else
        self.enemyMaterialCells[i].add:SetActive(true)
        if i == #enemySelect + 1 then
          if not myTurn then
            if gameRule == 1 and extra ~= 0 then
              self.enemyMaterialCells[i].chooseSymbol:SetActive(false)
            else
              self.enemyMaterialCells[i].chooseSymbol:SetActive(true)
            end
          elseif gameRule == 1 and extra ~= 0 then
            self.enemyMaterialCells[i].chooseSymbol:SetActive(true)
          else
            self.enemyMaterialCells[i].chooseSymbol:SetActive(false)
          end
        else
          self.enemyMaterialCells[i].chooseSymbol:SetActive(false)
        end
      end
    end
  end
  local totalMaterials = CookMasterManager.Me():GetTotalMaterials()
  local leftMaterials = CookMasterManager.Me():GetLeftMaterials()
  self.materialGridCtrl:ResetDatas(leftMaterials)
  if myTurn then
    if gameRule == 1 then
      if extra ~= 0 then
        self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_SpecialRuleTip1, playerName, enemyName)
      else
        self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_PlayerTurnTip, playerName)
      end
    else
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_PlayerTurnTip, playerName)
    end
  elseif gameRule == 1 then
    if extra ~= 0 then
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_SpecialRuleTip1, enemyName, playerName)
    else
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_PlayerTurnTip, enemyName)
    end
  else
    self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_PlayerTurnTip, enemyName)
  end
  if gameRound <= 5 then
    self.playerReadyToCook:SetActive(true)
    self.enemyReadyToCook:SetActive(true)
    self.playerChooseStyleBtn:SetActive(false)
    self.enemyChooseStyleBtn:SetActive(false)
  else
    if gameRule == 2 then
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip2, playerName, enemyName)
    else
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip, playerName)
    end
    self.playerReadyToCook:SetActive(false)
    self.enemyReadyToCook:SetActive(false)
    self.playerChooseStyleBtn:SetActive(true)
    self.enemyChooseStyleBtn:SetActive(true)
    if gameRule == 2 then
      self.playerChooseStyleBtn_SwitchSymbol:SetActive(false)
      self.playerChooseStyleBtn_BoxCollider.enabled = false
      self.enemyChooseStyleBtn_SwitchSymbol:SetActive(true)
      self.enemyChooseStyleBtn_BoxCollider.enabled = true
      self.enemyChooseStyleBtn_ClickTip:SetActive(true)
    else
      self.playerChooseStyleBtn_SwitchSymbol:SetActive(true)
      self.playerChooseStyleBtn_BoxCollider.enabled = true
      self.enemyChooseStyleBtn_SwitchSymbol:SetActive(false)
      self.enemyChooseStyleBtn_BoxCollider.enabled = false
      self.playerChooseStyleBtn_ClickTip:SetActive(true)
    end
  end
  if gameRound <= 6 then
    self.startCookBtn_Grey:SetActive(true)
    self.startCookBtn:SetActive(false)
  else
    self.startCookBtn_Grey:SetActive(false)
    self.startCookBtn:SetActive(true)
  end
end

function CookMasterView:InitTipPage()
  local recipeList = CookMasterManager.Me():GetAvailableFoodRecipe()
  if self.inMode7 then
    recipeList = {
      CookMasterManager.Me().inMode7Data.params.recipe_id1
    }
    self.cookTipTitle:SetActive(false)
  end
  self.cookTipListCtrl:ResetDatas(recipeList)
end

function CookMasterView:chooseMaterial(cell)
  local playerSelect = CookMasterManager.Me():GetPlayerMaterialList()
  if playerSelect and 5 <= #playerSelect then
    redlog("已选完")
    return
  end
  local chooseItemid = cell.data.id
  xdlog("选取材料", chooseItemid, cell.indexInList)
  CookMasterManager.Me():PlayerTurn(cell.indexInList)
end

function CookMasterView:enemyTurnEnd()
  xdlog("回合结束")
  self:movementTipMove()
  CookMasterManager.Me():SetCurTurn(true)
  CookMasterManager.Me():NextRound()
end

function CookMasterView:playerTurnEnd()
  xdlog("我的回合结束")
  self:movementTipMove()
  CookMasterManager.Me():SetCurTurn(false)
  self.clickCollider.enabled = true
  TimeTickManager.Me():CreateOnceDelayTick(2000, function(owner, deltaTime)
    CookMasterManager.Me():EnemyTurn()
  end, 1)
end

function CookMasterView:ChooseCookStyle(id)
  CookMasterManager.Me():SetPlayerCookStyle(id)
  CookMasterManager.Me():SetCurTurn(false)
  self:RefreshCookStyle()
  self.playerChooseStyleBtn_ClickTip:SetActive(false)
  self.enemyChooseStyleBtn_ClickTip:SetActive(false)
  CookMasterManager.Me():SetEnemyCookStyle()
end

function CookMasterView:HandleEnemyChooseCookStyle()
  CookMasterManager.Me():NextRound()
  self:RefreshCookStyle()
end

function CookMasterView:RefreshCookStyle()
  local playerName = Game.Myself.data:GetName()
  local enemyName = self.enemyData.NameZh
  local gameRule = CookMasterManager.Me():GetExtraRule()
  local gameRound = CookMasterManager.Me():GetGameRound()
  local playerCookStyle = CookMasterManager.Me():GetPlayerCookStyle()
  local enemyCookStyle = CookMasterManager.Me():GetEnemyCookStyle()
  local myTurn = CookMasterManager.Me():GetCurTurn()
  xdlog(playerCookStyle, enemyCookStyle, myTurn, gameRound)
  if gameRound == 6 then
    if gameRule == 2 then
      if myTurn then
        self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip2, playerName, enemyName)
      else
        self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip2, enemyName, playerName)
      end
    elseif myTurn then
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip, playerName)
    else
      self.gameStatusTipLabel.text = string.format(ZhString.CookMaster_ChooseCookStyleTip, enemyName)
    end
  else
    self.gameStatusTipLabel.text = ZhString.CookMaster_ReadyToGO
  end
  local iconName
  self.playerChooseStyleBtn_Icon.spriteName = "food_icon_0" .. playerCookStyle
  self.enemyChooseStyleBtn_Icon.spriteName = "food_icon_0" .. enemyCookStyle
  if gameRound <= 6 then
    self.startCookBtn_Grey:SetActive(true)
    self.startCookBtn:SetActive(false)
  else
    self.startCookBtn_Grey:SetActive(false)
    self.startCookBtn:SetActive(true)
  end
end

function CookMasterView:movementTipMove()
  self.movementTip:SetActive(true)
  self.movementTip_TweenPos:ResetToBeginning()
  local myTurn = CookMasterManager.Me():GetCurTurn()
  local gameRule = CookMasterManager.Me():GetExtraRule()
  local gameRound = CookMasterManager.Me():GetGameRound()
  local _, extra = math.modf(gameRound / 2)
  local icon
  xdlog(myTurn, extra, extra ~= 0, gameRound)
  if myTurn then
    local playerSelect
    if gameRule == 1 then
      if extra ~= 0 then
        self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(470, -42, 0)
        playerSelect = CookMasterManager.Me():GetEnemyMaterialList()
      else
        self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(-470, -42, 0)
        playerSelect = CookMasterManager.Me():GetPlayerMaterialList()
      end
    else
      self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(-470, -42, 0)
      playerSelect = CookMasterManager.Me():GetPlayerMaterialList()
    end
    local target = playerSelect and playerSelect[#playerSelect]
    local single = target.itemId
    local item = Table_Item[single]
    icon = item.Icon
    IconManager:SetItemIcon(icon, self.movementTip_Icon)
    self.movementTip_Icon:MakePixelPerfect()
    self.movementTip.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
  else
    local enemySelect
    if gameRule == 1 then
      if extra ~= 0 then
        self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(-470, -42, 0)
        enemySelect = CookMasterManager.Me():GetPlayerMaterialList()
      else
        self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(470, -42, 0)
        enemySelect = CookMasterManager.Me():GetEnemyMaterialList()
      end
    else
      self.movementTip_TweenPos.to = LuaGeometry.GetTempVector3(470, -42, 0)
      enemySelect = CookMasterManager.Me():GetEnemyMaterialList()
    end
    local target = enemySelect and enemySelect[#enemySelect]
    local single = target.itemId
    local item = Table_Item[single]
    icon = item.Icon
    IconManager:SetItemIcon(icon, self.movementTip_Icon)
    self.movementTip_Icon:MakePixelPerfect()
    self.movementTip.transform.localScale = LuaGeometry.GetTempVector3(0.7, 0.7, 0.7)
  end
  self.movementTip_TweenPos:PlayForward()
end
