ServiceHomeCmdAutoProxy = class("ServiceHomeCmdAutoProxy", ServiceProxy)
ServiceHomeCmdAutoProxy.Instance = nil
ServiceHomeCmdAutoProxy.NAME = "ServiceHomeCmdAutoProxy"

function ServiceHomeCmdAutoProxy:ctor(proxyName)
  if ServiceHomeCmdAutoProxy.Instance == nil then
    self.proxyName = proxyName or ServiceHomeCmdAutoProxy.NAME
    ServiceProxy.ctor(self, self.proxyName)
    self:Init()
    ServiceHomeCmdAutoProxy.Instance = self
  end
end

function ServiceHomeCmdAutoProxy:Init()
end

function ServiceHomeCmdAutoProxy:onRegister()
  self:Listen(70, 1, function(data)
    self:RecvQueryFurnitureDataHomeCmd(data)
  end)
  self:Listen(70, 2, function(data)
    self:RecvFurnitureActionHomeCmd(data)
  end)
  self:Listen(70, 3, function(data)
    self:RecvFurnitureOperHomeCmd(data)
  end)
  self:Listen(70, 4, function(data)
    self:RecvFurnitureUpdateHomeCmd(data)
  end)
  self:Listen(70, 5, function(data)
    self:RecvFurnitureDataUpdateHomeCmd(data)
  end)
  self:Listen(70, 6, function(data)
    self:RecvHouseActionHomeCmd(data)
  end)
  self:Listen(70, 7, function(data)
    self:RecvHouseDataUpdateHomeCmd(data)
  end)
  self:Listen(70, 9, function(data)
    self:RecvPetFurnitureActionhomeCmd(data)
  end)
  self:Listen(70, 10, function(data)
    self:RecvPrayHomeCmd(data)
  end)
  self:Listen(70, 11, function(data)
    self:RecvEnterHomeCmd(data)
  end)
  self:Listen(70, 12, function(data)
    self:RecvQueryHouseDataHomeCmd(data)
  end)
  self:Listen(70, 21, function(data)
    self:RecvQueryHouseFurnitureHomeCmd(data)
  end)
  self:Listen(70, 13, function(data)
    self:RecvOptUpdateHomeCmd(data)
  end)
  self:Listen(70, 14, function(data)
    self:RecvPrintActionHomeCmd(data)
  end)
  self:Listen(70, 15, function(data)
    self:RecvPrintUpdateHomeCmd(data)
  end)
  self:Listen(70, 16, function(data)
    self:RecvBoardItemQueryHomeCmd(data)
  end)
  self:Listen(70, 17, function(data)
    self:RecvBoardItemUpdateHomeCmd(data)
  end)
  self:Listen(70, 18, function(data)
    self:RecvBoardMsgUpdateHomeCmd(data)
  end)
  self:Listen(70, 19, function(data)
    self:RecvEventItemQueryHomeCmd(data)
  end)
  self:Listen(70, 20, function(data)
    self:RecvQueryWoodRankHomeCmd(data)
  end)
end

function ServiceHomeCmdAutoProxy:CallQueryFurnitureDataHomeCmd(house, furniture)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.QueryFurnitureDataHomeCmd()
    if house ~= nil and house.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.accid = house.accid
    end
    if house ~= nil and house.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.id = house.id
    end
    if house ~= nil and house.visitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.visitcount = house.visitcount
    end
    if house ~= nil and house.furniturelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.furniturelv = house.furniturelv
    end
    if house ~= nil and house.furniturescore ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.furniturescore = house.furniturescore
    end
    if house ~= nil and house.petrewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.petrewardtime = house.petrewardtime
    end
    if house ~= nil and house.firerewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.firerewardtime = house.firerewardtime
    end
    if house ~= nil and house.dayvisitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.dayvisitcount = house.dayvisitcount
    end
    if house ~= nil and house.guide ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.guide = house.guide
    end
    if house ~= nil and house.default_furn ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.default_furn = house.default_furn
    end
    if house ~= nil and house.levelup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.levelup = house.levelup
    end
    if house ~= nil and house.woodrankopen ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.woodrankopen = house.woodrankopen
    end
    if house ~= nil and house.ftype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.ftype = house.ftype
    end
    if house ~= nil and house.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.state = house.state
    end
    if house.opt ~= nil and house.opt.open ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.open = house.opt.open
    end
    if house.opt ~= nil and house.opt.board_open ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.board_open = house.opt.board_open
    end
    if house.opt ~= nil and house.opt.enter_area ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.enter_area = house.opt.enter_area
    end
    if house.opt ~= nil and house.opt.furniture_show ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.furniture_show = house.opt.furniture_show
    end
    if house ~= nil and house.opt.forbid_self ~= nil then
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      if msg.house.opt.forbid_self == nil then
        msg.house.opt.forbid_self = {}
      end
      for i = 1, #house.opt.forbid_self do
        table.insert(msg.house.opt.forbid_self, house.opt.forbid_self[i])
      end
    end
    if house ~= nil and house.opt.forbid_other ~= nil then
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      if msg.house.opt.forbid_other == nil then
        msg.house.opt.forbid_other = {}
      end
      for i = 1, #house.opt.forbid_other do
        table.insert(msg.house.opt.forbid_other, house.opt.forbid_other[i])
      end
    end
    if house.opt ~= nil and house.opt.garden_house ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.garden_house = house.opt.garden_house
    end
    if house ~= nil and house.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.name = house.name
    end
    if house ~= nil and house.sign ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.sign = house.sign
    end
    if house ~= nil and house.board ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.board = house.board
    end
    if house ~= nil and house.decorates ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.decorates == nil then
        msg.house.decorates = {}
      end
      for i = 1, #house.decorates do
        table.insert(msg.house.decorates, house.decorates[i])
      end
    end
    if house ~= nil and house.pets ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.pets == nil then
        msg.house.pets = {}
      end
      for i = 1, #house.pets do
        table.insert(msg.house.pets, house.pets[i])
      end
    end
    if house ~= nil and house.radios ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.radios == nil then
        msg.house.radios = {}
      end
      for i = 1, #house.radios do
        table.insert(msg.house.radios, house.radios[i])
      end
    end
    if house ~= nil and house.boards ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.boards == nil then
        msg.house.boards = {}
      end
      for i = 1, #house.boards do
        table.insert(msg.house.boards, house.boards[i])
      end
    end
    if house ~= nil and house.events ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.events == nil then
        msg.house.events = {}
      end
      for i = 1, #house.events do
        table.insert(msg.house.events, house.events[i])
      end
    end
    if house ~= nil and house.week_clear_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.week_clear_time = house.week_clear_time
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_puton ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_puton = house.home_riskskilldata.last_puton
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_putoff ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_putoff = house.home_riskskilldata.last_putoff
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_reward ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_reward = house.home_riskskilldata.last_reward
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.cursize ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.cursize = house.home_riskskilldata.cursize
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.enable ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.enable = house.home_riskskilldata.enable
    end
    if furniture ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.furniture == nil then
        msg.furniture = {}
      end
      for i = 1, #furniture do
        table.insert(msg.furniture, furniture[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryFurnitureDataHomeCmd.id
    local msgParam = {}
    if house ~= nil and house.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.accid = house.accid
    end
    if house ~= nil and house.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.id = house.id
    end
    if house ~= nil and house.visitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.visitcount = house.visitcount
    end
    if house ~= nil and house.furniturelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.furniturelv = house.furniturelv
    end
    if house ~= nil and house.furniturescore ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.furniturescore = house.furniturescore
    end
    if house ~= nil and house.petrewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.petrewardtime = house.petrewardtime
    end
    if house ~= nil and house.firerewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.firerewardtime = house.firerewardtime
    end
    if house ~= nil and house.dayvisitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.dayvisitcount = house.dayvisitcount
    end
    if house ~= nil and house.guide ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.guide = house.guide
    end
    if house ~= nil and house.default_furn ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.default_furn = house.default_furn
    end
    if house ~= nil and house.levelup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.levelup = house.levelup
    end
    if house ~= nil and house.woodrankopen ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.woodrankopen = house.woodrankopen
    end
    if house ~= nil and house.ftype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.ftype = house.ftype
    end
    if house ~= nil and house.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.state = house.state
    end
    if house.opt ~= nil and house.opt.open ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.open = house.opt.open
    end
    if house.opt ~= nil and house.opt.board_open ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.board_open = house.opt.board_open
    end
    if house.opt ~= nil and house.opt.enter_area ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.enter_area = house.opt.enter_area
    end
    if house.opt ~= nil and house.opt.furniture_show ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.furniture_show = house.opt.furniture_show
    end
    if house ~= nil and house.opt.forbid_self ~= nil then
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      if msgParam.house.opt.forbid_self == nil then
        msgParam.house.opt.forbid_self = {}
      end
      for i = 1, #house.opt.forbid_self do
        table.insert(msgParam.house.opt.forbid_self, house.opt.forbid_self[i])
      end
    end
    if house ~= nil and house.opt.forbid_other ~= nil then
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      if msgParam.house.opt.forbid_other == nil then
        msgParam.house.opt.forbid_other = {}
      end
      for i = 1, #house.opt.forbid_other do
        table.insert(msgParam.house.opt.forbid_other, house.opt.forbid_other[i])
      end
    end
    if house.opt ~= nil and house.opt.garden_house ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.garden_house = house.opt.garden_house
    end
    if house ~= nil and house.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.name = house.name
    end
    if house ~= nil and house.sign ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.sign = house.sign
    end
    if house ~= nil and house.board ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.board = house.board
    end
    if house ~= nil and house.decorates ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.decorates == nil then
        msgParam.house.decorates = {}
      end
      for i = 1, #house.decorates do
        table.insert(msgParam.house.decorates, house.decorates[i])
      end
    end
    if house ~= nil and house.pets ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.pets == nil then
        msgParam.house.pets = {}
      end
      for i = 1, #house.pets do
        table.insert(msgParam.house.pets, house.pets[i])
      end
    end
    if house ~= nil and house.radios ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.radios == nil then
        msgParam.house.radios = {}
      end
      for i = 1, #house.radios do
        table.insert(msgParam.house.radios, house.radios[i])
      end
    end
    if house ~= nil and house.boards ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.boards == nil then
        msgParam.house.boards = {}
      end
      for i = 1, #house.boards do
        table.insert(msgParam.house.boards, house.boards[i])
      end
    end
    if house ~= nil and house.events ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.events == nil then
        msgParam.house.events = {}
      end
      for i = 1, #house.events do
        table.insert(msgParam.house.events, house.events[i])
      end
    end
    if house ~= nil and house.week_clear_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.week_clear_time = house.week_clear_time
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_puton ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_puton = house.home_riskskilldata.last_puton
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_putoff ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_putoff = house.home_riskskilldata.last_putoff
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_reward ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_reward = house.home_riskskilldata.last_reward
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.cursize ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.cursize = house.home_riskskilldata.cursize
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.enable ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.enable = house.home_riskskilldata.enable
    end
    if furniture ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.furniture == nil then
        msgParam.furniture = {}
      end
      for i = 1, #furniture do
        table.insert(msgParam.furniture, furniture[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallFurnitureActionHomeCmd(action, items, nocheck)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.FurnitureActionHomeCmd()
    if action ~= nil then
      msg.action = action
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    if nocheck ~= nil then
      msg.nocheck = nocheck
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FurnitureActionHomeCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    if nocheck ~= nil then
      msgParam.nocheck = nocheck
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallFurnitureOperHomeCmd(oper, guid, value, source, data, values, wood_data)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.FurnitureOperHomeCmd()
    if oper ~= nil then
      msg.oper = oper
    end
    if guid ~= nil then
      msg.guid = guid
    end
    if value ~= nil then
      msg.value = value
    end
    if source ~= nil then
      msg.source = source
    end
    if data ~= nil then
      msg.data = data
    end
    if values ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.values == nil then
        msg.values = {}
      end
      for i = 1, #values do
        table.insert(msg.values, values[i])
      end
    end
    if wood_data ~= nil and wood_data.type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.type = wood_data.type
    end
    if wood_data ~= nil and wood_data.race ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.race = wood_data.race
    end
    if wood_data ~= nil and wood_data.shape ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.shape = wood_data.shape
    end
    if wood_data ~= nil and wood_data.nature ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.nature = wood_data.nature
    end
    if wood_data ~= nil and wood_data.damage_reduce ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.damage_reduce = wood_data.damage_reduce
    end
    if wood_data ~= nil and wood_data.nature_lv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.nature_lv = wood_data.nature_lv
    end
    if wood_data ~= nil and wood_data.boss_type ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.boss_type = wood_data.boss_type
    end
    if wood_data ~= nil and wood_data.monster_id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.wood_data == nil then
        msg.wood_data = {}
      end
      msg.wood_data.monster_id = wood_data.monster_id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FurnitureOperHomeCmd.id
    local msgParam = {}
    if oper ~= nil then
      msgParam.oper = oper
    end
    if guid ~= nil then
      msgParam.guid = guid
    end
    if value ~= nil then
      msgParam.value = value
    end
    if source ~= nil then
      msgParam.source = source
    end
    if data ~= nil then
      msgParam.data = data
    end
    if values ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.values == nil then
        msgParam.values = {}
      end
      for i = 1, #values do
        table.insert(msgParam.values, values[i])
      end
    end
    if wood_data ~= nil and wood_data.type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.type = wood_data.type
    end
    if wood_data ~= nil and wood_data.race ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.race = wood_data.race
    end
    if wood_data ~= nil and wood_data.shape ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.shape = wood_data.shape
    end
    if wood_data ~= nil and wood_data.nature ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.nature = wood_data.nature
    end
    if wood_data ~= nil and wood_data.damage_reduce ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.damage_reduce = wood_data.damage_reduce
    end
    if wood_data ~= nil and wood_data.nature_lv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.nature_lv = wood_data.nature_lv
    end
    if wood_data ~= nil and wood_data.boss_type ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.boss_type = wood_data.boss_type
    end
    if wood_data ~= nil and wood_data.monster_id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.wood_data == nil then
        msgParam.wood_data = {}
      end
      msgParam.wood_data.monster_id = wood_data.monster_id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallFurnitureUpdateHomeCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.FurnitureUpdateHomeCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FurnitureUpdateHomeCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallFurnitureDataUpdateHomeCmd(guid, updates)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.FurnitureDataUpdateHomeCmd()
    if guid ~= nil then
      msg.guid = guid
    end
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.FurnitureDataUpdateHomeCmd.id
    local msgParam = {}
    if guid ~= nil then
      msgParam.guid = guid
    end
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallHouseActionHomeCmd(action, dec)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.HouseActionHomeCmd()
    if action ~= nil then
      msg.action = action
    end
    if dec ~= nil and dec.floor ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dec == nil then
        msg.dec = {}
      end
      msg.dec.floor = dec.floor
    end
    if dec ~= nil and dec.ids ~= nil then
      if msg.dec == nil then
        msg.dec = {}
      end
      if msg.dec.ids == nil then
        msg.dec.ids = {}
      end
      for i = 1, #dec.ids do
        table.insert(msg.dec.ids, dec.ids[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HouseActionHomeCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if dec ~= nil and dec.floor ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dec == nil then
        msgParam.dec = {}
      end
      msgParam.dec.floor = dec.floor
    end
    if dec ~= nil and dec.ids ~= nil then
      if msgParam.dec == nil then
        msgParam.dec = {}
      end
      if msgParam.dec.ids == nil then
        msgParam.dec.ids = {}
      end
      for i = 1, #dec.ids do
        table.insert(msgParam.dec.ids, dec.ids[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallHouseDataUpdateHomeCmd(updates)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.HouseDataUpdateHomeCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.HouseDataUpdateHomeCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallPetFurnitureActionhomeCmd(action, index, petguid)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.PetFurnitureActionhomeCmd()
    if action ~= nil then
      msg.action = action
    end
    if index ~= nil then
      msg.index = index
    end
    if petguid ~= nil then
      msg.petguid = petguid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PetFurnitureActionhomeCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if index ~= nil then
      msgParam.index = index
    end
    if petguid ~= nil then
      msgParam.petguid = petguid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallPrayHomeCmd()
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.PrayHomeCmd()
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrayHomeCmd.id
    local msgParam = {}
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallEnterHomeCmd(accid, charid)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.EnterHomeCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if charid ~= nil then
      msg.charid = charid
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EnterHomeCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if charid ~= nil then
      msgParam.charid = charid
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallQueryHouseDataHomeCmd(house, garden)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.QueryHouseDataHomeCmd()
    if house ~= nil and house.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.accid = house.accid
    end
    if house ~= nil and house.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.id = house.id
    end
    if house ~= nil and house.visitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.visitcount = house.visitcount
    end
    if house ~= nil and house.furniturelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.furniturelv = house.furniturelv
    end
    if house ~= nil and house.furniturescore ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.furniturescore = house.furniturescore
    end
    if house ~= nil and house.petrewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.petrewardtime = house.petrewardtime
    end
    if house ~= nil and house.firerewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.firerewardtime = house.firerewardtime
    end
    if house ~= nil and house.dayvisitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.dayvisitcount = house.dayvisitcount
    end
    if house ~= nil and house.guide ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.guide = house.guide
    end
    if house ~= nil and house.default_furn ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.default_furn = house.default_furn
    end
    if house ~= nil and house.levelup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.levelup = house.levelup
    end
    if house ~= nil and house.woodrankopen ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.woodrankopen = house.woodrankopen
    end
    if house ~= nil and house.ftype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.ftype = house.ftype
    end
    if house ~= nil and house.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.state = house.state
    end
    if house.opt ~= nil and house.opt.open ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.open = house.opt.open
    end
    if house.opt ~= nil and house.opt.board_open ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.board_open = house.opt.board_open
    end
    if house.opt ~= nil and house.opt.enter_area ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.enter_area = house.opt.enter_area
    end
    if house.opt ~= nil and house.opt.furniture_show ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.furniture_show = house.opt.furniture_show
    end
    if house ~= nil and house.opt.forbid_self ~= nil then
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      if msg.house.opt.forbid_self == nil then
        msg.house.opt.forbid_self = {}
      end
      for i = 1, #house.opt.forbid_self do
        table.insert(msg.house.opt.forbid_self, house.opt.forbid_self[i])
      end
    end
    if house ~= nil and house.opt.forbid_other ~= nil then
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      if msg.house.opt.forbid_other == nil then
        msg.house.opt.forbid_other = {}
      end
      for i = 1, #house.opt.forbid_other do
        table.insert(msg.house.opt.forbid_other, house.opt.forbid_other[i])
      end
    end
    if house.opt ~= nil and house.opt.garden_house ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.opt == nil then
        msg.house.opt = {}
      end
      msg.house.opt.garden_house = house.opt.garden_house
    end
    if house ~= nil and house.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.name = house.name
    end
    if house ~= nil and house.sign ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.sign = house.sign
    end
    if house ~= nil and house.board ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.board = house.board
    end
    if house ~= nil and house.decorates ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.decorates == nil then
        msg.house.decorates = {}
      end
      for i = 1, #house.decorates do
        table.insert(msg.house.decorates, house.decorates[i])
      end
    end
    if house ~= nil and house.pets ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.pets == nil then
        msg.house.pets = {}
      end
      for i = 1, #house.pets do
        table.insert(msg.house.pets, house.pets[i])
      end
    end
    if house ~= nil and house.radios ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.radios == nil then
        msg.house.radios = {}
      end
      for i = 1, #house.radios do
        table.insert(msg.house.radios, house.radios[i])
      end
    end
    if house ~= nil and house.boards ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.boards == nil then
        msg.house.boards = {}
      end
      for i = 1, #house.boards do
        table.insert(msg.house.boards, house.boards[i])
      end
    end
    if house ~= nil and house.events ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.events == nil then
        msg.house.events = {}
      end
      for i = 1, #house.events do
        table.insert(msg.house.events, house.events[i])
      end
    end
    if house ~= nil and house.week_clear_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.house == nil then
        msg.house = {}
      end
      msg.house.week_clear_time = house.week_clear_time
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_puton ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_puton = house.home_riskskilldata.last_puton
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_putoff ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_putoff = house.home_riskskilldata.last_putoff
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_reward ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.last_reward = house.home_riskskilldata.last_reward
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.cursize ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.cursize = house.home_riskskilldata.cursize
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.enable ~= nil then
      if msg.house == nil then
        msg.house = {}
      end
      if msg.house.home_riskskilldata == nil then
        msg.house.home_riskskilldata = {}
      end
      msg.house.home_riskskilldata.enable = house.home_riskskilldata.enable
    end
    if garden ~= nil and garden.accid ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.accid = garden.accid
    end
    if garden ~= nil and garden.id ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.id = garden.id
    end
    if garden ~= nil and garden.visitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.visitcount = garden.visitcount
    end
    if garden ~= nil and garden.furniturelv ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.furniturelv = garden.furniturelv
    end
    if garden ~= nil and garden.furniturescore ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.furniturescore = garden.furniturescore
    end
    if garden ~= nil and garden.petrewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.petrewardtime = garden.petrewardtime
    end
    if garden ~= nil and garden.firerewardtime ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.firerewardtime = garden.firerewardtime
    end
    if garden ~= nil and garden.dayvisitcount ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.dayvisitcount = garden.dayvisitcount
    end
    if garden ~= nil and garden.guide ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.guide = garden.guide
    end
    if garden ~= nil and garden.default_furn ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.default_furn = garden.default_furn
    end
    if garden ~= nil and garden.levelup ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.levelup = garden.levelup
    end
    if garden ~= nil and garden.woodrankopen ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.woodrankopen = garden.woodrankopen
    end
    if garden ~= nil and garden.ftype ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.ftype = garden.ftype
    end
    if garden ~= nil and garden.state ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.state = garden.state
    end
    if garden.opt ~= nil and garden.opt.open ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      msg.garden.opt.open = garden.opt.open
    end
    if garden.opt ~= nil and garden.opt.board_open ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      msg.garden.opt.board_open = garden.opt.board_open
    end
    if garden.opt ~= nil and garden.opt.enter_area ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      msg.garden.opt.enter_area = garden.opt.enter_area
    end
    if garden.opt ~= nil and garden.opt.furniture_show ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      msg.garden.opt.furniture_show = garden.opt.furniture_show
    end
    if garden ~= nil and garden.opt.forbid_self ~= nil then
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      if msg.garden.opt.forbid_self == nil then
        msg.garden.opt.forbid_self = {}
      end
      for i = 1, #garden.opt.forbid_self do
        table.insert(msg.garden.opt.forbid_self, garden.opt.forbid_self[i])
      end
    end
    if garden ~= nil and garden.opt.forbid_other ~= nil then
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      if msg.garden.opt.forbid_other == nil then
        msg.garden.opt.forbid_other = {}
      end
      for i = 1, #garden.opt.forbid_other do
        table.insert(msg.garden.opt.forbid_other, garden.opt.forbid_other[i])
      end
    end
    if garden.opt ~= nil and garden.opt.garden_house ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.opt == nil then
        msg.garden.opt = {}
      end
      msg.garden.opt.garden_house = garden.opt.garden_house
    end
    if garden ~= nil and garden.name ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.name = garden.name
    end
    if garden ~= nil and garden.sign ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.sign = garden.sign
    end
    if garden ~= nil and garden.board ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.board = garden.board
    end
    if garden ~= nil and garden.decorates ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.decorates == nil then
        msg.garden.decorates = {}
      end
      for i = 1, #garden.decorates do
        table.insert(msg.garden.decorates, garden.decorates[i])
      end
    end
    if garden ~= nil and garden.pets ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.pets == nil then
        msg.garden.pets = {}
      end
      for i = 1, #garden.pets do
        table.insert(msg.garden.pets, garden.pets[i])
      end
    end
    if garden ~= nil and garden.radios ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.radios == nil then
        msg.garden.radios = {}
      end
      for i = 1, #garden.radios do
        table.insert(msg.garden.radios, garden.radios[i])
      end
    end
    if garden ~= nil and garden.boards ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.boards == nil then
        msg.garden.boards = {}
      end
      for i = 1, #garden.boards do
        table.insert(msg.garden.boards, garden.boards[i])
      end
    end
    if garden ~= nil and garden.events ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.events == nil then
        msg.garden.events = {}
      end
      for i = 1, #garden.events do
        table.insert(msg.garden.events, garden.events[i])
      end
    end
    if garden ~= nil and garden.week_clear_time ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.garden == nil then
        msg.garden = {}
      end
      msg.garden.week_clear_time = garden.week_clear_time
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_puton ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.home_riskskilldata == nil then
        msg.garden.home_riskskilldata = {}
      end
      msg.garden.home_riskskilldata.last_puton = garden.home_riskskilldata.last_puton
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_putoff ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.home_riskskilldata == nil then
        msg.garden.home_riskskilldata = {}
      end
      msg.garden.home_riskskilldata.last_putoff = garden.home_riskskilldata.last_putoff
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_reward ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.home_riskskilldata == nil then
        msg.garden.home_riskskilldata = {}
      end
      msg.garden.home_riskskilldata.last_reward = garden.home_riskskilldata.last_reward
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.cursize ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.home_riskskilldata == nil then
        msg.garden.home_riskskilldata = {}
      end
      msg.garden.home_riskskilldata.cursize = garden.home_riskskilldata.cursize
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.enable ~= nil then
      if msg.garden == nil then
        msg.garden = {}
      end
      if msg.garden.home_riskskilldata == nil then
        msg.garden.home_riskskilldata = {}
      end
      msg.garden.home_riskskilldata.enable = garden.home_riskskilldata.enable
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryHouseDataHomeCmd.id
    local msgParam = {}
    if house ~= nil and house.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.accid = house.accid
    end
    if house ~= nil and house.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.id = house.id
    end
    if house ~= nil and house.visitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.visitcount = house.visitcount
    end
    if house ~= nil and house.furniturelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.furniturelv = house.furniturelv
    end
    if house ~= nil and house.furniturescore ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.furniturescore = house.furniturescore
    end
    if house ~= nil and house.petrewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.petrewardtime = house.petrewardtime
    end
    if house ~= nil and house.firerewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.firerewardtime = house.firerewardtime
    end
    if house ~= nil and house.dayvisitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.dayvisitcount = house.dayvisitcount
    end
    if house ~= nil and house.guide ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.guide = house.guide
    end
    if house ~= nil and house.default_furn ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.default_furn = house.default_furn
    end
    if house ~= nil and house.levelup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.levelup = house.levelup
    end
    if house ~= nil and house.woodrankopen ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.woodrankopen = house.woodrankopen
    end
    if house ~= nil and house.ftype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.ftype = house.ftype
    end
    if house ~= nil and house.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.state = house.state
    end
    if house.opt ~= nil and house.opt.open ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.open = house.opt.open
    end
    if house.opt ~= nil and house.opt.board_open ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.board_open = house.opt.board_open
    end
    if house.opt ~= nil and house.opt.enter_area ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.enter_area = house.opt.enter_area
    end
    if house.opt ~= nil and house.opt.furniture_show ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.furniture_show = house.opt.furniture_show
    end
    if house ~= nil and house.opt.forbid_self ~= nil then
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      if msgParam.house.opt.forbid_self == nil then
        msgParam.house.opt.forbid_self = {}
      end
      for i = 1, #house.opt.forbid_self do
        table.insert(msgParam.house.opt.forbid_self, house.opt.forbid_self[i])
      end
    end
    if house ~= nil and house.opt.forbid_other ~= nil then
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      if msgParam.house.opt.forbid_other == nil then
        msgParam.house.opt.forbid_other = {}
      end
      for i = 1, #house.opt.forbid_other do
        table.insert(msgParam.house.opt.forbid_other, house.opt.forbid_other[i])
      end
    end
    if house.opt ~= nil and house.opt.garden_house ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.opt == nil then
        msgParam.house.opt = {}
      end
      msgParam.house.opt.garden_house = house.opt.garden_house
    end
    if house ~= nil and house.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.name = house.name
    end
    if house ~= nil and house.sign ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.sign = house.sign
    end
    if house ~= nil and house.board ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.board = house.board
    end
    if house ~= nil and house.decorates ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.decorates == nil then
        msgParam.house.decorates = {}
      end
      for i = 1, #house.decorates do
        table.insert(msgParam.house.decorates, house.decorates[i])
      end
    end
    if house ~= nil and house.pets ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.pets == nil then
        msgParam.house.pets = {}
      end
      for i = 1, #house.pets do
        table.insert(msgParam.house.pets, house.pets[i])
      end
    end
    if house ~= nil and house.radios ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.radios == nil then
        msgParam.house.radios = {}
      end
      for i = 1, #house.radios do
        table.insert(msgParam.house.radios, house.radios[i])
      end
    end
    if house ~= nil and house.boards ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.boards == nil then
        msgParam.house.boards = {}
      end
      for i = 1, #house.boards do
        table.insert(msgParam.house.boards, house.boards[i])
      end
    end
    if house ~= nil and house.events ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.events == nil then
        msgParam.house.events = {}
      end
      for i = 1, #house.events do
        table.insert(msgParam.house.events, house.events[i])
      end
    end
    if house ~= nil and house.week_clear_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.house == nil then
        msgParam.house = {}
      end
      msgParam.house.week_clear_time = house.week_clear_time
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_puton ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_puton = house.home_riskskilldata.last_puton
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_putoff ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_putoff = house.home_riskskilldata.last_putoff
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.last_reward ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.last_reward = house.home_riskskilldata.last_reward
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.cursize ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.cursize = house.home_riskskilldata.cursize
    end
    if house.home_riskskilldata ~= nil and house.home_riskskilldata.enable ~= nil then
      if msgParam.house == nil then
        msgParam.house = {}
      end
      if msgParam.house.home_riskskilldata == nil then
        msgParam.house.home_riskskilldata = {}
      end
      msgParam.house.home_riskskilldata.enable = house.home_riskskilldata.enable
    end
    if garden ~= nil and garden.accid ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.accid = garden.accid
    end
    if garden ~= nil and garden.id ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.id = garden.id
    end
    if garden ~= nil and garden.visitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.visitcount = garden.visitcount
    end
    if garden ~= nil and garden.furniturelv ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.furniturelv = garden.furniturelv
    end
    if garden ~= nil and garden.furniturescore ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.furniturescore = garden.furniturescore
    end
    if garden ~= nil and garden.petrewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.petrewardtime = garden.petrewardtime
    end
    if garden ~= nil and garden.firerewardtime ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.firerewardtime = garden.firerewardtime
    end
    if garden ~= nil and garden.dayvisitcount ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.dayvisitcount = garden.dayvisitcount
    end
    if garden ~= nil and garden.guide ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.guide = garden.guide
    end
    if garden ~= nil and garden.default_furn ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.default_furn = garden.default_furn
    end
    if garden ~= nil and garden.levelup ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.levelup = garden.levelup
    end
    if garden ~= nil and garden.woodrankopen ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.woodrankopen = garden.woodrankopen
    end
    if garden ~= nil and garden.ftype ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.ftype = garden.ftype
    end
    if garden ~= nil and garden.state ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.state = garden.state
    end
    if garden.opt ~= nil and garden.opt.open ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      msgParam.garden.opt.open = garden.opt.open
    end
    if garden.opt ~= nil and garden.opt.board_open ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      msgParam.garden.opt.board_open = garden.opt.board_open
    end
    if garden.opt ~= nil and garden.opt.enter_area ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      msgParam.garden.opt.enter_area = garden.opt.enter_area
    end
    if garden.opt ~= nil and garden.opt.furniture_show ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      msgParam.garden.opt.furniture_show = garden.opt.furniture_show
    end
    if garden ~= nil and garden.opt.forbid_self ~= nil then
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      if msgParam.garden.opt.forbid_self == nil then
        msgParam.garden.opt.forbid_self = {}
      end
      for i = 1, #garden.opt.forbid_self do
        table.insert(msgParam.garden.opt.forbid_self, garden.opt.forbid_self[i])
      end
    end
    if garden ~= nil and garden.opt.forbid_other ~= nil then
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      if msgParam.garden.opt.forbid_other == nil then
        msgParam.garden.opt.forbid_other = {}
      end
      for i = 1, #garden.opt.forbid_other do
        table.insert(msgParam.garden.opt.forbid_other, garden.opt.forbid_other[i])
      end
    end
    if garden.opt ~= nil and garden.opt.garden_house ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.opt == nil then
        msgParam.garden.opt = {}
      end
      msgParam.garden.opt.garden_house = garden.opt.garden_house
    end
    if garden ~= nil and garden.name ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.name = garden.name
    end
    if garden ~= nil and garden.sign ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.sign = garden.sign
    end
    if garden ~= nil and garden.board ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.board = garden.board
    end
    if garden ~= nil and garden.decorates ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.decorates == nil then
        msgParam.garden.decorates = {}
      end
      for i = 1, #garden.decorates do
        table.insert(msgParam.garden.decorates, garden.decorates[i])
      end
    end
    if garden ~= nil and garden.pets ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.pets == nil then
        msgParam.garden.pets = {}
      end
      for i = 1, #garden.pets do
        table.insert(msgParam.garden.pets, garden.pets[i])
      end
    end
    if garden ~= nil and garden.radios ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.radios == nil then
        msgParam.garden.radios = {}
      end
      for i = 1, #garden.radios do
        table.insert(msgParam.garden.radios, garden.radios[i])
      end
    end
    if garden ~= nil and garden.boards ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.boards == nil then
        msgParam.garden.boards = {}
      end
      for i = 1, #garden.boards do
        table.insert(msgParam.garden.boards, garden.boards[i])
      end
    end
    if garden ~= nil and garden.events ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.events == nil then
        msgParam.garden.events = {}
      end
      for i = 1, #garden.events do
        table.insert(msgParam.garden.events, garden.events[i])
      end
    end
    if garden ~= nil and garden.week_clear_time ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      msgParam.garden.week_clear_time = garden.week_clear_time
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_puton ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.home_riskskilldata == nil then
        msgParam.garden.home_riskskilldata = {}
      end
      msgParam.garden.home_riskskilldata.last_puton = garden.home_riskskilldata.last_puton
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_putoff ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.home_riskskilldata == nil then
        msgParam.garden.home_riskskilldata = {}
      end
      msgParam.garden.home_riskskilldata.last_putoff = garden.home_riskskilldata.last_putoff
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.last_reward ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.home_riskskilldata == nil then
        msgParam.garden.home_riskskilldata = {}
      end
      msgParam.garden.home_riskskilldata.last_reward = garden.home_riskskilldata.last_reward
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.cursize ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.home_riskskilldata == nil then
        msgParam.garden.home_riskskilldata = {}
      end
      msgParam.garden.home_riskskilldata.cursize = garden.home_riskskilldata.cursize
    end
    if garden.home_riskskilldata ~= nil and garden.home_riskskilldata.enable ~= nil then
      if msgParam.garden == nil then
        msgParam.garden = {}
      end
      if msgParam.garden.home_riskskilldata == nil then
        msgParam.garden.home_riskskilldata = {}
      end
      msgParam.garden.home_riskskilldata.enable = garden.home_riskskilldata.enable
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallQueryHouseFurnitureHomeCmd(sessionid, type, furnitures)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.QueryHouseFurnitureHomeCmd()
    if sessionid ~= nil then
      msg.sessionid = sessionid
    end
    if type ~= nil then
      msg.type = type
    end
    if furnitures ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.furnitures == nil then
        msg.furnitures = {}
      end
      for i = 1, #furnitures do
        table.insert(msg.furnitures, furnitures[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryHouseFurnitureHomeCmd.id
    local msgParam = {}
    if sessionid ~= nil then
      msgParam.sessionid = sessionid
    end
    if type ~= nil then
      msgParam.type = type
    end
    if furnitures ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.furnitures == nil then
        msgParam.furnitures = {}
      end
      for i = 1, #furnitures do
        table.insert(msgParam.furnitures, furnitures[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallOptUpdateHomeCmd(accid, data, value, ids, str)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.OptUpdateHomeCmd()
    if accid ~= nil then
      msg.accid = accid
    end
    if data ~= nil then
      msg.data = data
    end
    if value ~= nil then
      msg.value = value
    end
    if ids ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ids == nil then
        msg.ids = {}
      end
      for i = 1, #ids do
        table.insert(msg.ids, ids[i])
      end
    end
    if str ~= nil then
      msg.str = str
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.OptUpdateHomeCmd.id
    local msgParam = {}
    if accid ~= nil then
      msgParam.accid = accid
    end
    if data ~= nil then
      msgParam.data = data
    end
    if value ~= nil then
      msgParam.value = value
    end
    if ids ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ids == nil then
        msgParam.ids = {}
      end
      for i = 1, #ids do
        table.insert(msgParam.ids, ids[i])
      end
    end
    if str ~= nil then
      msgParam.str = str
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallPrintActionHomeCmd(action, id)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.PrintActionHomeCmd()
    if action ~= nil then
      msg.action = action
    end
    if id ~= nil then
      msg.id = id
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrintActionHomeCmd.id
    local msgParam = {}
    if action ~= nil then
      msgParam.action = action
    end
    if id ~= nil then
      msgParam.id = id
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallPrintUpdateHomeCmd(items)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.PrintUpdateHomeCmd()
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.PrintUpdateHomeCmd.id
    local msgParam = {}
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallBoardItemQueryHomeCmd(page, totalcount, available, items)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.BoardItemQueryHomeCmd()
    if page ~= nil then
      msg.page = page
    end
    if totalcount ~= nil then
      msg.totalcount = totalcount
    end
    if available ~= nil then
      msg.available = available
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardItemQueryHomeCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if totalcount ~= nil then
      msgParam.totalcount = totalcount
    end
    if available ~= nil then
      msgParam.available = available
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallBoardItemUpdateHomeCmd(updates, dels)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.BoardItemUpdateHomeCmd()
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardItemUpdateHomeCmd.id
    local msgParam = {}
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallBoardMsgUpdateHomeCmd(time, updates, dels)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.BoardMsgUpdateHomeCmd()
    if time ~= nil then
      msg.time = time
    end
    if updates ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.updates == nil then
        msg.updates = {}
      end
      for i = 1, #updates do
        table.insert(msg.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.dels == nil then
        msg.dels = {}
      end
      for i = 1, #dels do
        table.insert(msg.dels, dels[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.BoardMsgUpdateHomeCmd.id
    local msgParam = {}
    if time ~= nil then
      msgParam.time = time
    end
    if updates ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.updates == nil then
        msgParam.updates = {}
      end
      for i = 1, #updates do
        table.insert(msgParam.updates, updates[i])
      end
    end
    if dels ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.dels == nil then
        msgParam.dels = {}
      end
      for i = 1, #dels do
        table.insert(msgParam.dels, dels[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallEventItemQueryHomeCmd(page, totalcount, visitcount, dayvisitcount, items)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.EventItemQueryHomeCmd()
    if page ~= nil then
      msg.page = page
    end
    if totalcount ~= nil then
      msg.totalcount = totalcount
    end
    if visitcount ~= nil then
      msg.visitcount = visitcount
    end
    if dayvisitcount ~= nil then
      msg.dayvisitcount = dayvisitcount
    end
    if items ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.items == nil then
        msg.items = {}
      end
      for i = 1, #items do
        table.insert(msg.items, items[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.EventItemQueryHomeCmd.id
    local msgParam = {}
    if page ~= nil then
      msgParam.page = page
    end
    if totalcount ~= nil then
      msgParam.totalcount = totalcount
    end
    if visitcount ~= nil then
      msgParam.visitcount = visitcount
    end
    if dayvisitcount ~= nil then
      msgParam.dayvisitcount = dayvisitcount
    end
    if items ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.items == nil then
        msgParam.items = {}
      end
      for i = 1, #items do
        table.insert(msgParam.items, items[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:CallQueryWoodRankHomeCmd(typebranch, hpreduce, over, ranks)
  if not NetConfig.PBC then
    local msg = HomeCmd_pb.QueryWoodRankHomeCmd()
    if typebranch ~= nil then
      msg.typebranch = typebranch
    end
    if hpreduce ~= nil then
      msg.hpreduce = hpreduce
    end
    if over ~= nil then
      msg.over = over
    end
    if ranks ~= nil then
      if msg == nil then
        msg = {}
      end
      if msg.ranks == nil then
        msg.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msg.ranks, ranks[i])
      end
    end
    self:SendProto(msg)
  else
    local msgId = ProtoReqInfoList.QueryWoodRankHomeCmd.id
    local msgParam = {}
    if typebranch ~= nil then
      msgParam.typebranch = typebranch
    end
    if hpreduce ~= nil then
      msgParam.hpreduce = hpreduce
    end
    if over ~= nil then
      msgParam.over = over
    end
    if ranks ~= nil then
      if msgParam == nil then
        msgParam = {}
      end
      if msgParam.ranks == nil then
        msgParam.ranks = {}
      end
      for i = 1, #ranks do
        table.insert(msgParam.ranks, ranks[i])
      end
    end
    self:SendProto2(msgId, msgParam)
  end
end

function ServiceHomeCmdAutoProxy:RecvQueryFurnitureDataHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryFurnitureDataHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvFurnitureActionHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureActionHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvFurnitureOperHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureOperHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvFurnitureUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvFurnitureDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdFurnitureDataUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvHouseActionHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdHouseActionHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvHouseDataUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdHouseDataUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvPetFurnitureActionhomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdPetFurnitureActionhomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvPrayHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdPrayHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvEnterHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdEnterHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvQueryHouseDataHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseDataHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvQueryHouseFurnitureHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryHouseFurnitureHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvOptUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdOptUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvPrintActionHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdPrintActionHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvPrintUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdPrintUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvBoardItemQueryHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdBoardItemQueryHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvBoardItemUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdBoardItemUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvBoardMsgUpdateHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdBoardMsgUpdateHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvEventItemQueryHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdEventItemQueryHomeCmd, data)
end

function ServiceHomeCmdAutoProxy:RecvQueryWoodRankHomeCmd(data)
  self:Notify(ServiceEvent.HomeCmdQueryWoodRankHomeCmd, data)
end

ServiceEvent = _G.ServiceEvent or {}
ServiceEvent.HomeCmdQueryFurnitureDataHomeCmd = "ServiceEvent_HomeCmdQueryFurnitureDataHomeCmd"
ServiceEvent.HomeCmdFurnitureActionHomeCmd = "ServiceEvent_HomeCmdFurnitureActionHomeCmd"
ServiceEvent.HomeCmdFurnitureOperHomeCmd = "ServiceEvent_HomeCmdFurnitureOperHomeCmd"
ServiceEvent.HomeCmdFurnitureUpdateHomeCmd = "ServiceEvent_HomeCmdFurnitureUpdateHomeCmd"
ServiceEvent.HomeCmdFurnitureDataUpdateHomeCmd = "ServiceEvent_HomeCmdFurnitureDataUpdateHomeCmd"
ServiceEvent.HomeCmdHouseActionHomeCmd = "ServiceEvent_HomeCmdHouseActionHomeCmd"
ServiceEvent.HomeCmdHouseDataUpdateHomeCmd = "ServiceEvent_HomeCmdHouseDataUpdateHomeCmd"
ServiceEvent.HomeCmdPetFurnitureActionhomeCmd = "ServiceEvent_HomeCmdPetFurnitureActionhomeCmd"
ServiceEvent.HomeCmdPrayHomeCmd = "ServiceEvent_HomeCmdPrayHomeCmd"
ServiceEvent.HomeCmdEnterHomeCmd = "ServiceEvent_HomeCmdEnterHomeCmd"
ServiceEvent.HomeCmdQueryHouseDataHomeCmd = "ServiceEvent_HomeCmdQueryHouseDataHomeCmd"
ServiceEvent.HomeCmdQueryHouseFurnitureHomeCmd = "ServiceEvent_HomeCmdQueryHouseFurnitureHomeCmd"
ServiceEvent.HomeCmdOptUpdateHomeCmd = "ServiceEvent_HomeCmdOptUpdateHomeCmd"
ServiceEvent.HomeCmdPrintActionHomeCmd = "ServiceEvent_HomeCmdPrintActionHomeCmd"
ServiceEvent.HomeCmdPrintUpdateHomeCmd = "ServiceEvent_HomeCmdPrintUpdateHomeCmd"
ServiceEvent.HomeCmdBoardItemQueryHomeCmd = "ServiceEvent_HomeCmdBoardItemQueryHomeCmd"
ServiceEvent.HomeCmdBoardItemUpdateHomeCmd = "ServiceEvent_HomeCmdBoardItemUpdateHomeCmd"
ServiceEvent.HomeCmdBoardMsgUpdateHomeCmd = "ServiceEvent_HomeCmdBoardMsgUpdateHomeCmd"
ServiceEvent.HomeCmdEventItemQueryHomeCmd = "ServiceEvent_HomeCmdEventItemQueryHomeCmd"
ServiceEvent.HomeCmdQueryWoodRankHomeCmd = "ServiceEvent_HomeCmdQueryWoodRankHomeCmd"
