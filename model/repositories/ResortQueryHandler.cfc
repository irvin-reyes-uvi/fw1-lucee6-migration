component implements="model.interfaces.IResortQueryHandler" {
    variables.datasourceName = "sandalsweb";
    
    public query function getAllResorts() {
        cfstoredproc(
            procedure = "obe_pack.get_all_resorts",
            datasource = variables.datasourceName
        ) {
            cfprocresult(name="getresorts", resultset=1);
        }
        return getresorts;
    }
}
