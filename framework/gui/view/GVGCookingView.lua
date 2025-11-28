autoImport("CostInfoCell2")
autoImport("GVGCookingItemView")
GVGCookingView = class("GVGCookingView", BaseView)
GVGCookingView.ViewType = UIViewType.NormalLayer
local CookBagTypes = {
  BagProxy.BagType.Food
}
local GameConfig_GvgRimConfig, DefaultGvgRimConfig

function GVGCookingView:Init()
  self:InitStaticData()
  self:FindObjs()
  self:InitEvents()
end

function GVGCookingView:InitStaticData()
  local nowSeason = GvgProxy.Instance:NowSeason()
  GameConfig_GvgRimConfig = GameConfig.GvgRimConfig.SeasonSpecial and GameConfig.GvgRimConfig.SeasonSpecial[nowSeason] or GameConfig.GvgRimConfig
  DefaultGvgRimConfig = GameConfig.GvgRimConfig
end

function GVGCookingView:FindObjs()
  self.m_uiCookingTypePage = self:FindGO("uiProgressRoot/uiImgBtnCookingEnable/uiImgCookingType")
  self.m_uiImgBtnClose = self:FindGO("uiImgBtnClose")
  self.m_uiImgBtnCookingEnable = self:FindGO("uiImgBtnCookingEnable")
  self.m_uiImgBtnCookingDisable = self:FindGO("uiImgBtnCookingDisable")
  self.m_uiImgBtnEat = self:FindGO("uiImgBtnEat")
  self.m_uiImgBtnEat_Collider = self.m_uiImgBtnEat:GetComponent(BoxCollider)
  self.m_uiImgBtnHelp = self:FindGO("uiProgressRoot/uiBgRoot/uiImgBtnI")
  self.m_uiImgBtnHeat = self:FindGO("uiProgressRoot/uiImgBtnCookingEnable/uiImgCookingType/uiImgBtnHeat")
  self.m_uiImgBtnSeasoning = self:FindGO("uiProgressRoot/uiImgBtnCookingEnable/uiImgCookingType/uiImgBtnSeasoning")
  self.m_uiImgBtnIngredients = self:FindGO("uiProgressRoot/uiImgBtnCookingEnable/uiImgCookingType/uiImgBtnIngredients")
  self.m_uiImgBtnHeatCount = self:FindComponent("Label2", UILabel, self.m_uiImgBtnHeat)
  self.m_uiImgBtnSeasoningCount = self:FindComponent("Label2", UILabel, self.m_uiImgBtnSeasoning)
  self.m_uiImgBtnIngredientsCount = self:FindComponent("Label2", UILabel, self.m_uiImgBtnIngredients)
  self.m_uiTxtSeasoning = self:FindGO("uiProgressRoot/uiImgLine/uiImgSeasoning/uiTxtNum"):GetComponent(UILabel)
  self.m_uiTxtFire = self:FindGO("uiProgressRoot/uiImgLine/uiImgFire/uiTxtNum"):GetComponent(UILabel)
  self.m_uiTxtIngredients = self:FindGO("uiProgressRoot/uiImgLine/uiImgIngredients/uiTxtNum"):GetComponent(UILabel)
  self.progressLabel = self:FindComponent("uiBgRoot/progresslabel", UILabel)
  self.m_uiSliderBar = self:FindGO("uiProgressRoot/uiBgRoot/uiImgBar/uiSliderBar"):GetComponent(UISlider)
  local maxStartDistance = 315
  local star_point = GameConfig_GvgRimConfig.star_point or DefaultGvgRimConfig.star_point
  local maxPoint = star_point[5]
  self.m_uiAllStar = {}
  for i = 1, 5 do
    local ui = {}
    ui.m_uiImgStar = self:FindGO("uiProgressRoot/uiBgRoot/uiStarRoot/" .. i)
    ui.m_uiLock = self:FindGO("lock", ui.m_uiImgStar)
    ui.m_uiImgLightStar = self:FindGO("uiProgressRoot/uiBgRoot/uiStarRoot/" .. i .. "/uiImgLight")
    ui.m_uiImgLightStar.gameObject:SetActive(false)
    table.insert(self.m_uiAllStar, ui)
    LuaGameObject.SetLocalPositionGO(ui.m_uiImgStar, maxStartDistance * star_point[i] / maxPoint, 0, 0)
  end
  self.costtip = SpriteLabel.new(self:FindComponent("uiProgressRoot/uiImgBtnCookingEnable/uiImgCookingType/costtip", UIRichLabel), nil, 24, 24)
  local costInfoCellGO = self:LoadPreferb("cell/CostInfoCell2", self:FindGO("zenycontainer"))
  self.costInfoCell = CostInfoCell2.new(costInfoCellGO)
  self.costInfoCell:AddEventListener(MouseEvent.MouseClick, self.ShowIngredientsItem, self)
  self.costInfoCell:AddEventListener(CostInfoCell2.ClickTrace, self.ShowGetPath, self)
  self.m_uiScrollView = self:FindGO("anchor_left/uiScrollView"):GetComponent(UIScrollView)
  self.m_uiTable = self:FindComponent("Table", ROUITable, self.m_uiScrollView.gameObject)
end

function GVGCookingView:ShowIngredientsItem(cell)
  local sp = cell.symbol
  local itemData = ItemData.new("GVGIngredients", cell.id)
  local x = NGUIUtil.GetUIPositionXYZ(sp.gameObject)
  if 0 < x then
    self:ShowItemTip({itemdata = itemData}, sp, NGUIUtil.AnchorSide.Left, {-220, 0})
  else
    self:ShowItemTip({itemdata = itemData}, sp, NGUIUtil.AnchorSide.Right, {220, 0})
  end
end

function GVGCookingView:ShowGetPath(cell)
  self.bdt = GainWayTip.new(cell.gobtn)
  self.bdt:SetData(cell.id)
  self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
    self:CloseSelf()
  end, self)
  self.bdt:AddIgnoreBounds(cell.gobtn)
  self.bdt:SetAnchorPos(false)
  self.bdt:AddEventListener(GainWayTip.CloseGainWay, function()
    self.bdt = nil
  end, self)
end

function GVGCookingView:InitEvents()
  self.m_gridListCtrl = UIGridListCtrl.new(self.m_uiTable, GVGCookingItemView, "GVGCookingItemCell")
  self:AddClickEvent(self.m_uiImgBtnClose, function(go)
    self:CloseSelf()
  end)
  self:TryOpenHelpViewById(35250, nil, self.m_uiImgBtnHelp)
  self:AddClickEvent(self.m_uiImgBtnCookingEnable, function(go)
    self:onClickCookingEnable()
  end)
  self:AddClickEvent(self.m_uiImgBtnCookingDisable, function(go)
    self:onClickCookingDisable()
  end)
  self:AddClickEvent(self.m_uiImgBtnEat, function(go)
    self:onClickEat()
  end)
  self:AddClickEvent(self.m_uiCookingTypePage.gameObject, function(go)
    self:isVisibleCookingType(false)
  end)
  self:AddClickEvent(self.m_uiImgBtnHeat, function(go)
    if not self.heatOptEnable then
      MsgManager.ShowMsgByID(31064)
      return
    end
    if GVGCookingHelper.Me().m_cookingInfo.m_TotalPointFull then
      MsgManager.ShowMsgByID(31056)
      return
    end
    if GVGCookingHelper.Me().m_cookingInfo.m_HeatFull then
      MsgManager.ShowMsgByID(31061)
      return
    end
    self:onClickCooking(go, 2)
  end)
  self:AddClickEvent(self.m_uiImgBtnSeasoning, function(go)
    if not self.seasoningOptEnable then
      MsgManager.ShowMsgByID(31065)
      return
    end
    if GVGCookingHelper.Me().m_cookingInfo.m_TotalPointFull then
      MsgManager.ShowMsgByID(31056)
      return
    end
    if GVGCookingHelper.Me().m_cookingInfo.m_SeasoningFull then
      MsgManager.ShowMsgByID(31062)
      return
    end
    self:onClickCooking(go, 3)
  end)
  self:AddClickEvent(self.m_uiImgBtnIngredients, function(go)
    if GVGCookingHelper.Me().m_cookingInfo.m_TotalPointFull then
      MsgManager.ShowMsgByID(31056)
      return
    end
    if GVGCookingHelper.Me().m_cookingInfo.m_IngredFull then
      MsgManager.ShowMsgByID(31060)
      return
    end
    if not self.ingredientsOptEnable then
      MsgManager.ShowMsgByID(31063)
      return
    end
    if self.costItemId and self.costItemNum then
      local num = BagProxy.Instance:GetItemNumByStaticID(self.costItemId, CookBagTypes) or 0
      if num < self.costItemNum then
        MsgManager.ShowMsgByID(8)
        return
      end
    end
    self:onClickCooking(go, 1)
  end)
  self:AddListenEvt(ServiceEvent.NUserVarUpdate, self.UpdateOptNum)
end

function GVGCookingView:onClickCookingEnable(go)
  self:isVisibleCookingType(true)
end

function GVGCookingView:onClickCookingDisable(go)
end

function GVGCookingView:onClickEat(go)
  if self.lastEatenTime then
    local cd = ServerTime.CurServerTime() - self.lastEatenTime
    local CONFIGCD = GameConfig_GvgRimConfig.eat_cd or DefaultGvgRimConfig.eat_cd or 60
    if CONFIGCD > cd / 1000 then
      MsgManager.ShowMsgByID(GameConfig_GvgRimConfig.eat_msg or DefaultGvgRimConfig.eat_msg)
      return
    end
  end
  self.lastEatenTime = ServerTime.CurServerTime()
  local sceneUI = Game.Myself:GetSceneUI() or nil
  if sceneUI ~= nil then
    sceneUI.roleTopUI:PlayEmojiById(20)
  end
  MsgManager.ShowMsgByID(GameConfig_GvgRimConfig.eat_success_msg or DefaultGvgRimConfig.eat_success_msg or 43185)
  GVGCookingHelper.Me():playEatAnim()
  ServiceGuildCmdProxy.Instance:CallGvgCookingCmd(nil, true)
end

function GVGCookingView:onClickCooking(go, type)
  GVGCookingHelper.Me():playCookingAction(type)
  ServiceGuildCmdProxy.Instance:CallGvgCookingCmd(type, false)
  self:isVisibleCookingType(false)
end

function GVGCookingView:isVisibleCookingType(value)
  if self.m_uiCookingTypePage ~= nil then
    self.m_uiCookingTypePage.gameObject:SetActive(value)
  end
end

function GVGCookingView:UpdateOptNum()
  local heatTotalCount = GameConfig_GvgRimConfig.heat_count or DefaultGvgRimConfig.heat_count or 40
  local heatOptCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_GVGCOOK_HEAT) or 0
  if heatTotalCount > heatOptCount then
    self.m_uiImgBtnHeatCount.text = string.format("(%s/%s)", heatTotalCount - heatOptCount, heatTotalCount)
    self.heatOptEnable = true
  else
    self.m_uiImgBtnHeatCount.text = string.format("([c][D4512D]0[-][/c]/%s)", heatTotalCount)
    self.heatOptEnable = false
  end
  local seasoningTotalCount = GameConfig_GvgRimConfig.seasoning_count or DefaultGvgRimConfig.seasoning_count or 40
  local seasoningOptCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_GVGCOOK_SEASONING) or 0
  if seasoningTotalCount > seasoningOptCount then
    self.m_uiImgBtnSeasoningCount.text = string.format("(%s/%s)", seasoningTotalCount - seasoningOptCount, seasoningTotalCount)
    self.seasoningOptEnable = true
  else
    self.m_uiImgBtnSeasoningCount.text = string.format("([c][D4512D]0[-][/c]/%s)", seasoningTotalCount)
    self.seasoningOptEnable = false
  end
  local ingredientsTotalCount = GameConfig_GvgRimConfig.ingredients_count or DefaultGvgRimConfig.ingredients_count or 40
  local ingredientsOptCount = MyselfProxy.Instance:getVarValueByType(Var_pb.EVARTYPE_GVGCOOK_INGREDIENTS) or 0
  if ingredientsTotalCount > ingredientsOptCount then
    self.m_uiImgBtnIngredientsCount.text = string.format("(%s/%s)", ingredientsTotalCount - ingredientsOptCount, ingredientsTotalCount)
    self.ingredientsOptEnable = true
  else
    self.m_uiImgBtnIngredientsCount.text = string.format("([c][D4512D]0[-][/c]/%s)", ingredientsTotalCount)
    self.ingredientsOptEnable = false
  end
end

function GVGCookingView:ShowData()
  if not GVGCookingHelper.Me().m_cookingInfo then
    return
  end
  local curValue = GVGCookingHelper.Me():getCurValue()
  local curTotalVal = GVGCookingHelper.Me():getCurTotalValue()
  local maxValue = GVGCookingHelper.Me():getTotalValue()
  self.m_uiSliderBar.value = curValue / maxValue
  self.progressLabel.text = string.format("%s/%s", curValue, curTotalVal)
  local info = GVGCookingHelper.Me():getCookingInfo()
  local unit = maxValue / 5
  local star_point = GameConfig_GvgRimConfig.star_point or DefaultGvgRimConfig.star_point
  for i = 1, 5 do
    local v = self.m_uiAllStar[i]
    v.m_uiImgLightStar.gameObject:SetActive(curValue >= star_point[i])
    v.m_uiLock:SetActive(i > info.m_maxstar)
  end
  self.m_uiTxtFire.text = info.m_heat .. "/" .. (GameConfig_GvgRimConfig.HeatPoint or DefaultGvgRimConfig.HeatPoint)
  self.m_uiTxtIngredients.text = info.m_ingredients .. "/" .. (GameConfig_GvgRimConfig.IngredPoint or DefaultGvgRimConfig.IngredPoint)
  self.m_uiTxtSeasoning.text = info.m_seasoning .. "/" .. (GameConfig_GvgRimConfig.SeasoningPoint or DefaultGvgRimConfig.SeasoningPoint)
  self.m_uiImgBtnCookingDisable.gameObject:SetActive(curCookingCount == 0)
  self.m_uiImgBtnCookingEnable.gameObject:SetActive(curCookingCount ~= 0)
  self:UpdateOptNum()
  self.costItemId = info.m_ingreditem
  self.costItemNum = GameConfig.GvgRimConfig.IngredientsNum
  self.costInfoCell:SetData(self.costItemId, CookBagTypes)
  self.costtip:SetText(string.format(ZhString.GVGCookingView_CostTip, self.costItemId, self.costItemNum))
  if self.m_logList == nil then
    self.m_logList = {}
  end
  TableUtility.ArrayClear(self.m_logList)
  local logs = GVGCookingHelper.Me():getCookingLog()
  if logs ~= nil and 0 < #logs then
    for _, v in pairs(logs) do
      if v.opt ~= nil then
        local msgId = self:GetPointMsgId(v.point, v.opt)
        if msgId then
          local text = Table_Sysmsg[msgId].Text
          local desc = string.format(text, v.point)
          desc = "[c][67c8ff]" .. v.name .. "[-][/c]" .. desc
          table.insert(self.m_logList, 1, desc)
        end
      else
        table.insert(self.m_logList, 1, string.format(ZhString.GVG_Cooking_Log, v.name, v.point))
      end
    end
  end
  self.m_gridListCtrl:ResetDatas(self.m_logList, true)
end

function GVGCookingView:GetPointMsgId(point, opt)
  local msgTable
  if 1 < point then
    msgTable = GameConfig_GvgRimConfig.point_addmsg or DefaultGvgRimConfig.point_addmsg
  else
    msgTable = GameConfig_GvgRimConfig.point_failmsg or DefaultGvgRimConfig.point_failmsg
  end
  if msgTable then
    if opt == 1 then
      return msgTable.ingredients
    elseif opt == 2 then
      return msgTable.heat
    elseif opt == 3 then
      return msgTable.seasoning
    end
  end
  return nil
end

function GVGCookingView:CanEaten()
  if GvgProxy.Instance:GetGvgOpenFireState() then
    return true
  end
  local curTimeDate = os.date("*t", ServerTime.CurServerTime() / 1000)
  local gvgStartTime = GameConfig.GVGConfig.start_time
  if gvgStartTime then
    local eat_begin_time = GameConfig_GvgRimConfig.eat_begin_time or DefaultGvgRimConfig.eat_begin_time or 1800
    local curSec = curTimeDate.hour * 3600 + curTimeDate.min * 60 + curTimeDate.sec
    local curWDay = (curTimeDate.wday - 1 + 6) % 7 + 1
    for i = 1, #gvgStartTime do
      if not gvgStartTime[i].super and curWDay == gvgStartTime[i].day then
        local h, m = gvgStartTime[i].hour or 0, gvgStartTime[i].min or 0
        local daySec = h * 3600 + m * 60
        if curSec > daySec - eat_begin_time and curSec <= daySec then
          return true
        end
      end
    end
  end
  return false
end

function GVGCookingView:ActiveEatenButton(b)
  if b then
    self:SetTextureWhite(self.m_uiImgBtnEat, LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706, 1))
    self.m_uiImgBtnEat_Collider.enabled = true
  else
    self:SetTextureGrey(self.m_uiImgBtnEat)
    self.m_uiImgBtnEat_Collider.enabled = false
  end
end

function GVGCookingView:UpdateEatButton()
  self:ActiveEatenButton(self:CanEaten())
end

function GVGCookingView:OnEnter()
  GVGCookingView.super.OnEnter(self)
  EventManager.Me():AddEventListener(GVGCookingEvent.UpdateInfo, self.ShowData, self)
  EventManager.Me():AddEventListener(GVGCookingEvent.RemoveCookingNpc, self.CloseSelf, self)
  ServiceGuildCmdProxy.Instance:CallGvgCookingUpdateCmd()
  self:ShowData()
  local trans = GVGCookingHelper.Me():getCreatureTrans()
  if trans ~= nil then
    local viewPort = GameConfig_GvgRimConfig.CameraViewPort or {
      0.62,
      0.3,
      14
    }
    self:CameraFocusOnNpc(trans, LuaGeometry.GetTempVector3(unpack(viewPort)), CameraConfig.NPC_Dialog_DURATION, nil)
    GVGCookingHelper.Me():maskCreatureTopFram()
  end
  TimeTickManager.Me():CreateTick(0, 1000, function()
    self:UpdateEatButton()
  end, self, 111)
end

function GVGCookingView:OnExit()
  EventManager.Me():RemoveEventListener(GVGCookingEvent.UpdateInfo, self.ShowData, self)
  EventManager.Me():RemoveEventListener(GVGCookingEvent.RemoveCookingNpc, self.CloseSelf, self)
  GVGCookingHelper.Me():unMaskCreatureTopFram()
  self:CameraReset()
  TimeTickManager.Me():ClearTick(self)
  GVGCookingView.super.OnExit(self)
end
