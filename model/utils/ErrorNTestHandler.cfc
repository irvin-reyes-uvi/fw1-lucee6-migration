component extends="Base" accessors="true" {

    // Initialization block
    function init() {
        variables.stepinfo = {};
        variables.stepinfo.step = this.UN_SET;
        variables.stepinfo.is_havingerror = false;
        variables.stepinfo.main_message2guest = '';
        variables.stepinfo.extra_message2guest = '';
        variables.stepinfo.using_testing_cc = false;
        return this;
    }

    // Optionally call init() automatically on instantiation
    init();

    function initurl(urlStruct) {
        if (structKeyExists(urlStruct, "ectesting")) {
            if (urlStruct.ectesting == "1") {
                client.is_ec_testing = true;
            } else {
                structDelete(client, "is_ec_testing");
            }
        }
        return this;
    }

    function isUsingTestCC() {
        return variables.stepinfo.using_testing_cc;
    }

    function isCCATestingOne(p_cc) {
        variables.stepinfo.using_testing_cc = false;
        if (
            p_cc == "5431212121212020" ||
            p_cc == "5431212121212025" ||
            p_cc == "5431212121212012" ||
            p_cc == "4520840008174544"
        ) {
            variables.stepinfo.using_testing_cc = true;
        }
        return variables.stepinfo.using_testing_cc;
    }

    function recoverFromClientVar() {
        var st = getInfoFromClient();
        if (!structIsEmpty(st)) {
            variables.stepinfo = duplicate(st);
        }
        return this;
    }

    function isOnDev() {
        return (findNoCase("onlinepayment.sandals.com.ec", cgi.HTTP_HOST) > 0);
    }

    public void function reportError(
        required any p_ex,
        required numeric p_current_step,
        string p_extra_info = ""
    ) {
        var inetOBJ = createObject("java", "java.net.InetAddress");
        var LocalHostName = "";
        var v_ex = arguments.p_ex;
        inetOBJ = inetOBJ.getLocalHost();
        LocalHostName = inetOBJ.getHostName();

        if (isDoingTestNow()) {
            writeDump(arguments);
            abort;
        }

        var str = getExceptionMessageInString(v_ex);

        if (len(str) > 0) {
            writeLog(
                type = "error",
                file = "OnlinePaymentErr",
                text = "Error='" & str & "'  step='" & arguments.p_current_step & "' extra_info='" & arguments.p_extra_info & "'"
            );
        } else {
            writeLog(
                type = "error",
                file = "OnlinePaymentErr",
                text = "Error='N/A'  step='" & arguments.p_current_step & "' extra_info='" & arguments.p_extra_info & "'"
            );
        }

        variables.stepinfo.step = arguments.p_current_step;
        variables.stepinfo.is_havingerror = true;

        if (arguments.p_current_step == this.GETTING_INVOICE) {
            variables.stepinfo.main_message2guest = "Your order was NOT placed and your credit card was NOT charged yet. ";
        } else if (arguments.p_current_step == this.CHARGING_CC) {
            variables.stepinfo.main_message2guest = "Your order was NOT placed and your credit card may HAVE BEEN charged already.";
        } else if (arguments.p_current_step == this.READING_CC_CHARGEINFO) {
            variables.stepinfo.main_message2guest = "Your order was NOT placed and your credit card may HAVE BEEN charged already.";
            variables.stepinfo.extra_message2guest = "";
        } else if (arguments.p_current_step == this.INSERTING_DB_RECORDS) {
            variables.stepinfo.main_message2guest = "Your order may HAVE BEEN placed and your credit card may HAVE BEEN charged already.";
            variables.stepinfo.extra_message2guest = "";
        } else if (arguments.p_current_step == this.SENDING_EMAIL) {
            variables.stepinfo.main_message2guest = "Your order may HAVE BEEN placed and your credit card may HAVE BEEN charged already.";
            variables.stepinfo.extra_message2guest = "";
        }

        saveInfo2Client(p_stInfo = variables.stepinfo);
        location(url = "error.cfm", addtoken = false);
    }

    private string function getExceptionMessageInString(required any p_ex) {
        var str = "";
        var st = {};
        var v_ex = arguments.p_ex;

        if (structKeyExists(v_ex, "Message")) {
            str &= "ErrorMessage='" & v_ex.Message & "' ";
        }
        if (structKeyExists(v_ex, "TagContext")) {
            if (isArray(v_ex.TagContext) && arrayLen(v_ex.TagContext) > 0) {
                st = v_ex.TagContext[1];
                if (structKeyExists(st, "TEMPLATE")) {
                    str &= "Template='" & st.TEMPLATE & "' ";
                }
                if (structKeyExists(st, "RAW_TRACE")) {
                    str &= "RawTrace='" & st.RAW_TRACE & "' ";
                }
                if (structKeyExists(st, "LINE")) {
                    str &= "Line='" & st.LINE & "' ";
                }
            }
        }
        return str;
    }

    public boolean function isDoingTestNow() {
        if (structKeyExists(client, "is_ec_testing")) {
            return client.is_ec_testing;
        }
        return false;
    }

}
