$(document).ready(function () {
  new MaskedPassword(document.getElementById("CreditCard"), "\u25CF");
  new MaskedPassword(document.getElementById("cvv2Code"), "\u25CF");
});
$(document).ready(function () {
  var v_cvv_name = "cvv2Code";
  var v_ccnumber_name = "CreditCard";
  var v_cvv_id = "cvv2Code"; // the id of the <input> element of cvv code
  var v_ccnumber_id = "CreditCard"; // the id of the <input> element of credit card
  var v_cczip_id = "CCZipCode";
  var v_cctype_id = "cardtype";
  var errorCounter = 0,
    msg = "",
    cvvRegex3 = /^[0-9]{3}$/,
    cvvRegex4 = /^[0-9]{4}$/,
    zipRegex = /^[a-zA-Z0-9]+$/,
    zipInput = $("#" + v_cczip_id),
    cardTypeSelect = $("#" + v_cctype_id),
    realCCinput = $("input[name=" + v_ccnumber_name + "]"),
    realCVVinput = $("input[name=" + v_cvv_name + "]");

  //CC type max length setter
  $("#" + v_cctype_id)
    .on("change", function () {
      var v_ccType_val = $(this).val(),
        v_input_ccNum = $("#" + v_ccnumber_name),
        v_input_cVV = $("#" + v_cvv_name);

      if (v_ccType_val == 3) {
        v_input_ccNum.prop("maxLength", 15).val("");
        v_input_cVV.prop("maxLength", 4).val("");
      } else {
        v_input_ccNum.prop("maxLength", 16).val("");
        v_input_cVV.prop("maxLength", 3).val("");
      }
    })
    .change();

  //Zip Code Keyup Validator
  zipInput.on("keyup blur", function (e) {
    var $this = $(this);
    $this.val($this.val().replace(/[^a-zA-Z0-9]/g, ""));
  });

  //CC Number Keyup Validator
  $("#" + v_ccnumber_id + ", #" + v_cvv_id).on("keydown", function (e) {
    if (
      (e.which >= 48 && e.which <= 57) || //number pad
      (e.which >= 96 && e.which <= 105) || //numbers
      e.which == 8 || //backspace
      e.which == 9 || //tab
      (e.which == 86 && e.metaKey === true) || //paste on mac
      (e.which == 86 && e.ctrlKey === true) //paste on pc
    ) {
      //continue...
    } else {
      return false;
    }
  });

  $("#CreditCard").on("blur", function () {
    changeccTypeLog();
  });

  //Force Payment amount field to only accept numbers
  $("#PaymentAmount").keydown(function (e) {
    $(this).removeClass("placeholder");
    // Allow: backspace, delete, tab, escape, enter and .
    if (
      $.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
      // Allow: Ctrl+A
      (e.keyCode == 65 && e.ctrlKey === true) ||
      // Allow: home, end, left, right
      (e.keyCode >= 35 && e.keyCode <= 39)
    ) {
      // let it happen, don't do anything
      return;
    }
    // Ensure that it is a number and stop the keypress
    if (
      (e.shiftKey || e.keyCode < 48 || e.keyCode > 57) &&
      (e.keyCode < 96 || e.keyCode > 105)
    ) {
      e.preventDefault();
    }
  });

  $("#CreditCard").on("keyup", function () {
    changeccTypeLog();
  });

  $("#PaymentAmount").on("blur", function () {
    val = removeAllButLast($(this).val());

    val = val.substr(0, 1) === "." ? val.substr(1) : val;
    if (val.length > 0) {
      $(this).val(parseFloat(val).toFixed(2));
    } else {
      $(this).addClass("placeholder");
      $(this).val("$ 5.00 - No limit");
    }
  });

  $("#PaymentAmount").focus(function () {
    if ($(this).val().indexOf("limit") > 0) {
      $(this).val("");
    }
  });

  $("select[name=CCCountry]").on("change", function () {
    var $thisSelect = $(this);
    var selectVal = $thisSelect.val();

    $thisSelect.changestates(
      "CCState",
      "otherState",
      "countryOther",
      selectVal
    );

    if (selectVal != "") {
      var countryCode = selectVal;
      var zipCodeCountryLength =
        countryCode === "CA" ? 6 : countryCode === "US" ? 5 : 19;
      var zipCodeMinLength =
        countryCode === "CA" ? 6 : countryCode === "US" ? 5 : 0;

      $("#CCZipCode").attr("maxlength", zipCodeCountryLength);
      $("#CCZipCode").attr("minlength", zipCodeMinLength.toString());

      $("#CCZipCode").removeClass("validate-number");

      if ($("#CCZipCode").val().length !== zipCodeCountryLength) {
        $("#CCZipCode").val(
          $("#CCZipCode").val().slice(0, zipCodeCountryLength)
        );
      }

      if (selectVal !== "US" && selectVal !== "GB" && selectVal !== "CA") {
        $("#otherStateLabel").css({ display: "block" });
        $("#stateRow").css({ display: "none" });
      } else {
        $("#stateRow").css({ display: "block" });
        $("#otherStateLabel").css({ display: "none" });
        if (selectVal === "US") $("#CCZipCode").addClass("validate-number");
      }
    }
  });
});

function removeAllButLast(string) {
  var parts = string.split(".");
  return parts.slice(0, -1).join("") + "." + parts.slice(-1);
}

function GetCardType(number) {
  // visa
  var re = new RegExp("^4");
  if (number.match(re) != null) return "Visa";

  // Mastercard
  re = new RegExp("^5[1-5]");
  if (number.match(re) != null) return "Mastercard";
  re = new RegExp("^2[2-7]");
  if (number.match(re) != null) return "Mastercard";

  // AMEX
  re = new RegExp("^3[47]");
  if (number.match(re) != null) return "AMEX";

  // Discover
  re = new RegExp(
    "^(6011|622(12[6-9]|1[3-9][0-9]|[2-8][0-9]{2}|9[0-1][0-9]|92[0-5]|64[4-9])|65)"
  );
  if (number.match(re) != null) return "Discover";

  return "";
}

function changeccTypeLog() {
  var type = GetCardType($('[name="CreditCard"]').val());
  $('[name="cardtype"]').val(0);
  $("#CreditCard").prop("maxLength", 16);
  $("#cvv2Code").prop("maxLength", 3);
  if (type == "Visa") {
    $(".cardType").css({
      display: "block",
      backgroundPosition: "3px 2px",
      width: "41px",
      height: "25px",
      position: "relative",
      left: "-65px",
    });
    $('[name="cardtype"]').val(2);
  } else if (type == "Mastercard") {
    $(".cardType").css({
      display: "block",
      backgroundPosition: "-36px 2px",
      width: "41px",
      height: "25px",
      position: "relative",
      left: "-65px",
    });
    $('[name="cardtype"]').val(1);
  } else if (type == "AMEX") {
    $(".cardType").css({
      display: "block",
      backgroundPosition: "-79px 2px",
      width: "41px",
      height: "25px",
      position: "relative",
      left: "-65px",
    });
    $('[name="cardtype"]').val(3);
    $("#CreditCard").prop("maxLength", 15);
    $("#cvv2Code").prop("maxLength", 4);
  } else if (type == "Discover") {
    $(".cardType").css({
      display: "block",
      backgroundPosition: "-138px 2px",
      width: "41px",
      height: "25px",
      position: "relative",
      left: "-65px",
    });
    $('[name="cardtype"]').val(4);
  } else {
    $(".cardType").css("display", "none");
  }
}
