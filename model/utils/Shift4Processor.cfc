component displayname="Shift4Processor" hint="Component in charge of processing CC transaction with Shift4" {

    this.DS_reseng = "reseng";
    this.general_technical_error = "Transaction was not processed due to technical difficulty. Administrator was notified and will fix the problem as soon as possible.";
    this.cc_was_not_approved = "Credit Card Transaction was not approved";

    variables.stop_at_exception = false;
    variables.is_dev_link_now = false;
    variables.cc_option = "";
    variables.is_called_by_tester = false;
    variables.account_info = {
        i4Go_accountId: "",
        i4Go_SiteId: "",
        fuseaction: "",
        productDescriptor: "",
        appid: "",
        app_name: "",
        token_str: "",
        token_url: "",
        processing_url: "",
        cfid: "",
        ccNumberInfo: ""
    };

    function init(p_isOnDev, p_accountid, p_siteid, p_appid, p_desc, p_app_name, p_token_url, p_processing_url, p_cfid) {
        variables.account_info = {
            i4Go_accountId: p_accountid,
            i4Go_SiteId: p_siteid,
            fuseaction: "account.DirectPostCardEntry",
            productDescriptor: p_desc,
            appid: p_appid,
            app_name: p_app_name,
            token_str: "",
            token_url: p_token_url,
            processing_url: p_processing_url,
            cfid: p_cfid,
            ccNumberInfo: p_isOnDev ? "DEV_" : "PRODUCTION_"
        };
        variables.is_dev_link_now = p_isOnDev;
        variables.loginfo = "Dev:#p_isOnDev#,accountId:#p_accountid#,siteid:#p_siteid#,appid:#p_appid#,appname:#p_app_name#";
        return this;
    }

    function currentAccountInfoSettings() {
        return variables.account_info;
    }

    function setCalledByTester(p_var) {
        variables.is_called_by_tester = p_var;
    }

    function currentAccountInfoSettingsInStr() {
        var s_info = "";
        s_info = "i4Go_accountId:'#variables.account_info.i4Go_accountId#',i4Go_SiteId:'#variables.account_info.i4Go_SiteId#',fuseaction:'#variables.account_info.fuseaction#',productDescriptor:'#variables.account_info.productDescriptor#',appid:'#variables.account_info.appid#',app_name:'#variables.account_info.app_name#',token_str:'#variables.account_info.token_str#'";
        s_info &= "|   token_url:'#variables.account_info.token_url#',   processing_url:'#variables.account_info.processing_url#'";
        return s_info;
    }

    function setStopAtException(p_var) {
        variables.stop_at_exception = p_var;
    }

    function isUsingDevLinkNow() {
        return variables.is_dev_link_now;
    }

    function testError() {
        return lookForErrorMessage("102");
    }

    private struct function getCCToken(
        required string p_amount,
        required string p_streetaddress,
        required string p_zipcode,
        required string p_i4go_CardType,
        required string p_i4Go_CardholderName,
        required string p_CardNumber,
        required string p_i4Go_ExpirationMonth,
        required string p_i4Go_ExpirationYear,
        required string p_Cvv2Cod
    ) {
        var rt = structNew();
        var v_status = "SUCCESSFUL";
        var v_loginfo = "";
        rt = structNew();
        v_loginfo = variables.loginfo & ",token_url:" & variables.account_info.token_url & ",  amount:" & arguments.p_amount & ",address:" & arguments.p_streetaddress & ",ZIP:" & arguments.p_zipcode & ",CCtype:" & arguments.p_i4go_CardType & ",Holder:" & arguments.p_i4Go_CardholderName & ",Card:---,expire:" & arguments.p_i4Go_ExpirationMonth & "/" & arguments.p_i4Go_ExpirationYear & ",cvv:--- | ";
        rt = doHttpPostForToken(arguments);
        if (rt.ERROR == 1) {
            v_status = "ERROR";
        } else if (rt.ERROR == 2) {
            v_status = "FAILED";
        }
        if (structKeyExists(rt, "RESULT") && structKeyExists(rt.RESULT, "I4GO_UNIQUEID")) {
            variables.account_info.token_str = rt.RESULT.I4GO_UNIQUEID;
        }
        if (structKeyExists(rt, "RESULT") && structKeyExists(rt.RESULT, "I4GO_RESPONSE")) {
            v_loginfo &= " | ERROR:" & rt.ERROR & ",Mesg:" & rt.ERROR_MESSAGE & ",rs:" & rt.RESULT.I4GO_RESPONSE & ",rs_code:" & rt.RESULT.I4GO_RESPONSECODE & ",token:" & variables.account_info.token_str;
        } else {
            v_loginfo &= " | ERROR:" & rt.ERROR & ",Mesg:" & rt.ERROR_MESSAGE & ",token:" & variables.account_info.token_str;
        }
        v_loginfo &= "  || Internal Error Message : " & rt["internal_error_message"];
        rt["Token_String_shift4"] = variables.account_info.token_str;
        return rt;
    }

    private struct function doHttpPostForToken(required struct p_args) {
        var v_args = arguments.p_args;
        var stResult = getTokenResultDefaultSetting();
        var httpService = "";
        var result = "";
        var fileContent = "";
        stResult.error_message = "Invalid post";
        try {
            httpService = new http(
                method = "POST",
                url = variables.account_info.token_url,
                timeout = 20
            );
            httpService.addParam(type="formfield", name="i4Go_accountId", value=variables.account_info.i4Go_accountId);
            httpService.addParam(type="formfield", name="SiteId", value=variables.account_info.i4Go_SiteId);
            httpService.addParam(type="formfield", name="Fuseaction", value=variables.account_info.fuseaction);
            httpService.addParam(type="formfield", name="ProductDescriptor", value=variables.account_info.productDescriptor);
            httpService.addParam(type="formfield", name="AppID", value=variables.account_info.appid);
            httpService.addParam(type="formfield", name="amount", value=v_args.p_amount);
            httpService.addParam(type="formfield", name="streetaddress", value=v_args.p_streetaddress);
            httpService.addParam(type="formfield", name="zipcode", value=v_args.p_zipcode);
            httpService.addParam(type="formfield", name="i4go_CardType", value=v_args.p_i4go_CardType);
            httpService.addParam(type="formfield", name="i4Go_CardholderName", value=v_args.p_i4Go_CardholderName);
            httpService.addParam(type="formfield", name="CardNumber", value=v_args.p_CardNumber);
            httpService.addParam(type="formfield", name="i4Go_ExpirationMonth", value=v_args.p_i4Go_ExpirationMonth);
            httpService.addParam(type="formfield", name="i4Go_ExpirationYear", value=v_args.p_i4Go_ExpirationYear);
            httpService.addParam(type="formfield", name="Cvv2Cod", value=v_args.p_Cvv2Cod);
            result = httpService.send().getPrefix();
            fileContent = result.fileContent;
            if (!isXML(fileContent)) {
                stResult.error = 1;
                stResult.error_message = this.general_technical_error;
                stResult["internal_error_message"] = "The response from Token '" & variables.account_info.token_url & "' is not in xml format: '" & fileContent & "'";
                if (findNoCase("Connection Failure", fileContent) > 0) {
                    stResult["internal_error_message"] = "The response from Token '" & variables.account_info.token_url & "' (readTokenResponse) shows the connection could not be set up: '" & fileContent & "'";
                }
                logInfoError("error", "method='readTokenResponse' message='" & stResult.internal_error_message & "'");
                stResult.response_code = "7000";
                return stResult;
            }
            stResult = readTokenResponse(fileContent);
        } catch (any e) {
            stResult.error = 1;
            stResult.error_message = this.general_technical_error;
            stResult["internal_error_message"] = "TECHNICAL ERROR (doHttpPostForToken):" & getExceptionMessageInString(e);
            stResult["EXCEPTION"] = e;
            stResult.response_code = "7010";
            if (variables.stop_at_exception) {
                dump(e);
                abort;
            }
            return stResult;
        }
        stResult["internal_error_message"] = "Successful Token call";
        return stResult;
    }

    public struct function readTokenResponse(required string p_http_filecontent) {
        var stResult = getTokenResultDefaultSetting();
        var xmlObject = "";
        var Children = "";
        var bodyChildren = "";
        var formChildren = "";
        var container = "";
        var i = 0;
        var tmperror_mapping = structNew();
        stResult.error_message = "Invalid response returned";
        stResult["internal_error_message"] = "";
        try {
            xmlObject = xmlParse(arguments.p_http_filecontent, "yes");
            Children = xmlObject.xmlRoot.XmlChildren;
            bodyChildren = Children[2].xmlChildren;
            formChildren = bodyChildren[1].xmlChildren;
            container = structNew();
            for (i=1; i<=arrayLen(formChildren); i++) {
                if (formChildren[i].XmlName == "input") {
                    container[formChildren[i].XmlAttributes["name"]] = formChildren[i].XmlAttributes["value"];
                }
            }
            stResult.error = 0;
            stResult.error_message = "";
            stResult.result = duplicate(container);
            if (!structKeyExists(stResult.result, "I4GO_RESPONSECODE") || len(stResult.result["I4GO_RESPONSECODE"]) == 0) {
                stResult.error = 1;
                stResult.error_message = this.general_technical_error;
                stResult["internal_error_message"] = "Can not find I4GO_RESPONSECODE (or the value is blank) from Token (readTokenResponse) : '" & arguments.p_http_filecontent & "'";
                logInfoError("error", "method='readTokenResponse' message='" & stResult.internal_error_message & "'");
                stResult["response_code"] = "7020";
                return stResult;
            }
            stResult["response_code"] = stResult.result["I4GO_RESPONSECODE"];
            if (stResult.result["I4GO_RESPONSECODE"] != "1") {
                stResult.error = 2;
                tmperror_mapping = lookForErrorMessage(stResult.result["I4GO_RESPONSECODE"]);
                stResult.error_message = trim(tmperror_mapping.error_mesg_guest);
                if (len(stResult.error_message) == 0) stResult.error_message = "Credit Card Validation Failed";
                stResult["internal_error_message"] = "Transaction failed,  I4GO_RESPONSECODE:'" & stResult.result.I4GO_RESPONSECODE & "',hold_obe_booking:'" & tmperror_mapping.hold_OBE_booking & "', Error message mapped out:'" & tmperror_mapping.error_mesg_internal & "'";
                stResult["hold_obe_booking"] = tmperror_mapping.hold_OBE_booking;
                return stResult;
            }
        } catch (any e) {
            if (variables.is_called_by_tester) dump(e);
            stResult.error = 1;
            stResult.error_message = this.general_technical_error;
            stResult["internal_error_message"] = " ERROR with reading the token response (readTokenResponse):" & getExceptionMessageInString(e) & "!!!";
            stResult["EXCEPTION"] = e;
            stResult["response_code"] = "7040";
            logInfoError("error", "method='readTokenResponse' message='" & e.message & "--" & getExceptionMessageInString(e) & "'");
            if (variables.stop_at_exception) {
                dump(e);
                abort;
            }
            return stResult;
        }
        return stResult;
    }

    private struct function getTokenResultDefaultSetting() {
        var stResult = structNew();
        stResult.error = 1;
        stResult.error_message = "";
        stResult.Token_String_shift4 = "";
        stResult.EXCEPTION = "";
        stResult.hold_obe_booking = false;
        stResult.response_code = "";
        stResult.result = structNew();
        return stResult;
    }

    private struct function getFianlResultDefaultSetting() {
        var stResult = structNew();
        stResult.error = 1;
        stResult.error_message = "";
        stResult.Token_String_shift4 = "";
        stResult.EXCEPTION = "";
        stResult.auth = "";
        stResult.invoice = "";
        stResult.transactionid = "";
        stResult.internal_error_message = "";
        stResult.hold_obe_booking = false;
        stResult.response_code = "";
        return stResult;
    }

    private struct function getCCResultDefaultSetting() {
        var stResult = structNew();
        stResult.error = 1;
        stResult.error_message = "";
        stResult.internal_error_message = "";
        stResult.response_str = "";
        stResult.EXCEPTION = "";
        stResult.auth = "";
        stResult.invoice = "";
        stResult.transactionid = "";
        stResult.hold_obe_booking = false;
        stResult.response_code = "";
        stResult.result = structNew();
        return stResult;
    }

    private struct function lookForErrorMessage(required string p_codes) {
        var v_codes = trim(arguments.p_codes);
        var v_first_error_code = "";
        var v_result = structNew();
        var v_qrymesg = "";
        var qryResult = "";
        v_result.error_mesg_internal = "";
        v_result.error_mesg_guest = "";
        v_result.hold_OBE_booking = false;
        v_first_error_code = len(v_codes) ? listFirst(v_codes) : "BLANK";
        v_qrymesg = getMesgMappingQry();
        qryResult = queryExecute(
            "SELECT * FROM v_qrymesg WHERE ERROR_CODE = ?",
            [ { value: v_first_error_code, cfsqltype: "cf_sql_varchar" } ],
            { dbtype: "query" }
        );
        if (qryResult.recordCount > 0) {
            v_result.error_mesg_internal = qryResult.ERROR_MESSAGE;
            v_result.error_mesg_guest = qryResult.CLIENT_MESSAGE;
            if (qryResult.HOLD_BOOKING_YN == "Y") {
                v_result.hold_OBE_booking = true;
            }
        }
        return v_result;
    }

    public query function getMesgMappingQry() {
        var qrySwitches = "";
        if (!isDefined("application.cc_operations.qry_MesgMapping") || !isQuery(application.cc_operations.qry_MesgMapping)) {
            application.cc_operations.qry_MesgMapping = queryNew("");
        }
        if (application.cc_operations.qry_MesgMapping.recordCount == 0) {
            application.cc_operations.qry_MesgMapping = getMesgMappingQryFromOracle();
        }
        return application.cc_operations.qry_MesgMapping;
    }

    public query function getMesgMappingQryFromOracle() {
        var qry = queryNew("");
        try {
            qry = queryExecute(
                "SELECT * FROM shift4_error_messages_mv WHERE ERROR_SOURCE IN ('i4Go','UTG') ORDER BY ERROR_CODE ASC",
                [],
                { datasource: this.DS_reseng }
            );
        } catch (any e) {
            logInfoError("email", "method='getMesgMappingQryFromOracle' message='Could not read error message mapping info from " & this.DS_reseng & " (table shift4_error_messages_mv), error:" & e.message & ",details:" & getExceptionMessageInString(e) & "'");
            dump(e, "error from Shift4Processor.getMesgMappingQryFromOracle");
            if (variables.stop_at_exception) {
                dump(e);
                abort;
            }
        }
        return qry;
    }

    public boolean function isCCShift4(string p_app_name="") {
        var v_current_appname = "";
        v_current_appname = arguments.p_app_name.len() ? arguments.p_app_name : variables.account_info.app_name;
        variables.cc_option = trim(getCCSwitchOptions(v_current_appname));
        return variables.cc_option == "SHIFT4";
    }

    private string function getCCSwitchOptions(required string p_app_name) {
        var v_option = "SHIFT4";
        var qrySwitches = "";
        var qryResult = "";
        if (!isDefined("application.cc_operations.qry_CCSwitchOptions") || !isQuery(application.cc_operations.qry_CCSwitchOptions)) {
            application.cc_operations.qry_CCSwitchOptions = queryNew("");
        }
        if (application.cc_operations.qry_CCSwitchOptions.recordCount == 0) {
            application.cc_operations.qry_CCSwitchOptions = getCCSwitchOptionsQry();
        }
        qrySwitches = application.cc_operations.qry_CCSwitchOptions;
        if (qrySwitches.recordCount > 0) {
            qryResult = queryExecute(
                "SELECT sw_option FROM qrySwitches WHERE name = ?",
                [ { value: arguments.p_app_name, cfsqltype: "cf_sql_varchar" } ],
                { dbtype: "query" }
            );
            if (qryResult.recordCount > 0) {
                v_option = qryResult.sw_option;
            }
        }
        return v_option;
    }

    private void function logInfoError(required string p_type, required string p_text) {
        if (arguments.p_type == "email") {
            mail from="info@sandals.com" to="echou@sanservices.hn" type="html" subject="Shift4 notification: Application '#variables.account_info.app_name#'" {
                writeOutput(arguments.p_text);
            }
            return;
        }
        writeLog(type=arguments.p_type, file="Shift4_Err_Warning", text=arguments.p_text);
    }

    public void function dump(required any p_var, string p_label="") {
        if (len(arguments.p_label) == 0) {
            writeDump(var=arguments.p_var);
        } else {
            writeDump(var=arguments.p_var, label=arguments.p_label);
        }
    }

    public void function abort() {
        abort;
    }

    private void function throwex(required string message, string detail="") {
        throw(type="framework", message=arguments.message, detail=arguments.detail);
    }

    private string function getExceptionMessageInString(required any p_ex) {
        var str = "";
        var str_stackTrace = "";
        var st = structNew();
        var v_ex = arguments.p_ex;
        if (structKeyExists(v_ex, "Message")) {
            str &= "ErrorMessage='" & v_ex.Message & "' ";
        }
        if (structKeyExists(v_ex, "StackTrace")) {
            str_stackTrace = left(v_ex.StackTrace, 300);
            str &= "statck='" & str_stackTrace & "' ";
        }
        if (structKeyExists(v_ex, "TagContext") && isArray(v_ex.TagContext) && arrayLen(v_ex.TagContext) > 0) {
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
        return str;
    }

}
