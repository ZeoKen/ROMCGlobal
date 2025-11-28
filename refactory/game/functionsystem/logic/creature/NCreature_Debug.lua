function NCreature:Debug()
  roerr("======================= Begin =======================")
  
  local ai = self.ai
  local assetRole = self.assetRole
  local data = self.data
  roerr("id:", data.id, "assetGUID:", self.assetRole:GetGUID())
  if data.staticData then
    roerr("NpcId:", data.staticData.id, "Uniqueid:", data.uniqueid)
  end
  roerr("CellPriority:", self.cellPriority)
  local currentCommand = ai.currentCmd
  roerr("Current Command:", currentCommand and currentCommand.AIClass.ToString() or "nil")
  local nextCommand = ai.nextCmd
  roerr("Next Command:", nextCommand and nextCommand.AIClass.ToString() or "nil")
  local nextCommand1 = ai.nextCmd1
  roerr("Next Command1:", nextCommand1 and nextCommand1.AIClass.ToString() or "nil")
  local cmdQueue = ai.cmdQueue
  if nil ~= cmdQueue then
    for i = 1, #cmdQueue do
      if cmdQueue[i] then
        roerr("Command In Queue:", i, cmdQueue[i].AIClass.ToString())
      end
    end
  end
  roerr("======================= End =======================")
end
