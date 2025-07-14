/*******************************************************************************
 MaskedPassword.js       Converts password fields into "masked" password fields
 ------------------------------------------------------------------------------
 Adapted from                                      FormTools.addPasswordMasking
 Info/Docs         http://www.brothercake.com/site/resources/scripts/formtools/
 ------------------------------------------------------------------------------
*******************************************************************************/

//masked password constructor
function MaskedPassword(passfield, symbol) {
  if (
    typeof document.getElementById == "undefined" ||
    typeof document.styleSheets == "undefined"
  ) {
    return false;
  }

  if (passfield === null) {
    return false;
  }

  this.symbol = symbol;

  this.isIE = window.attachEvent && !window.addEventListener ? true : false;

  passfield.value = "";
  passfield.defaultValue = "";

  passfield._contextwrapper = this.createContextWrapper(passfield);

  this.fullmask = false;

  var wrapper = passfield._contextwrapper;

  var hiddenfield = '<input type="hidden" name="' + passfield.name + '">';

  var textfield = this.convertPasswordFieldHTML(passfield);

  wrapper.innerHTML = hiddenfield + textfield;

  passfield = wrapper.lastChild;
  passfield.className += " masked";
  passfield.setAttribute("autocomplete", "off");
  passfield._realfield = wrapper.firstChild;

  passfield._contextwrapper = wrapper;

  this.limitCaretPosition(passfield);

  //save a reference to this
  var self = this;

  //then apply the core events to the visible field
  this.addListener(passfield, "change", function (e) {
    self.fullmask = false;
    self.doPasswordMasking(self.getTarget(e));
  });
  this.addListener(passfield, "input", function (e) {
    self.fullmask = false;
    self.doPasswordMasking(self.getTarget(e));
  });
  //no fullmask setting for onpropertychange (as noted above)
  this.addListener(passfield, "propertychange", function (e) {
    self.doPasswordMasking(self.getTarget(e));
  });

  this.addListener(passfield, "keyup", function (e) {
    if (!/^(9|1[678]|224|3[789]|40)$/.test(e.keyCode.toString())) {
      self.fullmask = false;
      self.doPasswordMasking(self.getTarget(e));
    }
  });

  this.addListener(passfield, "blur", function (e) {
    self.fullmask = true;
    self.doPasswordMasking(self.getTarget(e));
  });

  this.forceFormReset(passfield);

  //return true for success
  return true;
}

//associated utility methods
MaskedPassword.prototype = {
  //implement password masking for a textbox event
  doPasswordMasking: function (textbox) {
    //create the plain password string
    var plainpassword = "";

    if (textbox._realfield.value != "") {
      for (var i = 0; i < textbox.value.length; i++) {
        if (textbox.value.charAt(i) == this.symbol) {
          plainpassword += textbox._realfield.value.charAt(i);
        } else {
          plainpassword += textbox.value.charAt(i);
        }
      }
    } else {
      plainpassword = textbox.value;
    }

    var maskedstring = this.encodeMaskedPassword(
      plainpassword,
      this.fullmask,
      textbox
    );

    if (
      textbox._realfield.value != plainpassword ||
      textbox.value != maskedstring
    ) {
      //copy the plain password to the real field
      textbox._realfield.value = plainpassword;

      //then write the masked value to the original textbox
      textbox.value = maskedstring;
    }
  },

  encodeMaskedPassword: function (passwordstring, fullmask, textbox) {
    var characterlimit = fullmask === true ? 0 : 1;

    for (var maskedstring = "", i = 0; i < passwordstring.length; i++) {
      if (i < passwordstring.length - characterlimit) {
        maskedstring += this.symbol;
      }
      //otherwise just copy across the real character
      else {
        maskedstring += passwordstring.charAt(i);
      }
    }

    //return the final masked string
    return maskedstring;
  },

  createContextWrapper: function (passfield) {
    var wrapper = document.createElement("span");

    wrapper.style.position = "relative";
    passfield.parentNode.insertBefore(wrapper, passfield);
    wrapper.appendChild(passfield);

    //return the wrapper reference
    return wrapper;
  },

  forceFormReset: function (textbox) {
    while (textbox) {
      if (/form/i.test(textbox.nodeName)) {
        break;
      }
      textbox = textbox.parentNode;
    }

    if (!/form/i.test(textbox.nodeName)) {
      return null;
    }

    this.addSpecialLoadListener(function () {
      textbox.reset();
    });

    //return the now-form reference
    return textbox;
  },

  convertPasswordFieldHTML: function (passfield, addedattrs) {
    //start the HTML for a text field
    var textfield = "<input";

    for (
      var fieldattributes = passfield.attributes, j = 0;
      j < fieldattributes.length;
      j++
    ) {
      if (
        fieldattributes[j].specified &&
        !/^(_|type|name)/.test(fieldattributes[j].name)
      ) {
        textfield +=
          " " + fieldattributes[j].name + '="' + fieldattributes[j].value + '"';
      }
    }

    textfield += ' type="text" autocomplete="off">';

    //return the finished textfield HTML
    return textfield;
  },

  limitCaretPosition: function (textbox) {
    //create a null timer reference and start function
    var timer = null,
      start = function () {
        //prevent multiple instances
        if (timer == null) {
          //IE uses this range stuff
          if (this.isIE) {
            timer = window.setInterval(function () {
              var range = textbox.createTextRange(),
                valuelength = textbox.value.length,
                character = "character";
              range.moveEnd(character, valuelength);
              range.moveStart(character, valuelength);
              range.select();
            }, 100);
          } else {
            timer = window.setInterval(function () {
              var valuelength = textbox.value.length;
              if (
                !(
                  textbox.selectionEnd == valuelength &&
                  textbox.selectionStart <= valuelength
                )
              ) {
                textbox.selectionStart = valuelength;
                textbox.selectionEnd = valuelength;
              }

              //ditto
            }, 100);
          }
        }
      },
      //and a stop function
      stop = function () {
        window.clearInterval(timer);
        timer = null;
      };

    //add events to start and stop the timer
    this.addListener(textbox, "focus", function () {
      start();
    });
    this.addListener(textbox, "blur", function () {
      stop();
    });
  },

  addListener: function (eventnode, eventname, eventhandler) {
    if (typeof document.addEventListener != "undefined") {
      return eventnode.addEventListener(eventname, eventhandler, false);
    } else if (typeof document.attachEvent != "undefined") {
      return eventnode.attachEvent("on" + eventname, eventhandler);
    }
  },

  addSpecialLoadListener: function (eventhandler) {
    if (this.isIE) {
      return window.attachEvent("onload", eventhandler);
    } else {
      return document.addEventListener("DOMContentLoaded", eventhandler, false);
    }
  },

  getTarget: function (e) {
    //just in case!
    if (!e) {
      return null;
    }

    //otherwise return the target
    return e.target ? e.target : e.srcElement;
  },
};
