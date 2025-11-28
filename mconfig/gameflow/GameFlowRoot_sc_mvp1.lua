local GameFlowRoot_sc_mvp1 = {
  btRoots = {
    [1] = {
      gid = 1,
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
              0.01638394,
              0,
              -0.01501312,
              -0.2948897
            },
            {
              0,
              0.1,
              0,
              -0.94
            },
            {
              0.01228346,
              0,
              0.01340504,
              0.4866774
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
              nid = 10,
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
              monsterid = 320040,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 12,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 1
            }
          }
        }
      }
    },
    [2] = {
      gid = 2,
      nid = 4,
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
              0.0715205,
              0,
              -0.06989148,
              3.414738
            },
            {
              0,
              0.2114165,
              0,
              -3.44186
            },
            {
              0.06989148,
              0,
              0.0715205,
              13.2502
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
          nid = 2,
          basetype = "Composite",
          type = "Sequence",
          children = {
            [1] = {
              nid = 6,
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
              monsterid = 320050,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 8,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 2
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
              0.06365072,
              0,
              0.01982499,
              5.235238
            },
            {
              0,
              0.2,
              0,
              -4.248
            },
            {
              -0.02973749,
              0,
              0.09547608,
              -7.07323
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
              monsterid = 320030,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 3
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
              0.02852881,
              0,
              -0.001560047,
              -1.153799
            },
            {
              0,
              0.2,
              0,
              -4.164
            },
            {
              0.01092033,
              0,
              0.1997017,
              -19.18361
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
              monsterid = 320020,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 4
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
              0.2,
              0,
              0,
              -20.742
            },
            {
              0,
              0.2,
              0,
              -0.324
            },
            {
              0,
              0,
              0.02,
              1.0958
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
              monsterid = 320010,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 10,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 5
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
          radius = 22,
          worldToLocalMatrix = {
            {
              1,
              0,
              0,
              136.59
            },
            {
              0,
              1,
              0,
              -14.89
            },
            {
              0,
              0,
              1,
              90.83
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
              bbKey = 2,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 5,
              basetype = "Action",
              type = "DisplayZoneCD",
              zoneid = 102,
              msgtype = 1,
              msgid = 43216,
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
              zoneid = 102,
              msgtype = 1,
              msgid = 43216,
              visible = false
            }
          }
        }
      }
    },
    [7] = {
      gid = 7,
      nid = 1,
      basetype = "Composite",
      type = "Cooldown",
      cd = 90,
      service = {
        nid = 2,
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
              0.1500222,
              0,
              -0.1322624,
              21.4073
            },
            {
              0,
              0.2,
              0,
              -4.946
            },
            {
              0.04408746,
              0,
              0.05000741,
              4.80769
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
              bbKey = 1,
              val = 0,
              op = 2
            },
            [2] = {
              nid = 6,
              basetype = "Decorator",
              type = "CheckWildMvpState",
              monsterid = 320160,
              state = 2,
              op = 1
            },
            [3] = {
              nid = 7,
              basetype = "Action",
              type = "DisplayZoneInfo",
              zoneId = 16
            }
          }
        }
      }
    }
  }
}
return GameFlowRoot_sc_mvp1
