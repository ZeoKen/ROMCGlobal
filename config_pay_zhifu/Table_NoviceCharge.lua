Table_NoviceCharge = {
  [1] = {
    id = 1,
    Duration = {
      "2022-12-28 05:00:00",
      "2022-12-31 05:00:00"
    },
    TfDuration = {
      "2022-12-15 05:00:00",
      "2022-12-31 05:00:00"
    },
    DuringDay = 30,
    Reward = {
      [1] = {
        ChargeNum = 6,
        RewardList = {
          [1] = {
            Rewards = {
              {100, 1000000},
              {901440, 1}
            },
            Tips = "##1283449"
          },
          [2] = {
            Rewards = {
              {100, 2000000},
              {6959, 3}
            }
          },
          [3] = {
            Rewards = {
              {100, 3000000},
              {6959, 3}
            }
          }
        }
      },
      [2] = {
        Deposit = 299,
        RewardList = {
          [1] = {
            Rewards = {
              {100, 1000000},
              {6959, 3}
            }
          },
          [2] = {
            Rewards = {
              {100, 2000000},
              {6959, 3}
            }
          },
          [3] = {
            Rewards = {
              {100, 3000000},
              {25157, 1}
            },
            Tips = "##1283450"
          }
        }
      },
      [3] = {
        ChargeNum = 128,
        RewardList = {
          [1] = {
            Rewards = {
              {100, 2000000},
              {6959, 6}
            }
          },
          [2] = {
            Rewards = {
              {100, 3000000},
              {23137, 1}
            },
            Tips = "##1283451"
          },
          [3] = {
            Rewards = {
              {100, 5000000},
              {5840, 5}
            }
          }
        }
      }
    }
  }
}
Table_NoviceCharge_fields = {
  "id",
  "Duration",
  "TfDuration",
  "DuringDay",
  "Reward"
}
return Table_NoviceCharge
