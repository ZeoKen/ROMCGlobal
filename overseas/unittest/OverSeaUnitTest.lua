OverSeaUnitTest = {}
OverSeaUnitTest.TestType = {Dress = 1}

function OverSeaUnitTest.TryTest(content)
  helplog(content)
  local cmds = string.split(content, " ")
  if 2 <= #cmds then
    local testCmds = string.split(cmds[1], "=")
    local args = {}
    for i = 2, #cmds do
      table.insert(args, cmds[i])
    end
    if #testCmds == 2 and testCmds[1] == "/lizitest" then
      local testType = tonumber(testCmds[2])
      local handler = OverSeaUnitTest.TestHandler[testType]
      if handler ~= nil then
        handler(unpack(args))
      end
      return true
    end
  end
  return false
end

OverSeaUnitTest.professes = {
  14,
  74,
  24,
  34,
  94,
  44,
  54,
  124,
  64,
  134
}
OverSeaUnitTest.dressTestIds = {}
OverSeaUnitTest.dressType = 1
OverSeaUnitTest.professWeapon = {
  [14] = {
    40029,
    40337,
    40737,
    41842,
    41539,
    25008
  },
  [74] = {
    42544,
    40029,
    40337,
    40737,
    41842,
    41539,
    25008
  },
  [24] = {40636, 40737},
  [34] = {40737, 40926},
  [94] = {40737, 41231},
  [44] = {41231},
  [54] = {40636, 41539},
  [124] = {62523, 41539},
  [64] = {
    41842,
    41539,
    40337,
    40737
  },
  [134] = {
    41842,
    41539,
    40337,
    40737,
    25401
  }
}

function OverSeaUnitTest.dressTest(...)
  OverSeaUnitTest.dressTestIds = {}
  for i = 1, select("#", ...) do
    local p = select(i, ...)
    local kp = string.split(p, "=")
    local key = kp[1]
    local value = kp[2]
    if key == "dress" then
      OverSeaUnitTest.dressType = tonumber(value)
    elseif key == "items" then
      OverSeaUnitTest.dressTestIds = string.split(value, ",")
    end
  end
  helplog("OverSeaUnitTest.dressTest", OverSeaUnitTest.dressType)
  for k, v in pairs(OverSeaUnitTest.professes) do
    helplog("OverSeaUnitTest.professes", v)
  end
  if #OverSeaUnitTest.dressTestIds == 0 then
    local server = FunctionLogin.Me():getCurServerData()
    local serverID = server ~= nil and server.sid or ""
    local baseUrl = "http://ww1.vvv.io:8030/query/lottery"
    local region_id = "region_id=" .. serverID
    local release = Resources.Load("Debug/cell/GMInputCell") == nil and 1 or 0
    local is_release = "&is_release=" .. release
    local url = string.format("%s?%s%s", baseUrl, region_id, is_release)
    helplog(url)
    local order = HttpWWWRequestOrder(url, NetConfig.HttpRequestTimeOut, nil, false, true)
    if order then
      order:SetCallBacks(function(response)
        helplog(response.resString)
        local data = string.split(response.resString, "\n")
        OverSeaUnitTest.dressTestIds = string.split(data[1], ",")
        if OverSeaUnitTest.dressType == 2 then
          OverSeaUnitTest.dressTestIds = string.split(data[2], ",")
        end
        for k, v in pairs(OverSeaUnitTest.dressTestIds) do
          helplog("OverSeaUnitTest.dressTestIds", v)
        end
        OverSeaUnitTest.wrapProfessionChange(1, OverSeaUnitTest.professes, function()
          OverSeaUnitTest.PlayActions(function()
            helplog(" OverSeaUnitTest.PlayActions end")
            OverSeaUnitTest.ErrorFloat("dressTest end!")
          end)
        end)
      end, function(order)
        MsgManager.FloatMsg("", "获取item id 出错！")
      end, function(order)
        MsgManager.FloatMsg("", "获取item id 出错！")
      end)
      Game.HttpWWWRequest:RequestByOrder(order)
    end
  else
    OverSeaUnitTest.wrapProfessionChange(1, OverSeaUnitTest.professes, function()
      OverSeaUnitTest.PlayActions(function()
        helplog(" OverSeaUnitTest.PlayActions end")
        OverSeaUnitTest.ErrorFloat("dressTest end!")
      end)
    end)
  end
end

function OverSeaUnitTest.wrapProfessionChange(index, list, cb)
  if index <= #list then
    local id = list[index]
    OverSeaUnitTest.professionChange(id, function()
      OverSeaUnitTest.warpDressTest(1, OverSeaUnitTest.dressTestIds, function()
        index = index + 1
        OverSeaUnitTest.wrapProfessionChange(index, list, cb)
      end)
    end)
  else
    cb()
  end
end

function OverSeaUnitTest.professionChange(ids, cb)
  local idsTab = string.split(ids, "|")
  if 1 <= #idsTab then
    local cId = tonumber(idsTab[1])
    OverSeaUnitTest.ErrorFloat("尝试切换职业:" .. cId)
    OverSeaUnitTest.curProfessWeapons = OverSeaUnitTest.professWeapon[cId]
    local branch = Table_Class[cId].TypeBranch
    helplog("OverSeaUnitTest.professionChange:", cId)
    ServiceNUserProxy.Instance:CallProfessionChangeUserCmd(branch, true)
    OverSeaUnitTest.DelayAction(2, function()
      cb()
    end)
  else
    OverSeaUnitTest.ErrorFloat("切换职业出错" .. ids)
  end
end

function OverSeaUnitTest.wrapUseItem(index, list, cb)
  if index <= #list then
    local dId = tonumber(list[index])
    OverSeaUnitTest.BagItemUse(dId, function()
      index = index + 1
      OverSeaUnitTest.wrapUseItem(index, list, cb)
    end, true)
  else
    cb()
  end
end

function OverSeaUnitTest.warpDressTest(index, list, cb)
  Game.Input_ClickTerrain(-10.525310516357, 2.5412356853485, 13.55912113189)
  OverSeaUnitTest.DelayAction(1.2, function()
    if index <= #list then
      local dId = tonumber(list[index])
      index = index + 1
      OverSeaUnitTest.Dress(dId, function()
        OverSeaUnitTest.warpDressTest(index, list, cb)
      end)
    else
      cb()
    end
  end)
end

function OverSeaUnitTest.hasEquip(itemId, cb)
  local count = BagProxy.Instance.roleEquip:GetEquipedItemNum(itemId)
  helplog("OverSeaUnitTest.hasEquip", itemId, count)
  cb(0 < count)
end

function OverSeaUnitTest.wrapProfessWeaponUse(index, list, cb)
  OverSeaUnitTest.DelayAction(1.2, function()
    if index <= #list then
      local weaponId = tonumber(list[index])
      helplog("OverSeaUnitTest.wrapProfessWeaponUse", weaponId, index, #list)
      index = index + 1
      OverSeaUnitTest.hasEquip(weaponId, function(equip)
        if equip then
          OverSeaUnitTest.DressSkillActions(function()
            OverSeaUnitTest.wrapProfessWeaponUse(index, list, cb)
          end)
        else
          local item = BagProxy.Instance:GetItemByStaticID(weaponId, BagProxy.BagType.MainBag)
          if item then
            OverSeaUnitTest.BagItemUse(weaponId, function()
              OverSeaUnitTest.DressSkillActions(function()
                OverSeaUnitTest.wrapProfessWeaponUse(index, list, cb)
              end)
            end, true)
          else
            OverSeaUnitTest.ErrorFloat("职业装备不存在，跳过！" .. weaponId)
            OverSeaUnitTest.wrapProfessWeaponUse(index, list, cb)
          end
        end
      end)
    else
      cb()
    end
  end)
end

function OverSeaUnitTest.realDress(cb)
  if OverSeaUnitTest.dressType == 1 then
    OverSeaUnitTest.wrapProfessWeaponUse(1, OverSeaUnitTest.curProfessWeapons, cb)
  else
    Game.Input_JoyStick(0.75, 0, -0.75)
    OverSeaUnitTest.DelayAction(0.5, function()
      Game.Input_JoyStickEnd()
      cb()
    end)
  end
end

function OverSeaUnitTest.Dress(dId, cb)
  OverSeaUnitTest.hasEquip(dId, function(equip)
    if equip then
      OverSeaUnitTest.realDress(cb)
    else
      local item = BagProxy.Instance:GetItemByStaticID(dId, BagProxy.BagType.MainBag)
      if item then
        OverSeaUnitTest.BagItemUse(dId, function()
          OverSeaUnitTest.realDress(cb)
        end, true)
      else
        OverSeaUnitTest.ErrorFloat("头饰不存在，跳过！" .. dId)
        cb()
      end
    end
  end)
end

function OverSeaUnitTest.PlayActions(cb)
  OverSeaUnitTest.ErrorFloat("开始测试表情动作！")
  
  function OverSeaUnitTest.EmojiViewEnter(emojiView)
    local emojiGrid = emojiView:FindGO("EmojiGrid")
    local actions = {}
    for i = 0, emojiGrid.transform.childCount - 1 do
      local emoji = emojiGrid.transform:GetChild(i)
      local action = emoji.transform:Find("Action")
      local name = action:Find("Symbol"):GetComponent(UISprite).spriteName
      if action and action.gameObject.activeSelf then
        table.insert(actions, {
          name,
          emoji.gameObject
        })
      end
    end
    OverSeaUnitTest.EmojiViewEnterHandler = nil
    OverSeaUnitTest.WrapClickActBtn(1, actions, cb)
  end
  
  Game.Input_JoyStick(0.75, 0, -0.75)
  OverSeaUnitTest.DelayAction(0.5, function()
    Game.Input_JoyStickEnd()
    OverSeaUnitTest.DelayAction(1, function()
      GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
        view = PanelConfig.ChatEmojiView,
        viewdata = {}
      })
    end)
  end)
end

function OverSeaUnitTest.WrapClickActBtn(index, actions, cb)
  local totalCount = #actions
  local btn = actions[index][2]
  local name = actions[index][1]
  helplog("OverSeaUnitTest.ClickActBtn" .. index)
  OverSeaUnitTest.ClickActBtn(btn, name, function()
    index = index + 1
    if index <= totalCount then
      OverSeaUnitTest.WrapClickActBtn(index, actions, cb)
    else
      cb()
    end
  end)
end

function OverSeaUnitTest.ClickActBtn(btn, name, cb)
  OverSeaUnitTest.ErrorFloat("播放动作:" .. name)
  OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(btn)
  OverSeaUnitTest.DelayAction(3.5, function()
    cb()
  end)
end

function OverSeaUnitTest.DressSkillActions(cb)
  local shortCount = 0
  if 0 < shortCount then
    local curShortIndex = 1
    OverSeaUnitTest.curSkillGroup = 0
    OverSeaUnitTest.WrapUseShortCut(curShortIndex, shortCount, function()
      helplog("OverSeaUnitTest.DressSkillActions End")
      cb()
    end)
  else
    OverSeaUnitTest.curSkillGroup = 0
    OverSeaUnitTest.WrapUseSkillGroup(function()
      cb()
    end)
  end
end

function OverSeaUnitTest.WrapUseShortCut(useShortIndex, shortCount, cb)
  OverSeaUnitTest.UseShortCut(useShortIndex, function()
    OverSeaUnitTest.curSkillGroup = 0
    OverSeaUnitTest.WrapUseSkillGroup(function()
      if useShortIndex < shortCount then
        useShortIndex = useShortIndex + 1
        OverSeaUnitTest.WrapUseShortCut(useShortIndex, shortCount, cb)
      else
        cb()
      end
    end)
  end)
end

function OverSeaUnitTest.WrapUseSkillGroup(cb)
  helplog("OverSeaUnitTest.WrapUseSkillGroup")
  if OverSeaUnitTest.curSkillGroup == 0 then
    local skillCount = OverSeaUnitTest.MainView:FindGO("SkillGrid").transform.childCount
    local useSkillIndex = 0
    OverSeaUnitTest.WrapUseSkill(useSkillIndex, skillCount, function()
      OverSeaUnitTest.curSkillGroup = OverSeaUnitTest.curSkillGroup + 1
      OverSeaUnitTest.WrapUseSkillGroup(cb)
    end)
  else
    OverSeaUnitTest.SwitchSkillGroup(function()
      if OverSeaUnitTest.curSkillGroup < OverSeaUnitTest.skillSwitchCount then
        local skillCount = OverSeaUnitTest.MainView:FindGO("SkillGrid").transform.childCount
        local useSkillIndex = 0
        OverSeaUnitTest.WrapUseSkill(useSkillIndex, skillCount, function()
          OverSeaUnitTest.curSkillGroup = OverSeaUnitTest.curSkillGroup + 1
          OverSeaUnitTest.WrapUseSkillGroup(cb)
        end)
      else
        cb()
      end
    end)
  end
end

function OverSeaUnitTest.WrapUseSkill(useSkillIndex, skillCount, cb)
  OverSeaUnitTest.UseSkill(useSkillIndex, function()
    useSkillIndex = useSkillIndex + 1
    if useSkillIndex < skillCount then
      OverSeaUnitTest.WrapUseSkill(useSkillIndex, skillCount, cb)
    else
      cb()
    end
  end)
end

OverSeaUnitTest.skillSwitchCount = 4
OverSeaUnitTest.curSkillGroup = 0

function OverSeaUnitTest.SwitchSkillGroup(cb)
  local SkillShortCutSwitch = OverSeaUnitTest.MainView:FindGO("SkillShortCutSwitch")
  OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(SkillShortCutSwitch)
  OverSeaUnitTest.DelayAction(1, function()
    cb()
  end)
end

function OverSeaUnitTest.UseShortCut(index, cb)
  helplog("UseShortCut" .. index)
  OverSeaUnitTest.ErrorFloat("使用快捷栏" .. index)
  local quickItemCellName = "QuickItemCell" .. index
  local shortCutItem = OverSeaUnitTest.MainView:FindGO(quickItemCellName)
  if shortCutItem ~= nil then
    OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(shortCutItem.gameObject)
    OverSeaUnitTest.DelayAction(1, function()
      cb()
    end)
  else
    OverSeaUnitTest.ErrorFloat("ShortCutItem 不存在" .. index)
  end
end

function OverSeaUnitTest.UseSkill(index, cb)
  helplog("OverSeaUnitTest.UseSkill" .. index)
  local skillBtn = OverSeaUnitTest.MainView:FindGO("SkillGrid").transform:GetChild(index)
  if skillBtn ~= nil then
    local click = skillBtn.transform:Find("Click")
    local icon = click:Find("Icon"):GetComponent(UISprite)
    if icon.spriteName ~= "" then
      local delay = 0
      local skillId = string.split(icon.spriteName, "_")[2]
      local skillInfo = Game.LogicManager_Skill:GetSkillInfo(tonumber(skillId))
      local skillName = skillId or "未知"
      if skillInfo then
        helplog("has skillinfo")
        skillName = skillInfo.staticData.NameZh
        local leadType = skillInfo.Lead_Type
        if leadType and leadType.type and leadType.type == SkillCastType.Magic then
          delay = leadType.CCT + leadType.FCT
        end
      end
      OverSeaUnitTest.ErrorFloat("使用技能" .. skillName)
      OverSeaUnitTest.DelayAction(1.5, function()
        OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(click.gameObject)
        OverSeaUnitTest.DelayAction(delay + 2, function()
          Game.Input_ClickTerrain(-10.525310516357, 2.5412356853485, 13.55912113189)
          cb()
        end)
      end)
    else
      cb()
    end
  else
    OverSeaUnitTest.ErrorFloat("OverSeaUnitTest 不存在" .. index)
  end
end

function OverSeaUnitTest.BagItemUse(itemId, useEndCallback, fixError)
  local dressSpriteName = "item_" .. tostring(itemId)
  
  function OverSeaUnitTest.PackageViewEnterHandler(pView, off)
    if off == nil then
      off = 0
    end
    local bagChild
    helplog("begin find dress icon!!!" .. off)
    local itemScrollView = pView:FindGO("ItemScrollView"):GetComponent(PullStopScrollView)
    itemScrollView:MoveRelative(Vector3(0, off * 700, 0))
    local bag_itemContainer = pView:FindGO("bag_itemContainer")
    for i = 0, bag_itemContainer.transform.childCount - 1 do
      local bagCombineItemCell = bag_itemContainer.transform:GetChild(i)
      for j = 0, bagCombineItemCell.transform.childCount - 1 do
        local child = bagCombineItemCell.transform:GetChild(j)
        local Icon_Sprite = child.transform:Find("Common_ItemCell/Item/NormalItem/Icon_Sprite"):GetComponent(UISprite)
        if Icon_Sprite.spriteName == dressSpriteName then
          helplog(dressSpriteName .. "exist!!!")
          bagChild = child
          break
        end
      end
    end
    if bagChild ~= nil then
      OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(bagChild.gameObject)
      OverSeaUnitTest.PackageViewEnterHandler = nil
    elseif off < 5 then
      OverSeaUnitTest.DelayAction(1, function()
        OverSeaUnitTest.PackageViewEnterHandler(pView, off + 1)
      end)
    else
      OverSeaUnitTest.ErrorFloat("道具不存在" .. itemId)
      if fixError then
        OverSeaUnitTest.PackageView:CloseSelf()
        useEndCallback(true)
      end
    end
  end
  
  function OverSeaUnitTest.ItemFloatTipEnterHandler(itemTip)
    helplog("OverSeaUnitTest.ItemFloatTipEnterHandler callback")
    local cell3 = itemTip:FindGO("3_Cell1")
    local useBtn = cell3.transform:Find("MainPanel/BottomButtons/Style1/FuncBtn1")
    if useBtn and cell3.transform:Find("MainPanel/BottomButtons/Style1").gameObject.activeSelf then
      OverSeaUnitTest.ErrorFloat("尝试使用道具" .. Table_Item[itemId].NameZh)
      OverSeaUnitTest.DelayAction(1, function()
        OverSeas_TW.OverSeaUnitTestCSharp.GetInstance():ForceClickObj(useBtn.gameObject)
        OverSeaUnitTest.PackageView:CloseSelf()
        useEndCallback(true)
      end)
      OverSeaUnitTest.ItemFloatTipEnterHandler = nil
    else
      OverSeaUnitTest.ErrorFloat("道具无法使用" .. itemId)
      if fixError then
        useEndCallback(true)
      end
    end
  end
  
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.Bag,
    viewdata = {}
  })
end

function OverSeaUnitTest.failEnd()
end

function OverSeaUnitTest.ErrorFloat(msg)
  MsgManager.FloatMsgTableParam(nil, msg)
end

function OverSeaUnitTest.DelayAction(delay, handler)
  if OverSeaUnitTest.MainView ~= nil then
    TimeTickManager.Me():CreateOnceDelayTick(delay * 1000, function(owner, deltaTime)
      if handler then
        handler()
      end
    end, self)
  end
end

OverSeaUnitTest.ItemFloatTipEnterHandler = nil
OverSeaUnitTest.PackageViewEnterHandler = nil
OverSeaUnitTest.EmojiViewEnterHandler = nil
OverSeaUnitTest.PackageView = nil
OverSeaUnitTest.MainView = nil

function OverSeaUnitTest.PackageViewEnter(packageView)
  OverSeaUnitTest.PackageView = packageView
  if OverSeaUnitTest.PackageViewEnterHandler then
    OverSeaUnitTest.PackageViewEnterHandler(packageView)
  end
end

function OverSeaUnitTest.ItemTipEnter(itemTip)
  if OverSeaUnitTest.ItemFloatTipEnterHandler then
    OverSeaUnitTest.ItemFloatTipEnterHandler(itemTip)
  end
end

function OverSeaUnitTest.EmojiViewEnter(emojiView)
  if OverSeaUnitTest.EmojiViewEnterHandler then
    OverSeaUnitTest.EmojiViewEnterHandler(emojiView)
  end
end

OverSeaUnitTest.TestHandler = {}
OverSeaUnitTest.TestHandler[OverSeaUnitTest.TestType.Dress] = OverSeaUnitTest.dressTest
