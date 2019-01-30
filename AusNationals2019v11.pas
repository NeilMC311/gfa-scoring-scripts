program AusNats2018v11;
// ***************************************************************************************
// ****               S e e Y o u    S c o r i n g    S c r i p t                     ****
// ****                                                                               ****
// ****                 Australian Nationals Rules 2018 v2.9                          ****
// ****                                                                               ****
// ****  Last Updated                                                                 ****
// ****  Tim Shirley, 11 Oct 2016 v7                                                  ****
// ****  Neil Campbell, 04 August 2018 v8                                             ****
// ****  Neil Campbell, 06 December 2018 v9                                           ****
// ****  Ian Steventon, 22 January 2019 v11                                           ****
// ****                                                                               ****
// ****                                                                               ****
// **** I N S T R U C T I O N S                                                       ****
// **** 1. Confirm Local Rules for variations of                                      ****
// ****    Dd - minimum task distance under which a day is devalued (m)               ****
// ****    Md - minimum marking distance (m)                                          ****
// ****    Td - minimum task time                                                     ****
// ****                                                                               ****
// **** 2. Uncomment the appropriate class constant before importing into SeeYou      ****
// ****    updating Dd and Md if varied by local rules.  Defaults are listed below    ****
// ****                                                                               ****
// **** 3. Confirm if either start bonus and / or start intervals in use.  if so      ****
// ****    setup the appropriate parameters in the Contest Day Tag - see below        ****
// ****                                                                               ****
// ***************************************************************************************
// ****  Parameters passed via Contest Day Tag => Parm1=Value1;Parm2=Value2           ****
// ****    S T A R T   I N T E R V A L S                                              ****
// ****    =============================                                              ****
// ****    Day Tag Parameters:                                                        ****
// ****      INTERVAL => interval length in seconds                                   ****
// ****      NUMINTERVALS => number of intervals                                      ****
// ****      BUFFER => Pre-interval buffer                                            ****
// ****                                                                               ****
// ****    * Uses standard rules copied from SeeYou example scripts.                  ****
// ****    * Pilot start time alloated to start of interval in which they start.      ****
// ****    * Pilots starting within the Buffer period prior to any interval except    ****
// ****      the first interval will be assigned their actual start time.             ****
// ****    * Pilots starting after the last interval finish will be assigned a        ****
// ****      start time as if they started in the final interval.                     ****
// ****    * User Warning used to record the actual and assigned start times.         ****
// ****                                                                               ****
// ****    S T A R T   B O N U S                                                      ****
// ****    =====================                                                      ****
// ****    Day Tag Parameters:                                                        ****
// ****      STARTBONUS => Total available bonus points                               ****
// ****      BONUSTIME => Time over which bonus points decay to zero in seconds       ****
// ****      BONUSWINDOW => Initial time window when all bonus points are available   ****
// ****                                                                               ****
// ****    * Start time bonus uses raw start time independent of any start time       ****
// ****      intervals in use.                                                        ****
// ****    * Full start bonus points will be awarded from the start time until the    **** 
// ****      end of the Bonus Window.                                                 ****
// ****    * Bonus points decay in a linear fashion over the bonus time after the     **** 
// ****      starting at the end of the Bonus Window.                                 ****
// ****    * Maximum allocated start bonus points are also devalued directly          ****
// ****      propoortionally with the total available points.                         ****
// ****    * Start bonus points are applied PRIOR to the day factor!  We may want     ****
// ****      change this to make it simpler.                                          ****
// ****    * User Warning is used to indicate when start bonus points are allocated,  ****
// ****      once fully understood we may want to remove this to remove clutter from  ****
// ****      scoring sheets.                                                          ****
// ****                                                                               ****
// ****    Example: Any pilot who starts within 10 minutes after the start gate opens ****
// ****             will score full Early Bird points. Points for pilots who start    ****
// ****             later will reduce by 2% per minute, with all points expiring      **** 
// ****             60 minutes after the start gate opens.                            ****
// ****                                                                               ****
// ****    Contest Day Tag: STARTBONUS=100;BONUSWINDOW=600;BONUSTIME=3000;            ****
// ****                                                                               ****
// ****        STARTBONUS=100; <= Additional 100 points will be available for pilots  ****
// ****                           who start early                                     ****
// ****        BONUSWINDOW=600; <= Any pilot who starts within 10 minutes after the   ****
// ****                            start gate opens will score full Early Bird points ****
// ****        BONUSTIME=3000; <= Points for pilots who start later will reduce by    ****
// ****                           2% per minute, with all points expiring 60 minutes  ****
// ****                           after the start gate opens. Bonus time is 50mins as ****
// ****                           the first 10mins is the bonus window.               ****
// ****                                                                               ****
// ***************************************************************************************
// ****                                                                               ****
// ****   Version Details                                                             ****
// ****   V11 - Cosmetic readability/commenting changes as part of familiarisation    ****
// ****       - Display bonus window info in the info tag too                         ****
// ****       - Clearer comments for start bonus input                                ****
// ****                                                                               ****
// ****   V10 - Fix error in start bonus point calculation with bonus window          ****
// ****       - Display bonus window info in the info tag too                         ****
// ****       - Clearer comments for start bonus input                                ****
// ****                                                                               ****
// ****   V9 - Updated logic for start time bonus to include a full bonus point       ****
// ****        window after the start time before the bonus points begin to decay.    ****
// ****                                                                               ****
// ****   V8 - Included additional comments and parameters to "simplify"              ****
// ****      - Incorporated logic from SeeYou standard script to support start        ****
// ****        interval logic.   Will need to be changed if intervals are passed to   ****
// ****        scoring script from task dialog in SeeYou                              ****
// ****      - Incorporate logic to support start time bonus as per Alan Barnes'      ****
// ****        request.  Intended to be trialed during 2018/2019.                     ****
// ****                                                                               ****
// ***************************************************************************************
// ****                                                                               ****
// ****   Refer to end of script for SeeYou variables reference                       ****
// ****                                                                               ****
// ***************************************************************************************

const
// ***************************************************************************************
// ****  Uncomment correct class - Update values if varied by Local Rules             ****
// ***************************************************************************************
  CompClass = 'Club', Dd = 200000, Md = 80000;
  //CompClass = '15m Sports', Dd = 225000, Md = 90000;
  //CompClass = 'Std', Dd = 225000, Md = 90000;
  //CompClass = '15m', Dd = 225000, Md = 90000;
  //CompClass = 'Open Sports', Dd = 250000, Md = 100000;
  //CompClass = '18m', Dd = 250000, Md = 100000;
  //CompClass = 'Open', Dd = 250000, Md = 100000;
  //CompClass = '2-seater', Dd = 250000, Md = 100000;

// ***************************************************************************************
// ****  Minimum Task Time - Update value if varied by local rules                    ****
// ***************************************************************************************
  Td = 3;  // in hours 

// ***************************************************************************************
// ****  Day devaluation                                                              ****
// ***************************************************************************************
  UseDayDevaluation = TRUE;
  //UseDayDevaluation = FALSE;
    
// ***************************************************************************************
// ****  Other Constants                                                              ****
// ***************************************************************************************
  HcapBase = 1000.0;
  Pmax = 1000.0;         //Max available points

// ***************************************************************************************
// ****  Global Variables                                                             ****
// ***************************************************************************************
var
  i, N, Nd, Nv : integer;
  Dhmax, Vhmax, Tdmin,
  PmaxDistance, PmaxSpeed,
  Pvmax, Pdmax, Pm,
  Pd, Pv,
  Rd, Rv,
  F, S : double;
  TempString1, TempString2 : string;
  NumIntervals, Interval, IntervalBuffer, StartBonus, BonusTime, BonusWindow : integer;
  GateIntervalPos, NumIntervalsPos, PilotStartInterval, PilotStartTime : integer;
  StartBonusInUse, StartIntervalsInUse : Boolean;

// ***************************************************************************************
// ****  MinValue Function to simplify maximum daily points calculation               ****
// ***************************************************************************************
function MinValue( a,b,c : double ) : double;
var
  m : double;
begin
  m := a;
  if (b < m) then m := b;
  if (c < m) then m := c;
  MinValue := m;
end;

// ***************************************************************************************
// ****  Parse daytag for parameters  Parm1=Value1;Parm2=Value2                   ****
// ***************************************************************************************
function ParseDayTag( TagString, Tag : string ) : string;
var
  x : integer;
begin
  //showmessage('start of parse for:' + Tag + ' in:' + TagString);
  Result := '';
  TagString := Uppercase(TagString);
  x := pos(uppercase(Tag),TagString);
  //showmessage('x=' + inttostr(x));
  if (x > 0) then begin
    Result := copy(TagString,x + length(Tag) + 1,99);
    x := pos(';',Result);
    //showmessage('x=' + inttostr(x));
    if (x > 0) then begin
      Result := copy(Result,1,x - 1);
    end;
  end;
  //showmessage('Result:' + Result);
end;

// ***************************************************************************************
// ****  Seconds to time of day                                      ****
// ***************************************************************************************
function SecsToTOD( seconds : integer ) : string;
var
  h, m, s, x : integer;
  hh, mm, ss : string; 
begin
  h := seconds div 3600;
  x := (seconds - h * 3600);
  m := x div 60;
  s := x - m * 60;
  
  if h < 10 then hh := '0' + inttostr(h) else hh := inttostr(h);
  if m < 10 then mm := '0' + inttostr(m) else mm := inttostr(m);
  if s < 10 then ss := '0' + inttostr(s) else ss := inttostr(s);
  
  Result := hh + ':' + mm + ':' + ss;
  //Showmessage('seconds = ' + inttostr(seconds) + 'time = ' + Result);
end;

// ***************************************************************************************
// ****  Main Script                                                                  ****
// ***************************************************************************************
begin
  //showmessage('AusNats2018 Start');
  
  //Extract variables from daytag  
  Interval       := strtoint(ParseDayTag(DayTag,'INTERVAL'),0);
  NumIntervals   := strtoint(ParseDayTag(DayTag,'NUMINTERVALS'),0);
  IntervalBuffer := strtoint(ParseDayTag(DayTag,'BUFFER'),0);
  StartBonus     := strtoInt(ParseDayTag(DayTag,'STARTBONUS'),0);
  BonusTime      := StrToInt(ParseDayTag(DayTag,'BONUSTIME'),0);
  BonusWindow    := StrToInt(ParseDayTag(DayTag,'BONUSWINDOW'),0);
  
  //showmessage('int='+ inttostr(Interval) + ' NbrInt=' + inttostr(NumIntervals) + ' IntervalBuffer=' + inttostr(IntervalBuffer));
  //showmessage('StartBonus=' + inttostr(StartBonus) + ' BonusTime=' + inttostr(BonusTime) + ' BonusWindow=' + inttostr(BonusWindow));

  if (Interval > 0) and (NumIntervals > 0) and (IntervalBuffer > 0) then StartIntervalsInUse := TRUE else StartIntervalsInUse := FALSE;
  if (StartBonus > 0) and (BonusTime > 0) and (BonusWindow > 0) then StartBonusInUse := TRUE else StartBonusInUse := FALSE;
 
  // Start time bonus calculation 
  // Save bonus points in pilot[].td3 as start times will change if intervals are in use as well.
  // Start points will be scaled by Pm/PMax and also day factor when points calculated.
  if StartBonusInUse then begin
    for i := 0 to GetArrayLength(Pilots)-1 do begin
      if  (Pilots[i].start > 0) 
      and (Pilots[i].start < Task.NoStartBeforeTime + BonusWindow + BonusTime) 
      and (Pilots[i].start >= Task.NoStartBeforeTime) then begin      
        //Pilot has started, within the bonus time + BonusWindow and after the start gate is open        
        if (Pilots[i].start <= Task.NoStartBeforeTime + BonusWindow) then begin
          //Pilot has started after the starttime within the Bonus Window so is awarded the full start bonus            
          Pilots[i].td3 := StartBonus;
        end
        else begin
          //Pilot has started after the starttime after the BonusWindow has finished so is awarded a % of the available points            
          Pilots[i].td3 := (1 - ((Pilots[i].start - Task.NoStartBeforeTime - BonusWindow) / BonusTime)) * StartBonus;
        end
      end
      else begin 
        Pilots[i].td3 := 0.0;
      end;    
      //showmessage('Pilot ' + Pilots[i].CompID + ' received start bonus of ' + formatfloat('0.000000',Pilots[i].td3)); 
    end;
  end;

  // Start time intervals  
  if StartIntervalsInUse then begin                                      
    for i:=0 to GetArrayLength(Pilots)-1 do begin
      // Start interval used by pilot. 0 = first interval = opening of the start line
      PilotStartInterval := Round(Pilots[i].start - Task.NoStartBeforeTime) div Interval;          
      PilotStartTime := Task.NoStartBeforeTime + PilotStartInterval * Interval;

      // Last start interval if pilot started late
      if PilotStartInterval > (NumIntervals-1) then PilotStartInterval := NumIntervals-1;

      if (Pilots[i].start > 0) 
      and ((PilotStartTime + Interval - Pilots[i].start) > IntervalBuffer) then begin
        // Check for buffer zone to next start interval
        // set up warning to display change in times
        Pilots[i].warning := 'Actual Start=' + SecsToTOD(round(Pilots[i].start)) + ' Allocated Start=' + SecsToTOD(PilotStartTime);  
        Pilots[i].start := PilotStartTime;
        if (Pilots[i].speed > 0) then begin
          Pilots[i].speed := Pilots[i].dis / (Pilots[i].finish - Pilots[i].start);
        end
      end;  
      // Else not required. if started in buffer zone actual times are used
      //showmessage('Pilot ' + Pilots[i].CompID + ' allocated start time =' + floattostr(Pilots[i].start) + ' Speed=' + floattostr(Pilots[i].speed) + ' interval=' + inttostr(PilotStartInterval)); 
    end;
  end;

  // Calculation of basic daily parameters
  Dhmax := 0;  //Highest Marking distance D0 in the scoring definitions
  Vhmax := 0;  //Maximum handicapped speed
  Tdmin := 99999;  
  N     := 0;
  Nd    := 0;
  Nv    := 0;
  
  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Use temporary double 1 td1 = handicapped distance
    Pilots[i].td1 := Pilots[i].dis / Pilots[i].Hcap*HcapBase;

    // Use temporary double 2 td2 = handicapped speed
    Pilots[i].td2 := Pilots[i].speed / Pilots[i].Hcap*HcapBase;

    // Pilots hors concours are not included in day devaluation calculations
    if not Pilots[i].isHC then begin
      // Pilot is competing (Not HC)
      // Find maximum handicapped distance (Dhmax) and speed (Vhmax)
      if (Pilots[i].td1 > Dhmax) then Dhmax := Pilots[i].td1;
    
      if (Pilots[i].td2 >= Vhmax) then begin
        Vhmax := Pilots[i].td2;
        if (Vhmax > 0) then Tdmin := ((Pilots[i].td1/1000)/(Vhmax*3.6));
      end;

      // Count the number of competition launches (N) and number of competitors
      // exceeding handicapped distance (Nd)
      if (Pilots[i].takeoff > 0) then N  := N+1;
      if (Pilots[i].td1 >= Md)   then Nd := Nd+1;
    end;
  end;

  if N = 0 then Exit; // No competition launches (yet?)

  // Rule 44.2  Short Day devaluation.  By default 3 hours and 250km,
  // change Dd and Td if local rules specify.
  PmaxDistance := (1250 * Dhmax / Dd) - 250;
  if (Vhmax > 0) then PmaxSpeed := (1200 * Tdmin / Td) - 200 else PmaxSpeed := 1000;
  if UseDayDevaluation then Pm := MinValue( PmaxDistance, PmaxSpeed, 1000.0 ) else Pm := 1000;
  
  // Showmessage ('Pmaxdistance=' + FormatFloat('0',PmaxDistance))
  // Showmessage ('PmaxSpeed=' + FormatFloat('0',PmaxSpeed))

  // Day factor (rule 44.6)
  F := 1.25*Nd/N;
  if (F > 1) then F := 1;

  Nv := 0;

  for i := 0 to GetArrayLength(Pilots)-1 do begin
    if (not Pilots[i].isHC) then begin 
      // Pilot is competing (not HC)
      // Check if any pilot reached the goal.
      if (Pilots[i].finish > 0) then begin
        // Count the number of pilots who exceed 2/3rds of the fastest speed (Nv)
        if (Pilots[i].td2 > Vhmax*2/3) then Nv := Nv+1;
      end;
    end;
  end;

  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Definition of Rd
    if (Dhmax > 0) then begin
      Rd := Pilots[i].td1 / Dhmax;
      if (Pilots[i].finish > 0) then Rd := 1;
    end
    else begin
      Rd := 0;
    end

    // Definition of Rv
    if (Vhmax > 0) then Rv := Pilots[i].td2 / Vhmax else Rv := 0;
     
    // These formulas are taken from rule 44.3 but also cover rule 44.4
    // since when Nv=0 the formulas are equivalent.
    Pd := Pm * ((1 - (2/3)*(Nv/N)) * Rd);
    Pv := Pm * (2 * (Rv - 2/3) * (Nv/N));
    if (Pv < 0) then Pv := 0;

    S := Pv + Pd;
  
    // Add start bonus points scaled by Pm / Pmax
    S := S + (Pilots[i].td3 * Pm / Pmax);

    // Start Intervals in Use
    if StartIntervalsInUse then begin
      TempString1 := Pilots[i].warning;
    end
    else begin
      TempString1:='';
    end;
  
    // Start Bonuses in Use
    if  (StartBonusInUse) 
    and (pilots[i].td3 > 0.0) then begin
      TempString2 := ' Start Bonus Points = ' + formatfloat('0.00',Pilots[i].td3 * Pm / Pmax);
    end 
    else begin
      TempString2 := '';
    end;
  
    Pilots[i].warning := TempString1 + TempString2;

    // Apply the day factor (rule 44.6) and penalty (rule 44.5)
    S := S * F - Pilots[i].Penalty;
  
    if (Pilots[i].Points > -1) then begin
      // Round to nearest whole point (rule 44.1)
      Pilots[i].Points := Round(S);
      Pilots[i].PointString := FormatFloat('0',Pilots[i].Points);
    end;
  end; // For loop

  // Set up results for display
  for i := 0 to GetArrayLength(Pilots)-1 do begin
    // Displayed start and finish times are real start and finish times
    Pilots[i].sstart  := Pilots[i].start;
    Pilots[i].sfinish := Pilots[i].finish;

    // Displayed distance and speed are handicapped distance and speed
    // Pilots[i].sdis    := Pilots[i].td1;
    // Pilots[i].sspeed  := Pilots[i].td2;

    // Displayed distance and speed are raw distance and speed
    Pilots[i].sdis    := Pilots[i].dis;
    Pilots[i].sspeed  := Pilots[i].speed;
  end;

  // Calculate the maximum possible speed and distance scores 
  // fixed in v8 Pmax changed to Pm.
  // (corrected for day factor)
  Pdmax := Pm * (1 - 2/3*(Nv/N)) * F;
  Pvmax := Pm * (2/3 * (Nv/N)) * F;

  Info1 := 'Maximum Points: '+FormatFloat('0',Pvmax+Pdmax)+', Pvmax: '+FormatFloat('0',Pvmax)+', Pdmax: '+FormatFloat('0',Pdmax);
  Info2 := 'f='+FormatFloat('0.000',F) +', N='+IntToStr(N)+', Nd='+IntToStr(Nd)+', Nv='+IntToStr(Nv);
  
  if StartBonusInUse then begin
    Info3 := 'Maximum Start Bonus: ' + formatfloat('0.0',StartBonus * Pm / Pmax) + ', Full Start Bonus Window: ' + IntToStr(BonusWindow div 60)+'min, Start Bonus Decay Time: ' + IntToStr(Bonustime div 60)+'min'   
  end
  else begin
    Info3 := '';
  end;
  
  if StartIntervalsInUse then begin
    Info4 := 'Start Time Interval: '+IntToStr(Interval div 60)+'min, Number of Intervals: '+IntToStr(NumIntervals) + ', Buffer: ' + IntToStr(IntervalBuffer) +'s'
  end
  else begin
    Info4 := '';
  end;
end.

//---------------------------------------------------------------------------------------------
//Pilots[i] record element description
//
// sstart starttime   written in results sets in seconds
// sfinish finishtime written in results sets in seconds (negative values - no finish)
// sdis               distance shown in results in meters (negative values will be shown in parenthesis)
// sspeed             speed shown in results in m/s (negative values will be shown in parenthesis)
// points             points shown in results
// pointString:       string; a string representation of points for custom output
// Hcap               handicap factor as declared in pilot setup
// penalty            penalty points defined in Day performance dialog
// start              start time of task (-1 if no start)
// finish             finish time of task (-1 if no finish)
// dis                flown distance
// speed              speed of finished taks (-1 if no finish, takes into account task time)
// tstart             start time of task with time (-1 if no start)
// tfinish            finish time of task with time
// tdis               flown distance in task time
// tspeed             flown distance divided by task time
// takeoff            takeoff time (-1 if no takeoff)
// landing            landing time (-1 if no landing)
// phototime          outlanding time (-1 if no outlanding)
// isHc               set to TRUE if not competing is used
// FinishAlt          altitude of task finish
// DisToGoal          distance between Task landing point and flight landing point
// Tag                string value as defined in Day performace dialog
// Leg,LegT           array of TLeg records; info about each leg, LegT for timeout calculation
// Warning:           String; used to set up a user warning
// CompID:            String; Competition ID
// PilotTag:          String; string value as defined in Pilot edit dialog
// user_str1,user_str2,user_str3: String; user strings, which are stored also in XML file
// td1,td2,td3:       Double; temprary variables

//---------------------------------------------------------------------------------------------
//TLeg = record; holding leg information
//
// start,finish,d,crs Double; time in seconds, distance in meters, crs in radians
// td1,td2,td3 Double; variables may be used as temporary variables

//---------------------------------------------------------------------------------------------
//other variables
// info1..info2 informational strings shown on results
// DayTag string value as defined in Day properties dialog
//
//---------------------------------------------------------------------------------------------
//Task = record; holding basic information about task
// TotalDis: Double; task distance in meters
// TaskTime: Integer; task time in second
// NoStartBeforeTime: Integer; start time in second
// Point: Array of TTaskPoint; description of task
//---------------------------------------------------------------------------------------------
//TTaskPoint = record; holding basic information about taskpoint and leg
// lon,lat: Double; 
// d,crs: Double; distance, course to next point
// td1,td2,td3 Double; variables may be used as temporary variables

