# Version  --  v0.0.1
#######################################################################################################
# Notes
# adding user and pass params uses sql auth, otherwise windows auth
#######################################################################################################
Import-Module SqlServer -ErrorAction Stop
$sqlParams = @{
    query = "SELECT GETDATE();";
    ServerInstance = 'scvlbisql01.ansirascvl.com';
    Database = 'SHOE';
    QueryTimeout = 0;
    Verbose = $true;
    ErrorAction = 'Stop';
}
Invoke-Sqlcmd @sqlParams
