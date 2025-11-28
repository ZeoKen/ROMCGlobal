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
        need_deposit = 30,
        reward = {100, 5000000}
      },
      [3] = {
        need_deposit = 68,
        reward = {10000320, 3}
      },
      [4] = {
        need_deposit = 128,
        reward = {52836, 800}
      },
      [5] = {
        need_deposit = 328,
        reward = {52838, 1}
      },
      [6] = {
        need_deposit = 648,
        reward = {3013154, 1}
      }
    },
    ShowNpc = 894412,
    AdText = "累计打赏648，赠限定双人坐骑！"
  },
  [2] = {
    id = 2,
    ServerID = _EmptyTable,
    Duration = {
      "2025-09-24 05:00:00",
      "2025-10-24 05:00:00"
    },
    TfDuration = {
      "2025-09-11 05:00:00",
      "2025-10-11 05:00:00"
    },
    Reward = {
      [1] = {
        need_deposit = 0,
        reward = {3012848, 5}
      },
      [2] = {
        need_deposit = 30,
        reward = {3012848, 15}
      },
      [3] = {
        need_deposit = 68,
        reward = {10000320, 3}
      },
      [4] = {
        need_deposit = 128,
        reward = {3012848, 50}
      },
      [5] = {
        need_deposit = 328,
        reward = {52838, 1}
      },
      [6] = {
        need_deposit = 648,
        reward = {10000422, 1},
        extraTip = "限定坐骑"
      }
    },
    ShowNpc = 894420,
    AdText = "累计充值达到648，赠限定坐骑！"
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
