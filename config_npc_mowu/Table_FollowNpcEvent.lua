Table_FollowNpcEvent = {
  [1] = {
    id = 1,
    type = 1,
    params = {emojiid = 1},
    isLoop = 1,
    condition = _EmptyTable
  },
  [2] = {
    id = 2,
    type = 2,
    params = {dialogid = 657336},
    isLoop = 1,
    condition = _EmptyTable
  },
  [3] = {
    id = 3,
    type = 3,
    params = {
      audiopath = "Npc/neula_8"
    },
    isLoop = 1,
    condition = _EmptyTable
  },
  [4] = {
    id = 4,
    type = 4,
    params = {pqtlName = 11020},
    isLoop = 1,
    condition = {
      id = 4,
      type = 100005,
      pos = {
        -46.14,
        3.76,
        -79.83
      },
      range = 30
    },
    interruptType = 1
  },
  [5] = {
    id = 5,
    type = 1,
    params = {emojiid = 1},
    condition = {
      id = 5,
      type = 100005,
      pos = {
        2.2,
        1.84,
        -115.9
      },
      range = 5
    },
    interruptType = 2
  },
  [6] = {
    id = 6,
    type = 2,
    params = {dialogid = 657336},
    condition = {
      id = 6,
      type = 100005,
      pos = {
        -10.29,
        1.84,
        -122.86
      },
      range = 5
    },
    interruptType = 2
  },
  [7] = {
    id = 7,
    type = 3,
    params = {
      audiopath = "Npc/neula_8neula_8"
    },
    condition = {
      id = 7,
      type = 100005,
      pos = {
        -25.5,
        1.84,
        -128.3
      },
      range = 30
    },
    interruptType = 2
  },
  [8] = {
    id = 8,
    type = 2,
    params = {dialogid = 657507},
    condition = _EmptyTable,
    interruptType = 2
  },
  [9] = {
    id = 9,
    type = 2,
    params = {dialogid = 657508},
    condition = _EmptyTable,
    interruptType = 2
  },
  [10] = {
    id = 10,
    type = 2,
    params = {dialogid = 657508},
    condition = _EmptyTable,
    interruptType = 2
  },
  [11] = {
    id = 11,
    type = 4,
    params = {pqtlName = 11060},
    isLoop = 1,
    condition = {
      id = 11,
      type = 100005,
      pos = {
        9.81,
        10.7,
        85.54
      },
      range = 66
    },
    interruptType = 1
  },
  [12] = {
    id = 12,
    type = 4,
    params = {pqtlName = 11061},
    isLoop = 1,
    condition = {
      id = 12,
      type = 100005,
      pos = {
        9.81,
        10.7,
        85.54
      },
      range = 66
    },
    interruptType = 1
  },
  [13] = {
    id = 13,
    type = 2,
    params = {dialogid = 657934},
    condition = _EmptyTable,
    interruptType = 2
  },
  [14] = {
    id = 14,
    type = 2,
    params = {dialogid = 657633},
    condition = _EmptyTable,
    interruptType = 2
  },
  [15] = {
    id = 15,
    type = 4,
    params = {pqtlName = 11062},
    isLoop = 1,
    condition = {
      id = 15,
      type = 100005,
      pos = {
        100.23,
        -5.21,
        5.22
      },
      range = 20
    },
    interruptType = 1
  },
  [16] = {
    id = 16,
    type = 4,
    params = {pqtlName = 11063},
    isLoop = 1,
    condition = {
      id = 16,
      type = 100005,
      pos = {
        100.23,
        -5.21,
        5.22
      },
      range = 20
    },
    interruptType = 1
  },
  [17] = {
    id = 17,
    type = 2,
    params = {dialogid = 657820},
    condition = _EmptyTable,
    interruptType = 2
  },
  [18] = {
    id = 18,
    type = 4,
    params = {pqtlName = 11064},
    isLoop = 1,
    condition = {
      id = 18,
      type = 100005,
      pos = {
        -4.77,
        10.77,
        39.32
      },
      range = 25
    },
    interruptType = 1
  }
}
Table_FollowNpcEvent_fields = {
  "id",
  "type",
  "params",
  "isLoop",
  "condition",
  "interruptType"
}
return Table_FollowNpcEvent
