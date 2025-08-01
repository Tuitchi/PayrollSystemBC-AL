codeunit 50104 "SSS Import"
{
    trigger OnRun()
    begin
    end;

    procedure ImportSSSTable()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileMgt: Codeunit "File Management";
        UploadResult: Boolean;
        FileName: Text;
        SheetName: Text;
        FileInStream: InStream;
        SSSContribution: Record "SSS Contribution";
    begin
        UploadResult := UploadIntoStream('Import SSS Table', '', 'Excel Files (*.xlsx)|*.xlsx|All Files (*.*)|*.*',
                                        FileName, FileInStream);

        if not UploadResult then
            exit;

        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(FileInStream, 'SSS Table');
        TempExcelBuffer.ReadSheet();

        if not ProcessExcelData(TempExcelBuffer, SSSContribution) then
            Error('Failed to import SSS Table. Please check the Excel format.');

        Message('SSS Table has been imported successfully.');
    end;

    local procedure ProcessExcelData(var TempExcelBuffer: Record "Excel Buffer" temporary; var SSSContribution: Record "SSS Contribution"): Boolean
    var
        RowNo: Integer;
        MaxRowCount: Integer;
        EffectiveDate: Date;
    begin
        // Find the maximum row number
        TempExcelBuffer.SetCurrentKey("Row No.");
        if TempExcelBuffer.FindLast() then
            MaxRowCount := TempExcelBuffer."Row No.";

        // Ask for the effective date
        if not GetEffectiveDate(EffectiveDate) then
            exit(false);

        // Start from row 2 (assuming row 1 is header)
        for RowNo := 2 to MaxRowCount do begin
            if not ImportRow(TempExcelBuffer, RowNo, EffectiveDate, SSSContribution) then
                exit(false);
        end;

        exit(true);
    end;

    local procedure ImportRow(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer;
                             EffectiveDate: Date; var SSSContribution: Record "SSS Contribution"): Boolean
    var
        LowRate: Decimal;
        HighRate: Decimal;
        MSC: Decimal;
        EmployeeShare: Decimal;
        EmployerShare: Decimal;
        ECC: Decimal;
        TotalContribution: Decimal;
    begin
        // Read columns - adjust column numbers based on your Excel format
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 1, LowRate) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 2, HighRate) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 3, MSC) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 4, EmployeeShare) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 5, EmployerShare) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 6, ECC) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 7, TotalContribution) then exit(false);

        // Create or update SSS Contribution record
        SSSContribution.Reset();
        SSSContribution.SetRange("LowRate", LowRate);
        SSSContribution.SetRange("HighRate", HighRate);
        SSSContribution.SetRange("EffectiveDate", EffectiveDate);

        if not SSSContribution.FindFirst() then begin
            SSSContribution.Init();
            SSSContribution."LowRate" := LowRate;
            SSSContribution."HighRate" := HighRate;
            SSSContribution."EffectiveDate" := EffectiveDate;
            SSSContribution.Insert();
        end;

        SSSContribution."MSC" := MSC;
        SSSContribution."EmployeeShare" := EmployeeShare;
        SSSContribution."EmployerShare" := EmployerShare;
        SSSContribution."ECC" := ECC;
        SSSContribution."TotalContribution" := TotalContribution;
        SSSContribution.Modify();

        exit(true);
    end;

    local procedure GetDecimalCellValue(var TempExcelBuffer: Record "Excel Buffer" temporary;
                                       RowNo: Integer; ColNo: Integer; var Value: Decimal): Boolean
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", RowNo);
        TempExcelBuffer.SetRange("Column No.", ColNo);

        if not TempExcelBuffer.FindFirst() then
            exit(false);

        // Excel buffer stores numbers as text, so we need to evaluate it
        Evaluate(Value, TempExcelBuffer."Cell Value as Text");
        exit(true);
    end;

    local procedure GetEffectiveDate(var EffectiveDate: Date): Boolean
    var
        DateText: Text;
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        DateText := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');

        if ConfirmManagement.GetResponseOrDefault('Enter effective date (DD/MM/YYYY): ' + DateText, true) then begin
            Evaluate(EffectiveDate, DateText);
            exit(true);
        end;

        exit(false);
    end;
}