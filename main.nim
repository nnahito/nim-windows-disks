import winim

# ドライブの種類情報
const DRIVE_TYPE = [
    "不明なディスク", "無効なパス", "リムーバブル", "固定ドライブ",
    "リモートドライブ", "CD/DVDドライブ", "RAMディスク"
]

# 有効なドライブの情報を取得
let dwDrive = GetLogicalDrives()
for nDrive in 0..25:        # ドライブは26個まで（A～Z）
    if (dwDrive and (1 shl nDrive)) > 0:
        let driveIdentifier = nDrive + int("A"[0])

        # ドライブの種類を取得
        var lpRootPathName = char(driveIdentifier) & ":\\\\"        # バックスラッシュ2つで1つのバックスラッシュになる（エスケープが必要だから）
        let driveTypeId = GetDriveType(lpRootPathName)

        # ドライブの容量を取得
        var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes: ULARGE_INTEGER
        if GetDiskFreeSpaceEx(lpRootPathName, &lpFreeBytesAvailableToCaller, &lpTotalNumberOfBytes, &lpTotalNumberOfFreeBytes) == (WINBOOL)true:
            # ドライブ識別名（ドライブタイプ）: 利用可能容量 / 全体の容量
            echo char(driveIdentifier) & "ドライブ（" & DRIVE_TYPE[driveTypeId] & "）: " & $lpFreeBytesAvailableToCaller.QuadPart & " / " & $lpTotalNumberOfBytes.QuadPart
