using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Verse.org/Colors }
using { /UnrealEngine.com/Temporary/SpatialMath}

kill_counter_device := class(creative_device):

    @editable
    var ElimMachineRed : elimination_manager_device = elimination_manager_device{}
    @editable
    var ElimMachineBlue : elimination_manager_device = elimination_manager_device{}

    var KillCount : int = 0
    var KillCount2 : int = 0
    var Players : []player = array{}
    var TextRed : text_block = text_block{}
    var TextBlue : text_block = text_block{}
    TextForUI<localizes>(Kills : int) : message = "{Kills}"
    TextForUI2<localizes>(Kills2 : int) : message = "{Kills2}"


    OnBegin<override>()<suspends>:void=
        ElimMachineRed.EliminationEvent.Subscribe(EnemyKilledRed)
        set Players = GetPlayspace().GetPlayers()
        set TextRed = text_block{DefaultTextColor := color{ R:= 255.0/255.0, G:= 0.0 / 255.0, B := 0.0 / 255.0}, DefaultTextOpacity := 0.75, DefaultShadowColor := NamedColors.Black, DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}}}
        TextRed.SetShadowOpacity(1.0)

        ElimMachineBlue.EliminationEvent.Subscribe(EnemyKilledBlue)
        set Players = GetPlayspace().GetPlayers()
        set TextBlue = text_block{DefaultTextColor := color{ R:= 0.0/255.0, G:= 0.0 / 255.0, B := 255.0 / 255.0}, DefaultTextOpacity := 0.75, DefaultShadowColor := NamedColors.Black, DefaultShadowOffset:= option{vector2{X:=2.0, Y:=2.0}}}
        TextBlue.SetShadowOpacity(1.0)

        if (Player := Players[0]):
            CreateUI(Player)

    EnemyKilledRed(Agent : ?agent) : void =
        set KillCount += 1
        TextRed.SetText(TextForUI(KillCount))

    EnemyKilledBlue(Agent : ?agent) : void =
        set KillCount2 += 1
        TextBlue.SetText(TextForUI2(KillCount2))

    CreateUI(Player : player) : void=
        if(PlayerUI := GetPlayerUI[Player]):
            TextRed.SetText(TextForUI(0))
            TextBlue.SetText(TextForUI2(0))
            MyCanvas : canvas = canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.2}, Maximum := vector2{X := 0.5, Y := 0.2}}
                        Offsets := margin{Top := 100.0, Left := 50.0, Right := 50.0, Bottom := 50.0}
                        Alignment := vector2{X := 0.5, Y := 0.5}
                        SizeToContent := false
                        Widget := TextRed
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.2}, Maximum := vector2{X := 0.5, Y := 0.2}}
                        Offsets := margin{Top := 100.0, Left := 80.0, Right := 20.0, Bottom := 50.0}
                        Alignment := vector2{X := 0.5, Y := 0.5}
                        SizeToContent := false
                        Widget := TextBlue
            PlayerUI.AddWidget(MyCanvas)