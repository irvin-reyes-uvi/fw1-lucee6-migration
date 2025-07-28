component extends="model.utils.bugtrack" accessors="true" {

    property name="init_ok" type="boolean";
    property name="ObeWSObj" type="any";
    property name="qCountries" type="query";
    property name="qStates" type="query";
    property name="qGateways" type="query";
    property name="qUS_CANADA_Gateways" type="query";
    property name="qResortGateways" type="query";
    property name="qRoomCategories" type="query";
    property name="sandalsDB" type="string";

    public function init() {
        fncOBJInit();
        return this;
    }

    private function fncOBJInit() {
        this.init_ok = false;
        var rtnStruct = {};

        try {
            var rtnSetup = fncGetObeSetup().results;
            this.ObeWSObj = createObject('webservice', rtnSetup.web_service);

            rtnStruct = fncGetCountries();
            if (rtnStruct.error) {
                throw(message = 'Error Initializing countries.', detail = rtnStruct.errorMessage);
            }
            this.qCountries = rtnStruct.results;

            rtnStruct = fncGetStates();
            if (rtnStruct.error) {
                throw(message = 'Error Initializing States.', detail = rtnStruct.errorMessage);
            }
            this.qStates = rtnStruct.results;

            rtnStruct = fncGetDepartureGateways();
            if (rtnStruct.error) {
                throw(message = 'Error Initializing Departure Gateways.', detail = rtnStruct.errorMessage);
            }
            this.qGateways = rtnStruct.results;

            rtnStruct = fncGetDepartureGateways('', '', true);
            if (rtnStruct.error) {
                throw(message = 'Error Initializing US Canada Gateways.', detail = rtnStruct.errorMessage);
            }
            this.qUS_CANADA_Gateways = rtnStruct.results;

            rtnStruct = fncGetResortGateways('', true);
            if (rtnStruct.error) {
                throw(message = 'Error Initializing Resort Gateways.', detail = rtnStruct.errorMessage);
            }
            this.qResortGateways = rtnStruct.results;

            rtnStruct = fncGetRoomCategoryInfo('', '', true);
            if (rtnStruct.error) {
                throw(message = 'Error Initializing Room Categories.', detail = rtnStruct.errorMessage);
            }
            this.qRoomCategories = rtnStruct.results;

            this.ResortsObj = createObject('Component', 'model.services.ResortQueryService');

            this.init_ok = true;
        } catch (any e) {
            this.init_ok = false;
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncOBJInit: #rtnStruct.errorMessage#', e);
        }
    }

    public struct function fncGetCountries() {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };
        var queryResult;

        try {
            cfstoredproc(datasource = this.sandalsDB, procedure = "obe_pack.get_countries_usa_ca") {
                cfprocresult(name = "queryResult", resultset = 1);
            }
            rtnStruct.results = queryResult;

            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetCountries: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

    public struct function fncGetStates(string country_code = '') {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };
        var queryResult;

        try {
            if (arguments.country_code eq '') {
                cfstoredproc(datasource = this.sandalsDB, procedure = "obe_pack.get_states") {
                    cfprocresult(name = "queryResult", resultset = 1);
                }
                rtnStruct.results = queryResult;
            } else {
                rtnStruct.results = queryExecute(
                    'select * from this.qStates where country_code = :countryCode order by state',
                    {countryCode: {value: arguments.country_code, cfsqltype: 'cf_sql_varchar'}},
                    {dbtype: 'query'}
                );
            }

            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetStates: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

    public struct function fncGetDepartureGateways(string country = '', string state = '', boolean AllGateways = false) {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };

        try {
            if (arguments.country neq '' && arguments.state neq '') {
                rtnStruct.errorMessage = 'Country and State are mutually exclusive.';
                rtnStruct = logWarning('fncGetDepartureGateways: #rtnStruct.errorMessage#');
                return rtnStruct;
            }

            if (arguments.AllGateways) {
                rtnStruct.results = queryExecute(
                    'select gateway, city, state, country FROM this.qGateways where country in (''USA'',''CANADA'') order by state,city asc',
                    {},
                    {dbtype: 'query'}
                );
            }

            else if (arguments.country neq '') {
                rtnStruct.results = queryExecute(
                    'SELECT distinct state FROM this.qGateways where country = :countryCode ORDER BY STATE asc',
                    {countryCode: {value: trim(uCase(arguments.country)), cfsqltype: 'cf_sql_varchar'}},
                    {dbtype: 'query'}
                );
            }

            else if (arguments.state neq '') {
                rtnStruct.results = queryExecute(
                    'select gateway, city, state, country FROM this.qGateways where state = :stateCode order by city asc',
                    {stateCode: {value: trim(uCase(arguments.state)), cfsqltype: 'cf_sql_varchar'}},
                    {dbtype: 'query'}
                );
            }
            // Note: Original logic had multiple independent IF statements, potentially overwriting rtnStruct.results.
            // This conversion preserves that behavior.

            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetDepartureGateways: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

    public struct function fncGetResortGateways(required string resort_code, boolean populateAppVariable = false) {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };
        var ResortGateways;

        try {
            if (arguments.populateAppVariable) {
                ResortGateways = queryExecute(
                    'select * from resorts_gateways order by resort_code',
                    {},
                    {datasource: this.sandalsDB}
                );

                rtnStruct.error = 0;
                rtnStruct.warnings = 0;
                rtnStruct.results = ResortGateways;
            } else {
                rtnStruct.results = queryExecute(
                    'SELECT * FROM this.qResortGateways WHERE RESORT_CODE = :resortCode ORDER BY gateway',
                    {resortCode: {value: trim(uCase(arguments.resort_code)), cfsqltype: 'cf_sql_varchar'}},
                    {dbtype: 'query'}
                );

                rtnStruct.error = 0;
                rtnStruct.warnings = 0;
            }
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetResortGateways: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

    public struct function fncGetObeSetup() {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };
        var queryResult;

        try {
            cfstoredproc(datasource = this.sandalsDB, procedure = "obe_pack.get_obe_setup") {
                cfprocresult(name = "queryResult", resultset = 1);
            }
            rtnStruct.results = queryResult;

            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetObeSetup: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

    public struct function fncGetRoomCategoryInfo(
        required string resort_code,
        required string category_code,
        boolean PutInMemory = false
    ) {
        var rtnStruct = {
            error: 1,
            errorMessage: '',
            results: queryNew(''),
            warnings: 1,
            warningsMessage: ''
        };
        var queryResult;

        try {
            if (arguments.PutInMemory) {
                cfstoredproc(datasource = this.sandalsDB, procedure = "obe_pack.get_room_categories") {
                    cfprocresult(name = "queryResult", resultset = 1);
                }
                rtnStruct.results = queryResult;
            } else {
                rtnStruct.results = queryExecute(
                    'SELECT * FROM this.qRoomCategories WHERE rst_code = :resortCode AND category_code = :categoryCode',
                    {
                        resortCode: {value: arguments.resort_code, cfsqltype: 'cf_sql_varchar'},
                        categoryCode: {value: arguments.category_code, cfsqltype: 'cf_sql_varchar'}
                    },
                    {dbtype: 'query'}
                );
            }

            rtnStruct.error = 0;
            rtnStruct.warnings = 0;
        } catch (any e) {
            rtnStruct.errorMessage = '#e.detail# - #e.message#';
            logError('fncGetRoomCategoryInfo: #rtnStruct.errorMessage#', e);
        }

        return rtnStruct;
    }

}
