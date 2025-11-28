Table_AccumDeposit = {
  [1] = {
    id = 1,
    ServerID = _EmptyTable,
    Duration = {
      "2025-08-29 05:00:00",
      "2025-09-19 05:00:00"
    },
    TfDuration = {
      "2025-08-22 05:00:00",
      "2025-09-12 05:00:00"
    },
    Reward = {
      [1] = {
        need_deposit = 0,
        reward = {10000319, 1}
      },
      [2] = {
        need_deposit = 4.99,
        reward = {100, 5000000}
      },
      [3] = {
        need_deposit = 9.99,
        reward = {10000320, 3}
      },
      [4] = {
        need_deposit = 17.99,
        reward = {52836, 800}
      },
      [5] = {
        need_deposit = 45.99,
        reward = {52838, 1}
      },
      [6] = {
        need_deposit = 89.99,
        reward = {3013154, 1}
      }
    },
    ShowNpc = 894412,
    AdText = "##44703553"
  },
  [2] = {
    id = 2,
    ServerID = _EmptyTable,
    Duration = {
      "2025-11-26 05:00:00",
      "2025-12-26 05:00:00"
    },
    TfDuration = {
      "2025-11-14 05:00:00",
      "2025-12-14 05:00:00"
    },
    Reward = {
      [1] = {
        need_deposit = 0,
        reward = {3012848, 5}
      },
      [2] = {
        need_deposit = 4.99,
        reward = {3012848, 15}
      },
      [3] = {
        need_deposit = 9.99,
        reward = {10000320, 3}
      },
      [4] = {
        need_deposit = 17.99,
        reward = {3012848, 50}
      },
      [5] = {
        need_deposit = 45.99,
        reward = {52838, 1}
      },
      [6] = {
        need_deposit = 89.99,
        reward = {10000422, 1},
        extraTip = "##44706344"
      }
    },
    ShowNpc = 894420,
    AdText = "##44706881"
  }
}
Table_AccumDeposit_fields = {
  "id",
  "ServerID",
  "Duration",
  "TfDuration",
  "Reward",
  "ShowNpc",
  "AdText"
}
return Table_AccumDeposit
