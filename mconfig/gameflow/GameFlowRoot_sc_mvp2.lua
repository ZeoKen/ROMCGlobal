local GameFlowRoot_sc_mvp2 = {
  btRoots = {
    [1] = {
      gid = 1,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 5,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.25,
              0,
              0,
              -6.1425
            },
            {
              0,
              0.2,
              0,
              -2.714
            },
            {
              0,
              0,
              0.125,
              12.31625
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 4,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320080,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 6
            }
          }
        }
      }
    },
    [2] = {
      gid = 2,
      nid = 3,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.1206953,
              0,
              0.1149366,
              16.71518
            },
            {
              0,
              0.2,
              0,
              -2.664
            },
            {
              -0.1379239,
              0,
              0.1448344,
              2.716849
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 2,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320060,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 7
            }
          }
        }
      }
    },
    [3] = {
      gid = 3,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.05375941,
              0,
              0.08432038,
              5.945733
            },
            {
              0,
              0.2,
              0,
              -5.554
            },
            {
              -0.1686408,
              0,
              0.1075188,
              -9.693054
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320090,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 8
            }
          }
        }
      }
    },
    [4] = {
      gid = 4,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.1446899,
              0,
              0.1380755,
              5.17426
            },
            {
              0,
              0.2,
              0,
              -3.114
            },
            {
              -0.06903776,
              0,
              0.07234493,
              1.579798
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320070,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 9
            }
          }
        }
      }
    },
    [5] = {
      gid = 5,
      nid = 2,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 4,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 2,
          center = {
            0,
            0,
            0
          },
          extents = {
            0.5,
            0.5,
            0.5
          },
          worldToLocalMatrix = {
            {
              0.1,
              0,
              0,
              0.851
            },
            {
              0,
              0.2,
              0,
              -6.448
            },
            {
              0,
              0,
              0.1,
              -7.123001
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 8,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 3,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320100,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 10
            }
          }
        }
      }
    },
    [6] = {
      gid = 6,
      nid = 1,
      basetype = "Composite",
      type = "Selector",
      service = {
        nid = 2,
        basetype = "Service",
        type = "PlayerTriggerCollector",
        groupRange = 0,
        collider = {
          type = 1,
          center = {
            0,
            0,
            0
          },
          radius = 16,
          worldToLocalMatrix = {
            {
              1,
              0,
              0,
              -6.22
            },
            {
              0,
              1,
              0,
              -14.31
            },
            {
              0,
              0,
              1,
              98.91
            },
            {
              0,
              0,
              0,
              1
            }
          }
        }
      },
      children = {
        [1] = {
          nid = 3,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 4,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 9,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 101,
              msgtype = 2,
              msgid = 43202,
              visible = true
            }
          }
        },
        [2] = {
          nid = 6,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 7,
              basetype = "Decorator",
              type = "CompareBB",
              serviceKey = "PlayerTriggerCollector",
              bbKey = 10,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 8,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 101,
              msgtype = 2,
              msgid = 43202,
              visible = false
            }
          }
        }
      }
    }
  }
}
return GameFlowRoot_sc_mvp2
