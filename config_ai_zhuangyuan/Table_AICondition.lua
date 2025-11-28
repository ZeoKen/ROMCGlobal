Table_AICondition = {
  [1] = {
    id = 1,
    Content = "time",
    Type = 1,
    Params = {hour = 9, interactNpcId = 822220},
    EventId = 113,
    Probability = 100
  },
  [2] = {
    id = 2,
    Content = "photograph",
    Type = 2,
    Params = {
      range = 5,
      updateRange = 2,
      updateAngle = 90
    },
    EventId = 121,
    Probability = 100
  },
  [3] = {
    id = 3,
    Content = "fashion",
    Type = 3,
    Params = {
      range = 3,
      Or = {
        {part = "HEAD", id = 149545},
        {part = "BODY", id = 60105},
        {part = "BODY", id = 60106},
        {part = "BODY", id = 60107},
        {part = "BODY", id = 60108},
        {part = "BODY", id = 331},
        {part = "BODY", id = 332},
        {part = "BODY", id = 333},
        {part = "BODY", id = 334},
        {part = "BODY", id = 60604},
        {part = "BODY", id = 60605},
        {part = "BODY", id = 60606},
        {part = "BODY", id = 60607},
        {part = "BODY", id = 60614},
        {part = "BODY", id = 60615},
        {part = "BODY", id = 60616},
        {part = "BODY", id = 60617}
      }
    },
    EventId = 122,
    Probability = 100
  },
  [4] = {
    id = 4,
    Content = "damage",
    Type = 2,
    Params = {range = 5},
    EventId = 123,
    Probability = 100
  },
  [5] = {
    id = 5,
    Content = "interactNpc",
    Type = 2,
    Params = {range = 3, interactNpcId = 822193},
    EventId = 127,
    Probability = 100
  },
  [6] = {
    id = 6,
    Content = "cpOccupied",
    Type = 3,
    Params = {
      range = 3,
      occupiedNpcs = {
        {id = 822193, exitEventId = 126},
        {id = 822194, exitEventId = 130},
        {id = 822195, exitEventId = 134},
        {id = 822196, exitEventId = 138}
      },
      slotId = 1
    },
    EventId = 125,
    Probability = 100
  },
  [7] = {
    id = 7,
    Content = "time",
    Type = 1,
    Params = {hour = 14, interactNpcId = 822220},
    EventId = 113,
    Probability = 100
  },
  [8] = {
    id = 8,
    Content = "time",
    Type = 1,
    Params = {hour = 20, interactNpcId = 822220},
    EventId = 113,
    Probability = 100
  },
  [9] = {
    id = 9,
    Content = "interactNpc",
    Type = 2,
    Params = {range = 3, interactNpcId = 822194},
    EventId = 131,
    Probability = 100
  },
  [10] = {
    id = 10,
    Content = "interactNpc",
    Type = 2,
    Params = {range = 3, interactNpcId = 822195},
    EventId = 135,
    Probability = 100
  },
  [11] = {
    id = 11,
    Content = "interactNpc",
    Type = 2,
    Params = {range = 3, interactNpcId = 822196},
    EventId = 139,
    Probability = 100
  }
}
Table_AICondition_fields = {
  "id",
  "Content",
  "Type",
  "Params",
  "EventId",
  "Probability"
}
return Table_AICondition
