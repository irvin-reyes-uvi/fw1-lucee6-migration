component
    displayname="Shift4Factory"
    hint="Provides instance of Shift4Processor due to different application"
    accessors="true"
{

    variables.stop_at_exception = false;
    variables.qry_shift4_settings = queryNew('');
    variables.qry_shift4_ccards = queryNew('');
    variables.current_appname = '';
    variables.cfid = '';

    function init(p_cfid) {
        variables.cfid = p_cfid;
        return this;
    }

    function init() {
        return this;
    }

    public query function getCCTypes() {
        if (!isDefined('application.cc_operations.qry_CCTypes') || !isQuery(application.cc_operations.qry_CCTypes)) {
            application.cc_operations.qry_CCTypes = queryNew('');
        }
        if (application.cc_operations.qry_CCTypes.recordCount == 0) {
            // Async query execution
            var futureQry = runAsync(function() {
                return getCCTypesFromMysqlDB();
            });
            application.cc_operations.qry_CCTypes = futureQry.get();
        }
        return application.cc_operations.qry_CCTypes;
    }

    public string function getCCCodeById(required numeric p_typeid, required query p_qryCCtypes) {
        var qry = queryExecute(
            'SELECT cc_code FROM p_qryCCtypes WHERE cctype_id = ?',
            [{value: arguments.p_typeid, cfsqltype: 'cf_sql_numeric'}],
            {dbtype: 'query'}
        );
        if (qry.recordCount > 0) {
            return qry.cc_code;
        }
        return 'VS';
    }

    public string function getCCCode4DBById(required numeric p_typeid, required query p_qryCCtypes) {
        var qry = queryExecute(
            'SELECT cc_code_4DB FROM p_qryCCtypes WHERE cctype_id = ?',
            [{value: arguments.p_typeid, cfsqltype: 'cf_sql_numeric'}],
            {dbtype: 'query'}
        );
        if (qry.recordCount > 0) {
            return qry.cc_code_4DB;
        }
        return 'VI/MC';
    }

    private query function getShift4SettingsFromMysqlDB() {
        var app_name_Values = [
            'OP',
            'OBE',
            'OBETA',
            'OEE',
            'VAX',
            'OTHER',
            'IVR',
            'OBELATAM',
            'OBETALATAM',
            'MOBE'
        ];
        var app_type_Values = ['PRODUCTION', 'DEV'];
        var account_id_Values = ['1905', '254'];
        var site_id_Values = [
            '00000923',
            '00000925',
            '00000926',
            '00000922',
            '00000924',
            '00000926',
            '00001058',
            '00001087',
            '00001088',
            '00000280',
            '00000292',
            '00000282',
            '00000278',
            '00000279',
            '00000282',
            '00000299',
            '00000300',
            '00000301',
            '00000302',
            '00001553'
        ];
        var app_id_Values = [
            '71',
            '81',
            '101',
            '61',
            '91',
            '101',
            '141',
            '151',
            '161',
            '34',
            '35',
            '37',
            '36',
            '38',
            '37',
            '42',
            '43',
            '44',
            '45',
            '171'
        ];
        var description_Values = [
            'Online Payment transaction',
            'OBE transaction',
            'OBETA transaction',
            'OEE transaction',
            'VAX transaction',
            'OTHER: useOBETA transaction',
            'Intractive Voice Response',
            'OBE Latam transaction',
            'OBETA Latam transaction',
            'MOBE transaction'
        ];
        var token_str_Values = ['https://secure.i4go.com/index.cfm', 'https://i4go.shift4test.com/index.cfm'];
        var processing_url_Values = [
            'http://ccsystem.sandals.net/processing/CCProcessingService.cfc?WSDL',
            'http://stagingccsystem.sandals.net/processing/CCProcessingService.cfc?WSDL'
        ];

        NUM_ROWS = 20;
        APP_NAME_COUNT = 10;
        GROUP_SPLIT = 9;
        EXTRA_ID_OFFSET = 10;
        LAST_ROW_INDEX = NUM_ROWS;
        LAST_APP_NAME_IDX = APP_NAME_COUNT;
        FIRST_GROUP_IDX = 1;
        SECOND_GROUP_IDX = 2;

        positions = [];
        for (var i = 1; i <= NUM_ROWS; i++) {
            arrayAppend(positions, i);
        }

        settingsArray = positions.map((queryPos) => {
            isFirstGroup = queryPos <= GROUP_SPLIT + 1;
            isLastRow = queryPos == LAST_ROW_INDEX;
            temp_setting_id = isFirstGroup ? queryPos : queryPos + EXTRA_ID_OFFSET;

            temp_pos_1 = isFirstGroup
             ? queryPos
             : (isLastRow ? LAST_APP_NAME_IDX : queryPos - GROUP_SPLIT);

            temp_pos_2 = (isFirstGroup || isLastRow) ? FIRST_GROUP_IDX : SECOND_GROUP_IDX;

            return {
                setting_id: temp_setting_id,
                app_name: app_name_Values[temp_pos_1],
                app_type: app_type_Values[temp_pos_2],
                account_id: account_id_Values[temp_pos_2],
                site_id: site_id_Values[queryPos],
                app_id: app_id_Values[queryPos],
                description: description_Values[temp_pos_1],
                token_str: token_str_Values[temp_pos_2],
                processing_url: processing_url_Values[temp_pos_2]
            };
        });

        result = queryNew(
            'setting_id,app_name,app_type,account_id,site_id,app_id,description,token_str,processing_url',
            'Integer,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar,VarChar'
        );
        queryAddRow(result, NUM_ROWS);

        settingsArray.each((setting, idx) => {
            var rowNum = idx;
            querySetCell(
                result,
                'setting_id',
                setting.setting_id,
                rowNum
            );
            querySetCell(
                result,
                'app_name',
                setting.app_name,
                rowNum
            );
            querySetCell(
                result,
                'app_type',
                setting.app_type,
                rowNum
            );
            querySetCell(
                result,
                'account_id',
                setting.account_id,
                rowNum
            );
            querySetCell(
                result,
                'site_id',
                setting.site_id,
                rowNum
            );
            querySetCell(
                result,
                'app_id',
                setting.app_id,
                rowNum
            );
            querySetCell(
                result,
                'description',
                setting.description,
                rowNum
            );
            querySetCell(
                result,
                'token_str',
                setting.token_str,
                rowNum
            );
            querySetCell(
                result,
                'processing_url',
                setting.processing_url,
                rowNum
            );
        });
        return result;
    }

    private query function getCCTypesFromMysqlDB() {
        var result = queryNew(
            'cctype_id,card_type_id,Type,card_type,NumLength,CvvLength,FirstDigit,Comments,cc_code,cc_code_4DB,cc_vax_code',
            'Integer,Integer,VarChar,VarChar,Integer,Integer,Integer,VarChar,VarChar,VarChar,VarChar'
        );
        queryAddRow(result, 4);

        querySetCell(result, 'cctype_id', 1, 1);
        querySetCell(result, 'card_type_id', 1, 1);
        querySetCell(result, 'Type', 'MASTERCARD', 1);
        querySetCell(result, 'card_type', 'MASTERCARD', 1);
        querySetCell(result, 'NumLength', 16, 1);
        querySetCell(result, 'CvvLength', 3, 1);
        querySetCell(result, 'FirstDigit', 5, 1);
        querySetCell(
            result,
            'Comments',
            '1 800-633-7367',
            1
        );
        querySetCell(result, 'cc_code', 'MC', 1);
        querySetCell(result, 'cc_code_4DB', 'MC', 1);
        querySetCell(result, 'cc_vax_code', 'CC MC', 1);

        querySetCell(result, 'cctype_id', 2, 2);
        querySetCell(result, 'card_type_id', 2, 2);
        querySetCell(result, 'Type', 'VISA', 2);
        querySetCell(result, 'card_type', 'VISA', 2);
        querySetCell(result, 'NumLength', 16, 2);
        querySetCell(result, 'CvvLength', 3, 2);
        querySetCell(result, 'FirstDigit', 4, 2);
        querySetCell(
            result,
            'Comments',
            '1 800-945-2000',
            2
        );
        querySetCell(result, 'cc_code', 'VS', 2);
        querySetCell(result, 'cc_code_4DB', 'VS', 2);
        querySetCell(result, 'cc_vax_code', 'CC VI', 2);

        querySetCell(result, 'cctype_id', 3, 3);
        querySetCell(result, 'card_type_id', 3, 3);
        querySetCell(result, 'Type', 'AMERICAN EXPRESS', 3);
        querySetCell(
            result,
            'card_type',
            'AMERICAN EXPRESS',
            3
        );
        querySetCell(result, 'NumLength', 15, 3);
        querySetCell(result, 'CvvLength', 4, 3);
        querySetCell(result, 'FirstDigit', 3, 3);
        querySetCell(
            result,
            'Comments',
            '1 800-639-1202',
            3
        );
        querySetCell(result, 'cc_code', 'AX', 3);
        querySetCell(result, 'cc_code_4DB', 'AX', 3);
        querySetCell(result, 'cc_vax_code', 'CC AX', 3);

        querySetCell(result, 'cctype_id', 4, 4);
        querySetCell(result, 'card_type_id', 4, 4);
        querySetCell(result, 'Type', 'DISCOVER', 4);
        querySetCell(result, 'card_type', 'DISCOVER', 4);
        querySetCell(result, 'NumLength', 16, 4);
        querySetCell(result, 'CvvLength', 3, 4);
        querySetCell(result, 'FirstDigit', 6, 4);
        querySetCell(
            result,
            'Comments',
            '1 800-347-2683',
            4
        );
        querySetCell(result, 'cc_code', 'NS', 4);
        querySetCell(result, 'cc_code_4DB', 'NS', 4);
        querySetCell(result, 'cc_vax_code', 'CC DI', 4);

        return result;
    }


    private string function serializeObject4Log(required any obj) {
        var res = '';
        res = replace(
            serializeJSON(arguments.obj, true),
            'null',
            '""',
            'all'
        );
        res = replace(res, ':[', ':''[', 'all');
        res = reReplace(res, '\\](,|})', ']''\\1', 'all');
        res = reReplace(
            res,
            '"([^"]*)":"*([^"\\[]*)"*(,|})',
            '\\1=''\\2''\\3',
            'all'
        );
        res = replace(res, '{"', '{', 'all');
        res = replace(res, '":', '=', 'all');
        res = reReplace(res, '([^"]),"', '\\1,', 'all');
        res = replace(res, '"', '''', 'all');
        return res;
    }

    private void function logInfoError(required string p_type, required string p_logtype, required string p_text) {
        var v_text_string = right(arguments.p_text, 2995);
        if (arguments.p_type == 'email') {
            mail
                from="info@sandals.com"
                to="irvin.reyes@sanservices.hn"
                type="html"
                subject="Shift4 notification: Application '#variables.current_appname#'" {
                writeOutput(arguments.p_text);
            }
            return;
        }
        writeLog(type = 'Warning', file = 'Shift4_Err_Warning', text = v_text_string);
    }

}
