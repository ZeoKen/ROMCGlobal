SweepTicketUtil = class("SweepTicketUtil")
local _PackageCheck = {1, 8}

function SweepTicketUtil.HasSweepTicket()
  local ticket_config = GameConfig.Pve.SweepTicket
  if not ticket_config then
    return false
  end
  local ticket_id = ticket_config.id
  if not ticket_id then
    return false
  end
  local own_count = BagProxy.Instance:GetItemNumByStaticID(ticket_id, _PackageCheck)
  return 0 < own_count
end

function SweepTicketUtil.GetSweepTicketDiscountTime()
  local ticket_config = GameConfig.Pve.SweepTicket
  if not ticket_config then
    return 0
  end
  local ticket_id = ticket_config.id
  local discount_time = ticket_config.time
  if not ticket_id or not discount_time then
    return 0
  end
  local own_count = BagProxy.Instance:GetItemNumByStaticID(ticket_id, _PackageCheck)
  return own_count * discount_time
end

function SweepTicketUtil.GetSweepTicketConfig()
  return GameConfig.Pve.SweepTicket
end

function SweepTicketUtil.GetSweepTicketCount()
  local ticket_config = SweepTicketUtil.GetSweepTicketConfig()
  if not ticket_config then
    return 0
  end
  local ticket_id = ticket_config.id
  if not ticket_id then
    return 0
  end
  return BagProxy.Instance:GetItemNumByStaticID(ticket_id, _PackageCheck)
end

function SweepTicketUtil.CalculateRequiredTicketCount(requiredTime)
  local ticket_config = SweepTicketUtil.GetSweepTicketConfig()
  if not ticket_config then
    return 0
  end
  local ticket_time = ticket_config.time
  if not ticket_time or ticket_time <= 0 then
    return 0
  end
  return math.floor(requiredTime / ticket_time)
end

function SweepTicketUtil.CheckSweepTimeSufficient(requiredTime)
  local ticket_discount_time = SweepTicketUtil.GetSweepTicketDiscountTime()
  local play_time = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.PLAY, true) or 0
  local battle_time = 0
  if not ISNoviceServerType then
    battle_time = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.BATTLE, true) or 0
  end
  return requiredTime <= ticket_discount_time + play_time + battle_time
end

function SweepTicketUtil.CheckSweepTicketValid(costTime, isFree, checkSweepValidFunc)
  if isFree then
    return false
  end
  if not costTime or costTime <= 0 then
    return false
  end
  if not SweepTicketUtil.HasSweepTicket() then
    return false
  end
  if checkSweepValidFunc and not checkSweepValidFunc(true, true) then
    return false
  end
  return SweepTicketUtil.CheckSweepTimeSufficient(costTime)
end

function SweepTicketUtil.HandleSweepTicketSweep(costTime, showConfirmFunc, showOverflowFunc)
  local requiredTime = costTime
  local required_ticket_count = SweepTicketUtil.CalculateRequiredTicketCount(requiredTime)
  local own_ticket_count = SweepTicketUtil.GetSweepTicketCount()
  local use_ticket_count = math.min(required_ticket_count, own_ticket_count)
  local remaining_time = requiredTime - use_ticket_count * SweepTicketUtil.GetSweepTicketConfig().time
  local play_time = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.PLAY, true) or 0
  local battle_time = 0
  if not ISNoviceServerType then
    battle_time = BattleTimeDataProxy.Instance:GetLeftTime(BattleTimeDataProxy.ETime.BATTLE, true) or 0
  end
  if remaining_time <= 0 then
    showConfirmFunc(use_ticket_count, requiredTime, true)
  elseif remaining_time <= play_time + battle_time then
    showConfirmFunc(use_ticket_count, requiredTime, false)
  elseif own_ticket_count > use_ticket_count then
    use_ticket_count = use_ticket_count + 1
    showOverflowFunc(use_ticket_count, requiredTime)
  else
    MsgManager.ShowMsgByID(43115)
  end
end

function SweepTicketUtil.ShowSweepTicketConfirm(ticketCount, requiredTime, noTimeCost, doSweepFunc)
  local actualRequiredTime = ticketCount * SweepTicketUtil.GetSweepTicketConfig().time
  MsgManager.ConfirmMsgByID(43640, function()
    doSweepFunc(true)
  end, function()
    doSweepFunc(false)
  end, nil, ticketCount, actualRequiredTime // 60)
end

function SweepTicketUtil.ShowSweepTicketOverflowConfirm(ticketCount, requiredTime, doSweepFunc)
  local overflowTime = ticketCount * SweepTicketUtil.GetSweepTicketConfig().time - requiredTime
  MsgManager.ConfirmMsgByID(43643, function()
    doSweepFunc(true)
  end, nil, nil, ticketCount, requiredTime // 60, overflowTime // 60)
end
