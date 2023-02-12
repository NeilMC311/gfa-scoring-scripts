Program Totals_with_Lay_Days; 
// ***************************************************************************************
// ****               S e e Y o u    S c o r i n g    S c r i p t                     ****
// ****                                                                               ****
// ****                 Total Script with Lay Days and Pilot Pairs                    ****
// ****                                                                               ****
// ****  Last Updated                                                                 ****
// ****  Tim Shirley, Initial Version                                                 ****
// ****  Neil Campbell, 30 January 2019 v2                                            ****
// ****                                                                               ****
// **** I N S T R U C T I O N S                                                       ****
// ****                                                                               ****
// **** 1. The Total Script is required to support Lay Days and Pilot Pairs           ****
// ****                                                                               ****
// **** 2. Determine the "discount" applied to Lay Days and update the LayDayDiscount ****
// ****    constant below.                                                            ****
// ****                                                                               ****
// **** 3. The scorer manually scores a lay day and pilot pair not flying:            ****
// ****    Enter Manual Score of -1 for Lay Day                                       ****
// ****    Enter Manual Score of -2 for Pilot Pair not flying                         ****
// ****                                                                               ****
// ***************************************************************************************
// ****   Version Details                                                             ****
// ****   V2 - Constant for layday discount, comments and formatting (courtesy of     ****
// ****        Ian Steventon)                                                         ****
// ***************************************************************************************

const
// ***************************************************************************************
// ****  discount percentage - in the case that rules require the lay day score to    ****
// ****  be reduced:                                                                  ****
// ****      set value to 0.90 if the lay day score is to be reduced by 10%           ****
// ****      set value to 1 if no reduction is needed                                 ****
// ***************************************************************************************
  LayDayDiscount = 0.90;
  
var 
  i, j, k, LD, PP, nDays : integer; 
  avg, temptotal, maxpts : double; 
begin
  for i := 0 to GetArrayLength(Pilots) - 1 do begin

    // work out the average daily score in case there is a Lay Day or Pilot Pair
    // scorer puts in -1 points for a Lay Day and -2 points for a Pilot Pair not flying
    temptotal := 0;
    nDays     := 0;
	
    for j := 0 to GetArrayLength(Pilots[i].DayPts) - 1 do begin
      if (Pilots[i].DayPts[j] > -1) then begin
        // find max points for the day
        maxpts := 0;
        for k := 0 to GetArrayLength(Pilots) - 1 do
        begin
          if (Pilots[k].DayPts[j] > maxpts) then maxpts := Pilots[k].DayPts[j];
        end;

        //  calculate total on flying days but eliminating devaluations
        if (maxpts > 0) then temptotal := temptotal + (Pilots[i].DayPts[j]/maxpts*1000);
        nDays := nDays + 1;
      end;
    end;

    if nDays > 0 then avg := temptotal/nDays else avg := 0;

    // recalculate total points
    Pilots[i].Total := 0;
    for j := 0 to GetArrayLength(Pilots[i].DayPts) - 1 do begin
      // if there is a Lay Day or Pilot Pair 
	  // find the max points for the day in case of devaluation
      if (Pilots[i].DayPts[j] < 0) then begin
        maxpts := 0;
        for k := 0 to GetArrayLength(Pilots) - 1 do begin
          if (Pilots[k].DayPts[j] > maxpts) then maxpts := Pilots[k].DayPts[j];
        end;
      end;

      // Store corrected average points
      LD := 0;
      PP := 0;

      if (Pilots[i].DayPts[j] = -1) then begin
        // Lay Day reduction percentage 
		// 0.90 = 10% 
		// 0.95 = 5% etc etc
        Pilots[i].DayPts[j] := round((avg * maxpts * LayDayDiscount / 1000)*10)/10;
        Pilots[i].DayPtsStr[j] := 'LD';
        LD := 1;
      end;     

      if (Pilots[i].DayPts[j] = -2) then begin   
        Pilots[i].DayPts[j] := round((avg * maxpts / 1000)*10)/10;
        Pilots[i].DayPtsStr[j] := 'PP';
        PP := 1;
      end;

      // Calculate totals
      Pilots[i].Total := Pilots[i].Total + Pilots[i].DayPts[j];
      Pilots[i].TotalString := FormatFloat('0',Pilots[i].Total);

      if (LD = 1) then Pilots[i].DayPts[j] := -1;
      if (PP = 1) then Pilots[i].DayPts[j] := -2;
    end;
  end;    
end.
