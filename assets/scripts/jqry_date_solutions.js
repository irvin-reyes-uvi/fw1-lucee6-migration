// JavaScript Document
var var_year_from = 2000;
var var_year_to = 2020;
function setYearFromTo(p_year_from, p_year_to) {
  var_year_from = p_year_from;
  var_year_to = p_year_to;
}
/*
	Obtain the days in a specific month of a specific year
	
	p_month: number of month, starting from 1 which is January, ending with 12 which is December
	p_year: year number,4 digits format,such as: 2003,1971
*/
function daysInMonth(p_month, p_year) {
  var v_is_leap_year =
    p_year % 400 ? (p_year % 100 ? (p_year % 4 ? false : true) : false) : true;
  var v_days = 31;

  if (p_month == 2) {
    // Feb
    v_days = v_is_leap_year ? 29 : 28;
    //alert('FEB:p_month='+p_month+'--p_year='+p_year+'--v_days='+v_days);
  } else if (p_month % 2) {
    // if the month is "ODD"
    v_days = p_month <= 7 ? 31 : 30; // if the month is ODD and between Jan - July, then it will have 30 days, otherwise it will have 31
    //alert('ODD:p_month='+p_month+'--p_year='+p_year+'--v_days='+v_days);
  } else {
    // if the month is "EVEN"
    v_days = p_month <= 7 ? 30 : 31; // similar to above but when months are odd
    //alert('EVEN:p_month='+p_month+'--p_year='+p_year+'--v_days='+v_days);
  }

  return v_days;
}
function month_to_3LetterName(p_month) {
  if (p_month == 1) {
    return "Jan";
  } else if (p_month == 2) {
    return "Feb";
  } else if (p_month == 3) {
    return "Mar";
  } else if (p_month == 4) {
    return "Apr";
  } else if (p_month == 5) {
    return "May";
  } else if (p_month == 6) {
    return "Jun";
  } else if (p_month == 7) {
    return "Jul";
  } else if (p_month == 8) {
    return "Aug";
  } else if (p_month == 9) {
    return "Sep";
  } else if (p_month == 10) {
    return "Oct";
  } else if (p_month == 11) {
    return "Nov";
  } else if (p_month == 12) {
    return "Dec";
  }
  return "";
}

/*
	Should be run one time on this page, set up the year, month and days. The year and month will not change any more
	p_select_year: element id of the "year" <select>
	p_year:  the year to be selected
	p_select_month: element id of the "month" <select>
	p_month:  the month to be selected
	p_select_day: element id of the "day" <select>
	p_day:  the day to be selected
*/
function initDateSelect(
  p_select_year,
  p_year,
  p_select_month,
  p_month,
  p_select_day,
  p_day
) {
  var v_days_in_month = daysInMonth(p_month, p_year);
  var v_year_diff = var_year_to - var_year_from + 1;
  var v_num_tmp = 0;
  var v_is_selected = false; //shared by year, month and day
  var i = 0;
  $("#" + p_select_year + " option").remove();
  $("#" + p_select_month + " option").remove();
  $("#" + p_select_day + " option").remove();

  //init years
  v_num_tmp = var_year_from;
  for (i = 0; i < v_year_diff; i++) {
    v_is_selected = false;
    if (v_num_tmp == p_year) {
      v_is_selected = true;
    }

    $("#" + p_select_year).append(
      $("<option></option>")
        .attr("value", v_num_tmp)
        .attr("selected", v_is_selected)
        .text(v_num_tmp)
    );
    v_num_tmp++;
  }

  //init months
  for (i = 1; i <= 12; i++) {
    v_is_selected = false;
    if (i == p_month) {
      v_is_selected = true;
    }
    $("#" + p_select_month).append(
      $("<option></option>")
        .attr("value", i)
        .attr("selected", v_is_selected)
        .text(month_to_3LetterName(i))
    );
  }
  //init days
  for (i = 1; i <= v_days_in_month; i++) {
    v_is_selected = false;
    if (i == p_day) {
      v_is_selected = true;
    }
    $("#" + p_select_day).append(
      $("<option></option>")
        .attr("value", i)
        .attr("selected", v_is_selected)
        .text(i)
    );
  }
}

/*
	When year or month is changed, re-init the day <select>
	p_select_year: element id of the "year" <select>
	p_select_month: element id of the "month" <select>
	p_select_day: element id of the "day" <select>
	
*/
function changeYearMonth(p_select_year, p_select_month, p_select_day) {
  var v_select_year = $("#" + p_select_year);
  var v_select_month = $("#" + p_select_month);
  var v_select_day = $("#" + p_select_day);
  //alert('p_select_year='+p_select_year+'--p_year='+p_year+'--p_select_month='+p_select_month+'--p_month='+p_month+'--p_select_day='+p_select_day+'--p_day='+p_day);

  var v_year_value = $("#" + p_select_year).val();
  var v_month_value = $("#" + p_select_month).val();
  var v_day_value = $("#" + p_select_day).val();
  var v_days_in_month = daysInMonth(v_month_value, v_year_value);
  var v_day_to_be =
    v_days_in_month > v_day_value ? v_day_value : v_days_in_month;
  var i = 0;
  var v_is_selected = false; //shared by year, month and day
  //alert('v_year_value:'+v_year_value+'  v_month_value:'+v_month_value+'  v_day_value:'+v_day_value+'   v_days_in_month:'+v_days_in_month);
  $("#" + p_select_day + " option").remove();
  for (i = 1; i <= v_days_in_month; i++) {
    v_is_selected = false;
    if (i == v_day_to_be) {
      v_is_selected = true;
    }
    $("#" + p_select_day).append(
      $("<option></option>")
        .attr("value", i)
        .attr("selected", v_is_selected)
        .text(i)
    );
  }
}
