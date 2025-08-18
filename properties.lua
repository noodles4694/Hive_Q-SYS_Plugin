table.insert(
  props,
  {
    Name = "IP Address",
    Type = "string",
    Value = "192.168.1.30"
  }
)

table.insert(
  props,
  {
    Name = "Model",
    Type = "enum",
    Choices = {"PLAYER_1", "PLAYER_2", "PLAYER_3", "PLAYER_4"},
    Value = "PLAYER_3"
  }
)

table.insert(
  props,
  {
    Name = "Media List Count",
    Type = "integer",
    Value = 10,
    Min = 1,
    Max = 120
  }
)
