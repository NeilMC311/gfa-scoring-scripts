Program SGPNoScorev2;

var

  // Day variables
  TsPos : Integer;  // position of Ts in DayTag

  Ts : Double; //  The Regatta Start Time of the day
  
  DebugPos : Integer;  // position of DEBUG in DayTag
  // Competitor variables
  T : Double; //  Finishers Marking Time= Pilots[i].finish - Ts + penalty
  SStart : Double; // the scoring start time
  SFinish : Double; // the scoring finish time
  SDis : Double; // the scoring distance
  SSpeed : Double; // the scoring speed

  // Others variable
  i : Integer;


begin
  
  // Initial setup
  
  TsPos := Pos('Ts=',DayTag);

  Ts := StrToFloat( Copy( DayTag, TsPos+3,2 ) )*3600 + StrToFloat( Copy( DayTag, TsPos+6,2 ) )*60 + StrToFloat( Copy( DayTag, TsPos+9,2 ) );

  DebugPos := Pos('DEBUG',DayTag);
  
  for i:=0 to GetArrayLength(Pilots)-1 do
  begin
     // init
     SStart :=-1;
     SFinish :=-1;
     SDis := Pilots[i].dis;
     SSpeed := 0;
If not (DebugPos = 0) then
  begin
		showmessage('Pilot = '  + pilots[i].CompID
					 + #10'Start Time=' + floattostr(Pilots[i].start)
					 + #10'Day Tag Start =' + floattostr(Ts)
					 + #10'Finish Time=' + floattostr(Pilots[i].finish)
					 + #10'Outlanding Time =' + floattostr(Pilots[i].phototime)
					 + #10'distance =' + floattostr(Pilots[i].dis));
	end;
     // Case the pilot has started
     if (Pilots[i].start > 0) Then
     begin
		SStart := Ts;
		
        if  (Pilots[i].finish>0) then
        begin
           SFinish := Pilots[i].finish;
           T := SFinish - SStart;
           SSpeed := SDis / T;  // Speed calculation not affected by penalties
        end
        // Case the pilot lands out
     end // end the pilot started
     Pilots[i].Points := 0;

     // other displayed data
     Pilots[i].sstart:= SStart;
     Pilots[i].sfinish:=SFinish;
     Pilots[i].sdis:=SDis;
     Pilots[i].sspeed:=SSpeed;
  end; // loop  
    // Info fields, also presented on the Score Sheets
  If not (TsPos = 0) then
  begin
    Info1 := 'Regatta start time :  '+Copy( DayTag, TsPos+3,8 ) ;
  end;



end.
