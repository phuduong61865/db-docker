#!/bin/bash

# Thông tin đăng nhập SQL Server
SQL_USER="SA"
SQL_PASSWORD="Abc@1234"

# Đường dẫn file backup và tên database
BACKUP_FILE="/var/opt/mssql/backup/AdventureWorksLT2022.bak"
DB_NAME="AdventureWorksLT2022"

# Logical names của data và log file (thay đổi nếu cần)
DATA_LOGICAL_NAME="AdventureWorksLT2022_Data"
LOG_LOGICAL_NAME="AdventureWorksLT2022_Log"

# Thư mục lưu data mặc định của SQL Server
DATA_DIR="/var/opt/mssql/data"

# Đường dẫn của sqlcmd
SQLCMD_PATH="/opt/mssql-tools18/bin/sqlcmd"

# Restore database
echo "Bắt đầu restore database $DB_NAME từ $BACKUP_FILE..."

$SQLCMD_PATH -C \
-S localhost -U $SQL_USER -P $SQL_PASSWORD \
-Q "
RESTORE DATABASE [$DB_NAME]
FROM DISK = N'$BACKUP_FILE'
WITH
MOVE '$DATA_LOGICAL_NAME' TO '$DATA_DIR/${DB_NAME}.mdf',
MOVE '$LOG_LOGICAL_NAME' TO '$DATA_DIR/${DB_NAME}_log.ldf',
REPLACE, RECOVERY;
"

# Kiểm tra kết quả
if [ $? -eq 0 ]; then
    echo "Restore thành công!"
else
    echo "Restore thất bại. Vui lòng kiểm tra thông báo lỗi."
    exit 1
fi