pipeline {
    agent any

    environment {
        SQLCMD  = "C:\\Program Files\\Microsoft SQL Server\\Client SDK\\ODBC\\170\\Tools\\Binn\\sqlcmd.exe"
        DB_HOST = "localhost"
        DB_NAME = "JenkinsMigrationDB"
    }

    stages {

        stage('Checkout Repository') {
            steps {
                checkout scm
            }
        }

        stage('Check SQL Connectivity') {
            steps {
                bat """
                "%SQLCMD%" -S %DB_HOST% -d %DB_NAME% -E -Q "SELECT 'SQL CONNECTION OK'"
                """
            }
        }

        stage('Run Pending Migrations') {
            steps {
                bat """
powershell -NoProfile -Command "
Write-Host 'Reading applied migrations...';

\\$applied = & '%SQLCMD%' -S %DB_HOST% -d %DB_NAME% -E `
    -Q 'SET NOCOUNT ON; IF OBJECT_ID(''dbo.schema_migrations'') IS NOT NULL SELECT version FROM dbo.schema_migrations' |
    Select-Object -Skip 2 | ForEach-Object { \\$_ .Trim() };

Get-ChildItem db\\migrations\\V*.sql |
Sort-Object Name |
ForEach-Object {

    \\$ver = (\\$_ .Name -replace 'V(\\\\d+).*','\\\\$1');

    if (\\$applied -notcontains \\$ver) {
        Write-Host 'Applying migration:' \\$_ .Name;

        & '%SQLCMD%' -S %DB_HOST% -d %DB_NAME% -E -i \\$_ .FullName;
        if (\\$LASTEXITCODE -ne 0) {
            Write-Error 'Migration failed:' \\$_ .Name;
            exit 1;
        }

        & '%SQLCMD%' -S %DB_HOST% -d %DB_NAME% -E `
        -Q \\"INSERT INTO dbo.schema_migrations (version, description, script_name)
            VALUES (\\$ver, '\\$(\\$_ .BaseName)', '\\$(\\$_ .Name)')\\";
    }
    else {
        Write-Host 'Skipping already applied:' \\$_ .Name;
    }
}
"
                """
            }
        }
    }

    post {
        success {
            echo "Database migration completed successfully."
        }
        failure {
            echo "Database migration failed. Check logs."
        }
    }
}
