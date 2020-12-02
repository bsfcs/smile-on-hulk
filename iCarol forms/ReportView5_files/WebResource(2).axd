var eWorld_CalendarPopup_CurrentCalendar;

function CalendarPopup_Calendar(id, textBoxId, labelId, buttonId, imageId, hiddenId, validateHiddenId, enabledHiddenId, calendarDivId, 
   monthYearDivId, format, monthNames, dayNames, firstDayOfWeek, sundayNumber, saturdayNumber, 
   displayCalendarYearSelection, lowerBoundDate, upperBoundDate, quadrant, padDigits, offsetX, offsetY, 
   showClearDate, clearDateText, nullableText, showGoToToday, goToTodayText, arrowUrl, nextMonthImageUrl, 
   previousMonthImageUrl, nextYearImageUrl, previousYearImageUrl, calendarWidth, visibleDate,
   monthYearApplyText, monthYearCancelText, javascriptFunction, autoPostBack, allowArbitraryText, monthYearDisabled, nullable) {
   
   if (visibleDate == '') {
      visibleDate = new Date();
   }
   
   this.Id = id;
   this.TextBoxId = textBoxId;
   this.LabelId = labelId;
   this.ButtonId = buttonId;
   this.ImageId = imageId;
   this.HiddenId = hiddenId;
   this.ValidateHiddenId = validateHiddenId;
   this.EnabledHiddenId = enabledHiddenId;
   this.CalendarDivId = calendarDivId;
   this.MonthYearDivId = monthYearDivId;
   this.Format = format;
   this.MonthNames = monthNames;
   this.DayNames = dayNames;
   this.FirstDayOfWeek = firstDayOfWeek;
   this.SundayNumber = sundayNumber;
   this.SaturdayNumber = saturdayNumber;
   this.DisplayCalendarYearSelection = displayCalendarYearSelection;
   this.LowerBoundDate = new Date(lowerBoundDate);
   this.UpperBoundDate = new Date(upperBoundDate);
   this.Quadrant = quadrant;
   this.PadDigits = padDigits;
   this.OffsetX = offsetX;
   this.OffsetY = offsetY;
   this.ShowClearDate = showClearDate;
   this.ClearDateText = clearDateText;
   this.NullableText = nullableText;
   this.ShowGoToToday = showGoToToday;
   this.GoToTodayText = goToTodayText;
   this.MonthYearArrowUrl = arrowUrl;
   this.NextMonthImageUrl = nextMonthImageUrl;
   this.PreviousMonthImageUrl = previousMonthImageUrl;
   this.NextYearImageUrl = nextYearImageUrl;
   this.PreviousYearImageUrl = previousYearImageUrl;
   this.CalendarWidth = calendarWidth;   
   this.VisibleDate = new Date(visibleDate);
   this.MonthYearApplyText = monthYearApplyText;
   this.MonthYearCancelText = monthYearCancelText;
   this.JavascriptFunction = javascriptFunction;
   this.AutoPostBack = autoPostBack;
   this.AllowArbitraryText = allowArbitraryText;
   this.MonthYearDisabled = monthYearDisabled;
   this.Nullable = nullable;
   
   this.ImageClick = null;
   
   this.ActiveMonth = 1;
   this.ActiveYear = 1;
   
   this.SetActiveMonth = function(value) {
      this.ActiveMonth = value;
      this.DisplayMonthYear(this.ActiveMonth + '/1/' + this.ActiveYear);
   }
   
   this.SetActiveYear = function(value) {
      this.ActiveYear = value;
      this.DisplayMonthYear(this.ActiveMonth + '/1/' + this.ActiveYear);
   }
   
   this.GetStyle = function() {
      return eWorld_FindItem(eWorld_CalendarPopup_Styles, this.Id);
   }
   
   this.Setup = function() {     
      var div = document.getElementById(this.CalendarDivId);
      
      CalendarPopup_MouseOut();
      eWorld_AddEvent(div, 'mouseout', CalendarPopup_MouseOut);
      eWorld_AddEvent(div, 'mouseover', CalendarPopup_MouseOver);
   }
   
   this.Show = function() {
      eWorld_CalendarPopup_CurrentCalendar = this;
      var div = document.getElementById(this.CalendarDivId);
      var divIframe = document.getElementById(this.CalendarDivId + '_iframe');
      var tb = document.getElementById(this.TextBoxId);
      var img = document.getElementById(this.ImageId);
      var btn = document.getElementById(this.ButtonId);
      if (div.style.display != 'none') {
         this.Hide();
      } else {
         this.DisplayCalendar(this.VisibleDate);
         this.Setup();
         var obj = tb;
         if (obj == null) obj = img;
         if (obj == null) obj = btn;
         var result = eWorld_FindPosition(obj);
         var x = result.x;
         var y = result.y;
         
         div.style.visibility = 'hidden';
         
         div.style.display = 'block';
         switch (this.Quadrant) {
            case 1:
               y += (obj.offsetHeight + 1);
               break;
            case 2:
               x -= (div.offsetWidth - 2);
               break;
            case 3:
               x += (obj.offsetWidth + 1);
               break;
            case 4:
               y -= (div.offsetHeight - 1);
         }
         div.style.top = y + this.OffsetY + 'px';
         div.style.left = x + this.OffsetX + 'px';
         
         div.style.visibility = 'visible';
         
         if (divIframe != null) {
            divIframe.width = (document.all) ? div.offsetWidth : div.offsetWidth - 4;
            divIframe.height = (document.all) ? div.offsetHeight : div.offsetHeight - 4;
            divIframe.style.top = div.style.top;
            divIframe.style.left = div.style.left;
            divIframe.style.display = 'block';
         }
      }
   }
   
   this.GetDate = function() {
      var date = new Date();
      var tb = document.getElementById(this.TextBoxId);
      var hid = document.getElementById(this.HiddenId);
      var value = '';
      if (tb != null) {
         value = tb.value;
      } else {
         value = hid.value;
      }
      
      if (value != '') {
         var dateArray = value.replace(/[\.-]/g, '/').split('/');
         var format = [[2,1,0],[0,1,2],[1,0,2],[1,2,0]][this.Format % 4];
         
         if (dateArray.length == 3) {
            date = new Date(eWorld_ReplaceFormat('{0}/{1}/{2}', new Array(dateArray[format[0]], dateArray[format[1]], dateArray[format[2]])));
            if (isNaN(date)) date = new Date();
         }
      }
      
      return date;
   }
   
   this.FormatDate = function(input) {
      var date = new Date(input);
      var month = date.getMonth() + 1;
      var day = date.getDate();
      var year = date.getFullYear();
      
      if (this.PadDigits) {
         if (month < 10) month = '0' + month;
         if (day < 10) day = '0' + day;
      }
      
      var separator = '/';
      var output = '';
      
      if (this.Format >= 5 && this.Format <= 8) separator = '.';
      else if (this.Format >= 9 && this.Format <= 12) separator = '-';
      
      if (this.Format == 1 || this.Format == 5 || this.Format == 9) output = eWorld_ReplaceFormat('{1}{0}{2}{0}{3}', new Array(separator, month, day, year));
      else if (this.Format == 2 || this.Format == 6 || this.Format == 10) output = eWorld_ReplaceFormat('{1}{0}{2}{0}{3}', new Array(separator, day, month, year));
      else if (this.Format == 3 || this.Format == 7 || this.Format == 11) output = eWorld_ReplaceFormat('{1}{0}{2}{0}{3}', new Array(separator, year, month, day));
      else output = eWorld_ReplaceFormat('{1}{0}{2}{0}{3}', new Array(separator, year, day, month));
      
      return output;
   }
   
   this.IsSameDate = function(date1, date2) {
      var inputDate1 = new Date(date1);
      var inputDate2 = new Date(date2);
      
      return (inputDate1.getMonth() == inputDate2.getMonth() && inputDate1.getDate() == inputDate2.getDate() && inputDate1.getFullYear() == inputDate2.getFullYear());
   }
   
   this.IsSpecialDay = function(date) {
      if (typeof eWorld_CalendarPopup_SpecialDays == "undefined" || eWorld_CalendarPopup_SpecialDays == null) return false;
      for (var i=0; i<eWorld_CalendarPopup_SpecialDays.length; i++) {
         var specialDay = eWorld_CalendarPopup_SpecialDays[i];
         if (specialDay != null && specialDay.Id == this.Id) {
            if (this.IsSameDate(date, specialDay.Month + '/' + specialDay.Day + '/' + ((specialDay.Span) ? date.getFullYear() : specialDay.Year))) return true;
         }
      }
      return false;
   }
   
   this.IsSpecialDayDisabled = function(date) {
      if (typeof eWorld_CalendarPopup_SpecialDays == "undefined" || eWorld_CalendarPopup_SpecialDays == null) return false;
      for (var i=0; i<eWorld_CalendarPopup_SpecialDays.length; i++) {
         var specialDay = eWorld_CalendarPopup_SpecialDays[i];
         if (specialDay != null && specialDay.Id == this.Id) {
            if (this.IsSameDate(date, specialDay.Month + '/' + specialDay.Day + '/' + ((specialDay.Span) ? date.getFullYear() : specialDay.Year))) {
               return specialDay.Disabled;
            }
         }
      }
      return false;
   }
   
   this.Clear = function() {
      if (this.Nullable) {
         this.VisibleDate = new Date();
         if (document.getElementById(this.TextBoxId) != null) {
            document.getElementById(this.TextBoxId).value = '';
         }
         document.getElementById(this.HiddenId).value = '';
         if (document.getElementById(this.LabelId) != null) {
            document.getElementById(this.LabelId).innerHTML = this.NullableText;
         }
         document.getElementById(this.ValidateHiddenId).value = '';
         this.RaiseClientFunctions();
         this.Hide();
         this.Validate();
      }
   }
   
   this.Validate = function() {
      eWorld_ValidateControl(document.getElementById(this.ValidateHiddenId));
   }
   
   this.DisplayCalendar = function(date) {
      var style = this.GetStyle();
      var hid = document.getElementById(this.HiddenId);
      var todayDate = new Date();
      var lowerDate = new Date(this.LowerBoundDate);
      var upperDate = new Date(this.UpperBoundDate);
      var currentDate = this.GetDate();
      var currentMonth = currentDate.getMonth();
      var currentYear = currentDate.getFullYear();
      var input = new Date(date);
      var monthDays = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
      var inputDay = input.getDay();
      var inputDate = input.getDate();
      var inputMonth = input.getMonth();
      var inputYear = input.getFullYear();
      if (((inputYear % 4 == 0) && !(inputYear % 100 == 0)) || (inputYear % 400 == 0)) 
         monthDays[1]++;
      var output = '';
      var prevMonth = inputMonth;
      var prevDay = inputDate;
      var prevYear = inputYear;
      if (prevMonth < 1) {
         prevMonth = 12;
         prevYear = prevYear - 1;
      }
      if (inputDate > monthDays[prevMonth - 1]) {
         prevDay = monthDays[prevMonth - 1];
      }
      var nextMonth = inputMonth + 2;
      var nextDay = inputDate;
      var nextYear = inputYear;
      if (nextMonth > 12) {
         nextMonth = 1;
         nextYear++;
      }
      if (inputDate > monthDays[nextMonth - 1]) {
         nextDay = monthDays[nextMonth - 1];
      }
      var startSpaces = inputDate;
      while (startSpaces > 7) startSpaces -= 7;
      startSpaces = inputDay - startSpaces + 1;
      startSpaces = startSpaces - this.FirstDayOfWeek;
      if (startSpaces < 0) startSpaces += 7;
      
      // table
      output = '<table';
      if (this.CalendarWidth > 0) 
         output += ' width=\"' + this.CalendarWidth + 'px\"';
      output += ' style=\"border:black 1px solid;\" border=0 cellspacing=0 cellpadding=2>';
     
      // previous month / year
      if (!this.DisplayCalendarYearSelection) {
         if (this.PreviousMonthImageUrl == '')
            output += eWorld_ReplaceFormat('<tr><td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\">&lt;</span></td>', new Array(style.MonthHeader, this.Id, prevMonth, prevDay, prevYear));
         else
            output += eWorld_ReplaceFormat('<tr><td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\"><img src=\"{5}\" border=0 /></span></td>', new Array(style.MonthHeader, this.Id, prevMonth, prevDay, prevYear, this.PreviousMonthImageUrl));
      } else {
         if (this.PreviousMonthImageUrl == '')
            output += eWorld_ReplaceFormat('<tr><td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\">&lt;</span>', new Array(style.MonthHeader, this.Id, prevMonth, prevDay, prevYear));
         else
            output += eWorld_ReplaceFormat('<tr><td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\"><img src=\"{5}\" border=0 /></span>', new Array(style.MonthHeader, this.Id, prevMonth, prevDay, prevYear, this.PreviousMonthImageUrl));
         
         if (this.PreviousYearImageUrl == '')
            output += eWorld_ReplaceFormat('&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{0}\').DisplayCalendar(\'{1}/{2}/{3}\');\">&lt;&lt;</span></td>', new Array(this.Id, inputMonth + 1, inputDate, inputYear - 1));
         else
            output += eWorld_ReplaceFormat('&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{0}\').DisplayCalendar(\'{1}/{2}/{3}\');\"><img src=\"{4}\" border=0 /></span></td>', new Array(this.Id, inputMonth + 1, inputDate, inputYear - 1, this.PreviousYearImageUrl));
      }
      
      // month cell
      if (!this.MonthYearDisabled) {
         output += eWorld_ReplaceFormat('<td colspan=5 nowrap align=center {0}><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayMonthYear(\'{2}/1/{3}\');\">{4} {5}', new Array(style.MonthHeader, this.Id, inputMonth + 1, inputYear, this.MonthNames[inputMonth], inputYear));
         if (this.MonthYearArrowUrl != '')
            output += eWorld_ReplaceFormat('&nbsp;<img src=\"{0}\" border=0 />', new Array(this.MonthYearArrowUrl));
      } else {
         output += eWorld_ReplaceFormat('<td colspan=5 nowrap align=center {0}><span>{1} {2}', new Array(style.MonthHeader.replace(/cursor:pointer;/, ''), this.MonthNames[inputMonth], inputYear));
      }
      output = output + '</span></td>';
      
      // next month / year
      if (!this.DisplayCalendarYearSelection) {
         if (this.NextMonthImageUrl == '')
            output += eWorld_ReplaceFormat('<td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\">&gt;</span></td></tr>', new Array(style.MonthHeader, this.Id, nextMonth, nextDay, nextYear));
         else
            output += eWorld_ReplaceFormat('<td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\"><img src=\"{5}\" border=0 /></span></td></tr>', new Array(style.MonthHeader, this.Id, nextMonth, nextDay, nextYear, this.NextMonthImageUrl));
      } else {
         if (this.NextYearImageUrl == '')
            output += eWorld_ReplaceFormat('<td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\">&gt;&gt;</span>', new Array(style.MonthHeader, this.Id, inputMonth + 1, inputDate, inputYear + 1));
         else
            output += eWorld_ReplaceFormat('<td {0} align=center><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\');\"><img src=\"{5}\" border=0 /></span>', new Array(style.MonthHeader, this.Id, inputMonth + 1, inputDate, inputYear + 1, this.NextYearImageUrl));
            
         if (this.NextMonthImageUrl == '')
            output += eWorld_ReplaceFormat('&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{0}\').DisplayCalendar(\'{1}/{2}/{3}\');\">&gt;</span></td></tr>', new Array(this.Id, nextMonth, nextDay, nextYear));
         else
            output += eWorld_ReplaceFormat('&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{0}\').DisplayCalendar(\'{1}/{2}/{3}\');\"><img src=\"{4}\" border=0 /></span></td></tr>', new Array(this.Id, nextMonth, nextDay, nextYear, this.NextMonthImageUrl));
      }
      
      // day headers
      output += eWorld_ReplaceFormat('<tr><td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[0]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[1]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[2]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[3]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[4]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td>', new Array(style.DayHeader, this.DayNames[5]));
      output += eWorld_ReplaceFormat('<td {0} align=center>{1}</td></tr>', new Array(style.DayHeader, this.DayNames[6]));
      
      // blank starting spaces
      for (var space=0; space<startSpaces; space++) {
         var spaceDay, spaceMonth, spaceYear;
         if (inputMonth == 0) {
            spaceDay = monthDays[11] - (startSpaces - (space + 1));
            spaceMonth = 12;
            spaceYear = inputYear - 1;
         } else {
            spaceDay = monthDays[inputMonth - 1] - (startSpaces - (space + 1));
            spaceMonth = inputMonth;
            spaceYear = inputYear;
         }
         var spaceDate = new Date(spaceMonth + '/' + spaceDay + '/' + spaceYear);
         var lowerAmount = (this.LowerBoundDate - spaceDate);
         var upperAmount = (spaceDate - this.UpperBoundDate);
         if (space == 0) output = output + '<tr>';
         if ((lowerAmount > 0 && upperAmount < 0) || (upperAmount > 0 && lowerAmount < 0))
            output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, ''), spaceDay));
         else
            output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.OffMonth, this.Id, spaceMonth, spaceDay, spaceYear));
      }
      
      // calendar days
      var count = 1;
      while (count <= monthDays[inputMonth]) {
         for (var weekday=startSpaces;weekday<7;weekday++) {
            var calendarDate = new Date(eWorld_ReplaceFormat('{0}/{1}/{2}', new Array(inputMonth + 1, count, inputYear)));
            var sameDate = (hid.value.length == 0) ? false : this.IsSameDate(currentDate, calendarDate);
            var isToday = this.IsSameDate(new Date(), calendarDate);
            var isSpecialDay = this.IsSpecialDay(calendarDate);
            var lowerAmount = (this.LowerBoundDate - calendarDate);
            var upperAmount = (calendarDate - this.UpperBoundDate);
            var disabled = ((lowerAmount > 0 && upperAmount < 0) || (lowerAmount < 0 && upperAmount > 0) || (this.IsSpecialDayDisabled(calendarDate)));
            var isWeekend = ((weekday == this.SundayNumber) || (weekday == this.SaturdayNumber));
            if (weekday == 0) output = output + '<tr>';
            if (count <= monthDays[inputMonth]) {
               // current month
               if (sameDate) {
                  if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), count));
                  else {
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.SelectedDate, this.Id, inputMonth + 1, count, inputYear));
                  }
               } else if (isToday) {
                  if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), count));
                  else
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.TodayDay, this.Id, inputMonth + 1, count, inputYear));
               } else if (isSpecialDay) {
                  if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), count));
                  else if (isWeekend)
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.SpecialDayWeekend, this.Id, inputMonth + 1, count, inputYear));
                  else
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.SpecialDayWeekday, this.Id, inputMonth + 1, count, inputYear));
               } else if (isWeekend) {
                  if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), count));
                  else
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.Weekend, this.Id, inputMonth + 1, count, inputYear));
               } else {
                  if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), count));
                  else
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.Weekday, this.Id, inputMonth + 1, count, inputYear));
               }
            } else {
               // next month
               var month, day, year;
               if (inputMonth == 11) {
                  month = 1;
                  year = inputYear + 1;
               } else {
                  month = inputMonth + 2;
                  year = inputYear;
               }
               day = count - monthDays[inputMonth];
               calendarDate = new Date(eWorld_ReplaceFormat('{0}/{1}/{2}', new Array(month, day, year)));
               lowerAmount = (this.LowerBoundDate - calendarDate);
               upperAmount = (calendarDate - this.UpperBoundDate);
               if (disabled)
                     output += eWorld_ReplaceFormat('<td align=center {0}>{1}</td>', new Array(style.DisabledDay.replace(/cursor:pointer;/, 'cursor:default;'), day));
                  else
                     output += eWorld_ReplaceFormat('<td align=center {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SelectDate(\'{2}/{3}/{4}\')\">{3}</td>', new Array(style.OffMonth, this.Id, month, day, year));
            }
            count++;
         }
         output = output + '</tr>';
         startSpaces = 0;
      }
      
      // go to today
      if (this.ShowGoToToday) {
         output += eWorld_ReplaceFormat('<tr><td colspan=7 align=center {0}><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/{3}/{4}\')\">{5}&nbsp;{6}</span></td></tr>', new Array(style.GoToToday, this.Id, todayDate.getMonth() + 1, todayDate.getDate(), todayDate.getFullYear(), this.GoToTodayText, this.FormatDate(todayDate)));
      }
      
      // clear date
      if (this.ShowClearDate && this.Nullable) {
         output += eWorld_ReplaceFormat('<tr><td colspan=7 align=center {0}><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').Clear()\">{2}</span></td></tr>', new Array(style.ClearDate, this.Id, this.ClearDateText));
      }
      
      output = output + '</table>';
         
      var div = document.getElementById(this.CalendarDivId);
      var divIframe = document.getElementById(this.CalendarDivId + '_iframe');
      
      div.innerHTML = output;
      
      if (divIframe != null) {
         divIframe.width = (document.all) ? div.offsetWidth : div.offsetWidth - 4;
         divIframe.height = (document.all) ? div.offsetHeight : div.offsetHeight - 4;
         divIframe.style.top = div.style.top;
         divIframe.style.left = div.style.left;
      }
   }
   
   this.SelectDate = function(input) {
      var date = new Date(input);
      var oldDate = document.getElementById(this.HiddenId).value;
      var formattedDate = this.FormatDate(date);
      var dateHasChanged = (oldDate != formattedDate);
      if (dateHasChanged) {
         if (document.getElementById(this.TextBoxId) != null) {
            document.getElementById(this.TextBoxId).value = formattedDate;
         }
         document.getElementById(this.HiddenId).value = formattedDate;
         if (document.getElementById(this.LabelId) != null) {
            document.getElementById(this.LabelId).innerHTML = formattedDate;
         }
         document.getElementById(this.ValidateHiddenId).value = input;
         this.VisibleDate = date;
         this.RaiseClientFunctions();
         this.Validate();
      }
      this.Hide();
   }
   
   this.Hide = function() {
      var div = document.getElementById(this.CalendarDivId);
      var iframe = document.getElementById(this.CalendarDivId + '_iframe');
      
      div.style.display = 'none';
      if (iframe != null) {
         iframe.style.display = 'none';
      }
      eWorld_CalendarPopup_CurrentCalendar = null;
      
      this.RemoveEvents();
   }
   
   this.RemoveEvents = function() {
      var div = document.getElementById(this.CalendarDivId);
      
      CalendarPopup_MouseOver();
      eWorld_RemoveEvent(div, 'mouseout', CalendarPopup_MouseOut);
      eWorld_RemoveEvent(div, 'mouseover', CalendarPopup_MouseOver);
   }
   
   this.RaiseClientFunctions = function() {
      if (this.JavascriptFunction.length > 0) {
         var value = '';
         var tb = document.getElementById(this.TextBoxId);
         var hid = document.getElementById(this.HiddenId);
         var value = '';
         if (tb != null) {
            value = tb.value;
         } else {
            value = hid.value;
         }
         
         eval(eWorld_ReplaceFormat('{0}("{1}", {2}, "{3}")', new Array(this.JavascriptFunction, value, (value.length == 0), this.Id)));
      }
      if (this.AutoPostBack) {
         __doPostBack(this.Id, '');
      }
   }
   
   this.DisplayMonthYear = function(input) {
      var date = new Date(input);
      var style = this.GetStyle();
      
      this.ActiveMonth = date.getMonth() + 1;
      this.ActiveYear = date.getFullYear();
      
      output = eWorld_ReplaceFormat('<div {0}><table style=\"border:black 1px solid;\" border=0 cellspacing=0 cellpadding=0>', new Array(style.MonthYearItem));
      output = output + '<tr><td valign=top><table border=0 cellspacing=0 cellpadding=2>';
      
      for (var i=0; i<12; i++) {
         if (i % 2 == 0) output = output + '<tr>';
         if (i == date.getMonth())
            output += eWorld_ReplaceFormat('<td align=center {0} nowrap><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveMonth({2});\">{3}</span></td>', new Array(style.MonthYearSelectedItem, this.Id, i + 1, this.MonthNames[i]));
         else
            output += eWorld_ReplaceFormat('<td align=center {0} nowrap><span onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveMonth({2});\">{3}</span></td>', new Array(style.MonthYearItem, this.Id, i + 1, this.MonthNames[i]));
         if (i % 2 != 0) output = output + '</tr>';
      }
      
      output = output + '</table></td><td valign=top><table border=0 cellspacing=0 cellpadding=2 width=100%>';
      
      for (var i=(date.getFullYear() - 2); i<(date.getFullYear() + 3); i++) {
         if (i == date.getFullYear())
            output += eWorld_ReplaceFormat('<tr><td align=center {0} nowrap>&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveYear({2});\">{2}</span>&nbsp;&nbsp;</td></tr>', new Array(style.MonthYearSelectedItem, this.Id, i));
         else
            output += eWorld_ReplaceFormat('<tr><td align=center {0} nowrap>&nbsp;&nbsp;<span onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveYear({2});\">{2}</span>&nbsp;&nbsp;</td></tr>', new Array(style.MonthYearItem, this.Id, i));
      }
      
      output += eWorld_ReplaceFormat('<tr><td align=center nowrap><span {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveYear({2});\">&lt;&lt;</span>', new Array(style.MonthYearItem, this.Id, date.getFullYear() - 5));
      output += eWorld_ReplaceFormat('<span {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').SetActiveYear({2});\">&gt;&gt;</span></td></tr>', new Array(style.MonthYearItem, this.Id, date.getFullYear() + 5));
      output += '</table></td></tr>';
      output += eWorld_ReplaceFormat('<tr><td colspan=2 style=\"padding-bottom:5px;padding-top:5px;\" align=center nowrap><span {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').DisplayCalendar(\'{2}/1/{3}\');CalendarPopup_FindCalendar(\'{1}\').HideMonthYear();\">&nbsp;&nbsp;{4}&nbsp;&nbsp;</span>&nbsp;&nbsp;', new Array(style.MonthYearButton, this.Id, this.ActiveMonth, this.ActiveYear, this.MonthYearApplyText));
      output += eWorld_ReplaceFormat('<span {0} onclick=\"CalendarPopup_FindCalendar(\'{1}\').HideMonthYear();\">&nbsp;&nbsp;{2}&nbsp;&nbsp;</span>&nbsp;&nbsp;</td></tr></table></div>', new Array(style.MonthYearButton, this.Id, this.MonthYearCancelText));
      
      this.RemoveEvents();
      
      var div = document.getElementById(this.MonthYearDivId);
      var divIframe = document.getElementById(this.MonthYearDivId + '_iframe');
      var cal = document.getElementById(this.CalendarDivId);
      
      div.innerHTML = output;
      div.style.left = cal.style.left;
      div.style.top = cal.style.top;
      div.style.display = 'block';
      
      if (divIframe != null) {
         divIframe.width = (document.all) ? div.offsetWidth : div.offsetWidth - 4;
         divIframe.height = (document.all) ? div.offsetHeight : div.offsetHeight - 4;
         divIframe.style.top = div.style.top;
         divIframe.style.left = div.style.left;
         divIframe.style.display = 'block';
      }
   }
   
   this.HideMonthYear = function() {
      var div = document.getElementById(this.MonthYearDivId);
      var divIframe = document.getElementById(this.MonthYearDivId + '_iframe');
      var calDiv = document.getElementById(this.CalendarDivId);
      var calDivIframe = document.getElementById(this.CalendarDivId + '_iframe');
      
      div.style.display = 'none';
      if (divIframe != null) {
         divIframe.style.display = 'none';
      }
      calDiv.style.display = 'block';
      if (calDivIframe != null) {
         calDivIframe.style.display = 'block';
      }
      
      eWorld_CalendarPopup_CurrentCalendar = this;
      
      this.Setup();
   }
   
   this.TextChanged = function() {
      var hid = document.getElementById(this.HiddenId);
      var tb = document.getElementById(this.TextBoxId);
      var valHid = document.getElementById(this.ValidateHiddenId);
      var date = this.GetDate();
      
      if (!this.AllowArbitraryText) {
         if (tb.value == '' && this.Nullable) {
            this.Clear();
            return;
         } else {
            tb.value = this.FormatDate(date);
         }
      }
      
      this.VisibleDate = date;
      hid.value = tb.value;
      valHid.value = date.getMonth() + "/" + date.getDay() + "/" + date.getFullYear();
      
      this.RaiseClientFunctions();
      this.Hide();
      this.Validate();
   }
   
   this.Disable = function() {
      var tb = document.getElementById(this.TextBoxId);
      var btn = document.getElementById(this.ButtonId);
      var img = document.getElementById(this.ImageId);
      var hid = document.getElementById(this.EnabledHiddenId);
      
      if (tb != null) {
         tb.disabled = true;
      }
      if (btn != null) {
         btn.disabled = true;
      }
      if (img != null && typeof(img.onclick) != 'undefined' && img.onclick != null) {
         img.disabled = true;
         img.style.cursor = 'default';
         this.ImageClick = img.onclick;
         img.onclick = null;
      }
      hid.value = 'false';
   }
   
   this.Enable = function() {
      var tb = document.getElementById(this.TextBoxId);
      var btn = document.getElementById(this.ButtonId);
      var img = document.getElementById(this.ImageId);
      var hid = document.getElementById(this.EnabledHiddenId);
      
      if (tb != null) {
         tb.disabled = false;
      }
      if (btn != null) {
         btn.disabled = false;
      }
      if (img != null && typeof(this.ImageClick) != 'undefined' && this.ImageClick != null) {
         img.disabled = false;
         img.style.cursor = 'pointer';
         img.onclick = this.ImageClick;
         this.ImageClick = null;
      }
      hid.value = 'true';
   }
   
   // NOTE: This needs to be placed at the end of the construction so that the method exists
   if (document.getElementById(this.EnabledHiddenId).value == 'false') {
      this.Disable();
   }
}

function CalendarPopup_Style(id, weekday, weekend, offMonth, selectedDate, monthHeader, dayHeader, clearDate, goToToday, todayDay, specialDayWeekday, specialDayWeekend, monthYearItem, monthYearSelectedItem, monthYearButton, disabledDay) {
   this.Id = id;
   this.Weekday = weekday;
   this.Weekend = weekend;
   this.OffMonth = offMonth;
   this.SelectedDate = selectedDate;
   this.MonthHeader = monthHeader;
   this.DayHeader = dayHeader;
   this.ClearDate = clearDate;
   this.GoToToday = goToToday;
   this.TodayDay = todayDay;
   this.SpecialDayWeekday = specialDayWeekday;   
   this.SpecialDayWeekend = specialDayWeekend;
   this.MonthYearItem = monthYearItem;
   this.MonthYearSelectedItem = monthYearSelectedItem;
   this.MonthYearButton = monthYearButton;
   this.DisabledDay = disabledDay;
}

function CalendarPopup_SpecialDay(id, month, day, year, span, disabled) {
   this.Id = id;
   this.Month = month;
   this.Day = day;
   this.Year = year;
   this.Span = span;
   this.Disabled = disabled;
}

function CalendarPopup_FindCalendar(id) {
   return eWorld_FindItem(eWorld_CalendarPopup_Calendars, id);
}

function CalendarPopup_LostFocus() {
   if (eWorld_CalendarPopup_CurrentCalendar != null) {
      eWorld_CalendarPopup_CurrentCalendar.Hide();
   }
}

function CalendarPopup_MouseOut() {
   eWorld_AddEvent(document, 'mousedown', CalendarPopup_LostFocus);
}

function CalendarPopup_MouseOver() {
   eWorld_RemoveEvent(document, 'mousedown', CalendarPopup_LostFocus);
}

function CalendarPopup_InitializeCompatibility() {
   if (typeof(eWorld_UI_CalendarPopups) != 'undefined') {
      for (var i=0; i<eWorld_UI_CalendarPopups.length; i++) {
         var element = document.getElementById(eWorld_UI_CalendarPopups[i]);
         eWorld_CalendarPopup_Styles[i] = eval(element.calendarStyle);

         eWorld_CalendarPopup_Calendars[i] = eval(element.calendar);
           
         if (typeof(element.specialDays) != 'undefined') {
            var specialDays = element.specialDays.split(';');
            for (var j=0; j<specialDays.length; j++) {
               eWorld_CalendarPopup_SpecialDays[eWorld_CalendarPopup_SpecialDays.length] = eval(specialDays[j]);
            }
         }
      }
   }
}
