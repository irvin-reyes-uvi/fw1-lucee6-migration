const sandalsHeaderProject = "/sandals-menu-header/";
const BookingSearchForm = document.getElementById("BookingSearchForm");

if (BookingSearchForm !== null) {
  BookingSearchForm.addEventListener("submit", function (e) {
    e.preventDefault();
    Verify();
  });
}

const brandSandals = document.getElementById("brandSandals");
if (brandSandals !== null) {
  document
    .getElementById("brandSandals")
    .addEventListener("click", function () {
      changeResorts(this);
    });
}

const brandBeaches = document.getElementById("brandBeaches");
if (brandBeaches !== null) {
  document
    .getElementById("brandBeaches")
    .addEventListener("click", function () {
      changeResorts(this);
    });
}

$(document).ready(function () {
  const brandRadios = document.querySelectorAll('input[name="brand"]');
  const sandalsRow = document.getElementById("rstSandals");
  const beachesRow = document.getElementById("rstBeaches");
  hideElem();
  console.log("EESSDEE");
  brandRadios.forEach((radio) => {
    radio.addEventListener("change", function () {
      if (this.value === "S") {
        sandalsRow.classList.remove("hidden");
        beachesRow.classList.add("hidden");
      } else if (this.value === "B") {
        beachesRow.classList.remove("hidden");
        sandalsRow.classList.add("hidden");
      }
    });
  });

  const resortCodes = document.querySelector("#ResortCodeS");
  if (resortCodes !== null) {
    resortCodes.addEventListener("change", function () {
      validateResort(this);
    });
  }

  const resortCodeb = document.querySelector("#ResortCodeB");
  if (resortCodeb !== null) {
    resortCodeb.addEventListener("change", function () {
      validateResort(this);
    });
  }
});

function Verify() {
  const regx = /([\<])([^\>]{1,})*([\>])/gi;
  const regy = /[\<\>]/gi;

  const GroupName = document.BookingSearchForm.GroupName.value;
  if (regx.test(GroupName)) {
    GroupName = GroupName.replace(regx, "");
  }
  if (regy.test(GroupName)) {
    GroupName = GroupName.replace(regy, "");
  }

  document.BookingSearchForm.GroupName.value = GroupName;

  Display = "You left the following fields blank\n";
  if (document.BookingSearchForm.BookingNumber.value == "") {
    Display = Display + "Booking Number\n";
  }

  if (document.BookingSearchForm.GroupName.value == "") {
    Display = Display + "Group Name\n";
  }

  if (document.BookingSearchForm.ResortCode.value == "") {
    Display = Display + "Resort\n";
  }
  if (document.BookingSearchForm.CheckinDt.value == "") {
    Display = Display + "Check In Date\n";
  }
  if (Display != "You left the following fields blank\n") {
    alert(Display);
    return false;
  }
  if (
    !document.getElementById("brandSandals").checked &&
    !document.getElementById("brandBeaches").checked &&
    !document.getElementById("brandGP").checked
  ) {
    Display = Display + "Resort Brand\n";
  } else {
    document.forms[0].submit();
  }
}

function checkDate(dateField) {
  let err = 0;

  window.onerror = null;
  fval = dateField.value;
  if (fval != null) {
    if (fval.length > 0) {
      spos = -1;
      epos = -1;
      spos = fval.indexOf("/");
      if (spos != -1) {
        epos = fval.lastIndexOf("/");
      } else {
        spos = fval.indexOf("-");
        if (spos != -1) {
          epos = fval.lastIndexOf("-");
        }
      }
      if (spos == -1 || epos == -1 || epos == spos) {
        err = 1;
      } else {
        mn = fval.substring(0, spos);
        dy = fval.substring(spos + 1, epos);
        yr = fval.substring(epos + 1, fval.length);
        if (isNaN(mn)) {
          err = 1;
        }
        if (isNaN(dy)) {
          err = 1;
        }
        if (isNaN(yr)) {
          err = 1;
        }
        if (mn < 1 || mn > 12) {
          err = 1;
        }
        if (dy < 1 || dy > 31) {
          err = 1;
        }
        if (yr < 999 || yr > 9999) {
          err = 1;
        }

        // months with 30 days
        if (mn == 4 || mn == 6 || mn == 11 || mn == 9) {
          if (dy == 31) {
            err = 1;
          }
        }

        //leap year
        if (mn == 2) {
          if (dy > 29) {
            err = 1;
          }
          if (dy == 29 && yr % 4 != 0) {
            err = 1;
          }
        }
      }

      if (err) {
        fval = prompt("Please format dates mm/dd/yyyy.", fval);

        //returns null if they press cancel
        if (fval != null) {
          dateField.value = fval;
          checkdate(dateField);
        } else {
          dateField.value = "";
        }
      }
    }
  }
}
function calendar(formname, txtname) {
  const nUrl =
    "calendar.cfm?location=obe&target=" + txtname + "&myform=" + formname;

  const newWind = window.open(nUrl, "Calendar", "width=550,height=200");
  if (newWind.opener == null) {
    newWind.opener = window;
  }
}

// Credit card number.
const CC_REGEX = /^[0-9]{15,16}$/;

// Luhn MOD10 validation.
function LHV10_isValid(number) {
  return LHV_calculateChecksum(number, true) % 10 == 0 ? true : false;
}

// Luhn MOD10 checksum calculation.
function LHV10_calculate(number) {
  return 10 - (LHV_calculateChecksum(number, false) % 10);
}

// Luhn MOD10 plus MOD5 validation.
function LHV10p5_isValid(number) {
  const checksum = LHV_calculateChecksum(number, true) % 10;

  if (checksum == 0 || checksum == 5) {
    return true;
  } else {
    return false;
  }
}

// Luhn MOD10 checksum digit calculation.
function LHV_calculateChecksum(number, validating) {
  if (!number.match(CC_REGEX)) {
    return -1;
  }

  let checksum = 0;
  let digits = reverseToArray(number);

  let addEvens = validating;
  let m = 0;
  for (let i = 0; i < digits.length; i++) {
    if (addEvens) {
      checksum += digits[i];
    } else {
      m = digits[i] * 2;
      checksum += m > 9 ? m - 9 : m;
    }
    addEvens = !addEvens;
  }

  return checksum;
}

// Reverse to array utility.
function reverseToArray(number) {
  let digits = new Array();

  for (let i = 0, r = number.length - 1; r >= 0; i++, r--) {
    digits[i] = parseInt(number.charAt(r), 10);
  }

  return digits;
}

function VerifyPayment() {
  let v_cvv_name = "cvv2Code",
    v_ccnumber_name = "CreditCard",
    v_cvv_id = "cvv2Code",
    v_ccnumber_id = "CreditCard",
    v_cczip_id = "CCZipCode",
    v_cctype_id = "cardtype",
    v_paymentamount_id = "PaymentAmount",
    v_MinPayment_id = "MinPayment",
    v_CCFirstName_id = "CCFirstName",
    v_CCLastName_id = "CCLastName",
    v_CCEmail_id = "Email",
    v_CCAddress_id = "CCAddress",
    v_CCCountry_id = "CCCountry",
    v_CCCity_id = "CCCity",
    v_CCState_id = "CCState",
    v_expiryyear_id = "year",
    v_expirymonth_id = "month",
    v_paymentType_id = "paymentType",
    v_firstname_id = "CCFirstName",
    v_lastname_id = "CCLastName",
    errorCounter = 0,
    msg = "",
    cvvRegex3 = /^[0-9]{3}$/,
    cvvRegex4 = /^[0-9]{4}$/,
    zipRegex = /^[a-zA-Z0-9]+$/,
    cardTypeSelect = $("#" + v_cctype_id),
    realCCinput = $("input[name=" + v_ccnumber_name + "]"),
    realCVVinput = $("input[name=" + v_cvv_name + "]");

  let v_ccnumber_val = $.trim($("input[name=" + v_ccnumber_name + "]").val()),
    v_cc_ccvid_val = $.trim($("input[name=" + v_cvv_name + "]").val()),
    v_ccType_val = $("#" + v_cctype_id).val(),
    v_paymentamount_val = $.trim($("#" + v_paymentamount_id).val()),
    v_MinPayment_val = $.trim($("#" + v_MinPayment_id).val()),
    v_CCFirstName_val = $.trim($("#" + v_CCFirstName_id).val()),
    v_CCLastName_val = $.trim($("#" + v_CCLastName_id).val()),
    v_CCEmail_val = $.trim($("#" + v_CCEmail_id).val()),
    v_CCAddress_val = $.trim($("#" + v_CCAddress_id).val()),
    v_CCCountry_val = $.trim($("#" + v_CCCountry_id).val()),
    v_CCCity_val = $.trim($("#" + v_CCCity_id).val()),
    v_CCState_val = $.trim($("#" + v_CCState_id).val()),
    v_CCZipCode_val = $.trim($("#" + v_cczip_id).val()),
    v_paymentType_val = $.trim(
      $("input[name=" + v_paymentType_id + "]").is(":checked")
    ),
    v_expiryyear_val = $.trim($("#" + v_expiryyear_id).val()),
    v_expirymonth_val = $.trim($("#" + v_expirymonth_id).val()),
    v_firstname_val = $.trim($("#" + v_firstname_id).val()),
    v_lastname_val = $.trim($("#" + v_lastname_id).val());

  let errors = "",
    errors_count = 0;

  if (v_ccnumber_val == "") {
    errors += "Credit Card\n";
    errors_count++;
  }
  if (v_cc_ccvid_val == "") {
    errors += "CVV2 Code\n";
    errors_count++;
  }
  if (v_paymentamount_val == "" || v_paymentamount_val == "$ 5.00 - No limit") {
    errors += "Payment Amount\n";
    errors_count++;
  }
  if (v_CCFirstName_val == "") {
    errors += "First Name\n";
    errors_count++;
  }
  if (v_CCLastName_val == "") {
    errors += "Last Name\n";
    errors_count++;
  }
  if (v_CCEmail_val == "") {
    errors += "Email\n";
    errors_count++;
  }
  if (v_CCAddress_val == "") {
    errors += "Address\n";
    errors_count++;
  }
  if (v_CCCountry_val == 0) {
    errors += "Country\n";
    errors_count++;
  }
  if (v_CCCity_val == "") {
    errors += "City\n";
    errors_count++;
  }
  if (
    v_CCState_val == "" &&
    (v_CCCountry_val == "US" ||
      v_CCCountry_val == "CA" ||
      v_CCCountry_val == "GB")
  ) {
    errors += "State\n";
    errors_count++;
  }
  if (v_CCZipCode_val == "") {
    errors += "Zip Code\n";
    errors_count++;
  }
  if (v_paymentType_val == "false") {
    errors += "Payment Type\n";
    errors_count++;
  }

  if (errors != "") {
    if (errors_count == 1) {
      alert("The following field is required:\n\n" + errors);
      return false;
    } else {
      alert("The following fields are required:\n\n" + errors);
      return false;
    }
  }

  const regexName =
    /^[A-Za-z\xAA\xB5\xBA\xC0-\xD6\xD8-\xF6\xF8-\u02C1\u02C6-\u02D1\u02E0-\u02E4\u02EC\u02EE\u0370-\u0374\u0376\u0377\u037A-\u037D\u0386\u0388-\u038A\u038C\u038E-\u03A1\u03A3-\u03F5\u03F7-\u0481\u048A-\u0527\u0531-\u0556\u0559\u0561-\u0587\u05D0-\u05EA\u05F0-\u05F2\u0620-\u064A\u066E\u066F\u0671-\u06D3\u06D5\u06E5\u06E6\u06EE\u06EF\u06FA-\u06FC\u06FF\u0710\u0712-\u072F\u074D-\u07A5\u07B1\u07CA-\u07EA\u07F4\u07F5\u07FA\u0800-\u0815\u081A\u0824\u0828\u0840-\u0858\u08A0\u08A2-\u08AC\u0904-\u0939\u093D\u0950\u0958-\u0961\u0971-\u0977\u0979-\u097F\u0985-\u098C\u098F\u0990\u0993-\u09A8\u09AA-\u09B0\u09B2\u09B6-\u09B9\u09BD\u09CE\u09DC\u09DD\u09DF-\u09E1\u09F0\u09F1\u0A05-\u0A0A\u0A0F\u0A10\u0A13-\u0A28\u0A2A-\u0A30\u0A32\u0A33\u0A35\u0A36\u0A38\u0A39\u0A59-\u0A5C\u0A5E\u0A72-\u0A74\u0A85-\u0A8D\u0A8F-\u0A91\u0A93-\u0AA8\u0AAA-\u0AB0\u0AB2\u0AB3\u0AB5-\u0AB9\u0ABD\u0AD0\u0AE0\u0AE1\u0B05-\u0B0C\u0B0F\u0B10\u0B13-\u0B28\u0B2A-\u0B30\u0B32\u0B33\u0B35-\u0B39\u0B3D\u0B5C\u0B5D\u0B5F-\u0B61\u0B71\u0B83\u0B85-\u0B8A\u0B8E-\u0B90\u0B92-\u0B95\u0B99\u0B9A\u0B9C\u0B9E\u0B9F\u0BA3\u0BA4\u0BA8-\u0BAA\u0BAE-\u0BB9\u0BD0\u0C05-\u0C0C\u0C0E-\u0C10\u0C12-\u0C28\u0C2A-\u0C33\u0C35-\u0C39\u0C3D\u0C58\u0C59\u0C60\u0C61\u0C85-\u0C8C\u0C8E-\u0C90\u0C92-\u0CA8\u0CAA-\u0CB3\u0CB5-\u0CB9\u0CBD\u0CDE\u0CE0\u0CE1\u0CF1\u0CF2\u0D05-\u0D0C\u0D0E-\u0D10\u0D12-\u0D3A\u0D3D\u0D4E\u0D60\u0D61\u0D7A-\u0D7F\u0D85-\u0D96\u0D9A-\u0DB1\u0DB3-\u0DBB\u0DBD\u0DC0-\u0DC6\u0E01-\u0E30\u0E32\u0E33\u0E40-\u0E46\u0E81\u0E82\u0E84\u0E87\u0E88\u0E8A\u0E8D\u0E94-\u0E97\u0E99-\u0E9F\u0EA1-\u0EA3\u0EA5\u0EA7\u0EAA\u0EAB\u0EAD-\u0EB0\u0EB2\u0EB3\u0EBD\u0EC0-\u0EC4\u0EC6\u0EDC-\u0EDF\u0F00\u0F40-\u0F47\u0F49-\u0F6C\u0F88-\u0F8C\u1000-\u102A\u103F\u1050-\u1055\u105A-\u105D\u1061\u1065\u1066\u106E-\u1070\u1075-\u1081\u108E\u10A0-\u10C5\u10C7\u10CD\u10D0-\u10FA\u10FC-\u1248\u124A-\u124D\u1250-\u1256\u1258\u125A-\u125D\u1260-\u1288\u128A-\u128D\u1290-\u12B0\u12B2-\u12B5\u12B8-\u12BE\u12C0\u12C2-\u12C5\u12C8-\u12D6\u12D8-\u1310\u1312-\u1315\u1318-\u135A\u1380-\u138F\u13A0-\u13F4\u1401-\u166C\u166F-\u167F\u1681-\u169A\u16A0-\u16EA\u1700-\u170C\u170E-\u1711\u1720-\u1731\u1740-\u1751\u1760-\u176C\u176E-\u1770\u1780-\u17B3\u17D7\u17DC\u1820-\u1877\u1880-\u18A8\u18AA\u18B0-\u18F5\u1900-\u191C\u1950-\u196D\u1970-\u1974\u1980-\u19AB\u19C1-\u19C7\u1A00-\u1A16\u1A20-\u1A54\u1AA7\u1B05-\u1B33\u1B45-\u1B4B\u1B83-\u1BA0\u1BAE\u1BAF\u1BBA-\u1BE5\u1C00-\u1C23\u1C4D-\u1C4F\u1C5A-\u1C7D\u1CE9-\u1CEC\u1CEE-\u1CF1\u1CF5\u1CF6\u1D00-\u1DBF\u1E00-\u1F15\u1F18-\u1F1D\u1F20-\u1F45\u1F48-\u1F4D\u1F50-\u1F57\u1F59\u1F5B\u1F5D\u1F5F-\u1F7D\u1F80-\u1FB4\u1FB6-\u1FBC\u1FBE\u1FC2-\u1FC4\u1FC6-\u1FCC\u1FD0-\u1FD3\u1FD6-\u1FDB\u1FE0-\u1FEC\u1FF2-\u1FF4\u1FF6-\u1FFC\u2071\u207F\u2090-\u209C\u2102\u2107\u210A-\u2113\u2115\u2119-\u211D\u2124\u2126\u2128\u212A-\u212D\u212F-\u2139\u213C-\u213F\u2145-\u2149\u214E\u2183\u2184\u2C00-\u2C2E\u2C30-\u2C5E\u2C60-\u2CE4\u2CEB-\u2CEE\u2CF2\u2CF3\u2D00-\u2D25\u2D27\u2D2D\u2D30-\u2D67\u2D6F\u2D80-\u2D96\u2DA0-\u2DA6\u2DA8-\u2DAE\u2DB0-\u2DB6\u2DB8-\u2DBE\u2DC0-\u2DC6\u2DC8-\u2DCE\u2DD0-\u2DD6\u2DD8-\u2DDE\u2E2F\u3005\u3006\u3031-\u3035\u303B\u303C\u3041-\u3096\u309D-\u309F\u30A1-\u30FA\u30FC-\u30FF\u3105-\u312D\u3131-\u318E\u31A0-\u31BA\u31F0-\u31FF\u3400-\u4DB5\u4E00-\u9FCC\uA000-\uA48C\uA4D0-\uA4FD\uA500-\uA60C\uA610-\uA61F\uA62A\uA62B\uA640-\uA66E\uA67F-\uA697\uA6A0-\uA6E5\uA717-\uA71F\uA722-\uA788\uA78B-\uA78E\uA790-\uA793\uA7A0-\uA7AA\uA7F8-\uA801\uA803-\uA805\uA807-\uA80A\uA80C-\uA822\uA840-\uA873\uA882-\uA8B3\uA8F2-\uA8F7\uA8FB\uA90A-\uA925\uA930-\uA946\uA960-\uA97C\uA984-\uA9B2\uA9CF\uAA00-\uAA28\uAA40-\uAA42\uAA44-\uAA4B\uAA60-\uAA76\uAA7A\uAA80-\uAAAF\uAAB1\uAAB5\uAAB6\uAAB9-\uAABD\uAAC0\uAAC2\uAADB-\uAADD\uAAE0-\uAAEA\uAAF2-\uAAF4\uAB01-\uAB06\uAB09-\uAB0E\uAB11-\uAB16\uAB20-\uAB26\uAB28-\uAB2E\uABC0-\uABE2\uAC00-\uD7A3\uD7B0-\uD7C6\uD7CB-\uD7FB\uF900-\uFA6D\uFA70-\uFAD9\uFB00-\uFB06\uFB13-\uFB17\uFB1D\uFB1F-\uFB28\uFB2A-\uFB36\uFB38-\uFB3C\uFB3E\uFB40\uFB41\uFB43\uFB44\uFB46-\uFBB1\uFBD3-\uFD3D\uFD50-\uFD8F\uFD92-\uFDC7\uFDF0-\uFDFB\uFE70-\uFE74\uFE76-\uFEFC\uFF21-\uFF3A\uFF41-\uFF5A\uFF66-\uFFBE\uFFC2-\uFFC7\uFFCA-\uFFCF\uFFD2-\uFFD7\uFFDA-\uFFDC \-]+$/i;

  if (regexName.test(v_firstname_val) == false) {
    alert("First Name field should only contain letters");
    return false;
  }

  if (regexName.test(v_lastname_val) == false) {
    alert("Last Name field should only contain letters");
    return false;
  }

  const regEmail =
    /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (!regEmail.test(v_CCEmail_val)) {
    alert("Email is incorrect");
    return false;
  }

  const regyy = /([\<])([^\>]{1,})*([\>])/gi;
  const regxx = /[\<\>]/gi;

  if (regyy.test(v_CCFirstName_val) || regxx.test(v_CCFirstName_val)) {
    alert("First Name is incorrect");
    return false;
  }
  if (regyy.test(v_CCLastName_val) || regxx.test(v_CCLastName_val)) {
    alert("Last Name is incorrect");
    return false;
  }
  if (regyy.test(v_CCAddress_val) || regxx.test(v_CCAddress_val)) {
    alert("Address is incorrect");
    return false;
  }
  if (regyy.test(v_CCCity_val) || regxx.test(v_CCCity_val)) {
    alert("City is incorrect");
    return false;
  }
  if (regyy.test(v_CCState_val) || regxx.test(v_CCState_val)) {
    alert("State is incorrect");
    return false;
  }

  //validate Zip Code
  const country = $("select[name=CCCountry]").val();

  if (country === "US" || country === "CA") {
    if (
      $("#CCZipCode").val().length < parseInt($("#CCZipCode").attr("minlength"))
    ) {
      alert(
        `Please make sure you enter in a proper Zip Code. Length should be of ${parseInt(
          $("#CCZipCode").attr("minlength")
        )} digits.`
      );
      return false;
    }
  }

  if (!zipRegex.test(v_CCZipCode_val)) {
    alert("Please make sure you enter in a proper Zip Code)");
    return false;
  }

  //Validate credit card number
  if (
    v_ccnumber_val == "" ||
    isNaN(v_ccnumber_val) ||
    !LHV10p5_isValid(v_ccnumber_val)
  ) {
    $("input[name=" + v_ccnumber_name + "]").val("");
    $("#" + v_ccnumber_id).val("");
    $("input[name=" + v_cvv_name + "]").val("");
    $("#" + v_cvv_id).val("");
    $(".cardType").css("display", "none");
    alert("Please enter a valid credit card number");
    return false;
  }
  // validate CCV based on CC type
  if (v_ccType_val == 3) {
    if (!cvvRegex4.test(v_cc_ccvid_val)) {
      $("input[name=" + v_ccnumber_name + "]").val("");
      $("#" + v_ccnumber_id).val("");
      $("input[name=" + v_cvv_name + "]").val("");
      $("#" + v_cvv_id).val("");
      $(".cardType").css("display", "none");
      alert("Please make sure you enter in a proper CVV code (4 digits only)");
      return false;
    }
  } else {
    if (!cvvRegex3.test(v_cc_ccvid_val)) {
      $("input[name=" + v_ccnumber_name + "]").val("");
      $("#" + v_ccnumber_id).val("");
      $("input[name=" + v_cvv_name + "]").val("");
      $("#" + v_cvv_id).val("");
      $(".cardType").css("display", "none");
      alert("Please make sure you enter in a proper CVV code (3 digits only)");
      return false;
    }
  }

  //validate payment amount
  if (
    v_paymentamount_val == "" ||
    isNaN(v_paymentamount_val || v_paymentamount_val <= 0)
  ) {
    alert("Please enter a valid payment amount");
    return false;
  } else if (
    !isNaN(v_paymentamount_val) &&
    Number(v_paymentamount_val) < Number(v_MinPayment_val)
  ) {
    alert("A minimum payment of $" + v_MinPayment_val + " must be paid");
    $("#" + v_paymentamount_id).val(v_MinPayment_val);
    return false;
  }

  //validate expiry date
  const v_now_date = new Date(),
    v_now_month = v_now_date.getMonth() + 1,
    v_now_year = v_now_date.getFullYear();

  if (
    parseInt(v_expiryyear_val) == v_now_year &&
    parseInt(v_expirymonth_val) < v_now_month
  ) {
    alert("Please check that the expiration date is not before today's date.");
    return false;
  }

  //Delete html tags in comment fields
  const reg = /([\<])([^\>]{1,})*([\>])/gi;
  const reg2 = /[\<\>]/gi;

  const v_comment = document.pio.comment.value;
  if (reg.test(v_comment)) {
    v_comment = v_comment.replace(reg, "");
  }
  if (reg2.test(v_comment)) {
    v_comment = v_comment.replace(reg2, "");
  }

  document.pio.comment.value = v_comment;

  $("#pio").submit();
}

function changeResorts(elem) {
  document.getElementById("selectResort").style.display = "none";
  const group = document.BookingSearchForm.rstbrand;
  for (let i = 0; i < group.length; i++) {
    if (group[i] != elem) {
      group[i].checked = false;
    }
  }

  let rstSandals = document.getElementById("rstSandals");
  let rstBeaches = document.getElementById("rstBeaches");

  if (elem.value == "S") {
    rstSandals.style.display = "table-row";
  } else {
    rstSandals.style.display = "none";
  }

  if (elem.value == "B") {
    rstBeaches.style.display = "table-row";
  } else {
    rstBeaches.style.display = "none";
  }

  const wereBrandsChecked =
    !document.getElementById("brandSandals").checked &&
    !document.getElementById("brandBeaches").checked &&
    !document.getElementById("brandGP").checked;
  if (wereBrandsChecked) {
    rstSandals.style.display = "none";
    rstBeaches.style.display = "none";

    document.getElementById("selectResort").style.display = "table-row";
  }
}

function hideElem() {
  let rstSandals = document.getElementById("rstSandals");
  let rstBeaches = document.getElementById("rstBeaches");

  if (rstBeaches !== null || rstSandals !== null) {
    rstSandals.style.display = "none";
    rstBeaches.style.display = "none";
  }
}

function validateResort(elem) {
  document.BookingSearchForm.ResortCode.value = elem.value;
}

function changeYear() {
  changeYearMonth(
    "checkin_date_year",
    "checkin_date_month",
    "checkin_date_day"
  );
}
function changeMonth() {
  changeYearMonth(
    "checkin_date_year",
    "checkin_date_month",
    "checkin_date_day"
  );
}
function saveToHiddenInput() {
  $("#CheckinDt").val(
    $("#checkin_date_month").val() +
      "/" +
      $("#checkin_date_day").val() +
      "/" +
      $("#checkin_date_year").val()
  );
}
$(document).ready(function () {
  // Get current date
  let v_from_date = new Date();

  // Add 3 years to current date
  let v_to_date = new Date();
  v_to_date.setFullYear(v_to_date.getFullYear() + 3);

  setYearFromTo(v_from_date, v_to_date);

  $("#checkin_date_year").change(function () {
    changeYearMonth(
      "checkin_date_year",
      "checkin_date_month",
      "checkin_date_day"
    );
  });
  $("#checkin_date_month").change(function () {
    changeYearMonth(
      "checkin_date_year",
      "checkin_date_month",
      "checkin_date_day"
    );
  });

  $("#checkin_date_year").blur(function () {
    saveToHiddenInput();
  });
  $("#checkin_date_month").blur(function () {
    saveToHiddenInput();
  });
  $("#checkin_date_day").blur(function () {
    saveToHiddenInput();
  });

  $("#booking_search_submit_btn").click(function () {
    saveToHiddenInput();
  });
  saveToHiddenInput();
});
